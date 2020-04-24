# covid-19-analysis

This is a repo that holds various bash commands that analyze data from the New York Times Covid-19-Data set. These are amaturish commands that I developed to increase my skills at using Linux/GNU tools to analyze datasets.

Example usage:
	./summary.sh -r 15 -s 20 -c 6

-r => show last 15 days
-s => show top 20 states (mod'd up to fill all columns on last row)
-r => show 6 columns

TODO:
 - Add percentage and absolute change values for each day
 - This was written against the mawk verions of awk.  Need to test against gawk.
 - Make commands more readable.  Consider an awk file and more bash scripts.
 - Account for screen height and width
 - Parameterize commands to allow desired output columns
 - Add percentage for percent change to total number
 - All sort by deaths, and percent changed

