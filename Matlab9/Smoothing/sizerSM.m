function makeplot = sizerSM(data,paramstruct) 
% SIZERSM, SIgnificance of ZERo crossings of derivatives,
%   Steve Marron's matlab function
%     For determining which features in a smooth 
%     (density estimate, or nonparametric regression)
%     are statistically significant.
%     Recommended default version of SiZer, usable quite simply
%     with just a set of data (e.g. a first analysis of a new
%     set of data), but also very flexible with a wide range of 
%     options available.
% Inputs:
%   data        - either n x 1 column vector of density estimation data
%                     or n x 2 matrix of regression data:
%                             X's in first column,  Y's in second
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
%    iout             1  (default)  use 2 panels: family overlay, 
%                                        slope SiZer
%                     2  use 3 panels: family overlay, slope SiZer,
%                                        curvature SiZer
%                     3  use 4 panels:  family overlay & surface 
%                                            curvature and slope SiZer
%                     4  family overlay only
%                     5  family surface only
%                     6  slope SiZer only
%                     7  curvature SiZer only
%
%    imovie           1  (default)  make movie version
%                     0  make a single still plot
%                            (will force reset to this for iout > 4)
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                     unspecified:  results only appear on screen
%                     movie version (imovie = 1):
%                         add .mpg and create MPEG file
%                     static version (imovie = 0):  
%                         add .ps, and save as either
%                              color postscript (icolor = 1)
%                         or
%                              black&white postscript (when icolor = 0)
%
%    ihazard          0  (default)  give ordinary density or 
%                            regression estimates
%                     1  give hazard rate estimates
%                            (note, no curvature SiZer, data-driven
%                                 bandwidths allowed, and only
%                                 simflag = 1 is currently supported)
%
%    icensor          0  (default)  assume data are uncensored
%                     1  assume data are censored, and have a
%                            2nd column of censoring indicators 
%                            (works only for density or hazard
%                                 estimation)
%                            (note, no curvature SiZer, data-driven
%                                 bandwidths allowed, and only
%                                 simflag = 1 is currently supported)
%
%    ilengthb         0  (default)  do not do a length biased
%                            adjustment
%                     1  adjust for length biased sampling
%                            (works only for density or hazard
%                                 estimation)
%                            (note, no curvature SiZer, data-driven
%                                 bandwidths allowed, and only
%                                 simflag = 1 is currently supported)
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
%    alpha            Usual "level of significance".  
%                         I.e. C.I.s have coverage probability 
%                         1 - alpha.  (0.05 when not specified)
%
%    icolor           1  (default)  full color version of SiZer
%                     0  fully black and white version
%
%    xlabelstr        String for labeling x axes (default is none)
%
%    ylabelstr        String for labeling x axes (default is none)
%
%    labelfontsize    Font Size for labels (uses Matlab default)
%                                   (15 is "fairly large")
%
%    famoltitle       Title for family overlay plot
%                           (default is 'Family Overlay, date')
%
%    famsurtitle      Title for family surface plot
%                           (default is 'SiZer colored Scale Space')
%
%    sizertitle       Title for slope SiZer plot
%                           (default is 'Slope SiZer Map')
%
%    curvsizertitle       Title for curvature SiZer plot
%                           (default is 'Curvature SiZer Map')
%
%    titlefontsize    Font Size for titles (uses Matlab default)
%                                   (18 is "fairly large")
%
%    viewangle        Angle for Viewing of 3d surface plot, 
%                         in degrees azimuth and elevation, 
%                         recommend  [165,30] (default)
%                                or  [195,30]
%
%
%    idatovlay        0  Do not overlay data on kde plot
%                     1  (default) overlay data using heights based on data ordering
%                              Note:  To see "c.d.f. style" increasing line, 
%                                     should also sort the data
%                     2  overlay data using random heights
%                     another integer > 0,  overlay data, using random heights,
%                                           with this number as the seed (so can 
%                                           better match data points across plots),
%                                           (should be an integer with <= 8 digits)
%                                           (has no effect for regression)
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
%    dolcolor         data overlay color
%                     string (any of 'r', 'g', 'k', etc.) for that single color
%                               default is 'g'
%                     1  Matlab 7 color default
%                     2  time series version (ordered spectrum of colors)
%                     nx3 color matrix:  a color label for each data point
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size (useful since some
%                              postscript graphics leave dots too small)
%
%    cdolcolor        censored data overlay color
%                                    (only has effect when plot is made here)
%                           default is 'y'
%
%    dolhtseed        seed for random heights used in data overlay jitter plot
%                           default is [] (for using current Matlab seed) 
%                                    (should be an integer with <= 8 digits)
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%    nbin             number of bins (default = 401)
%
%    minx             left end of bin range (default is min of data)
%
%    maxx             right end of bin range (default is max of data)
%
%    bpar             bin range boundary handling parameter
%                         0 - (default), move data to ends
%                         1 - truncate data outside ends
%
%    ibdryadj         index of boundary adjustment
%                         0 (or not specified)  -  no adjustment
%                         1  -  mirror image adjustment
%                         2  -  circular design
%                                 (only has effect for density estimation)
%
%    nfh              number of h's for family
%                           (default, 41 for movies,  11 for static)
%
%    fhmin            left end of family h range (default = binwd * 2) 
%
%    fhmax            right end of family h range (default = range)
%
%    nsh              number of h's for SiZer
%                           (default, 41 for movies,  11 for static)
%
%    shmin            left end of SiZer h range (default = binwd * 2) 
%
%    shmax            right end of SiZer h range (default = range)
%
%    moviefps         movie speed, in frames per second (default = 5)
%
%    moviecstr        movie compression string, for type of AVI compression:
%                            most look bad with 256 color adapter,
%                            so use a higher one
%                       'MSVC'
%                            requires 256 color graphic adapter,
%                            streamlines and contours OK (on 1st run),
%                            but dots look bad
%                       'None'   (no compression)
%                            looks good but big file
%                       'Cinepak'   (default)
%                            looks good, small file
%                       'Indeo3'
%                            gives warning about "frame size"
%                            good color, but blurry, small file
%                       'Indeo5'
%                            gives warning about "frame size"
%                            good color, but blurry, small file
%
%    nrepeat          number of times to repeat movie (default = 2)
%
%    ishoweffwind    0  do not show effective window width
%                            (i.e. curves showing +- 2 h)
%                    1  (default) show effective window width
%
%    hhighlight      0  don't highlight any h (in static family output)
%                    -1 (default) highlight h closest to data driven
%                    h > 0  highlight h closest to this value
%                          Note: doesn't appear when no family plot
%                                is computed
%
% Outputs:
%     For iout = 1,2,3:   graphics in current Figure
%     For iout = 4,5,6,7:   graphics in current axes
%     When savestr exists,
%        For imovie = 1:  MPEG file saved in 'savestr'.mpg
%        For imovie = 0:  Postscript file saved in 'savestr'.ps
%                        (color postscript for icolor = 1)
%                        (B & W postscript for icolor = 0)
%    
%
% Assumes path can find personal functions:
%    bwsjpiSM.m
%    bwrswSM.m
%    kdeSM.m
%    nprSM.m
%    sz2SM.m
%    sc2SM.m
%    vec2matSM
%    CHkdeSM
%    CHsz1SM
%    lbinrSM.m
%    bwrfphSM.m
%    bwosSM.m
%    rootfSM
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM
%    cquantSM
%    bwrswSM.m
%    CHlbinrSM.m
%    KMcdfSM.m
%    LBcdfSM.m
%    iqrSM
%    cquantSM

