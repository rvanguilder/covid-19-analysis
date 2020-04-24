
BEGIN{
	Old_IFS=$IFS
	OFS="\t"
}
{
	if(NR==1) {
		change_in_cases=0
		change_in_deaths=0
		print $0
	}
	else if(NR==2) {
		change_in_cases = $1 - prior_cases
		change_in_deaths = $2 - prior_deaths
		print $1 "\t" $2 "\t" change_in_cases "\t" change_in_deaths
		
	} else {
		change_in_cases = $1 - prior_cases
		change_in_deaths = $2 - prior_deaths
		print $1 "\t" $2 "\t" change_in_cases "\t" change_in_deaths
	} 

	prior_cases=$1; 
	prior_deaths=$2;
}
END{
	IFS=$Old_IFS
}

