#!/bin/bash

tempDir=$(mktemp -d "${TMPDIR:-/tmp/}$(basename $0).XXXXXXXXXX")
tempDir=$tempDir"/"

tempDir="./tmp/"

#echo "Temp directory create at "$tempDir

while getopts r:s:c:o:a: option
do
	case "${option}"
	in
		r) recordCount=${OPTARG};;
		s) stateCount=${OPTARG};;
		c) columns=${OPTARG};;
		o) order_by=${OPTARG};;
		a) rolling_avg=${OPTARG};;
	esac
done

if [ -z "$recordCount" ]
then
	recordCount=21
	#echo "Hit recordCount"
fi

if [ -z "$stateCount" ]
then
	stateCount=53
	#echo "Hit recordCount"
fi

rolling_avg_days=7
including_rolling_avg=1
if [ -z "$rolling_avg" ];
then
	#echo "Hit rolling_avg"
	rolling_avg_days=7;
elif [ $rolling_avg == 0 ];
then
	including_rolling_avg=0;
else
	rolling_avg_days=$rolling_avg;
fi;

#echo $including_rolling_avg
#echo $rolling_avg_days

space_per_column=32
if [ $including_rolling_avg == 1 ];
then
	space_per_column=48;
fi;

if [ -z "$columns" ]
then
	cols=$(tput cols)
	# 16 for Date + 32 for each columns
	spaceForCols=$(($cols - 16))
	columns=$(($spaceForCols / $space_per_column))
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
#echo $stateCount

totalSize=$(($stateCount + 1))

mod=$(($totalSize % $columns))

#echo $mod

totalSize=$(($totalSize + $columns - mod))

#echo $totalSize

stateCount=$(($totalSize - 1))

cat ./covid-19-data/us-states.csv | awk -F"," 'BEGIN{OFS="\t"}{a[$1];c[$1]+=$4;d[$1]+=$5}END{for (i in a)print i,c[i],d[i]}' | grep "2020-[0-9]\{2\}-[0-9]\{2\}" | sort > "$tempDir"us 

cut -d$'\t' -f1 "$tempDir"us | tail -n $recordCount | sed '1s/^/Date\t\n/' > "$tempDir"dates 

cut -d$'\t' -f2,3 "$tempDir"us | awk -f add_single_delta.awk > "$tempDir"0-1 

united_states_label="United States\t\t";
if [ $including_rolling_avg == 1 ];
then
	cat "$tempDir"0-1 | awk -f add_rolling_avg.awk days=$rolling_avg_days | tail -n $recordCount > "$tempDir"0;
	united_states_label=$united_states_label"\t\t"
else
	cat "$tempDir"0-1 | tail -n $recordCount > "$tempDir"0;
fi;

sed -i '1s/^/'"$united_states_label"'\n/' "$tempDir"0

cat ./covid-19-data/us-states.csv | grep $(cat ./covid-19-data/us-states.csv | tail -n 1 | cut -d',' -f1) | awk -F"," '{print $1 "," $2 "," $4 "," $5}' | sort -t"," -k $order_by_field -n -r | head -n $stateCount | cut -d',' -f2 | { 

	j=0;

	while read i; 
		do let j=j+1; 
		
		cat ./covid-19-data/us-states.csv | awk -F"," -v state="$i" 'BEGIN{OFS="\t"}$2==state{a[$1];c[$1]+=$4;d[$1]+=$5}END{for (i in a)print i, c[i],d[i]}' | sort | cut -d$'\t' -f2,3 | awk -f add_single_delta.awk > "$tempDir$j-1"; 

		if [ $including_rolling_avg == 1 ];
		then
			cat "$tempDir$j-1" | awk -f add_rolling_avg.awk days=$rolling_avg_days > "$tempDir$j-2"
		else
			cp "$tempDir$j-1" "$tempDir$j-2";
		fi;

		cat "$tempDir$j-2" | tail -n $recordCount > "$tempDir$j"

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

		if [ $including_rolling_avg == 1 ];
		then
			#print "histing this"
			state_label="$state_label\t\t";
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

		#echo $params1;
		paste $params1;

		printf "\n\n"
	done

} | less 

#rm -rf "$tempDir"

