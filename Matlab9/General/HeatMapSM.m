function HeatMapSM(mdata,paramstruct) 
% HeatMapSM, Heat Map Visualization of a data matrix
%     Displays entries of a data matrix, coding values as colors (maybe gray)
%     This view of a data matrix is common in bioinformatics
%     Care is needed about choice of color ranges
%     Generally handled by using quantiles at upper and lower end
%     Can also choose to highlight 0 value
%     Also can add color histogram, to show distribution of colors
%
%   Steve Marron's matlab function
% Inputs:
%         mdata - rectangular matrix of input data 
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
%    icolor            index for color scheme:
%                      0 - Gray level colors (default), 
%                              starting with black at the alpha-th quantile
%                              through white at the (1 - alpha)-th quantile
%                      1 - Gray level colors, with white at 0, 
%                              useful for nonnegative entries, 
%                              when value 0 is important to highlight  
%                      2 - Shades of Blue, White, Red, best for + and - values,
%                              especially when 0 is important, 
%                              which is coded as white
%                      3 - Rainbow color scheme
%                      4 - Heat Color scheme
%                      ncolorx3 color matrix 
%                              (size of this overrides any input of ncolor)
%
%    alpha             Proportion of data in:
%                           first and last bins (icolor = 0, 3, 4 or matrix)
%                           last bin  (icolor = 1)
%                           larger of first and last bin (icolor = 2)
%                              (default = 0.05)
%                      For manually set range (not based on quantiles 
%                            as above), make this a 2 x 1 vector:
%                                  [lovalue; hivalue]
%
%    ncolor            Number of color bins to use, (default = 64)
%
%    icolordist        Indicator for making histogram of values
%                          with bars using map colors,
%                          shown in an additional figure window
%                      0 - Do not make color distribution plot
%                      1 - (default) Add new figure with color distribution plot
%                      int > 1 - Put color distribution plot in figure(int)
%
%    cdonlyflag        0 - (default) Create new figure as specified by
%                                       icolordist
%                      1 - only make color distribution plot in current figure
%                              (makes no heat map and ignores icolordist)
%
%    titlestr          string for plot title
%                      '' for no title (default)
%
%    xlabelstr         string for label of x (horizontal) axis
%                      '' for no label (default)
%
%    ylabelstr         string for label of y (vertical) axis
%                      '' for no label (default)
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                       Will add file suffix determined by savetype
%                         unspecified:  results only appear on screen
%                      When making color distribution plot, will add
%                          "ColorDist" to file name
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
%     Graphics in current figure.
%       and new figure, or specified figure, for color distribution plot 
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    cquantSM.m
%    RainbowColorsQY.m
%    HeatColorsSM.m

%    Copyright (c) J. S. Marron 2019, 2023, 2025



