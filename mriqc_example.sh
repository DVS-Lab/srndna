# example code for MRIQC
# runs MRIQC on all subjects in BIDS_out_all

sudo docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/mriqc:/out \
poldracklab/mriqc:latest \
/data /out \
participant
