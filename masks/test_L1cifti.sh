#!/usr/bin/env bash


run=1
FEATDir=`pwd`/func/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-${run}_space-MNI_bold.feat
cdata=`pwd`/func/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-${run}_bold_timeseries.dtseries.nii
Lsurf=`pwd`/anat/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_hemi-L_space-MNI_mesh-fsLR32k_midthickness.surf.gii
Rsurf=`pwd`/anat/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_hemi-R_space-MNI_mesh-fsLR32k_midthickness.surf.gii
ROIsFolder=/data/projects/abcd-mid/derivatives/dcan/derivatives/abcd-hcp-pipeline/sub-NDARINV028WCTG6/ses-baselineYear1Arm1
DesignMatrix=${FEATDir}/design.mat
DesignContrasts=${FEATDir}/design.con

#Split into surface and volume
wb_command -cifti-separate-all $cdata -volume ${FEATDir}/outVolume.nii.gz -left ${FEATDir}/outLhemi.func.gii -right ${FEATDir}/outRhemi.func.gii

# questions
# why is it atlasroi in ${LevelOnefMRIName}${TemporalFilterString}${SmoothingString}${RegString}.atlasroi.L.${LowResMesh}k_fs_LR.func.gii
# shape files? ${DownSampleFolder}/${Subject}.L.atlasroi.${LowResMesh}k_fs_LR.shape.gii
# no shape files in the abcd download


#Run film_gls on subcortical volume data and clean up
film_gls --rn=${FEATDir}/SubcorticalVolumeStats --sa --ms=5 --in=${FEATDir}/outVolume.nii.gz --pd=${DesignMatrix} --con=${DesignContrasts} --thr=1 --mode=volumetric
#rm ${FEATDir}/outVolume.nii.gz

#Run film_gls on cortical surface data
for Hemisphere in L R ; do

  #Prepare for film_gls
  wb_command -metric-dilate ${FEATDir}/out${Hemisphere}hemi.func.gii anat/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_hemi-${Hemisphere}_space-MNI_mesh-fsLR32k_midthickness.surf.gii 50 ${FEATDir}/out${Hemisphere}hemi_dil.func.gii -nearest

  #Run film_gls on surface data
  film_gls --rn=${FEATDir}/${Hemisphere}_SurfaceStats --sa --ms=15 --epith=5 --in2=anat/sub-NDARINV028WCTG6_ses-baselineYear1Arm1_hemi-${Hemisphere}_space-MNI_mesh-fsLR32k_midthickness.surf.gii --in=${FEATDir}/out${Hemisphere}hemi_dil.func.gii --pd=${DesignMatrix} --con=${DesignContrasts} --mode=surface
  #rm ${FEATDir}/out${Hemisphere}hemi_dil.func.gii ${FEATDir}/out${Hemisphere}hemi.func.gii
done

# Merge Cortical Surface and Subcortical Volume into Grayordinates
mkdir ${FEATDir}/GrayordinatesStats
cat ${FEATDir}/SubcorticalVolumeStats/dof > ${FEATDir}/GrayordinatesStats/dof
cat ${FEATDir}/SubcorticalVolumeStats/logfile > ${FEATDir}/GrayordinatesStats/logfile
cat ${FEATDir}/L_SurfaceStats/logfile >> ${FEATDir}/GrayordinatesStats/logfile
cat ${FEATDir}/R_SurfaceStats/logfile >> ${FEATDir}/GrayordinatesStats/logfile

## missing shape files for ABCD, so cannot reproduce HCP exactly
## use template instead, like film_cifti
for Subcortical in ${FEATDir}/SubcorticalVolumeStats/*nii.gz ; do
  File=$( basename $Subcortical .nii.gz );
  #wb_command -cifti-create-dense-timeseries ${FEATDir}/GrayordinatesStats/${File}.dtseries.nii -volume $Subcortical $ROIsFolder/Atlas_ROIs.2.nii.gz -left-metric ${FEATDir}/L_SurfaceStats/${File}.func.gii -roi-left ${DownSampleFolder}/${Subject}.L.atlasroi.${LowResMesh}k_fs_LR.shape.gii -right-metric ${FEATDir}/R_SurfaceStats/${File}.func.gii -roi-right ${DownSampleFolder}/${Subject}.R.atlasroi.${LowResMesh}k_fs_LR.shape.gii

  # instead, rebuild cifti from template
  wb_command -cifti-create-dense-from-template $cdata ${FEATDir}/GrayordinatesStats/${File}.dtseries.nii -left-metric ${FEATDir}/L_SurfaceStats/${File}.func.gii -metric CORTEX_RIGHT ${FEATDir}/R_SurfaceStats/${File}.func.gii -volume-all ${FEATDir}/SubcorticalVolumeStats/${File}.nii.gz
done
#rm -r ${FEATDir}/SubcorticalVolumeStats ${FEATDir}/L_SurfaceStats ${FEATDir}/R_SurfaceStats
