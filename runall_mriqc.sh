# example code for MRIQC
# runs MRIQC on input subject
# usage: bash run_mriqc.sh sub
# example: bash run_mriqc.sh 102


docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/mriqc:/out \
-v /data/projects/srndna/scratch:/scratch \
-u $(id -u):$(id -g) \
-w /scratch \
poldracklab/mriqc:0.12.1 \
/data /out \
participant --n_cpus 12 --fft-spikes-detector --ica -w /scratch

# #--participant_label $sub
