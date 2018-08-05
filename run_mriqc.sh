# example code for MRIQC
# runs MRIQC on input subject
# usage: bash run_mriqc.sh sub
# example: bash run_mriqc.sh 102

sub=$1

sudo docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/mriqc:/out \
poldracklab/mriqc:latest \
/data /out \
participant --participant_label $sub

# need to select a version and stick with it instead of poldracklab/mriqc:latest
