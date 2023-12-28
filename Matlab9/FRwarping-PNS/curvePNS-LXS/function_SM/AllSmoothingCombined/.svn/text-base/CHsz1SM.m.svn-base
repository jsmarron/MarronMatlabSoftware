function [mapout,xgrid] = CHsz1SM(data,paramstruct)
%(data,itype,vxgp,vhgp,eptflag,alpha,simflag,llflag) 

% CHSZ1SM, Censored, Hazard, length biased versions of
%         SIgnificant derivative ZERo crossings,
%   Steve Marron's matlab function
%     A variation of sz1SM.m
%     Creates color map (function of location and bandwidth),
%     showing statistical signicance of slope of smooth
%     Colored (or gray level) as:
%         blue (dark)    at points where deriv sig > 0
%         red (light)    at points where deriv sig < 0
%         purple (gray)  at points where deriv roughly 0
%         light gray where "effective sample size" < 5
%
% Inputs:
%
%   data        - Case 1: uncensored data,
%                     n x 1 column vector of 1-d data
%                 Case 2: censored data,
%                     n x 2 matrix of data, with:
%                        X's in first column,
%                        delta's in second column, with values:
%                          1 - when X is the actual value
%                          0 - when X is the (right) censoring time
%                                (i.e. the actual value is only
%                                      known to be larger)
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
%    itype            index of estimation type:
%                       1  density estimation (default)
%                       2  hazard rate estimation
%                       3  length biased density estimation
%                       4  length biased hazard rate estimation
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
%    eptflag          endpoint truncation flag (only has effect when imptyp = 0):
%                       0 (or not specified)  -  move data outside range to
%                                         nearest endpoint
%                       1  -  truncate data outside range
%
%    alpha            Usual "level of significance".  I.e. C.I.s have coverage
%                           probability 1 - alpha.  (0.05 when not specified)
%
%    simflag          Confidence Interval type (simultaneous vs. ptwise)
%                       0  -  Use Pointwise C.I.'s
%                       1 (or not specified)  -  Use Row-wise Simultaneous C.I.'s
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
%     mapout  -  output of gray level map
%     xgrid   -  col vector grid of points at which estimate(s) are 
%                    evaluted (useful for plotting), unless grid is input,
%                    can also get this from linspace(le,re,nb)'  
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    lbinrSM.m
%    CHlbinrSM.m
%    KMcdfSM.m
%    LBcdfSM.m
%

%    Copyright (c) J. S. Marron 2001


%  First set all parameters to defaults
itype = 1 ;
vxgp = 0 ;
vhgp = 0 ;
eptflag = 0 ;
alpha = 0.05 ;
simflag = 1 ;
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

  if isfield(paramstruct,'itype') ;    %  then change to input value
    itype = getfield(paramstruct,'itype') ; 
  end ;

  if isfield(paramstruct,'vxgp') ;    %  then change to input value
    vxgp = getfield(paramstruct,'vxgp') ; 
  end ;

  if isfield(paramstruct,'vhgp') ;    %  then change to input value
    vhgp = getfield(paramstruct,'vhgp') ; 
  end ;

  if isfield(paramstruct,'eptflag') ;    %  then change to input value
    eptflag = getfield(paramstruct,'eptflag') ; 
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



%  detect whether censored or uncensored data
%
if size(data,2) == 1 ;    %  Then is uncensored
  xdat = data(:,1) ;
  vdel = ones(length(xdat),1) ;
  icen = 0 ;
else ;                    %  Then assume censored
  xdat = data(:,1) ;
  vdel = data(:,2) ;
  icen = 1 ;
end ;



%  set control parameters
%
ihazard = 0 ;
ilengthb = 0 ;

if  itype == 2  |   itype == 4  ;
  ihazard = 1 ;
end ;

if  itype == 3  |   itype == 4  ;
  ilengthb = 1 ;
end ;



