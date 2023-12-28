function [fh, ess, sig2] = sss2fhdSM(data,h,iout) 
% SSS2FHDSM, Function for SSS, this gets basic smooth and Effective Sample Size
%                     for Density estimation
%     Does Gaussian convolution smoothing of binned data
%   Steve Marron's matlab function
%     Note:  the assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
%            For "Cartesian style coordinates", answer is still
%                   the same, since are working with matrices
% Inputs:
%     data - matrix of binned data (e.g. by sss1bin.m)
%        h - bandwidth (of circular Gaussian kernel)
%     iout - index for output (optional)
%                    -1  -  just do smooth, no effective sample size
%      (not given or) 0  - no variance est.              (but do ESS)
%                     1  - local variance est. of fh     (and do ESS)
% Outputs:
%       fh - matrix of smoothed data
%      ess - matrix of "effective sample sizes"
%     sig2 - estimated local variances, always a matrix
%

%    Copyright (c) J. S. Marron 1999, 2001



if nargin >= 3 ;     %  then use input value
  iiout = iout ;
else ;               %  use default value
  iiout = 0 ;
end ;



n = size(data,1) ;
          %  number of rows of data matrix (i.e. y-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. x-values)
ndat = sum(sum(data)) ;
          %  number of data points = sum of bin counts



%  set up common kernel matrix
%
mker = k2dgSM(((1-n):(n-1))',(m-1):-1:(1-m),h) ;


%  get smooth of data
%
fh = conv2(mker,data,'valid') ;
          %  f_h (hat)



if iiout ~= -1 ;     %  then do ESS calculation


  %  get effective sample size
  %
  ess = fh / mker(n,m) ;
          %  effective sample size


  if iiout == 1 ;    %  then do variance calculation

    sig2 = conv2(mker.^2,data,'valid') / ndat ;
          %  2nd moment part

    sig2 = sig2 - (fh / ndat).^2 ;

    sig2 = sig2 / (ndat - 1) ;

  else ;

    sig2 = [] ;

  end ;

else ;       %  have done no ess or var calcs

  ess = [] ;
  sig2 = [] ;

end ;



fh = fh / ndat ;
          %  put on scale of a density estimate



