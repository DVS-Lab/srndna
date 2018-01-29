
ntrials = 36; 
choice_dur = 3;
ISI_list = [repmat(2,1,18) repmat(4,1,10) repmat(6,1,6) repmat(8,1,2)];
ISI_list = ISI_list(randperm(length(ISI_list)));
ITI_list = [repmat(2,1,18) repmat(4,1,10) repmat(6,1,5) repmat(8,1,2) 10];
ITI_list = ITI_list(randperm(length(ITI_list)));

choice_pairs = combnk([0 1 2 4],2);
trial_mat = [choice_pairs ones(6,1)*3 ones(6,1);
             choice_pairs ones(6,1)*3 zeros(6,1);
             choice_pairs ones(6,1)*2 ones(6,1);
             choice_pairs ones(6,1)*2 zeros(6,1);
             choice_pairs ones(6,1)*1 ones(6,1);
             choice_pairs ones(6,1)*1 zeros(6,1)];
    
fid = fopen('design_test.csv','w');
fprintf(fid,'Trial,cLow,cHigh,Partner,Reciprocate,ISI,ITI\n');
% Partner is Friend=3, Stranger=2, Computer=1
% Reciprocate is Yes=1, No=0
% cLow is the low-value option
% cHigh is the high-value option

rand_trials = randperm(ntrials);
for i = 1:ntrials
    fprintf(fid,'%d,%d,%d,%d,%d,%d,%d\n',i,trial_mat(rand_trials(i),:),ISI_list(rand_trials(i)),ITI_list(rand_trials(i)));
end
fclose(fid);


