function [fhii, fhij, fhjj, sigii2, sigij2, sigjj2, coviijj] = sss2fh2SM(data,h,sig2) 
% SSS2FH2SM, Function for SSS2, this gets 2nd partial derivatives
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
%                    fhxx = fhjj
%                    fhxy = fhij
%                    fhyy = fhii
%                  sigxx2 = sigjj2
%                  sigxy2 = sigij2
%                  sigyy2 = sigii2
%                 covxxyy = coviijj
% Inputs:
%     data - matrix of image data
%        h - bandwidth (of circular Gaussian kernel)
%     sig2 - (local) variance estimate (optional):
%                   n x m matrix of variance estimates
% Outputs:
%      fhii - 2nd partial in i,i (vertical,vertical) direction
%      fhij - 2nd partial in i,j (vertical,horizontal) direction
%      fhjj - 2nd partial in j,j (horizontal,horizontal) direction
%    sigii2 - estimated variance of fhii  (CAUTION: empty when sig2 not given)
%    sigij2 - estimated variance of fhij  (CAUTION: empty when sig2 not given)
%    sigjj2 - estimated variance of fhjj  (CAUTION: empty when sig2 not given)
%    coviijj - estimated covariance of fhii and fhjj
%                                         (CAUTION: empty when sig2 not given)
%
% Assumes path can find personal functions:
%    k2dgSM
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004


n = size(data,1) ;
          %  number of rows of data matrix (i.e. i-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. j-values)



miiker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,11) ;
fhii = conv2(miiker,data,'valid') ;
          %  f_h,ii (hat)   (2nd partial in i, vertical, direction)

mijker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,12) ;
fhij = conv2(mijker,data,'valid') ;
          %  f_h,ij (hat)   (2nd partial in i and j directions)

mjjker = k2dgSM(((1-n):(n-1))',(1-m):(m-1),h,22) ;
fhjj = conv2(mjjker,data,'valid') ;
          %  f_h,jj (hat)   (2nd partial in j, horizontal direction)



if nargin >= 3    %  then get variance est's

  sigii2 = conv2(miiker.^2,sig2,'valid') ;
          %  sigma_ii^2
  sigij2 = conv2(mijker.^2,sig2,'valid') ;
          %  sigma_ij^2
  sigjj2 = conv2(mjjker.^2,sig2,'valid') ;
          %  sigma_jj^2
  coviijj = conv2(miiker.*mjjker,sig2,'valid') ;
          %  cov_ii,jj

end



