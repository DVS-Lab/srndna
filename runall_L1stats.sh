#!/bin/bash

for ppi in "ffa" "vs" "amyg"; do
	
	for subrun in "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5"; do
	
	  set -- $subrun
	  sub=$1
	  nruns=$2
	  #echo "$sub $nruns"
	
	  for run in `seq $nruns`; do
	  	#Manages the number of jobs and cores
	  	SCRIPTNAME=L1_task-trust_model-01.sh
	  	NCORES=16
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 1s
	  	done
	  	bash $SCRIPTNAME $sub $run $ppi &
	  	sleep 5s
	  done
	
	  for run in `seq 2`; do
	  	#Manages the number of jobs and cores
	  	SCRIPTNAME=L1_task-sharedreward_model-01.sh
	  	NCORES=5
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 1s
	  	done
	  	bash $SCRIPTNAME $sub $run $ppi &
	  	sleep 5s
	  done
	
	  for run in `seq 2`; do
	  	#Manages the number of jobs and cores
	  	SCRIPTNAME=L1_task-ultimatum_model-01.sh
	  	NCORES=5
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 1s
	  	done
	  	bash $SCRIPTNAME $sub $run $ppi &
	  	sleep 5s
	  done
	
	
	done
done
