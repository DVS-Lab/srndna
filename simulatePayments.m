function output = simulatePayments(trust_values,nperms)
% trust_values should be a 1 x 4 numeric array (e.g., [0 1 4 8])
% nperms should be an postive integer (e.g., 1000)

% subject payment simulation %
% by D. Smith & E. Beard 031918



%% What do we know about the Trust Game here?

% How many fake subjects? How many runs? How many trials per run?
subjects = nperms;
runs = 6;
trials = 36;

% What are the possible options? This is what we'll tweak
choice_pairs = combnk(trust_values,2); % these are the only numbers we change.

% What is their initial endowment on each trial? Let's go with the max.
endowment = max(max(choice_pairs));



%% What happens on each run/trial?
% 1) Trustor chooses how much they want to send to the Trustee. How often?
% this is unknown, so let's make it random, with shuffledpayments = Shuffle(choice_pairs)

% 2) Amount sent to the Trustee gets multiplied. What is the multiplier?
multiplier = 3;

% 3) Trustee then reciprocates (sends back half) or defects (keeps all)
% 4) How often does this happen?
reciprocation_rate = 0.5;

% 5) how would this look on a given trial?
%{

shuffledpayments = Shuffle(choice_pairs);
if rand < reciprocation_rate
    payment = 0.5 * (shuffledpayments(1,1) * multiplier); % reciprocate and share half
else
    payment = endowment - shuffledpayments; % defect. here, the get they get 0 if they sent the max
end

%}

% 6) How will the subject be paid?
% Sum across runs. Thus, you need one row per subject in this simulation.
trust_payments = zeros(subjects,1);

%% Now put it together and run the simulation
for s = 1:subjects
    tmp_runs = zeros(runs,1);
    for r = 1:runs
        
        tmp_trials = zeros(trials,1);
        for t = 1:trials
            
            shuffledpayments = Shuffle(choice_pairs);
            if rand < reciprocation_rate
                tmp_trials(t,1) = 0.5 * (shuffledpayments(1,1) * multiplier); % reciprocate and share half
            else
                tmp_trials(t,1) = endowment - shuffledpayments(1,1); % defect. here, the get they get 0 if they sent the max
            end
        end
        tmp_runs(r,1) = randsample(tmp_trials,1);
    end
    trust_payments(s,1) = sum(tmp_runs);
end
output.mean = mean(trust_payments);
output.twostd = std(trust_payments) * 2;
output.max = max(trust_payments);
output.min = min(trust_payments);


