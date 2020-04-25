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
 - ./summary.sh
 - ./summary.sh -r 15 -s 20 -c 6 -o d

## optional arguments
 - -r => show last 15 days
 - -s => show top 20 states (mod'd up to fill all columns on last row)
 - -c => show 6 columns, defaults to how many columns can fit screen
 - -o => order by (c) cases, (d) deaths

# TODO
 - Add percentage and absolute change values for each day
 - This was written against the mawk verions of awk.  Need to test against gawk.
 - Make commands more readable.  Consider an awk file and more bash scripts.
 - Parameterize commands to allow desired output columns
 - Add percentage for percent change to total number
 - Allow sort absolute and percent changed
 - what is the version of linux, awk, etc. for Chromebook, container, WSL, etc.

