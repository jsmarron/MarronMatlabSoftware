function adjdata = BatchAdjustCC(rawdata,batchlabels,paramstruct) 
% BATCHADJUSTCC, of adjustment of "centerpoint" of subpopulations,
%   Chris Cabanski's version, which replaces BatchAdjustSM, 
%     and incorporates new graphics features.
%     Intended for simple adjustment of subpopulation mean effects
%     in microarray and related data analysis.
%     Allows output of graphics, including "before" and "after"
%     PCA 2-d Draftsman's plots.
%     Algorithm uses DWD to find an effective direction for adjustment,
%     projects the data in this direction, and then shifts the
%     multivariate subpopulations along this direction vector.
%     This works pairwise, i.e. for a pair of subpopulations
%     For more subpopulations, apply this several times, to groups
%     of subpopulations.  Good choice of groups can be done by first
%     looking at the population structure, e.g. using a class colored
%     version of the PCA 2-d Draftsman's plot given by scatplotSM.
% Inputs:
%   rawdata     - d x n matrix of log gene expression data, 
%                          columns are cases, rows are genes 
%   batchlabels - 1 x n vector of vector of batch labels,
%                          for each case, must be +-1
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1, ...
%                            'field2',values2, ...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%    paramstruct = struct('',, ...
%                         '',, ...
%                         '',) ;
%
%    fields            values
%
%    imeantype        0   (default) move both projected populations to 0
%                                  (sensible for Agilent microarrays and  
%                                   other differentially expressed data)
%                     +1  move -1 data set so projected mean is same as 
%                                        +1 data set
%                                  (sensible when +1 data set is all 
%                                   nonnegative, e.g. Affymetrics microarrays,
%                                   and prefer to view data on that scale)
%                     -1  move +1 data set so projected mean is same as 
%                                        -1 data set
%                                  (sensible when -1 data set is all 
%                                   nonnegative, e.g. Affymetrics microarrays,
%                                   and prefer to view data on that scale)
%
%    viplot           vector of zeros and ones, indicating which plots to make
%                         1st entry:  1 (default) makes "before"
%                                           PCA 2-d Draftsman's plot
%                         2nd entry:  1 (default) makes "projection plot"
%                                           showing DWD performance
%                         3rd entry:  1 makes "afterwards projection plot",
%                                           of DWD applied to adjusted data
%                                           (default is 0, no plot) 
%                         4th entry:  1 (default) makes "after"
%                                           PCA 2-d Draftsman's plot
%                             (use zeros(4,1) for no plots,
%                                  ones(4,1) for all plots)
%
%    icolor           [] for default of:   Red for Batch label = 1, 
%                                          Blue for Batch label = -1
%                     nx3 color matrix:  a color label for each Batch label
%
%    markerstr        [] for default of:  '+' for Batch label = 1, 
%                                         'o' for Batch label = -1
%                     Can be either a single string with symbol to use for marker,
%                         e.g. 'o', '.', '+', 'x'
%                         (see "help plot" for a full list)
%                     Or a character array (n x 1), of these symbols,
%                         One for each data vector, created using:  strvcat
%
%    isubpopkde       0  construct kde using only the full data set
%                     1  (default) partition data into subpopulations, using the color
%                            indicators in icolor (defaults to 0, unless icolor
%                            is an nx3 color matrix), as markers of subsets.
%                            The corresponding mixture colors are then used in
%                            the subdensity plot, and overlaid with the full 
%                            density shown in black
%                     2  Show only the component densities (in corresponding 
%                            colors), without showing the full population
%                            density
%
%    idatovlay        0  Do not overlay data on kde plots (on diagonal)
%                     1  (default) overlay data using heights based on data ordering
%                              Note:  To see "c.d.f. style" increasing line, 
%                                     should also sort the data
%                     2  overlay data using random heights
%                     another integer > 0,  overlay data, using random heights,
%                                           with this numbers as the seed (so can 
%                                           better match data points across plots),
%                                           (should be an integer with <= 8 digits)
%
%    ndatovlay     number of data points overlayed (only has effect for idatovlay > 0)
%                       1  -  (default) overlay up to 1000 points 
%                                           (random choice, when more)
%                       2  -  overlay full data set
%                       n > 2   -  overlay n random points
%
%    datovlaymax      maximum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.6
%
%    datovlaymin      minimum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.5
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                     unspecified:  results only appear on screen
%                     result:  add various plot names (depending 
%                                 on viplot) and add .ps
%
%    titlestr         String for Title of Projection plots 
%                           (will add to this depending on plot)
%                           (leave empty for no title at all)
%                           (default is "Batch Adjustment")
%
%    titlefontsize    Font Size for titles (uses Matlab default)
%                                   (18 is "fairly large")
%
%    legcellstr       Legend Cell String
%                     Use to apply labels to batches
%                     E.g.    legcellstr = {{'Batch 1' 'Batch 2'}} ;
%                         (this "cell within a cell" structure seems
%                          needed to pass in a cell array of strings,
%                          for Matlab 6.0, may be different for other
%                          Matlab versions)
%
%    mlegendcolor     2 x 3 color matrix, corresponding to cell legends above
%                     (defaults to red and blue when set to [] 
%                                  and 2 entries in legcellstr)
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%    minproj          left end of range in projection plots
%                               (default is output of axisSM)
%
%    maxproj          right end of range in projection plots
%                               (default is output of axisSM)
%
%    npc              Number of Principal Component Directions to show
%                     in output plots 1 and 4
%                     Default: 4
%
%
% Output:
%   adjdata     - d x n matrix of adjusted data, 
%                          columns are samples (i.e. cases), rows are genes (i.e. variables)
%    