%  Give error message if length biased data are <= 0
%
if ilengthb == 1 ;
  if min(data(:,1)) <= 0 ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from CHsz1SM.m:      !!!') ;
    disp('!!!   length biased estimation   !!!') ;
    disp('!!!   requires positive data     !!!') ;
    disp('!!!   Terminating Execution      !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
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
    disp('!!!   Error from CHsz1SM.m:        !!!') ;
    disp('!!!   Bad inputs in vhgp,          !!!') ;
    disp('!!!   Reguires vhgp(1) < vhgp(2)   !!!') ;
    disp('!!!   Terminating execution        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end ;
end ;



%  Sort and bin the data
%
if itype == 1  &  icen == 0  ;   %  ordinary density estimation
  bincts = lbinrSM(data,[left,right,ngrid],eptflag) ;
else ;

  [svdata, vsortind] = sort(xdat) ;
  svdel = vdel(vsortind) ;

  if icen == 1 ;    %  then are doing censored estimation
    vg = KMcdfSM(svdata,1 - svdel,1) ;
    vgbar = 1 - vg  ;  
  else ;
    vgbar = ones(n,1) ;
  end ;

  if ihazard == 1 ;     % then are doing hazard est.
    if ilengthb == 0 ;
      vf = KMcdfSM(svdata,svdel,1) ;
    else ;
      vf = LBcdfSM(svdata,svdel,1) ;
    end ;
    vfbar = 1 - vf  ;  
  else ;
    vfbar = ones(n,1) ;
  end ;

  if ilengthb == 1 ;
    vlb = svdata ;
    vgbartrunc = vgbar + 1 / (2 * n) ;
    mu = (sum(svdel ./ (svdata .* vgbartrunc)) / n)^(-1) ;
  else ;
    vlb = ones(n,1) ;
    mu = 1 ;
  end ;


  vlbar = vfbar .* vgbar .* vlb ;

  data = [svdata, svdel, vlbar] ;

  bincts = CHlbinrSM(data,[left,right,ngrid],eptflag) ;

end ;




%  Also get "unadjusted bin counts", to use in ESS
%
if icen == 0 ;
  uabincts = lbinrSM(xdat,vxgp,eptflag) ;
else ;
  if sum(vdel) > 0 ;    %  then there are some uncensored obs's
    uabincts = lbinrSM(xdat(logical(vdel)),vxgp,eptflag) ;
  else ;
    uabincts = zeros(ngrid,1) ;
  end ;
end ;


if eptflag == 1 ;
  n = sum(xdat >= left  &  xdat <= right) ;
          %  put this here in case of truncations during binning
end ;



%  Construct Surfaces
%
mdsurf = [] ;
          %  Derivative surface
mesurf = [] ;
          %  Effective sample size surface
mvsurf = [] ;
          %  Estimated Variance of Derivative
vgq = [] ;
          %  Vector of Gaussian Quantiles (for simultaneous CI's)

%  Create grid for kernel values
delta = (right - left) / (ngrid - 1) ;    %  binwidth
k = ngrid - 1 ;    %  index of last nonzero entry of kernel vector

%  Loop through bandwidths
for ih = 1:nh ;
  h = vh(ih) ;

  %  Set common values
  arg = linspace(0,k * delta / h,k + 1)' ;
  kvec = exp(-(arg.^2) / 2) ;
  kvec = [flipud(kvec(2:k+1)); kvec] ;
        %  construct symmetric kernel


  %  Vector of Effective sample sizes 
  %          (notation "s0" is consistent with below)
  ve = conv(uabincts(:,1),kvec) ;
          %  use unadjusted bin counts here, to count
          %  actual pieces of data
  ve = ve(k+1:k+ngrid) ;
          %  denominator of NW est.
          %    (same as sum for kde)


  kvecd = -arg .* exp(-(arg.^2) / 2) / sqrt(2 * pi) ;
  kvecd = [-flipud(kvecd(2:k+1)); kvecd] ;
        %  construct symmetric kernel


  flag0 = (uabincts == 0) ;
  n0 = sum(flag0) ;
  if n0 > 0 ;
    denom = uabincts ;
    denom(flag0) = ones(n0,1) ;
    twiddlefactor = bincts ./ denom ;
    twiddlefactor = (1 - flag0) .* twiddlefactor ;
  else ;
    twiddlefactor = bincts ./ uabincts ;
  end ;
  cabincts = bincts .* twiddlefactor ;

  vd = conv(bincts,kvecd) ;
  vv = conv(cabincts,kvecd.^2) ;
  vd = vd(k+1:k+ngrid) / (n * h^2) ;
  vv = vv(k+1:k+ngrid) / (n * h^4) ;


  vv = vv - vd.^2 ;
  vv = vv / n ;

  if ilengthb == 1 ;
    vd = vd * mu ;
    vv = vv * mu^2 ;
  end ;



  %  Get Gaussian quantile, for CI's
  flag = (ve >= 5) ;
          %  locations where effective sample size >= 5
  if sum(flag) > 0 ;
    if simflag == 0 ;         %  do pt'wise CI's
      gquant = norminv(1 - (alpha / 2)) ;
    else ;                     %  do simultaneous CI's
      nxbar = mean(ve(flag)) ;
          %  Crude average effective sample size
      numind = n / nxbar ;
          %  Effective number of independent groups
      beta = (1 - alpha)^(1/numind) ;
      gquant = -norminv((1 - beta) / 2) ;
    end ;
  else ;
    gquant = inf ;
  end ;


  mdsurf = [mdsurf vd] ;
  mesurf = [mesurf ve] ;
  mvsurf = [mvsurf vv] ;
  vgq = [vgq gquant] ;

end ;    %  of ih loop through bandwidths


%  Construct scale space CI surfaces
%
if length(vgq) > 1 ;    %  then have full matrices
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

