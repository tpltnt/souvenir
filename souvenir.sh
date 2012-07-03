#!/bin/bash

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

# create checksums
create_checksums(){
    md5deep -lr $1 >> checksums.md5
    sha1deep -lr $1 >> checksums.sha1
    sha256deep -lr $1 >> checksums.sha256
    tigerdeep -lr $1 >> checksums.tiger
    whirlpooldeep -lr $1 >> checksums.whirlpool
}

# get whois information
get_whois(){
    domain=`echo $1|awk -F/ '{print $3}'`
    echo $domain
    # chop of first part
    if [[ -n `whois $domain | grep 'Status: invalid'` ]]
    then
	echo "have to chop"
    fi
}

if [[ -z $1 ]]
then
    echo "no argument given ..." >&2
    exit 255
fi

get_whois $1
exit 42
#timestamp format: year-month-day_hours-minutesOFFSET(unixtime)
timestamp=`date +%F_%H-%M%z_%s`
# create working directory
echo "creating directory structure ..." >&1
mkdir -p ${timestamp}/rawdata
cd ${timestamp}/rawdata
#mirror site
#--input-file=file
echo "starting to mirror ..." >&1
wget --append-output=${timestamp}.log --timestamping --random-wait --no-directories --keep-session-cookies \
--save-cookies ${timestamp}.cookies --no-check-certificate --recursive --level=1 --convert-links \
--backup-converted --page-requisites $1

#calculate checksums of downloaded files
echo "calculating checksums of source files ..." >&1
for sourcefile in `ls`; do
    create_checksums $sourcefile
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

exit 23
# do whois lookup
echo "retriving whois data ..." >&1
whois $1

#search for witness websites
#query google, bing, yahoo, chinasuchmaschine
#checksums over witnesslist
#whois lookup + checksum
