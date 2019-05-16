function [fq] = srvf2fun(qInput,xgrid,fmean0,itype)
%
% LXS Tools
% convert SRVF to function


binsize = mean(diff(xgrid)) ;
[M N] = size(qInput);
inte = zeros([N M+1]);
integrand = qInput.*abs(qInput);
for i = 1:N;
    qqi = integrand(:,i);
    inte(i,:) = [0,cumsum(qqi)'*binsize];
    % adjust
    inte(i,:) = inte(i,:)/max(inte(i,:));
end;
fm0 = ones([N M+1])*fmean0;
fq = fm0' + inte';





