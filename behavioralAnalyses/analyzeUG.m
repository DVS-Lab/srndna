clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'UG_summary_run_3_19_2019_InOut_FairUnfair_wmeanRT.csv');
fid_run = fopen(fname,'w');
%fprintf(fid_run,'subnum,run,avg_comp,avg_OutGrp,avg_InGrp,avg_comp_RT,avg_OutGrp_RT,avg_InGrp_RT,misses\n');
fprintf(fid_run,'subnum,run,avg_compFair,avg_compUnfair,avg_OutGrpFair,avg_OutGrpUnfair,avg_InGrpFair,avg_InGrpUnfair,avg_compFairlogRT,avg_compUnfairlogRT,avg_OutGrpFairlogRT,avg_OutGrpUnfairlogRT,avg_InGrpFairlogRT,avg_InGrpUnfailogRT,avg_compFair_RT,avg_compUnfair_RT,avg_outgroupFair_RT,avg_outgroupUnfair_RT,avg_ingroupFair_RT,avg_ingroupUnfair_RT,misses\n');
fname = fullfile(maindir,'UG_summary_subj_3_19_2019_InOut_FairUnfair_wmeanRT.csv');
fid_subj = fopen(fname,'w');
%fprintf(fid_subj,'subnum,avg_comp,avg_OutGrp,avg_InGrp,avg_comp_RT,avg_OutGrp_RT,avg_InGrp_RT,misses\n');
fprintf(fid_subj,'subnum,avg_compFair,avg_compUnfair,avg_OutGrpFair,avg_OutGrpUnfair,avg_InGrpFair,avg_InGrpUnfair,avg_compFairlogRT,avg_compUnfairlogRT,avg_OutGrpFairlogRT,avg_OutGrpUnfairlogRT,avg_InGrpFairlogRT,avg_InGrpUnfairlogRT,avg_compFair_RT,avg_compUnfair_RT,avg_outgroupFair_RT,avg_outgroupUnfair_RT,avg_ingroupFair_RT,avg_ingroupUnfair_RT,misses\n');

%scan subjects only
sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 204 205 206 207 208 209 210 211 212 213 215 216 217 218 220 221 222 224 225 226 227 228];

%older adults are subjects 111/211, 127/227, 128/228, 129/229
%new subs include 122/222, 123 (?) 223, 124-129/224-229 (?)
% subj 229 and 123 missing behav data

%ethinicity=0 (white): 105-111, 115, 117, 120-122
%ethnicity=1 (non-white): 104, 112-114, 116, 118-119, 124-126



for s = 1:length(sublist)
    
    subj = sublist(s);
    runs = 2; 
    
    tmp_data = zeros(runs,19);
    for r = 1:runs
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-ultimatum_run-%d_raw.csv',subj,r-1)); % creates variable to store the path to a given subject's data
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN); %creates a cell array C reading in the .csv file with header rows
        fclose(fid);
        
        RT = C{12}; % create variable to store reaction time 
        Partner = C{5}; % create variable to store partner: 1 (computer), 2 (outgroup), 3 (ingroup)
        response = C{11}; % create variable to store response: 2 = reject, 3 = accept (with '999' for no response)
        offer = C{4}; % create variable to store offer amount: 1-10
        block = C{2}; % create variable to store block type: 1 = fair, 0 = unfair
        data = [Partner block offer response RT]; % creates matrix to hold subject data of relevance
        
        misses = length(find(data(:,3)==999)); %create vector of missed trials
        data(data(:,4)==999,:) = []; % remove rows of missed trials from data for calculations
        data(data(:,4)==2,4) = 0; % recode reject from 2 to 0
        data(data(:,4)==3,4) = 1; % recode accept from 3 to 1
        Partner = data(:,1);
        block = data(:,2);
        offer = data(:,3);
        response = data(:,4);
        RT = data(:,5);
        logRT = log(RT); % log transform RT
        
        % compute average proportion of accepted trials per partner
        avg_compFair = mean(response(Partner==1 & block == 1,1));
        avg_compUnfair = mean(response(Partner==1 & block == 0,1));
        avg_outgroupFair = mean(response(Partner==2 & block == 1,1));
        avg_outgroupUnfair = mean(response(Partner==2 & block == 0,1));
        avg_ingroupFair = mean(response(Partner==3 & block == 1,1));
        avg_ingroupUnfair = mean(response(Partner==3 & block == 0,1));
        
        %compute average logRT per partner
        avg_compFair_logRT = mean(logRT(Partner==1 & block == 1,1));
        avg_compUnfair_logRT = mean(logRT(Partner==1 & block == 0,1));
        avg_outgroupFair_logRT = mean(logRT(Partner==2 & block == 1,1));
        avg_outgroupUnfair_logRT = mean(logRT(Partner==2 & block == 0,1));
        avg_ingroupFair_logRT = mean(logRT(Partner==3 & block == 1,1));
        avg_ingroupUnfair_logRT = mean(logRT(Partner==3 & block == 0,1));
        
        avg_compFair_RT = mean(RT(Partner==1 & block == 1,1));
        avg_compUnfair_RT = mean(RT(Partner==1 & block == 0,1));
        avg_outgroupFair_RT = mean(RT(Partner==2 & block == 1,1));
        avg_outgroupUnfair_RT = mean(RT(Partner==2 & block == 0,1));
        avg_ingroupFair_RT = mean(RT(Partner==3 & block == 1,1));
        avg_ingroupUnfair_RT = mean(RT(Partner==3 & block == 0,1));
        
        %fill temporary matrix with data to be written out
        tmp_data(r,:) = [avg_compFair avg_compUnfair avg_outgroupFair avg_outgroupUnfair avg_ingroupFair avg_ingroupUnfair avg_compFair_logRT avg_compUnfair_logRT avg_outgroupFair_logRT avg_outgroupUnfair_logRT avg_ingroupFair_logRT avg_ingroupUnfair_logRT avg_compFair_RT avg_compUnfair_RT avg_outgroupFair_RT avg_outgroupUnfair_RT avg_ingroupFair_RT avg_ingroupUnfair_RT misses];
        
        %write out averages per run
        % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));
        
    end
    % write out average across runs
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));
    
end
fclose(fid_subj);
fclose(fid_run);


