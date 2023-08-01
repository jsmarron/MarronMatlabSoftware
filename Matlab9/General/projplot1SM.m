function projplot1SM(data,vdir,paramstruct) 
% PROJPLOT1SM, PROJection PLOT in 1 dimension, 
%   Steve Marron's matlab function
%     Studies one dimensional projections of data,
%     using jitter-type plots and kernel density estimates
%     based on a given direction vector
%
% Inputs:
%   data    - d x n matrix of data, each column vector is 
%                    a "d-dim digitized curve"
%
%   vdir    - a d dimensional "direction vector"
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
%                    Version for easy copying and modification:
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    icolor           0  fully black and white version (everywhere)
%                     string (any of 'r', 'g', 'b', etc.) that single color
%                     1  (default)  color version (Matlab 7 color default)
%                     2  time series version (ordered spectrum of colors)
%                     3  black and white time series version 
%                             (ordered spectrum of gray levels)
%                     nx3 color matrix:  a color label for each data point
%
%    markerstr        Can be either a single string with symbol to use for marker,
%                         e.g. 'o' (default), '.', '+', 'x'
%                         (see "help plot" for a full list)
%                     Or a character array (n x 1), of these symbols,
%                         One for each data vector, created using:  char
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
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%                              Only has effect when markerstr = '.' 
%
%    idatovlay        0  Do not overlay data on kde plot
%                     1  (default) overlay data using heights based on data ordering
%                              Note:  To see "c.d.f. style" increasing line, 
%                                     should first sort the data
%                     2  overlay data using random heights
%                     another integer > 0,  overlay data, using random heights,
%                                           with this number as the seed (so can 
%                                           better match data points across plots),
%                                           (should be an integer with <= 8 digits)
%
%    ndatovlay     number of data points overlayed (only has effect for idatovlay > 0)
%                       1  -  overlay up to 1000 points 
%                                           (random choice, when more)
%                       2  -  (default) overlay full data set
%                       n > 2   -  overlay n random points
%
%    datovlaymax      maximum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.6
%
%    datovlaymin      minimum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.5
%
%    legendcellstr    cell array of strings for legend (nl of them),
%                     useful for (colored) classes, create this using
%                     cellstr, or {{string1 string2 ...}}
%                     CAUTION:  If are updating this field, using a command like:
%                         paramstruct = setfield(paramstruct,'legendcellstr',...
%                     Then should only use single braces in the definition of
%                     legendecellstr, i. e. {string1 string2 ...}
%                     Also a way to add a "title" to the first plot
%                             for this, use input of form:  {{string}}
%                     Also can indicate symbols, by just adding (at least 
%                             for +,x.o) into the text
%
%    mlegendcolor     nl x 3 color matrix, corresponding to cell legends above
%                     (not needed when legendcellstr not specified)
%                     (defaults to black when not specified)
%
%    vaxlim        Vector of axis limits
%                        Use [] for default of all automatically chosen, by axisSM
%                        Use 1 for symmetrically chosen, by axisSM
%                            (often preferred for centered plots, as in PCA)
%                                 Caution:  For either of these, projections 
%                                           which are all the same will 
%                                           generate a warning message, and
%                                           be shown using common value +- 1
%                                           and bandwidth of 0.1
%                        Otherwise, must be 1 x 4 or 1 x 2 row vector of axis limits
%                            1 x 4 determines all 4 axis limits
%                            1 x 2 determines horizontal axis limits
%                        Note:  Use is generally not recommended,
%                        because defaults give "good visual impression
%                        of decomposition".  It is mostly intended for use 
%                        with certain types of zooming
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
%    ifigure          index for figure number:
%                       0    (default) Ignore Figure, and put in current axes
%                                (for use as component of larger scale plot)
%                       > 0  Put in Figure ifigure, first clearing the figure
%                                (usually best for stand alone plot)
%                       < 0  Put in Figure -ifigure, without clearing
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
%     When savestr exists,
%        Postscript files saved in 'savestr'.ps
%                 (color postscript for icolor ~= 0)
%                 (B & W postscript for icolor = 0)
%
%
% Assumes path can find personal functions:
%    Plot1dSM.m
%    axisSM.m
%    bwsjpiSM.m
%    kdeSM.m
%    lbinrSM.m
%    vec2matSM.m
%    bwrfphSM.m
%    bwosSM.m
%    rootfSM
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM.m
%    cquantSM.m
%    printSM.m

%    Copyright (c) J. S. Marron 2004-2023



%  First set all parameters to defaults
%
icolor = 1 ;
markerstr = 'o' ;
isubpopkde = 0 ;
ibigdot = 0 ;
idatovlay = 1 ;
ndatovlay = 2 ;
datovlaymax = 0.6 ;
datovlaymin = 0.5 ;
legendcellstr = {} ;
mlegendcolor = [] ;
vaxlim = [] ;
titlestr = '' ;
titlefontsize = [] ;
xlabelstr = '' ;
ylabelstr = '' ;
labelfontsize = [] ;
ifigure = 0 ;
savestr = [] ;
savetype = 1 ;
iscreenwrite = 0 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2    %  then paramstruct is an argument

  if isfield(paramstruct,'icolor')     %  then change to input value
    icolor = paramstruct.icolor ; 
  end 

  if isfield(paramstruct,'markerstr')     %  then change to input value
    markerstr = paramstruct.markerstr ; 
  end 

  if isfield(paramstruct,'isubpopkde')     %  then change to input value
    isubpopkde = paramstruct.isubpopkde ; 
  end 

  if isfield(paramstruct,'ibigdot')     %  then change to input value
    ibigdot = paramstruct.ibigdot ; 
  end 

  if isfield(paramstruct,'idatovlay')     %  then change to input value
    idatovlay = paramstruct.idatovlay ; 
  end 

  if isfield(paramstruct,'ndatovlay')     %  then change to input value
    ndatovlay = paramstruct.ndatovlay ; 
  end 

  if isfield(paramstruct,'datovlaymax')     %  then change to input value
    datovlaymax = paramstruct.datovlaymax ; 
  end 

  if isfield(paramstruct,'datovlaymin')     %  then change to input value
    datovlaymin = paramstruct.datovlaymin ; 
  end 

  if isfield(paramstruct,'legendcellstr')     %  then change to input value
    legendcellstr = paramstruct.legendcellstr ; 
  end 

  if isfield(paramstruct,'mlegendcolor')     %  then change to input value
    mlegendcolor = paramstruct.mlegendcolor ; 
  end 

  if isfield(paramstruct,'vaxlim')     %  then change to input value
    vaxlim = paramstruct.vaxlim ; 
  end 

  if isfield(paramstruct,'titlestr')     %  then change to input value
    titlestr = paramstruct.titlestr ; 
  end 

  if isfield(paramstruct,'titlefontsize')     %  then change to input value
    titlefontsize = paramstruct.titlefontsize ; 
  end 

  if isfield(paramstruct,'xlabelstr')     %  then change to input value
    xlabelstr = paramstruct.xlabelstr ; 
  end 

  if isfield(paramstruct,'ylabelstr')     %  then change to input value
    ylabelstr = paramstruct.ylabelstr ; 
  end 

  if isfield(paramstruct,'labelfontsize')     %  then change to input value
    labelfontsize = paramstruct.labelfontsize ; 
  end 

  if isfield(paramstruct,'ifigure')     %  then change to input value
    ifigure = paramstruct.ifigure ; 
  end 
  
  if isfield(paramstruct,'savestr')     %  then use input value
    savestr = paramstruct.savestr ; 
  end 
  
  if isfield(paramstruct,'savetype')     %  then use input value
    savetype = paramstruct.savetype ; 
  end 

  if isfield(paramstruct,'iscreenwrite')     %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ; 
  end 

end     %  of resetting of input parameters


%  set preliminary stuff
%
d = size(data,1) ;
         %  dimension of each data curve
n = size(data,2) ;
         %  number of data curves

if ~(d == size(vdir,1)) 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from projplot1SM.m:   !!!') ;
  disp('!!!   Dimension of vdir must be   !!!') ;
  disp('!!!   same as dimension of data   !!!') ;
  disp('!!!   Terminating execution       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end 

if ~(1 == size(vdir,2)) 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from projplot1SM.m:   !!!') ;
  disp('!!!   vdir must be a single       !!!') ;
  disp('!!!   column vector               !!!') ;
  disp('!!!   Terminating execution       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end 


%  Compute Projections
%
vdirlen2 = sum(vdir.^2) ;
if abs(vdirlen2 - 1) < 10^(-10)     %  already has length 1
  vdirn = vdir ;
else     %  need to adjust length to be 1
  if iscreenwrite == 1     %  then give a warning about adjustment
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from projplot1SM.m:          !!!') ;
    disp('!!!   vdir should be a direction vector,   !!!') ;
    disp('!!!   will adjust to length 1              !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  end 
  if vdirlen2 < 10^(-10)      %  then can't proceed, so quit
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from projplot1SM.m:   !!!') ;
    disp('!!!   vdir length is too short,   !!!') ;
    disp('!!!   Terminating execution       !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end 
  vdirn = vdir / sqrt(vdirlen2) ;
end 

vproj = vdirn' * data ;
    %  row vector of inner products with data

P1dParamstruct.icolor = icolor ;
P1dParamstruct.markerstr = markerstr ;
P1dParamstruct.isubpopkde = isubpopkde ;
P1dParamstruct.ibigdot = ibigdot ;
P1dParamstruct.idatovlay = idatovlay ;
P1dParamstruct.ndatovlay = ndatovlay ;
P1dParamstruct.datovlaymax = datovlaymax ;
P1dParamstruct.datovlaymin = datovlaymin ;
P1dParamstruct.legendcellstr = legendcellstr ;
P1dParamstruct.mlegendcolor = mlegendcolor ;
P1dParamstruct.vaxlim = vaxlim ;
P1dParamstruct.titlestr = titlestr ;
P1dParamstruct.titlefontsize = titlefontsize ;
P1dParamstruct.xlabelstr = xlabelstr ;
P1dParamstruct.ylabelstr = ylabelstr ;
P1dParamstruct.labelfontsize = labelfontsize ;
P1dParamstruct.ifigure = ifigure ;
P1dParamstruct.savestr = savestr ;
P1dParamstruct.savetype = savetype ;
P1dParamstruct.iscreenwrite = iscreenwrite ;

Plot1dSM(vproj,P1dParamstruct) ;


