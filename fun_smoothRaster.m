% smoothraster
% last update: 16-Jan-2022
% Mohammad Shams
% m.shamsahmar@gmail.com

function sA = fun_smoothRaster(A,sw,method)

switch nargin
    case 2
        method = 'moving';            
end

for irow = 1:size(A,1)
    sA(irow,:) = smooth(A(irow,:),sw,method);
end