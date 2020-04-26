#!/bin/bash

tempDir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXX")
tempDir=$tempDir"/"
#tempDir="./tmp/"

echo "Temp directory create at "$tempDir

while getopts r:s:c:o: option
do
	case "${option}"
	in
		r) recordCount=${OPTARG};;
		s) state=${OPTARG};;
		d) countyCount=${OPTARG};;
		c) columns=${OPTARG};;
		o) order_by=${OPTARG};;
	esac
done

if [ -z "$state" ]
then
	state="Colorado"
fi

echo $state

if [ -z "$recordCount" ]
then
	recordCount=21
	#echo "Hit recordCount"
fi

if [ -z "$countyCount" ]
then
	countyCount=53
	#echo "Hit recordCount"
fi

if [ -z "$columns" ]
then
	cols=$(tput cols)
	# 16 for Date + 32 for each columns
	spaceForCols=$(($cols - 16))
	columns=$(($spaceForCols / 32))
	#echo $columns
fi

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

#echo $recordCount
#echo $countyCount

totalSize=$(($countyCount + 1))

mod=$(($totalSize % $columns))

#echo $mod

totalSize=$(($totalSize + $columns - mod))

#echo $totalSize

countyCount=$(($totalSize - 1))

cat ./covid-19-data/us-counties.csv | awk -F',' -v state="$state" 'BEGIN{OFS=","}$3==state{print $0}' | awk -F"," 'BEGIN{OFS="\t"}{a[$1];c[$1]+=$5;d[$1]+=$6}END{for (i in a)print i,c[i],d[i]}' | grep "2020-[0-9]\{2\}-[0-9]\{2\}" | sort | tail -n $(($recordCount + 1)) > "$tempDir"state 

cut -d$'\t' -f1 "$tempDir"state | tail -n $recordCount | sed '1s/^/Date\t\n/' > "$tempDir"dates 

cut -d$'\t' -f2,3 "$tempDir"state | sort -k 2 -n | awk -f add_single_delta.awk | tail -n $recordCount | sed '1s/^/'"$state"'\t\t\n/' > "$tempDir"0 

cat ./covid-19-data/us-counties.csv | awk -F',' -v state="$state" '$3==state{print $0}' | grep $(cat ./covid-19-data/us-counties.csv | tail -n 1 | cut -d',' -f1) | awk -F"," '{print $1 "," $2 "," $5 "," $6}' | sort -t"," -k $order_by_field -n -r | head -n $countyCount | cut -d',' -f2 | { 

	j=0;

	while read i; 
		do let j=j+1; 
	
		#print "$state - $i"	
		cat ./covid-19-data/us-counties.csv | awk -F"," -v state="$state" -v county="$i" 'BEGIN{OFS="\t"} $2==county && $3==state {a[$1];c[$1]+=$5;d[$1]+=$6}END{for (i in a)print i, c[i],d[i]}' | sort | cut -d$'\t' -f2,3 | awk -f add_single_delta.awk | tail -n $recordCount > "$tempDir"$j; 

		state_label="($j) $i"

		state_length=$(expr length "$state_label"); 

		#echo "$state_label $state_length"

		if [ "$state_length" -le 15 ];
		then
			state_label="$state_label\t\t"; 
		elif [ "$state_length" -le 19 ];
		then
			state_label="$state_label\t"; 
		fi;

		sed -i '1s/^/'"$state_label"'\n/' "$tempDir"$j; 
		
	done; 

	#build paste arguments
	rows=$(($totalSize / columns));
	
	counter=0;

	for (( k=0; k<$rows; k++))
	do
		params1=""$tempDir"dates ";

		for (( m=0; m<$columns; m++ ))
		do
			currentFile="$tempDir$counter"
			if [ ! -f "$currentFile" ]; then
				#echo "Breaking out! $currentFile doesn't exist!"
				break;
			fi
			params1="$params1$currentFile "			
			counter=$(($counter + 1))
		done

		paste $params1;

		printf "\n\n"
	done

} | less 

rm -rf "$tempDir"

