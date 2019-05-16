function [fhi, fhj, sigi2, sigj2] = sss2fh1SM(data,h,sig2) 
% SSSFH1, Function for SSS2, this gets 1st partial derivatives
%     Does Gaussian convolution smoothing of image data
%   Steve Marron's matlab function
%     Note:  the assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
%            For "Cartesian style coordinates", where
%                   indices are (xgrid,ygrid), 
%                              xgrid horizontal (running in columns),
%                              ygrid vertical (running in rows),
%            use assignments:
%                    fhx = fhj
%                    fhy = fhi
%                  sigx2 = sigj2
%                  sigy2 = sigi2
% Inputs:
%     data - matrix of image data
%        h - bandwidth (of circular Gaussian kernel)
%     sig2 - (local) variance estimate (optional):
%                   n x m matrix of variance estimates
% Outputs:
%      fhi - partial in i (vertical) direction
%      fhj - partial in j (horizontal) direction
%    sigi2 - estimated variance of fhi  (CAUTION: empty when sig2 not given)
%    sigj2 - estimated variance of fhj  (CAUTION: empty when sig2 not given)
%
% Assumes path can find personal functions:
%    k2dgSM
%    vec2matSM

%    Copyright (c) J. S. Marron 1998, 2001, 2004


n = size(data,1) ;
          %  number of rows of data matrix (i.e. i-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. j-values)


miker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,1) ;
fhi = conv2(miker,data,'valid') ;
          %  f_h,i (hat)   (partial in i direction)

mjker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,2) ;
fhj = conv2(mjker,data,'valid') ;
          %  f_h,j (hat)   (partial in j direction)


if nargin == 3 ;    %  then get variance est's

  sigi2 = conv2(miker.^2,sig2,'valid') ;
          %  sigma_i^2
  sigj2 = conv2(mjker.^2,sig2,'valid') ;
          %  sigma_j^2

end ;



