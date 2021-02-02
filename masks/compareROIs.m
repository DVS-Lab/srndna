ciftiOFC_run1 = load('sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-1_bold_timeseries_nan_rTommy_OFC_meants.csv');
ciftiOFC_run2 = load('sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-2_bold_timeseries_nan_rTommy_OFC_meants.csv');
ciftiVS_run1 = load('sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-1_bold_timeseries_nan_rTommy_VS_meants.csv');
ciftiVS_run2 = load('sub-NDARINV028WCTG6_ses-baselineYear1Arm1_task-MID_run-2_bold_timeseries_nan_rTommy_VS_meants.csv');


niftiOFC_run1 = load('run-1_OFC_NIFTI.txt');
niftiOFC_run2 = load('run-2_OFC_NIFTI.txt');
niftiVS_run1 = load('run-1_VS_NIFTI.txt');
niftiVS_run2 = load('run-2_VS_NIFTI.txt');

ciftidata = [ciftiOFC_run1' ciftiOFC_run2' ciftiVS_run1' ciftiVS_run2'];
niftidata = [niftiOFC_run1 niftiOFC_run2 niftiVS_run1 niftiVS_run2];

corr([ciftiVS_run1' niftiVS_run1])
corr([ciftiVS_run2' niftiVS_run2])

vs_data = [ciftiVS_run1' niftiVS_run1 ciftiVS_run2' niftiVS_run2];
corr(vs_data(8:end,:)) % ignore first 7 time points since they have the spike

% are there 30 vertices in this file?
figure,imagesc(corr(gifti_ofc'))


mean_gifti_ofc = mean(gifti_ofc,1)';
figure,imagesc(corr([mean_gifti_ofc niftiOFC_run1 niftiOFC_run2]));


