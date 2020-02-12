#!/usr/bin/env bash

maindir=`pwd`

TASK=trust

sub=$1
run=$2
ppi=$3 # 0 for activation, otherwise name of the roi
sm=$4
dtype=dctAROMAnonaggr

# TODO: 
# 2) add logging option if running through a second time
# 4) execute with datalad run -m "message" --input "derivatives/fmriprep/*" --output "derivatives/fsl/*" "bash run_L1stats.sh"

if [ $sub -eq 150 -a $run -eq 2 ]; then
	echo "participant fell asleep. skip run"
	exit
fi


# set input and output and adjust for ppi
MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
mkdir -p $MAINOUTPUT
DATA=${maindir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-0${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz 
CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}_task-${TASK}_run-0${run}_desc-confounds_run-0${run}_desc-confounds_desc-fslConfounds.tsv
EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run}
if [ "$ppi" == "0" ]; then
	TYPE=act
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_run-0${run}_sm-${sm}_variant-${dtype}
else
	TYPE=ppi
	OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-${TYPE}_seed-${ppi}_run-0${run}_sm-${sm}_variant-${dtype}
fi

# check for output and skip existing
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
   echo "missing: $OUTPUT " >> ${maindir}/re-runL1.log
	rm -rf ${OUTPUT}.feat
fi


MISSED_TRIAL=${EVDIR}_missed_trial.txt
if [ -e $MISSED_TRIAL ]; then
	EV_SHAPE=3
else
	EV_SHAPE=10
fi

ITEMPLATE=${maindir}/derivatives/fsl/templates/L1_task-${TASK}_model-01_type-${TYPE}.fsf
OTEMPLATE=${MAINOUTPUT}/L1_task-${TASK}_model-01_seed-${ppi}_run-0${run}_variant-${dtype}.fsf
if [ "$ppi" == "0" ]; then
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@MISSED_TRIAL@'$MISSED_TRIAL'@g' \
	-e 's@EV_SHAPE@'$EV_SHAPE'@g' \
	-e 's@SMOOTH@'$sm'@g' \
	-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
	<$ITEMPLATE> $OTEMPLATE
else
	PHYS=${MAINOUTPUT}/ts_task-${TASK}_mask-${ppi}_run-0${run}.txt
	MASK=${maindir}/masks/r${ppi}_func.nii.gz
	fslmeants -i $DATAPPI -o $PHYS -m $MASK
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@DATA@'$DATA'@g' \
	-e 's@EVDIR@'$EVDIR'@g' \
	-e 's@MISSED_TRIAL@'$MISSED_TRIAL'@g' \
	-e 's@EV_SHAPE@'$EV_SHAPE'@g' \
	-e 's@PHYS@'$PHYS'@g' \
	-e 's@SMOOTH@'$sm'@g' \
	-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
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
