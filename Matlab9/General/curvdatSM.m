function curvdatSM(data,paramstruct) 
% CURVDATSM, CURVes as DATa analysis, 
%   Steve Marron's matlab function
%     Does several types of analysis when the atoms,
%     i.e. data objects, are curves
%     Includes: PCA, with graphical displays
%               SiZer and QQ analysis of projections
%               Draftsman's bivariate projection plots
%     Variations: 
%         Pre-transformations:
%                Correlations, Spearman's Correlations, 
%                project to sphere/ellipse
%         Post-transformations:
%                Varimax (w/ arbitrary basis)
%     Note:  philosophy is to provide a decomposition of 
%            entered family of curves.  So even when 
%            tranformations (e.g. to sphere) are used,
%            these only determine directions, and 
%            projections of raw data are displayed
%
% Inputs:
%   data    - d x n matrix of data, each column vector is 
%                     a "d-dim digitized curve"
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
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    itype            Index of (pretransformation) PCA type:
%                     1  (default) Standard Principal Components
%                     2  Correlation Principal Components
%                     3  Spearman's Correlation PCA
%                     4  Shrink to sphere PCA
%                     5  map to ellipse (determined by MAD) PCA
%
%    viout            Vector of indices for output plots:
%                     1  (default) Standard eigenvectors and projections
%                     2  SiZer and Gaussian Q-Q analysis of 1d projections
%                                    ('SZQQ' is added to savestr)
%                     3  Scatterplot Matrix of 2d projections
%                                    ('SMP2d' is added to savestr)
%
%    vipcplot         Vector of Indices of Principal Components to PLOT
%                        (default = [0 1 2 3 4])
%                        0 means include "top row" with raw data,
%                                 mean, mean residual and power plot
%                        Other numbers are indices of PCs to plot
%                            No more than 5 total (4 nonzero) is 
%                            recommended (otherwise lose detail in plots)
%                        Values larger than rank(mdat) will be truncated
%
%    vicolplot        Vector of Indices of Columns in main plot
%                        (default = [1 2 3 4])
%                        For rows with ipclot = 0  (i.e. "top row"):
%                          1  Raw Data
%                          2  Center (e.g. mean)
%                          3  Center Residuals
%                          4  R^2 Power plot
%                        For other rows (i.e. PC's)
%                          1  PC Projections
%                          2  Center +- Extreme Projections
%                          3  Remaining Residuals
%                          4  Scores kde & jitter plot
%
%    viSiZer          Vector of Indices for SiZer - QQ Components to plot
%                        (default = [1 2 3 4])
%                        1  Family plot for scores
%                        2  SiZer map
%                        3  SiCon map
%                        4  Gaussian Q-Q plot
%
%    nevcompute       Number of EigenVectors to compute 
%                        (for display in R^2 power plot)
%                        (default = min(10,rank(mdat)))
%                        Will be reset to rank(mdat) if larger
%                        Will be reset to max(vievplot) if smaller
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default)  color version (Matlab defaults)
%                     2  time series version (ordered spectrum of colors)
%                     3  black and white time series version 
%                             (ordered spectrum of gray levels)
%                     nx3 color matrix:  a color label for each data point
%                             (to be used everywhere, except SiZer & QQ
%                              useful for comparing classes)
%
%    isubpopkde       0  (default) construct kde using only the full data set
%                     1  partition data into subpopulations, using the color
%                            indicators in icolor (defaults to 0, unless icolor
%                            is an nx3 color matrix), as markers of subsets.
%                            The corresponding mixture colors are then used in
%                            the subdensity plot, and overlaid with the full 
%                            density shown in black
%                     2  Show only the component densities (in corresponding 
%                            colors), without showing the full population
%                            density
%
%    markerstr        Can be either a single string with symbol to use for marker,
%                         e.g. 'o' (default), '.', '+', 'x'
%                         (see "help plot" for a full list)
%                     Or a character array (n x 1), of these symbols,
%                         One for each data vector, created using:  strvcat
%
%    ivarimax         0  (default) no varimax (post PCA) rotation
%                     1  do varimax, with basis defined in vmbasis,
%                            rotation will be of subspace of
%                            eigen-directions in vipcplot
%
%    vmbasis          d x d basis matrix (default is identity)
%                     this is the "target" basis, i.e. this basis
%                     will be preserved by the varimax rotation
%                     E.g. to focus on Fourier directions,
%                     put Fourier basis elements in columns
%
%    vmpower          scalar power to control variations of varimax
%                     0  (default) standard orthogonal rotation
%                     1  preserves uncorrelation of scores
%                    -1  preserves uncorrelation of inner products
%                              of data with direction vectors
%                     CAUTION:  when this is non-zero, no longer get
%                         orthonormal directions, so sum of squares and
%                         draftsman's plots are no longer interpretable
%
%    qqnsim           0  overlay no envelope when doing QQ plots
%                     >0  overlay a simulated envelope of that many
%                            (default 100)
%
%    idataconn        indices of data points to connect with line segments
%                     []  (default) for not connectiong any data points
%                     otherwise : x 2 matrix of pairs of indices of data points]
%                     (thus all intergers from 1,...,n).
%                     For time series data, this can give a clearer view of the 
%                     data ordering by using [[1, 2];[2, 3];[3, 4];...].
%                     For bias adjustment, with matched pairs, each row should
%                     have the ind0ces of the matches.
%
%    idataconncolor   can be any of 'r', 'g', 'b', etc., to use that color for all
%                     default is 'k'
%                     or can be 2 (or 3) for easy rainbow (gray level) coloring, 
%                         intended for time series of curves
%                         (Caution: this will use the first part of icolor,
%                          so might make most sense to use with icolor = 2  
%                          (3 resp.), to avoid strange results)
%                     or can be color matrix, where the number of rows  
%                     is the same as the number of rows of idataconn
%                         (has no effect for idataconn = [])
%
%    idataconntype    can be any of '-', '--', '-.', ':'
%                     default is '-'
%                     or can be character array (created using strvcat) of these, 
%                     where the number of rows is the same as 
%                     the number of rows of idataconn
%                         (has no effect for idataconn = [])
%                         Only has effect when markerstr = '.' 
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%
%    dolhtseed        seed for random heights used in PC overlay jitter plot
%                         default is [] (for using current Matlab seed) 
%                         when this is nonempty, use SAME seed in each plot
%                         (so can better match data points across plots),
%                         otherwise different seed for different plots
%                                (should be an integer with <= 8 digits)
%                         Only affects SiZer plots
%
%    qqseed           seed for qq simulated overlay (to display randomness)
%                         default is [] (for using current Matlab seed) 
%                                (should be an integer with <= 8 digits)
%
%    legendcellstr    cell array of strings for legend (nl of them),
%                     useful for (colored) classes, create this using
%                     cellstr, or {{string1 string2 ...}}
%                     also a way to add a "title" to the first plot
%                             for this, use input of form:  {{string}}
%
%    mlegendcolor     nl x 3 color matrix, corresponding to cell legends above
%                     (not needed when legendcellstr not specified)
%                     (defaults to black when not specified)
%
%    iaxlim           index for controlling axis limits
%                     For vertical axes in curve plots (horizontal is 1,...,d), 
%                     for horizontal axes in 1-d kde projections,
%                     and for both axes in scatterplots
%                         Use 0 for default of each automatically chosen, by axisSM
%                             (generally rcommended as showing the most detail
%                              in each plot, but differing axes can be tricky)
%                         Use 1 for global choice, which gives a view that
%                         highlights "visual changes in variation":
%                             (default for Raw Data, same for Mean, and Center +-
%                              default for Center Resid, same for all Proj & Resid.)
%                         Use 2 for symmetrically chosen version of 1
%                             (can be useful when centering is critical)
%
%    iplotaxes        0 do not plot axes, in 2D Draftsman's Plots (scatterplots)
%                     1 (default) plot axes as determined by direction vectors, 
%                           using thin line type
%
%    idiffigwind      index for putting graphics in different figure windows:
%                         0 - (default) put all plots in same window
%                         1 - put each plot in a new window
%                                  (useful for keeping several Matlab
%                                   plots active on the screen)
%
%    isingleaxis      index for keeping graphics in single axis
%                         0 - (default) create needed subplot structure
%                         1 - use outside subplot structure
%                                  Requires (when used):
%                                          length(vipcplot) = 1
%                                          length(vicolplot) = 1
%                                          length(viSiZer) = 1
%                                  Has no effect where viout = 3.
%                                  (useful for manually creating single
%                                   plot graphics for figures)
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                       Will add file suffix determined by savetype
%                         unspecified:  results only appear on screen
%                       Note:  when savestr is nonempty, and ifigure = 0,
%                            give warning and reset ifigure to 1
%
%    savetype         indicator of output file type:
%                         1 - (default)  Matlab figure file (.fig)
%                         2 - (.png)  raster graphics
%                         3 - (.pdf)  vector graphics
%                         4 - (.eps)  Color vector 
%                                     (use when icolor is not 0)
%                         5 - (.eps)  Black and White vector 
%                                     (use when icolor = 0)
%                         6 - (.jpg)  raster
%                         7 - (.svg)  vector
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%
% Outputs:
%     Graphics in current Figure
%        (or several figures, when idiffigwind = 1)
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
%
% Assumes path can find personal functions:
%    bwsjpiSM.m
%    kdeSM.m
%    lbinrSM.m
%    pcaSM.m
%    sizerSM.m
%    vec2matSM.m
%    rmeanSM.m
%    madSM.m
%    Plot1dSM.m
%    projplot1SM.m
%    qqLM.m
%    scatplotSM.m
%    bwrswSM.m
%    nprSM.m
%    sz2SM.m
%    sc2SM.m
%    CHkdeSM
%    CHsz1SM
%    bwrfphSM.m
%    bwosSM.m
%    rootfSM
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM
%    cquantSM
%    CHlbinrSM.m
%    KMcdfSM.m
%    LBcdfSM.m
%    axisSM.m
%    printSM.m

