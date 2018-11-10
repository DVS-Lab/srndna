#!/usr/bin/env bash

maindir=`pwd`

task=$1
copenum=$2
copename=$3

MAINOUTPUT=${maindir}/fsl/L3_all_n9
mkdir -p $MAINOUTPUT


OUTPUT=${MAINOUTPUT}/L3_task-${task}_model-01_type-act_copenum-${copenum}_copename-${copename}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/templates/L3_template_n9.fsf
	OTEMPLATE=${MAINOUTPUT}/L3_task-${task}_model-01_type-act_copenum-${copenum}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@TASK@'$task'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE
	
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi

