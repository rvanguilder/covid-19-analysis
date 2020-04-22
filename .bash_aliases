# Some basic bash aliases to provide different views into the Covid-19 data.  c19_for_state requires a $state session variable.

alias c19_us="cat ~/projects/covid-19-data/us-states.csv | awk -F',' '{a[\$1];c[\$1]+=\$4;d[\$1]+=\$5}END{for (i in a)print i,c[i],d[i]}' | grep '2020-[0-9]\\{2\\}-[0-9]\\{2\\}' | sort | column -t -s' '"
alias c19_by_state="cat ~/projects/covid-19-data/us-states.csv  | grep \$(cat ~/projects/covid-19-data/us-states.csv | tail -n 1 | cut -d',' -f1) | awk -F\",\" '{print \$1 \",\" \$2 \",\" \$4 \",\" \$5}' | sort -t',' -k 3 -n | column -t -s',' "
alias c19_for_state="echo 'State=$state' && cat ~/projects/covid-19-data/us-states.csv | awk -F\",\" -v state=\"$state\" '\$2==state{a[\$1];c[\$1]+=\$4;d[\$1]+=\$5}END{for (i in a)print i,c[i],d[i]}' | sort | column -t -s' '"
