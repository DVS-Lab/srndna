#!/bin/bash

#echo "sleeping for 3 hours at `date`"
#sleep 3h

# Note that Contrast N for PPI is always PHYS in these models.
# Remove for type-act or add if-statement to ignore/skip

for other in "type-nppi-dmn_sm-6" "type-nppi-ecn_sm-6" "type-ppi_seed-FFA_sm-6" "type-ppi_seed-Amyg_sm-6" "type-ppi_seed-VS_sm-6" "type-act_sm-6"; do
	for subrun in "1 C_fair" "2 C_unfair" "3 IG_fair" "4 IG_unfair" "5 OG_fair" "6 OG_unfair"; do
	#for subrun in "7 unfair-fair" "8 soc-comp" "9 fairness_IG-OG" "10 fairness_IG-C" "11 fairness_OG-C" "13 phys"; do
	
		if [ "${other}" == "type-act_sm-6" ] && [ "${subrun}" == "13 phys" ]; then
			echo "skipping phys for activation since it does not exist..."
			continue
		fi
		set -- $subrun
		copenum=$1
		copename=$2
		bash L3_task-all_model-01.sh ultimatum $copenum $copename $other &
		sleep 5
	
	done
	#sleep 5m
done

#echo "sleeping for 5 minutes at `date`"
#sleep 5m
	
for other in "type-ppi_seed-FFA_sm-6" "type-ppi_seed-Amyg_sm-6" "type-ppi_seed-VS_sm-6" "type-act_sm-6"; do
	
	for subrun in "1 C_pun" "2 C_rew" "3 F_pun" "4 F_rew" "5 S_pun" "6 S_rew"; do
	#for subrun in "7 rew-pun" "8 F-S" "9 F-C" "10 FS-C" "11 rew-pun_F-S" "12 rew-pun_S-C" "13 rew-pun_F-C" "14 rew_F-S" "15 rew_S-C" "16 rew_F-C" "17 pun_F-S" "18 pun_S-C" "19 pun_F-C" "20 phys"; do
	
		if [ "${other}" == "type-act_sm-6" ] && [ "${subrun}" == "20 phys" ]; then
			echo "skipping phys for activation since it does not exist..."
			continue
		fi
		
		set -- $subrun
		copenum=$1
		copename=$2
		bash L3_task-all_model-01.sh sharedreward $copenum $copename $other &
		sleep 5
	done


	for subrun in "1 c_C" "2 c_F" "3 c_S" "4 C_def" "5 C_rec" "6 F_def" "7 F_rec" "8 S_def" "9 S_rec"; do
	#for subrun in "10 rec-def" "11 face" "12 rec-def_F-S" "13 F-S" "14 F-C" "15 S-C" "16 rec_SocClose" "17 def_SocClose" "18 rec-def_SocClose" "19 phys"; do
		if [ "${other}" == "type-act_sm-6" ] && [ "${subrun}" == "19 phys" ]; then
			echo "skipping phys for activation since it does not exist..."
			continue
		fi		
		
		set -- $subrun
		copenum=$1
		copename=$2
		bash L3_task-all_model-01.sh trust $copenum $copename $other &
		sleep 5
	done
	
	#echo "sleeping for 15 minutes at `date`"
	#sleep 15m

done
