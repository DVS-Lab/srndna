#!/bin/bash

umask 0000
for subrun in "104 5" "105 5" "106 3" "107 5" "108 5" "109 2" "110 2" "112 5" "113 5"; do

  set -- $subrun
  sub=$1
  nruns=$2

  bash run_heudiconv.sh $sub 1 $nruns
  bash run_pydeface.sh $sub
  # bash run_fmriprep.sh $sub
  # bash run_mriqc.sh $sub

done
