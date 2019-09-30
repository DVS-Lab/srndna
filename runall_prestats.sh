#!/bin/bash

#for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do
#for subrun in "111 5" "115 5" "116 5" "117 5" "118 5" "120 5" "121 5"; do
#for subrun in "122 5" "124 5" "125 5" "126 5"; do
#for subrun in "135 5" "136 2" "137 5"; do
# leaving out "143 3" for now

#for subrun in "138 4" "140 5" "141 4" "142 5" "144 3" "145 2" "147 5" "149 4" "150 5" "151 5"; do
for subrun in "150 5"; do
  set -- $subrun
  sub=$1
  nruns=$2

  bash run_heudiconv.sh $sub $nruns
  bash run_pydeface.sh $sub
  #bash run_fmriprep.sh $sub
  #bash run_mriqc.sh $sub

done