% Assumes path can find personal functions:
%    bwsjpiSM.m
%    kdeSM.m
%    vec2matSM.m
%    DWD1SM.m
%    curvdatSM.m
%    axisSM.m
%    sepelimdwd.m
%    lbinrSM.m
%    bwrfphSM.m
%    bwosSM.m
%    rootfSM.m
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM.m
%    cquantSM.m
%    pcaSM.m
%    sizerSM.m
%    rmeanSM.m
%    madSM.m
%    projplot1SM.m
%    qqLM.m
%    scatplotSM.m
%    bwrswSM.m
%    nprSM.m
%    sz2SM.m
%    sc2SM.m
%    CHkdeSM.m
%    CHsz1SM.m
%    CHlbinrSM.m
%    KMcdfSM.m
%    LBcdfSM.m


%    Copyright (c) J. S. Marron 2003-2012, Chris Cabanski 2009-2010


%  Set all input parameters to defaults
%
imeantype = 0 ;
viplot = [1; 1; 0; 1] ;
icolor = [] ;    %  reset this later, since default depends on good inputs
markerstr = [] ;
isubpopkde = 1 ;
idatovlay = 1 ;
ndatovlay = 1 ;
datovlaymax = 0.6 ;
datovlaymin = 0.5 ;
savestr = [] ;
titlestr = ['Batch Adjustment'] ;
titlefontsize = [] ;
legcellstr = {} ;
mlegendcolor = [] ;
iscreenwrite = 0 ;
minproj = [] ;
maxproj = [] ;
npc = 4 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2 ;   %  then paramstruct is an argument

  if isfield(paramstruct,'imeantype') ;    %  then change to input value
    imeantype = getfield(paramstruct,'imeantype') ; 
  end ;

  if isfield(paramstruct,'viplot') ;    %  then change to input value
    viplot = getfield(paramstruct,'viplot') ; 
  end ;

  if isfield(paramstruct,'icolor') ;    %  then change to input value
    icolor = getfield(paramstruct,'icolor') ; 
  end ;

  if isfield(paramstruct,'markerstr') ;    %  then change to input value
    markerstr = getfield(paramstruct,'markerstr') ; 
  end ;

  if isfield(paramstruct,'isubpopkde') ;    %  then change to input value
    isubpopkde = getfield(paramstruct,'isubpopkde') ; 
  end ;

  if isfield(paramstruct,'idatovlay') ;    %  then change to input value
    idatovlay = getfield(paramstruct,'idatovlay') ; 
  end ;

  if isfield(paramstruct,'ndatovlay') ;    %  then change to input value
    ndatovlay = getfield(paramstruct,'ndatovlay') ; 
  end ;

    if isfield(paramstruct,'datovlaymax') ;    %  then change to input value
    datovlaymax = getfield(paramstruct,'datovlaymax') ; 
  end ;

  if isfield(paramstruct,'datovlaymin') ;    %  then change to input value
    datovlaymin = getfield(paramstruct,'datovlaymin') ; 
  end ;

  if isfield(paramstruct,'savestr') ;    %  then use input value
    savestr = getfield(paramstruct,'savestr') ; 
    if ~ischar(savestr) ;    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from BatchAdjustCC.m:    !!!') ;
      disp('!!!   Invalid savestr,                 !!!') ;
      disp('!!!   using default of no save         !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end ;
  end ;

  if isfield(paramstruct,'titlestr') ;    %  then change to input value
    titlestr = getfield(paramstruct,'titlestr') ; 
  end ;

  if isfield(paramstruct,'titlefontsize') ;    %  then change to input value
    titlefontsize = getfield(paramstruct,'titlefontsize') ; 
  end ;

  if isfield(paramstruct,'legcellstr') ;    %  then change to input value
    legcellstr = getfield(paramstruct,'legcellstr') ; 
  end ;

  if isfield(paramstruct,'mlegendcolor') ;    %  then change to input value
    mlegendcolor = getfield(paramstruct,'mlegendcolor') ; 
  end ;

  if isfield(paramstruct,'iscreenwrite') ;    %  then change to input value
    iscreenwrite = getfield(paramstruct,'iscreenwrite') ; 
  end ;

  if isfield(paramstruct,'minproj') ;    %  then change to input value
    minproj = getfield(paramstruct,'minproj') ; 
  end ;

  if isfield(paramstruct,'maxproj') ;    %  then change to input value
    maxproj = getfield(paramstruct,'maxproj') ; 
  end ;

  if isfield(paramstruct,'npc') ;    %  then change to input value
    npc = getfield(paramstruct,'npc') ; 
  end ;

end ;    %  of resetting of input parameters



%  Set internal parameters
%
d = size(rawdata,1) ;
n = size(rawdata,2) ;
npixshift = 20 ;
    %  number of pixels to shift new figures by



%  Check inputs
%
errflag = logical(0) ;
if  (n ~= size(batchlabels,2))  | ...
    (1 ~= size(batchlabels,1))  ;

  errflag = logical(1) ;

  errstr = ['input "batchlabels" must be a row vector ' ...
                     'of length ' num2str(n)] ;

elseif  (sum(batchlabels == 1) + sum(batchlabels == -1))  ~=  n  ;

  errflag = logical(1) ;

  errstr = 'entries in "batchlabels" must all be +- 1' ;
  
end ;


if errflag ;    %  then had a fatal input error

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from BatchAdjustCC.m:                   !!!') ;
  disp(['!!!   ' errstr]) ;
  disp('!!!   Terminating execution, with an empty return   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  adjdata = [] ;
  return ;

else ;    %  inputs OK, so do serious work


  if ~iscell(legcellstr) ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from BatchAdjustCC:          !!!') ;
    disp('!!!   legcellstr is not a cell string      !!!') ;
    disp('!!!   Will turn off the Legend Cell String !!!') ;
    disp('!!!   i.e. the text with batch labels      !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    legcellstr = {} ;

  else ;

    if length(legcellstr) > 2 ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from BatchAdjustCC:       !!!') ;
      disp('!!!   legcellstr is too big,            !!!') ;
      disp('!!!   Will use only first two entries   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      legcellstr = legcellstr([1,2]) ;

    end ;

  end ;


  if length(viplot) ~= 4 ;

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from BatchAdjustCC.m:   !!!') ;
    disp('!!!   Invalid size of viplot,         !!!') ;
    disp('!!!   reverting to default            !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    viplot = [1; 1; 0; 1] ;
  
  end ;

  viplot = logical(viplot) ;
      %  make sure this is logical, 
      %  for use in if statements below

  if isempty(icolor) ;
    icolor = [(batchlabels == 1)' zeros(n,2)] + ...
                  [ zeros(n,2) (batchlabels == -1)']; 
  end ;

  if isempty(markerstr) ;    %  then need to set default markerstr
    for i = 1:length(batchlabels) ;
      if batchlabels(i) == 1 ;
        markerstr = strvcat(markerstr,'+') ;
      elseif batchlabels(i) == -1 ;
        markerstr = strvcat(markerstr,'o') ;
      else ;    %  should never get here, due to above check
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Warning from BatchAdjustCC:          !!!') ;
        disp(['!!!   batchlabels(' num2str(i) ') not in correct format ']) ;
        disp('!!!   i.e. value is neither +1 nor -1      !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      end ;
    end ;
  end ;

  if  length(legcellstr) == 2  &  isempty(mlegendcolor)  ;
    mlegendcolor = [[1 0 0]; [0 0 1]] ;
  end


  %  Do DWD Batch adjustment
  %
  flagp = (batchlabels == 1) ;
  flagn = (batchlabels == -1) ;
  np = sum(flagp) ;
  nn = sum(flagn) ;
  icolorp = icolor(flagp,:) ;
  icolorn = icolor(flagn,:) ;


  %  Find DWD direction
  %
  dirvec = DWD1SM(rawdata(:,flagp),rawdata(:,flagn)) ;


  %  Project data
  %
  vprojp = rawdata(:,flagp)' * dirvec ;
  vprojn = rawdata(:,flagn)' * dirvec ;

  meanprojp = mean(vprojp) ;
  meanprojn = mean(vprojn) ;


  %  Do shift along direction vector
  %
  if imeantype == -1 ;    %  move +1 data, so projected mean is same as -1 data
    adjdata(:,flagp) = rawdata(:,flagp) - vec2matSM(meanprojp * dirvec,length(vprojp)) ...
                                        + vec2matSM(meanprojn * dirvec,length(vprojp)) ;
    adjdata(:,flagn) = rawdata(:,flagn) ;
  elseif imeantype == 1 ;    %  move -1 data, so projected mean is same as +1 data
    adjdata(:,flagp) = rawdata(:,flagp) ;
    adjdata(:,flagn) = rawdata(:,flagn) - vec2matSM(meanprojn * dirvec,length(vprojn)) ...
                                        + vec2matSM(meanprojp * dirvec,length(vprojn)) ;
  else ;    %  move both projected populations to 0
    adjdata(:,flagp) = rawdata(:,flagp) - vec2matSM(meanprojp * dirvec,length(vprojp)) ;
    adjdata(:,flagn) = rawdata(:,flagn) - vec2matSM(meanprojn * dirvec,length(vprojn)) ;
  end ;


  %  Subtract respective class means
  %
%  adjdata(:,flagp) = rawdata(:,flagp) - vec2matSM(meanprojp * dirvec,length(vprojp)) ;
%  adjdata(:,flagn) = rawdata(:,flagn) - vec2matSM(meanprojn * dirvec,length(vprojn)) ;



  %  Make graphics (if needed)
  %
  fignum = 1 ;
  if viplot(1) ;    %  then make "before" 2-d scatterplot matrix

    figure(fignum) ;
    clf ;
    fignum = fignum + 1 ;
    set(gcf,'Name','PCA 2-d Projections, Before') ;

    paramstruct = struct('npcadiradd',npc, ...
                         'irecenter',0, ...
                         'icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'isubpopkde',isubpopkde, ...
                         'idatovlay',idatovlay, ...
                         'ndatovlay',ndatovlay, ...
                         'datovlaymax',datovlaymax, ...
                         'datovlaymin',datovlaymin, ...
                         'mlegendcolor',mlegendcolor, ...
                         'iscreenwrite',iscreenwrite) ;

    if ~isempty(savestr) ;
      paramstruct = setfield(paramstruct, ...
                            'savestr',[savestr 'PCA2dBefore']) ;
    end ;

    if ~isempty(legcellstr) ;
      paramstruct = setfield(paramstruct, ...
                            'legendcellstr',legcellstr) ;
    end ;

    scatplotSM(rawdata,[],paramstruct) ;

  end ;



  if viplot(2) ;    %  then make DWD projection plot

    if fignum == 1 ;    %  then this figure is first
      figure(1) ;
      clf ;
    else ;    %  then have an earlier figure, so shift this one
      vpos = get(gcf,'Position') ;
      vpos = [(vpos(1) + npixshift) ...
              (vpos(2) - npixshift) ...
               vpos(3) vpos(4)] ;
      figure(fignum) ;
      clf ;
      set(gcf,'Position',vpos) ;
    end ;
    set(gcf,'Name','DWD Projections') ;


    if  isempty(minproj)  &  isempty(maxproj) ;
      vaxlim = [] ;    %  Just use axisSM defaults
    else ;
      vproj = rawdata' * dirvec ;    %  column vector of projections
      vaxlim = axisSM(vproj) ;
      if ~isempty(minproj) ;
        vaxlim(1) = minproj ;
      end ;
      if ~isempty(maxproj) ;
        vaxlim(2) = maxproj ;
      end ;
    end ;

    if ~isempty(titlestr) ;
      titlestrin = [titlestr ', Proj. on DWD'] ;
    else ;
      titlestrin = [] ;
    end ;

    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'isubpopkde',isubpopkde, ...
                         'idatovlay',idatovlay, ...
                         'ndatovlay',ndatovlay, ...
                         'datovlaymax',datovlaymax, ...
                         'datovlaymin',datovlaymin, ...
                         'mlegendcolor',mlegendcolor, ...
                         'vaxlim',vaxlim, ...
                         'titlestr',titlestrin, ...
                         'titlefontsize',titlefontsize, ...
                         'ifigure',fignum, ...
                         'iscreenwrite',iscreenwrite) ;

    if ~isempty(savestr) ;
      paramstruct = setfield(paramstruct, ...
                            'savestr',[savestr 'DWDproj']) ;
    end ;

    if ~isempty(legcellstr) ;
      paramstruct = setfield(paramstruct, ...
                            'legendcellstr',legcellstr) ;
    end ;

    projplot1SM(rawdata,dirvec,paramstruct) ;


    fignum = fignum + 1 ;

  end ;



  if viplot(3) ;    %  then repeat DWD, for checking, and make projection plot

    if fignum == 1 ;    %  then this figure is first
      figure(1) ;
      clf ;
    else ;    %  then have an earlier figure, so shift this one
      vpos = get(gcf,'Position') ;
      vpos = [(vpos(1) + npixshift) ...
              (vpos(2) - npixshift) ...
               vpos(3) vpos(4)] ;
      figure(fignum) ;
      clf ;
      set(gcf,'Position',vpos) ;
    end ;
    set(gcf,'Name','Check DWD Proj. for Adjusted Data') ;

    %  Find DWD direction for adjusted data
    %
    dirvec = DWD1SM(adjdata(:,flagp),adjdata(:,flagn)) ;


    if  isempty(minproj)  &  isempty(maxproj) ;
      vaxlim = [] ;    %  Just use axisSM defaults
    else ;
      vproj = adjdata' * dirvec ;    %  column vector of projections
      vaxlim = axisSM(vproj) ;
      if ~isempty(minproj) ;
        vaxlim(1) = minproj ;
      end ;
      if ~isempty(maxproj) ;
        vaxlim(2) = maxproj ;
      end ;
    end ;

    if ~isempty(titlestr) ;
      titlestrin = [titlestr ', Proj. on Repeat DWD'] ;
    else ;
      titlestrin = [] ;
    end ;

    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'isubpopkde',isubpopkde, ...
                         'idatovlay',idatovlay, ...
                         'ndatovlay',ndatovlay, ...
                         'datovlaymax',datovlaymax, ...
                         'datovlaymin',datovlaymin, ...
                         'mlegendcolor',mlegendcolor, ...
                         'vaxlim',vaxlim, ...
                         'titlestr',titlestrin, ...
                         'titlefontsize',titlefontsize, ...
                         'ifigure',fignum, ...
                         'iscreenwrite',iscreenwrite) ;

    if ~isempty(savestr) ;
      paramstruct = setfield(paramstruct, ...
                            'savestr',[savestr 'DWDrepeatProj']) ;
    end ;

    if ~isempty(legcellstr) ;
      paramstruct = setfield(paramstruct, ...
                            'legendcellstr',legcellstr) ;
    end ;

    projplot1SM(adjdata,dirvec,paramstruct) ;


    fignum = fignum + 1 ;


  end ;



  if viplot(4) ;    %  then make "after" 2-d scatterplot matrix

    if fignum == 1 ;    %  then this figure is first
      figure(1) ;
      clf ;
    else ;    %  then have an earlier figure, so shift this one
      vpos = get(gcf,'Position') ;
      vpos = [(vpos(1) + npixshift) ...
              (vpos(2) - npixshift) ...
               vpos(3) vpos(4)] ;
      figure(fignum) ;
      clf ;
      set(gcf,'Position',vpos) ;
    end ;
    set(gcf,'Name','PCA 2-d Projections, After') ;
    fignum = fignum + 1 ;

    paramstruct = struct('npcadiradd',npc, ...
                         'irecenter',0, ...
                         'icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'isubpopkde',isubpopkde, ...
                         'idatovlay',idatovlay, ...
                         'ndatovlay',ndatovlay, ...
                         'datovlaymax',datovlaymax, ...
                         'datovlaymin',datovlaymin, ...
                         'mlegendcolor',mlegendcolor, ...
                         'iscreenwrite',iscreenwrite) ;

    if ~isempty(savestr) ;
      paramstruct = setfield(paramstruct, ...
                            'savestr',[savestr 'PCA2dAfter']) ;
    end ;

    if ~isempty(legcellstr) ;
      paramstruct = setfield(paramstruct, ...
                            'legendcellstr',legcellstr) ;
    end ;

    scatplotSM(adjdata,[],paramstruct) ;


  end ;


end ;

