sublist = [104 105 106 107 108 109 110 111 112 113 115 116 ...
    117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 140 141 142 ...
    143 144 145 147 149:159];

%sublist = [130 131 132];

% no 139?


fname = sprintf('summary_misses_task-trust.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,run,misses\n');
for s = 1:length(sublist)
    convertTrust_BIDS(sublist(s))
end
fclose(fid);

fname = sprintf('summary_misses_task-sharedreward.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,run,misses\n');
for s = 1:length(sublist)
    convertSharedReward_BIDS(sublist(s))
end
fclose(fid);

fname = sprintf('summary_misses_task-ultimatum.csv');
fid = fopen(fname,'w');
fprintf(fid,'sub,run,misses\n');
for s = 1:length(sublist)
    convertUG_BIDS(sublist(s))
end
fclose(fid);
