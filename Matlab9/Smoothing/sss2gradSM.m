function [vsigg, marrow, msiggloc] = sss2gradSM(data,h,pixpar,ess,sig2,alpha,idatyp) 
% SSSGRAD, Function for SSS2, this gets arrow matrix for significant gradient
%     First does 1st partials of Gaussian convolution smoothing
%     Then does test of significance
%     Finally gets info for plotting arrows
%   Steve Marron's matlab function
%     Note:  this assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
% Inputs:
%     data - matrix of image data
%        h - bandwidth (of circular Gaussian kernel)
%   pixpar - parameter for pixel block size:
%                  1 - single pixels
%                  2 - 2x2 blocks of pixels
%      ess - matrix of Effective Sample Sizes at each pixel location
%     sig2 - matrix estimate of noise level sigma
%    alpha -  Usual "level of significance".  I.e. C.I.s have coverage
%                  probability 1 - alpha.  (0.05 when not specified)
%   idatyp - index of data type:
%                  1 - regression
%                  2 - density estimation
% Outputs:
%    vsigg - column vector with one where gradient is significant
%                   (one entry for each possible block of pixels,
%                             thus n*m for pixpar = 1, 
%                             and (n/2)*(m/2) for pixpar = 2)
%                   (use reshape(vsigg,n,m) or reshape(vsigg,no2,mo2) to
%                             get usual matrix)
%   marrow - matrix with significant arrow information, 
%                   (one row for each arrow,
%                             column 1:  corresponding index in vsigg
%                             column 2:  i location of center
%                             column 3:  j location of center
%                             column 4:  i direction
%                             column 5:  j direction
%                                    (directions are normalized to [0,1],
%                                       and "quartered" when pixpar = 2)
%    msiggloc - 3 column matrix, one row for each pixel
%                    column 1:  one when gradient is significant
%                    column 2:  i location of center (vert. "y" coord.)
%                    column 3:  j location of center (horiz. "x" coord.)
%
% Assumes path can find personal functions:
%    sss2fh1SM
%    sss2fh1dSM
%    k2dgSM
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004


n = size(data,1) ;
          %  number of rows of data matrix (i.e. i-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. j-values)


%  Get 1st partial derivatives
%
if idatyp == 1    %  then are doing regression
  [fhi,fhj,si2,sj2] = sss2fh1SM(data,h,sig2) ;
elseif idatyp == 2    %  then are doing density estimation
  [fhi,fhj,si2,sj2] = sss2fh1dSM(data,h) ;
end



%  Protect against sparse data problems
%
smallessflag = ess < 5 ;
          %  ones where ess < 5, i.e. where are looking for significance ;
nsmalless = sum(sum(smallessflag)) ;
          %  number of locations where too few data points
if nsmalless > 0
          %  then need to guard against small denominators

  si2(smallessflag) = ones(nsmalless,1) ;
  sj2(smallessflag) = ones(nsmalless,1) ;
          %  replace variance estimate by one at sparse data locations
          %  Note:  anything appearing here will be set circled out

end

zerovarflag = (si2 == 0)  |  (sj2 == 0) ;
          %  ones where the variance is 0 
          %  (happens when one pixel has data, but no other data
          %          within the kernel window)
nzerovar = sum(sum(zerovarflag)) ;
          %  number of locations where variance is 0
if nzerovar > 0
  si2(zerovarflag) = ones(nzerovar,1) ;
  sj2(zerovarflag) = ones(nzerovar,1) ;
          %  replace variance estimate by one at sparse data locations
          %  Note:  anything appearing here will be set circled out
end




g2 = fhi.^2 ./ si2 + fhj.^2 ./ sj2 ;
          %  square of normalized gradient of fh




if nzerovar > 0     %  then need to set some g2's to zeros,
                    %  since want no significant gradient at
                    %  isolated points
  g2(zerovarflag) = zeros(nzerovar,1) ;
end




%  Do test of significance of gradient
%
essnosmalless = ess(~smallessflag) ;
l = (n * m - nsmalless) / mean(essnosmalless) ;
          %  number of independent blocks
qg = -2 * log(1 - (1 - alpha)^(1/l)) ;
          %  chi^2,2 critical value for gradient statistic

mgtestsig = (g2 > qg) ;
          %   puts a one where test of gradient non-zero is significant



if pixpar == 1    %  Then need one arrow for each pixel

  %  First main output
  %
  vsigg = reshape(mgtestsig,n*m,1) ;
          %  column vector version of mgtestsig, rows where ones exist are
          %  indexed by first column of marrow,
          %  to get back, use:     mgtestsig = reshape(vsigg,n,m) ;

  %  get vector of indices (into vsigg), where have significant gradient
  %
  vind = [vsigg, (1:length(vsigg))'] ;
          %  add on column with (all) indices


  %  get center points
  %
  icent = vec2matSM((1:n)',m) ;
  jcent = vec2matSM((1:m),n) ;

  icent = reshape(icent,n*m,1) ;
  jcent = reshape(jcent,n*m,1) ;


  %  get directions
  %
  magvel = abs(fhi + i * fhj) ; %#ok<IJCL>
          %  velocity vector length

  %  Protect against 0 derivatives
  %
  zeroderivflag = (magvel == 0) ;
          %  ones where will get 0 divide
  nzeroderiv = sum(sum(zeroderivflag)) ;
          %  number of locations where will get 0 divide
  if nzeroderiv > 0
          %  then need to guard against 0 division
    magvel(zeroderivflag) = ones(nzeroderiv,1) ;
          %  replace magvle by one at 0 locations
          %  Note:  this will not affect final answer, since
          %  have no significance here, so
          %  these points will be truncated from marrow below
  end

  idir = fhi ./ magvel ;
  jdir = fhj ./ magvel ;
          %  make length 1 (right for pixel scale)

  idir = reshape(idir,n*m,1) ;
  jdir = reshape(jdir,n*m,1) ;





elseif pixpar == 2   %  then work on 2x2 blocks

  %  First decimate to 2x2 grid
  %
  mo2 = floor(m/2) ;
  no2 = floor(n/2) ;

  icent = reshape((1:(2*no2))',2,no2)' ;
  icent = mean(icent') ; %#ok<UDIM>
          %  midpoints of 2 x 2 blocks
  icent = vec2matSM(icent',mo2) ;
  icent = reshape(icent,no2*mo2,1) ;

  jcent = reshape((1:(2*mo2))',2,mo2)' ;
  jcent = mean(jcent') ; %#ok<UDIM>
          %  midpoints of 2 x 2 blocks
  jcent = vec2matSM(jcent,no2) ;
  jcent = reshape(jcent,no2*mo2,1) ;

  fhidec = conv2(fhi,(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  fhidec = fhidec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  fhjdec = conv2(fhj,(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  fhjdec = fhjdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  mgtestsigdec = conv2(double(mgtestsig),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  mgtestsigdec = mgtestsigdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers


  %  First main output
  %
  vsigg = reshape(mgtestsigdec,no2*mo2,1) ;
          %  column vector version of mgtestsigdec,
          %  rows where entry > 0 are
          %  indexed by first column of marrow,
          %  to get back, use:     mgtestsigdec = reshape(vsigg,no2,mo2) ;
          %      (gives proportion of number sig in 2 x 2 block)
  vsigg = (vsigg > 0) ;
          %  Keep only ones where have something significant


  %  get vector of indices (into vsigg), where have significant gradient
  %
  vind = [vsigg, (1:length(vsigg))'] ;
          %  add on column with indices


  %  get directions
  %
  magvel = abs(fhidec + i * fhjdec) ; %#ok<IJCL>
          %  velocity vector length

  %  Protect against 0 derivatives
  %
  zeroderivflag = (magvel == 0) ;
          %  ones where will get 0 divide
  nzeroderiv = sum(sum(zeroderivflag)) ;
          %  number of locations where will get 0 divide
  if nzeroderiv > 0
          %  then need to guard against 0 division
    magvel(zeroderivflag) = ones(nzeroderiv,1) ;
          %  replace magvle by one at 0 locations
          %  Note:  this will not affect final answer, since
          %  have no significance here, so
          %  these points will be truncated from marrow below
  end

  idir = mgtestsigdec .* fhidec ./ magvel ;
  jdir = mgtestsigdec .* fhjdec ./ magvel ;
          %  make length 1, the "quarter" depending on how many in block
          %         are significant
  idir = reshape(idir,no2*mo2,1) ;
  jdir = reshape(jdir,no2*mo2,1) ;


end 



%  2nd main output
%
marrow = [vind, icent, jcent, idir, jdir] ;
marrow = marrow((vind(:,1) > 0),:) ;
          %  delete rows where none of the gradients are signficant
marrow = marrow(:,(2:6)) ;
          %  cutoff first column (all 1's)



%  3rd main output
%
msiggloc = [vsigg, icent, jcent] ;

