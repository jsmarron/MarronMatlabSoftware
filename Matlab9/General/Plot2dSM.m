function Plot2dSM(data,paramstruct) 
% PLOT2DSM, PROJection PLOT in 2 dimensions,
%   Steve Marron's matlab function
%     Generic plot of two dimensional (bivariate) data,
%     using a scatterplot
%
% Inputs:
%   data    - 2 x n matrix of row vector data
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
%                             (to be used everywhere, except SiZer & QQ
%                              useful for comparing classes)
%
%    markerstr        Can be either a single string with symbol to use for marker,
%                         e.g. 'o' (default), '.', '+', 'x'
%                         (see "help plot" for a full list)
%                     Or a character array (n x 1), of these symbols,
%                         One for each data vector, created using:  strvcat
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
%                          so might make most sense to use with icolor = 2 (3 resp.), 
%                          to avoid strange results)
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
%                     Note:  for symbols of different length strings,
%                            use all length 2 strings, e.g use strvcat
%                            on '- ' and '--'
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%                              Only has effect when markerstr = '.' 
%
%    legendcellstr    cell array of strings for legend (nl of them),
%                     useful for (colored) classes, create this using
%                     cellstr, or {{string1 string2 ...}}
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
%                        Otherwise, must be 1 x 4 row vector of axis limits
%                        Note:  Use is generally not recommended,
%                        because defaults give "good visual impression
%                        of decomposition.  It is mostly intended for use 
%                        with "very different" projections
%
%    iplotaxes        0 (default) do not plot axes
%                     1 plot axes 
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
%                       < 0  Put in Figure ifigure, first clearing the figure
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
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
%
% Assumes path can find personal functions:
%    Plot1dSM.m
%    vec2matSM.m
%    axisSM.m
%    lbinrSM.m
%    bwrswSM.m
%    interp1s.m
%    printSM.m

%    Copyright (c) J. S. Marron 2004-2023



%  First set all parameters to defaults
%
icolor = 1 ;
markerstr = 'o' ;
idataconn = [] ;
idataconncolor = 'k' ;
idataconntype = '-' ;
ibigdot = 0 ;
legendcellstr = {} ;
mlegendcolor = [] ;
vaxlim = [] ;
iplotaxes = 0 ;
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
if nargin > 1    %  then paramstruct is an argument

  if isfield(paramstruct,'icolor')     %  then change to input value
    icolor = paramstruct.icolor ; 
  end 

  if isfield(paramstruct,'markerstr')     %  then change to input value
    markerstr = paramstruct.markerstr ; 
  end 

  if isfield(paramstruct,'idataconn')     %  then change to input value
    idataconn = paramstruct.idataconn ; 
  end 

  if isfield(paramstruct,'idataconncolor')     %  then change to input value
    idataconncolor = paramstruct.idataconncolor ; 
  end 

  if isfield(paramstruct,'idataconntype')     %  then change to input value
    idataconntype = paramstruct.idataconntype ; 
  end 

  if isfield(paramstruct,'ibigdot')     %  then change to input value
    ibigdot = paramstruct.ibigdot ; 
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

  if isfield(paramstruct,'iplotaxes')     %  then change to input value
    iplotaxes = paramstruct.iplotaxes ; 
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
    if ~(ischar(savestr) || isempty(savestr))     %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from Plot2dSM.m:     !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end 
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
d = size(data,1) ; %#ok<NASGU>
         %  dimension of each data curve
n = size(data,2) ;
         %  number of data curves

