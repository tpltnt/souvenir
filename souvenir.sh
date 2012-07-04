#!/usr/bin/env zsh

# a small script to mirror webpages and add some tamper resistance
# copyright 2012 by tpltnt <tpltnt.github@dropcut.net>
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO. 

#check for all tools needed
check_tools(){
    which wget
    if [[ 0 -ne $? ]]
    then
	echo "wget not found ... please install it" >&2
	exit 1
    fi

    which gpg 
    if [[ 0 -ne $? ]]
    then
	echo "gpg not found ... please install the GnuPrivacyGuard" >&2
	exit 1
    fi

    which tar
    if [[ 0 -ne $? ]]
    then
	echo "tar not found ... please install it" >&2
	exit 1
    fi

    which md5deep
    if [[ 0 -ne $? ]]
    then
        echo "md5deep not found ... please install it" >&2
        exit 1
    fi

    which whois
    if [[ 0 -ne $? ]]
    then
	echo "whois not found ... please install it" >&2
	exit 1
    fi

}

# create detached signature for a file
create_detached_signature(){
    filetobesigned=$1
    signingkeyid=$2
    keyring=$3

    gpg --no-default-keyring --keyring $keyring --default-key $signingkeyid \
    --output $filetobesigned.sig --detach-sig $filetobesigned
}

# create checksums
create_checksums(){
    md5deep -lr $1 >> checksums.md5
    sha1deep -lr $1 >> checksums.sha1
    sha256deep -lr $1 >> checksums.sha256
    tigerdeep -lr $1 >> checksums.tiger
    whirlpooldeep -lr $1 >> checksums.whirlpool
}

# recursivly chop stuff
chop_domain(){
    domain=$1
    if [[ -n `whois $domain | grep 'Status: invalid'` ]]
    then
        # chop off first part & try again
        chomp=`echo $domain|awk -F. '{print $1}'`
        domain=`echo $domain|sed "s/$chomp.//"`
        chop_domain $domain
    else
        echo $domain
    fi
}

# get domain
get_domain(){
    domain=`echo $1|awk -F/ '{print $3}'`
    chop_domain $domain
}

if [[ -z $1 ]]
then
    echo "no argument given ..." >&2
    exit 255
fi

#timestamp format: year-month-day_hours-minutesOFFSET(unixtime)
timestamp=`date +%F_%H-%M%z_%s`
# create working directory
echo "creating directory structure ..." >&1
mkdir -p ${timestamp}/rawdata
cd ${timestamp}/rawdata
#mirror site
#--input-file=file
echo "starting to mirror ..." >&1
wget --append-output=${timestamp}.log --timestamping --random-wait \
--no-directories --keep-session-cookies \
--save-cookies ${timestamp}.cookies --no-check-certificate \
--local-encoding=utf-8 \
--recursive --level=1 --convert-links \
--backup-converted --page-requisites $1

#calculate checksums of downloaded files
echo "calculating checksums of source files ..." >&1
for sourcefile in `ls`; do
    create_checksums $sourcefile
done
# create signatures for hashes
echo "creating signatures of hash files ..." >&1
keyid="48034655"
keyring="../../playground/test.keyring"
for filename in `ls | grep checksums`; do
    create_detached_signature $filename $keyid $keyring
done

#create archive of raw data
echo "archiving raw data ..." >&1
cd ..
tar -cjf rawdata.tar.bz2 rawdata

echo "creating checksums of raw data archive ..." >&1
create_checksums rawdata.tar.bz2

echo "removing loose files ..." >&1
rm -rf rawdata

#create imagedump
python screenshooter $1
echo "calculating checksums for image dump ..." >&1
create_checksums screenshot.png

# do whois lookup
echo "retriving whois data ..." >&1
domain=`get_domain $1`
whois $domain >> whoisdata.txt
if [[ -n `grep "Error: 55000000002 \
Connection refused; access control \
limit exceeded" whoisdata.txt` ]]
then
    echo "whois lookup blocked, please wait and try later" >&2
    exit 1
fi

create_checksums whoisdata.txt

# save URL
echo $1 >> url.txt
create_checksums url.txt

# setup up crypto stuff
keyid="48034655"
keyring="../playground/test.keyring"
for filename in `ls | grep checksums`; do
    create_detached_signature $filename $keyid $keyring
done

# get out & pack everything up
cd ..
tar -cjf $timestamp.tar.bz2 $timestamp
create_checksums $timestamp.tar.bz2
keyid="48034655"
keyring="./playground/test.keyring"
create_detached_signature $timestamp.tar.bz2 $keyid $keyring