# Decision Neuroscience and Aging
This repository contains code related to our SRNDNA grant [Subaward of NIH R24-AG054355 (PI Samanez-Larkin)]. All hypotheses and analysis plans were pre-registered on AsPredicted on 7/26/2018 and data collection commenced on 7/31/2018. We will share all of the resulting imaging data via [OpenNeuro][1] at the conclusion of our study (projected for summer 2019). More details about code can be found on the wiki associated with this repository.

## Notes on repository organization and files
Some of the contents of this repository are not tracked (.gitignore) because the files are large. These files/folders specifically include our dicom images, converted images in bids format, fsl output, and derivatives from bids (e.g., mriqc and fmriprep). All scripts will reference these directories, which are only visible on our the primary linux workstation in Smith Lab.

The psychopy folder contains all of the code for stimulus delivery. Input files for psychopy were generated with Matlab (e.g., gen*.m files). We covert the output from psychopy to BIDS events format using Matlab (e.g., convert*BIDS.m)..


## Basic steps for experimenters
Here are the basic steps for transferring and processing data. Note that when you see `$sub`, it should be replaced with your subject number (e.g., 102). Remember, always check your input and output for each step. If the input/output isn't clear, look through the scripts and talk to someone.

1. Transfer data from XNAT to dicoms folder (e.g., /data/projects/srndna/dicoms/SMITH-AgingDM-102)
1. Run [heudiconv][3] to convert dicoms to BIDS using `bash run_heudiconv.sh $sub`.
1. Run PyDeface to remove the face from the anats. This is done using `bash run_pydeface.sh $sub`. This updates permissions.
1. Run convert*BIDS.m scripts to place events files in bids folder. Note, this is a Matlab script.
1. Run [mriqc][4] and [fmriprep][5] using `bash run_mriqc.sh $sub` and `bash run_fmriprep.sh $sub`, respectively.
1. Convert `*_events.tsv` files to 3-column files (compatible with FSL) using Tom Nichols' [BIDSto3col.sh][2] script. This script is wrapped into our pipeline using `bash gen_3col_files.sh $sub`
1. Run analyses in FSL. Analyses in FSL consist of two stages, which we call "Level 1" (L1) and "Level 2" (L2). The basic analysis scripts follow the same logic as above but also include a run number for L1 analyses: `bash L1_task-trust_model-01.sh $sub $run`

[1]: https://openneuro.org/
[2]: https://github.com/INCF/bidsutils
[3]: https://github.com/nipy/heudiconv
[4]: https://mriqc.readthedocs.io/en/latest/index.html
[5]: http://fmriprep.readthedocs.io/en/latest/index.html
