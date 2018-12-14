clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'ultimatum_summary_run99_2018_InOut_pvsrt.csv');
fid_run = fopen(fname,'w'); % csv uses commas (,) and tsv uses tabs (\t)
fprintf(fid_run,'subnum,run,avg_comp_fair,avg_diffage_fair,avg_sameage_fair,avg_comp_unfair,avg_diffage_unfair,avg_sameage_unfair,avg_comp_fair_RT,avg_diffage__fair_RT,avg_sameage_fair_RT,avg_comp_unfair_RT,avg_diffage_unfair_RT,avg_sameage_unfair_RT,misses\n');
fname = fullfile(maindir,'ultimatum_summary_subj_99_2018InOutpvsrt.csv');
fid_subj = fopen(fname,'w');
fprintf(fid_subj,'subnum,avg_comp_fair,avg_diffage_fair,avg_sameage_fair,avg_comp_unfair,avg_diffage_unfair,avg_sameage_unfair,avg_comp_fair_RT,avg_diffage_fair_RT,avg_sameage_fair_RT,avg_comp_unfair_RT,avg_diffage_unfair_RT,avg_sameage_unfair_RT,misses\n');

%sublist = [104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121 122 124 125 126];
sublist = [104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121 122 124 125 126 204 205 206 207 208 209 210 211 212 213 215 216 217 218 220 221 222 224 225 226];
for s = 1:length(sublist)

    subj = sublist(s);
    runs = 2;

    tmp_data = zeros(runs,13);
    for r = 1:runs
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-ultimatum_run-%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);

        RT = C{12};
        Partner = C{5}; % partner is 1 (computer), 2 (different age), 3 (same age)
        fairness = C{2}; % fair == 1, unfair == 0
        ultimatum_val = C{11}; % 2.0-3.0 (with '999' for no response)
        data = [Partner ultimatum_val RT fairness]; 

        misses = length(find(data(:,2)==999));
        data(data(:,2)==999,:) = [];
        ultimatum_val = data(:,2);
        ultimatum_val = ultimatum_val - 2; % 1 == accept, 0 == reject
        Partner = data(:,1);
        RT = data(:,3);
        fairness = data(:,4);
        logRT = log(RT);
        avg_comp_fair = mean(ultimatum_val(Partner==1 & fairness==1,1));
        avg_diffage_fair = mean(ultimatum_val(Partner==2 & fairness==1,1));
        avg_sameage_fair = mean(ultimatum_val(Partner==3 & fairness==1,1));
        avg_comp_unfair = mean(ultimatum_val(Partner==1 & fairness==0,1));
        avg_diffage_unfair = mean(ultimatum_val(Partner==2 & fairness==0,1));
        avg_sameage_unfair = mean(ultimatum_val(Partner==3 & fairness==0,1));
        avg_comp_fair_logRT = mean(logRT(Partner==1 & fairness==1,1));
        avg_diffage_fair_logRT = mean(logRT(Partner==2 & fairness==1,1));
        avg_sameage_fair_logRT = mean(logRT(Partner==3 & fairness==1,1));
        avg_comp_unfair_logRT = mean(logRT(Partner==1 & fairness==0,1));
        avg_diffage_unfair_logRT = mean(logRT(Partner==2 & fairness==0,1));
        avg_sameage_unfair_logRT = mean(logRT(Partner==3 & fairness==0,1));
        tmp_data(r,:) = [avg_comp_fair,avg_diffage_fair,avg_sameage_fair,avg_comp_unfair,avg_diffage_unfair,avg_sameage_unfair,avg_comp_fair_logRT,avg_diffage_fair_logRT,avg_sameage_fair_logRT,avg_comp_unfair_logRT,avg_diffage_unfair_logRT,avg_sameage_unfair_logRT,misses];

        % subnum,run,avg_comp_fair,avg_diffage_fair,avg_sameage_fair,avg_comp_unfair,avg_diffage_unfair,avg_sameage_unfair,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));

    end
    % subnum,avg_comp_fair,avg_diffage_fair,avg_sameage_fair,avg_comp_unfair,avg_diffage_unfair,avg_sameage_unfair,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));

    subj = sublist(s);
    runs = 2;

    % tmp_data = zeros(runs,12);
    % for r = 1:runs
      % fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03_task-ultimatum_run-%d_raw.csv',subj,r-1));
      % fid = fopen(fname,'r');
     % C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
     % fclose(fid);
    % end

end
fclose(fid_subj);
fclose(fid_run);
