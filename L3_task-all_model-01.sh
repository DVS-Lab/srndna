#!/usr/bin/env bash

maindir=`pwd`

task=$1
copenum=$2
copename=$3
other=$4 # type-ppi_seed-ffa

MAINOUTPUT=${maindir}/fsl/L3_model-01_ppi_n16_rfx_CDT-z2p6
mkdir -p $MAINOUTPUT
REPLACEME=task-${task}_model-01_${other}

OUTPUT=${MAINOUTPUT}/L3_task-${task}_${other}_copename-${copename}
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/templates/L3_template_n16.fsf
	OTEMPLATE=${MAINOUTPUT}/L3_task-${task}_${REPLACEME}_copenum-${copenum}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@REPLACEME@'$REPLACEME'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi
