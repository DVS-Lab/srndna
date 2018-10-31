clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'trust_summary_run.csv');
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,run,avg_comp,avg_stranger,avg_friend,misses\n');
fname = fullfile(maindir,'trust_summary_subj.csv');
fid_subj = fopen(fname,'w');
fprintf(fid_subj,'subnum,avg_comp,avg_stranger,avg_friend,avg_misses\n');

sublist = [104 105 106 107 108 109 110 112 113];
for s = 1:length(sublist)
    
    subj = sublist(s);
    if subj == 106
        runs = 3;
    elseif subj == 109 || subj == 110
        runs = 2;
    else
        runs = 5;
    end
    
    tmp_data = zeros(runs,4);
    for r = 1:runs
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-trust_run-%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        % RT = C{16}; % will do something with this later
        % partner is 1 (computer), 2 (stranger), 3 (friend)
        Partner = C{4};
        trust_val = C{13}; % 0-8 (with '999' for no response)
        data = [Partner trust_val];
        
        misses = length(find(data(:,2)==999));
        data(data(:,2)==999,:) = [];
        trust_val = data(:,2);
        Partner = data(:,1);
        avg_comp = mean(trust_val(Partner==1,1));
        avg_stranger = mean(trust_val(Partner==2,1));
        avg_friend = mean(trust_val(Partner==3,1));
        tmp_data(r,:) = [avg_comp avg_stranger avg_friend misses];
        
        % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));
        
    end
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f\n',subj,mean(tmp_data));
    
end
fclose(fid_subj);
fclose(fid_run);
