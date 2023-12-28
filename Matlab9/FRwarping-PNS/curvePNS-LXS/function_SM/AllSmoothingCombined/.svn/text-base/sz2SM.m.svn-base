function [mapout,xgrid,vrowmax] = sz2SM(data,paramstruct) 
% SZ2SM, Significant derivative Zero crossings
%   Steve Marron's matlab function
%     Creates color map (function of location and bandwidth),
%     showing statistical significance of slope of smooth
%     Colored (or gray level) as:
%         blue (dark)    at points where deriv sig > 0
%         red (light)    at points where deriv sig < 0
%         purple (gray)  at points where deriv roughly 0
%         light gray where "effective sample size" < 5
%
% Inputs:
%
%   data        - Case 1: density estimation:
%                     either n x 1 column vector of 1-d data
%                     or vector of bincts, when imptyp = -1
%                 Case 2: regression:
%                     either n x 2 matrix of Xs (1st col) and Ys (2nd col)
%                     or g x 3 matrix of bincts, when imptyp = -1
%                            (3rd column is wt'd bin avg's of squares)
%
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1,...
%                            'field2',values2,...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%    fields            values
%
%    vxgp             vector of x grid parameters:
%                       0 (or not specified)  -  use endpts of data and 401 bins
%                       [le; lr; nb] - le left, re right, and nb bins
%
%    vhgp             vector of h (bandwidth) grid parameters:
%                       0 (or not specified)  -  use (2*binwidth) to (range),
%                                                     and 21 h's
%                       [hmin; hmax; nh]  -  use hmin to hmax and nh h's.
%
%    imptyp           flag indicating implementation type:
%                      -1  -  binned version, and "data" is assumed to be
%                                        bincounts of prebinned data
%                                        CAUTION: for regression, also need
%                                        to include bincounts of squares
%                                        as a third column
%                       0 (or not specified)  -  linear binned version
%                                        and bin data here
%
%    eptflag          endpoint truncation flag (only has effect when imptyp = 0):
%                       0 (or not specified)  -  move data outside range to
%                                        nearest endpoint
%                       1  -  truncate data outside range
%
%    ibdryadj         index of boundary adjustment
%                         0 (or not specified)  -  no adjustment
%                         1  -  mirror image adjustment
%                         2  -  circular design
%                                 (only has effect for density estimation)
%
%    iregtdist        index for using Student's t distribution in regression
%                       0 (or not specified)  -  use only Gaussian approximation
%                       1  -  use Student's t distribution quantiles in testing
%                                 (only has effect for regression)
%
%    alpha            Usual "level of significance".  I.e. C.I.s have coverage
%                           probability 1 - alpha.  (0.05 when not specified)
%
%    simflag          Confidence Interval type (simultaneous vs. ptwise)
%                       0  -  Pointwise C.I.'s  (strongly anti-convservative)
%                       1  -  Original Row-wise Simultaneous C.I.'s
%                                 (web posted version of SiZer before July 2004)
%                       2 (or not specified) - Current Row-wise Simultaneous C.I.'s
%                                 (based on Hannig and Marron 2004)
%                       3  -  Early Global Simultaneous C.I.'s 
%                                 (assumes that rows are independent,
%                                  known to be conservative)
%                       4  -  Current Global Simultaneous C.I.'s
%                                 (fully accounts for dependence of rows)
%
%    icolor           1  (default)  full color version of SiZer
%                     0  fully black and white version
%
%    titlestr         string with title (only has effect when plot is made here)
%                           default is empty string, '', for no title
%
%    titlefontsize    font size for title
%                                    (only has effect when plot is made here,
%                                     and when the titlestr is nonempty)
%                           default is empty [], for Matlab default
%
%    xlabelstr        string with x axis label
%                                    (only has effect when plot is made here)
%                           default is empty string, '', for no xlabel
%
%    ylabelstr        string with y axis label
%                                    (only has effect when plot is made here)
%                           default is empty string, '', for no ylabel
%
%    labelfontsize    font size for axis labels
%                                    (only has effect when plot is made here,
%                                     and when a label str is nonempty)
%                           default is empty [], for Matlab default
%
%    iplot            1  -  plot even when there is numerical output
%                     0  -  (default) only plot when no numerical output
%
%
% Outputs:
%     (none)  -  Draws a gray level map (in the current axes)
%     mapout  -  output of indices into color map
%     xgrid   -  col vector grid of points at which estimate(s) are 
%                    evaluted (useful for plotting), unless grid is input,
%                    can also get this from linspace(le,re,nb)'  
%    vrowmax  -  Row-wise maxima of SiZer statistic
%                    Useful for simulation verification
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    lbinrSM.m
%

