# example code for MRIQC
# runs MRIQC on input subject
# usage: bash run_mriqc.sh sub
# example: bash run_mriqc.sh 102

#echo "sleeping for 30 minutes at `date`"
#sleep 30m 

docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/mriqc:/out \
-v /data/projects/srndna/scratch:/scratch \
-u $(id -u):$(id -g) \
-w /scratch \
poldracklab/mriqc:0.15.0 \
/data /out \
participant --fft-spikes-detector --ica -w /scratch

# #--participant_label $sub
