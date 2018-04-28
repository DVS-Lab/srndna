
maindir = pwd;

fid = fopen('UG_901_final_run_1.csv','r');
C = textscan(fid,repmat('%f',1,15),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
fclose(fid);

% Partner is Friend=3, Stranger=2, Computer=1
% "Feedback" is the offer value (out of $20)

onset = C{9};
iti = C{6}; % if > 1, it's the beginning of a new block
RT = C{12} - C{9};
duration = C{14};
%trialtype --> C{2} is IsFairBlock and C{5} is Partner
IsFairBlock = C{2};
Partner = C{5};
PartnerKeeps = C{1};
Offer = C{4};
%response --> C{13} --> accept/reject? 1/2?
response = C{13};

subnum = 901;
task = 'UG';

fname = sprintf('sub-%03d_task-%s_events.tsv',subnum,task);
fid = fopen(fullfile(maindir,fname),'w');
fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
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