%  First set all parameters to defaults
%
icolor = 0 ;
alpha = 0.05 ;
ncolor = 64 ;
icolordist = 1 ;
cdonlyflag = 0 ;
titlestr = '' ;
xlabelstr = '' ;
ylabelstr = '' ;
savestr = [] ;
savetype = 1 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1   %  then paramstruct is an argument

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ; 
  end

  if isfield(paramstruct,'alpha')    %  then change to input value
   alpha = paramstruct.alpha ; 
  end

  if isfield(paramstruct,'ncolor')    %  then change to input value
    ncolor = paramstruct.ncolor ; 
  end

  if isfield(paramstruct,'icolordist')    %  then change to input value
    icolordist = paramstruct.icolordist ; 
  end

  if isfield(paramstruct,'cdonlyflag')    %  then change to input value
    cdonlyflag = paramstruct.cdonlyflag ; 
  end

  if isfield(paramstruct,'titlestr')    %  then change to input value
    titlestr = paramstruct.titlestr ; 
    if ~(ischar(titlestr) || isempty(titlestr))    %  then invalid input, 
                                                   %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from HeatMapSM.m:    !!!') ;
      disp('!!!   Invalid titlestr,            !!!') ;
      disp('!!!   using default of no title    !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      titlestr = [] ;
    end
  end

  if isfield(paramstruct,'xlabelstr')    %  then change to input value
    xlabelstr = paramstruct.xlabelstr ; 
    if ~(ischar(xlabelstr) || isempty(xlabelstr))    %  then invalid input, 
                                                     %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from HeatMapSM.m:    !!!') ;
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
      disp('!!!   Warning from HeatMapSM.m:    !!!') ;
      disp('!!!   Invalid ylabelstr,           !!!') ;
      disp('!!!   using default of no label    !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      ylabelstr = [] ;
    end
  end

  if isfield(paramstruct,'savestr')     %  then use input value
    savestr = paramstruct.savestr ; 
    if ~(ischar(savestr) || isempty(savestr))    %  then invalid input, 
                                                 %  so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from HeatMapSM.m:    !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'savetype')     %  then use input value
    savetype = paramstruct.savetype ; 
  end 


end    %  of resetting of input parameters



%  check and set preliminaries
%
nrow = size(mdata,1) ;
ncolumn = size(mdata,2) ;
vdata = reshape(mdata,nrow*ncolumn,1) ;
    %  vector version of data matrix
if length(alpha) == 1    %  scalar entry, use quantiles
  vq = cquantSM(vdata,[alpha (1-alpha)]) ;
  qlo = vq(1) ;
      %  lower data quantile
  qhi = vq(2) ;
      %  upper data quantile
elseif  (size(alpha,1) == 2)  &  (size(alpha,2) == 1)
                                     %  2 x 1 vector, use input values
  qlo = alpha(1) ;
  qhi = alpha(2) ;
else
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from HeatMapSM.m:    !!!') ;
  disp('!!!   Invalid alpha,               !!!') ;
  disp('!!!   using default quantile       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vq = cquantSM(vdata,[0.05 0.95]) ;
  qlo = vq(1) ;
      %  lower data quantile
  qhi = vq(2) ;
      %  upper data quantile
end ;


if max(size(icolor)) == 1    %  have scalar icolor 

  if (icolor == 0) || (icolor == 1)    %  Use gray levels

    if icolor == 0
      lovalue = qlo ;
      hivalue = qhi ;
    elseif icolor == 1
      lovalue = 0 ;
      hivalue = qhi ;
    end

    %  Make gray level colormap
    %
    cmap = linspace(0,1,ncolor)' * ones(1,3) ;

  elseif icolor == 2    %  Use Red, White, Blue scheme, centered at 0

    qmax = max(abs(qlo),abs(qhi)) ;
    lovalue = -qmax ;
    hivalue = qmax ;

    %  Make red, white, blue colormap
    % 
    if round(ncolor / 2) == ncolor / 2    %  if ncolor is even 
      cmap = [ones(ncolor / 2,1) (linspace(0,1,ncolor / 2)' * ones(1,2))] ;
      cmap = [cmap; [(linspace(1,0,ncolor / 2)' * ones(1,2)) ones(ncolor / 2,1)]] ;
    else    %  ncolor is odd
      cmap = [ones((ncolor + 1) / 2,1) ...
                      (linspace(0,1,(ncolor + 1) / 2)' * ones(1,2))] ;
      cmap = [cmap(1:((ncolor - 1) / 2),:); ...
                       [(linspace(1,0,(ncolor + 1) / 2)' * ones(1,2)) ...
                            ones((ncolor + 1) / 2,1)]] ;
    end

  elseif icolor == 3    %  Use Rainbow Colors, data driven range

    lovalue = qlo ;
    hivalue = qhi ;

    %  Make rainbow colormap
    %
    cmap = RainbowColorsQY(ncolor) ;

  elseif icolor == 4    %  Use Heat Colors, data driven range

    lovalue = qlo ;
    hivalue = qhi ;

    %  Make heat colormap
    %
    cmap = HeatColorsSM(ncolor) ;

  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from HeatMapSM.m:   !!!') ;
    disp('!!!   Invalid icolor,             !!!') ;
    disp('!!!   using default icolor == 0   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    lovalue = qlo ;
    hivalue = qhi ;
    cmap = linspace(0,1,ncolor)' * ones(1,3) ;

  end

else    %  Have nonscalar icolor 

  if size(icolor,2) == 3    %  have valid input color map

    ncolor = size(icolor,1) ;
    lovalue = qlo ;
    hivalue = qhi ;
    cmap = icolor ;

  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from HeatMapSM.m:   !!!') ;
    disp('!!!   Invalid icolor,             !!!') ;
    disp('!!!   using default icolor == 0   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    lovalue = qlo ;
    hivalue = qhi ;
    cmap = linspace(0,1,ncolor)' * ones(1,3) ;

  end

end


mdatasc = 0 + ncolor * ((mdata - lovalue) / (hivalue - lovalue)) ;
    %  Color scaled version of mdata,
    %  where [lovalue, hivalue] maps to [0, ncolor]   


%  Construct Main Image Heat Map
%
if ~(cdonlyflag == 1)
  colormap(cmap) ;
  image(mdatasc) ;
  title(titlestr) ;
  xlabel(xlabelstr) ;
  ylabel(ylabelstr) ;
  if ~isempty(savestr)   %  then create output file
    printSM(savestr,savetype) ;
  end
end


if icolordist ~= 0    %  Consider adding a histogram of color distribution

  if (icolordist >= 1) && (icolordist == round(icolordist))
                                %  Good choice of figure

    if ~(cdonlyflag == 1)
      if icolordist == 1    %  Add a new figure window with color distribution
        figure ;
      else    %  Put graphic into this specified figure window
        figure(icolordist) ;
        clf ;
      end
    end

    %  Make histogram of color distribution
    %
    del = (hivalue - lovalue) / (ncolor - 2) ;
        %  width of each bin
    vedges = linspace(lovalue,hivalue,ncolor - 1) ;
        %  vector of edges betwee each bin
    vcts = histcounts(vdata,[-inf vedges inf]) ;
        %  vector of bin counts
    vedgesp = [(lovalue - del) vedges (hivalue + del)] ;
        %  vector of edges for plotting
    axis([vedgesp(1) vedgesp(ncolor + 1) 0 (1.05 * max(vcts))]) ;
    hold on ;
      for ic = 1:ncolor
        patch([vedgesp(ic); vedgesp(ic); vedgesp(ic + 1); ...
                                   vedgesp(ic + 1); vedgesp(ic)], ...
              [0; vcts(ic); vcts(ic); 0; 0],cmap(ic,:)) ;
      end
    hold off ;
    title('Heatmap Pixel Color Distribution') ;
    xlabel('Color Values') ;
    ylabel('Counts') ;

    if ~isempty(savestr)    %  then print to file
      printSM([savestr 'ColorDist'],savetype) ;    
    end

  else    %  Bad parameter input, indicate error

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from HeatMapSM.m:          !!!') ;
    disp('!!!   Invalid icolordist,                !!!') ;
    disp('!!!   should be a nonnegative integer    !!!') ;
    disp('!!!   Not showing histogram of colors    !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  end

end


