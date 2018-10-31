#!/usr/bin/env bash
umask 0000
sub=$1
xnat=$2
nruns=$3
bash run_heudiconv.sh $sub $xnat $nruns
bash run_pydeface.sh $sub
bash run_fmriprep.sh $sub
bash run_mriqc.sh $sub
