
% 18 blocks
pre_block_ITI = [repmat(8,1,9) repmat(10,1,6) repmat(12,1,3)]; % some IBI jitter to estimate reward/punishment separately (HCP is fixed at 15 s)
pre_block_ITI = pre_block_ITI(randperm(length(pre_block_ITI)));
% this occurrs every 8 trials, starting with trial 1. it should come first
% need to add at least 12 s at the end of the experiment to catch last HRF


block_types = [1:6 1:6 1:6]; %will name these below. 3 partners * 2 outcomes
block_types = block_types(randperm(length(block_types)));
keep_checking = 1;
while keep_checking
    repeats = 0;
    block_types = block_types(randperm(length(block_types)));
    for i = 1:length(block_types)-1
        if block_types(i) == block_types(i+1)
            repeats = repeats + 1;
        end
    end
    if ~repeats
        keep_checking = 0;
    end
end


fid = fopen('UG_design_test.csv','w');
fprintf(fid,'Trialn,Blockn,Partner,IsFairBlock,Offer,ITI\n');

nblocks = length(block_types);
rand_trials = randperm(nblocks);
t = 0;
for i = 1:nblocks
    % Partner is Friend=3, Stranger=2, Computer=1
    % Feedback is Reward=3, Neutral=2, Punishment=1
    
    fair = [16 17 18 19 20];
    unfair = [4 5 6 7 8];

    
    punishment = [1 1 1 1 1 1 randsample([2 3],1) randsample([2 3],1)];
    punishment = punishment(randperm(length(punishment)));
    reward = [3 3 3 3 3 3 randsample([2 1],1) randsample([2 1],1)];
    reward = reward(randperm(length(reward)));
    
    switch block_types(i)
        case 1 %Computer Punishment
            partner = 1;
            feedback_mat = punishment;
        case 2 %Computer Reward
            partner = 1;
            feedback_mat = reward;
        case 3 %Stranger Punishment
            partner = 2;
            feedback_mat = punishment;
        case 4 %Stranger Reward
            partner = 2;
            feedback_mat = reward;
        case 5 %Friend Punishment
            partner = 3;
            feedback_mat = punishment;
        case 6 %Friend Reward
            partner = 3;
            feedback_mat = reward;
    end
    
    for f = 1:length(feedback_mat)
        t = t + 1;
        if f == length(feedback_mat)
            fprintf(fid,'%d,%d,%d,%d,%d\n',t,i,partner,feedback_mat(f),pre_block_ITI(i));
        else
            fprintf(fid,'%d,%d,%d,%d,%d\n',t,i,partner,feedback_mat(f),1);
        end
    end
end
fclose(fid);


