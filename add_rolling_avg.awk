{
	#print $0
	change_in_cases[NR] = $3
	change_in_deaths[NR] = $4
	printf $1 "\t" $2 "\t" $3 "\t" $4
	
	counter=0
	cases_sum=0
	deaths_sum=0

	#print days

	rolling_avg_period = days
	if(NR > rolling_avg_period) {
		for(i=0; i<rolling_avg_period; i++) {
			cases_sum += change_in_cases[NR-i]
			deaths_sum += change_in_deaths[NR-i]					
		}
		cases_avg = cases_sum / rolling_avg_period
		printf "\t" int(cases_avg)
		deaths_avg = deaths_sum / rolling_avg_period
		printf "\t" int(deaths_avg)
	}
	else {
		printf "\t\t"
	}

	printf "\n"
}

