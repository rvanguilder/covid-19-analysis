# covid-19-analysis

This is a repo that holds various bash commands and scripts that analyze data from the **New York Times Covid-19-Data set**. These are *amaturish* commands and scripts that I developed to increase my skills at using Linux/GNU tools to analyze datasets. The output uses **less**.

This repo includes a git submodule to the [New York Times covid-19-data set](https://github.com/nytimes/covid-19-data). See notes below to work with the submodule.

# Usage
## To use this repo - first time
git clone https://github.com/rvanguilder/covid-19-analysis.git

git submodule update --init --recursive

./summary.sh

## To use this repo - after a nytimes/covid-19-data update
git submodule update --remote

# Examples
## Summary View
 - ./summary.sh
 - ./summary.sh -r 7
 - ./summary.sh -r 15 -s 20 -c 6 -o d

### optional arguments
 - -r => (records) show last 15 days; defaults to 21
 - -s => (states) show top 20 states (mod'd up to fill all columns on last row)
 - -c => show 6 columns, defaults to how many columns can fit screen
 - -o => order by (c) cases, (d) deaths

## Summary for specific state
 - ./state_summary.sh -s Colorado

## Summary by counties, for a specific state
 - ./counties.sh -s "Colorado"
 - ./counters.sh -r 7 -s "Minnesota" => show for 7 days

## US Totals - Smmary
 - ./us_totals_only.sh 
 - ./us_totals_only.sh -s d
 - ./us_totals_only.sh -s a

# TODO
 - Add percentage and absolute change values for each day
 - Parameterize commands to allow desired output columns
 - Add percentage for percent change to total number
 - Allow sort absolute and percent changed
 - what is the version of linux, awk, etc. for Chromebook, container, WSL, etc.

