#!/usr/bin/env bash

sub=$1
nruns=$2
bash run_heudiconv.sh $sub $nruns
bash run_pydeface.sh $sub
bash run_fmriprep.sh $sub
bash run_mriqc.sh $sub
