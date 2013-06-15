#! /bin/bash

# Wrapper for speedtest script. Outputs to logfile from args.

numopts=0

# check commandline for logfile name
while getopts ":f:" opt; do
	case $opt in
		f)
			file=$OPTARG
			#echo "Logfile: $file"
			let "numopts+=1"
			;;
		\?)
			echo "Invalid option: $OPTARG"
			exit 1
			;;
		:)
			echo "Must supply argument (-f <filename>)"
			exit 1
			;;
	esac
done

if [ $numopts -ne 1 ]
then
	echo "Must supply argument (-f <filename>)"
	exit 1
fi


# get date and time
val_dtetime=`date "+%Y%m%d_%H%M%S"`

#echo "DATETIME=$val_dtetime"


# run speedtest
val_spdtest=`~/scripts/speedtest`

#echo "$val_spdtest"

# grab values
val_ping=`echo "$val_spdtest" | grep 'Hosted' | awk -F: '{print $2}' | awk '{print $1}'`
val_dl=`echo "$val_spdtest" | grep 'Download' | awk -F: '{print $2}' | awk '{print $1}'`
val_ul=`echo "$val_spdtest" | grep 'Upload' | awk -F: '{print $2}' | awk '{print $1}'`

# output to logfile
printf "$val_dtetime | %7.3f | %6.2f | %6.2f\n" $val_ping $val_dl $val_ul >> $file


exit

