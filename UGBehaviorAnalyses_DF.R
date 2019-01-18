####SRNDNA, UG Analyses for OHBM abstract
####12.17.18, DF

rm(list=ls());
setwd('//Users/dfareri/Dropbox/Dominic/Github/DVS-Lab/srndna/')

##UGBehavData<-read.csv(file = 'UG_summary_subj_12_2018InOut_FairUnfair.csv',header=TRUE,sep = ',')
UGBehavData_Long<-read.csv(file = 'UG_summary_subj_12_2018InOut_FairUnfair_long.csv',header=TRUE,sep = ',')

#convert from proportion accept to proportion reject
UGBehavData$avg_compFairRej<-(1-UGBehavData$avg_compFair)
UGBehavData$avg_compUnfairRej<-(1-UGBehavData$avg_compUnfair)
UGBehavData$avg_OutGrpFairRej<-(1-UGBehavData$avg_OutGrpFair)
UGBehavData$avg_OutGrpUnfairRej<-(1-UGBehavData$avg_OutGrpUnfair)
UGBehavData$avg_InGrpFairRej<-(1-UGBehavData$avg_InGrpFair)
UGBehavData$avg_InGrpUnfairRej<-(1-UGBehavData$avg_InGrpUnfair)

#Repeated Measures, fixed effects only
Partner_OfferType<-lm(ProportionAccept~Partner*Block,data=UGBehavData_Long)
#regression output
summary(Partner_OfferType)
#output as ANOVA (f-statistic)
summary(aov(Partner_OfferType))

#Repeated Measures using lmer, modeling subject as random effect
lmer_Partner_OfferType<-lmer(ProportionAccept~Partner*Block + (1|SubjectID),data = UGBehavData_Long)
#output of lmer
summary(lmer_Partner_OfferType)

##create difference scores
DifferenceScores<-matrix(nrow=20,ncol=4)
DifferenceScores[,1]<-UGBehavData$SubjectID
DifferenceScores[,2]<-(UGBehavData$avg_compUnfairRej-UGBehavData$avg_compFairRej)
DifferenceScores[,3]<-(UGBehavData$avg_OutGrpUnfairRej-UGBehavData$avg_OutGrpFairRej)
DifferenceScores[,4]<-(UGBehavData$avg_InGrpUnfairRej-UGBehavData$avg_InGrpFairRej)
