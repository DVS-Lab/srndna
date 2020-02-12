# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=$1
    
singularity run -B /data/projects:/base \
/data/tools/fmriprep-1.5.3.simg \
/base/ds.srndna /base/ds.srndna/derivatives \
participant --participant_label $sub \
--use-aroma --fs-no-reconall --fs-license-file /base/srndna/fs_license.txt
