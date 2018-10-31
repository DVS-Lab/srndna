#!/bin/bash


for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do

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
  	bash $SCRIPTNAME $sub $run &
  	sleep 5s
  done

  for run in `seq 2`; do
  	#Manages the number of jobs and cores
  	SCRIPTNAME=L1_task-sharedreward_model-01.sh
  	NCORES=5
  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    		sleep 1s
  	done
  	bash $SCRIPTNAME $sub $run &
  	sleep 5s
  done
  
  for run in `seq 2`; do
  	#Manages the number of jobs and cores
  	SCRIPTNAME=L1_task-ultimatum_model-01.sh
  	NCORES=5
  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    		sleep 1s
  	done
  	bash $SCRIPTNAME $sub $run &
  	sleep 5s
  done


done
