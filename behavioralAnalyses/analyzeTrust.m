clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'trust_summary_run_3_19_2019_InOut_wmeanRT.csv');
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,run,avg_comp,avg_stranger,avg_friend,avg_comp_logRT,avg_stranger_logRT,avg_friend_logRT,avg_comp_RT,avg_stranger_RT,avg_friend_RT,misses\n');
fname = fullfile(maindir,'trust_summary_subj_3_19_2019_InOut_wmeanRT.csv');
fid_subj = fopen(fname,'w');
fprintf(fid_subj,'subnum,avg_comp,avg_stranger,avg_friend,avg_comp_logRT,avg_stranger_logRT,avg_friend_logRT,avg_comp_RT,avg_stranger_RT,avg_friend_RT,misses\n');

%sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121];
sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 204 205 206 207 208 209 210 211 212 213 215 216 217 218 220 221 222 224 225 226 227 228];

%older adults are subjects 111/211, 127/227, 128/228, 129/229
%new subs include 122/222, 123 (?) 223, 124-129/224-229 (?)
% subj 229 and 123 missing behav data
for s = 1:length(sublist)
    
    subj = sublist(s);
    if subj == 106 || subj == 213
        runs = 3;
    elseif subj == 109 || subj == 110
        runs = 2;
    elseif subj == 207 || subj == 210 || subj == 211 || subj == 212 || subj == 215 || subj == 216 || subj == 217 || subj == 221 || subj == 224 || subj == 227
        runs = 4;
    else
        runs = 5;
    end
    
    tmp_data = zeros(runs,10);
    for r = 1:runs
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-Rej_%02d_task-intertemporalchoice_run%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        RT = C{16}; % will do something with this later
        % partner is 1 (computer), 2 (stranger), 3 (friend)
        Partner = C{4};
        trust_val = C{13}; % 0-8 (with '999' for no response)
        data = [Partner trust_val RT];
        
        misses = length(find(data(:,2)==999));
        data(data(:,2)==999,:) = [];
        trust_val = data(:,2);
        Partner = data(:,1);
        RT = data(:,3);
        logRT = log(RT);
        avg_comp = mean(trust_val(Partner==1,1));
        avg_stranger = mean(trust_val(Partner==2,1));
        avg_friend = mean(trust_val(Partner==3,1));
        avg_comp_logRT = mean(logRT(Partner==1,1));
        avg_stranger_logRT = mean(logRT(Partner==2,1));
        avg_friend_logRT = mean(logRT(Partner==3,1));
        avg_comp_RT = mean(RT(Partner==1,1));
        avg_stranger_RT = mean(RT(Partner==2,1));
        avg_friend_RT = mean(RT(Partner==3,1));
        tmp_data(r,:) = [avg_comp avg_stranger avg_friend avg_comp_logRT avg_stranger_logRT avg_friend_logRT avg_comp_RT avg_stranger_RT avg_friend_RT misses];
        
        
        % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));
        
    end
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));
    
end
fclose(fid_subj);
fclose(fid_run);


