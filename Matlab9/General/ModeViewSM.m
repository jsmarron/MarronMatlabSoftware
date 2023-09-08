function ModeViewSM(mdata,paramstruct) 
% ModeViewSM, Modes of variation Views 
%     Several ways of visualizing modes of variation of a data metrix
%     Including matrix heat maps, plus both rows and columns as data objects
%     Organized into pages in various ways 
%     This works something like a combination of:
%         HeatMapSM
%         curvdatSM
%         scatplotSM
%     with exception that both column and row object centering 
%     are first considered (and displayed) as modes of variation
%     and then SVD is done on the overall centered data to get the
%     remaining modes of variation
%
%   Steve Marron's matlab function
% Inputs:
%         mdata - d x n rectangular matrix of input data 
%
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
%                          these are optional, unspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    iout              Index for output organization:
%                      1 - (default) One page (figure) for each mode
%                                         of variation
%                      4 - Column object scores scatterplot (as in scatplotSM)
%              Note: these are not yet supported:
%                      2 - Each row has 3 modes (heat map, columns, rows)
%                      3 - Similar to curvdatSM, but with row mean mode
%                      5 - Row object scores scatterplot 
%
%    nmode             number of modes of variation to show, beyond:
%                          raw data
%                          column object mean mode
%                          row object mean mode
%                          default = 3 ;
%
%    icolorhm          index for heat map color scheme:
%                      0 - Gray level colors, 
%                              starting with black at the alpha-th quantile
%                              through white at the (1 - alpha)-th quantile
%                      1 - Gray level colors, with white at 0, 
%                              useful for nonnegative entries, 
%                              when value 0 is important to highlight  
%                      2 - Shades of Blue, White, Red, best for + and - values,
%                              especially when 0 is important, 
%                              which is coded as white
%                      3 - (default) Gray level colors as in 0, for first 3 pages,
%                              plus blue, white, red as in 2 for rest
%                      4 - Gray level colors as in 1, for first 3 pages,
%                              plus blue, white, red as in 2 for rest
%                      ncolor x 3 color matrix 
%                              (size of this overrides any input  of ncolor)
%
%    icolorcols        index for columns as data object curves plot
%                      0 - Black
%                      1 - color version (Matlab 7 color default)
%                      2 - (default) Rainbow color scheme
%                      n x 3 color matrix 
%
%    markerstrcols     markers for column objects,  only has effect for iout = 3 or 4
%                      Can be either a single string with symbol to use for marker,
%                          e.g. 'o' (default), '.', '+', 'x'
%                          (see "help plot" for a full list)
%                      Or a character array (n x 1), of these symbols,
%                          One for each data vector, created using:  strvcat
%
%    icolorrows        index for columns as data object curves plot
%                      0 - Black
%                      1 - (default) Heat Color scheme
%                      d x 3 color matrix 
%
%    markerstrrows     markers for row objects,  only has effect for iout = 5
%                      Can be either a single string with symbol to use for marker,
%                          e.g. '+' (default), '.', 'o', 'x'
%                          (see "help plot" for a full list)
%                      Or a character array (n x 1), of these symbols,
%                          One for each data vector, created using:  strvcat
%
%    alpha             Proportion of data in:
%                           first and last bins (icolor = 0, 3, 4 or matrix)
%                           last bin  (icolor = 1)
%                           larger of first and last bin (icolor = 2)
%                              (default = 0.05)
%
%    ncolor            Number of color bins to use, (default = 64)
%
%    icolordist        Indicator for making histogram of values
%                          with bars using heat map colors,
%                          shown in lower corner of page
%                      0 - Do not make color distribution plot
%                      1 - (default) Add new figure with color distribution plot
%
%    titlestr          string for plot title (for 1st heatmap each page)
%                      '' for only default titles (default)
%                      0 for no titles at all
%
%    xlabelstr         string for label of x (horizontal) axis of heatmap,
%                      as well as horizontal axis of row curves view
%                      '' for no label (default)
%                      Note:  Appropriate axes are labelled 'Color Values'
%                                 to aid understanding of corresponding axes
%
%    ylabelstr         string for label of y (vertical) axis of heatmap,
%                      as well as vertical axis of column curves view
%                      '' for no label (default)
%                      Note:  Appropriate axes are labelled 'Color Values'
%                                 to aid understanding of corresponding axes
%
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                       Will add file suffix determined by savetype
%                         unspecified:  results only appear on screen
%                      Will add appropriate suffixes for multiple pages
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
%
% Outputs:
%     Graphics in new figures as:
%         Figure 1:  Raw data
%         Figure 2:  Column Object Mean mode of variation
%         Figure 3:  Row Trait Mean mode of variation
%         Figure 4:  Residuals from double centering
%         Figure 5+:  SVD modes of variation
% 
%     When savestr exists,
%        Postscript file saved in 'savestr'.ps 
%                 (and 'savestr'ColorDist.ps, when specified)
%                 (B & W postscript for icolor = 0 or 1)
%                 (color postscript otherwise)
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    cquantSM.m
%    RainbowColorsQY.m
%    HeatColorsSM.m

