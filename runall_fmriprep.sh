# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

echo "sleeping for 20 minutes..."
sleep 20m

docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/fmriprep:/out \
-v /data/projects/srndna/fs_license.txt:/opt/freesurfer/fs_license.txt \
-v /data/projects/srndna/scratch:/scratch \
-u $(id -u):$(id -g) \
-w /scratch \
poldracklab/fmriprep:1.5.3 \
/data /out \
participant --participant_label 158 159 \
--use-aroma --fs-no-reconall --fs-license-file /opt/freesurfer/fs_license.txt \
-w /scratch

# --participant_label 149 150