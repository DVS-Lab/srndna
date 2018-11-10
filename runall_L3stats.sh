#!/bin/bash


# Ultimatum
# Lower-level contrast 7 (unfair-fair)
# Lower-level contrast 8 (soc-comp)
# Lower-level contrast 9 (unfair-fair (IG-OG))
# Lower-level contrast 10 (unfair-fair (IG-C))
# Lower-level contrast 11 (unfair-fair (OG-C))
# Lower-level contrast 12 (unfair-fair (IG-C))

for subrun in "7 unfair-fair" "8 soc-comp" "9 fairness_IG-OG" "10 fairness_IG-C" "11 fairness_OG-C" "12 fairness_IG-C"; do

	set -- $subrun
	copenum=$1
	copename=$2
	bash L3_task-all_model-01.sh ultimatum $copenum $copename &
	sleep 5

done



# Shared Reward
# Lower-level contrast 7 (rew-pun)
# Lower-level contrast 8 (F-S)
# Lower-level contrast 9 (F-C)
# Lower-level contrast 10 ((F+S)-C)
# Lower-level contrast 11 (F-S (rew-pun))
# Lower-level contrast 12 (S-C (rew-pun))
# Lower-level contrast 13 (F-C (rew-pun))

for subrun in "7 rew-pun" "8 F-S" "9 F-C" "10 FS-C" "11 reward_F-S" "12 reward_S-C" "13 reward_F-C"; do

	set -- $subrun
	copenum=$1
	copename=$2
	bash L3_task-all_model-01.sh sharedreward $copenum $copename &
	sleep 5

done



# Trust
#Lower-level contrast 10 (rec-def)
#Lower-level contrast 11 (S+F > C (face))
#Lower-level contrast 12 (F > S (rec-def))
#Lower-level contrast 13 (F > S)
#Lower-level contrast 14 (F > C)
#Lower-level contrast 15 (S > C)
#Lower-level contrast 16 (rec_SocClose)
#Lower-level contrast 17 (def_SocClose)
#Lower-level contrast 18 (rec-def (SocClose))

for subrun in "10 rec-def" "11 face" "12 reciprocation_F-S" "13 F-S" "14 F-C" "15 S-C" "16 rec_SocClose" "17 def_SocClose" "18 rec-def_SocClose"; do

	set -- $subrun
	copenum=$1
	copename=$2
	bash L3_task-all_model-01.sh trust $copenum $copename &
	sleep 5

done

