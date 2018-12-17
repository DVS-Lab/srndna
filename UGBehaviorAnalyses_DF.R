####SRNDNA, UG Analyses for OHBM abstract
####12.17.18, DF

rm(list=ls());
setwd('//Users/dfareri/Dropbox/Dominic/Github/DVS-Lab/srndna/')

##UGBehavData<-read.csv(file = 'UG_summary_subj_12_2018InOut_FairUnfair.csv',header=TRUE,sep = ',')
UGBehavData_Long<-read.csv(file = 'UG_summary_subj_12_2018InOut_FairUnfair_long.csv',header=TRUE,sep = ',')


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