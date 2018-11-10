#!/usr/bin/env bash

maindir=`pwd`

sub=$1
nruns=$2

MAINOUTPUT=${maindir}/fsl/sub-${sub}

# Trust Task
NCOPES=18
INPUT1=${MAINOUTPUT}/L1_task-trust_model-01_type-act_run-01.feat
INPUT2=${MAINOUTPUT}/L1_task-trust_model-01_type-act_run-02.feat
INPUT3=${MAINOUTPUT}/L1_task-trust_model-01_type-act_run-03.feat
INPUT4=${MAINOUTPUT}/L1_task-trust_model-01_type-act_run-04.feat
INPUT5=${MAINOUTPUT}/L1_task-trust_model-01_type-act_run-05.feat

OUTPUT=${MAINOUTPUT}/L2_task-trust_model-01_type-act
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/templates/L2_task-trust_model-01_type-act_nruns-${nruns}.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-trust_model-01_type-act.fsf
	
	if [ ${nruns} -eq 5 ]; then
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@INPUT1@'$INPUT1'@g' \
		-e 's@INPUT2@'$INPUT2'@g' \
		-e 's@INPUT3@'$INPUT3'@g' \
		-e 's@INPUT4@'$INPUT4'@g' \
		-e 's@INPUT5@'$INPUT5'@g' \
		<$ITEMPLATE> $OTEMPLATE
	elif [ ${nruns} -eq 4 ]; then
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@INPUT1@'$INPUT1'@g' \
		-e 's@INPUT2@'$INPUT2'@g' \
		-e 's@INPUT3@'$INPUT3'@g' \
		-e 's@INPUT4@'$INPUT4'@g' \
		<$ITEMPLATE> $OTEMPLATE
	elif [ ${nruns} -eq 3 ]; then
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@INPUT1@'$INPUT1'@g' \
		-e 's@INPUT2@'$INPUT2'@g' \
		-e 's@INPUT3@'$INPUT3'@g' \
		<$ITEMPLATE> $OTEMPLATE
	elif [ ${nruns} -eq 2 ]; then
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@INPUT1@'$INPUT1'@g' \
		-e 's@INPUT2@'$INPUT2'@g' \
		<$ITEMPLATE> $OTEMPLATE
	fi
	feat $OTEMPLATE
	
	
	# delete unused files
	for cope in `seq ${NCOPES}`; do
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
	done

fi


# Shared Reward Task
NCOPES=13
INPUT1=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-01.feat
INPUT2=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-act_run-02.feat

OUTPUT=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-act
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat
	
	ITEMPLATE=${maindir}/templates/L2_task-sharedreward_model-01_type-act.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-act.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE
	
	# delete unused files
	for cope in `seq ${NCOPES}`; do
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
	done

fi


# Ultimatum Game Task
NCOPES=12
INPUT1=${MAINOUTPUT}/L1_task-ultimatum_model-01_type-act_run-01.feat
INPUT2=${MAINOUTPUT}/L1_task-ultimatum_model-01_type-act_run-02.feat

OUTPUT=${MAINOUTPUT}/L2_task-ultimatum_model-01_type-act
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/templates/L2_task-ultimatum_model-01_type-act.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-ultimatum_model-01_type-act.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@INPUT1@'$INPUT1'@g' \
	-e 's@INPUT2@'$INPUT2'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE
	
	# delete unused files
	for cope in `seq ${NCOPES}`; do
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
		rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
	done

fi
