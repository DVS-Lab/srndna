# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=$1

docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/fmriprep:/out \
-v /data/projects/srndna/fs_license.txt:/opt/freesurfer/fs_license.txt \
-v /data/projects/srndna/scratch:/scratch \
-u $(id -u):$(id -g) \
-w /scratch \
poldracklab/fmriprep:1.1.4 \
/data /out \
participant --participant_label $sub \
--n_cpus 12 --use-aroma --fs-no-reconall --fs-license-file /opt/freesurfer/fs_license.txt -w /scratch
