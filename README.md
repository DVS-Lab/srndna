# Decision Neuroscience and Aging
This repository contains code related to our SRNDNA grant [Subaward of NIH R24-AG054355 (PI Samanez-Larkin)]. All hypotheses and analysis plans were pre-registered on AsPredicted on 7/26/2018 and data collection commenced on 7/31/2018. We will share all of the resulting imaging data via [OpenNeuro][1] at the conclusion of our study (projected for summer 2019). More details about code can be found on the wiki associated with this repository.

## Notes on repository organization and files
Some of the contents of this repository are not tracked (.gitignore) because the files are large. These files/folders specifically include our dicom images, converted images in bids format, fsl output, and derivatives from bids (e.g., mriqc and fmriprep). All scripts will reference these directories, which are only visible on our the primary linux workstation in Smith Lab.

The psychopy folder contains all of the code for stimulus delivery. Input files for psychopy were generated with Matlab (e.g., gen*.m files). We covert the output from psychopy to BIDS events format using Matlab (e.g., convert*BIDS.m)..


## Basic steps for experimenters
1. Transfer data from XNAT to dicoms folder (e.g., /data/projects/srndna/dicoms/SMITH-AgingDM-102)
1. Run [heudiconv][3] to convert dicoms to BIDS. See `batch_convert.sh` for details that apply to our file structure.
1. Run convert*BIDS.m scripts to place events files in bids folder
1. Run [mriqc][4] and [fmriprep][5] using `bash mriqc_example.sh` and `bash fmriprep_example.sh`, respectively. (NB: you need to edit these scripts first to point it to correct subject.)
1. Convert *_events.tsv files to 3-column files (compatible with FSL) using Tom Nichols' [BIDSto3col.sh][2] script. This script is wrapped into our pipeline using `bash gen_3col_files.sh` (NB: edit to add subject numbers)
1. Run analyses in FSL

[1]: https://openneuro.org/
[2]: https://github.com/INCF/bidsutils
[3]: https://github.com/nipy/heudiconv
[4]: https://mriqc.readthedocs.io/en/latest/index.html
[5]: http://fmriprep.readthedocs.io/en/latest/index.html
