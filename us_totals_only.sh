#!/bin/bash

while getopts r:s: option
do
	case "${option}"
	in
		r) recordCount=${OPTARG};;
		s) sort_by=${OPTARG};;
	esac
done

if [ -z "$recordCount" ]
then
	recordCount=$(tput lines)
	recordCount=$(($recordCount - 3))
	#echo "Hit recordCount " $recordCount
fi

head_or_tail="head "
sortArg="-r"
if [ -z "$sort_by" ]
then
	sort_by="d"
fi

if [ "$sort_by" != "d" ]
then
	sortArg=""
	head_or_tail="tail "
fi

cat ./covid-19-data/us-states.csv | sed '1d' | awk -F',' '{a[$1];c[$1]+=$4;d[$1]+=$5}END{for (i in a)print i,c[i],d[i]}' | sort $sortArg | $head_or_tail -n $recordCount | (echo "Date Cases Deaths" && cat) | column -t -s' '| less


