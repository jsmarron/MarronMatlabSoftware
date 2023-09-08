function [final_vari, eval] = autotransfuncQF(vari, istat, paraindex)
 % This function is used for transforming each individual variable

%    Copyright (c) Qing Feng & J. S. Marron 2014-2023

i = paraindex;
[d,n] = size(vari) ;
beta = sign(i)*(exp(abs(i))-1);
alpha = abs(1/beta);

% get the interquartile range of the values in the data vector
iqrange_vari = iqr(vari);

% use the interquartile range as the data range if not zero 
% otherwise use the full data range
if iqrange_vari == 0
    range_vari = range(vari);
else
    range_vari = iqrange_vari;
end

% transform based on the sign of beta       
 if beta == 0
     vark1 = vari;
 elseif beta > 0
     vark1 = log(vari-min(vari)+alpha*range_vari);
 else
     vark1 = -log(max(vari)-vari+alpha*range_vari);
 end  
         
 % standardize transformed data vector 
 mabd = mean(abs(vark1 - median(vark1))) ;
 mabd = mabd* sqrt(pi / 2) ;
 
 if mabd == 0
     final_vari = zeros(d, n) ;
 else
     vark1 = (vark1 - median(vark1)) / mabd ;
     % winsorise transformed data vector
     p95 = evinv(0.95,0,1) ;
     ak = (2*log(n*d))^(-0.5) ;
     bk = (2*log(n*d) - log(log(n*d)) - log(4*pi))^0.5;
     TH = p95*ak+bk;
     vark1(vark1>TH) = repmat(TH, 1, sum(vark1>TH)) ;
     vark1(vark1<-TH) = repmat(-TH, 1, sum(vark1<-TH)) ;
     % re-standardize by substract the mean and divide by standard deviation
     final_vari  = (vark1 - mean(vark1)) / std(vark1) ;     
 end

 
 % calculate evaluation stat
 if istat == 1
     eval = ADStatQF(final_vari) ;
 elseif istat == 2
     eval = skewness(final_vari) ;
 end
 