if  (size(icolor,1) > 1)  ||  (size(icolor,2) > 1)      %  if have color matrix
  if ~(3 == size(icolor,2)) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:                  !!!') ;
    disp('!!!   icolor as a matrix must have 3 columns    !!!') ;
    disp('!!!   Resetting to icolor = 1, Matlab default   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    icolor = 1 ;
  elseif ~(n == size(icolor,1)) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:                  !!!') ;
    disp(['!!!   icolor as a matrix must have ' num2str(n) ' rows']) ;
    disp('!!!   Resetting to icolor = 1, Matlab default   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    icolor = 1 ;
  end 
end 

if  ~isempty(vaxlim)  &  ~(vaxlim == 1)  %#ok<AND2>
  if ~((size(vaxlim,1) == 1)  &&  (size(vaxlim,2) == 4)) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from Plot2dSM.m:      !!!') ;
    disp('!!!   vaxlim must be empty, = 1   !!!') ;
    disp('!!!   or a 1 x 4 row vector       !!!') ;
    disp('!!!   Terminating execution       !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end 
end 

if  ~isempty(savestr) && ifigure == 0 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from Plot2dSM.m:       !!!') ;
  disp('!!!   savestr = [], and ifigure = 0  !!!') ;
  disp('!!!   are inconsistent,              !!!') ;
  disp('!!!   Resetting ifigure to 1         !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  ifigure = 1 ;
end 

if ~isempty(idataconn) 

  if ~(size(idataconn,2) == 2) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:         !!!') ;
    disp('!!!   invalid idataconn                !!!') ;
    disp('!!!   Will not draw connecting lines   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    idataconn = [] ;

  elseif (min(min(idataconn)) < 1  ||  max(max(idataconn)) > n) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:         !!!') ;
    disp('!!!   entries in idataconn outside     !!!') ;
    disp('!!!   range of data                    !!!') ;
    disp('!!!   Will not draw connecting lines   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    idataconn = [] ;

  else 

    if size(idataconncolor,1) > 1 
      if ~(size(idataconncolor,1) == size(idataconn,1)  && ...
               size(idataconncolor,2) == 3) 
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Warning from Plot2dSM.m:         !!!') ;
        disp('!!!   invalid idataconncolor           !!!') ;
        disp('!!!   Resetting idataconncolor to ''k''  !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        idataconncolor = 'k' ;
      end 
    end 

    if  ~ischar(idataconntype)     | ...
        ~((size(idataconntype,1) == 1)  | ...
          (size(idataconntype,1) == size(idataconn,1))) %#ok<OR2>
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from Plot2dSM.m:        !!!') ;
      disp('!!!   invalid idataconntype           !!!') ;
      disp('!!!   Resetting idataconntype to ''-''  !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      idataconntype = '-' ;
    end 

  end 

end 



if  ~isempty(mlegendcolor) 
  if ~(size(legendcellstr,2) == size(mlegendcolor,1)) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:       !!!') ;
    disp('!!!   legendcellstr &  mlegendcolor  !!!') ;
    disp('!!!   must have the same number      !!!') ;
    disp('!!!   of entries                     !!!') ;
    disp('!!!   Resetting to no legend         !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    legendcellstr = [] ;
  end 
end 

if  ~isempty(mlegendcolor) 
  if ~(size(mlegendcolor,2) == 3) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:      !!!') ;
    disp('!!!   mlegendcolor                  !!!') ;
    disp('!!!   must have 3 columns           !!!') ;
    disp('!!!   Resetting to no legend        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    legendcellstr = [] ;
  end 
end 

if  size(markerstr,1) == 1  &&  size(markerstr,2) == 1  
  if  (ibigdot == 1)  &&  ~strcmp(markerstr,'.')  
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:      !!!') ;
    disp('!!!   ibigdot is set to 1,          !!!') ;
    disp('!!!   but a non-dot appears         !!!') ;
    disp('!!!   in markerstr                  !!!') ;
    disp('!!!   Resetting to ibigdot = 0      !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ibigdot = 0 ;
  end 
else 
  if ~(size(markerstr,1) == n  && ...
       size(markerstr,2) == 1  && ...
       ischar(markerstr)) 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from Plot2dSM.m:                !!!') ;
    disp('!!!   markerstr must be a character array   !!!') ;
    disp('!!!   with n rows and one column            !!!') ;
    disp('!!!   Terminating execution                 !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;
  end 
  if ibigdot == 1 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from Plot2dSM.m:      !!!') ;
    disp('!!!   ibigdot is set to 1,          !!!') ;
    disp('!!!   but markerstr has             !!!') ;
    disp('!!!   multiple entries              !!!') ;
    disp('!!!   Resetting to ibigdot = 0      !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ibigdot = 0 ;
  end 
end 


%  Set up appropriate colors
%
if  size(icolor,1) == 1   &&  size(icolor,2) == 1     %  then have scalar input

  if icolor == 0     %  then do everything black and white

    dotcolor = 'k' ;
        %  color of projection dots
    indivplotflag = 0 ;

  elseif ischar(icolor) 

    dotcolor = icolor ;
        %  string for color of projection dots
    indivplotflag = 0 ;

  elseif icolor == 1     %  then do MATLAB 7 color default

    colmap1 = [     0         0    1.0000 ; ...
                    0    0.5000         0 ; ...
               1.0000         0         0 ; ...
                    0    0.7500    0.7500 ; ...
               0.7500         0    0.7500 ; ...
               0.7500    0.7500         0 ; ...
               0.2500    0.2500    0.2500 ] ;
        %  color of projection dots, matlab default
    colmap = colmap1 ;
    while size(colmap,1) < n 
      colmap = [colmap; colmap1] ; %#ok<AGROW>
    end 
    colmap = colmap(1:n,:) ;

    indivplotflag = 1 ;

  elseif icolor == 2     %  then do spectrum for ordered time series

    colmap = RainbowColorsQY(n) ;

    indivplotflag = 1 ;

  elseif icolor == 3     %  then do gray levels for ordered time series

    %  set up color map stuff
    %
    startgray = 0.9 ;
    vgray = linspace(startgray,0,n) ;
    colmap = vgray' * ones(1,3) ;

    indivplotflag = 1 ;
        %  Leave this as "color" to get gray levels to show up in .ps file

  end     %  of icolor if-block


elseif  size(icolor,2) == 3      %  then have valid color matrix

  colmap = icolor ;

  indivplotflag = 1 ;

else     %   invalid color matrix input

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from Plot2dSM.m:              !!!') ;
  disp('!!!   Invalid icolor input,               !!!') ;
  disp('!!!   must be a scalar, or color matrix   !!!') ;
  disp('!!!   Terminating execution               !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;

end 


if  size(idataconncolor,1) == 1  &  (idataconncolor == 2  | ...
                    idataconncolor == 3)  %#ok<OR2,AND2>
    %  then take idataconncolor to be first part of icolor

  ndataconn = size(idataconn,1) ;
      %  number of data connections to draw

  if ndataconn <= size(colmap,1)     %  then have enough colors in icolor
    idataconncolor = colmap(1:ndataconn,:) ;

  else     %  then not enough colors, so write error message, and reset

        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Warning from Plot2dSM.m:                 !!!') ;
        disp('!!!   invalid idataconncolor, corresponding    !!!') ;
        disp('!!!   color map does not have                  !!!') ;
        disp('!!!   as many rows as idataconn.               !!!') ;
        disp('!!!   Resetting idataconncolor to ''k''        !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        idataconncolor = 'k' ;

  end 

end 



%  Set up for multiple markers (if needed)
%
if size(markerstr,1) > 1    %  then have already input full
                             %  character array, so use it
  mmarks = markerstr ;
  if indivplotflag == 0     %  then need to reset this 
                             %  and create a colmap
    indivplotflag = 1 ;
    if strcmp(dotcolor,'k') 
      vcolor = [0 0 0] ;
    elseif strcmp(dotcolor,'r') 
      vcolor = [1 0 0] ;
    elseif strcmp(dotcolor,'g') 
      vcolor = [0 1 0] ;
    elseif strcmp(dotcolor,'b') 
      vcolor = [0 0 1] ;
    elseif strcmp(dotcolor,'c') 
      vcolor = [0 1 1] ;
    elseif strcmp(dotcolor,'m') 
      vcolor = [1 0 1] ;
    elseif strcmp(dotcolor,'y') 
      vcolor = [1 1 0] ;
    elseif strcmp(dotcolor,'w') 
      vcolor = [1 1 1] ;
    end 
    colmap = ones(n,1) * vcolor ;
  end 
else    %  then are using default, or have entered single symbol
  if indivplotflag == 1     %  the need to create full char array
    mmarks = [] ;
    for i=1:n 
      mmarks = char(mmarks,markerstr) ;
    end 
  end 
end 


if ~isempty(legendcellstr) 
  nlegend = length(legendcellstr) ;
  if isempty(mlegendcolor) 
    mlegendcolor = vec2matSM(zeros(1,3),nlegend) ;
        %  all black when unspecified
  end 
end 


%  Set Axes
%
if isempty(vaxlim)     %  then use axisSM defaults
  vax = axisSM(data(1,:),data(2,:)) ;
elseif vaxlim == 1     %  then use symmetrized defaults
  vax = axisSM(data(1,:),data(2,:)) ;
  vaxx = max(abs(vax([1 2]))) ;
  vaxy = max(abs(vax([3 4]))) ;
  vax = [-vaxx vaxx -vaxy vaxy] ;
else 
  vax = vaxlim ;
end 


%  make main graphic
%
if iscreenwrite == 1 
  disp('  Making 2d Projection Plot') ;
end 

if ifigure > 0 
  figure(ifigure) ;
  clf ;
elseif ifigure < 0 
  figure(-ifigure) ;
end 


if indivplotflag == 0     %  then can plot everything with a single call

  if ibigdot == 1    %  plot deliberately large dots
    plot(data(1,:),data(2,:),[dotcolor 'o'],'MarkerSize',1,'LineWidth',2) ;
  else     %  use input marker
    plot(data(1,:),data(2,:),[dotcolor markerstr]) ;
  end 
                            % do scatterplot
    axis(vax) ;

    if ~isempty(legendcellstr)     %  then add legend
      hold on ;
        tx = vax(1) + 0.1 * (vax(2) - vax(1)) ;
        for ilegend = 1:nlegend 
          ty = vax(3) + ((nlegend - ilegend + 1) / ...
                               (nlegend + 1)) * (vax(4) - vax(3)) ;
          text(tx,ty,legendcellstr(ilegend),  ...
                    'Color',mlegendcolor(ilegend,:)) ;
        end 
      hold off ;
    end 


elseif indivplotflag == 1     %  then need to do individual calls to plot

  if ibigdot == 1    %  plot deliberately large dots
    plot(data(1,1),data(2,1),'o','Color',colmap(1,:), ...
              'MarkerSize',1,'LineWidth',2) ;
  else     %  use input marker
    plot(data(1,1),data(2,1),mmarks(1),'Color',colmap(1,:)) ;
  end 


  hold on ;
      for idat = 2:n 

        if ibigdot == 1    %  plot deliberately large dots
          plot(data(1,idat),data(2,idat),'o','Color',colmap(idat,:), ...
                                      'MarkerSize',1,'LineWidth',2) ;
        else     %  use input marker
          plot(data(1,idat),data(2,idat),mmarks(idat), ...
                                      'Color',colmap(idat,:)) ;
        end 

       
      end 
    hold off ;

    axis(vax) ;

    if ~isempty(legendcellstr)     %  then add legend
      hold on ;
        tx = vax(1) + 0.1 * (vax(2) - vax(1)) ;
        for ilegend = 1:nlegend 
          ty = vax(3) + ((nlegend - ilegend + 1) / ...
                               (nlegend + 1)) * (vax(4) - vax(3)) ;
          text(tx,ty,legendcellstr(ilegend),  ...
                    'Color',mlegendcolor(ilegend,:)) ;
        end 
      hold off ;
    end 


end     %  of indivplotflag if block



%  Add axes if needed
%
if iplotaxes == 1 
  hold on ;
    plot([vax(1); vax(2)],[0;0],'k-','LineWidth',0.5) ;
    plot([0;0],[vax(3); vax(4)],'k-','LineWidth',0.5) ;
  hold off ;
end 


%  Add title and labels
%
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



%  Add data connections (if needed)
%
if ~isempty(idataconn) 
  ndc = size(idataconn,1) ;
  hold on ;
  
  if size(idataconncolor,1) == 1     %  then need to expand
    if ischar(idataconncolor) 
      mdataconncolor = [] ;
      for idc = 1:ndc 
        mdataconncolor = [mdataconncolor; idataconncolor] ; %#ok<AGROW>
      end 
    else 
      mdataconncolor = ones(ndc,1) * idataconncolor ;
    end 
  else 
    mdataconncolor = idataconncolor ;
  end 

  if size(idataconntype,1) == 1      %  then need to expand
    mdataconntype = [] ;
    for idc = 1:ndc 
      mdataconntype = [mdataconntype; idataconntype] ; %#ok<AGROW>
    end 
  else 
    mdataconntype = idataconntype ;
  end 

  for idc = 1:ndc     %  loop through rows of idataconn
    plot([data(1,idataconn(idc,1));data(1,idataconn(idc,2))], ...
         [data(2,idataconn(idc,1));data(2,idataconn(idc,2))], ...
         mdataconntype(idc,:),'Color',mdataconncolor(idc,:)) ;
  end 

  hold off ;
end 


%  Save output (if needed)
%
if ~isempty(savestr)    %  then save graphics

  printSM(savestr,savetype) ;

end 



