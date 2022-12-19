function [starts ends] = consecutive_ones(x)

% periods of 1 are searched for, for each period the start and end position
% is given

% x contains only ones or zeros
assert(isempty(find(x ~= 1 & x ~= 0)))

% prepare
starts = [];
ends = [];

if isempty(find(x ~= 1))
    starts = 1;
    ends = length(x);
else
    idx_0 = find(x == 0);
    if length(idx_0) == 1 % there is just one zero
        if idx_0 == 1 % at first position
            starts(1) = 2; 
            ends(1) = length(x);
        elseif idx_0 == length(x)
            starts(1) = 1; 
            ends(1) = length(x)-1;
        else % different from first or last position
            starts(1) = 1;
            ends(1) = idx_0 - 1;
            starts(2) = idx_0 + 1;
            ends(2) = length(x);
        end
    else 
        cnt = 0;
        for i=1:length(idx_0)
           
           if i == 1 && idx_0(i) > 1 % there is a one before a zero
               cnt = cnt + 1;
               starts(cnt) = 1;
               ends(cnt) = idx_0(i) - 1;
           elseif idx_0(i) == length(x) % if we are at the last position and there is a zero, there is no other period
               break
           elseif i == length(idx_0) % last round, no other idx_0
               cnt = cnt + 1;
               starts(cnt) = idx_0(i)+1;
               ends(cnt) = length(x);
           elseif idx_0(i+1) -  idx_0(i) == 1 % there is no one between two zeros
               continue
           else
               cnt = cnt + 1;
               starts(cnt) = idx_0(i)+1;
               ends(cnt) = idx_0(i+1)-1;
           end
           
            
        end
    end
end