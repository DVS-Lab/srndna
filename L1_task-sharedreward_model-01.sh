#!/usr/bin/env bash

maindir=`pwd`

sub=$1
run=$2

EVDIR=${maindir}/fsl/EVfiles/sub-${sub}/sharedreward/run-0${run}
DATA=${maindir}/fmriprep/fmriprep/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-smoothAROMAnonaggr_preproc.nii.gz
MAINOUTPUT=${maindir}/fsl/sub-${sub}/
mkdir -p $MAINOUTPUT
OUTPUT=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-0${run}
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
	rm -rf ${OUTPUT}.feat
fi

ITEMPLATE=${maindir}/templates/L1_task-sharedreward_model-01_type-act.fsf
OTEMPLATE=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-0${run}.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
<$ITEMPLATE> $OTEMPLATE

# runs feat on output template
feat $OTEMPLATE

# fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
mkdir -p ${OUTPUT}.feat/reg
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz

# delete unused files
# not deleting filtered_func_data bc that's input for PPI
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
