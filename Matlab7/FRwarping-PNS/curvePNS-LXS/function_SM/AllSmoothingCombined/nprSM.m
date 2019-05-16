function [npr,xgrid,mker] = nprSM(data,paramstruct) 
% NPRSM, General Purpose NonParametric Regression (1-d, Local poly))
%   Steve Marron's matlab function
%     Does 1-d kernel local polynomial (usually linear) regression,
%     using binned (default), direct (either matrix, or loops for 
%     bigger data sets), or moving window (for higher degree)
%     implementations, with the bandwidth either user specified 
%     (can be vector), or data driven (Ruppert Sheather and Wand DPI or ROT)
%     Kernel shape is Gaussian.
%
% Inputs:
%   data        - either n x 2 matrix of Xs (1st col) and Ys (2nd col)
%                     or g x 2 matrix of bincts, when imptyp = -1
%
%                     For equally spaced X's, and a return at those X's only,
%                     use imptyp = -1,
%                     and all 1's in 1st column of bincts, and Y's in the 2nd
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
%    vh               vector of bandwidths, or specifies data driven:
%                       0 (or not specified)  -  Ruppert, Sheather, Wand DPI
%                      -1  -  Ruppert, Sheather, Wand ROT
%                          Note: <= 0 requires imptyp = 0
%                      >0  -  Use input number (numbers if vector)
%                          Note: this (these) MUST be >0 for imptyp >= 1
%                                     (the direct implementations)
%
%    vxgrid           vector of parameters for, or values of, grid to evaluate at:
%                       0 (or not specified)  -  use endpts of data and 401 bins
%                       [le; lr]  -  le is left end, re is right, 401 bins
%                              (get error message and no return if le > lr)
%                       [le; lr; nb] - le left, re right, and nb bins
%                       xgrid  -  Use input values 
%                                 Note:  need to have more than 3 entries,
%                                      and only works when imptyp = 1 or 2
%
%    imptyp           flag indicating implementation type:
%                      -1  -  binned version, and "data" is assumed to be
%                                        bincounts of prebinned data
%                       0 (or not specified)  -  linear binned version
%                                        and bin data here
%                       1  -  Direct matrix implementation
%                       2  -  Slow looped implementation (only useful when
%                                 1 creates matrices that are too large)
%                       3  -  Moving window implementation (slow, but allows
%                                 higher polynomial degrees than 1 (linear)
%
%    polydeg          scalar degree of local polynomial.  For imptyp < 3, can
%                       only use:    0 - local constant (ie. Nadaraya-Watson)
%                                    1 - local linear (the default)
%                       For imptyp = 3, can be 0,1,2,...
%
%    eptflag          endpoint truncation flag (only has effect when imptyp = 0):
%                       0 (or not specified)  -  move data outside range to
%                                        nearest endpoint
%                       1  -  truncate data outside range
%
%
%    ndataoverlay     overlay raw data as a jitterplot  (requires  imptyp >= 0)
%                                    (only has effect when plot is made here)
%                       0  -  (default) no data plot
%                       1  -  overlay up to 1000 points (random choice, when more)
%                       2  -  overlay full data set
%                       n > 2   -  overlay n random points
%
%    dolcolor         data overlay color
%                                    (only has effect when plot is made here)
%                           default is 'g'
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%
%    linewidth        width of lines (only has effect when plot is made here)
%                           default is 2, for length(vh) <= 3,
%                           default is 0.5, for length(vh) > 3,
%
%    linecolor        string with color for lines
%                                    (only has effect when plot is made here)
%                           default is 'b'
%                           use the empty string, '', for standard Matlab colors
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
%    plotbottom       bottom of plot window,
%                              use [] to get min - 0.05 * range (default)
%
%    plottop          top of plot window,  
%                              use [] to get max + 0.05 * range (default)
%
%    iplot            1  -  plot even when there is numerical output
%                     0  -  (default) only plot when no numerical output
%
%
% Outputs:
%     (none)  -  Draws a graph of the result (in the current axes)
%     npr     -  col vector of heights of kernel smooth,
%                    unless vh is a vector (then have matrix, with
%                    corresponding cols as smooths)
%                    Note: when a grid is used where the data are
%                    too sparse for a given bandwidth, direct 
%                    implementations return an interpolation of
%                    the data, and binned implementations return
%                    an interpolation of the estimate
%     xgrid   -  col vector grid of points at which estimate(s) are 
%                    evaluted (useful for plotting), unless grid is input,
%                    can also get this from linspace(le,re,nb)'  
%     mker    -  matrix (vector) of kernel functions, evaluated at xgrid,
%                    which can be plotted to show "effective window 
%                    sizes" (currently scaled to have mass 0.05, may
%                    need some vertical rescaling)
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    lbinrSM.m
%    bwrswSM.m

