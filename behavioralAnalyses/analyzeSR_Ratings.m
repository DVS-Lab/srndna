clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'SR_summary_Ratings_SANS.csv');
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,comp_win,stranger_win,friend_win,comp_loss,stranger_loss,friend_loss\n');
%fname = fullfile(maindir,'trust_summary_subj_11_2018InOut.csv');
%fid_subj = fopen(fname,'w');
%fprintf(fid_subj,'subnum,avg_comp,avg_stranger,avg_friend,avg_comp_RT,avg_stranger_RT,avg_friend_RT,misses\n');

%sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121];
%sublist = [103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 120 121 204 205 206 207 208 209 210 211 212 213 215 216 217 218 220 221];
sublist = [103 104];

for s = 1:length(sublist)
    
    subj = sublist(s);
    tmp_data = zeros(2,6);
    %for r = 1:runs
    fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub%03d_SR-Ratings-2.csv',subj));
    fid = fopen(fname);
    C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
    fclose(fid);
    
    % partner is 1 (computer), 2 (stranger), 3 (friend)
    Partner = C{2};
    Outcome = C{3}; % 0-8 (with '999' for no response)
    Rating = C{6};
    data = [Partner Outcome Rating];
    
    %misses = length(find(data(:,2)==999));
    %data(data(:,2)==999,:) = [];
    outcome_type = data(:,2);
    Partner = data(:,1);
    Rating = data(:,3);
    comp_win = Rating(Partner==1 & outcome_type==0);
    stranger_win = Rating(Partner==2 & outcome_type==0);
    friend_win = Rating(Partner==3 & outcome_type==0);
    comp_loss = Rating(Partner==1 & outcome_type==1);
    stranger_loss = Rating(Partner==2 & outcome_type==1);
    friend_loss = Rating(Partner==3 & outcome_type==1);
    tmp_data = [comp_win stranger_win friend_win comp_loss stranger_loss friend_loss];
    
    % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_run,'%d,%f,%f,%f,%f,%f,%f\n',subj,tmp_data);
        
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    %fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));
    
end
%fclose(fid_subj);
fclose(fid_run);


