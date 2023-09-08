function [ADval]=ADStatQF(vari)

% This function is used to caclulate the Anderson Darling Test Statistics of
% Standard Normal distribution

%    Copyright (c) Qing Feng & J. S. Marron 2014-2023

n = length(vari);

if n < 7
    disp( 'Sample size must be greater than 7.' );
    return,
else
    vari = sort(vari) ;
    f = normcdf(vari, mean(vari), std(vari)) ;
    i = 1:n;
    S = sum((((2*i)-1)/n).*(log(f)+log(1-f(n+1-i)))) ;
    ADval = -n-S;
end

end

