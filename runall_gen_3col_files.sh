#!/bin/bash


#for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do
#for subrun in "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5"; do
#for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5" "122 5" "124 5" "125 5" "126 5" "127 5" "128 5" "129 5" "130 5" "131 5" "132 5" "133 5" "134 4"; do
#for subrun in "135 5" "136 2" "137 5"; do	
#for subrun in "138 4"; do	

# unsure about sub-143 right now
for subrun in "138 4" "140 5" "141 4" "142 5" "144 3" "145 2" "147 5" "149 4" "150 5" "151 5"; do		
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
