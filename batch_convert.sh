#!/#!/usr/bin/env bash

sudo docker run --rm -it -v /data/projects/srndna:/data:ro \
-v /data/projects/srndna/bids:/output \
nipy/heudiconv:latest \
-d /data/dicoms/SMITH-AgingDM-{subject}/scans/*/DICOM/*.dcm -s 102 \
-f /data/heuristics.py -c dcm2niix -b -o /output
