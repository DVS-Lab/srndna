#!/usr/bin/env bash

# example code for heudiconv
# runs heudiconv on input subject
# usage: bash run_heudiconv.sh sub xnat
# example: bash run_heudiconv.sh 102 1

sub=$1
xnat=$2
nruns=$3

bidsroot=/data/projects/srndna/bids
rm -rf ${bidsroot}/sub-${sub}

if [ $xnat == 1 ]; then
  docker run --rm -it -v /data/projects/srndna:/data:ro \
  -v ${bidsroot}:/output \
  -u $(id -u):$(id -g) \
  nipy/heudiconv:latest \
  -d /data/dicoms/SMITH-AgingDM-{subject}/scans/*/DICOM/*.dcm -s $sub \
  -f /data/heuristics.py -c dcm2niix -b --minmeta -o /output
else
  docker run --rm -it -v /data/projects/srndna:/data:ro \
  -v ${bidsroot}:/output \
  -u $(id -u):$(id -g) \
  nipy/heudiconv:latest \
  -d /data/dicoms/SMITH-AgingDM-{subject}/*/*/*.IMA -s $sub \
  -f /data/heuristics.py -c dcm2niix -b --minmeta -o /output
fi

# need to check anonymization (e.g., dcm2niix -ba -y)???

rm -rf missing-BIDS_sub-${sub}.log
if [ $nruns -eq 5 ]; then
	# FMAP_INTENDEDFOR  set the list of func filenames correctly here (relative paths starting from within sub-### folder)
	# will have to adjust for subjects who don't have this. need a better way to do this
	FUNC01=\"func\\/sub-${sub}_task-sharedreward_run-01_bold.nii.gz\"
	FUNC02=\"func\\/sub-${sub}_task-sharedreward_run-02_bold.nii.gz\"
	FUNC03=\"func\\/sub-${sub}_task-trust_run-01_bold.nii.gz\"
	FUNC04=\"func\\/sub-${sub}_task-trust_run-02_bold.nii.gz\"
	FUNC05=\"func\\/sub-${sub}_task-trust_run-03_bold.nii.gz\"
	FUNC06=\"func\\/sub-${sub}_task-trust_run-04_bold.nii.gz\"
	FUNC07=\"func\\/sub-${sub}_task-trust_run-05_bold.nii.gz\"
	FUNC08=\"func\\/sub-${sub}_task-ultimatum_run-01_bold.nii.gz\"
	FUNC09=\"func\\/sub-${sub}_task-ultimatum_run-02_bold.nii.gz\"

	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-ultimatum_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2 3 4 5; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-trust_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done

	#FMAP_INTENDEDFOR edit the line below so that it only includes as many FUNC_FILENAME as you need
	#the formatting of this line is kind of tricky with all the special characters: \n \t
	#be sure to include ,\n\t\t in between each ${FUNCFILENAME} (but not after the last one)
	#after the last ${FUNCFILENAME} in the line there should be the characters ],/g before the closing quotation mark (")
	sed -i "1s/{/{\n\t\"IntendedFor\": [${FUNC01},\n\t\t${FUNC02},\n\t\t${FUNC03},\n\t\t${FUNC04},\n\t\t${FUNC05},\n\t\t${FUNC06},\n\t\t${FUNC07},\n\t\t${FUNC08},\n\t\t${FUNC09}],/g" ${bidsroot}/sub-${sub}/fmap/sub-${sub}_*.json

elif [ $nruns -eq 4 ]; then

	FUNC01=\"func\\/sub-${sub}_task-sharedreward_run-01_bold.nii.gz\"
	FUNC02=\"func\\/sub-${sub}_task-sharedreward_run-02_bold.nii.gz\"
	FUNC03=\"func\\/sub-${sub}_task-trust_run-01_bold.nii.gz\"
	FUNC04=\"func\\/sub-${sub}_task-trust_run-02_bold.nii.gz\"
	FUNC05=\"func\\/sub-${sub}_task-trust_run-03_bold.nii.gz\"
	FUNC06=\"func\\/sub-${sub}_task-trust_run-04_bold.nii.gz\"
	FUNC08=\"func\\/sub-${sub}_task-ultimatum_run-01_bold.nii.gz\"
	FUNC09=\"func\\/sub-${sub}_task-ultimatum_run-02_bold.nii.gz\"

	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-ultimatum_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2 3 4; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-trust_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done

	sed -i "1s/{/{\n\t\"IntendedFor\": [${FUNC01},\n\t\t${FUNC02},\n\t\t${FUNC03},\n\t\t${FUNC04},\n\t\t${FUNC05},\n\t\t${FUNC06},\n\t\t${FUNC08},\n\t\t${FUNC09}],/g" ${bidsroot}/sub-${sub}/fmap/sub-${sub}_*.json


elif [ $nruns -eq 3 ]; then

	FUNC01=\"func\\/sub-${sub}_task-sharedreward_run-01_bold.nii.gz\"
	FUNC02=\"func\\/sub-${sub}_task-sharedreward_run-02_bold.nii.gz\"
	FUNC03=\"func\\/sub-${sub}_task-trust_run-01_bold.nii.gz\"
	FUNC04=\"func\\/sub-${sub}_task-trust_run-02_bold.nii.gz\"
	FUNC05=\"func\\/sub-${sub}_task-trust_run-03_bold.nii.gz\"
	FUNC08=\"func\\/sub-${sub}_task-ultimatum_run-01_bold.nii.gz\"
	FUNC09=\"func\\/sub-${sub}_task-ultimatum_run-02_bold.nii.gz\"

	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-ultimatum_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2 3; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-trust_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done

	sed -i "1s/{/{\n\t\"IntendedFor\": [${FUNC01},\n\t\t${FUNC02},\n\t\t${FUNC03},\n\t\t${FUNC04},\n\t\t${FUNC05},\n\t\t${FUNC08},\n\t\t${FUNC09}],/g" ${bidsroot}/sub-${sub}/fmap/sub-${sub}_*.json


elif [ $nruns -eq 2 ]; then

	FUNC01=\"func\\/sub-${sub}_task-sharedreward_run-01_bold.nii.gz\"
	FUNC02=\"func\\/sub-${sub}_task-sharedreward_run-02_bold.nii.gz\"
	FUNC03=\"func\\/sub-${sub}_task-trust_run-01_bold.nii.gz\"
	FUNC04=\"func\\/sub-${sub}_task-trust_run-02_bold.nii.gz\"
	FUNC08=\"func\\/sub-${sub}_task-ultimatum_run-01_bold.nii.gz\"
	FUNC09=\"func\\/sub-${sub}_task-ultimatum_run-02_bold.nii.gz\"

	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-sharedreward_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-ultimatum_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done
	for i in 1 2; do
		checkfile=${bidsroot}/sub-${sub}/func/sub-${sub}_task-trust_run-0${i}_bold.nii.gz
		if [ ! -e $checkfile ]; then
			echo $checkfile >> missing-BIDS_sub-${sub}.log
		fi
	done

	sed -i "1s/{/{\n\t\"IntendedFor\": [${FUNC01},\n\t\t${FUNC02},\n\t\t${FUNC03},\n\t\t${FUNC04},\n\t\t${FUNC08},\n\t\t${FUNC09}],/g" ${bidsroot}/sub-${sub}/fmap/sub-${sub}_*.json


fi
clear
tree ${bidsroot}/sub-${sub}

