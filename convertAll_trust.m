% convert all trust
sublist = [104 105 106 107 108 109 110 112 113 111 115 116 ...
    117 118 120 121 122 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 140 141 142];
% no 139?
for s = 1:length(sublist)
    convertTrust_BIDS(sublist(s)); % scanner participant
    if sublist(s) == 129 || sublist(s) == 138
        continue
    else
        convertTrust_BIDS(sublist(s) + 100); % friend outside
    end
    %pay_subject(sublist(s));
end


