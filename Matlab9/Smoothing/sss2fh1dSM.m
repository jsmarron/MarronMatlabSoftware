function [fhi, fhj, sigi2, sigj2] = sss2fh1dSM(data,h) 
% SSS2FH1DSM, Function for SSS, this gets 1st partial derivatives
%                 Density estimation version
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
%     data - matrix of binned data (e.g. by sss1bin.m)
%        h - bandwidth (of circular Gaussian kernel)
% Outputs:
%      fhi - partial in i (vertical) direction
%      fhj - partial in j (horizontal) direction
%    sigi2 - estimated variance of fhi  (CAUTION: empty when sig2 not given)
%    sigj2 - estimated variance of fhj  (CAUTION: empty when sig2 not given)
%
% Assumes path can find personal functions:
%    k2dgSM
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004



n = size(data,1) ;
          %  number of rows of data matrix (i.e. i-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. j-values)
ndat = sum(sum(data)) ;
          %  number of data points = sum of bin counts


miker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,1) ;
fhi = conv2(miker,data,'valid') / ndat ;
          %  f_h,i (hat)   (partial in i direction)

mjker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,2) ;
fhj = conv2(mjker,data,'valid') / ndat ;
          %  f_h,j (hat)   (partial in j direction)


if nargout > 2    %  then get variance est's

  sigi2 = conv2(miker.^2,data,'valid') / ndat ;
          %  2nd moment part
  sigi2 = sigi2 - fhi.^2 ;
  sigi2 = sigi2 / (ndat - 1) ;
          %  sigma_i^2

  sigj2 = conv2(mjker.^2,data,'valid') / ndat ;
          %  2nd moment part
  sigj2 = sigj2 - fhj.^2 ;
  sigj2 = sigj2 / (ndat - 1) ;
          %  sigma_j^2


end