%    Copyright (c) J. S. Marron 1998-2023


%  First set all parameters to defaults
%
itype = 1 ;
ivarimax = 0 ;
vmbasis = [] ;
vmpower = 0 ;
viout = 1 ;
vipcplot = [0 1 2 3 4] ;
vicolplot = [1 2 3 4] ;
viSiZer = [1 2 3 4] ;
nevcompute = 10 ;
icolor = 1 ;
markerstr = 'o' ;
isubpopkde = 0 ;
qqnsim = 100 ;
idataconn = [] ;
idataconncolor = 'k' ;
idataconntype = '-' ;
ibigdot = 0 ;
dolhtseed = [] ;
qqseed = [] ;
legendcellstr = {} ;
mlegendcolor = [] ;
iaxlim = 0 ;
iplotaxes = 1 ;
idiffigwind = 0 ;
isingleaxis = 0 ;
savestr = [] ;
savetype = 1 ;
iscreenwrite = 0 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1   %  then paramstruct is an argument

  if isfield(paramstruct,'itype')    %  then change to input value
    itype = paramstruct.itype ; 
  end

  if isfield(paramstruct,'ivarimax')    %  then change to input value
    ivarimax = paramstruct.ivarimax ; 
  end

  if isfield(paramstruct,'vmbasis')    %  then change to input value
    vmbasis = paramstruct.vmbasis ; 
  end

  if isfield(paramstruct,'vmpower')    %  then change to input value
    vmpower = paramstruct.vmpower ; 
  end

  if isfield(paramstruct,'viout')    %  then change to input value
    viout = paramstruct.viout ; 
  end

  if isfield(paramstruct,'vipcplot')    %  then change to input value
    vipcplot = paramstruct.vipcplot ; 
  end

  if isfield(paramstruct,'vicolplot')    %  then change to input value
    vicolplot = paramstruct.vicolplot ; 
  end

  if isfield(paramstruct,'viSiZer')    %  then change to input value
    viSiZer = paramstruct.viSiZer ; 
  end

  if isfield(paramstruct,'nevcompute')    %  then change to input value
    nevcompute = paramstruct.nevcompute ; 
  end

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ; 
  end

  if isfield(paramstruct,'markerstr')    %  then change to input value
    markerstr = paramstruct.markerstr ; 
  end

  if isfield(paramstruct,'isubpopkde')    %  then change to input value
    isubpopkde = paramstruct.isubpopkde ; 
  end

  if isfield(paramstruct,'qqnsim')    %  then change to input value
    qqnsim = paramstruct.qqnsim ; 
  end

  if isfield(paramstruct,'idataconn')    %  then change to input value
    idataconn = paramstruct.idataconn ; 
  end

  if isfield(paramstruct,'idataconncolor')    %  then change to input value
    idataconncolor = paramstruct.idataconncolor ; 
  end

  if isfield(paramstruct,'idataconntype')    %  then change to input value
    idataconntype = paramstruct.idataconntype ; 
  end

  if isfield(paramstruct,'ibigdot')    %  then change to input value
    ibigdot = paramstruct.ibigdot ; 
  end

  if isfield(paramstruct,'dolhtseed')    %  then change to input value
    dolhtseed = paramstruct.dolhtseed ; 
  end

  if isfield(paramstruct,'qqseed')    %  then change to input value
    qqseed = paramstruct.qqseed ; 
  end

  if isfield(paramstruct,'legendcellstr')    %  then change to input value
    legendcellstr = paramstruct.legendcellstr ; 
  end

  if isfield(paramstruct,'mlegendcolor')    %  then change to input value
    mlegendcolor = paramstruct.mlegendcolor ; 
  end

  if isfield(paramstruct,'iaxlim')    %  then change to input value
    iaxlim = paramstruct.iaxlim ; 
  end

  if isfield(paramstruct,'iplotaxes')    %  then change to input value
    iplotaxes = paramstruct.iplotaxes ; 
  end

  if isfield(paramstruct,'idiffigwind')    %  then change to input value
    idiffigwind = paramstruct.idiffigwind ; 
  end

  if isfield(paramstruct,'isingleaxis')    %  then change to input value
    isingleaxis = paramstruct.isingleaxis ; 
  end

  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstruct.savestr ; 
    if ~ischar(savestr)    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from curvdatSM.m:    !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'savetype')     %  then use input value
    savetype = paramstruct.savetype ; 
  end 

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ; 
  end


