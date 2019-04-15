#!/bin/bash

for sm in 6; do
		
	for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5" "122 5" "124 5" "125 5" "126 5" "127 5" "128 5" "129 5" "130 5" "131 5" "132 5" "133 5" "134 4"; do
		set -- $subrun
		sub=$1
		nruns=$2
		bash L2_task-all_model-01_type-act.sh $sub $nruns $sm &
		sleep 10s

	done

done

sleep 5m

for sm in 6; do
	for ppi in "VS" "FFA" "Amyg"; do
		for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5" "122 5" "124 5" "125 5" "126 5" "127 5" "128 5" "129 5" "130 5" "131 5" "132 5" "133 5" "134 4"; do
			set -- $subrun
			sub=$1
			nruns=$2
			bash L2_task-all_model-01_type-ppi.sh $sub $nruns $ppi $sm &
			sleep 10s
	
		done
	done
done

sleep 5m

for ppi in "dmn" "ecn"; do
	for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5" "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5" "122 5" "124 5" "125 5" "126 5" "127 5" "128 5" "129 5" "130 5" "131 5" "132 5" "133 5" "134 4"; do
	
		set -- $subrun
		sub=$1
		nruns=$2
		bash L2_task-all_model-01_type-nppi.sh $sub $nruns $ppi &
		sleep 10s

	done
done
