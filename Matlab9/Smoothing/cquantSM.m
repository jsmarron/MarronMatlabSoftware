function vquant = cquantSM(data,vprob,isort) 
% CQUANT, Continuous empirical QUANTiles.
%   Steve Marron's matlab function
%      Calculates "how far through the 1-d data set in 'data'",
%      an element with prob vprob is, assuming the underlying 
%      distribution is continuous.  When there are no ties in 
%      data (expected unless there is rounding), the i-th order 
%      statistic of 'data' is at prob i / (n + 1) (motivated by 
%      putting mass 1 / (n + 1) between each order stat, and 
%      also by the fact that for U_(i) i-th i.i.d. Unif(0,1),
%      order stat, E(U_(i)) = 1 / (n+1)) and everything in 
%      between is linearly interpolated (with linear extension 
%      at the ends).  When there are ties in the data, points
%      are combined before interpolation (so the resulting cdf is
%      continuous).
%      
%      Useful for generating bootstrap data.
% Inputs:
%     data  - column vector, a 1-d data set
%     vprob  - column vector of probabilities, 
%                            whose quantiles are desired
%     isort - flag indicating need to sort:
%                0  ===>  Don't need to sort
%                        !!!  DATA ASSUMED TO BE IN INCREASING ORDER  !!!
%                1  ===>  Data unsorted, so first do a sort
%                            (default, when isort not specified)
% Output:
%     vquant  - column vector of quantiles 
%                    (corresponding to rows of vx)
%                for x = X_(i),      returns i / (n + 1)  
%                linearly interpolated between, and extended linearly
%                to endpoints (from nearest two order stats).
%
% For inverse of this (over probs in [0,1]), use cprobSM.m

%    Copyright (c) J. S. Marron 1997, 2004, 2023


%  Check have a column vector input
if size(data,2) > 1 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!  Error from cquantSM.m   !!!') ;
  disp('!!!  Input  data  must be    !!!') ;
  disp('!!!  a column vector         !!!') ;
  disp('!!!  Terminating Execution   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vquant = [] ;
  return ;
end 

%  Now decide whether or not to sort, based on number of inputs
if nargin == 2 
  iisort = 1 ;       %  default is to sort, when isort unpsecified    
else 
  iisort = isort ;   %  use input value
end 

%  Do sort if needed
if iisort ~= 0     %  then do a sort
  sdata = sort(data) ;
else               %  data assumed to be already sorted
  sdata = data ;  
end 

%  Set up initial parameters
n = size(sdata,1) ;    %  number of rows in data matrix (#obs each set)
np = length(vprob) ;
vquant = zeros(np,1) ;  %  initialize output quantile vector

%  Assign probs to order statistics
vdatp = linspace(1 / (n + 1),1 - 1 / (n + 1),n) ;

%  Handle possible ties by averaging probs over tied values
tdata(1) = sdata(1) ;
tvdatp(1) = vdatp(1) ;
nintie = 1 ;
          %  number in last tie
for i = 2:n     %  loop through rest of data

  if sdata(i) == sdata(i - 1)    %  then have tie with last
    tvdatp(length(tvdatp)) = ...
                 (nintie / (nintie + 1)) * tvdatp(length(tvdatp)) + ...
                 (1 / (nintie + 1)) * vdatp(i) ; %#ok<AGROW>
          %  replace current prob by weighted average of probs already
          %  here, and new prob
    nintie = nintie + 1 ;
          %  now have one more in last tie

  else                           %  then have no tie with last

  tdata = [tdata; sdata(i)] ; %#ok<AGROW>
          %  No tie, so tack on new data point
  tvdatp = [tvdatp; vdatp(i)] ; %#ok<AGROW>
          %  No tie, so tack on new prob
  nintie = 1 ;
          %  number in last tie

  end 

end 
tn = length(tdata) ;



if length(tdata) == 1     %  then all data points are same

  disp('!!!   Warning from cquantSM: all input same   !!!') ;
  disp('!!!   Returning that value for all probs      !!!') ;
  vquant = tdata(1) * ones(np,1) ;

else    %  have at least two different data points

  %  Move out endpoints according to last piecwise line
  tdata(1) = (tvdatp(2) / (tvdatp(2) - tvdatp(1))) * tdata(1) - ...
             (tvdatp(1) / (tvdatp(2) - tvdatp(1)))  * tdata(2) ;
  tdata(tn) = ...
      ((1 - tvdatp(tn-1)) / (tvdatp(tn) - tvdatp(tn-1))) * tdata(tn) - ...
      ((1 - tvdatp(tn)) / (tvdatp(tn) - tvdatp(tn-1)))  * tdata(tn-1) ;
  tvdatp(1) = 0 ;
  tvdatp(tn) = 1 ;

  %  Handle interior x's
  flag = ((0 < vprob) & (vprob < 1)) ;
          %  flags prob's in interior
  vquant(flag) = interp1(tvdatp,tdata,vprob(flag)) ;

  %  Handle prob's below zero
  flag = (vprob <= 0) ;
          %  flags prob's below 0
  vquant(flag) = tdata(1) * ones(sum(flag),1) ;

  %  Handle prob's above one
  flag = (1 <= vprob) ;
          %  flags prob's above 1
  vquant(flag) = tdata(tn) * ones(sum(flag),1) ;

end 