%    Copyright (c) J. S. Marron 2019, 2020, 2023


%  First set all parameters to defaults
%
iout = 1 ;
nmode = 3 ;
icolorhm = 3 ;
icolorcols = 2 ;
markerstrcols = 'o' ;
icolorrows = 1 ;
alpha = 0.05 ;
ncolor = 64 ;
icolordist = 1 ;
titlestr = '' ;
xlabelstr = '' ;
ylabelstr = '' ;
savestr = [] ;
savetype = 1 ;

%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1    %  then paramstruct is an argument

  if isfield(paramstruct,'iout')    %  then change to input value
    iout = paramstruct.iout ; 
  end

  if isfield(paramstruct,'nmode')    %  then change to input value
    nmode = paramstruct.nmode ; 
  end

  if isfield(paramstruct,'icolorhm')    %  then change to input value
    icolorhm = paramstruct.icolorhm ; 
  end

  if isfield(paramstruct,'icolorcols')    %  then change to input value
    icolorcols = paramstruct.icolorcols ; 
  end

  if isfield(paramstruct,'markerstrcols')    %  then change to input value
    markerstrcols = paramstruct.markerstrcols ; 
  end

  if isfield(paramstruct,'icolorrows')    %  then change to input value
    icolorrows = paramstruct.icolorrows ; 
  end

  if isfield(paramstruct,'markerstrrows')    %  then change to input value
    markerstrrows = paramstruct.markerstrrows ; %#ok<NASGU>
  end

  if isfield(paramstruct,'alpha')    %  then change to input value
   alpha  = paramstruct.alpha ; 
  end

  if isfield(paramstruct,'ncolor')    %  then change to input value
    ncolor = paramstruct.ncolor ; 
  end

  if isfield(paramstruct,'icolordist')    %  then change to input value
    icolordist = paramstruct.icolordist ; 
  end

  if isfield(paramstruct,'titlestr')    %  then change to input value
    titlestr = paramstruct.titlestr ; 
    if (~ischar(titlestr) && titlestr == 0)
      titleflag = 0 ;
    elseif ~(ischar(titlestr) || isempty(titlestr))     %  then invalid input, 
                                                        %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from ModeViewSM.m:   !!!') ;
      disp('!!!   Invalid titlestr,            !!!') ;
      disp('!!!   using default titles         !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      titlestr = [] ;
      titleflag = 1 ;
    else
      titleflag = 1 ;
    end
  else
    titleflag = 1 ;
  end

  if isfield(paramstruct,'xlabelstr')    %  then change to input value
    xlabelstr = paramstruct.xlabelstr ; 
    if ~(ischar(xlabelstr) || isempty(xlabelstr))    %  then invalid input, 
                                                      %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from ModeViewSM.m:   !!!') ;
      disp('!!!   Invalid xlabelstr,           !!!') ;
      disp('!!!   using default of no label    !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      xlabelstr = [] ;
    end
  end

  if isfield(paramstruct,'ylabelstr')    %  then change to input value
    ylabelstr = paramstruct.ylabelstr ; 
    if ~(ischar(ylabelstr) || isempty(ylabelstr))    %  then invalid input, 
                                                     %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from ModeViewSM.m:   !!!') ;
      disp('!!!   Invalid ylabelstr,           !!!') ;
      disp('!!!   using default of no label    !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      ylabelstr = [] ;
    end
  end

  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstruct.savestr ; 
    if ~(ischar(savestr) || isempty(savestr))    %  then invalid input, 
                                                  %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from ModeViewSM.m:   !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'savetype')     %  then use input value
    savetype = paramstruct.savetype ; 
  end 

else
  titleflag = 1 ;
end    %  of resetting of input parameters
titleflag = logical(titleflag) ;


%  check and set preliminaries
%
d = size(mdata,1) ;
n = size(mdata,2) ;
hgrid = 1:n ;
vgrid = (1:d)' ;

if icolorhm == 0
  icolorhm1 = 0 ;
      %  icolorhm for first 3 pages
  icolorhm2 = 0 ;
      %  icolorhm for rest
elseif icolorhm == 1
  icolorhm1 = 1 ;
  icolorhm2 = 1 ;
elseif icolorhm == 2
  icolorhm1 = 2 ;
  icolorhm2 = 2 ;
elseif icolorhm == 3
  icolorhm1 = 0 ;
      %  icolorhm for first 3 pages
  icolorhm2 = 2 ;
      %  icolorhm for rest
elseif icolorhm == 4
  icolorhm1 = 1 ;
  icolorhm2 = 2 ;
else
  icolorhm1 = icolorhm ;
  icolorhm2 = icolorhm ;
end

if icolorcols == 0
  mcolorcols = ones(n,1) * [0 0 0] ;
elseif icolorcols == 2
  mcolorcols = RainbowColorsQY(n) ;
else
  if ~(size(icolorcols,2) == 3)    %  have invalid input color map
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from ModeViewSM.m:            !!!') ;
    disp('!!!   Invalid icolor,                       !!!') ;
    disp('!!!   resetting to default Rainbow Colors   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    mcolorcols = RainbowColorsQY(n) ;
  else
    mcolorcols = icolorcols ;
  end
end

if icolorrows == 0
  mcolorrows = ones(d,1) * [0 0 0] ;
elseif icolorrows == 1
  mcolorrows = flipud(HeatColorsSM(round(1.1 * d))) ;
  mcolorrows = mcolorrows(1:d,:) ;
      %  keep just first 90%, to avoid white curves 
      %      that don't show up on white background
else
  if ~(size(icolorrows,2) == 3)    %  have invalid input color map
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from ModeViewSM.m:            !!!') ;
    disp('!!!   Invalid icolor,                       !!!') ;
    disp('!!!   resetting to default Rainbow Colors   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    mcolorrows = HeatColorsSM(d) ;
  else
    mcolorrows = icolorrows ;
  end
end


%  Do common calculations
%
mdatacom = mean(mdata,2) * ones(1,n) ;
vromscores = mean(mdata,1) ;
mdatarom = ones(d,1) * vromscores ;
mdataoac = mdata - mdatacom - mdatarom + mean(mean(mdata)) ;
    %  Overall Centered Version of Data
[U,S,V] = svds(mdataoac,nmode) ;
mscores = [vromscores; (S * V')] ;
    %  Scores for plotting when iout = 4


if iout == 1    %  One page (figure) for each mode of variation

  %  Make raw data plot page (figure)
  %
  figure(1) ;
  clf ;
  subplot(2,2,1) ;    %  Heat map in upper left
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'icolordist',0, ...
                         'titlestr',[titlestr ' Input Data'], ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr',ylabelstr) ;
    HeatMapSM(mdata,paramstruct) ;
  subplot(2,2,2) ;    %  Cols as data objects in upper right
    plot(mdata(:,1),vgrid,'-','Color',mcolorcols(1,:)) ;
    hold on ;
      for ic = 1:n
        plot(mdata(:,ic),vgrid,'-','Color',mcolorcols(ic,:)) ;
      end
      vaxmdata = axisSM(mdata) ;
      axis([vaxmdata 1 d]) ;
      if titleflag
        title([titlestr ' Column Curves']) ;
      end
      xlabel('Color Values') ;
      ylabel(ylabelstr) ;
    hold off ;
    set(gca,'Ydir','reverse')
  subplot(2,2,3) ;    %  Rows as data objects in lower left
    plot(hgrid',mdata(1,:)','-','Color',mcolorrows(1,:)) ;
    hold on ;
      for ir = 1:d
        plot(hgrid',mdata(ir,:)','-','Color',mcolorrows(ir,:)) ;
      end
      axis([1 n vaxmdata]) ;
      if titleflag
        title([titlestr ' Row Curves']) ;
      end
      xlabel(xlabelstr) ;
      ylabel('Color Values') ;
    hold off ;
  if ~(icolordist == 0)
    subplot(2,2,4) ;    %  Show heatmap color distribution in lower right
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'cdonlyflag',1) ;
    HeatMapSM(mdata,paramstruct) ;
    if ~titleflag
      set(get(gca,'Title'),'String','')
    end
  end
  set(gcf,'renderer','zbuffer') ;
      %  This cures the tendency for the image to turn all black
  if ~isempty(savestr)   %  then create postscript file
    printSM([savestr 'Input'],savetype) ;
  end

  %  Make column object mean mode page (figure)
  %
  figure(2) ;
  clf ;
  subplot(2,2,1) ;    %  Heat map in upper left
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'icolordist',0, ...
                         'titlestr',[titlestr ' Column Object Mean'], ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr',ylabelstr) ;
    HeatMapSM(mdatacom,paramstruct) ;
  subplot(2,2,2) ;    %  Cols as data objects in upper right
    plot(mdatacom(:,1),vgrid,'-','Color',mcolorcols(1,:)) ;
    hold on ;
      for ic = 1:n
        plot(mdatacom(:,ic),vgrid,'-','Color',mcolorcols(ic,:)) ;
      end
      vaxmdatacom = axisSM(mdatacom) ;
      axis([vaxmdatacom 1 d]) ;
      if titleflag
        title([titlestr ' Column Curves']) ;
      end
      xlabel('Color Values') ;
      ylabel(ylabelstr) ;
    hold off ;
    set(gca,'Ydir','reverse')
  subplot(2,2,3) ;    %  Rows as data objects in lower left
    plot(hgrid',mdatacom(1,:)','-','Color',mcolorrows(1,:)) ;
    hold on ;
      for ir = 1:d
        plot(hgrid',mdatacom(ir,:)','-','Color',mcolorrows(ir,:)) ;
      end
      axis([1 n vaxmdatacom]) ;
      if titleflag
        title([titlestr ' Row Curves']) ;
      end

      xlabel(xlabelstr) ;
      ylabel('Color Values') ;
    hold off ;
  if ~(icolordist == 0)
    subplot(2,2,4) ;    %  Show heatmap color distribution in lower right
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'cdonlyflag',1) ;
    HeatMapSM(mdatacom,paramstruct) ;
    if ~titleflag
      set(get(gca,'Title'),'String','')
    end
  end
  set(gcf,'renderer','zbuffer') ;
      %  This cures the tendency for the image to turn all black
  if ~isempty(savestr)   %  then create postscript file
    printSM([savestr 'ColObjMean'],savetype) ;
  end

  %  Make row object mean mode page (figure)
  %
  figure(3) ;
  clf ;
  subplot(2,2,1) ;    %  Heat map in upper left
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'icolordist',0, ...
                         'titlestr',[titlestr ' Row Object Mean'], ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr',ylabelstr) ;
    HeatMapSM(mdatarom,paramstruct) ;
  subplot(2,2,2) ;    %  Cols as data objects in upper right
    plot(mdatarom(:,1),vgrid,'-','Color',mcolorcols(1,:)) ;
    hold on ;
      for ic = 1:n
        plot(mdatarom(:,ic),vgrid,'-','Color',mcolorcols(ic,:)) ;
      end
      vaxmdatarom = axisSM(mdatarom) ;
      axis([vaxmdatarom 1 d]) ;
      if titleflag
        title([titlestr ' Column Curves']) ;
      end
      xlabel('Color Values') ;
      ylabel(ylabelstr) ;
    hold off ;
    set(gca,'Ydir','reverse')
  subplot(2,2,3) ;    %  Rows as data objects in lower left
    plot(hgrid',mdatarom(1,:)','-','Color',mcolorrows(1,:)) ;
    hold on ;
      for ir = 1:d
        plot(hgrid',mdatarom(ir,:)','-','Color',mcolorrows(ir,:)) ;
      end
      axis([1 n vaxmdatarom]) ;
      if titleflag
        title([titlestr ' Row Curves']) ;
      end
      xlabel(xlabelstr) ;
      ylabel('Color Values') ;
    hold off ;
  if ~(icolordist == 0)
    subplot(2,2,4) ;    %  Show heatmap color distribution in lower right
    paramstruct = struct('icolor',icolorhm1, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'cdonlyflag',1) ;
    HeatMapSM(mdatarom,paramstruct) ;
    if ~titleflag
      set(get(gca,'Title'),'String','')
    end
  end
  set(gcf,'renderer','zbuffer') ;
      %  This cures the tendency for the image to turn all black
  if ~isempty(savestr)    %  then create postscript file
    printSM([savestr 'RowObjMean'],savetype) ;
  end

  %  Make overall mean centered residuals page (figure)
  %
  figure(4) ;
  clf ;
  subplot(2,2,1) ;    %  Heat map in upper left
    paramstruct = struct('icolor',icolorhm2, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'icolordist',0, ...
                         'titlestr',[titlestr ' Overall Mean Residuals'], ...
                         'xlabelstr',xlabelstr, ...
                         'ylabelstr',ylabelstr) ;
    HeatMapSM(mdataoac,paramstruct) ;
  subplot(2,2,2) ;    %  Cols as data objects in upper right
    plot(mdataoac(:,1),vgrid,'-','Color',mcolorcols(1,:)) ;
    hold on ;
      for ic = 1:n
        plot(mdataoac(:,ic),vgrid,'-','Color',mcolorcols(ic,:)) ;
      end
      vaxmdataoac = axisSM(mdataoac) ;
      axis([vaxmdataoac 1 d]) ;
      if titleflag
        title([titlestr ' Column Curves']) ;
      end
      xlabel('Color Values') ;
      ylabel(ylabelstr) ;
    hold off ;
    set(gca,'Ydir','reverse')
  subplot(2,2,3) ;    %  Rows as data objects in lower left
    plot(hgrid',mdataoac(1,:)','-','Color',mcolorrows(1,:)) ;
    hold on ;
      for ir = 1:d
        plot(hgrid',mdataoac(ir,:)','-','Color',mcolorrows(ir,:)) ;
      end
      axis([1 n vaxmdataoac]) ;
      if titleflag
        title([titlestr ' Row Curves']) ;
      end
      xlabel(xlabelstr) ;
      ylabel('Color Values') ;
    hold off ;
  if ~(icolordist == 0)
    subplot(2,2,4) ;    %  Show heatmap color distribution in lower right
    paramstruct = struct('icolor',icolorhm2, ...
                         'alpha',alpha, ...
                         'ncolor',ncolor, ...
                         'cdonlyflag',1) ;
    HeatMapSM(mdataoac,paramstruct) ;
    if ~titleflag
      set(get(gca,'Title'),'String','')
    end
  end
  set(gcf,'renderer','zbuffer') ;
      %  This cures the tendency for the image to turn all black
  if ~isempty(savestr)    %  then create postscript file
    printSM([savestr 'OAMeanResid'],savetype) ;
  end

  %  Make SVD modes pages (figures)
  %
  for imode = 1:nmode
    figure(4 + imode) ;
    clf ;
    mdatamode = U(:,imode) * S(imode,imode) * V(:,imode)' ;
        %  Rank 1 matrix version of this mode
    subplot(2,2,1) ;    %  Heat map in upper left
      paramstruct = struct('icolor',icolorhm2, ...
                           'alpha',alpha, ...
                           'ncolor',ncolor, ...
                           'icolordist',0, ...
                           'titlestr',[titlestr ' Mode ' num2str(imode)], ...
                           'xlabelstr',xlabelstr, ...
                           'ylabelstr',ylabelstr) ;
      HeatMapSM(mdatamode,paramstruct) ;
    subplot(2,2,2) ;    %  Cols as data objects in upper right
      plot(mdatamode(:,1),vgrid,'-','Color',mcolorcols(1,:)) ;
      hold on ;
        for ic = 1:n
          plot(mdatamode(:,ic),vgrid,'-','Color',mcolorcols(ic,:)) ;
        end
        vaxmdatamode = axisSM(mdatamode) ;
        axis([vaxmdatamode 1 d]) ;
        if titleflag
          title([titlestr ' Column Curves']) ;
        end
        xlabel('Color Values') ;
        ylabel(ylabelstr) ;
      hold off ;
      set(gca,'Ydir','reverse')
    subplot(2,2,3) ;    %  Rows as data objects in lower left
      plot(hgrid',mdatamode(1,:)','-','Color',mcolorrows(1,:)) ;
      hold on ;
        for ir = 1:d
          plot(hgrid',mdatamode(ir,:)','-','Color',mcolorrows(ir,:)) ;
        end
        axis([1 n vaxmdatamode]) ;
        if titleflag
          title([titlestr ' Row Curves']) ;
        end
        xlabel(xlabelstr) ;
        ylabel('Color Values') ;
      hold off ;
    if ~(icolordist == 0)
      subplot(2,2,4) ;    %  Show heatmap color distribution in lower right
      paramstruct = struct('icolor',icolorhm2, ...
                           'alpha',alpha, ...
                           'ncolor',ncolor, ...
                           'cdonlyflag',1) ;
      HeatMapSM(mdatamode,paramstruct) ;
      if ~titleflag
        set(get(gca,'Title'),'String','')
      end
    end
    set(gcf,'renderer','zbuffer') ;
        %  This cures the tendency for the image to turn all black
    if ~isempty(savestr)   %  then create postscript file
      printSM([savestr 'Mode' num2str(imode)],savetype) ;
    end

  end


elseif iout == 2    %  Each row has 3 modes (heat map, columns, rows)



elseif iout == 3     %  Similar to curvdatSM, but with row mean mode



elseif iout == 4    %  Column object scores scatterplot (as in scatplotSM)

  labelcellstr = {{'Flat Dir''n Scores'; ...
                   'Mode 1 Scores'; ...
                   'Mode 2 Scores'; ...
                   'Mode 3 Scores'; ...
                   'Mode 4 Scores'}} ;
  paramstruct = struct('icolor',mcolorcols, ...
                       'markerstr',markerstrcols, ...
                       'titlecellstr',{{titlestr}}, ...
                       'labelcellstr',labelcellstr, ...
                       'savestr',savestr) ;
  scatplotSM(mscores,eye(nmode + 1),paramstruct) ;


elseif iout == 5    %  Row object scores scatterplot



end



