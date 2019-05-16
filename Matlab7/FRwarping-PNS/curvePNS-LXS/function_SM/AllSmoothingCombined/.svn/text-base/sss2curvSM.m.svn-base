function [vsigc, mdot] = sss2curvSM(data,h,pixpar,ess,sig2,alpha,idatyp) 
% SSS2CURVSM, Function for SSS2, this gets dot matrix for significant curvature
%     First does 2nd partials of Gaussian convolution smoothing
%     Then does test of significance
%     Finally gets info for plotting dots
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
%    alpha   -  Usual "level of significance".  I.e. C.I.s have coverage
%                  probability 1 - alpha.  (0.05 when not specified)
%   idatyp - index of data type:
%                  1 - regression
%                  2 - density estimation
% Outputs:
%    vsigc - column vector with one where curvature is significant
%                   (one entry for each possible block of pixels,
%                             thus n*m for pixpar = 1, 
%                             and (n/2)*(m/2) for pixpar = 2)
%                   (use reshape(vsigg,n,m) or reshape(vsigg,no2,mo2) to
%                             get usual matrix)
%     mdot - matrix with significant dot information, 
%                   (one row for each dot,
%                             column 1:  corresponding index in vsigc
%                             column 2:  code of significance type:
%                                                 00 - 0 
%                                                 ++ - 1 
%                                                 +0 - 2 
%                                                 +- - 3 
%                                                 -0 - 4 
%                                                 -- - 5 
%                             column 3:  x location of center
%                             column 4:  y location of center
%
% Assumes path can find personal functions:
%    sss2fh2SM
%    sss2fh2dSM
%    vec2matSM
%    k2dgSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004


n = size(data,1) ;
          %  number of rows of data matrix (i.e. i-values)
m = size(data,2) ;
          %  number of cols of data matrix (i.e. j-values)



%  Get 2nd partial derivatives
%
if idatyp == 1 ;    %  then are doing regression
  [fhii,fhij,fhjj,sii2,sij2,sjj2,ciijj] = sss2fh2SM(data,h,sig2) ;
elseif idatyp == 2 ;    %  then are doing density estimation
  [fhii,fhij,fhjj,sii2,sij2,sjj2,ciijj] = sss2fh2dSM(data,h) ;
end ;



%  Get variance estimate, pooled across derivatives
%
sigoa = sqrt((sii2/3 + sij2 + sjj2/3 + ciijj) / 4) ;
          %  Overall value, combined from nontrivial components
          %  Recall sii2 and sjj2 are estimates of 3 times this value




%  Protect against sparse data problems
%
smallessflag = ess < 5 ;
          %  ones where ess < 5, i.e. where are looking for significance ;
nsmalless = sum(sum(smallessflag)) ;
          %  number of locations where too few data points
if nsmalless > 0 ;
          %  then need to guard against small denominators

  sigoa(smallessflag) = ones(nsmalless,1) ;
          %  replace variance estimate by one at sparse data locations
          %  Note:  anything appearing here will be set circled out

end ;



%  Do test of significance of curvature
%
fhii =  fhii ./ sigoa ;
fhij =  fhij ./ sigoa ;
fhjj =  fhjj ./ sigoa ;
          %  puts these on this scale of the tabulated distribution

mb = fhii + fhjj ;
rt = sqrt((fhii - fhjj).^2 + 4 * fhij.^2) ;
lam1 = (mb + rt) / 2 ;
lam2 = (mb - rt) / 2 ;
          %  matrices of eigenvalues of 2x2 Hessian
          %  note:  lam1 >= lam2

vlam1 = reshape(lam1,1,n*m) ;
vlam2 = reshape(lam2,1,n*m) ;
          %  put in row vector form

vt = max([abs(vlam1); abs(vlam2)]) ;
t = reshape(vt,n,m) ;

%  Critical Values
%
essnosmalless = ess(~smallessflag) ;
l = (n * m - nsmalless) / mean(essnosmalless) ;
          %  number of independent blocks
p = (1 - alpha)^(1/l) ;
          %  tail probability, for l independent variables
load sss1sigcurv2 ;
          %  loads values, computed by sigcurv2.m, for interpolation
          %  Note:  this was formerly called sigcurv2.mat
ml10p = -log10(1 - p) ;
[maxtp, imaxtp] = max(tprob) ;
[mintp, imintp] = min(tprob) ;
if ml10p > maxtp ;      %  can't do interpolation with this range, use endpoint

  qc = vq(imaxtp) ;
          %  take the biggest quantile
  impp = 1 - 10^(-tprob(imaxtp)) ;
          %  value of p implied by biggest q
  impalpha = 1 - impp^l ;
          %  value of alpha implied by impp

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from ssscurv.m:  alpha too small   !!!') ;
  disp('!!!   Using smallest allowed critical level,     !!!') ;
  disp(['!!!   Corresponds to alpha = ' num2str(impalpha) ]) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

elseif ml10p < mintp ;      %  can't do interpolation with this range, use endpoint

  qc = vq(imintp) ;
          %  take the smallest quantile
  impp = 1 - 10^(-tprob(imintp)) ;
          %  value of p implied by biggest q
  impalpha = 1 - impp^l ;
          %  value of alpha implied by impp

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from ssscurv.m:  alpha too big   !!!') ;
  disp('!!!   Using smallest allowed critical level,   !!!') ;
  disp(['!!!   Corresponds to alpha = ' num2str(impalpha) ]) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
 
else ;    %  than can use interpolation

 qc = interp1(tprob,vq,ml10p) ;
          %  gets quantile by interpolation
          %  by old method, based on simulated quantiles
          %  Note:  didn't use fit line method, since c.d.f was too curved    

end ;


mctestsig = (t > qc) ;
          %    puts a one where test of curvature non-zero is significant


%  get significances of individual eigenvalues
%
lam1sp = (lam1 >= qc) ;
lam2sp = (lam2 >= qc) ;
lam1sn = (lam1 <= -qc) ;
lam2sn = (lam2 <= -qc) ;
           %  ones where eigenvalues have given significant

lam1s0 = ~(lam1sp | lam1sn) ;
lam2s0 = ~(lam2sp | lam2sn) ;
          %  ones where neither eignevalue is significant

sigpp = lam1sp & lam2sp ;
sigp0 = lam1sp & lam2s0 ;
sigpn = lam1sp & lam2sn ;
sign0 = lam1s0 & lam2sn ;
signn = lam1sn & lam2sn ;
          %  ones for appropriate pairs

nplus = lam1sp + lam2sp ;
nminus = lam1sn + lam2sn ;
          %  number of significant eigenvalues





if pixpar == 1 ;    %  Then need one dot for each pixel

  %  First main output
  %
  vsigc = reshape(mctestsig,n*m,1) ;
          %  column vector version of mctestsig, rows where ones exist are
          %  indexed by first column of mdot,
          %  to get back, use:     mctestsig = reshape(vsigc,n,m) ;

  %  get vector of indices (into vsigc), where have significant gradient
  %
  vind = [vsigc, (1:length(vsigc))'] ;
          %  add on column with (all) indices


  %  get center points
  %
  icent = vec2matSM((1:n)',m) ;
  jcent = vec2matSM((1:m),n) ;

  icent = reshape(icent,n*m,1) ;
  jcent = reshape(jcent,n*m,1) ;


  %  get sigcodes
  %
  sigcode = zeros(n,m) ;
          %  start with default code of 0 (nothing significant)


  flag = sigpp ;
          %  ones where have ++
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have ++, so put 1 in sigcode
    sigcode(flag) = 1 * ones(nflag,1) ;
  end ;

  flag = sigp0 ;
          %  ones where have +0
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have +0, so put 2 in sigcode
    sigcode(flag) = 2 * ones(nflag,1) ;
  end ;

  flag = sigpn ;
          %  ones where have +-
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have +-, so put 3 in sigcode
    sigcode(flag) = 3 * ones(nflag,1) ;
  end ;

  flag = sign0 ;
          %  ones where have -0
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have -0, so put 4 in sigcode
    sigcode(flag) = 4 * ones(nflag,1) ;
  end ;

  flag = signn ;
          %  ones where have --
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have --, so put 5 in sigcode
    sigcode(flag) = 5 * ones(nflag,1) ;
  end ;

  sigcode = reshape(sigcode,n*m,1) ;


elseif pixpar == 2 ;   %  then work on 2x2 blocks

  %  First decimate to 2x2 grid
  %
  mo2 = floor(m/2) ;
  no2 = floor(n/2) ;

  icent = reshape((1:(2*no2))',2,no2)' ;
  icent = mean(icent') ;
          %  midpoints of 2 x 2 blocks
  icent = vec2matSM(icent',mo2) ;
  icent = reshape(icent,no2*mo2,1) ;

  jcent = reshape((1:(2*mo2))',2,mo2)' ;
  jcent = mean(jcent') ;
          %  midpoints of 2 x 2 blocks
  jcent = vec2matSM(jcent,no2) ;
  jcent = reshape(jcent,no2*mo2,1) ;

  mctestsigdec = conv2(double(mctestsig),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  mctestsigdec = mctestsigdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  nplusdec = conv2(nplus,ones(2,2),'valid') ;
          %  do 2x2 simple sum
  nplusdec = nplusdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  nminusdec = conv2(nminus,ones(2,2),'valid') ;
          %  do 2x2 simple sum
  nminusdec = nminusdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  sigppdec = conv2(double(sigpp),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  sigppdec = sigppdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  sigp0dec = conv2(double(sigp0),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  sigp0dec = sigp0dec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  sigpndec = conv2(double(sigpn),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  sigpndec = sigpndec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  sign0dec = conv2(double(sign0),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  sign0dec = sign0dec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers

  signndec = conv2(double(signn),(ones(2,2) / 4),'valid') ;
          %  do 2x2 simple moving average
  signndec = signndec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers



  %  First main output
  %
  vsigc = reshape(mctestsigdec,no2*mo2,1) ;
          %  column vector version of mctestsigdec,
          %  rows where entry > 0 are
          %  indexed by first column of mdot,
          %  to get back, use:     mctestsigdec = reshape(vsigc,no2,mo2) ;
          %      (gives count of number sig in 2 x 2 block)
  vsigc = (vsigc > 0) ;
          %  Keep only ones where have something significant


  %  get vector of indices (into vsigc), where have significant gradient
  %
  vind = [vsigc, (1:length(vsigc))'] ;
          %  add on column with indices


  %  get sigcodes
  %
  sigcode = zeros(floor(n/2),floor(m/2)) ;
          %  initially set to "no significant curvature"

  npmnm = nplusdec - nminusdec ;
          %  most color rules based on this difference

  flag = (npmnm >= 6) ;
          %  ones where have ++
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have ++, so put 1 in sigcode
    sigcode(flag) = 1 * ones(nflag,1) ;
  end ;

  flag = (3 <= npmnm) & (npmnm <= 5) ;
          %  ones where have +0
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have +0, so put 2 in sigcode
    sigcode(flag) = 2 * ones(nflag,1) ;
  end ;

  flag = (-2 <= npmnm) & (npmnm <= 2) & ...
                                (nplusdec >= 3) & (nminusdec >= 3) ;
          %  ones where have +-
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have +-, so put 3 in sigcode
    sigcode(flag) = 3 * ones(nflag,1) ;
  end ;

  flag = (-5 <= npmnm) & (npmnm <= -3) ;
          %  ones where have -0
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have -0, so put 4 in sigcode
    sigcode(flag) = 4 * ones(nflag,1) ;
  end ;

  flag = (npmnm <= -6) ;
          %  ones where have --
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;    %  then have --, so put 5 in sigcode
    sigcode(flag) = 5 * ones(nflag,1) ;
  end ;


  %  Override these colors, when there is a majority vote >= 3
  %
  flag = sigppdec >= 3 ;      
          %  ones where pp is in the majority
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;  %  if we have some them, then override with ++ code 1
    sigcode(flag) = 1 * ones(nflag,1) ;
  end ;

  flag = sigp0dec >= 3 ;      
          %  ones where p0 is in the majority
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;  %  if we have some them, then override with +0 code 2
    sigcode(flag) = 2 * ones(nflag,1) ;
  end ;

  flag = sigpndec >= 3 ;      
          %  ones where pn is in the majority
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;  %  if we have some them, then override with +- code 3
    sigcode(flag) = 3 * ones(nflag,1) ;
  end ;

  flag = sign0dec >= 3 ;      
          %  ones where n0 is in the majority
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;  %  if we have some them, then override with -0 code 4
    sigcode(flag) = 4 * ones(nflag,1) ;
  end ;

  flag = signndec >= 3 ;
          %  ones where nn is in the majority
  nflag = sum(sum(flag)) ;
  if nflag > 0 ;  %  if we have some them, then override with -- code 5
    sigcode(flag) = 5 * ones(nflag,1) ;
  end ;

  sigcode = reshape(sigcode,no2*mo2,1) ;


end ;



%  2nd main output
%
mdot = [vind, sigcode, icent, jcent] ;
mdot = mdot((vind(:,1) > 0),:) ;
          %  delete rows where none of the gradients are signficant
mdot = mdot(:,(2:5)) ;
          %  cutoff first column (all 1's)