end    %  of resetting of input parameters



%  Turn viout into control parameters
%
vipageout = zeros(3,1) ;

if sum(viout == 1) > 0    %  if 1 appears in viout
  vipageout(1) = 1 ;
end

if sum(viout == 2) > 0    %  if 2 appears in viout
  vipageout(2) = 1 ;
end

if sum(viout == 3) > 0    %  if 3 appears in viout
  vipageout(3) = 1 ;
end



%  Check isingleaxis is allowable
%
if isingleaxis ~=0

  iresetisa = 0 ;

  if sum(viout == 1) > 0    %  if 1 appears in viout
    if (length(vipcplot) ~= 1) || (length(vicolplot) ~= 1)
      iresetisa = 1 ;
    end
  end

  if sum(viout == 2) > 0    %  if 2 appears in viout
    if (length(vipcplot) ~= 1) || (length(viSiZer) ~= 1)
      iresetisa = 1 ;
    end
  end

  if iresetisa == 1
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from CurvDatSM.m:   !!!') ;
    disp('!!!   Invalid isingleaxis,        !!!') ;
    disp('!!!   resetting to default of 0   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    isingleaxis = 0 ;
  end

end



%  set preliminary stuff
%
d = size(data,1) ;
         %  dimension of each data curve
n = size(data,2) ;
         %  number of data curves


if  (size(icolor,1) > 1)  ||  (size(icolor,2) > 1)    %  if have color matrix
  if ~(3 == size(icolor,2))
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from scatplotSM.m:               !!!') ;
    disp('!!!   icolor as a matrix must have 3 columns    !!!') ;
    disp('!!!   Resetting to icolor = 1, Matlab default   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    icolor = 1 ;
  elseif ~(n == size(icolor,1))
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from scatplotSM.m:               !!!') ;
    disp(['!!!   icolor as a matrix must have ' num2str(n) ' rows']) ;
    disp('!!!   Resetting to icolor = 1, Matlab default   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    icolor = 1 ;
  end
end



%  Set up appropriate colors
%
if  size(icolor,1) == 1  &&  size(icolor,2) == 1    %  then have scalar input

  if icolor == 0    %  then do everything black and white

    datacolor = 'k' ;
    meancolor = 'k' ;
%    kdecolor = 'k' ;    %  Don't need, since set in Plot1dSM
    dotcolor = 'k' ;
        %  color of projection dots
    evcolor = 'k' ;
        %  color of eigenvalues
    cevcolor = 'k' ;
        %  color of cumulative eigenvalues

    indivcolorflag = 0 ;
    icolorprint = 0 ;

  elseif icolor == 1    %  then do full color 

    datacolor = [] ;    % use default matlab mixed colors
    meancolor = 'k' ;
%    kdecolor = 'k' ;    %  Don't need, since set in Plot1dSM
    dotcolor = [] ;
        %  color of projection dots
    evcolor = 'b' ;
        %  color of eigenvalues
    cevcolor = 'r' ;
        %  color of cumulative eigenvalues

    indivcolorflag = 0 ;
    icolorprint = 1 ;

  elseif icolor == 2    %  then do spectrum for ordered time series

    colmap = RainbowColorsQY(n) ;

    meancolor = 'k' ;
%    kdecolor = 'k' ;    %  Don't need, since set in Plot1dSM
    dotcolor = 'g' ;
        %  color of projection dots
    evcolor = 'm' ;
        %  color of eigenvalues
    cevcolor = 'c' ;
        %  color of cumulative eigenvalues

    indivcolorflag = 1 ;
    icolorprint = 1 ;

  elseif icolor == 3    %  then do gray levels for ordered time series

    %  set up color map stuff
    %
    startgray = 0.9 ;
    vgray = linspace(startgray,0,n) ;
    colmap = vgray' * ones(1,3) ;

    meancolor = 'k' ;
%    kdecolor = 'k' ;    %  Don't need, since set in Plot1dSM
    dotcolor = 'k' ;
        %  color of projection dots
    evcolor = 'k' ;
        %  color of eigenvalues
    cevcolor = [0.5 0.5 0.5] ;
        %  color of cumulative eigenvalues

    indivcolorflag = 1 ;
    icolorprint = 1 ;
        %  Leave this as "color" to get gray levels to show up in .ps file

  end

else    %  then have color matrix (validity was checked in warnings above

  colmap = icolor ;

  meancolor = 'k' ;
%    kdecolor = 'k' ;    %  Don't need, since set in Plot1dSM
  dotcolor = 'g' ;
      %  color of projection dots
  evcolor = 'm' ;
      %  color of eigenvalues
  cevcolor = 'k' ;
      %  color of cumulative eigenvalues

  indivcolorflag = 1 ;
  icolorprint = 1 ;

end



if ~isempty(legendcellstr)
  nlegend = length(legendcellstr) ;
  if isempty(mlegendcolor)
    mlegendcolor = vec2matSM(zeros(1,3),nlegend) ;
        %  all black when unspecified
  end
end


if ivarimax == 1
  varimaxstr = 'VM ' ;
  if isempty(vmbasis)
    vmbasis = eye(d) ;
  end
else
  varimaxstr = '' ;
end





%  get mean and subtract to get residuals
%  and do pretransformation
%
if itype == 1    %  Standard PCA

  vcenter = mean(data,2) ;
      %  component-wise mean
  ssc = n * sum(vcenter.^2) ;
  mresid = data - vec2matSM(vcenter,n) ;
  sscr = sum(sum(mresid .^ 2)) ;

  tmresid = mresid ;
      %  transformed version of residuals
%  sstmr = sscr ;

  centerst = 'Mean' ;
  typestr = 'Standard PCA' ;

elseif itype == 2    %  Correlation PCA

  vcenter = mean(data,2) ;
      %  component-wise mean
  ssc = n * sum(vcenter.^2) ;
  mresid = data - vec2matSM(vcenter,n) ;
  sscr = sum(sum(mresid .^ 2)) ;

  vsd = std(data,0,2) ;
      %  componentwise standard deviation
  flag0 = vsd == 0 ;
  nflag0 = sum(flag0) ;
  if nflag0 > 0    %  need to avoid division by 0
    vsd(flag0) = ones(nflag0,1) ;
        %  replace by 1, since these are all 0 after subt'ing mean
  end
  tmresid = mresid ./ vec2matSM(vsd,n) ;
      %  transformed version of residuals
%  sstmr = sum(sum(tmresid .^ 2)) ;

  centerst = 'Mean' ;
  typestr = 'Correlation PCA' ;

elseif itype == 3    %  Spearman Correlation PCA

  vcenter = median(data,2) ;
      %  component-wise median
  ssc = n * sum(vcenter.^2) ;
  mresid = data - vec2matSM(vcenter,n) ;
  sscr = sum(sum(mresid .^ 2)) ;

  [~,msind] = sort(mresid') ;
          %  Transpose, since want "coordinates as variables"
          %  Sort gives indices for doing sort
  mrank = [] ;
  vind = (1:n)' ;
  for i = 1:d
    mrank = [mrank, vind(msind(:,i))] ;
          %  matrix of ranks
  end

  tmresid = mrank' ;
      %  transformed version of residuals
%  sstmr = sscr ;
%  sstmr = sum(sum(tmresid .^ 2)) ;

  centerst = 'Median' ;
  typestr = 'Spearman Corr PCA' ;

elseif itype == 4    %  Shrink to sphere PCA

  vcenter = rmeanSM(data',(10^-6),20,0)' ;
          %  Huber's L1 M-estimate
          %  accuracy parameters, and 0 for no screen writes
  ssc = n * sum(vcenter.^2) ;
  mresid = data - vec2matSM(vcenter,n) ;
  sscr = sum(sum(mresid .^ 2)) ;

  vrad = sqrt(sum(mresid .^2)) ;
          %  Transpose, since want "coordinates as variables"
          %  vector of radii of each curve
  sphereresid = mresid' ./ vec2matSM(vrad',d) ;
          %  make each curve have "length" one

  tmresid = sphereresid' ;
      %  transformed version of residuals
%  sstmr = sum(sum(tmresid .^ 2)) ;

  centerst = 'L1 M-est.' ;
  typestr = 'Spherical PCA' ;

elseif itype == 5    %  Shrink to Ellipse PCA

  vmad = madSM(data')' ;
          %  column vector of MADs of each row

  flag0mad = (vmad == 0) ;
  n0mad = sum(flag0mad) ;
          %  one where vmad = 0 
  if n0mad > 0    %  then have some zero mad's
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from CurvDatSM.m:   !!!') ;
    disp(['!!!   Have 0 mad in ' num2str(n0mad) ' coordinates']) ;
    disp('!!!   will replace with zeros     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    vmad(flag0mad) = ones(n0mad,1) ;
  end

  sdata = data .* vec2matSM(1 ./ vmad, n) ;
          %  make each coordinate have MAD 1
  if n0mad > 0
    sdata(flag0mad) = zeros(n0mad,1) ;
  end

  svmean = rmeanSM(sdata',(10^-6),20,0)' ;
          %  accuracy parameters, and 0 for no screen writes
  vcenter = svmean .* vmad ;
          %  Elliptical version of Huber's L1 M-estimate
  ssc = n * sum(vcenter.^2) ;
  smresid = sdata - vec2matSM(svmean,n) ;
  mresid = smresid .* vec2matSM(vmad, n) ;
  sscr = sum(sum(mresid .^ 2)) ;

  vrad = sqrt(sum(smresid .^2)) ;
  sphereresid = smresid' ./ vec2matSM(vrad',d) ;
          %  Transpose, since want "coordinates as variables"
          %  vector of radii of each curve
          %  make each curve have "length" one
  ellipsresid = sphereresid .* vec2matSM(vmad', n) ;
          %  return each coordinate to original scale

  tmresid = ellipsresid' ;
      %  transformed version of residuals
%  sstmr = sum(sum(tmresid .^ 2)) ;

  centerst = 'Ell. L1M' ;
  typestr = 'Elliptical PCA' ;

end    %  of itype if-block



%  Adjust vipcplot and nevcompute
%
rtmr = rank(tmresid) ;

npcplot = length(vipcplot) ;
    %  number of PC plot indices
flag = (vipcplot <= rtmr) ;
    %  one where will keep PC indices,
    %  since smaller than rank
if sum(flag) < npcplot    %  then need to truncate,
                          %  since larger than rank
  vipcplot = vipcplot(flag) ;
  npcplot = length(vipcplot) ;
  if isfield(paramstruct,'vipcplot')    %  then should warn of change,
                                          %  since this vipcplot was chosen
    disp(['!!!   Warning from curvdatSM:  truncated vipcplot, to ' ...
                                      num2str(vipcplot)]) ;
  end
end
maxipcplot = max(vipcplot) ;
vipcplot = unique(vipcplot) ;
    %  put these in increasing order,
    %  and get rid of duplicates
if length(vipcplot) < npcplot
  disp('!!!   Warning from curvdatSM: eliminated duplicates in vipcplot') ;
end
npcplot = length(vipcplot) ;
vipcplotn0 = vipcplot(vipcplot > 0) ;
npcplotn0 = length(vipcplotn0) ;

if nevcompute > rtmr    %  then need to adjust,
                          %  since some are bigger than rank
  nevcompute = rtmr ;
  if isfield(paramstruct,'nevcompute')    %  then should warn of change,
                                         %  since use chose this nevplot
    disp('!!!   Warning from curvdatSM:  reducing nevcompute, to rank(mdat)') ;
  end
end

if nevcompute < maxipcplot    %  then need to adjust
  nevcompute = maxipcplot ;
  disp('!!!   Warning from curvdatSM:  increasing nevcompute, to max(maxipcplot)') ;
end



%  do main PCA
%
paramstruct = struct('npc',nevcompute, ...
                     'iprestd',1, ...
                     'viout',[1 1 0 0 0 0 0 0 1 0], ...
                     'iscreenwrite',0) ;
outstruct = pcaSM(tmresid / sqrt(n - 1),paramstruct) ;
if iscreenwrite == 1
  disp('    curvdatSM finished eigendecomposition') ;
end

veigval = getfield(outstruct,'veigval') ;
    %  vector eigenvalues
tmeigvec = getfield(outstruct,'meigvec') ;
    %  matrix of eigenvectors of transformed data
    %  Note: these are sorted so largest eigenvalues are first
    %        and eigen vectors are column vectors
tvpropSScr = getfield(outstruct,'vpropSSmr') ;
    %  vector of Proportions of Mean Residuals
    %  of transformed data
    %  for plotting lines in power plot



%  Adjust direction vectors for potential pre-tranformations 
%  (otherwise above output would be used more)
%
if  itype == 1  || ...
    itype == 4  || ...
    itype == 5    %  Standard PCA, or
                  %  Shrink to sphere PCA, or
                  %  Shrink to Ellipse PCA

  meigvec = tmeigvec ;
      %  matrix of eigenvectors transformed back to 
      %  original curve space
      %  use this for projections of curves

      %  all of these direction vectors are 
      %  in the original space, no back transform needed

elseif itype == 2    %  Correlation PCA

  meigvec = tmeigvec .* vec2matSM(vsd,nevcompute) ;
      %  matrix of eigenvectors transformed back to 
      %  original curve space
      %  use this for projections of curves
  evs = sqrt(sum((meigvec .^ 2),1)) ;
      %  eigenvector norms
  meigvec = meigvec ./ vec2matSM(evs,d) ;
      %  divide by norms to make these unit vectors

elseif itype == 3    %  Spearman Correlation PCA

  meigvec = tmeigvec ;
      %  matrix of eigenvectors transformed back to 
      %  original curve space
      %  use this for projections of curves
      
      %  idea here is that these are direction vectors in
      %  original space (at least "relative to axes")

end    %  of itype if-block




%  Apply varimax rotation if needed
%
if ivarimax == 1

  meigvecplot = meigvec(:,vipcplotn0) ;
      %  extract direction vectors of subspace to rotate

  if vmpower ~= 0
    meigvecplot = meigvecplot * diag(veigval(vipcplotn0) .^ (vmpower / 2)) ;
  end

  [~,mrotvec] = varimaxTP(meigvecplot,vmbasis) ;

  if vmpower ~= 0    %  then make these unit vectors
    mrotvec = mrotvec ./ vec2matSM(sqrt(sum(mrotvec.^2,1)),d) ;
  end

  mpcrot = mrotvec' * mresid ;
      %  projection of centered residuals, 
      %  in original data space
      %  onto these direction vectors (scores)

  vrotSS = sum(mpcrot.^2,2) ;
  [~,vind] = sort(vrotSS) ;
      %  indices to put in increasing order
  vind = vind(end:-1:1) ;
      %  indices to put in increasing order
  mrotvec = mrotvec(:,vind) ;


  meigvec(:,vipcplotn0) = mrotvec ;
      %  used this approach instead of selecting the 
      %  needed rows, to make the cumulative sums correct

end



%  compute projections, and needed sums of squares
%
mpc = meigvec' * mresid ;
    %  projection of centered residuals, 
    %  in original data space
    %  onto direction vectors (scores)

a3proj = meigvec(:,1) * mpc(1,:) ;
    %  d x n matrix of projections onto first direction vector
    %  in original data space
vss = sum(sum(a3proj.^2)) ;
    %  sum of squares of projected data, in first direction
a3mresid = mresid - a3proj ;
    %  residuals from first projection
    %  3d array of mean residuals of transformed data
vssr = sscr - vss ;
    %  vector of sum of squares of residuals
vpropSSpr = vssr / sscr ;
    %  vector of SS, as a proportion of the previous residuals
for iev = 2:maxipcplot
  a3proj = cat(3,a3proj,meigvec(:,iev) * mpc(iev,:)) ;
      %  buildup 3-d array of
      %  d x n matrix of projections onto direction vectors
  vss = [vss; sum(sum(a3proj(:,:,iev).^2))] ;
      %  sum of squares of projected data, in first direction
  a3mresid = cat(3,a3mresid,a3mresid(:,:,(iev-1)) - a3proj(:,:,iev)) ;
      %  buildup 3-d array of
      %  d x n matrix of sequential residuals
  vssr = [vssr; (vssr(iev-1) - vss(iev))] ;
  vpropSSpr = [vpropSSpr; vssr(iev) / vssr(iev-1)] ;
        %  vector of SS, as a proportion of the previous residuals
end    %  of iev loop

vpropSScr = vss / sscr ;
    %  vector of SS, proportional to centered residual SS
cvpropSScr = cumsum(vpropSScr) ;
    %  cumulative of SS, proportional to centered residual SS

tcvpropSScr = cumsum(tvpropSScr) ;
    %  get cumulative sum, of SS from eigen-analysis
    %  (i.e. in transform space)



%  Set up axis limits as needed
%
if iaxlim == 1
  vaxlimraw = axisSM(data) ;
  vaxlimproj = axisSM(mresid) ;
  vaxlimsc = axisSM(mpc) ;
      %  here use sensible global choices
elseif iaxlim == 2
  vaxlimraw = axisSM([data; -data]) ;
  vaxlimproj = axisSM([mresid; -mresid]) ;
  vaxlimsc = axisSM([mpc; -mpc]) ;
      %  here use symmetrized global choices
else
  vaxlimraw = [] ;
  vaxlimproj = [] ;
  vaxlimsc = [] ;
      %  [] flags default of axisSM choice of axes
end



%  make main output plot (if requested)
%
figcount = 0 ;
if vipageout(1) == 1

  figcount = figcount + 1 ;
  if idiffigwind == 1
    figure(figcount) ;
  end


  if iscreenwrite == 1
    disp('  Making curve decomposition plot') ;
  end
  if isingleaxis ~= 1
    clf ;
  end

  npx = length(vicolplot) ;
            %  number of columns output
  npy = npcplot ;
            %  number of rows output
  xgrid = (1:d)' ;



  if indivcolorflag == 0    %  then can plot everything with global colors


    %  loop through plot rows
    %
    for iplotrow = 1:npy

      if vipcplot(iplotrow) == 0    %  then plot data, mean, etc.

        tx = 1 + 0.1 * (d - 1) ;
        iplotcol = 0 ;
        if sum(vicolplot == 1) > 0    %  then vicolplot has a 1,
                                        %  so make Raw Data plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,data,[datacolor '-']) ;
              if isempty(vaxlimraw)
                vax = axisSM(data) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
              if ~isempty(legendcellstr)    %  then add legend
                for ilegend = 1:nlegend
                    ty = vax(1) + ((nlegend - ilegend + 1) / ...
                                       (nlegend + 1)) * (vax(2) - vax(1)) ;
                  text(tx,ty,legendcellstr(ilegend),  ...
                            'Color',mlegendcolor(ilegend,:)) ;
                end
              end
              title('Raw Data') ;
        end


        if sum(vicolplot == 2) > 0    %  then vicolplot has a 2,
                                        %  so make Center plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,vcenter,[meancolor '-']) ;
              if isempty(vaxlimraw)
                vax = axisSM(vcenter) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * ssc / (ssc + sscr), 4) '% of Tot']) ;
              title(['Center: ' centerst]) ;
        end


        if sum(vicolplot == 3) > 0    %  then vicolplot has a 3,
                                        %  so make Center Residual plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,mresid,[datacolor '-']) ;
              if isempty(vaxlimproj)
                vax = axisSM(mresid) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * sscr / (ssc + sscr),4) '% of Tot']) ;
              title('Center Resid.') ;
        end


        if sum(vicolplot == 4) > 0    %  then vicolplot has a 4,
                                        %  so make R^2 Power plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(1:nevcompute,tvpropSScr,[evcolor,'-'], ...
                 1:nevcompute,tcvpropSScr,[cevcolor,'--'], ...
                 vipcplotn0,vpropSScr(vipcplotn0),[evcolor,'o'], ...
                 vipcplotn0,cvpropSScr(vipcplotn0),[cevcolor,'+']) ;
              ylabel('R^2') ;
              minev = min([0; vpropSScr]) ;
              if minev < -10^(-3)
                negevflag = (vpropSScr < 0) ;
                negevind = 1:d ;
                negevind = negevind(negevflag) ;
                negev = vpropSScr(negevflag) ;
                hold on ;
                  plot(negevind,negev,'yo') ;
                hold off ;
                minev = minev - 0.05 ;
              end
              axis([0,nevcompute,minev,1]) ;
                ttx = 0 + 0.1 * (nevcompute - 0) ;
              text(ttx,0.5,typestr) ;
              title('PC R-squareds') ;
        end


      else    %  then plot PC row

        ipc = vipcplot(iplotrow) ;
            %  index of current PC

        istr = num2str(ipc) ;

        tx = 1 + 0.1 * (d - 1) ;
        iplotcol = 0 ;
        if sum(vicolplot == 1) > 0    %  then vicolplot has a 1,
                                        %  so make Projection plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,a3proj(:,:,ipc),[datacolor '-']) ;
              if isempty(vaxlimproj)
                vax = axisSM(a3proj(:,:,ipc)) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
              if npx == 2    %  then put this here, else put on mean +- plot
                  ty = vax(1) + .9 * (vax(2) - vax(1)) ;
                text(tx,ty,[num2str(100 * vpropSScr(ipc),4) '% of MR']) ;
              end
              title([varimaxstr 'PC' num2str(ipc) ' Proj.']) ;
        end


        if sum(vicolplot == 2) > 0    %  then vicolplot has a 2,
                                        %  so make Center +- Extreme plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,vcenter,[meancolor '-']) ;
              if isempty(vaxlimproj)
                vax = axisSM([vcenter + max(mpc(ipc,:)') * meigvec(:,ipc); ...
                              vcenter + min(mpc(ipc,:)') * meigvec(:,ipc)]) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
              hold on ;
                plot(xgrid,vcenter + max(mpc(ipc,:)') * meigvec(:,ipc),[meancolor '--']) ;
                plot(xgrid,vcenter + min(mpc(ipc,:)') * meigvec(:,ipc),[meancolor ':']) ;
              hold off ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * vpropSScr(ipc),4) '% of CR']) ;
              title([varimaxstr 'Center +- PC' istr]) ;
        end


        if sum(vicolplot == 3) > 0    %  then vicolplot has a 3,
                                        %  so make Remaining Residuals plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,a3mresid(:,:,ipc),[datacolor '-']) ;
              if isempty(vaxlimproj)
                vax = axisSM(a3mresid(:,:,ipc)) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * vpropSSpr(ipc),4) '% of above']) ;
              title([varimaxstr 'PC' istr ' Resid.']) ;
        end


        if sum(vicolplot == 4) > 0    %  then vicolplot has a 4,
                                      %  so make Scores kde & jitter plot

          iplotcol = iplotcol + 1 ;

          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end

          if isempty(vaxlimsc)
            vax = axisSM(mpc(ipc,:)) ;
          else
            vax = vaxlimsc ;
          end

          paramstruct1 = struct('icolor',icolor, ...
                                'markerstr',markerstr, ...
                                'ibigdot',ibigdot, ...
                                'isubpopkde',isubpopkde, ...
                                'vaxlim',vax, ...
                                'titlestr',[varimaxstr 'PC' istr ' Scores'], ...
                                'iscreenwrite',iscreenwrite) ;

          vdir = meigvec(:,ipc) ;
          projplot1SM(mresid,vdir,paramstruct1) ;

        end


      end    %  of row type if-block

    end    %  of iplotrow loop


  elseif indivcolorflag == 1    %  then need to do individual 
                                  %  plots and colors


    %  loop through plot rows
    %
    for iplotrow = 1:npy

      if vipcplot(iplotrow) == 0    %  then plot data, mean, etc.

        tx = 1 + 0.1 * (d - 1) ;
        iplotcol = 0 ;
        if sum(vicolplot == 1) > 0    %  then vicolplot has a 1,
                                        %  so make Raw Data plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,data(:,1),'-','Color',colmap(1,:)) ;
              if isempty(vaxlimraw)
                vax = axisSM(data) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
              hold on ;
                for idat = 2:n
                  plot(xgrid,data(:,idat),'-','Color',colmap(idat,:)) ;
                end
              hold off ;
              if ~isempty(legendcellstr)    %  then add legend
                for ilegend = 1:nlegend
                    ty = vax(1) + ((nlegend - ilegend + 1) / ...
                                       (nlegend + 1)) * (vax(2) - vax(1)) ;
                  text(tx,ty,legendcellstr(ilegend),  ...
                            'Color',mlegendcolor(ilegend,:)) ;
                end
              end
              title('Raw Data') ;
        end


        if sum(vicolplot == 2) > 0    %  then vicolplot has a 2,
                                        %  so make Center plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,vcenter,[meancolor '-']) ;
              if isempty(vaxlimraw)
                vax = axisSM(vcenter) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * ssc / (ssc + sscr),4) '% of Tot']) ;
              title(['Center: ' centerst]) ;
        end


        if sum(vicolplot == 3) > 0    %  then vicolplot has a 3,
                                      %  so make Center Residual plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1 
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,mresid(:,1),'-','Color',colmap(1,:)) ;
              if isempty(vaxlimproj)
                vax = axisSM(mresid) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
              hold on ;
                for idat = 2:n
                  plot(xgrid,tmresid(:,idat),'-','Color',colmap(idat,:)) ;
                end
              hold off ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * sscr / (ssc + sscr),4) '% of Tot']) ;
              title('Center Resid.') ;
        end


        if sum(vicolplot == 4) > 0    %  then vicolplot has a 4,
                                      %  so make R^2 Power plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(1:nevcompute,tvpropSScr,[evcolor,'-'], ...
                 1:nevcompute,tcvpropSScr,[cevcolor,'--'], ...
                 vipcplotn0,vpropSScr(vipcplotn0),[evcolor,'o'], ...
                 vipcplotn0,cvpropSScr(vipcplotn0),[cevcolor,'+']) ;
              ylabel('R^2') ;
              minev = min([0; vpropSScr]) ;
              if minev < -10^(-3)
                negevflag = (vpropSScr < 0) ;
                negevind = 1:d ;
                negevind = negevind(negevflag) ;
                negev = vpropSScr(negevflag) ;
                hold on ;
                  plot(negevind,negev,'yo') ;
                hold off ;
                minev = minev - 0.05 ;
              end
              axis([0,nevcompute+1,minev,1]) ;
              text(tx,.5,typestr) ;
              title('Center Resid.') ;
        end


      else    %  then plot PC row

        ipc = vipcplot(iplotrow) ;
            %  index of current PC

        istr = num2str(ipc) ;


        tx = 1 + 0.1 * (d - 1) ;
        iplotcol = 0 ;
        if sum(vicolplot == 1) > 0    %  then vicolplot has a 1,
                                      %  so make Projection plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,a3proj(:,1,ipc),'-','Color',colmap(1,:)) ;
              if isempty(vaxlimproj)
                vax = axisSM(a3proj(:,:,ipc)) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
              hold on ;
                for idat = 2:n
                  plot(xgrid,a3proj(:,idat,ipc),'-','Color',colmap(idat,:)) ;
                end
              hold off ;
              if npx == 2    %  then put this here, else put on mean +- plot
                  ty = vax(1) + .9 * (vax(2) - vax(1)) ;
                text(tx,ty,[num2str(100 * vpropSScr(ipc),4) '% of MR']) ;
              end
              title([varimaxstr 'PC' num2str(ipc) ' Proj.']) ;
        end


        if sum(vicolplot == 2) > 0    %  then vicolplot has a 2,
                                      %  so make Center +- Extreme plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,vcenter,[meancolor '-']) ;
              if isempty(vaxlimproj)
                vax = axisSM([vcenter + max(mpc(ipc,:)') * meigvec(:,ipc); ...
                              vcenter + min(mpc(ipc,:)') * meigvec(:,ipc)]) ;
              else
                vax = vaxlimraw ;
              end
              axis([1,d,vax]) ;
              hold on ;
                plot(xgrid,vcenter + max(mpc(ipc,:)') * meigvec(:,ipc),[meancolor '--']) ;
                plot(xgrid,vcenter + min(mpc(ipc,:)') * meigvec(:,ipc),[meancolor ':']) ;
              hold off ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * vpropSScr(ipc),4) '% of CR']) ;
              title(['Center +- ' varimaxstr 'PC' istr]) ;
        end


        if sum(vicolplot == 3) > 0    %  then vicolplot has a 3,
                                      %  so make Remaining Residuals plot
          iplotcol = iplotcol + 1 ;
          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end
            plot(xgrid,a3mresid(:,1,ipc),'-','Color',colmap(1,:)) ;
              if isempty(vaxlimproj)
                vax = axisSM(a3mresid(:,:,ipc)) ;
              else
                vax = vaxlimproj ;
              end
              axis([1,d,vax]) ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              hold on ;
                for idat = 2:n
                  plot(xgrid,a3mresid(:,idat,ipc),'-','Color',colmap(idat,:)) ;
                end
              hold off ;
                ty = vax(1) + .9 * (vax(2) - vax(1)) ;
              text(tx,ty,[num2str(100 * vpropSSpr(ipc),4) '% of above']) ;
              title([varimaxstr 'PC' istr ' Resid.']) ;
        end


        if sum(vicolplot == 4) > 0    %  then vicolplot has a 4,
                                        %  so make Scores kde & jitter plot


          iplotcol = iplotcol + 1 ;

          if isingleaxis ~= 1
            subplot(npy,npx,npx * (iplotrow - 1) + iplotcol) ;
          end

          if isempty(vaxlimsc)
            vax = axisSM(mpc(ipc,:)) ;
          else
            vax = vaxlimsc ;
          end

          paramstruct1 = struct('icolor',icolor, ...
                                'markerstr',markerstr, ...
                                'ibigdot',ibigdot, ...
                                'isubpopkde',isubpopkde, ...
                                'vaxlim',vax, ...
                                'titlestr',[varimaxstr 'PC' istr ' Scores'], ...
                                'iscreenwrite',iscreenwrite) ;

          vdir = meigvec(:,ipc) ;
          projplot1SM(mresid,vdir,paramstruct1) ;

        end


      end    %  of row type if-block

    end    %  of iplotrow loop


  end    %  of indivcolorflag if-block



  if ~isempty(savestr)   %  then create graphical output

  printSM(savestr,savetype) ;
  
  end

end    %  of if-block for main output plot




%  make QQ-SiZer 1-d plot (if requested)
%
if vipageout(2) == 1

  figcount = figcount + 1 ;
  if idiffigwind == 1
    figure(figcount) ;
  end


  if iscreenwrite == 1
    disp('  Making SiZer & QQ analysis') ;
  end
  if isingleaxis ~= 1
    clf ;
  end

  npx = npcplotn0 ;
            %  1 column for each eigenvector
  npy = length(viSiZer) ;
            %  number of rows output


  for i = 1:npcplotn0

    ipc = vipcplotn0(i) ;
        %  index of current PC

    istr = num2str(ipc) ;

    pcdat = mpc(ipc,:)' ;

    min3 = min(pcdat) ;
    max3 = max(pcdat) ;
    range3 = max3 - min3 ;
    min3 = min3 - 0.05 * range3 ;
    max3 = max3 + 0.05 * range3 ;
    range = max3 - min3 ;
    ngrid = 401 ;
    binw = range / (ngrid - 1) ;
    hmin = 2 * binw ;
    hmax = range ;

    irow = 0 ;
    if sum(viSiZer == 1) > 0    %  then viSiZer has a 1,
                                  %  so make family plot
      irow = irow + 1 ;
      if iscreenwrite == 1
        disp(['    Working on family, pc' istr]) ;
      end
      if isingleaxis ~= 1
        subplot(npy,npx,npx * (irow - 1) + i) ;
      end
        paramstruct = struct('iout',4, ...
                             'icolor',icolorprint, ...
                             'imovie',0, ...
                             'dolcolor',dotcolor', ...
                             'dolhtseed',dolhtseed, ...
                             'famoltitle',['Family Plot, ' varimaxstr 'PC' istr ' Scores'], ...
                             'nbin',ngrid, ...
                             'minx',min3, ...
                             'maxx',max3, ...
                             'nfh',11, ...
                             'fhmin',hmin, ...
                             'fhmax',hmax, ...
                             'hhighlight',-1, ...
                             'iscreenwrite',0) ;
            %  iout = 4:  family overlay only
            %  iscreenwrite = 0:  since basically say this above
          if isempty(dotcolor)
            paramstruct = rmfield(paramstruct,'dolcolor') ;
                %  revert to SiZerSM default
          end
        sizerSM(pcdat,paramstruct) ;  
    end


    if sum(viSiZer == 2) > 0    %  then viSiZer has a 2,
                                  %  so make SiZer map
      irow = irow + 1 ;
      if iscreenwrite == 1
        disp(['    Working on SiZer, pc' istr]) ;
      end
      if isingleaxis ~= 1
        subplot(npy,npx,npx * (irow - 1) + i) ;
      end
        paramstruct = struct('iout',6, ...
                             'icolor',icolorprint, ...
                             'imovie',0, ...
                             'famoltitle',['SiZer, ' varimaxstr 'pc' istr], ...
                             'nbin',401, ...
                             'minx',min3, ...
                             'maxx',max3, ...
                             'nfh',11, ...
                             'fhmin',hmin, ...
                             'fhmax',hmax, ...
                             'hhighlight',-1, ...
                             'iscreenwrite',0) ;
            %  iout = 6:  SiZer map only
            %  iscreenwrite = 0:  since basically say this above
        sizerSM(pcdat,paramstruct) ;  
    end


    if sum(viSiZer == 3) > 0    %  then viSiZer has a 3,
                                %  so make SiCon map
      irow = irow + 1 ;
      if iscreenwrite == 1
        disp(['    Working on SiCon, pc' istr]) ;
      end
      if isingleaxis ~= 1
        subplot(npy,npx,npx * (irow - 1) + i) ;
      end
        paramstruct = struct('iout',7, ...
                             'icolor',icolorprint, ...
                             'imovie',0, ...
                             'famoltitle',['SiCon, ' varimaxstr 'pc' istr], ...
                             'nbin',401, ...
                             'minx',min3, ...
                             'maxx',max3, ...
                             'nfh',11, ...
                             'fhmin',hmin, ...
                             'fhmax',hmax, ...
                             'hhighlight',-1, ...
                             'iscreenwrite',0) ;
            %  iout = 7:  SiZer map only
            %  iscreenwrite = 0:  since basically say this above
        sizerSM(pcdat,paramstruct) ;  
    end


    if sum(viSiZer == 4) > 0    %  then viSiZer has a 4,
                                  %  so make Q-Q plot
      irow = irow + 1 ;
      if iscreenwrite == 1
        disp(['    Working on Q-Q plot, pc' istr]) ;
      end
      if isingleaxis ~= 1
        subplot(npy,npx,npx * (irow - 1) + i) ;
      end
        paramstruct = struct('idist',1, ...
                             'icolor',icolorprint, ...
                             'nsim',qqnsim, ...
                             'left',min3, ...
                             'right',max3, ...
                             'bottom',min3, ...
                             'top',max3, ...
                             'simseed',qqseed, ...
                             'titlestr',['Gaussian Q-Q, ' varimaxstr 'pc' istr], ...
                             'ylabelstr',['pc' istr 'Q'], ...
                             'iscreenwrite',iscreenwrite) ;
             %  idist = 1:  Gaussian
        qqLM(pcdat,paramstruct) ;                            
    end


  end



  if ~isempty(savestr)   %  then create graphic output file

    printSM([savestr 'SZQQ'],savetype) ;

  end


end    %  of if-block for Q-Q SiZer 1d plot



%  make ScatterPlot Matrix 2-d plot (if requested)
%
if vipageout(3) == 1

  figcount = figcount + 1 ;
  if idiffigwind == 1
    figure(figcount) ;
  end


  if iscreenwrite == 1
    disp('  Making 2d Draftsman''s Plots') ;
  end
  clf ;

  mdir = [] ;
  labelcellstr = {} ;
  maxlim = [] ;
  for i = 1:npcplotn0
    ipc = vipcplotn0(i) ;
        %  index of current PC
    vdir = meigvec(:,ipc) ;
    mdir = [mdir vdir] ;
        %  matrix of directions to project onto
    istr = num2str(ipc) ;
    labelcellstr = cat(1,labelcellstr,{['PC' istr ' Scores']}) ;
    if ~isempty(vaxlimsc)
      maxlim = [maxlim; vaxlimsc] ;
    end
  end
  labelcellstr = {labelcellstr} ;
      %  for passing into subroutine

  if ~isempty(savestr)
    savestr3 = [savestr 'SPM2d'] ;
  else
    savestr3 = savestr ;
  end

  paramstruct3 = struct('icolor',icolor, ...
                        'markerstr',markerstr, ...
                        'idataconn',idataconn, ...
                        'idataconncolor',idataconncolor, ...
                        'idataconntype',idataconntype, ...
                        'ibigdot',ibigdot, ...
                        'maxlim',maxlim, ...
                        'iplotaxes',iplotaxes, ...
                        'isubpopkde',isubpopkde, ...
                        'labelcellstr',labelcellstr, ...
                        'savestr',savestr3, ...
                        'savetype',savetype, ...
                        'iscreenwrite',iscreenwrite) ;
  if ~(isempty(legendcellstr))
    paramstruct3.legendcellstr = legendcellstr ;
  end
  if ~(isempty(mlegendcolor))
    paramstruct3.mlegendcolor = mlegendcolor ;
  end

  scatplotSM(mresid,mdir,paramstruct3) ; 


end    %  of if-block for draftsmans 2d plot



