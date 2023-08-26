function MargDistPlotSM(mdata,paramstruct) 
% MargDistPlotSM, Marginal Distribution Plot
%     Given an input data matrix, studies 1-d marginal distributions
%     Focus is on a particular statistic (mean, variance, skewness, ...)
%     Upper left plot shows sorted values of statistic,
%     and highlights some interesting variables 
%     (e.g. quantiles of the summary statistic distribution)
%     Other plots study individual distributions of the highlighted variables,
%     using density estimates, and data overlays.
%     Useful for checking marginal distributions in various ways
%     
%   Steve Marron's matlab function
% Inputs:
%         mdata - d x n matrix of data, 
%                    the n columns each are a d-dim data vector,
%                    the d row vectors each contain marginal data
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
%    istat             index of the 1-d summary statistics to use:
%                      1 - Sample mean
%                      2 - Sample Standard Deviation (default)
%                      3 - Skewness
%                      4 - Kurtosis
%                      5 - Median
%                      6 - MAD
%                      7 - IQR
%                      8 - Min
%                      9 - Max
%                      10 - Range (= max - min)
%                      11 - Number of unique values (using Matlab's "unique")
%                      12 - Number of most frequent value
%                      13 - Number of 0's
%                      14 - smallest non-zero spacing
%                      15 - Continuity Index (proportion of non-zero 
%                                    pairwise distances)
%                      16 - Entropy (discrete version)
%                      17 - Bowley Skewness (robust version, based on 
%                                    quartiles and median)
%                      18 - 2nd L-statistic ratio (robust version of variance)
%                      19 - 3rd L-statistic ratio (robust version of skewness)
%                      20 - 4th L-statistic ratio (robust version of kurtosis)
%
%    varnamecellstr   vertical cell array of variable names
%                     which appear in xlabels of individual distribution plots
%                       number of variable names must be d
%                       (or will reset to default)
%                     Create this using cellstr, or {{string1; string2; ...}}
%                         Note:  These strange double brackets seems to be needed
%                                for correct pass to subroutine
%                                It may change in later versions of Matlab
%                     Some useful example lines are:
%                              varnamecellstr = {} ;
%                              for i = 1:d ;
%                                varnamecellstr = cat(1,varnamecellstr,{['var ' num2str(i)]}) ;
%                              end ;
%                              varnamecellstr = {varnamecellstr} ;
%                     CAUTION:  If are updating this field, using a command like:
%                         paramstruct = setfield(paramstruct,'varnamecellstr',...
%                     Then should only use single braces in the definition of
%                     varnamecellstr, i. e. {string1; string2; ...}
%                     Leave empty (default) for {'Variable 1'; 'Variable 2'; ...}
%
%    nplot             number of plots to make,
%                      when nplot is a perfect square, 
%                        make sqrt(nplot) x sqrt(nplot) matrix of plots
%                        with summary plot in upper left
%                      otherwise make nplot individual plots 
%                        (each in a different figure window)
%                        with summary plot first
%                      when nplot > d + 1, will just show d + 1
%                      default = 16     (4 x 4 matrix)
%
%    viplot            vector of plot indices (among sorted summary statistics),
%                      should have length = 0 (i.e. empty)
%                               or length = nplot - 1
%                        entries should be unique, 
%                        and integers in the range 1,...,d
%                      default is empty (length 0)      
%                        for first, last and equally spaced in between
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default)  color version 
%                               summary statistic plot - blue
%                               overlay bars - black
%                               density estimates - blue
%                               data overlay - green
%                     2  time series version 
%                              (ordered spectrum of colors for each data point)
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
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%                              Only has effect when markerstr = '.' 
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
%    idatovlay        0  Do not overlay data on kde plots
%                     1  (default) overlay data using heights based on data ordering
%                              Note:  To see "c.d.f. style" increasing line, 
%                                     should also sort the data
%                     2  overlay data using random heights
%                     another integer > 0,  overlay data, using random heights,
%                                           with this number as the seed (so can 
%                                           better match data points across plots),
%                                           (should be an integer with <= 8 digits)
%
%    ndatovlay     number of data points overlayed (only has effect for idatovlay > 0)
%                       1  - overlay up to 1000 points 
%                                           (random choice, when more)
%                       2  - (default) overlay full data set
%                       n > 2   -  overlay n random points
%                           for n > 2 (or 1 when n > 1000), it is
%                           recommended to set a seed using idatovlay, 
%                           so get same subset in each plot
%
%    datovlaymax      maximum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.6
%
%    datovlaymin      minimum (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.5
%
%    textht           fraction (on [0,1] scale, with 0 at bottom, 1 at top of plot)
%                     of vertical range, for writing value of summary statistic
%                     Default = 0.8
%
%    titlecellstr     row cell array for making subplot titles
%                     Construct this by e.g.   {{'title1' 'title2'}}
%                     default is an empty cell array, {} for no titles,
%                     which will put 'Summary Statistics' on the first plot
%                     Anything else will overwrite this
%                     For matrix of plots, this will write only on the top row plots
%                     To skip titles on some plots, put an empty string ''
%                     in those locations
%                     This will leave 'Summary Statistics' on the first plot
%
%    titlefontsize    font size for titles
%                           (only has effect when titlecellstr is nonempty)
%                     default is empty, [], for Matlab default
%
%    labelfontsize    font size for axis labels (variable names)
%                         default is empty [], for Matlab default
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                       Will add file suffix determined by savetype
%                         unspecified:  results only appear on screen
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
%     Graphics in current figure (for nplot a prefect square)
%          or figures 1,...,nplot
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
%
% Assumes path can find personal functions:
%    projplot1SM.m
%    Plot1dSM.m
%    vec2matSM.m
%    kdeSM.m
%    axisSM.m
%    lbinrSM.m
%    bwsjpiSM.m
%    bwosSM.m
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM.m
%    cquantSM.m
%    bwrfphSM.m
%    rootfSM.m
%    LstatisticSM.m

%    Copyright (c) J. S. Marron 2010-2023



%  First set all parameters to defaults
%
istat = 2 ;
varnamecellstr = [] ;
nplot = 16 ;
viplot = [] ;
icolor = 1 ;
markerstr = 'o' ;
ibigdot = 0 ;
isubpopkde = 0 ;
idatovlay = 1 ;
ndatovlay = 2 ;
datovlaymax = 0.6 ;
datovlaymin = 0.5 ;
textht = 0.8 ;
titlecellstr = {} ;
titlefontsize = [] ;
labelfontsize = [] ;
savestr = [] ;
savetype = 1 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1   %  then paramstruct is an argument

  if isfield(paramstruct,'istat')    %  then change to input value
    istat = paramstruct.istat ; 
  end

  if isfield(paramstruct,'varnamecellstr')    %  then change to input value
    varnamecellstr = paramstruct.varnamecellstr ;
  end

  if isfield(paramstruct,'nplot')    %  then change to input value
    nplot = paramstruct.nplot ;
  end

  if isfield(paramstruct,'viplot')    %  then change to input value
    viplot = paramstruct.viplot;
  end

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ;
  end

  if isfield(paramstruct,'markerstr')    %  then change to input value
    markerstr = paramstruct.markerstr ; 
  end

  if isfield(paramstruct,'ibigdot')    %  then change to input value
    ibigdot = paramstruct.ibigdot ;
  end

  if isfield(paramstruct,'isubpopkde')    %  then change to input value
    isubpopkde = paramstruct.isubpopkde ;
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

  if isfield(paramstruct,'textht')    %  then change to input value
    textht = paramstruct.textht ;
  end

  if isfield(paramstruct,'titlecellstr')    %  then change to input value
    titlecellstr = paramstruct.titlecellstr ;
  end

  if isfield(paramstruct,'titlefontsize')    %  then change to input value
    titlefontsize = paramstruct.titlefontsize ;
  end

  if isfield(paramstruct,'labelfontsize')    %  then change to input value
    labelfontsize = paramstruct.labelfontsize ; 
  end

  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstruct.savestr ; 
    if  ~ischar(savestr)  &&  ~isempty(savestr)   
                          %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from MargDistPlotSM.m:  !!!') ;
      disp('!!!   Invalid savestr,                !!!') ;
      disp('!!!   using default of no save        !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'savetype')     %  then use input value
    savetype = paramstruct.savetype ; 
  end 


end    %  of resetting of input parameters



%  check and set preliminaries
%
d = size(mdata,1) ;
n = size(mdata,2) ;

if istat == 1
  statstr = 'mean' ;
elseif istat == 2
  statstr = 'SD' ;
elseif istat == 3 
  statstr = 'skewness' ;
elseif istat == 4 
  statstr = 'kurtosis' ;
elseif istat == 5 
  statstr = 'median' ;
elseif istat == 6 
  statstr = 'MAD' ;
elseif istat == 7 
  statstr = 'IQR' ;
elseif istat == 8 
  statstr = 'min' ;
elseif istat == 9 
  statstr = 'max' ;
elseif istat == 10 
  statstr = 'range' ;
elseif istat == 11    %  Number of unique values (using Matlab's "unique")
  statstr = 'nuniq' ;
elseif istat == 12    %  Number of most frequent value
  statstr = 'NMF' ;
elseif istat == 13    %  Number of 0s
  statstr = 'N0' ;
elseif istat == 14    %  smallest non-zero spacing
  statstr = 'SNS' ;
elseif istat == 15    %  Continuity Index
  statstr = 'ContInd' ;
elseif istat == 16    %  Entropy
  statstr = 'Entropy' ;
elseif istat == 17    %  Bowley Skewness
  statstr = 'BowlSkew' ;
elseif istat == 18    %  2nd L-statistic Ratio
  statstr = 'Lstat2' ;
elseif istat == 19    %  3rd L-statistic Ratio
  statstr = 'Lstat3' ;
elseif istat == 20    %  4th L-statistic Ratio
  statstr = 'Lstat4' ;
else
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from MargDistPlotSM:       !!!') ;
  disp(['!!!   Invalid value of istat = ' num2str(istat)]) ;
  disp('!!!   Returning without plotting       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end


if ~isempty(varnamecellstr)
  if  (size(varnamecellstr,1) == d)  &&  ((size(varnamecellstr,2) == 1))
         % then have valid varnamecellstr
    igenvnc = false ;
  else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from MargDistPlotSM:          !!!') ;
    disp('!!!   Invalid value of varnamecellstr       !!!') ;
    disp('!!!   Resetting to default Variable Names   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    igenvnc = true ;


  end
else
  igenvnc = true ;
end
if igenvnc    %  Then generate varnamecellstr using default variable names
  varnamecellstr = {} ;
  for i = 1:d
    varnamecellstr = cat(1,varnamecellstr,{['Variable ' num2str(i)]}) ;
  end
end

np = min(nplot,d + 1) ;
if round(sqrt(nplot)) == sqrt(nplot)    %  nplot is a perfect square
  vifig = 1 ;
else
  vifig = 1:np ;
end


if ~isempty(viplot)
  if  (length(viplot) == (np - 1))  && ...
      (length(unique(viplot)) == length(viplot))  && ...
      (min(viplot) >= 1)  && ...
      (max(viplot) <= d)
    igenvip = false ;
  else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from MargDistPlotSM:    !!!') ;
    disp('!!!   Invalid value of viplot         !!!') ;
    disp('!!!   Resetting to default viplot     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    igenvip = true ;
  end
else
  igenvip = true ;
end



%  Compute Summary Statistics
%
vsumstat = [] ;
for i = 1:d
  if istat == 1
    sumstat = mean(mdata(i,:)) ;
  elseif istat == 2
    sumstat = std(mdata(i,:)) ;
  elseif istat == 3
    sumstat = skewness(mdata(i,:)) ;
  elseif istat == 4
    sumstat = kurtosis(mdata(i,:)) ;
  elseif istat == 5
    sumstat = median(mdata(i,:)) ;
  elseif istat == 6
    sumstat = madSM(mdata(i,:)) ;
  elseif istat == 7
    sumstat = iqrSM(mdata(i,:)') ;
  elseif istat == 8
    sumstat = min(mdata(i,:)) ;
  elseif istat == 9
    sumstat = max(mdata(i,:)) ;
  elseif istat == 10
    sumstat = max(mdata(i,:)) - min(mdata(i,:)) ;
  elseif istat == 11    %  Number of unique values (using Matlab's "unique")
    sumstat = length(unique(mdata(i,:))) ;
  elseif istat == 12    %  Number of most frequent value
    uval = unique(mdata(i,:)) ;
    ufreq = [] ;
    for ifreq = 1:length(uval)
      ufreq = [ufreq; sum(mdata(i,:) == uval(ifreq))] ; %#ok<AGROW>
    end
    sumstat = max(ufreq) ;
  elseif istat == 13    %  Number of 0s
    sumstat = sum(mdata(i,:) == 0) ;
  elseif istat == 14    %  smallest non-zero spacing
    uval = unique(mdata(i,:)) ;
    uval = sort(uval) ;
    sumstat = min(uval(2:end) - uval(1:(end - 1))) ;
  elseif istat == 15    %  Continuity Index
    mdist = abs(vec2matSM(mdata(i,:)',n) - vec2matSM(mdata(i,:),n)) ;
    n0 = sum(sum(mdist == 0)) ;
    sumstat = (n^2 - n0) / (n * (n - 1)) ;
        %  Take full matrix, and subtract all 0s
        %  divide by total nondiagonal elements
  elseif istat == 16    %  Entropy
    uval = unique(mdata(i,:)) ;
    nfreq = length(uval) ;
    ufreq = [] ;
    for ifreq = 1:nfreq
      ufreq = [ufreq; sum(mdata(i,:) == uval(ifreq))] ; %#ok<AGROW>
    end
    vp = ufreq / nfreq ;
    sumstat = -sum(vp .* log(vp)) ;
  elseif istat == 17    %  Bowley Skewness
    vq = cquantSM(mdata(i,:)',[0.25; 0.5; 0.75]) ;
    sumstat = (vq(1) - 2 * vq(2) + vq(3)) / (vq(3) - vq(1)) ;
  elseif istat == 18    %  2nd L-statistics ratio
    sumstat = LstatisticSM(mdata(i,:)',2) ;
  elseif istat == 19    %  3rd L-statistics ratio
    sumstat = LstatisticSM(mdata(i,:)',3) ;
  elseif istat == 20    %  4th L-statistics ratio
    sumstat = LstatisticSM(mdata(i,:)',4) ;
  end
  vsumstat = [vsumstat; sumstat] ; %#ok<AGROW>
end

[svsumstat,vindsort] = sort(vsumstat) ;
vi = (1:d)' ;
vis = vi(vindsort) ;
varnamecellstrs = varnamecellstr(vindsort) ;

if igenvip    %  then need to generate viplot
  if d <= (nplot - 1)    %  then will use all variables
    viplot = (1:d)' ;
  else    %  need to reduce to appropriate quantiles
    viplot = round(linspace(1,d,nplot - 1))' ;
  end
end

visplot = vis(viplot) ;

varnamecellstrsp = varnamecellstrs(viplot) ;
svsumstatp = svsumstat(viplot) ;


%  Make Summary Plot
%
if vifig == 1    %  are making matrix of plots
  subplot(sqrt(nplot),sqrt(nplot),1) ;
else
  figure(1) ;
  clf ;
end
if (sum(sum(icolor == 0)) == (size(icolor,1) * size(icolor,2))) 
  colstr = 'k-' ;
else
  colstr = 'b-' ;
end
plot((1:d)',svsumstat,colstr,'LineWidth',3) ;
  vax = axisSM(svsumstat) ;
  axis([0 (d + 1) vax(1) vax(2)]) ;
  if isempty(titlefontsize)
    title('Summary Statistics') ;
  else
    title('Summary Statistics','FontSize',titlefontsize) ;
  end
  if isempty(labelfontsize)
    xlabel('Sorted Variable Index') ;
    ylabel([statstr ' summary statistic value']) ;
  else
    xlabel('Sorted Variable Index','FontSize',labelfontsize) ;
    ylabel([statstr ' summary statistic value'],'FontSize',labelfontsize) ;
  end
  hold on ;
    for ip = 1:(np - 1)    %  draw vertical lines
      plot([viplot(ip) viplot(ip)],[vax(1) vax(2)],'k--') ;
    end
  hold off ;

%  Make individual distribution plots
%
for ip = 2:np
  if vifig == 1    %  are making matrix of plots
    subplot(sqrt(nplot),sqrt(nplot),ip) ;
  else    %  are putting plots in individual figures
    figure(vifig(ip)) ;
  end
  paramstruct = struct('icolor',icolor, ...
                       'markerstr',markerstr, ...
                       'isubpopkde',isubpopkde, ...
                       'ibigdot',ibigdot, ...
                       'idatovlay',idatovlay, ...
                       'ndatovlay',ndatovlay, ...
                       'datovlaymax',datovlaymax, ...
                       'datovlaymin',datovlaymin, ...
                       'xlabelstr',varnamecellstrsp{ip - 1}, ...
                       'labelfontsize',labelfontsize) ;
  vdir = zeros(d,1) ;
  vdir(visplot(ip - 1)) = 1 ;
  projplot1SM(mdata,vdir,paramstruct) ;
  vax = axis ;
  hold on ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + textht * (vax(4) - vax(3)), ...
         [statstr ' = ' num2str(svsumstatp(ip - 1))]) ;
  hold off ;

  if ~(vifig == 1)    %  are putting plots in individual figures
    if ~isempty(savestr)   %  then create postscript file
      orient landscape ;
      if icolor ~= 0    %  then make color postscript
        print('-dpsc2',savestr) ;
      else              %  then make black and white
        print('-dps2',savestr) ;
      end 
    end
  end


end    %  of main ip loop



%  Add titles, if needed
%
if ~isempty(titlecellstr) 
  if vifig == 1    %  then are putting all plots in one figure
    for itit = 1:min(length(titlecellstr),sqrt(np))
      if ~isempty(titlecellstr{itit})
        subplot(sqrt(np),sqrt(np),itit) ;
        if isempty(titlefontsize)
          title(titlecellstr{itit}) ;
        else
          title(titlecellstr{itit},'FontSize',titlefontsize) ;
        end
      end
    end
  else    %  are putting plots in individual figures
    for itit = 1:min(length(titlecellstr),np)
      if ~isempty(titlecellstr{itit})
        figure(itit) ;
        if isempty(titlefontsize)
          title(titlecellstr{itit}) ;
        else
          title(titlecellstr{itit},'FontSize',titlefontsize) ;
        end
      end
    end
  end
end



%  Save output (if needed)
%
if ~isempty(savestr)   %  then save graphics

  printSM(savestr,savetype) ;

end


