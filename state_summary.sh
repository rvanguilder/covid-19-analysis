#!/bin/bash

while getopts s: option
do
	case "${option}"
	in
		s) state=${OPTARG};;
	esac
done

if [ -z "$state" ]
then
	state=Colorado
fi

#state=Minnesota

echo "State=$state" && cat ./covid-19-data/us-states.csv | awk -F"," -v state="$state" '$2==state{a[$1];c[$1]+=$4;d[$1]+=$5}END{for (i in a)print i,c[i],d[i]}' | sort | column -t -s' '

