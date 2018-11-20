#!/bin/bash

for ppi in "ffa" "vs" "amyg"; do
	
	for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5"; do
	
		set -- $subrun
		sub=$1
		nruns=$2
		bash L2_task-all_model-01_type-ppi.sh $sub $nruns $ppi &
		sleep 5

	done
done