function [kde,xgrid,mker] = CHkdeSM(data,vh,paramstruct) 
% CHkdeSM, Censored Hazard Kernel Density Estimate (1-d, Gaussian Kernel)
%     Also can handle length biased data
%     Does 1-d kernel density or hazard estimation, 
%     using a binned implementation, 
%     with the bandwidth user specified (can be vector)
%   Can use first 2 or 3 arguments.
% Inputs:
%     data   - either n x 1 column vector of uncensored data
%                  or n x 2 matrix of censored data, with:
%                      X's in first column,
%                      delta's in second column, with values:
%                          1 - when X is the actual value
%                          0 - when X is the (right) censoring time
%                                (i.e. the actual value is only
%                                      known to be larger)
%
%     vh      - vector of bandwidths (required)
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
%    itype             index of estimation type:
%                          1  density estimation (default)
%                          2  hazard rate estimation
%                          3  length biased density estimation
%                          4  length biased hazard rate estimation
%
%    vxgrid            vector of grid parameters
%                          0 (or not specified)  -  use endpts of data 
%                                    and 401 bins
%                          [le; lr]  -  le is left end, re is right, 
%                                    401 bins (get error message and 
%                                              no return if le > lr)
%                          [le; lr; nb] - le left, re right, and nb bins
%
%    eptflag           endpoint truncation flag
%                          0  -  move data outside range to nearest endpoint
%                          1 (or not specified)  -  truncate data outside range
%                                CAUTION:  this default is the opposite
%                                    of lkdeSM, but makes sense, since
%                                    often want to eliminate wierd edge 
%                                    effects in these settings
%
%    ndataoverlay     overlay raw data as a jitterplot
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
%    cdolcolor        censored data overlay color
%                                    (only has effect when plot is made here)
%                           default is 'y'
%
%    dolhtseed        seed for random heights used in data overlay jitter plot
%                           default is [] (for using current Matlab seed) 
%                                    (should be an integer with <= 8 digits)
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
%    plotbottom      bottom of plot window,
%                                    use [] to get 0 - .05 * range (default)
%
%    plottop         top of plot window,
%                                    use [] to get max + .05 * range (default)
%
%    iplot            1  -  plot even when there is numerical output
%                     0  -  (default) only plot when no numerical output
%
%
% Outputs:
%     (none)  -  Draws a graph of the result (in the current axes)
%     kde     -  col vector of heights of kernel kernel density estimate,
%                    unless vh is a vector (then have matrix, with
%                    corresponding cols as density estimates)
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
%    CHlbinrSM.m
%    KMcdfSM.m
%    LBcdfSM.m

%    Copyright (c) J. S. Marron 2001


