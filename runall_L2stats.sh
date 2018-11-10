#!/bin/bash


for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do

	set -- $subrun
	sub=$1
	nruns=$2
	bash L2_task-all_model-01.sh $sub $nruns &
	sleep 5

done
