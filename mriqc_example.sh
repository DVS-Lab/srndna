# example code for MRIQC
# runs MRIQC on all subjects in BIDS_out_all

docker run -it --rm \
-v /Users/tug87422/BIDS_testing_TUBRIC/PARAM_TEST/BIDS_out_all:/data:ro \
-v /Users/tug87422/BIDS_testing_TUBRIC/PARAM_TEST/MRIQC_new:/out \
poldracklab/mriqc:latest \
/data /out \
participant