%  give error message if no bandwidth specified
%
if nargin < 2
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from CHkdeSM.m:        !!!') ;
  disp('!!!   must input bandwidth(s), vh  !!!') ;
  disp('!!!   (as second argument)         !!!') ;
  disp('!!!   Terminating Execution        !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
elseif nargin == 2
  paramstruct = struct([]) ;
end


%  First set all parameters to defaults
itype = 1 ;
vxgrid = 0 ;
eptflag = 1 ;
ndataoverlay = 0 ;
dolcolor = 'g' ;
ibigdot = 0 ;
cdolcolor = 'y' ;
dolhtseed = [] ;
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
if nargin > 1   %  then paramstruct has been added

  if isfield(paramstruct,'itype')    %  then change to input value
    itype = paramstruct.itype ; 
  end

  if isfield(paramstruct,'vxgrid')    %  then change to input value
    vxgrid = paramstruct.vxgrid ; 
  end

  if isfield(paramstruct,'eptflag')    %  then change to input value
    eptflag = paramstruct.eptflag ; 
  end

  if isfield(paramstruct,'ndataoverlay')    %  then change to input value
    ndataoverlay = paramstruct.ndataoverlay ; 
  end

  if isfield(paramstruct,'dolcolor')    %  then change to input value
    dolcolor = paramstruct.dolcolor ; 
  end

  if isfield(paramstruct,'ibigdot')    %  then change to input value
    ibigdot = paramstruct.ibigdot ; 
  end

  if isfield(paramstruct,'cdolcolor')    %  then change to input value
    cdolcolor = paramstruct.cdolcolor ; 
  end

  if isfield(paramstruct,'dolhtseed')    %  then change to input value
    dolhtseed = paramstruct.dolhtseed ; 
  end

  if isfield(paramstruct,'linewidth')    %  then change to input value
    linewidth = paramstruct.linewidth ; 
  end

  if isfield(paramstruct,'linecolor')    %  then change to input value
    linecolor = paramstruct.linecolor ; 
  end

  if isfield(paramstruct,'titlestr')    %  then change to input value
    titlestr = paramstruct.titlestr ; 
  end

  if isfield(paramstruct,'titlefontsize')    %  then change to input value
    titlefontsize = paramstruct.titlefontsize ; 
  end

  if isfield(paramstruct,'xlabelstr')    %  then change to input value
    xlabelstr = paramstruct.xlabelstr ; 
  end

  if isfield(paramstruct,'ylabelstr')    %  then change to input value
    ylabelstr = paramstruct.ylabelstr ; 
  end

  if isfield(paramstruct,'labelfontsize')    %  then change to input value
    labelfontsize = paramstruct.labelfontsize ; 
  end

  if isfield(paramstruct,'plotbottom')    %  then change to input value
    plotbottom = paramstruct.plotbottom ; 
  end

  if isfield(paramstruct,'plottop')    %  then change to input value
    plottop = paramstruct.plottop ; 
  end

  if isfield(paramstruct,'iplot')    %  then change to input value
    iplot = paramstruct.iplot ; 
  end


end  %  of resetting of input parameters




%  set control parameters
%
ihazard = 0 ;
ilengthb = 0 ;

if  itype == 2  ||  itype == 4 
  ihazard = 1 ;
end

if  itype == 3  ||  itype == 4 
  ilengthb = 1 ;
end



%  detect whether censored or uncensored data
%
if size(data,2) == 1    %  Then is uncensored
  xdat = data(:,1) ;
  vdel = ones(length(xdat),1) ;
  icen = 0 ;
else                    %  Then assume censored
  xdat = data(:,1) ;
  vdel = data(:,2) ;
  icen = 1 ;
end
n = length(xdat) ;



%  Give error message if length biased data are <= 0
%
if ilengthb == 1
  if min(xdat) <= 0
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from CHkdeSM.m:      !!!') ;
    disp('!!!   length biased estimation   !!!') ;
    disp('!!!   requires positive data     !!!') ;
    disp('!!!   Terminating Execution      !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end
end



%  Calculate curve estimate
%
%  Specify grid parameters
nbin = 401 ;         %  Default
lend = min(xdat) ;   %  Default
rend = max(xdat) ;   %  Default
if (length(vxgrid) == 2) || (length(vxgrid) == 3)
                                 %  then use input endpoints
  lend = vxgrid(1) ;
  rend = vxgrid(2) ;
end
if length(vxgrid) == 3         %  then use number of grid points
  nbin = vxgrid(3) ;
end


if lend > rend    %  Then bad range has been input
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from CHkdeSM:    !!!') ;
  disp('!!!   Invalid range chosen   !!!') ;
  disp('!!!   Terminating Execution  !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  bincts = [] ;
else

  if itype == 1  &&  icen == 0     %  ordinary density estimation
    bincts = lbinrSM(xdat,[lend,rend,nbin],eptflag) ;
  else

    [sxdat, vsortind] = sort(xdat) ;
    svdel = vdel(vsortind) ;


    %  Get G bar cumulative (censored case only)
    %
    if icen == 1    %  then are doing censored estimation
      vg = KMcdfSM(sxdat,1 - svdel,1) ;
      vgbar = 1 - vg  ;  
    else     %  are doing uncensored estimation
      vgbar = ones(n,1) ;
    end


    %  Get F bar (hazard case only)
    %
    if ihazard == 1     % then are doing hazard est.
      if ilengthb == 0 
        vf = KMcdfSM(sxdat,svdel,1) ;
      else
        vf = LBcdfSM(sxdat,svdel,1) ;
      end
      vfbar = 1 - vf  ;  
    else
      vfbar = ones(n,1) ;
    end

    %  Get length biased adjustment
    %
    if ilengthb == 1
      vlb = sxdat ;
      vgbartrunc = vgbar + 1 / (2 * n) ;

      mu = (sum(svdel ./ (sxdat .* vgbartrunc)) / n)^(-1) ;
    else
      vlb = ones(n,1) ;
      mu = 1 ;
    end


    vlbar = vfbar .* vgbar .* vlb ;

    msdata = [sxdat, svdel, vlbar] ;

    bincts = CHlbinrSM(msdata,[lend,rend,nbin],eptflag) ;

    if ihazard == 0    %  then should renormalize these counts,
                       %  so that they sum to n
      sbc = sum(bincts) ;
      if sbc > 0
        bincts = n * bincts / sbc ;
      end
    end

  end

end


if eptflag == 1
  n = sum(xdat >= lend  &  xdat <= rend) ;
          %  put this here in case of truncations during binning
end


if n == 0    %  Possible when all data points are censored

  kde = zeros(nbin,length(vh)) ;

else

  %  Loop through bandwidths
  kde = [] ;
  for ih = 1:length(vh)
    h = vh(ih) ;

    %  Create vector of kernel values, at equally spaced grid
    delta = (rend - lend) / (nbin - 1) ;    %  binwidth
    k = nbin - 1 ;    %  index of last nonzero entry of kernel vector
    arg = linspace(0,k * delta / h,k + 1)' ;
    kvec = exp(-(arg.^2) / 2) / sqrt(2 * pi) ;
    kvec = [flipud(kvec(2:k+1)); kvec] ; %#ok<AGROW>

    %  Do actual kernel density estimation
    kdeh = conv(bincts,kvec) ;
    kdeh = kdeh(k+1:k+nbin) / (n * h) ;


    if ilengthb == 1
      kdeh = kdeh * mu ;
    end


    kde = [kde kdeh] ; %#ok<AGROW>
  end

end


xgrid = linspace(lend,rend,nbin)' ;



%  Create matrix of kernels, if this is needed
%
if nargout == 3
  cent = mean([lend; rend]) ;
          %  centerpoint of evaluation grid
  if length(vh) > 1
    mih = vec2matSM(1 ./ vh',nbin) ;
    mker = vec2matSM((xgrid - cent),length(vh)) .* mih;
          %  argument of gaussian kernel
  else
    mih = 1 / vh ;
    mker = (xgrid - cent) .* mih;
          %  argument of gaussian kernel
  end
  mker = exp(-mker.^2 / 2) .* mih / sqrt(2 * pi) ;
          %  Gaussian kernels with mass 1
  mker = 0.05 * mker ;
          %  Make masses = 0.05
end



%  Make plots if no numerical output requested, or if plot requested
%
if  nargout == 0  || ...
      iplot == 1   %  Then make a plot


  if  length(vh) > 3  &&  ~isfield(paramstruct,'linewidth') 
                              %  then need to change default value of linewidth
    linewidth = 0.5 ;
  end


  if isempty(linecolor)
    plot(xgrid,kde,'LineWidth',linewidth) ;
  else
    plot(xgrid,kde,'LineWidth',linewidth,'Color',linecolor) ;
  end

  if  isempty(plottop)  &&  isempty(plotbottom)    %  then adjust top and bottom
    plotbottom = 0 ;
    plottop = max(max(kde)) ;
    plotrange = plottop - plotbottom ;
    plotbottom = plotbottom - 0.05 * plotrange ;
    plottop = plottop + 0.05 * plotrange ;
  elseif isempty(plottop)                          %  then only adjust top
    plottop = max(max(kde)) ;
    plotrange = plottop - plotbottom ;
    plottop = plottop + 0.05 * plotrange ;
  elseif isempty(plotbottom)                       %  then only adjust bottom
    plotbottom = 0 ;
    plotrange = plottop - plotbottom ;
    plotbottom = plotbottom - 0.05 * plotrange ;
  end

  vax = [lend,rend,plotbottom,plottop] ;
  axis(vax) ;


  if  ndataoverlay > 0
                            %  then overlay jitterplot of data
  
    if ~isempty(dolhtseed)
      rng(dolhtseed) ;
    end

    if ndataoverlay == 1
      ndo = min(n,1000) ;
    elseif ndataoverlay == 2
      ndo = n ;
    else
      ndo = min(n,ndataoverlay) ;
    end


    flagleft = (xdat < lend) ;
        %  ones where data below left end
    flagright = (xdat > rend) ;
        %  ones where data above right end
    nleft = sum(flagleft) ;
    nright = sum(flagright) ;
    if nleft + nright > 0    %  then need to deal with points outside range

      if eptflag == 1    %  then truncate data outside range
        xdattrunc = xdat(~(flagleft | flagright)) ;
        vdeltrunc = vdel(~(flagleft | flagright)) ;
            %  keep data that is not (outside left or outside right)
        ntrunc = length(xdattrunc) ;

      else    %  then move outside points to nearest end
        xdattrunc = xdat ;
        vdeltrunc = vdel ;
        if nleft > 0    %  then replace those points with lend
          xdattrunc(flagleft) = lend * ones(nleft,1) ;
        end
        if nright > 0    %  then replace those points with rend
          xdattrunc(flagright) = rend * ones(nright,1) ;
        end
        ntrunc = n ;

      end

    else

      xdattrunc = xdat ;
      vdeltrunc = vdel ;
      ntrunc = n ;

    end


    if ndo < ntrunc    %  then need to subsample
      [~,randperm] = sort(rand(ntrunc,1)) ;
            %  randperm is a random permutation of 1,2,...,ntrunc
      vkeep = randperm(1:ndo) ;
            %  indices of elements to keep for display
      xdatol = xdattrunc(vkeep,:) ;
      vdelol = vdeltrunc(vkeep,:) ;
    else    %  overlay full data set
      xdatol = xdattrunc ;
      vdelol = vdeltrunc ;
      ndo = ntrunc ;
    end


    %  overlay selected data
    %
    vax = axis ;
    plotbottom = vax(3) ;
    ftop = vax(4) ; %#ok<NASGU>
    hold on ;
      yrand = plotbottom + (0.7 + 0.2 * rand(ndo,1)) ...
                                            * (plottop - plotbottom) ;
             %  y coords for jittering

      ndel1 = sum(vdelol) ;
          %  number of deltas = 1 (uncensored)
      nplot = 0 ;
      if ndel1 > 0    %  then there are some uncensored, so plot

        if ibigdot == 1   %  plot deliberately large dots
          plot(xdatol(logical(vdelol)),yrand(logical(vdelol)),[dolcolor 'o'], ...
                                'MarkerSize',1,'LineWidth',2) ;
        else    %  use matlab default dots
          plot(xdatol(logical(vdelol)),yrand(logical(vdelol)),[dolcolor '.']) ;
        end

        nplot = nplot + 1 ;
      end
      if ndel1 < ndo    %  then there are some censored, so plot

        if ibigdot == 1   %  plot deliberately large dots
          plot(xdatol(~logical(vdelol)),yrand(~logical(vdelol)),[cdolcolor 'o'], ...
                                'MarkerSize',1,'LineWidth',2) ;
        else    %  use matlab default dots
          plot(xdatol(~logical(vdelol)),yrand(~logical(vdelol)),[cdolcolor '.']) ;
        end

        nplot = nplot + 1 ;
      end

    hold off ;


    %  reorder, so that overlaid data appears under the smooth
    %
    vachil = get(gca,'Children') ;
    nchil = length(vachil) ;
    vachil = [vachil(nplot+1:nchil); vachil(1:nplot)] ;
    set(gca,'Children',vachil) ;


  end


  if ~isempty(titlestr)
    if isempty(titlefontsize)
      title(titlestr) ;
    else
      title(titlestr,'FontSize',titlefontsize) ;
    end
  end


  if ~isempty(xlabelstr)
    if isempty(labelfontsize)
      xlabel(xlabelstr) ;
    else
      xlabel(xlabelstr,'FontSize',labelfontsize) ;
    end
  end


  if ~isempty(ylabelstr)
    if isempty(labelfontsize)
      ylabel(ylabelstr) ;
    else
      ylabel(ylabelstr,'FontSize',labelfontsize) ;
    end
  end


end



