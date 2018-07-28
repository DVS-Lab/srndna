function convertUG_BIDS(subj)
maindir = pwd;

try
    
    if ~ischar(subj)
        subj = num2str(subj);
    end
    fname = fullfile(maindir,'data',subj,['sub' subj '_task-ultimatum_raw.csv']);
    fid = fopen(fname,'r');
    C = textscan(fid,repmat('%f',1,17),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
    fclose(fid);
    
    % Partner is Friend=3, Stranger=2, Computer=1
    % "Feedback" is the offer value (out of $20)
    
    onset = C{12};
    iti = C{7}; % if > 1, it's the beginning of a new block
    RT = C{17} - C{12};
    duration = C{15};
    IsFairBlock = C{3};
    Partner = C{6};
    PartnerKeeps = C{2};
    Offer = C{5};
    response = C{16};
    
    task = 'UG';
    fname = sprintf('sub-%03d_task-%s_events.tsv',subj,task);
    fid = fopen(fullfile(maindir,'output',fname),'w');
    fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\n');
    for t = 1:length(onset);
        
        %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
        if (IsFairBlock(t) == 1) && (Partner(t) == 1)
            trial_type = 'computer_fair';
        elseif (IsFairBlock(t) == 1) && (Partner(t) == 2)
            trial_type = 'stranger_fair';
        elseif (IsFairBlock(t) == 1) && (Partner(t) == 3)
            trial_type = 'friend_fair';
        elseif (IsFairBlock(t) == 0) && (Partner(t) == 1)
            trial_type = 'computer_unfair';
        elseif (IsFairBlock(t) == 0) && (Partner(t) == 2)
            trial_type = 'stranger_unfair';
        elseif (IsFairBlock(t) == 0) && (Partner(t) == 3)
            trial_type = 'friend_unfair';
        end
        
        % 1 is reject
        % 2 is accept
        
        if ~isnan(response(t))
            if response(t) == 1
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%d\n',onset(t),duration(t),['event_accept_' trial_type],RT(t),PartnerKeeps(t),Offer(t));
            elseif response(t) == 2
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%d\n',onset(t),duration(t),['event_reject_' trial_type],RT(t),PartnerKeeps(t),Offer(t));
            end
        else
            fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%d\n',onset(t),duration(t),'missed_trial',3.5,PartnerKeeps(t),999);
        end
        if iti(t) > 1
            fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%d\n',onset(t),31,['block_' trial_type],999,999,999);
        end
        
    end
    fclose(fid);
    
catch ME
    disp(ME.message)
    keyboard
end