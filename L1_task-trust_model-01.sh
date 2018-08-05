#!/usr/bin/env bash

maindir=`pwd`

for sub in NDARINV38MDKPJC NDARINV4JR952MJ; do
  for run in 1 2; do
    EVDIR=${maindir}/fsl/EVfiles/sub-${sub}/ses-baselineYear1Arm1/run-0${run}
    DATA=${maindir}/fmriprep/sub-${sub}/ses-baselineYear1Arm1/func/sub-${sub}_ses-baselineYear1Arm1_task-mid_run-0${run}_bold_space-MNI152NLin2009cAsym_variant-smoothAROMAnonaggr_preproc.nii.gz
    MAINOUTPUT=${maindir}/fsl/sub-${sub}/ses-baselineYear1Arm1
    mkdir -p $MAINOUTPUT

    OUTPUT=${MAINOUTPUT}/L1_Act_run-0${run}

    # Fix TR in the header (ABCD incorrectly lists it as 1s and should be 0.8 s)
    fslhd -x ${DATA} | sed 's/  dt = .*/  dt = '0.8'/g' > grot
    cat grot | fslcreatehd - ${DATA}
    rm grot

    ITEMPLATE=${maindir}/templates/L1_Act_template.fsf
    OTEMPLATE=${MAINOUTPUT}/L1_Act_run-0${run}.fsf
    sed -e 's@OUTPUT@'$OUTPUT'@g' \
    -e 's@DATA@'$DATA'@g' \
    -e 's@EVDIR@'$EVDIR'@g' \
    <$ITEMPLATE> $OTEMPLATE

    #runs feat on output template
    feat $OTEMPLATE

    #fix registration as per NeuroStars post https://neurostars.org/t/performing-full-glm-analysis-with-fsl-on-the-bold-images-preprocessed-by-fmriprep-without-re-registering-the-data-to-the-mni-space/784/3
    mkdir -p ${OUTPUT}.feat/reg
    ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/example_func2standard.mat
    ln -s $FSLDIR/etc/flirtsch/ident.mat ${OUTPUT}.feat/reg/standard2example_func.mat
    ln -s ${OUTPUT}.feat/mean_func.nii.gz ${OUTPUT}.feat/reg/standard.nii.gz


    #delete unused files
    #not deleting filtered_func_data bc that's input for PPI
    rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
    rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
    rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz

  done
done
