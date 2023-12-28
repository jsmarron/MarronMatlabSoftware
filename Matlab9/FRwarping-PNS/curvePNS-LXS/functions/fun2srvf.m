function [srvf] = fun2srvf(fInput,xgrid)
% convert function to SRVF
% - LXS

binsize = mean(diff(xgrid));
[d,n] = size(fInput);
srvf = zeros(d-1,n);
for i = 1:n;
    dev = diff(fInput(:,i))/binsize;
    srvf(:,i) = sqrt(abs(dev)).*sign(dev);
end;


