#!/usr/bin/env bash

maindir=`pwd`

TASK=trust

sub=$1
run=$2
ppi=$3 # 0 for activation, otherwise name of the roi
sm=$4

MAINOUTPUT=${maindir}/fsl/sub-${sub}
mkdir -p $MAINOUTPUT

# denoise data, if it doesn't exist
cd ${maindir}/fmriprep/fmriprep/sub-${sub}/func
if [ ! -e sub-${sub}_task-${TASK}_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-unsmoothedAROMAnonaggr_preproc.nii.gz ]; then
	fsl_regfilt -i sub-${sub}_task-${TASK}_run-0${run}_bold_space-MNI152NLin2009cAsym_preproc.nii.gz \
	    -f $(cat sub-${sub}_task-${TASK}_run-0${run}_bold_AROMAnoiseICs.csv) \
	    -d sub-${sub}_task-${TASK}_run-0${run}_bold_MELODICmix.tsv \
	    -o sub-${sub}_task-${TASK}_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-unsmoothedAROMAnonaggr_preproc.nii.gz
fi

EVDIR=${maindir}/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run}
if [ "$ppi" == "0" ]; then
	DATA=${maindir}/fmriprep/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-unsmoothedAROMAnonaggr_preproc.nii.gz
	TYPE=act
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_run-0${run}_sm-${sm}
else
	DATA=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-act_run-0${run}_sm-${sm}.feat/filtered_func_data.nii.gz
	TYPE=ppi
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_seed-${ppi}_run-0${run}_sm-${sm}
fi


if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
	rm -rf ${OUTPUT}.feat
fi

MISSED_TRIAL=${EVDIR}_missed_trial.txt
if [ -e $MISSED_TRIAL ]; then
	EV_SHAPE=3
else
	EV_SHAPE=10
fi

ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-01_type-${TYPE}.fsf
OTEMPLATE=${MAINOUTPUT}/L1_task-${TASK}_model-01_seed-${ppi}_run-0${run}.fsf

if [ "$ppi" == "0" ]; then
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@MISSED_TRIAL@'$MISSED_TRIAL'@g' \
	-e 's@EV_SHAPE@'$EV_SHAPE'@g' \
	-e 's@SMOOTH@'$sm'@g' \
	<$ITEMPLATE> $OTEMPLATE
else
	PHYS=${MAINOUTPUT}/ts_task-trust_mask-${ppi}_run-0${run}.txt
	MASK=${maindir}/masks/mask-${ppi}_task-trust.nii.gz
	fslmeants -i $DATA -o $PHYS -m $MASK
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@MISSED_TRIAL@'$MISSED_TRIAL'@g' \
	-e 's@EV_SHAPE@'$EV_SHAPE'@g' \
	-e 's@PHYS@'$PHYS'@g' \
	-e 's@SMOOTH@'$sm'@g' \
	<$ITEMPLATE> $OTEMPLATE
fi

# runs feat on output template
feat $OTEMPLATE

# fix registration as per NeuroStars post:
# https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
mkdir -p ${OUTPUT}.feat/reg
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz

# delete unused files
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz

if [ ! "$ppi" == "0" ]; then
	rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
fi
