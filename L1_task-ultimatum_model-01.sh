#!/usr/bin/env bash

maindir=`pwd`

TASK=ultimatum

sub=$1
run=$2
ppi=$3 # 0 for activation, otherwise name of the roi

MAINOUTPUT=${maindir}/fsl/sub-${sub}
mkdir -p $MAINOUTPUT

EVDIR=${maindir}/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run}
if [ "$ppi" == "0" ]; then
	DATA=${maindir}/fmriprep/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-smoothAROMAnonaggr_preproc.nii.gz
	TYPE=act
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_run-0${run}
else
	DATA=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-act_run-0${run}.feat/filtered_func_data.nii.gz
	TYPE=ppi
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_seed-${ppi}_run-0${run}
fi

if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
	rm -rf ${OUTPUT}.feat
fi

ITEMPLATE=${maindir}/templates/L1_task-${TASK}_model-01_type-${TYPE}.fsf
OTEMPLATE=${MAINOUTPUT}/L1_task-${TASK}_model-01_seed-${ppi}_run-0${run}.fsf

if [ "$ppi" == "0" ]; then
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	<$ITEMPLATE> $OTEMPLATE
else
	PHYS=${MAINOUTPUT}/ts_task-trust_mask-${ppi}_run-0${run}.txt
	MASK=${maindir}/masks/mask-${ppi}_task-trust.nii.gz
	fslmeants -i $DATA -o $PHYS -m $MASK
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@PHYS@'$PHYS'@g' \
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
