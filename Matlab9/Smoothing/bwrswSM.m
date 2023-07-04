function hrsw = bwrswSM(data,piflag,xgridp,eptflag) 
% BWRSW, Ruppert Sheather Wand Plug In (Binned version), for 1-d reg.
%   Steve Marron's matlab function
%     Does data-based bandwidth selection for 1-d local linear reg.
%     estimation, using the Ruppert Sheather Wand Plug In method.
%     A linear binned implementation is used.
%   Assumes a Gaussian kernel.  Returns twice range when n <= 5
%   Can use first 1, 2, 3, 4 or 5 arguments.
% Inputs:
%     data   - n x 2 matrix of Xs (1st col) and Ys (2nd col)
%     piflag - flag for plug-in type:
%                  0 (or not specified)  -  "Direct Plug In"
%                             (Recommended by Ruppert, Sheather and Wand)
%                 -1  -  "Rule Of Thumb"  (simpler version)
%     xgridp - vector of parameters for binning grid:
%                  0 (or not specified)  -  use endpts of data and 401 bins
%                  [le; lr]  -  le is left end, re is right, 401 bins
%                         (get error message and no return if le > lr)
%                  [le; lr; nb] - le left, re right, and nb bins
%    eptflag - endpoint truncation flag (only has effect when imptyp = 0):
%                  0 (or not specified)  -  move data outside range to
%                                   nearest endpoint
%                  1  -  truncate data outside range
% Output:
%     hrsw  -  Ruppert Sheather Wand Plug In bandwidth choice
%              when it is in the interval [binwidth,2*range]
%              otherwise uses "sensible endpoint" of that interval
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    lbinrSM.m
%    nprSM.m

%    Copyright (c) J. S. Marron 1997-2023


%  Set parameters and defaults according to number of input arguments
%
if nargin == 1     %  only 1 argument input, use default plug in flag
  ipiflag = 0 ;
else               %  plug in flag was specified, use that
  ipiflag = piflag ;
end 

if nargin <= 2     %  at most 2 arguments input, use default xgrid params
  ixgridp = 0 ;
else               %  xgrid was specified, use that
  ixgridp = xgridp ;
end 

if nargin <= 3     %  at most 3 arguments input, use default endpt trunc
  ieptflag = 0 ;    %  Default
else 
  ieptflag = eptflag ;    %  Endpt trunc was specified, so use it
end 



%  Set parameters, and constants
alpha = .05 ;
          %  Truncation constant, recco'd by RSW.
nobs = size(data,1) ;
Nstar = 5 ;
          %  Recco from RSW: "may want to raise if feel there
          %            are many oscillations".
Nmax = max([min([floor(nobs / 20), Nstar]), 1]) ;
          %  Max number of blocks to try, another Recco of RSW

c1k = (1 / (2 * sqrt(pi))).^(1/5) ;
c2k = (3 / (8 * sqrt(pi))).^(1/7) ;
c3k = (4 * (1/2 + 2 * sqrt(2) - 4 * sqrt(3) / 3) / sqrt(2 * pi)).^(1/9) ;



%  Set endpts
%
nbin = 401 ;    %  standard default
if length(ixgridp) > 1    %  then have read in endpoints, so use them
  lend = ixgridp(1) ;
  rend = ixgridp(2) ;
  if length(ixgridp) == 3    %  then have read in numbe of bins, so use
    nbin = ixgridp(3) ;
  end    %  otherwise use above default
else   %  default to data endpoints
  lend = min(data(:,1)) ;
  rend = max(data(:,1)) ;
end 
ixgridp = [lend; rend; nbin] ;
          %  reset this for later calls


%  Set bounds on "reasonable range of bandwidths"
%
hmax = rend - lend ;
          %  range of data (or interval of interest)
hmin = hmax / nbin ;
          %  binwidth ;
hmax = 2 * hmax ;
          %  twice range



%  First check sample large enough to calculate this
%
if nobs <= 5 
          %  sample size is too small for some denominators below
  disp('!!!   Warning from bwrswb:  sample size is too small   !!!') ;
  disp('!!!            Returning twice range as answer         !!!') ;
  hrsw = hmax ;

