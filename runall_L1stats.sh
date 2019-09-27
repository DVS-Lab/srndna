#!/bin/bash


for sm in 6; do
	for ppi in 0 VS Amyg FFA; do #VS Amyg FFA; putting 0 first will indicate "activation"

		#for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5" "122 5" "124 5" "125 5" "126 5" "127 5" "128 5" "129 5" "130 5" "131 5" "132 5" "133 5" "134 4" "135 5" "136 2" "137 5" "138 4"; do
		for subrun in "140 5" "141 4" "142 5" "144 2" "145 2" "147 5" "149 4" "151 5"; do
		  set -- $subrun
		  sub=$1
		  nruns=$2
		  #echo "$sub $nruns"
		
		  for run in `seq $nruns`; do
		  	#Manages the number of jobs and cores
		  	SCRIPTNAME=L1_task-trust_model-01.sh
		  	NCORES=14
		  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		    		sleep 1s
		  	done
		  	bash $SCRIPTNAME $sub $run $ppi $sm &
		  	sleep 1s
		  done
		
		  for run in `seq 2`; do
		  	#Manages the number of jobs and cores
		  	SCRIPTNAME=L1_task-sharedreward_model-01.sh
		  	NCORES=5
		  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		    		sleep 1s
		  	done
		  	bash $SCRIPTNAME $sub $run $ppi $sm &
		  	sleep 1s
		  done
		
		  for run in `seq 2`; do
		  	#Manages the number of jobs and cores
		  	SCRIPTNAME=L1_task-ultimatum_model-01.sh
		  	NCORES=5
		  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		    		sleep 1s
		  	done
		  	bash $SCRIPTNAME $sub $run $ppi $sm &
		  	sleep 1s
		  done
		
		#sleep 5m
		done
	done
done
