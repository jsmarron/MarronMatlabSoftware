function rm = rmeanSM(data,xacc,nstep,iwrite) 
% RMEAN, Robust M-estimation version of the multivariate sample MEAN
%     Gives a robust estimate of the mean in arbitrary dimensions
%   Can use 1, 2 or 3 arguments.
%   Steve Marron's matlab function
% Inputs:
%     data - vector or matrix of data, each row is a d dimensional vector,
%                 the number of data points, n, is the number of rows
%     xacc - relative accuracy, when last step was smaller 
%                 than this, then quit (default = 10^(-6))
%    nstep - maximum number of steps to take (default = 20)
%   iwrite - index for screen writes:
%               0 - no screen writes
%               1 - write to screen at each step (default)
% Output:
%       rm - robust estimate of the mean
%
% Assumes path can find personal functions:
%    vec2matSM.m

%    Copyright (c) J. S. Marron 1998, 2001, 2023


%  Set parameters according to number of input arguments
%
if nargin == 1       %  only 1 argument input, use defaults
  ixacc = 10^(-6) ;
  instep = 20 ;
  iiwrite = 1 ;
elseif nargin == 2
  ixacc = xacc ;
  instep = 20 ;
  iiwrite = 1 ;
elseif nargin == 3
  ixacc = xacc ;
  instep = nstep ;
  iiwrite = 1 ;
elseif nargin == 4    % then all values input, use those
  ixacc = xacc ;
  instep = nstep ;
  iiwrite = iwrite ;
end



%  start with mean 
%
n = size(data,1) ;
          %  number of data points is number of rows
d = size(data,2) ;
          %  dimensionality is the number of columns
rm = mean(data) ;
          %  starting value of robust mean estimate


%  do iterative M-estimation improvement
%
for is = 1:instep      %  improve M-estimate

  rmold = rm ;


  %  set up weights
  %
  if d == 1
    vwt = data - rmold ;
  else
    vwt = data - vec2matSM(rmold,n) ;
  end
  if d == 1
    vwt = vwt .^ 2 ;
  else
    vwt = sum(vwt' .^2)' ;
          %  column vector of sum of squares along each row
  end
  vwt = 1 ./ sqrt(vwt) ;
          %  n x 1 vector of weights for M-estimation
  denom = sum(vwt) ;
          %  denominator of final average


  %  Get weighted average
  %
  rm = (vwt' * data) / denom ;
          %  1 x d vector 


  %  Check error, to quit
  %
  abserr = sum(abs(rm - rmold)) ;

  if iiwrite == 1
    disp(['        RMEAN, step ' num2str(is) ...
                      ' gave abs error = ' num2str(abserr)]) ;
  end

  if abserr / sqrt(rm * rm') <= ixacc
                %  then should jump out of loop:
    break ;
          %  terminates execution of loop
  end

end





