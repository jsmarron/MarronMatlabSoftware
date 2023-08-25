function [fh, ess, sig2] = sss2fhSM(data,h,iout) 
% SSSFHSM, Function for SSS2, this gets basic smooth and Effective Sample Size
%     Does Gaussian convolution smoothing of image data
%   Steve Marron's matlab function
%     Note:  the assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
%            For "Cartesian style coordinates", answer is still
%                   the same, since are working with matrices
% Inputs:
%     data - matrix of image data
%        h - bandwidth (of circular Gaussian kernel)
%     iout - index for output (optional)
%                    -1  - just do smooth, no effective sample size
%             not given  - no variance est.        (but do ESS)
%                     0  - pooled variance est.    (but do ESS)
%                     1  - local variance est.     (but do ESS)
% Outputs:
%       fh - matrix of smoothed data
%      ess - matrix of "effective sample sizes"
%     sig2 - (optional) estimated variance, always a matrix,
%                                    except empty when iout not given
%
% Assumes path can find personal functions:
%    k2dgSM
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004



if nargin >= 3     %  then use input value
  iiout = iout ;
else               %  use default value
  iiout = nan ;
end


n = size(data,1) ;
          %  number of rows of data matrix (i.e. y-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. x-values)


%  set up common kernel matrix
%
mker = k2dgSM(((1-n):(n-1))',(m-1):-1:(1-m),h) ;


%  get smooth of data
%
fh = conv2(mker,data,'valid') ;
          %  f_h (hat)



if iiout ~= -1     %  then do ESS calculations


  %  get effective sample size
  %
  nwdenom = conv2(mker,ones(n,m),'valid') ;
          %  Nadaraya - Watson denominator (# of pts. in window)
  ess = nwdenom / mker(n,m) ;
          %  effective sample size


  if nargin >= 3    %  then have made a variance request

    resid2 = (data - fh).^2 ;

    meanresid2 = mean(mean(resid2)) ;
    resid2 = resid2 - meanresid2 ;
          %  subtract out mean to reduce boundary effects


    sig2 = conv2(mker,resid2,'valid') ;
          %  smooth of squared residuals

    sig2 = sig2 + meanresid2 ;
          %  bring mean back after smoothing

    sig2 = sig2 .* ess ./ (ess - 1) ;
          %  make variance estimate unbiased  
          %  by correction by factor   n / (n - 1)



    if iiout == 0    %  Then need to pool

      sig2 = sum(sum(ess .* sig2)) ;
      sig2 = sig2 / sum(sum(ess)) ;
          %  ess - weighted average of sig2, i.e. pooled estimate

      sig2 = sig2 * ones(n,m) ;
           %  expand back to full matrix

    end

  else    %  then no variance request, so return empty matrix

    sig2 = [] ;

  end

else       %  have done no ess or var calcs

  ess = [] ;
  sig2 = [] ;

end

