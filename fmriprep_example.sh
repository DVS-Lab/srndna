# example code for FMRIPREP
# runs FMRIPREP on all subjects in BIDS_out_all

docker run -it --rm \
-v /data/projects/srndna/bids:/data:ro \
-v /data/projects/srndna/fmriprep:/out \
-v /data/projects/srndna/fs_license.txt:/opt/freesurfer/fs_license.txt \
poldracklab/fmriprep:latest \
/data /out \
participant --use-aroma --fs-no-reconall --fs-license-file /opt/freesurfer/fs_license.txt
