
maindir = pwd;

fid = fopen('SR_srn_nicole_test_run_1.csv','r');
C = textscan(fid,repmat('%f',1,15),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
fclose(fid);

% Partner is Friend=3, Stranger=2, Computer=1
% Feedback is Reward=3, Neutral=2, Punishment=1


onset = C{8};
iti = C{3}; % if > 1, it's the beginning of a new block
RT = C{12} - C{8};
duration = C{14};
block_types = C{5};
Partner = C{4};
feedback = C{2};
response = C{13}; % coded as 2 and 3; what is high/low? 

subnum = 902;
task = 'SharedReward';

fname = sprintf('sub-%03d_task-%s_events.tsv',subnum,task);
fid = fopen(fullfile(maindir,fname),'w');
fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\n');
for t = 1:length(onset);
    
    %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\n');
    if (feedback(t) == 1) && (Partner(t) == 1)
        event_type = 'computer_punish';
    elseif (feedback(t) == 1) && (Partner(t) == 2)
        trial_type = 'stranger_punish';
    elseif (feedback(t) == 1) && (Partner(t) == 3)
        trial_type = 'friend_punish';
    elseif (feedback(t) == 2) && (Partner(t) == 1)
        trial_type = 'computer_neutral';
    elseif (feedback(t) == 2) && (Partner(t) == 2)
        trial_type = 'stranger_neutral';
    elseif (feedback(t) == 2) && (Partner(t) == 3)
        trial_type = 'friend_neutral';
    elseif (feedback(t) == 2) && (Partner(t) == 1)
        trial_type = 'computer_reward';
    elseif (feedback(t) == 2) && (Partner(t) == 2)
        trial_type = 'stranger_reward';
    elseif (feedback(t) == 2) && (Partner(t) == 3)
        trial_type = 'friend_reward';
    end
    
    switch block_types(t)
        case 1, block_type = 'computer_punish';
        case 2, block_type = 'computer_reward';
        case 3, block_type = 'stranger_punish';
        case 4, block_type = 'stranger_reward';
        case 5, block_type = 'friend_punish';
        case 6, block_type = 'friend_reward';
    end
    
    if ~isnan(response(t))
        fprintf(fid,'%f\t%f\t%s\t%f\n',onset(t),duration(t),['event_' trial_type],RT(t));
    else
        fprintf(fid,'%f\t%f\t%s\t%s\n',onset(t),duration(t),'missed_trial','n/a');
    end
    if iti(t) > 1
        fprintf(fid,'%f\t%f\t%s\t%s\n',onset(t),31.45,['block_' block_type],'n/a');
    end
    
end
fclose(fid);