%    Copyright (c) J. S. Marron 1997-2002




%  First set all parameters to defaults
vh = 0 ;      %  use default RSW
vxgrid = 0 ;
imptyp = 0 ;
polydeg = 1 ;
eptflag = 0 ;
ndataoverlay = 0 ;
dolcolor = 'g' ;
ibigdot = 0 ;
linewidth = 2 ;
linecolor = 'b' ;
titlestr = '' ;
titlefontsize = [] ;
xlabelstr = '' ;
ylabelstr = '' ;
labelfontsize = [] ;
plotbottom = [] ;
plottop = [] ;
iplot = 0 ;





%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1 ;   %  then paramstruct has been added

  if isfield(paramstruct,'vh') ;    %  then change to input value
    vh = getfield(paramstruct,'vh') ; 
  end ;

  if isfield(paramstruct,'vxgrid') ;    %  then change to input value
    vxgrid = getfield(paramstruct,'vxgrid') ; 
  end ;

  if isfield(paramstruct,'imptyp') ;    %  then change to input value
    imptyp = getfield(paramstruct,'imptyp') ; 
  end ;

  if isfield(paramstruct,'polydeg') ;    %  then change to input value
    polydeg = getfield(paramstruct,'polydeg') ; 
  end ;

  if isfield(paramstruct,'eptflag') ;    %  then change to input value
    eptflag = getfield(paramstruct,'eptflag') ; 
  end ;

  if isfield(paramstruct,'ndataoverlay') ;    %  then change to input value
    ndataoverlay = getfield(paramstruct,'ndataoverlay') ; 
  end ;

  if isfield(paramstruct,'dolcolor') ;    %  then change to input value
    dolcolor = getfield(paramstruct,'dolcolor') ; 
  end ;

  if isfield(paramstruct,'ibigdot') ;    %  then change to input value
    ibigdot = getfield(paramstruct,'ibigdot') ; 
  end ;

  if isfield(paramstruct,'linewidth') ;    %  then change to input value
    linewidth = getfield(paramstruct,'linewidth') ; 
  end ;

  if isfield(paramstruct,'linecolor') ;    %  then change to input value
    linecolor = getfield(paramstruct,'linecolor') ; 
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

  if isfield(paramstruct,'plotbottom') ;    %  then change to input value
    plotbottom = getfield(paramstruct,'plotbottom') ; 
  end ;

  if isfield(paramstruct,'plottop') ;    %  then change to input value
    plottop = getfield(paramstruct,'plottop') ; 
  end ;

  if isfield(paramstruct,'iplot') ;    %  then change to input value
    iplot = getfield(paramstruct,'iplot') ; 
  end ;


end ;  %  of resetting of input parameters