%    Copyright (c) J. S. Marron 2000-2023



%  First set all parameters to defaults
%
iout = 1 ;
imovie = 1 ;
savestr = [] ;
ihazard = 0 ;
icensor = 0 ;
ilengthb = 0 ;
simflag = 2 ;
alpha = 0.05 ;
icolor = 1 ;
xlabelstr = [] ;
ylabelstr = [] ;
labelfontsize = [] ;
famoltitle = ['Family Overlay, ' datetime('today')] ;
famsurtitle = 'SiZer colored Scale Space' ;
sizertitle = 'Slope SiZer Map' ;
curvsizertitle = 'Curvature SiZer Map' ;
titlefontsize = [] ;
viewangle = [165,30] ;
idatovlay = 1 ;
ndatovlay = 1 ;
datovlaymax = 0.6 ;
datovlaymin = 0.5 ;
dolcolor = 'g' ;
ibigdot = 0 ;
cdolcolor = 'y' ;
dolhtseed = [] ;
iscreenwrite = 0 ;
nbin = 401 ;
minx = [] ;
maxx = [] ;
bpar = 0 ;
ibdryadj = 0 ;
nfh = [] ;
fhmin = [] ;
fhmax = [] ;
nsh = [] ;
shmin = [] ;
shmax = [] ;
moviefps = 5 ;
moviecstr = 'Cinepak' ;
nrepeat = 2 ;
ishoweffwind = 1 ;
hhighlight = -1 ;





