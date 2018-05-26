
maindir = pwd;

% Partner is Friend=3, Stranger=2, Computer=1
% Reciprocate is Yes=1, No=0
% cLeft is the left option
% cRight is the right option
% high/low value option will randomly flip between left/right

fid = fopen('srn_nicole_test_run_1.csv','r');
C = textscan(fid,[repmat('%f',1,11) '%s%s%f%s' repmat('%f',1,5)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
fclose(fid);

outcomeonset = C{18}; % should be locked to the presentation of the partner cue (at least 500 ms before choice screen)
choiceonset = C{11}; % should be locked to the presentation of the partner cue (at least 500 ms before choice screen)
RT = C{14} - C{11}; % not currently being recorded correctly (choice_dur)
choice_dur = C{14}; % see above
Partner = C{4};
reciprocate = C{3};
response = C{15}; % high/low -- build in check below to check recording
trust_val = C{13}; % 0-8 (with 'NA' for no response)
cLeft = C{6};
cRight = C{8};
options = [cLeft cRight];

subnum = 902;
task = 'trust';
runnum = '01';

fname = sprintf('sub-%03d_task-%s_run-%s_events.tsv',subnum,task,runnum);
fid = fopen(fullfile(maindir,fname),'w');
fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\ttrust_value\tchoice\n');
for t = 1:length(choiceonset);
    
    % output check
    if ~strcmp(trust_val{t},'NA')
        if strcmp(response{t},'high') && (max(options(t,:)) ~= str2double(trust_val{t}))
            error('response output incorrectly recorded for trial %d', t)
        end
    end
    
    if (Partner(t) == 1)
        trial_type = 'computer';
    elseif (Partner(t) == 2)
        trial_type = 'stranger';
    elseif (Partner(t) == 3)
        trial_type = 'friend';
    end
    
    % "String values containing tabs MUST be escaped using double quotes.
    % Missing and non applicable values MUST be coded as "n/a"."
    % http://bids.neuroimaging.io/bids_spec.pdf
    
    %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\ttrust_value\tchoice\n');
    if strcmp(trust_val{t},'NA')
        fprintf(fid,'%f\t%f\t%s\t%f\t%s\t%s\n',choiceonset(t),3,'missed_trial',3,'n/a','n/a');
    else
        if strcmp(trust_val{t},'0')
            fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',choiceonset(t),RT(t),['choice_' trial_type ],RT(t),0,response{t}); %should always be 'low'
        else
            if reciprocate(t) == 1
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',choiceonset(t),RT(t),['choice_' trial_type],RT(t),str2double(trust_val{t}),response{t});
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',outcomeonset(t),1,['outcome_' trial_type '_recip'],RT(t),str2double(trust_val{t}),response{t});
            else
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',choiceonset(t),RT(t),['choice_' trial_type],RT(t),str2double(trust_val{t}),response{t});
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',outcomeonset(t),1,['outcome_' trial_type '_defect'],RT(t),str2double(trust_val{t}),response{t});
            end
        end
    end
    
end
fclose(fid);