else    %  sample size OK, so proceed


  %  Sort data, for blockwise operations
  %    (this seems wasteful, because often data are presorted, but
  %     some tests showed this goes very fast for n up to 10000, and
  %     and took only 2-3 secs for 100000).
  %
  [~, vind] = sort(data(:,1)) ;
  sdata = data(vind,:) ;


  %  Get chosen type of bandwidth
  %
  if ipiflag == -1     %  Then do Rule of Thumb version
    vrss = [] ;
    vs2q = [] ;
    vt22q = [] ;
    for N = 1:Nmax     %  Loop through potential numbers of blocks
      vimax = round((1:(N-1))' * nobs / N) ;
      vimin = [1; (vimax + 1)] ;
          %  vector of starting indices for each block
      vimax = [vimax; nobs] ;
          %  vector of ending indices for each block
      rss = 0 ;
      t22q = 0 ;
          %  set to 0 so they can be summed
      for iblk = 1:N     %  Loop through blocks
        imin = vimin(iblk) ;
        imax = vimax(iblk) ;
        vdata = sdata(imin:imax,:) ;
          %  data in this block

        vdavg = mean(vdata(:,1)) ;
        vdma = vdata(:,1) - vdavg ;
          %  shift back so centered at origin
          %        (avoids instability, from all large values)
        p4coeffs = polyfit(vdma,vdata(:,2),4) ;
          %  coefficients of fit of quartic to shifted block
          %            (poly of deg 4)

        mq = polyval(p4coeffs,vdata(:,1)-vdavg) ;
          %  quartic fit, evaluated at data
        m2q = polyval(polyder(polyder(p4coeffs)),vdata(:,1)-vdavg) ;
          %  2nd deriv of quartic fit, evaluated at the data

        rss = rss + sum((vdata(:,2) - mq).^2) ;
          %  add to RSS
        t22q = t22q + sum(m2q.^2) ;
          %  add to theta22 estimate
      end   
      s2q = rss / (nobs - 5 * N) ;
      t22q = t22q / nobs ;

      vrss = [vrss; rss] ;
      vs2q = [vs2q; s2q] ;
      vt22q = [vt22q; t22q] ;
    end 
    vcp = (vrss /(vrss(Nmax) / (nobs - 5 * Nmax))) - ...
                                  (nobs - 10 * (1:Nmax)') ;
          %  RSW version of mallows Cp
    [~, Nhat] = min(vcp) ;
          %  get Nhat to minimize Cp
    s2q = vs2q(Nhat) ;
    t22q = vt22q(Nhat) ;


    %  Guard against denom too small
    if (abs(t22q) * nobs / std(data(:,2))) > eps   
                %  then 2nd derive estimate is large enough, so proceed
      hrsw = c1k * (s2q * (rend - lend) / (t22q * nobs)).^(1/5) ;
    else            %  funny denom, give error message, return upper bound
      disp('!!!   Warning from bwrswb:  t22q is too small   !!!') ;
      disp('!!!       Returning twice range as answer       !!!') ;
      hrsw = hmax ;
    end 


  else     %  Then do Direct Plug In


    %    Start step 1
    vrss = [] ;
    vs2q = [] ;
    vt24q = [] ;
    for N = 1:Nmax     %  Loop through potential numbers of blocks
      vimax = round((1:(N-1))' * nobs / N) ;
      vimin = [1; (vimax + 1)] ;
            %  vector of starting indices for each block
      vimax = [vimax; nobs] ;
            %  vector of sending indices for each block
      rss = 0 ;
      t24q = 0 ;
          %  set to 0 so they can be summed
      for iblk = 1:N     %  Loop through blocks
        imin = vimin(iblk) ;
        imax = vimax(iblk) ;
        vdata = sdata(imin:imax,:) ;
          %  data in this block

        vdavg = mean(vdata(:,1)) ;
        vdma = vdata(:,1) - vdavg ;
          %  shift back so centered at origin
          %        (avoids instability, from all large values)
        p4coeffs = polyfit(vdma,vdata(:,2),4) ;
          %  coefficients of fit of quartic to shifted block
          %            (poly of deg 4)

        mq = polyval(p4coeffs,vdata(:,1)-vdavg) ;
          %  quartic fit, evaluated at data
        m2q = polyval(polyder(polyder(p4coeffs)),vdata(:,1)-vdavg) ;
          %  2nd deriv of quartic fit, evaluated at the data
        m4q = p4coeffs(1) * 4 * 3 * 2 ;
          %  4th deriv of quartic fit, evaluated at data (since const.)

        rss = rss + sum((vdata(:,2) - mq).^2) ;
          %  add to RSS
        t24q = t24q + sum(m2q * m4q) ;
          %  add to theta24 estimate
      end   
      s2q = rss / (nobs - 5 * N) ;
      t24q = t24q / nobs ;

      vrss = [vrss; rss] ;
      vs2q = [vs2q; s2q] ;
      vt24q = [vt24q; t24q] ;
    end 
    vcp = (vrss /(vrss(Nmax) / (nobs - 5 * Nmax))) - ...
                                  (nobs - 10 * (1:Nmax)') ;
          %  RSW version of mallows Cp
    [~, Nhat] = min(vcp) ;
          %  get Nhat to minimize Cp
    s2q = vs2q(Nhat) ;
    t24q = vt24q(Nhat) ;
          %  this finishes step 1 in RSW


    %    Start step 2
    %
    %  First guard against denom too small
    if (abs(t24q) * nobs / std(data(:,2))) > eps 
                %  then 4th deriv. estimate is large enough, so proceed

      %         First bin the data
      bncts = lbinrSM(sdata,ixgridp,ieptflag) ;

      %        Estimate theta 22
      gamse = c2k * (s2q * (rend - lend) / (abs(t24q) * nobs))^(1/7) ;
      %    here come lines from nprSM.m:
      %  Create vector of kernel values, at equally spaced grid
      delta = (rend - lend) / (nbin - 1) ;    %  binwidth
      k = nbin - 1 ;    %  index of last nonzero entry of kernel vector
      arg = linspace(0,k * delta / gamse,k + 1)' ;
      kvec0 = exp(-(arg.^2) / 2) / sqrt(2 * pi) ;
      arg = arg * gamse ;
      kvec1 = kvec0 .* arg ;
      kvec2 = kvec1 .* arg ;
      kvec3 = kvec2 .* arg ;
      kvec4 = kvec3 .* arg ;
      kvec5 = kvec4 .* arg ;
      kvec6 = kvec5 .* arg ;

      kvec0 = [flipud(kvec0(2:k+1)); kvec0] ;
            %  construct symmetric kernel
      s0 = conv(bncts(:,1),kvec0) ;
      s0 = s0(k+1:k+nbin) ;
      sy0 = conv(bncts(:,2),kvec0) ;
      sy0 = sy0(k+1:k+nbin) ;

      kvec1 = [-flipud(kvec1(2:k+1)); kvec1] ;
            %  skew-symmetric here!
      s1 = conv(bncts(:,1),kvec1) ;
      s1 = s1(k+1:k+nbin) ;
      sy1 = conv(bncts(:,2),kvec1) ;
      sy1 = sy1(k+1:k+nbin) ;

      kvec2 = [flipud(kvec2(2:k+1)); kvec2] ;
            %  construct symmetric kernel
      s2 = conv(bncts(:,1),kvec2) ;
      s2 = s2(k+1:k+nbin) ;
      sy2 = conv(bncts(:,2),kvec2) ;
      sy2 = sy2(k+1:k+nbin) ;

      kvec3 = [-flipud(kvec3(2:k+1)); kvec3] ;
            %  skew-symmetric here!
      s3 = conv(bncts(:,1),kvec3) ;
      s3 = s3(k+1:k+nbin) ;
      sy3 = conv(bncts(:,2),kvec3) ;
      sy3 = sy3(k+1:k+nbin) ;

      kvec4 = [flipud(kvec4(2:k+1)); kvec4] ;
            %  construct symmetric kernel
      s4 = conv(bncts(:,1),kvec4) ;
      s4 = s4(k+1:k+nbin) ;

      kvec5 = [-flipud(kvec5(2:k+1)); kvec5] ;
            %  skew-symmetric here!
      s5 = conv(bncts(:,1),kvec5) ;
      s5 = s5(k+1:k+nbin) ;

      kvec6 = [flipud(kvec6(2:k+1)); kvec6] ;
            %  construct symmetric kernel
      s6 = conv(bncts(:,1),kvec6) ;
      s6 = s6(k+1:k+nbin) ;

      denom = s0 .* (s2.*s4.*s6 + s3.*s5.*s4 + s4.*s3.*s5 ...
                       - s4.*s4.*s4 - s3.*s3.*s6 - s2.*s5.*s5) ;
      denom = denom - s1 .* (s1.*s4.*s6 + s3.*s5.*s3 + s4.*s2.*s5 ...
                       - s3.*s4.*s4 - s2.*s3.*s6 - s1.*s5.*s5) ;
      denom = denom + s2 .* (s1.*s3.*s6 + s2.*s5.*s3 + s4.*s2.*s4 ...
                       - s3.*s3.*s4 - s2.*s2.*s6 - s1.*s4.*s5) ;
      denom = denom - s3 .* (s1.*s3.*s5 + s2.*s4.*s3 + s3.*s2.*s4 ...
                       - s3.*s3.*s3 - s2.*s2.*s5 - s1.*s4.*s4) ;


      if sum(denom == 0)    %  if any 0 entry in denominator
        disp('!!!   Warning from bwrswb:  gamse is too small   !!!') ;
        disp('!!!         Returning binwidth as answer         !!!') ;
        errflag = -1 ;  
      else 

        numer = s0 .* (s2.*sy2.*s6 + sy1.*s5.*s4 + s4.*s3.*sy3 ...
                         - s4.*sy2.*s4 - s3.*sy1.*s6 - s2.*sy3.*s5) ;
        numer = numer - s1 .* (s1.*sy2.*s6 + sy1.*s5.*s3 + s4.*s2.*sy3 ...
                         - s3.*sy2.*s4 - s2.*sy1.*s6 - s1.*sy3.*s5) ;
        numer = numer + sy0 .* (s1.*s3.*s6 + s2.*s5.*s3 + s4.*s2.*s4 ...
                         - s3.*s3.*s4 - s2.*s2.*s6 - s1.*s4.*s5) ;
        numer = numer - s3 .* (s1.*s3.*sy3 + s2.*sy2.*s3 + sy1.*s2.*s4 ...
                         - s3.*s3.*sy1 - s2.*s2.*sy3 - s1.*s4.*sy2) ;

        m2hat = numer ./ denom ;
              %  coefficient of quadratic term in cubic fit
        m2hat = 2 * m2hat ;
              %  estimate of m'' by local cubic fit
          bcents = linspace(lend,rend,nbin) ;
              %  bin centers
          [~, ia] = min(abs(bcents - ((1 - alpha) * lend + alpha * rend))) ;
              %  index of bin corresponding to alpha way through range
          [~, i1ma] = min(abs(bcents - (alpha * lend + (1 - alpha) * rend))) ;
              %  index of bin corresponding to 1 - alpha way through range
        tbncts = bncts(ia:i1ma,1) ;
              %  alpha truncated bincts
        t22 = sum(m2hat(ia:i1ma).^2 .* tbncts) ;
              %  binned version as in sec 6 of RSW
        t22 = t22 / nobs ;
  
        %        Estimate sig2
        %
        %  First guard against denom too small
        if (abs(t22) * nobs / std(data(:,2))) > eps 
                %  then 2nd deriv. estimate is large enough, so proceed
          lamamse = c3k * (s2q^2 * (rend - lend) / (t22^2 * nobs^2))^(1/9) ;
          paramstruct = struct('vh',lamamse,...
                               'vxgrid',ixgridp,...
                               'imptyp',-1) ;
                                         %  -1 for using already binned data
          mhat = nprSM(bncts,paramstruct) ;
        else     %  want "infinite bandwidth" here,
                 %  so just use linear at bincoutns
          lincoeffs = polyfit(vdata(:,1),vdata(:,2),1) ;
            %  coefficients of linear fit
          mhat = polyval(lincoeffs,linspace(lend,rend,nbin)') ;
            %  linear fit, evaluated at data
        end 
        s21 = sum(data(:,2).^2)  ;
        s21 = s21 - 2 * sum(mhat .* bncts(:,2)) ;
        s21 = s21 + sum(mhat.^2 .* bncts(:,1)) ;
              %  binned version as in sec 6 of RSW
        s21 = s21 / (nobs - 5 * N) ;
              %  this finishes step 2 in RSW

        errflag = 0 ;    %  finish usual calculation

      end 

    else      %  Then denom was too small, so return large bandwidth
      disp('!!!   Warning from bwrswb:  t24q is too small   !!!') ;
      disp('!!!        Returning twice range as answer      !!!') ;
      errflag = 1 ;   

    end 

    %    Step 3
    if errflag == -1     %  then seems h is too small, return binwidth
      hrsw = hmin ;
    elseif errflag == 1     %  then seems h is too big, return twice range
      hrsw = hmax ;
    else 
      hrsw = c1k * (s21 * (rend - lend) / (t22 * nobs)).^(1/5) ;
    end 

  end 

end 


%  Check final answer is within "acceptable range", if not then adjust
%
if hrsw < hmin 
  disp('!!!   Warning from bwrswb:  final result too small   !!!') ;
  disp('!!!           Returning binwidth as answer           !!!') ;
  hrsw = hmin ;
elseif hrsw > hmax 
  disp('!!!   Warning from bwrswb:  final result too large   !!!') ;
  disp('!!!         Returning twice range as answer          !!!') ;
  hrsw = hmax ;
end 

