#!/bin/bash


for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do

  set -- $subrun
  sub=$1
  run=$2
  echo "$sub $run"

	#Manages the number of jobs and cores
	SCRIPTNAME=gen_3col_files.sh
	NCORES=12
	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
  		sleep 1m
	done
	bash $SCRIPTNAME $sub $run
	sleep 5s

done