%    Copyright (c) J. S. Marron, Jan Hannig, Cheolwoo Park 1997-2008



%  First set all parameters to defaults
vxgp = 0 ;
vhgp = 0 ;
imptyp = 0 ;
eptflag = 0 ;
ibdryadj = 0 ;
iregtdist = 0 ;
alpha = 0.05 ;
simflag = 2 ;
icolor = 1 ;
titlestr = '' ;
titlefontsize = [] ;
xlabelstr = '' ;
ylabelstr = '' ;
labelfontsize = [] ;
iplot = 0 ;



%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1 ;   %  then paramstruct has been added

  if isfield(paramstruct,'vxgp') ;    %  then change to input value
    vxgp = getfield(paramstruct,'vxgp') ; 
  end ;

  if isfield(paramstruct,'vhgp') ;    %  then change to input value
    vhgp = getfield(paramstruct,'vhgp') ; 
  end ;

  if isfield(paramstruct,'eptflag') ;    %  then change to input value
    eptflag = getfield(paramstruct,'eptflag') ; 
  end ;

  if isfield(paramstruct,'ibdryadj') ;    %  then change to input value
    ibdryadj = getfield(paramstruct,'ibdryadj') ; 
  end ;

  if isfield(paramstruct,'iregtdist') ;    %  then change to input value
    iregtdist = getfield(paramstruct,'iregtdist') ; 
  end ;

  if isfield(paramstruct,'alpha') ;    %  then change to input value
    alpha = getfield(paramstruct,'alpha') ; 
  end ;

  if isfield(paramstruct,'simflag') ;    %  then change to input value
    simflag = getfield(paramstruct,'simflag') ; 
  end ;

  if isfield(paramstruct,'icolor') ;    %  then change to input value
    icolor = getfield(paramstruct,'icolor') ; 
  end ;

  if isfield(paramstruct,'titlestr') ;    %  then change to input value
    titlestr = getfield(paramstruct,'titlestr') ; 
  end ;

  if isfield(paramstruct,'titlefontsize') ;    %  then change to input value
    titlefontsize = getfield(paramstruct,'titlefontsize') ; 
  end ;

  if isfield(paramstruct,'xlabelstr') ;    %  then change to input value
    xlabelstr = getfield(paramstruct,'xlabelstr') ; 
  end ;

  if isfield(paramstruct,'ylabelstr') ;    %  then change to input value
    ylabelstr = getfield(paramstruct,'ylabelstr') ; 
  end ;

  if isfield(paramstruct,'labelfontsize') ;    %  then change to input value
    labelfontsize = getfield(paramstruct,'labelfontsize') ; 
  end ;

  if isfield(paramstruct,'iplot') ;    %  then change to input value
    iplot = getfield(paramstruct,'iplot') ; 
  end ;

  if isfield(paramstruct,'imptyp') ;    %  then change to input value
    imptyp = getfield(paramstruct,'imptyp') ; 
  end ;


end ;  %  of resetting of input parameters






%  detect whether density or regression data
%
if size(data,2) == 1 ;    %  Then is density estimation
  xdat = data(:,1) ;
  idatyp = 1 ;
  itdist = 0 ;
      %  use Gaussian distribution, not t
      
else ;                    %  Then assume regression ;
  xdat = data(:,1) ;
  ydat = data(:,2) ;
  idatyp = 2 ;
  if iregtdist == 1 ;
    itdist = 1 ;
      %  use t distribution
  else ;
    itdist = 0 ;
      %  use Gaussian distribution, not t
  end ;
  
end ;


%  Set x grid stuff
%
n = length(xdat) ;
if vxgp == 0 ;   %  then use standard default x grid
  vxgp = [min(xdat),max(xdat),401] ;
