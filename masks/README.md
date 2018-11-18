# Masks

Notes on masks for the SRNDNA project. Just making a changelog. Not sure if other details should be added to .json sidecar files, but I think a changelog to keep track of masks should suffice.

## Analysis with N=16
Currently have nice results with N=16. I made three masks using the Trust Task data. I'm trying to use a naming convention that resembles BIDS, but I'm not sure if there's actual guidance on this. 
1. `mask-vs_task-trust.nii.gz` is derived from the reciprocate > defect contrast
1. `mask-amyg_task-trust.nii.gz` is derived from the face contrast (friend+stranger > computer)
1. `mask-ffa_task-trust.nii.gz` is derived from the face contrast (friend+stranger > computer)