# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=104

docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/fmriprep2:/out \
-v /data/projects/srndna/fs_license.txt:/opt/freesurfer/fs_license.txt \
-v /data/projects/srndna/scratch2:/scratch2 \
-u $(id -u):$(id -g) \
-w /scratch \
poldracklab/fmriprep:1.5.1rc2 \
/data /out \
participant --participant_label 104 \
--use-aroma \
--fs-license-file /opt/freesurfer/fs_license.txt --cifti-output --no-submm-recon \
-w /scratch2