end ;
left = vxgp(1) ;
right = vxgp(2) ;
ngrid = vxgp(3) ;
xgrid = linspace(left,right,ngrid)' ;
          %  col vector to evaluate smooths at
cxgrid = xgrid - mean(xgrid) ;
          %  centered version, gives numerical stability


%  Set h grid stuff
%
if vhgp == 0 ;   %  then use standard default h grid
  range = right - left ;
  binw = range / (ngrid - 1) ;
  vhgp = [2 * binw,range,21] ;
end ;
hmin = vhgp(1) ;
hmax = vhgp(2) ;
nh = vhgp(3) ;
if nh == 1 ;
  vh = hmax ;
else ;
  if hmin < hmax ;    %  go ahead with vh construction
    vh = logspace(log10(hmin),log10(hmax),nh) ;
  else ;    %  bad inputs, warn and quit
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sz2SM.m:          !!!') ;
    disp('!!!   Bad inputs in vhgp,          !!!') ;
    disp('!!!   Reguires vhgp(1) < vhgp(2)   !!!') ;
    disp('!!!   Terminating execution        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end ;
end ;



%  Bin the data (if needed)
%
if idatyp == 1 ;        %  Treating as density estimation

  if imptyp == -1 ;   %  Then data have already been binned
    bincts = data ;
  else ;               %  Then need to bin data
    bincts = lbinrSM(xdat,vxgp,eptflag) ;
  end ;

elseif idatyp == 2 ;    %  Treating as regression

  if imptyp == -1 ;   %  Then data have already been binned
    bincts = data(:, [1 2]) ;
    bincts2 = data(:, [1 3]) ;
  else ;               %  Then need to bin data
    bincts = lbinrSM([xdat ydat],vxgp,eptflag) ;
    bincts2 = lbinrSM([xdat, ydat.^2],vxgp,eptflag) ;
  end ;

end ;
n = sum(bincts(:,1)) ;
          %  put this here in case of truncations during binning



%  Construct Surfaces
%
mdsurf = [] ;
          %  Derivative surface
mesurf = [] ;
          %  Effective sample size surface
mvsurf = [] ;
          %  Estimated Variance of Derivative
if itdist == 0 ;
  vgq = [] ;
          %  Vector of Gaussian Quantiles (for simultaneous CI's)
elseif itdist == 1 ;
  mtq = [] ;
          %  matrix of t Quantiles (for simultaneous CI's)
end ;

%  Create grid for kernel values
delta = (right - left) / (ngrid - 1) ;    %  binwidth
k = ngrid - 1 ;    %  index of last nonzero entry of kernel vector

%  If simultaneity is global set up here for use later
if simflag == 3 ;         %  do Global Simultaneous C.I.'s (using approximate independence of rows)

 numind=sum(ngrid*erf(sqrt((3/2)*log(ngrid)*delta^2./(4*vh.^2)))) ;
                        %  Sum (across different scales) of effective number of independent groups by Hsing  
    
     
elseif simflag == 4      % do Global Simultaneuous CI's (accounting for row dependency)
    
  integrand = ...
       inline('exp(-x).*(1+erf((A-x/(2*A))/sqrt(2))).*(1+erf((B-x/(2*B))/sqrt(2)))/4','x','A','B');
  numind = 0 ;
    
  for iint = 1:nh ; % average over rows to adjust for non-stationarity
      
    numind=numind+quad(integrand,0,1000,[],[],...
          sqrt(3*log(ngrid*nh))*delta/(2*vh(iint)),...
          sqrt(3*log(ngrid*nh))*(vh(2)/vh(1)-1)/2 );
  end;
  
  numind = ngrid*numind;
     
end;



%  Loop through bandwidths
for ih = 1:nh ;
  h = vh(ih) ;

  %  Set common values
  arg = linspace(0,k * delta / h,k + 1)' ;
  kvec = exp(-(arg.^2) / 2) ;
  kvec = [flipud(kvec(2:k+1)); kvec] ;
        %  construct symmetric kernel


  if idatyp == 1 ;       %  Doing density estimation
          %  main lines from gpkde.m, via nmsur5.m

    %  do boundary adjustment if needed
    %
    if ibdryadj == 1 ;    %  then do mirror image adjustment
      babincts = [flipud(bincts); bincts; flipud(bincts)] ;
    elseif ibdryadj == 2 ;    %  then do circular design adjustment
      babincts = [bincts; bincts; bincts] ;
    else ;
      babincts = bincts ;
    end ;


    %  Vector of Effective sample sizes 
    %          (notation "s0" is consistent with below)
    ve = conv(babincts,kvec) ;
    if  ibdryadj == 1  |  ibdryadj == 2 ;    %  then did boundary adjustment
      ve = ve(ngrid+k+1:k+2*ngrid) ;
    else ;
      ve = ve(k+1:k+ngrid) ;
    end ;
          %  denominator of NW est.
          %    (same as sum for kde)

    kvecd = -arg .* exp(-(arg.^2) / 2) / sqrt(2 * pi) ;
    kvecd = [-flipud(kvecd(2:k+1)); kvecd] ;
        %  construct symmetric kernel

    vd = conv(babincts,kvecd) ;
    vv = conv(babincts,kvecd.^2) ;
    if  ibdryadj == 1  |  ibdryadj == 2 ;    %  then did boundary adjustment
      vd = vd(ngrid+k+1:k+2*ngrid) / (n * h^2) ;
      vv = vv(ngrid+k+1:k+2*ngrid) / (n * h^4) ;
    else ;
      vd = vd(k+1:k+ngrid) / (n * h^2) ;
      vv = vv(k+1:k+ngrid) / (n * h^4) ;
    end ;
    vv = vv - vd.^2 ;
    vv = vv / n ;
          %  did this outside loop in nmsur5.m

  else ;    %    Doing regression
            %  using modification of lines from gpnpr.m
            %  main lines from gpnpr.m, via szeg4.m

    %  Vector of Effective sample sizes 
    %          (notation "s0" is consistent with below)
    ve = conv(bincts(:,1),kvec) ;
    ve = ve(k+1:k+ngrid) ;
          %  denominator of NW est.
          %    (same as sum for kde)

    flag = (ve < 1) ;
        %  locations with effective sample size < 1
    ve(flag) = ones(sum(flag),1) ;
        %  replace small sample sizes by 1 to avoid 0 divide
        %  no problem below, since gets grayed out

    s1 = conv(bincts(:,1) .* cxgrid , kvec) ;
    s1 = s1(k+1:k+ngrid) ;
    s2 = conv(bincts(:,1) .* cxgrid.^2 , kvec) ;
    s2 = s2(k+1:k+ngrid) ;
    t0 = conv(bincts(:,2),kvec) ;
    t0 = t0(k+1:k+ngrid) ;
        %  numerator of NW est.

    xbar = conv(bincts(:,1) .* cxgrid , kvec) ;
    xbar = xbar(k+1:k+ngrid) ;
        %  Weighted sum of X_i
    xbar = xbar ./ ve ;
        %  Weighted avg of X_i

    t1 = conv(bincts(:,2) .* cxgrid , kvec) ;
    t1 = t1(k+1:k+ngrid) ;

    numerd = t1 - t0 .* xbar ;
        %  sum(Y_i * (X_i - xbar)) * W      (weighted cov(Y,X))
    denomd = s2 - 2 * s1 .* xbar + ve .* xbar.^2 ;
        %  sum((X_i - xbar)^2) * W      (weighted var(X))

    flag2 = denomd < (10^(-10) * mean(denomd)) ;
        %  for local linear, need to also flag locations where this
        %  is small, because could have many observaitons piled up
        %  at one location
    ve(flag2) = ones(sum(flag2),1) ;
        %  also reset these, because could have more than 5 piled up
        %  at a single point, but nothing else in window
    flag = flag | flag2 ;
        %  logical "or", which flags both types of locations
        %  to avoid denominator problems

    denomd(flag) = ones(sum(flag),1) ;
        %  this avoids zero divide problems, OK, since grayed out later

    mhat = t0 ./ ve ;
    vd = numerd ./ denomd ;
        %  linear term from local linear fit (which est's deriv).
        %       (sometimes called betahat)

    sig2 = conv(bincts2(:,2),kvec) ;
    sig2 = sig2(k+1:k+ngrid) ;
    sig2 = sig2 ./ ve - mhat.^ 2 ;

    flag2 = sig2 < (10^(-10) * mean(sig2)) ;
    ve(flag2) = ones(sum(flag2),1) ;
        %  also reset these
    flag = flag | flag2 ;
        %  logical "or", which flags both types of locations
        %  to avoid denominator problems
    sig2(flag) = ones(sum(flag),1) ;
        %  this avoids zero divide problems, OK, since grayed out later

    rho2 = vd.^2 .* (denomd ./ (sig2 .* ve)) ;
    sig2res = (1 - rho2) .* sig2 ;
        %  get the residual variance from local linear reg.

    u0 = conv(bincts(:,1) .* sig2res , kvec.^2) ;
    u0 = u0(k+1:k+ngrid) ;
    u1 = conv(bincts(:,1) .* sig2res .* cxgrid , kvec.^2) ;
    u1 = u1(k+1:k+ngrid) ;
    u2 = conv(bincts(:,1) .* sig2res .* cxgrid.^2 , kvec.^2) ;
    u2 = u2(k+1:k+ngrid) ;
    vv = u2 - 2 * u1 .* xbar + u0 .* xbar.^2 ;
    vv = vv ./ denomd.^2 ;
        %  vector of variances of slope est. (from local linear)

  end ;



  %  Get quantiles, for CI's
  flag = (ve >= 5) ;
          %  locations where effective sample size >= 5
  if sum(flag) > 0 ;

    if simflag == 0 ;         %  do pt'wise CI's

      if itdist == 0 ;
        gquant = norminv(1 - (alpha / 2)) ;
      elseif itdist == 1 ;
        vtquant = tinv(1 - (alpha / 2),ve-1) ;
      end ;

    elseif simflag == 1 ;         %  do original (before July 2004)
                                  %      row-wise simultaneous CI's2

      nxbar = mean(ve(flag)) ;
          %  Crude average effective sample size
      numind = n / nxbar ;
          %  Effective number of independent groups

      beta = (1 - alpha)^(1/numind) ;
      if itdist == 0 ;
        gquant = -norminv((1 - beta) / 2) ;
      elseif itdist == 1 ;
        vtquant = -tinv((1 - beta) / 2,ve-1) ;
      end ;
 
      
    elseif simflag == 2 ;         %  do current row-wise simultaneous CI's
 
       numind=ngrid*erf(sqrt((3/2)*log(ngrid)*delta^2/(4*h^2))) ;

               %  Effective number of independent groups by Hsing
               %  Alternative formula is:
               %  numind=ngrid*erf((3/2)*sqrt(log(ngrid)*(1-exp(-delta^2/(4*h^2))))) ;

      beta = (1 - alpha)^(1/numind) ;

      if itdist == 0 ;
        gquant = -norminv((1 - beta) / 2) ;
      elseif itdist == 1 ;
        vtquant = -tinv((1 - beta) / 2,ve-1) ;
      end ;
  

    elseif  simflag == 3  | ...
            simflag == 4  ;         %  do Global Simultaneous C.I.'s
               % numind prepared earlier - line 332
        
      beta = (1 - alpha)^(1/numind) ;
     
      if itdist == 0 ;
        gquant = -norminv((1 - beta) / 2) ;
      elseif itdist == 1 ;
        vtquant = -tinv((1 - beta) / 2,ve-1) ;
      end ;
        
    end;
    
  else ;        % if all pixels on a row are grey
      
    if itdist == 0 ;
        gquant = inf ;
    elseif itdist == 1 ;
        vtquant = inf * ones(ngrid,1) ;
    end ;
    
  end ;


  mdsurf = [mdsurf vd] ;
  mesurf = [mesurf ve] ;
  mvsurf = [mvsurf vv] ;
  if itdist == 0 ;
    vgq = [vgq gquant] ;
  elseif itdist == 1 ;
    mtq = [mtq vtquant] ;
  end ;

end ;




%  Construct scale space CI surfaces
%
if itdist == 0 ;
  if nh > 1 ;    %  then have full matrices
    mloci = mdsurf - vec2matSM(vgq,ngrid) .* sqrt(mvsurf) ;
            %  Lower confidence (simul.) surface for derivative
    mhici = mdsurf + vec2matSM(vgq,ngrid) .* sqrt(mvsurf) ;
            %  Upper confidence (simul.) surface for derivative
  else ;       %  have only vectors (since only one h)
    mloci = mdsurf - vgq * sqrt(mvsurf) ;
            %  Lower confidence (simul.) surface for derivative
    mhici = mdsurf + vgq * sqrt(mvsurf) ;
            %  Upper confidence (simul.) surface for derivative
  end ;
elseif itdist == 1 ;
  mloci = mdsurf - mtq .* sqrt(mvsurf) ;
          %  Lower confidence (simul.) surface for derivative
  mhici = mdsurf + mtq .* sqrt(mvsurf) ;
          %  Upper confidence (simul.) surface for derivative
end ;


%  Construct "color map", really assignment
%    of pixels to integers, with idea:
%          1 (very dark)    - Deriv. Sig. > 0 
%          2 (darker gray)  - Eff. SS < 5
%          3 (lighter gray) - Eff. SS >= 5, but CI contains 0
%          4 (very light)   - Deriv. Sig. < 0 

mapout = 3 * ones(size(mloci)) ;
            %  default is purple (middle lighter gray)

flag = (mloci > 0) ;
            %  matrix of ones where lo ci above 0
ssflag = sum(sum(flag)) ;
if ssflag > 0 ;
  mapout(flag) = ones(ssflag,1) ;
            %  put blue (dark grey) where significantly positive
end ;


flag = (mhici < 0) ;
            %  matrix of ones where hi ci below 0
ssflag = sum(sum(flag)) ;
if ssflag > 0 ;
  mapout(flag) = 4 * ones(ssflag,1) ;
            %  put red (light gray) where significantly negative
end ;


flag = (mesurf <= 5) ;
            %  matrix of ones where effective np <= 5 ;
ssflag = sum(sum(flag)) ;
if ssflag > 0 ;

  mapout(flag) = 2 * ones(ssflag,1) ;
            %  put middle darker gray where effective sample size < 5
end ;


%  Transpose for graphics purposes
mapout = mapout' ;         



%  Make plots if no numerical output requested
%
if  nargout == 0  | ...
      iplot == 1  ;  %  Then make a plot


  if icolor ~= 0 ;     %  Then go for nice colors in sizer and sicon

    %  Set up colorful color map
    cocomap = [0,    0,   1; ...
              .35, .35, .35; ...
              .5,    0,  .5; ...
               1,    0,   0; ...
               1,   .5,   0; ...
             .35,  .35, .35; ...
               0,    1,   0; ...
               0,    1,   1] ; 
    colormap(cocomap) ;

  else ;     %  Then use gray scale maps everywhere

    %  Set up gray level color map
    comap = [.2, .2, .2; ...
             .35, .35, .35; ...
             .5, .5, .5; ...
             .8, .8, .8] ;
    colormap(comap) ;

  end ;


  image([left,right],[log10(hmin),log10(hmax)],mapout) ;
    set(gca,'YDir','normal') ;


  if ~isempty(titlestr) ;
    if isempty(titlefontsize) ;
      title(titlestr) ;
    else ;
      title(titlestr,'FontSize',titlefontsize) ;
    end ;
  end ;


  if ~isempty(xlabelstr) ;
    if isempty(labelfontsize) ;
      xlabel(xlabelstr) ;
    else ;
      xlabel(xlabelstr,'FontSize',labelfontsize) ;
    end ;
  end ;


  if ~isempty(ylabelstr) ;
    if isempty(labelfontsize) ;
      ylabel(ylabelstr) ;
    else ;
      ylabel(ylabelstr,'FontSize',labelfontsize) ;
    end ;
  end ;


end ;



%  output vrowmax if needed
%
if nargout >= 3 ;

  vrowmax = max(abs(mdsurf' ./ sqrt(mvsurf')),[],2) ;
      %  column vector of row maxima


end ;