if  imptyp < 3  &  polydeg > 1 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from nprSM.m:              !!!') ;
  disp('!!!   polydeg > 1 requires imptyp = 3    !!!') ;
  disp('!!!   resetting imptype to 3             !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  imptyp = 3 ;
end ;

if  vh <= 0  &  imptyp ~= 0  ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from nprSM.m:          !!!') ;
  disp('!!!   vh <= 0 requires imptyp = 0    !!!') ;
  disp('!!!   resetting imptype to 0         !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  imptyp = 0 ;

  if polydeg ~= 1 ;
    disp('!!!   and can''t have polydeg not 1   !!!') ;
    disp('!!!   resetting polydeg to 1         !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    polydeg = 1 ;
  end ;

end ;




%  Calculate local polynomial smooth
%
if imptyp > 0 ;    %  Then do direct implementation

  if min(vh) > 0 ;    %  Then have valid bandwidths, so proceed

    n = size(data,1) ;

    if length(vxgrid) > 3 ;  %  Then use input grid
      xgrid = vxgrid ;
      nbin = length(xgrid) ;
    else ;                    %  Need to generate a grid
      nbin = 401 ;         %  Default
      lend = min(data(:,1)) ;   %  Default
      rend = max(data(:,1)) ;   %  Default
      if length(vxgrid) >= 2 ;      %  use input endpoints
        lend = vxgrid(1) ;
        rend = vxgrid(2) ;
      end ;
      if length(vxgrid) == 3 ;      %  use number of grid points
        nbin = vxgrid(3) ;
      end ;

      if lend > rend ;    %  Then bad range has been input
        disp('!!!   Error in nprSM: invalid range chosen  !!!') ;
        xgrid = [] ;
      else ;
        xgrid = linspace(lend,rend,nbin)' ;
      end ;
    end ;


    %  Loop through bandwidths
    npr = [] ;
    for ih = 1:length(vh) ;
      h = vh(ih) ;

      if imptyp ~= 2  &  imptyp ~= 3 ;
                    %  Then do direct matrix implementation

        arg = vec2matSM((data(:,1) ./ h),nbin) - vec2matSM((xgrid' ./ h),n) ;
          %  efficient way to divide all dif's by h
        mwt = exp(-(arg .^2) / 2) ;
          %  exponential part of Gaussian density (constant not
          %         needed since these divide each other later)
        arg = arg * h ;
          %  put back on scale of data.

        s0 = sum(mwt)' ;
          %  sum part of s0, and make result a column vector
        sy0 = sum(mwt .* vec2matSM(data(:,2),nbin))' ;
        if polydeg ~= 0 ;    %  Then need extra stuff for local linear
          s1 = sum(mwt .* arg)' ;
          s2 = sum(mwt .* arg.^2)' ;
          sy1 = sum(mwt .* arg .* vec2matSM(data(:,2),nbin))' ;
        end ;

        arg = 0 ;
        mwt = 0 ;
          %  get rid of these huge matrices as soon as possible

        if polydeg == 0 ;    %  then do local constant (NW)
          denom = s0 ; 
        else ;                %  then do local linear
          denom = s2 .* s0 - s1 .* s1 ; 
        end ;

        if sum( (denom / max([denom; eps])) <= eps ) ;
                   %  If denominator has any entry that is effectively 0
          disp('!!!   Warning from nprSM:  h is too small  !!!') ;
          disp('!!!      returning interpolant of data     !!!') ;

          %  sort data and interpolate
          [sxdat, vsind] = sort(data(:,1)) ;
          sydat = data(:,2) ;
          sydat = sydat(vsind) ;
          nprh = interp1s(sxdat,sydat,xgrid) ;
             %  specially modified version, that allows extrapolation

        else ;    %  then do usual calculations

          if polydeg == 0 ;    %  then do local constant (NW)
            nprh = sy0 ./ denom ;
          else ;                %  then do local linear
            nprh = (s2 .* sy0 - s1 .* sy1) ./ denom ;
          end ;

        end ;

        npr = [npr nprh] ;

      else ;   %  Do slower looped implementations
        nprh = [] ;
        for ixg = 1:nbin ;    %  Loop through grid points
          arg = (data(:,1) - xgrid(ixg)) / h ;
          vwt = exp(-(arg .^2) / 2) ;
          %  exponential part of Gaussian density (constant not
          %         needed since these divide each other later)

          if imptyp == 2 ;   %  Then do formula type of linear fit
                              %  (direct modification of imptyp = 1)
            arg = arg * h ;
          %  put back on scale of data.
            s0 = sum(vwt) ;
            sy0 = sum(vwt .* data(:,2)) ;
            if polydeg ~= 0 ;    %  Then need extra stuff for local linear
              s1 = sum(vwt .* arg)' ;
              s2 = sum(vwt .* arg.^2)' ;
              sy1 = sum(vwt .* arg .* data(:,2))' ;
            end ;

            if polydeg == 0 ;    %  then do local constant (NW)
              denom = s0 ; 
            else ;                %  then do local linear
              denom = s2 .* s0 - s1 .* s1 ; 
            end ;

            if denom <= eps ;
                   %  If denominator is effectively 0
              disp('!!!   Warning from nprSM:  h is too small  !!!') ;
              disp('!!!      returning interpolant of data     !!!') ;

              %  sort data and interpolate
              [sxdat, vsind] = sort(data(:,1)) ;
              sydat = data(:,2) ;
              sydat = sydat(vsind) ;
              nprhx = interp1s(sxdat,sydat,xgrid(ixg)) ;

            else ;    %  then do usual calculations

              if polydeg == 0 ;    %  then do local constant (NW)
                nprhx = sy0 ./ denom ;
              else ;                %  then do local linear
                nprhx = (s2 .* sy0 - s1 .* sy1) ./ denom ;
              end ;

            end ;

          else ;   %  (imptyp = 3)  Then do direct poly fit, in window
            mx = ones(size(data,1),1) ;
                  %  1st column of "polynomial fit design matrix"
            if polydeg >= 1 ;
              for ideg = 1:polydeg ;
                mx = [mx, (arg .* mx(:,size(mx,2)))] ;
                  %  next column of "polynomial fit design matrix"
              end ;
            end ;
            mwt = diag(vwt) ;

            xpwx = mx' * mwt * mx ;

            if (1 / cond(xpwx)) <= eps ;
                   %  If matrix is effectively singular
              disp('!!!   Warning from nprSM:  h is too small  !!!') ;
              disp('!!!      returning interpolant of data     !!!') ;

              %  sort data and interpolate
              [sxdat, vsind] = sort(data(:,1)) ;
              sydat = data(:,2) ;
              sydat = sydat(vsind) ;
              nprhx = interp1s(sxdat,sydat,xgrid(ixg)) ;

            else ;    %  then do usual calculations

              polycoef = inv(xpwx) * mx' * mwt * data(:,2) ;
                  %  kernel weighted least squares fit of poly to Ys
              nprhx = polycoef(1) ;
                  %  1st entry is order 0 part
            end ;
          end ;

          nprh = [nprh; nprhx] ;
        end ;
        npr = [npr nprh] ;
      end ;
    end ;

  else ;    %  Have invalid bandwidths

    disp('!!!   Error in nprSM: A bandwidth is invalid   !!!') ;
    disp('    (Note: cannot use data driven, with direct impl''s)') ;

  end ;

else ;     %  Then do binned implementation

  if imptyp == -1 ;   %  Then data have already been binned

    if (length(vxgrid) == 1) | (length(vxgrid) > 3) ;
                         %  Then can't proceed because don't have bin ends
      disp('!!!   Error: nprSM needs to know the endpoints   !!!') ;
      disp('!!!            to use this implementation        !!!') ;
      bincts = [] ;
    else ;
      n = sum(data(:,1)) ;
      bincts = data ;

      nbin = 401 ;    %  default value
      lend = vxgrid(1) ;
      rend = vxgrid(2) ;
      if length(vxgrid) == 3 ;          %  then use number of grid points
        nbin = vxgrid(3) ;
      end ;

      if nbin ~= length(bincts) ;    %  Then something is wrong

        disp('!!!   Warning: nprSM was told the wrong number of bins   !!!') ;
        disp('!!!            will just use the number of counts.       !!!') ;

        nbin = size(bincts,1) ;
      end ;
    end ;

  else ;               %  Then need to bin data

    n = size(data,1) ;

    if length(vxgrid) > 3 ;  %  Then need to warn of change to default
      disp('!!!   Warning: nprSM was given an xgrid, and also   !!!') ;
      disp('!!!       asked to bin; will bin and ignore xgrid   !!!') ;
    end ;

    %  Specify grid parameters
    nbin = 401 ;         %  Default
    lend = min(data(:,1)) ;   %  Default
    rend = max(data(:,1)) ;   %  Default
    if (length(vxgrid) == 2) | (length(vxgrid) == 3) ;
                                     %  then use input endpoints
      lend = vxgrid(1) ;
      rend = vxgrid(2) ;
    end ;
    if length(vxgrid) == 3 ;          %  then use number of grid points
      nbin = vxgrid(3) ;
    end ;

    if lend > rend ;    %  Then bad range has been input
      disp('!!!   Error in nprSM: invalid range chosen  !!!') ;
      bincts = [] ;
    else ;
      bincts = lbinrSM(data,[lend,rend,nbin],eptflag) ;
    end ;

    %  Can do data-based bandwidth selection here, if specified
    if vh == -1 ;        %  Then use RSW Rule of Thumb
      vh = bwrswSM(data,-1) ;
    elseif min(vh) <= 0 ;     %  Then be sure to use default,
                              %  RSW Direct Plug In
                              %    (in case an unsupp val was input)
      vh = bwrswSM(data) ;
      if vh == 0 ;
        disp('!!!   Warning from nprSM: h_RSW was 0     !!!') ;
        disp('          (going to Rule of Thumb)    ') ;
        vh = bwrswSM(data,-1) ;
      end ;

    end ;

  end ;
  xgrid = linspace(lend,rend,nbin)' ;


  %  Loop through bandwidths
  npr = [] ;
  for ih = 1:length(vh) ;
    h = vh(ih) ;

    %  Create vector of kernel values, at equally spaced grid
    delta = (rend - lend) / (nbin - 1) ;    %  binwidth
    k = nbin - 1 ;    %  index of last nonzero entry of kernel vector
    arg = linspace(0,k * delta / h,k + 1)' ;
    kvec0 = exp(-(arg.^2) / 2) / sqrt(2 * pi) ;
    if polydeg ~= 0 ;    %  Then need extra stuff for local linear
      arg = arg * h ;
      kvec1 = kvec0 .* arg ;
      kvec2 = kvec1 .* arg ;
    end ;

    %  Do actual kernel smooth
    kvec0 = [flipud(kvec0(2:k+1)); kvec0] ;
          %  construct symmetric kernel
    s0 = conv(bincts(:,1),kvec0) ;
    s0 = s0(k+1:k+nbin) ;
    sy0 = conv(bincts(:,2),kvec0) ;
    sy0 = sy0(k+1:k+nbin) ;
    if polydeg ~= 0 ;    %  Then need extra stuff for local linear
      kvec1 = [-flipud(kvec1(2:k+1)); kvec1] ;
          %  skew-symmetric here!
      s1 = conv(bincts(:,1),kvec1) ;
      s1 = s1(k+1:k+nbin) ;
      sy1 = conv(bincts(:,2),kvec1) ;
      sy1 = sy1(k+1:k+nbin) ;

      kvec2 = [flipud(kvec2(2:k+1)); kvec2] ;
          %  construct symmetric kernel
      s2 = conv(bincts(:,1),kvec2) ;
      s2 = s2(k+1:k+nbin) ;
    end ;

    if polydeg == 0 ;    %  then do local constant (NW)
      denom = s0 ; 
    else ;                %  then do local linear
      denom = s2 .* s0 - s1 .* s1 ; 
    end ;


    vflag0d = (denom / max([denom; eps])) <= eps ;
          %  ones where denominator is effectively 0

    sflag0d = sum(vflag0d) ;
          %  > 0 when there are some locations with 0 denominator
    if sflag0d > 0 ;
      disp('!!!   Warning from nprSM:  data too sparse for this h   !!!') ;
      disp('!!!   will interpolate over sparse regions  !!!') ;
      denom(vflag0d) = ones(sflag0d,1) ;
          %  replace 0's by ones (temporarily)
    end ;

    %  main calculation of smooth
    if polydeg == 0 ;    %  then do local constant (NW)
      nprh = sy0 ./ denom ;
    else ;                %  then do local linear
      nprh = (s2 .* sy0 - s1 .* sy1) ./ denom ;
    end ;



    if sflag0d > 0 ;     %  then need to come back and fix up 0 denoms
      vflagbf = bincts(:,1) > 0 ;
          %  one where there is some data, in sense that binct > 0

      txbdat = xgrid(vflagbf) ;    
          %  x data, truncated to nonzero bins
      tybdat = bincts(vflagbf,2) ./ bincts(vflagbf,1) ;    
          %  y data as bin averages, truncated to nonzpero bins

      if sflag0d == nbin ;     %  then have denom trouble at each data point,
                               %  so just return interpolant of binned data

        nprh = interp1s(txbdat,tybdat,xgrid) ;

      else ;    %  then have some regions where denom is OK,
                %  so do interpolation only over those regions


        if vflag0d(1) == 1 ;    %  then have data sparsity at left end
                                %  and need to adjust
          [temp,ifge] = max(1 - vflag0d) ;
          %  index of first point with good estimate (where denom is nonzero)
          [temp,ifpbag] = max(vflagbf(ifge:nbin)) ;
          ifpbag = ifpbag + ifge - 1 ;
          %  index of first positive binct after first good estimate

            flag = txbdat < xgrid(ifpbag) ;
            if sum(flag) > 0 ;   %  Then there are some points to int. over
              vx = [txbdat(flag); xgrid(ifpbag)] ;
                  %  x's for interpolation 
              vy = [tybdat(flag); nprh(ifpbag)] ;
                  %  y's for interpolation 
            else ;
              vx = xgrid(ifpbag) ;
                  %  x's for interpolation 
              vy = nprh(ifpbag) ;
                  %  y's for interpolation 
            end ;
          nprh(1:(ifpbag-1)) = interp1s(vx,vy,xgrid(1:(ifpbag-1))) ;
          vflag0d(1:(ifpbag-1)) = zeros(ifpbag-1,1) ;
          %  reset flag, now that values have been fixed
        end ;


        if vflag0d(nbin) == 1 ;    %  then have data sparsity at right end
                                   %  and need to adjust
          [temp,ilge] = max(flipud(1 - vflag0d)) ;
          ilge = nbin + 1 - ilge ;
          %  index of last point with good estimate (where denom is nonzero)
          [temp,ilpbbg] = max(flipud(vflagbf(1:ilge))) ;
          ilpbbg = ilge + 1 - ilpbbg ;
          %  index of last positive binct before last good estimate
          
            flag = txbdat > xgrid(ilpbbg) ;
            if sum(flag) > 0 ;   %  Then there are some points to int. over
              vx = [xgrid(ilpbbg); txbdat(flag)] ;
                  %  x's for interpolation 
              vy = [nprh(ilpbbg); tybdat(flag)] ;
                  %  y's for interpolation 
            else ;
              vx = xgrid(ilpbbg) ;
                  %  x's for interpolation 
              vy = nprh(ilpbbg) ;
                  %  y's for interpolation 
            end ;
          nprh((ilpbbg+1):nbin) = interp1s(txbdat,tybdat, ...
                              xgrid((ilpbbg+1):nbin)) ;
          vflag0d((ilpbbg+1):nbin) = zeros(nbin-ilpbbg,1) ;
          %  reset flag, now that values have been fixed
        end ;


        while sum(vflag0d) > 0 ;   %  loop until all sparsity problems fixed
          [temp,ind0d] = max(vflag0d) ;
          %  an index where still have 0 denom

          [temp,inge] = max(1 - vflag0d(ind0d:nbin)) ;
          inge = inge + ind0d - 1 ;
          %  index of next point with good estimate (where denom is nonzero)
          [temp,inpbag] = max(vflagbf(inge:nbin)) ;
          inpbag = inpbag + inge - 1 ;
          %  index of next positive binct after first good estimate

          [temp,ilge] = max(flipud(1 - vflag0d(1:ind0d))) ;
          ilge = ind0d + 1 - ilge ;
          %  index of last point with good estimate (where denom is nonzero)
          [temp,ilpbbg] = max(flipud(vflagbf(1:ilge))) ;
          ilpbbg = ilge + 1 - ilpbbg ;
          %  index of last positive binct before last good estimate

            flag = (txbdat > xgrid(ilpbbg)) .* (txbdat < xgrid(inpbag)) ;
            if sum(flag) > 0 ;   %  Then there are some points to int. over
              vx = [xgrid(ilpbbg); txbdat(flag); xgrid(inpbag)] ;
                  %  x's for interpolation 
              vy = [nprh(ilpbbg); tybdat(flag); nprh(inpbag)] ;
                  %  y's for interpolation 
            else ;
              vx = [xgrid(ilpbbg); xgrid(inpbag)] ;
                  %  x's for interpolation 
              vy = [nprh(ilpbbg); nprh(inpbag)] ;
                  %  y's for interpolation 
            end ;
          nprh((ilpbbg+1):(inpbag-1)) = interp1(vx,vy, ...
                                      xgrid((ilpbbg+1):(inpbag-1))) ;
          %  linearly interpolate accross gap
          vflag0d((ilpbbg+1):(inpbag-1)) = zeros(inpbag-ilpbbg-1,1) ;
        end ;

      end ;

    end ;

    npr = [npr nprh] ;

  end ;

end ;



%  Create matrix of kernels, if this is needed
%
if nargout == 3 ;
  cent = mean([lend; rend]) ;
          %  centerpoint of evaluation grid
  mih = vec2matSM(1 ./ vh',nbin) ;
  mker = vec2matSM((xgrid - cent),length(vh)) .* mih;
          %  argument of gaussian kernel
  mker = exp(-mker.^2 / 2) .* mih / sqrt(2 * pi) ;
          %  Gaussian kernels with mass 1
  mker = 0.05 * mker ;
          %  Make masses = 0.05
end ;



%  Make plots if no numerical output requested
%
if  nargout == 0  | ...
      iplot == 1  ;  %  Then make a plot


  if  length(vh) > 3  &  ~isfield(paramstruct,'linewidth')  ;
                              %  then need to change default value of linewidth
    linewidth = 0.5 ;
  end ;


  if isempty(linecolor) ;
    plot(xgrid,npr,'LineWidth',linewidth) ;
  else ;
    plot(xgrid,npr,'LineWidth',linewidth,'Color',linecolor) ;
  end ;


  if  isempty(plottop)  &  isempty(plotbottom)  ;   %  then adjust top and bottom
    plotbottom = min(min(npr)) ;
    plottop = max(max(npr)) ;
    plotrange = plottop - plotbottom ;
    plotbottom = plotbottom - 0.05 * plotrange ;
    plottop = plottop + 0.05 * plotrange ;
  elseif isempty(plottop) ;                         %  then only adjust top
    plottop = max(max(npr)) ;
    plotrange = plottop - plotbottom ;
    plottop = plottop + 0.05 * plotrange ;
  elseif isempty(plotbottom) ;                      %  then only adjust bottom
    plotbottom = min(min(npr)) ;
    plotrange = plottop - plotbottom ;
    plotbottom = plotbottom - 0.05 * plotrange ;
  end ;

  vax = [lend,rend,plotbottom,plottop] ;
  axis(vax) ;


  if  ndataoverlay > 0  &  imptyp >= 0  ;
                            %  then overlay data
  
    if ndataoverlay == 1 ;
      ndo = min(n,1000) ;
    elseif ndataoverlay == 2 ;
      ndo = n ;
    else ;
      ndo = min(n,ndataoverlay) ;
    end ;


    flagleft = (data(:,1) < lend) ;
        %  ones where data below left end
    flagright = (data(:,1) > rend) ;
        %  ones where data above right end
    nleft = sum(flagleft) ;
    nright = sum(flagright) ;
    if nleft + nright > 0 ;    %  then need to deal with points outside range

      if eptflag == 1 ;    %  the truncate data outside range
        datatrunc = data(~(flagleft | flagright),:) ;
            %  keep data that is not (outside left or outside right)

      else ;    %  then move outside points to nearest end
        datatrunc = data ;
        if nleft > 0 ;    %  then replace those points with lend
          datatrunc(flagleft,1) = lend * ones(nleft,1) ;
        end ;
        if nright > 0 ;    %  then replace those points with rend
          datatrunc(flagright,1) = rend * ones(nright,1) ;
        end ;

      end ;

    else ;

      datatrunc = data ;

    end ;


    if ndo < n ;    %  then need to subsample
      [temp,randperm] = sort(rand(n,1)) ;
            %  randperm is a random permutation of 1,2,...,n
      vkeep = randperm(1:ndo) ;
            %  indices of elements to keep for display
      dataol = datatrunc(vkeep,:) ;
    else ;    %  overlay full data set
      dataol = datatrunc ;
    end ;


    %  overlay selected data
    %
    vax = axis ;
    fbottom = vax(3) ;
    ftop = vax(4) ;
    hold on ;

      if ibigdot == 1 ;   %  plot deliberately large dots
        plot(dataol(:,1),dataol(:,2),[dolcolor 'o'], ...
                          'MarkerSize',1,'LineWidth',2) ;
      else ;    %  use matlab default dots
        plot(dataol(:,1),dataol(:,2),[dolcolor '.']) ;
      end ;

    hold off ;
  
  end ;


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