%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1   %  then paramstruct is an argument

  if isfield(paramstruct,'iout')    %  then change to input value
    iout = paramstruct.iout ; 
  end

  if isfield(paramstruct,'imovie')    %  then change to input value
    imovie = paramstruct.imovie ; 
  end

  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstructsavestr ; 
    if ~ischar(savestr)    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from sizerSM.m:    !!!') ;
      disp('!!!   Invalid savestr,           !!!') ;
      disp('!!!   using default of no save   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'ihazard')    %  then change to input value
    ihazard = paramstruct.ihazard ; 
  end

  if isfield(paramstruct,'icensor')    %  then change to input value
    icensor = paramstruct.icensor ; 
  end

  if isfield(paramstruct,'ilengthb')    %  then change to input value
    ilengthb = paramstruct.ilengthb ; 
  end

  if isfield(paramstruct,'simflag')    %  then change to input value
    simflag = paramstruct.simflag ; 
  end

  if isfield(paramstruct,'alpha')    %  then change to input value
    alpha = paramstruct.alpha ; 
  end

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ; 
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

  if isfield(paramstruct,'famoltitle')    %  then change to input value
    famoltitle = paramstruct.famoltitle ; 
  end

  if isfield(paramstruct,'famsurtitle')    %  then change to input value
    famsurtitle = paramstruct.famsurtitle ; 
  end

  if isfield(paramstruct,'sizertitle')    %  then change to input value
    sizertitle = paramstruct.sizertitle ; 
  end

  if isfield(paramstruct,'curvsizertitle')    %  then change to input value
    curvsizertitle = paramstruct.curvsizertitle ; 
  end

  if isfield(paramstruct,'titlefontsize')    %  then change to input value
    titlefontsize = paramstruct.titlefontsize ; 
  end

  if isfield(paramstruct,'viewangle')    %  then change to input value
    viewangle = paramstruct.viewangle ; 
  end

  if isfield(paramstruct,'idatovlay')    %  then change to input value
    idatovlay = paramstruct.idatovlay ; 
  end

  if isfield(paramstruct,'ndatovlay')    %  then change to input value
    ndatovlay = paramstruct.ndatovlay ; 
  end

  if isfield(paramstruct,'datovlaymax')    %  then change to input value
    datovlaymax = paramstruct.datovlaymax ; 
  end

  if isfield(paramstruct,'datovlaymin')    %  then change to input value
    datovlaymin = paramstruct.datovlaymin ; 
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

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ; 
  end

  if isfield(paramstruct,'nbin')    %  then change to input value
    nbin = paramstruct.nbin ; 
  end

  if isfield(paramstruct,'minx')    %  then change to input value
    minx = paramstruct.minx ; 
  end

  if isfield(paramstruct,'maxx')    %  then change to input value
    maxx = paramstruct.maxx ; 
  end

  if isfield(paramstruct,'bpar')    %  then change to input value
    bpar = paramstruct.bpar ; 
  end

  if isfield(paramstruct,'ibdryadj')    %  then change to input value
    ibdryadj = paramstruct.ibdryadj ; 
  end

  if isfield(paramstruct,'nfh')    %  then change to input value
    nfh = paramstruct.nfh ; 
  end

  if isfield(paramstruct,'fhmin')    %  then change to input value
    fhmin = paramstruct.fhmin ; 
  end

  if isfield(paramstruct,'fhmax')    %  then change to input value
    fhmax = paramstruct.fhmax ; 
  end

  if isfield(paramstruct,'nsh')    %  then change to input value
    nsh = paramstruct.nsh ; 
  end

  if isfield(paramstruct,'shmin')    %  then change to input value
    shmin = paramstruct.shmin ; 
  end

  if isfield(paramstruct,'shmax')    %  then change to input value
    shmax = paramstruct.shmax ; 
  end

  if isfield(paramstruct,'moviefps')    %  then change to input value
    moviefps = paramstruct.moviefps ; 
  end

  if isfield(paramstruct,'moviecstr')    %  then change to input value
    moviecstr = paramstruct.moviecstr ; 
  end

  if isfield(paramstruct,'nrepeat')    %  then change to input value
    nrepeat = paramstruct.nrepeat ; 
  end

  if isfield(paramstruct,'ishoweffwind')    %  then change to input value
    ishoweffwind = paramstruct.ishoweffwind ; 
  end
  
  if isfield(paramstruct,'hhighlight')    %  then change to input value
    hhighlight = paramstruct.hhighlight ; 
  end


end    %  of resetting of input parameters





%  Turn iout into control parameters
%
if iout == 1
  viplot = [1; 0; 1; 0] ;
         %  indicators for family overlay, family surface, slope SiZer, 
         %                                        curvature SiZer
elseif iout == 2
  viplot = [1; 0; 1; 1] ;
elseif iout == 3
  viplot = [1; 1; 1; 1] ;
elseif iout == 4
  viplot = [1; 0; 0; 0] ;
elseif iout == 5
  viplot = [0; 1; 0; 0] ;
elseif iout == 6
  viplot = [0; 0; 1; 0] ;
elseif iout == 7
  viplot = [0; 0; 0; 1] ;
end
nplot = sum(viplot) ;

if  nplot == 1  &&  imovie == 1
          %  then reset imovie, since it focuses on figures, not axes 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from sizerSM.m:    !!!') ;
  disp('!!!   resetting imovie to 0      !!!') ;
  disp('!!!   (use iout < 4 for movie)   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  imovie = 0 ;
end

ihazcenlb = (ihazard == 1  |  icensor == 1  |  ilengthb == 1) ;
          %  one if are doing either hazard estimation, or censoring
if  ihazcenlb == 1   &&   viplot(4) == 1
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from sizerSM.m:      !!!') ;
  disp('!!!   curvature SiZer            !!!') ;
  disp('!!!   not supported for          !!!') ;
  disp('!!!   Hazard Est. or Censoring   !!!') ;
  disp('!!!   or Length Biased Sampling  !!!') ;
  disp('!!!   Choose another iout        !!!') ;
  disp('!!!   Terminating Execution      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;  
end
if  ihazcenlb == 1   &&   ~(simflag == 1)
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from sizerSM.m:      !!!') ;
  disp(['!!!   simflag = ' num2str(simflag)]) ;
  disp('!!!   but only simflag = 1         !!!') ;
  disp('!!!   is currently supported for   !!!') ;
  disp('!!!   Hazard Est. or Censoring     !!!') ;
  disp('!!!   or Length Biased Sampling    !!!') ;
  disp('!!!   Resetting to simflag = 1     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  simflag = 1 ;  
end



%  detect whether density or regression data
%
if icensor == 1    %  then assume data are censored

  xdat = data(:,1) ;
  vdel = data(:,2) ;
  idatyp = 1 ;
  mdat = [xdat, vdel] ;

else    %  then assume data are uncensored

  if size(data,2) == 1    %  Then is density or hazard estimation
    xdat = data(:,1) ;
    idatyp = 1 ;
    mdat = xdat ;
  else                    %  Then assume regression ;
    xdat = data(:,1) ;
    ydat = data(:,2) ;
    idatyp = 2 ;
    mdat = [xdat,ydat] ;
  end

end



%  check not all data points are same
%
if std(xdat) == 0     %  then all data points are same, warn and quit
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from sizerSM.m:    !!!') ;
  disp('!!!   All x values are same,   !!!') ;
  disp('!!!   Terminating Execution    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end




%  Determine data ranges
%
if isempty(minx)
  minx = min(xdat) ;
end

if isempty(maxx)
  maxx = max(xdat) ;
end

ndat = length(xdat) ;
centx = mean([minx;maxx]) ;




%  Check there are differing data points within range
%
flag = (xdat < maxx) & (xdat > minx) ;
if sum(flag) == 0    %  then no data in range
  errflag = 1 ;
else                 %  there are data in range, so check are different
  if std(xdat(flag)) == 0
    errflag = 1 ;
  else
    errflag = 0 ;
  end
end

if errflag == 1     %  write error message, and quit
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from sizerSM.m:           !!!') ;
  disp('!!!   no x values in chosen range,    !!!') ;
  disp('!!!   or x values are all the same,   !!!') ;
  disp('!!!   Terminating Execution           !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end



%  Determine bandwidth ranges
%
range = maxx - minx ;
binw = range / (nbin - 1) ;


if isempty(nfh)
  if imovie == 0
    nfh = 11 ;
  else
    nfh = 41 ;
  end
end

if isempty(fhmin)
  fhmin = 2 * binw ;
end

if isempty(fhmax)
  fhmax = range ;
end

if nfh > 1
  if fhmin >= fhmax
    disp('!!!  Warning from sizerSM:              !!!') ;
    disp('!!!  nfh > 1, and fhmin >= fhmax        !!!') ;
    disp('!!!  will reset nfh to 1, & use fhmax   !!!') ;
    nfh = 1 ;
    fvh = fhmax ;
  else
    fvh = logspace(log10(fhmin),log10(fhmax),nfh) ;
  end
else
  if fhmin == fhmax
    fvh = fhmax ;
  else
    disp('!!!  Warning from sizerSM:                 !!!') ;
    disp('!!!  nfh = 1, and fhmin, fhmax different   !!!') ;
    disp('!!!  will use fhmax as single h            !!!') ;
    fvh = fhmax ;
  end
end

if isempty(nsh)
  if imovie == 0
    nsh = 11 ;
  else
    nsh = 41 ;
  end
end

if isempty(shmin)
  shmin = 2 * binw ;
end

if isempty(shmax)
  shmax = range ;
end


if nsh > 1
  if shmin >= shmax
    disp('!!!  Warning from sizerSM:              !!!') ;
    disp('!!!  nsh > 1, and shmin >= shmax        !!!') ;
    disp('!!!  will reset nsh to 1, & use shmax   !!!') ;
    nsh = 1 ;
    svh = shmax ;
  else
    svh = logspace(log10(shmin),log10(shmax),nsh) ;
  end
else
  if shmin == shmax
    svh = shmax ;
  else
    disp('!!!  Warning from sizerSM:                 !!!') ;
    disp('!!!  nsh = 1, and shmin, shmax different   !!!') ;
    disp('!!!  will use shmax as single h            !!!') ;
    svh = shmax ;
  end
end



%  Set up colormap
%
if icolor ~= 0     %  Then go for nice colors in slope and curvature sizer

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

  famcolorstr = 'b' ;
          %  Plot most curves in blue
  highlightcolorstr = 'k' ;
          %  Plot highlighted curve in black
  datcolorstr = dolcolor ;
          %  Plot overlaid data in chosen color
  cendatcolorstr = 'y' ;
          %  Plot overlaid censored data in yellow

else     %  Then use gray scale maps everywhere

  %  Set up gray level color map
  comap = [.2, .2, .2; ...
           .35, .35, .35; ...
           .5, .5, .5; ...
           .8, .8, .8] ;
  colormap(comap) ;

  famcolorstr = 'k' ;
          %  Plot most curves in black
  highlightcolorstr = 'k' ;
          %  Plot highlighted curve in black
  datcolorstr = 'k' ;
          %  Plot overlaid data in black
  cendatcolorstr = [.5, .5, .5] ;
          %  Plot overlaid censored data in gray

end





%  Bin the data (if needed)
%
if ihazcenlb == 0    %  then none of censored, hazard or length biased, 
                       %  so consider common binning

  if  viplot(2) == 1  || ...
      viplot(3) == 1  || ...
      viplot(4) == 1  || ...
      idatovlay == 0
                    %  then are doing something besides family only,
                    %  or else want to use a single binning


    bincts = lbinrSM(data,[minx; maxx; nbin],bpar) ;
        %  eptflag = bpar


    if idatyp == 2    %  doing regression
                        %  so need enhanced matrix of bincounts

      bincts2 = lbinrSM([data(:,1), data(:,2).^2],[minx; maxx; nbin],bpar) ;
        %  eptflag = bpar
      bincts = [bincts, bincts2(:,2)] ;

    end

  end    %  of binning if-block

end




%  Calculate data driven bandwidths for highlighting (if needed)
%
if  imovie == 0   && ...
    hhighlight ~= 0   && ...
    ihazcenlb == 0 

  if ischar(hhighlight)

    disp('!!!   Warning from SiZerSM:  hhighlight must be numeric  !!!') ;
    disp('!!!       will not show highlighted bandwidth            !!!') ;

    hcflag = 0 ;

  else

    if  hhighlight < 0    %  then do data driven 
      if ihazcenlb == 0
        if idatyp == 1    %  doing density estimation
          hcent = bwsjpiSM(mdat,[minx; maxx; nbin],0,bpar) ;
        else              %  doing regression
          hcent = bwrswSM(mdat,0,[minx; maxx; nbin],bpar) ;
        end
        hcflag = 1 ;
      else
        disp('!!!   Warning from SiZerSM:  can''t do data driven h  !!!') ;
        disp('!!!       for censored, hazard or length biased,     !!!') ;
        disp('!!!       will not show highlighted bandwidth        !!!') ;
        hcflag = 0 ;
      end
    else
      hcent = hhighlight ;
      hcflag = 1 ;
    end

    %  Check range and find bandwidth closest to data driven (or input)
    %      for highlighting (if needed)
    %
    if hcflag == 1
      if hcent < fhmin    %  if data based h below range
        disp('!!!   Warning from SiZerSM: highlighted h below this range   !!!') ;
        hcflag = 0 ;
      elseif hcent > fhmax    %  if databased h above this range
        disp('!!!   Warning from SiZerSM: highlighted h above this range   !!!') ;
        hcflag = 0 ;
      else     %  if data based in range, then get its nearest index
        [~, hcind] = min(abs(log10(hcent) - log10(fvh))) ;
        hcflag = 1 ; 
      end
    end

  end


else

  hcflag = 0 ;

end




%  Calculate and plot family of smooths (if needed)
%
if  viplot(1) == 1  ||  viplot(2) == 1    %  Then will show a family plot

  if iscreenwrite == 1
    disp('    SiZerSM Working on family') ;
  end

  if nplot > 1    %  then doing multiple graphics
    clf ;   
    fighand = gcf ;
    if nplot == 4
      famolh = subplot(2,2,1) ;
    else
      famolh = subplot(nplot,1,1) ;
    end
  end



  if idatyp == 1    %  doing density or hazard estimation

    if ihazcenlb == 1      %  then are doing hazard or 
                             %  censoring or length biased est.

      itype = 1 + ihazard + 2*ilengthb ;
          %  argument itype (of CHkdeSM) is:
          %                1  when ihazard = 0 and ilengthb = 0
          %                2  when ihazard = 1 and ilengthb = 0
          %                3  when ihazard = 0 and ilengthb = 1
          %                4  when ihazard = 1 and ilengthb = 1

      if idatovlay == 0
        ndataoverlay = 0 ;
      else
        if idatovlay > 2
          dolhtseed = idatovlay ;
        end
        ndataoverlay = ndatovlay ;
      end

      paramstruct = struct('itype',itype, ...
                           'vxgrid',[minx; maxx; nbin], ...
                           'eptflag',bpar, ...
                           'titlestr',famoltitle, ...
                           'titlefontsize',titlefontsize, ...
                           'xlabelstr',xlabelstr, ...
                           'ylabelstr',ylabelstr, ...
                           'labelfontsize',labelfontsize, ...
                           'linecolor',famcolorstr, ...
                           'ndataoverlay',ndataoverlay, ...
                           'dolcolor',datcolorstr, ...
                           'ibigdot',ibigdot, ...
                           'dolhtseed',dolhtseed) ;

      if  viplot(1) == 1  &&  viplot(1) == 2
                                      %  then want BOTH family overlay and surface
          paramstruct.iplot = 1 ;
        [mfam, fxgrid] = CHkdeSM(mdat,fvh,paramstruct) ;
      elseif viplot(1) == 1
                                      %  then want ONLY family overlay
        CHkdeSM(mdat,fvh,paramstruct) ;
      elseif viplot(1) == 2 
                                      %  then want ONLY surface
        [mfam, fxgrid] = CHkdeSM(mdat,fvh,paramstruct) ;
      end

    else      %  do ordinary density estimation

      paramstruct = struct('vh',fvh, ...
                           'vxgrid',[minx; maxx; nbin], ...
                           'eptflag',bpar, ...
                           'ibdryadj',ibdryadj, ...
                           'titlestr',famoltitle, ...
                           'titlefontsize',titlefontsize, ...
                           'xlabelstr',xlabelstr, ...
                           'ylabelstr',ylabelstr, ...
                           'labelfontsize',labelfontsize, ...
                           'linecolor',famcolorstr, ...
                           'idatovlay',idatovlay, ...
                           'ndatovlay',ndatovlay, ...
                           'datovlaymax',datovlaymax, ...
                           'datovlaymin',datovlaymin, ...
                           'dolcolor',datcolorstr, ...
                           'ibigdot',ibigdot) ;

      if viplot(1) == 1    %  then plot family overlay
        paramstruct.iplot = 1 ;
      end


      if idatovlay == 0    %  then use bincounts, to avoid rebinning
        paramstruct.imptyp = -1 ;
            %  indicate use of previously binned data
        [mfam, fxgrid] = kdeSM(bincts,paramstruct) ;
      else                      %  then use raw data, for overlay
        [mfam, fxgrid] = kdeSM(mdat,paramstruct) ;
      end

    end

  else              %  doing regression

    if idatovlay == 0
      ndataoverlay = 0 ;
    else
      ndataoverlay = ndatovlay ;
    end

    paramstruct = struct('vh',fvh,...
                         'vxgrid',[minx; maxx; nbin], ...
                         'eptflag',bpar, ...
                         'titlestr',famoltitle, ...
                         'titlefontsize',titlefontsize, ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr',ylabelstr, ...
                         'labelfontsize',labelfontsize, ...
                         'linecolor',famcolorstr, ...
                         'ndataoverlay',ndataoverlay, ...
                         'dolcolor',datcolorstr, ...
                         'ibigdot',ibigdot) ;

    if viplot(1) == 1    %  then plot family overlay
      paramstruct = setfield(paramstruct,'iplot',1) ;
    end


    if idatovlay == 0    %  then use bincounts, to avoid rebinning
      paramstruct = setfield(paramstruct,'imptyp',-1) ;
          %  indicate use of previously binned data
      [mfam, fxgrid] = nprSM(bincts(:,[1 2]),paramstruct) ;
          %  only need first two columns for this
    else                      %  then use raw data, for overlay
      [mfam, fxgrid] = nprSM(mdat,paramstruct) ;
    end


  end

  vax = axis ;
  fbottom = vax(3) ;
  ftop = vax(4) ;



  if viplot(1) == 1    %  then have plotted family overlay

    %  get handles to lines in family plot
    %
    vaxchil = get(gca,'Children') ;
    vfamh = [] ;
    for i = length(vaxchil):-1:1    %  since order is reversed
      if get(vaxchil(i),'LineStyle') == '-'
        vfamh = [vfamh; vaxchil(i)] ;
      end
    end

    %  Highlight data driven curve (if needed)
    %
    if hcflag == 1
      set(vfamh(hcind),'LineWidth',2) ;
          %  use fatter line width for data based choice
      set(vfamh(hcind),'Color',highlightcolorstr) ;
          %  use given color for one in middle
    end


  end    


end    %  of family plot construction if block



%  Calculate SiZer (if needed)  and plot (if needed)
%
if  viplot(2) == 1  ||  viplot(3) == 1

  if iscreenwrite == 1
    disp('    SiZerSM Working on SiZer') ;
  end


  if nplot > 1    %  then doing multiple graphics
    if nplot == 4
      sizerh = subplot(2,2,3) ;
    else
      sizerh = subplot(nplot,1,2) ;
    end
  end


  if ihazcenlb == 0

    paramstruct = struct('vxgp',[minx; maxx; nbin], ...
                         'vhgp',[shmin; shmax; nsh], ...
                         'eptflag',bpar, ...
                         'ibdryadj',ibdryadj, ...
                         'simflag',simflag, ...
                         'alpha',alpha, ...
                         'imptyp',-1, ...
                         'icolor',icolor, ...
                         'titlestr',sizertitle, ...
                         'titlefontsize',titlefontsize, ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr','log_{10}(h)', ...
                         'labelfontsize',labelfontsize) ;


    if viplot(3) == 1    %  Then will show a SiZer map
      paramstruct.iplot = 1 ;
    end


    sizermap = sz2SM(bincts,paramstruct) ;


  else

    itype = 1 + ihazard + 2*ilengthb ;
        %  argument itype (of CHkdeSM) is:
        %                1  when ihazard = 0 and ilengthb = 0
        %                2  when ihazard = 1 and ilengthb = 0
        %                3  when ihazard = 0 and ilengthb = 1
        %                4  when ihazard = 1 and ilengthb = 1

    paramstruct = struct('itype',itype, ...
                         'vxgp',[minx; maxx; nbin], ...
                         'vhgp',[shmin; shmax; nsh], ...
                         'eptflag',bpar, ...
                         'alpha',alpha, ...
                         'icolor',icolor, ...
                         'titlestr',sizertitle, ...
                         'titlefontsize',titlefontsize, ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr','log_{10}(h)', ...
                         'labelfontsize',labelfontsize) ;


    if viplot(3) == 1    %  Then will show a SiZer map
      paramstruct.iplot = 1 ;
    end

    sizermap = CHsz1SM(mdat,paramstruct) ;

  end


  %  Highlight data driven curve (if needed)
  %
  if hcflag == 1
    hold on ;
      sizerlineh = plot([minx; maxx], ones(2,1)*log10(hcent), ...
                                         ['-' highlightcolorstr]) ;
    hold off ;
  end


  if ishoweffwind == 1    %  then add curves showing effective window width

    hold on ;
      plot(centx + 2*svh, log10(svh),':w') ;
      plot(centx - 2*svh, log10(svh),':w') ;
    hold off ;

  end


end





%  Do family surface graphics (if needed) 
%
if viplot(2) == 1

  if nsh == nfh    % then go ahead with surface graphics

    if nplot > 1    %  then doing multiple graphics
      famsurh = subplot(2,2,2) ;
            %  this only appears in the 4 panel plot
    end

    %  First do decimation if needed
    %
    if nbin > 41

      decimfact = ceil((nbin - 1) / 40) ;
            %  factor to decimate by
      keepflag = (1:decimfact:nbin)' ;

      mfamdecim = mfam(keepflag,:) ;
      fxgriddecim = fxgrid(keepflag) ;
      sizermapdecim = sizermap(:,keepflag) ;

    else

      mfamdecim = mfam ;
      fxgriddecim = fxgrid ;
      sizermapdecim = sizermap ;

    end



    l10hdecim = log10(fvh) ;
    if nfh > 21

      decimfact = ceil((nfh - 1) / 20) ;
            %  factor to decimate by
      keepflag = (1:decimfact:nfh)' ;

      mfamdecim = mfamdecim(:,keepflag) ;
      sizermapdecim = sizermapdecim(keepflag,:) ;
      l10hdecim = l10hdecim(keepflag) ;

    end



    nrowsmd = size(sizermapdecim,1) ;
    ncolsmd = size(sizermapdecim,2) ;
    sizermapdecim = sizermapdecim(2:nrowsmd,2:ncolsmd) ;
          %  cut off one row and one column, to give number
          %  of panels

    %  Make surface plot
    %
    surf(fxgriddecim,l10hdecim,mfamdecim',sizermapdecim) ;
          %  surface plot, using SiZer colors
      th = title(famsurtitle) ;
      if ~isempty(titlefontsize)
        set(th,'FontSize',titlefontsize) ;
      end
      lxh = xlabel(xlabelstr) ;
      lyh = ylabel('log_{10}(h)') ;
      lzh = zlabel(ylabelstr) ;
      if ~isempty(labelfontsize)
        set(lxh,'FontSize',labelfontsize) ;
        set(lyh,'FontSize',labelfontsize) ;
        set(lzh,'FontSize',labelfontsize) ;
      end

      if viplot(1) == 0    %  then did not make family overlay,
                           %  so need to sensibly define axes
        ftop = max(max(mfam)) ;
        if idatyp == 1    %  doing density or hazard estimation
          fbottom = 0  ;
        else    %  doing regression
          fbottom = min(min(mfam)) ;
        end
      end

      vax = [minx,maxx,log10(shmin),log10(shmax),fbottom,ftop] ;
      axis(vax) ;
      set(gca,'Xgrid','off') ;
      set(gca,'Ygrid','off') ;
      set(gca,'Zgrid','off') ;
      set(gca,'Xdir','reverse')
      view(viewangle) ; 

      clim([1, 8]) ;
      if icolor ~= 0     %  Then go for nice colors in sizer and sicom
        colormap(cocomap) ;  
      else     %  Then use gray scale maps everywhere
        colormap(comap) ;  
      end

    else

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Error from sizerSM.m:   !!!') ;
      disp('!!!   For surface plot,       !!!') ;
      disp('!!!   must have nsh = nfh     !!!') ;
      disp('!!!   Terminating execution   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      return ;

    end


  end    %  of family surface plot construction if block



%  Calculate curvature SiZer (if needed)  and plot (if needed)
%
if viplot(4) == 1    %  Then will show a curvature SiZer map

  if iscreenwrite == 1
    disp('    SiZerSM Working on curvature SiZer') ;
  end


  if nplot > 1    %  then doing multiple graphics
    if nplot == 4
      siconh = subplot(2,2,4) ;
    else 
      siconh = subplot(nplot,1,3) ;
    end
  end


  paramstruct = struct('vxgp',[minx; maxx; nbin], ...
                       'vhgp',[shmin; shmax; nsh], ...
                       'eptflag',bpar, ...
                       'ibdryadj',ibdryadj, ...
                       'simflag',simflag, ...
                       'alpha',alpha, ...
                       'imptyp',-1, ...
                       'icolor',icolor, ...
                       'titlestr',curvsizertitle, ...
                       'titlefontsize',titlefontsize, ...
                       'xlabelstr',xlabelstr, ...
                       'ylabelstr','log_{10}(h)', ...
                       'labelfontsize',labelfontsize) ;


  sc2SM(bincts,paramstruct) ;


  %  Highlight data driven curve (if needed)
  %
  if hcflag == 1
    hold on ;
      sizerlineh = plot([minx; maxx], ones(2,1)*log10(hcent), ...
                                         ['-' highlightcolorstr]) ;
    hold off ;
  end


  if ishoweffwind == 1    %  then add curves showing effective window width

    hold on ;
      plot(centx + 2*svh, log10(svh),':w') ;
      plot(centx - 2*svh, log10(svh),':w') ;
    hold off ;

  end


end



%  Do main movie construction
%
if imovie == 1

  if iscreenwrite == 1
    disp('    SiZerSM Working on Movie') ;
  end


  clear moviestruct ;


  %  Do highlight on family plot (if needed)
  %
  if viplot(1) == 1
    axes(famolh) ;
    hold on ;
      famollineh = plot(fxgrid,mfam(:,1),highlightcolorstr) ;
      set(famollineh,'LineWidth',2) ;
          %  use fatter line width for data based choice
    hold off ;
  end

  %  Do highlight on family surface (if needed)
  %
  if viplot(2) == 1
    axes(famsurh) ;
    hold on ;
      famsurlineh = plot3(fxgrid,log10(fvh(1))*ones(nbin,1), ...
                                   mfam(:,1),highlightcolorstr) ;
      set(famsurlineh,'LineWidth',2) ;
          %  use fatter line width for data based choice
    hold off ;
  end

  %  Add highlight to SiZer map (if needed)
  %
  if viplot(3) == 1
    axes(sizerh) ;
          %  make SiZer axes current
    hold on ;
      sizerlineh = plot([minx; maxx], ones(2,1)*log10(fvh(1)), ...
                                           ['-' highlightcolorstr]) ;
    hold off ;
  end

  %  Add highlight to curvature SiZer map (if needed)
  %
  if viplot(4) == 1
    axes(siconh) ;
          %  make SiCon axes current
    hold on ;
      siconlineh = plot([minx; maxx], ones(2,1)*log10(fvh(1)), ...
                                           ['-' highlightcolorstr]) ;
    hold off ;
  end


  moviestruct(1) = getframe(fighand) ;


  %  Loop through and change
  %
  for iframe = 2:nfh

    h = fvh(iframe) ;

    if viplot(1) == 1
      set(famollineh,'YData',mfam(:,iframe)) ;
    end


    if viplot(2) == 1
      set(famsurlineh,'YData',log10(fvh(iframe))*ones(nbin,1)) ;
      set(famsurlineh,'ZData',mfam(:,iframe)) ;
    end


    if viplot(3) == 1
      set(sizerlineh,'YData',ones(2,1)*log10(h)) ;
    end


    if viplot(4) == 1
      set(siconlineh,'YData',ones(2,1)*log10(h)) ;
    end


		moviestruct(iframe) = getframe(fighand) ;

  end    %  of iframe loop, to make movie



  %  Reorder frames, and replay
  %
  vmorder = [(1:nfh),((nfh-1):-1:2)] ;
  moviestruct = moviestruct(vmorder) ;
          %  reorder frames, to loop back to beginning


  movie(fighand,moviestruct,nrepeat,moviefps) ;
          %  Play movie on screen


end



%  Save results (if needed)
%
if ~isempty(savestr)     %  then save results

  if iscreenwrite == 1
    disp('    SiZerSM saving results') ;
  end


  if imovie == 0     %  then save as postscript file

    if  nplot == 1  ||  nplot == 4
      orient landscape ;
    else
      orient tall ;
    end

    if icolor ~= 0     %  then make color postscript
      print('-dpsc',[savestr '.ps']) ;
    else                %  then make black and white
      print('-dps',[savestr '.ps']) ;
    end

  elseif imovie == 1    %  then save as mpeg file

    movie2avi(moviestruct,savestr,'compression',moviecstr, ...
                          'keyframe',moviefps,'fps',moviefps) ;

  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sizerSM.m:                !!!') ;
    disp('!!!   Invalid value of imovie,             !!!') ;
    disp('!!!   Terminating Execution without save   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;

  end


  if iscreenwrite == 1
    disp('    SiZerSM finished save') ;
    disp('  ') ;
  end

end



