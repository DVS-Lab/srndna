#!/usr/bin/env bash

# example code for heudiconv
# runs heudiconv on input subject
# usage: bash run_heudiconv.sh sub xnat
# example: bash run_heudiconv.sh 102 1

sub=$1
xnat=$2

if [ $xnat == 1 ]; then
  sudo docker run --rm -it -v /data/projects/srndna:/data:ro \
  -v /data/projects/srndna/bids:/output \
  nipy/heudiconv:latest \
  -d /data/dicoms/SMITH-AgingDM-{subject}/scans/*/DICOM/*.dcm -s $sub \
  -f /data/heuristics.py -c dcm2niix -b -o /output
else
  sudo docker run --rm -it -v /data/projects/srndna:/data:ro \
  -v /data/projects/srndna/bids:/output \
  nipy/heudiconv:latest \
  -d /data/dicoms/SMITH-AgingDM-{subject}/*/*/*.IMA -s $sub \
  -f /data/heuristics.py -c dcm2niix -b -o /output
fi

# need to select a version and stick with it instead of nipy/heudiconv:latest
# need to check anonymization (e.g., dcm2niix -ba -y)???
