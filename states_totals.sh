#!/bin/bash

while getopts o: option
do
	case "${option}"
	in
		o) order_by=${OPTARG};;
	esac
done

order_by_field=3
if [ -z "$order_by" ]
then
	order_by="c"
fi

if [ "$order_by" == "d" ]
then
	order_by_field=4
	echo "Ordering by deaths"
fi


cat ./covid-19-data/us-states.csv  | grep $(cat ./covid-19-data/us-states.csv | tail -n 1 | cut -d',' -f1) | awk -F"," '{print $1 "," $2 "," $4 "," $5}' | sort -t',' -k $order_by_field -n -r | column -t -s',' | less -N

