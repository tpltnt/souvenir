#!/bin/sh

# a small script to mirror webpages and add some tamper resistance
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

    which sha224sum
    if [[ 0 -ne $? ]]
    then
	echo "sha224sum not found ... please install GNU coreutils" >&2
	exit 1
    fi

    which sha256sum
    if [[ 0 -ne $? ]]
    then
	echo "sha256sum not found ... please install GNU coreutils" >&2
	exit 1
    fi

    which sha384sum
    if [[ 0 -ne $? ]]
    then
	echo "sha384sum not found ... please install GNU coreutils" >&2
	exit 1
    fi

    which sha512sum
    if [[ 0 -ne $? ]]
    then
	echo "sha512sum not found ... please install GNU coreutils" >&2
	exit 1
    fi

    which tar
    if [[ 0 -ne $? ]]
    then
	echo "tar not found ... please install it" >&2
	exit 1
    fi

    which whois
    if [[ 0 -ne $? ]]
    then
	echo "whois not found ... please install it" >&2
	exit 1
    fi

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
wget --append-output=${timestamp}.log --timestamping --random-wait --no-directories --keep-session-cookies \
--save-cookies ${timestamp}.cookies --no-check-certificate --recursive --level=1 --convert-links \
--backup-converted --page-requisites $1

#calculate checksums of downloaded files
echo "calculating checksums of source files ..." >&1
for sourcefile in `ls`; do
    sha224sum $sourcefile >> checksums.sha224
    sha256sum $sourcefile >> checksums.sha256
    sha384sum $sourcefile >> checksums.sha384
    sha512sum $sourcefile >> checksums.sha512
done

#create archive of raw data
echo "archiving raw data ..." >&1
cd ..
tar -cjf rawdata.tar.bz2 rawdata

echo "creating checksums of raw data archive ..." >&1
sha224sum rawdata.tar.bz2 >> checksums.sha224
sha256sum rawdata.tar.bz2 >> checksums.sha256
sha384sum rawdata.tar.bz2 >> checksums.sha384
sha512sum rawdata.tar.bz2 >> checksums.sha512


echo "removing loose files ..." >&1
rm -rf rawdata

exit 23
#create imagedump
xvfb-run --server-args="-screen 0, 640x480x24" python webkit2png-simple.py

exit 23
echo "calculating checksums for image dump ..." >&1
sha224sum rawdata.tar.bz2 >> checksums.sha224
sha256sum rawdata.tar.bz2 >> checksums.sha256
sha384sum rawdata.tar.bz2 >> checksums.sha384
sha512sum rawdata.tar.bz2 >> checksums.sha512

#search for witness websites
#query google, bing, yahoo, chinasuchmaschine
#checksums over witnesslist
#whois lookup + checksum
