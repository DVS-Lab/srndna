#!/usr/bin/env bash

umask 0000
sub=$1
nruns=$2

for i in 1 2; do
  bash L1_task-ultimatum_model-01.sh $sub $i &
done
for i in 1 2; do
  bash L1_task-sharedreward_model-01.sh $sub $i &
done
for i in `seq $nruns`; do
  bash L1_task-trust_model-01.sh $sub $i &
done
