# Decision Neuroscience and Aging
This repository contains code related to our SRNDNA grant [Subaward of NIH R24-AG054355 (PI Samanez-Larkin)]. All hypotheses and analysis plans were pre-registered on AsPredicted on 7/26/2018 and data collection commenced on 7/31/2018. We will share all of the resulting imaging data via [OpenNeuro][1] at the conclusion of our study (projected for summer 2019). More details about code can be found on the wiki associated with this repository.

## Notes on repository organization and files
Some of the contents of this repository are not tracked (.gitignore) because the files are large. These files/folders specifically include our dicom images, converted images in bids format, fsl output, and derivatives from bids (e.g., mriqc and fmriprep). All scripts will reference these directories, which are only visible on our the primary linux workstation in Smith Lab.

The psychopy folder contains all of the code for stimulus delivery. Input files for psychopy were generated with Matlab (e.g., gen*.m files). We covert the output from psychopy to BIDS events format using Matlab (e.g., convert*BIDS.m).


## Basic steps for experimenters
Here are the basic steps for transferring and processing data. Note that when you see `$sub`, it should be replaced with your subject number (e.g., 102). Remember, always check your input and output for each step. If the input/output isn't clear, look through the scripts and talk to someone.

1. Transfer data from XNAT to dicoms folder (e.g., /data/projects/srndna/dicoms/SMITH-AgingDM-102). Be sure to save a backup on the S: drive.

WHY? This puts the imaging folders onto our computer in the proper location so that our later codes know where to look for the files.
The DICOM files should be moved to /data/projects/srndna/dicoms/SMITH-AgingDM-SUB_ID in the Linux computer.

2. Convert data to BIDS, preprocess, and run QA using the wrapper `bash run_prestats.sh $sub $xnat $nruns`. The `$xnat` argument indicates whether the data were downloaded from XNAT (1) or transferred directly on disk (0). The `$nruns` argument necessary because some subjects will not have the full set of five runs for the trust task. This wrapper will do the following:
    - Run [heudiconv][3] to convert dicoms to BIDS using `bash run_heudiconv.sh $sub $xnat $nruns`.
    - Run PyDeface to remove the face from the anats. This is done using `bash run_pydeface.sh $sub`.
    - Run [mriqc][4] and [fmriprep][5] using `bash run_mriqc.sh $sub` and `bash run_fmriprep.sh $sub`, respectively.

This is going to be done in the Command Prompt.  Before running anything, make sure that you are in the path of the run_prestats.sh command.  This is found in /data/projects/srndna.
$sub - subject’s ID number
$xnat - indicates whether the data were downloaded from XNAT (1) or transferred directly on disk (0).
1: If the files were placed onto the computer manually.
2: If the files were downloaded directly from XNAT.
$nruns - indicates how many rounds of the trust game were conducted.Necessary because some subjects will not have the full set of five runs for the trust task. 
**Note: this is going to take a Mississippi minute (2-3 hours). Go get coffee and call your family while you wait for this to finish running.

3. Run convert*BIDS.m scripts to place events files in bids folder. Note, this is a Matlab script.

WHY? This places all of our bonus money data in our bids folder, which will help us keep track of how much bonus money we gave our scanned participants.
Open Matlab from the Command Prompt.  To do this, run the command matlab &, which can be done from wherever you are in the directory.
matlab: opens Matlab
&: allows you to access the Command Prompt without ending the Matlab program that you are running.

4. Convert `*_events.tsv` files to 3-column files (compatible with FSL) using Tom Nichols' [BIDSto3col.sh][2] script. This script is wrapped into our pipeline using `bash gen_3col_files.sh $sub`

WHY? This will convert a BIDS event TSV file to a 3 column FSL file, which we will need for our next step.
To do this, make sure you are in the /data/projects/srndna path.

5. Run analyses in FSL. Analyses in FSL consist of two stages, which we call "Level 1" (L1) and "Level 2" (L2). The basic analysis scripts follow the same logic as above but also include a run number for L1 analyses: `bash L1_task-trust_model-01.sh $sub $run`

WHY? FSL is how we will do the majority of our analyses.  It is a visual tool that we can use to see 2D and 3D images of the brains that we scanned.
There should be an FSL command for each of the tasks run:
L1_task-sharedreward_model-01.sh (5 runs)
L1_task-trust_model-01.sh (2 runs)
L1_task-ultimateum_model-01.sh (2 runs)
For each of these tasks, make sure to run through each individual run (number of runs listed above).
**Note: this will NOT run unless you’ve done all the other steps.

[1]: https://openneuro.org/
[2]: https://github.com/INCF/bidsutils
[3]: https://github.com/nipy/heudiconv
[4]: https://mriqc.readthedocs.io/en/latest/index.html
[5]: http://fmriprep.readthedocs.io/en/latest/index.html
