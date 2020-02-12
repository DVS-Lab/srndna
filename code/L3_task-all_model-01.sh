#!/usr/bin/env bash

maindir=`pwd`

task=$1
copenum=$2
copename=$3
other=$4 #type-nppi-dmn_sm-4, type-ppi_seed-FFA_sm-4 (Amyg, VS), type-act_sm-4, type-act_sm-0

MAINOUTPUT=${maindir}/derivatives/fsl/L3_model-01_n50_flame1+2_all
mkdir -p $MAINOUTPUT
REPLACEME=task-${task}_model-01_${other}

cnum_pad=`zeropad ${copenum} 2`
OUTPUT=${MAINOUTPUT}/L3_task-${task}_${other}_cnum-${cnum_pad}_cname-${copename}_twogroup
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then
	#echo "skipping existing output"
	varnothing=varnothing
else
	echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/derivatives/fsl/templates/L3_template_n50_twogroup.fsf
	OTEMPLATE=${MAINOUTPUT}/L3_task-${task}_${REPLACEME}_copenum-${copenum}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@REPLACEME@'$REPLACEME'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi

cnum_pad=`zeropad ${copenum} 2`
OUTPUT=${MAINOUTPUT}/L3_task-${task}_${other}_cnum-${cnum_pad}_cname-${copename}_onegroup
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then
	#echo "skipping existing output"
	varnothing=varnothing
else
	echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/derivatives/fsl/templates/L3_template_n50_onegroup.fsf
	OTEMPLATE=${MAINOUTPUT}/L3_task-${task}_${REPLACEME}_copenum-${copenum}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@REPLACEME@'$REPLACEME'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi
