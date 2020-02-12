#!/usr/bin/env bash

maindir=`pwd`

sub=$1
nruns=$2
ppi=$3
sm=$4
dtype=$5

MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}

# Trust Task
NCOPES=19
if [ $sub -eq 150 ]; then
	nruns=4
	INPUT1=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-01_sm-${sm}_variant-${dtype}.feat
	INPUT2=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-03_sm-${sm}_variant-${dtype}.feat
	INPUT3=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-04_sm-${sm}_variant-${dtype}.feat
	INPUT4=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-05_sm-${sm}_variant-${dtype}.feat			
else
	INPUT1=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-01_sm-${sm}_variant-${dtype}.feat
	INPUT2=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-02_sm-${sm}_variant-${dtype}.feat
	INPUT3=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-03_sm-${sm}_variant-${dtype}.feat
	INPUT4=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-04_sm-${sm}_variant-${dtype}.feat
	INPUT5=${MAINOUTPUT}/L1_task-trust_model-01_type-ppi_seed-${ppi}_run-05_sm-${sm}_variant-${dtype}.feat
fi

OUTPUT=${MAINOUTPUT}/L2_task-trust_model-01_type-ppi_seed-${ppi}_sm-${sm}_variant-${dtype}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	echo "re-doing: ${OUTPUT}" >> re-runL2.log
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/derivatives/fsl/templates/L2_task-trust_model-01_type-ppi_nruns-${nruns}.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-trust_model-01_type-ppi_seed-${ppi}_variant-${dtype}.fsf
	
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
NCOPES=20
INPUT1=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-ppi_seed-${ppi}_run-01_sm-${sm}_variant-${dtype}.feat
INPUT2=${MAINOUTPUT}/L1_task-sharedreward_model-01_type-ppi_seed-${ppi}_run-02_sm-${sm}_variant-${dtype}.feat

OUTPUT=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-ppi_seed-${ppi}_sm-${sm}_variant-${dtype}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat
	
	ITEMPLATE=${maindir}/derivatives/fsl/templates/L2_task-sharedreward_model-01_type-ppi.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-sharedreward_model-01_type-ppi_seed-${ppi}_variant-${dtype}.fsf
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
NCOPES=13
INPUT1=${MAINOUTPUT}/L1_task-ultimatum_model-01_type-ppi_seed-${ppi}_run-01_sm-${sm}_variant-${dtype}.feat
INPUT2=${MAINOUTPUT}/L1_task-ultimatum_model-01_type-ppi_seed-${ppi}_run-02_sm-${sm}_variant-${dtype}.feat

OUTPUT=${MAINOUTPUT}/L2_task-ultimatum_model-01_type-ppi_seed-${ppi}_sm-${sm}_variant-${dtype}
if [ -e ${OUTPUT}.gfeat/cope${NCOPES}.feat/cluster_mask_zstat1.nii.gz ]; then
	echo "skipping existing output"
else
	rm -rf ${OUTPUT}.gfeat

	ITEMPLATE=${maindir}/derivatives/fsl/templates/L2_task-ultimatum_model-01_type-ppi.fsf
	OTEMPLATE=${MAINOUTPUT}/L2_task-ultimatum_model-01_type-ppi_seed-${ppi}_variant-${dtype}.fsf
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
