#!/bin/sh

#check for all tools needed
check_tools(){
    which wget
    if [[ 0 -ne $? ]]
	then
	echo "wget not found ... please install it"
	exit 1
	fi

    which sha224sum
    if [[ 0 -ne $? ]]
	then
	echo "sha224sum not found ... please install GNU coreutils"
	exit 1
	fi

    which sha256sum
    if [[ 0 -ne $? ]]
	then
	echo "sha256sum not found ... please install GNU coreutils"
	exit 1
	fi

    which sha384sum
    if [[ 0 -ne $? ]]
	then
	echo "sha384sum not found ... please install GNU coreutils"
	exit 1
	fi

    which sha512sum
    if [[ 0 -ne $? ]]
	then
	echo "sha512sum not found ... please install GNU coreutils"
	exit 1
	fi

    which tar
    if [[ 0 -ne $? ]]
	then
	echo "tar not found ... please install it"
	exit 1
	fi

    which whois
    if [[ 0 -ne $? ]]
	then
	echo "whois not found ... please install it"
	exit 1
	fi

}

if [[ -z $1 ]]
then
    echo "no argument given ..."
    exit 255
fi

#timestamp format: year-month-day_hours-minutesOFFSET(unixtime)
timestamp=`date +%F_%H-%M%z_%s`
# create working directory
echo "creating directory structure ..."
mkdir -p ${timestamp}/rawdata
cd ${timestamp}/rawdata
#mirror site
#--input-file=file
echo "starting to mirror ..."
wget --append-output=${timestamp}.log --timestamping --random-wait --no-directories --keep-session-cookies \
--save-cookies ${timestamp}.cookies --no-check-certificate --recursive --level=1 --convert-links \
--backup-converted --page-requisites $1

#calculate checksums of downloaded files
echo "calculating checksums of source files ..."
for sourcefile in `ls`; do
    sha224sum $sourcefile >> checksums.sha224
    sha256sum $sourcefile >> checksums.sha256
    sha384sum $sourcefile >> checksums.sha384
    sha512sum $sourcefile >> checksums.sha512
done

#create archive of raw data
echo "archiving raw data ..."
cd ..
tar -cjf rawdata.tar.bz2 rawdata

echo "creating checksums of raw data archive ..."
sha224sum rawdata.tar.bz2 >> checksums.sha224
sha256sum rawdata.tar.bz2 >> checksums.sha256
sha384sum rawdata.tar.bz2 >> checksums.sha384
sha512sum rawdata.tar.bz2 >> checksums.sha512

exit 23
echo "removing loose files ..."
rm -rf rawdata

exit 23
#create imagedump
<insert khtml-foo here>

echo "calculating checksums for image dump ..."
sha224sum rawdata.tar.bz2 >> checksums.sha224
sha256sum rawdata.tar.bz2 >> checksums.sha256
sha384sum rawdata.tar.bz2 >> checksums.sha384
sha512sum rawdata.tar.bz2 >> checksums.sha512

#search for witness websites
#query google, bing, yahoo, chinasuchmaschine
#checksums over witnesslist
#whois lookup + checksum
