# example code for FMRIPREP
# runs FMRIPREP on all subjects in BIDS_out_all

docker run -it --rm \
-v /Users/tug87422/BIDS_testing_TUBRIC/PARAM_TEST/BIDS_out_all:/data:ro \
-v /Users/tug87422/BIDS_testing_TUBRIC/PARAM_TEST/FMRIPREP_new:/out \
-v /Users/tug87422/Desktop/license.txt:/opt/freesurfer/license.txt \
poldracklab/fmriprep:latest \
/data /out \
participant --ignore slicetiming --use-aroma --fs-no-reconall --fs-license-file /opt/freesurfer/license.txt
