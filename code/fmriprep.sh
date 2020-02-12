# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=$1

# set up input and output directories.
maindir=`pwd` # assume you are running from the root

# make derivatives folder if it doesn't exist. 
# let's keep this out of bids for now
if [ ! -d $maindir/derivatives ]; then
	mkdir -p $maindir/derivatives
fi

singularity run --cleanenv -B $maindir:/base -B /data/tools/licenses:/opts -B /data/scratch:/scratch \
/data/tools/fmriprep-1.5.3.simg \
/base/bids /base/derivatives \
participant --participant_label $sub \
--use-aroma --fs-no-reconall --fs-license-file /opts/fs_license.txt -w /scratch
