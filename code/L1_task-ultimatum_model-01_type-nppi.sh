#!/usr/bin/env bash

maindir=`pwd`

TASK=ultimatum
sm=6

sub=$1
run=$2
ppi=$3 # network -- ecn or dmn
dtype=dctAROMAnonaggr

# TODO:
# 2) add logging option if running through a second time
# 4) execute with datalad run -m "message" --input "derivatives/fmriprep/*" --output "derivatives/fsl/*" "bash run_L1stats.sh"
# 5) change input data to fmriprep and update templatee to smooth?
# switch to ER design and exclude misses
# subject folders should be subdatasets

MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
mkdir -p $MAINOUTPUT

EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run}
DATA=${maindir}/derivatives/fsl/sub-${sub}/L1_task-ultimatum_model-01_type-act_run-01_sm-6_variant-dctAROMAnonaggr.feat/filtered_func_data.nii.gz
CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}_task-${TASK}_run-0${run}_desc-confounds_run-0${run}_desc-confounds_desc-fslConfounds.tsv

OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-01_nppi-${ppi}_run-0${run}_sm-${sm}_variant-${dtype}
if [ -e ${OUTPUT}.feat/cluster_mask_zstat1.nii.gz ]; then
	exit
else
   echo "missing: $OUTPUT " >> ${maindir}/re-runL1.log
	rm -rf ${OUTPUT}.feat
fi


MASK=${MAINOUTPUT}/L1_task-${TASK}_model-01_type-act_run-0${run}_sm-${sm}_variant-${dtype}.feat/mask
for net in `seq 0 9`; do
	NET=${maindir}/masks/nan_rPNAS_2mm_net000${net}.nii.gz
	TSFILE=${MAINOUTPUT}/ts_task-${TASK}_net000${net}_nppi-${ppi}_run-0${run}_variant-${dtype}.txt
	fsl_glm -i $DATA -d $NET -o $TSFILE --demean -m $MASK
	eval INPUT${net}=$TSFILE
done

DMN=$INPUT3
ECN=$INPUT7
if [ "$ppi" == "dmn" ]; then
	MAINNET=$DMN
	OTHERNET=$ECN
else
	MAINNET=$ECN
	OTHERNET=$DMN
fi

ITEMPLATE=${maindir}/derivatives/fsl/templates/L1_task-${TASK}_model-01_type-nppi.fsf
OTEMPLATE=${MAINOUTPUT}/L1_task-${TASK}_model-01_nppi-${ppi}_run-0${run}_variant-${dtype}.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
-e 's@MAINNET@'$MAINNET'@g' \
-e 's@OTHERNET@'$OTHERNET'@g' \
-e 's@INPUT0@'$INPUT0'@g' \
-e 's@INPUT1@'$INPUT1'@g' \
-e 's@INPUT2@'$INPUT2'@g' \
-e 's@INPUT4@'$INPUT4'@g' \
-e 's@INPUT5@'$INPUT5'@g' \
-e 's@INPUT6@'$INPUT6'@g' \
-e 's@INPUT8@'$INPUT8'@g' \
-e 's@INPUT9@'$INPUT9'@g' \
-e 's@CONFOUNDEVS@'$CONFOUNDEVS'@g' \
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
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
