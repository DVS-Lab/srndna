#!/bin/bash


for subrun in "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5"; do

	set -- $subrun
	sub=$1
	nruns=$2
	bash L2_task-all_model-01.sh $sub $nruns &
	sleep 5

done
