clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'UG_summary_run_12_2018_InOut.csv');
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,run,avg_comp,avg_OutGrp,avg_InGrp,avg_comp_RT,avg_OutGrp_RT,avg_InGrp_RT,misses\n');
fname = fullfile(maindir,'UG_summary_subj_12_2018InOut.csv');
fid_subj = fopen(fname,'w');
fprintf(fid_subj,'subnum,avg_comp,avg_OutGrp,avg_InGrp,avg_comp_RT,avg_OutGrp_RT,avg_InGrp_RT,misses\n');

%sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121];

%scan subjects only
sublist = [104 105 106 107 108 109 110 111 112 113 115 116 117 118 120 121 122 124 125 126];
%ethinicity=0: 105-111, 115, 117, 120-122
%ethnicity=1: 104, 112-114, 116, 118-119, 124-126



for s = 1:length(sublist)
    
    subj = sublist(s);
    runs = 2; 
    %{
    if subj == 106 || subj == 213
        runs = 3;
    elseif subj == 109 || subj == 110
        runs = 2;
    elseif subj == 207 || subj == 210 || subj == 211 || subj == 212 || subj == 215 || subj == 216 || subj == 217 || subj == 221
        runs = 4;
    else
        runs = 5;
    end
    %}
    
    tmp_data = zeros(runs,7);
    for r = 1:runs
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-ultimatum_run-%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        RT = C{12}; % will do something with this later
        % partner is 1 (computer), 2 (outgroup), 3 (ingroup)
        Partner = C{5};
        response = C{11}; % 2 = reject, 3 = accept (with '999' for no response)
        offer = C{4}; %1-10
        data = [Partner offer response RT];
        
        misses = length(find(data(:,3)==999));
        data(data(:,3)==999,:) = [];
        data(data(:,3)==2,3) = 0;
        data(data(:,3)==3,3) = 1;
        Partner = data(:,1);
        offer = data(:,2);
        response = data(:,3);
        logRT = log(RT);
        logRT = data(:,4);
        
        avg_comp = mean(response(Partner==1,1));
        avg_outgroup = mean(response(Partner==2,1));
        avg_ingroup = mean(response(Partner==3,1));
        avg_comp_logRT = mean(logRT(Partner==1,1));
        avg_outgroup_logRT = mean(logRT(Partner==2,1));
        avg_ingroup_logRT = mean(logRT(Partner==3,1));
        tmp_data(r,:) = [avg_comp avg_outgroup avg_ingroup avg_comp_logRT avg_outgroup_logRT avg_ingroup_logRT misses];
        
        % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));
        
    end
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));
    
end
fclose(fid_subj);
fclose(fid_run);


