function MargOverlapSM(mdata,vflag,paramstruct) 
% MargClassSM, Marginal distribution Overlap measure
%     Given an input data matrix, and binary class labels
%     studies 1-d marginal distributions
%     Focus is on finding variables with least overlap
%     Upper left plot shows sorted values of statistic,
%     and highlights some interesting variables 
%     (e.g. quantiles of the summary statistic distribution)
%     Other plots study individual distributions of the highlighted variables,
%     using density estimates, and data overlays.
%     
%   Steve Marron's matlab function
% Inputs:
%         mdata - d x n matrix of data, 
%                    the n columns each are a d-dim data vector,
%                    the d row vectors each contain marginal data
%
%         vflag - 1 x n logical vector, 1 for Class +1, 0 for Class -1
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
%    ioverlap          index of the 1-d measure of overlap to use:
%                      1 - t-stat (unequal var) log10 p-value  (default)
%                                        or    -log10(1 - p) for p ~ 1
%                      2 - Wilcoxon rank sum log10 p-value
%                                        or    -log10(1 - p) for p ~ 1
%                      3 - Gaussian Error Rate (mean & sd)
%                      4 - Gaussian Error Rate (median & mad)
%                      5 - AUC based on ROC curve
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
%                        for 1,...,(nplot/2 - 1),d/2,(d - (nplot/2 - 2)),...,d
%                            (nearly half at left end, and at right)
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default)  color version 
%                               summary statistic plot - blue
%                               overlay bars - black
%                               density estimates - blue
%                               data overlay, Class +1 - red
%                               data overlay, Class -1 - blue
%                     2x3 color matrix:  Class color labels
%
%    markerstr        Can be either a string matrix of the form
%                         strvcat('+','o') (default)
%                              (Class +1, -1, respectively)
%                         (see "help plot" for a full list of availabe markers)
%                     Or a character array (n x 1), of symbols,
%                         One for each data vector, created using:  strvcat
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%                              Only has effect when markerstr = '.' 
%
%    isubpopkde       0  construct kde using only the full data set
%                     1  (default) partition data into subpopulations, using the 
%                            color indicators in icolor (defaults to 0, unless 
%                            icolor is an nx3 color matrix), as markers of subsets.
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
%    cquantSM.m
%    bwrfphSM.m
%    rootfSM.m
%    ROCcurveSM

%    Copyright (c) J. S. Marron 2016-2023



%  First set all parameters to defaults
%
ioverlap = 1 ;
varnamecellstr = [] ;
nplot = 16 ;
viplot = [] ;
icolor = 1 ;
markerstr = char('+','o') ;
ibigdot = 0 ;
isubpopkde = 1 ;
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
if nargin > 2   %  then paramstruct is an argument

  if isfield(paramstruct,'ioverlap')    %  then change to input value
    ioverlap = paramstruct.ioverlap ; 
  end 
  
  if isfield(paramstruct,'varnamecellstr')    %  then change to input value
    varnamecellstr = paramstruct.varnamecellstr ; 
  end

  if isfield(paramstruct,'nplot')    %  then change to input value
    nplot = paramstruct.nplot ;
  end

  if isfield(paramstruct,'viplot')    %  then change to input value
    viplot = paramstruct.viplot ;
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
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from MargOverlapSM.m:  !!!') ;
      disp('!!!   Invalid savestr,               !!!') ;
      disp('!!!   using default of no save       !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
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

if ioverlap == 1
  statstr = 't-stat logp' ;
elseif ioverlap == 2
  statstr = 'RankSum logp' ;
elseif ioverlap == 3
  statstr = 'NormErr' ;
elseif ioverlap == 4
  statstr = 'RobNErr' ;
elseif ioverlap == 5
  statstr = 'AUC-ROC' ;
else
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from MargOverlapSM:        !!!') ;
  disp(['!!!   Invalid value of ioverlap = ' num2str(ioverlap)]) ;
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
    disp('!!!   Warning from MargOverlapSM:           !!!') ;
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
    disp('!!!   Warning from MargOverlapSM:     !!!') ;
    disp('!!!   Invalid value of viplot         !!!') ;
    disp('!!!   Resetting to default viplot     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    igenvip = true ;
  end
else
  igenvip = true ;
end

if (size(icolor,1) == 1) && (size(icolor,2) == 1)
  if icolor == 0    %  Set all to black
    mcolor = zeros(n,3) ;
  elseif icolor == 1    %  Need to set default colors
    mcolor = ones(n,1) * [0 0 1] ;
        %  Set all to blue
    mcolor(vflag,:) = ones(sum(vflag),1) * [1 0 0] ;
        %  Update Class 1 to red
  elseif icolor ~= 1
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!  Warning from MargOverlapSM:   !!!') ;
    disp('!!!  Invalid icolor                !!!') ;
    disp('!!!  Resetting to all black        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    icolor = 0 ;
    mcolor = zeros(n,3) ;
  end 
elseif (size(icolor,1) == 2) && (size(icolor,2) == 3)
  mcolor = ones(n,1) * icolor(2,:) ;
      %  Set all to 2nd color
  mcolor(vflag,:) = ones(sum(vflag),1) * icolor(1,:) ;
        %  Update Class 1 to 1st color
else
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!  Warning from MargOverlapSM:   !!!') ;
  disp('!!!  Invalid icolor                !!!') ;
  disp('!!!  Resetting to all black        !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  icolor = 0 ;
  mcolor = zeros(n,3) ;
end

if (size(markerstr,1) == 2)    %  Then expand markerstr 
  markerstrin = markerstr ;
  markerstr = 'z' ;
  for i = 1:n
    if vflag(i)
      markerstr = char(markerstr,markerstrin(1)) ;
    else
      markerstr = char(markerstr,markerstrin(2)) ;
    end
  end
  markerstr = markerstr(2:end) ;
end


%  Compute Overlap Measures
%
%                      1 - t-stat (unequal var) p-value  (default)
%                      2 - Wilcoxon rans sum p-value
%                      3 - Gaussian Error Rate (mean & sd)
%                      4 - Gaussian Error Rate (median & mad)
%                      5 - AUC based on ROC curve
volmeas = [] ;
for i = 1:d
  if ioverlap == 1
    [~,p] = ttest2(mdata(i,vflag),mdata(i,~vflag),'vartype','unequal') ; 
     if isnan(p)    %  Happens when both variances are 0
        olmeas = 0 ;    %  Inconclusive version of log p
     else    %  Have useful p-val
      if mean(mdata(i,vflag)) > mean(mdata(i,~vflag))
        olmeas = log10(p) ;    %  Use as is
      else
        olmeas = -log10(p) ;    %  Flips direction, think of log(1 - p)
      end
    end
  elseif ioverlap == 2
    [p,~] = ranksum(mdata(i,~vflag),mdata(i,vflag),'tail','both') ;
     if isnan(p)    %  Happens when both variances are 0
        olmeas = 0 ;    %  Inconclusive version of log p
     else    %  Have useful p-val
      if median(mdata(i,vflag)) > median(mdata(i,~vflag))
        olmeas = log10(p) ;    %  Use as is
      else
        olmeas = -log10(p) ;    %  Flips direction, think of log(1 - p)
      end
    end
  elseif  (ioverlap == 3) ||  (ioverlap == 4)
    if ioverlap == 3
      meanp = mean(mdata(i,vflag)) ;
      varp = var(mdata(i,vflag)) ; 
      meann = mean(mdata(i,~vflag)) ; 
      varn = var(mdata(i,~vflag)) ; 
    elseif ioverlap == 4
      meanp = median(mdata(i,vflag)) ;
      varp = madSM(mdata(i,vflag))^2 ; 
      meann = median(mdata(i,~vflag)) ; 
      varn = madSM(mdata(i,~vflag))^2 ; 
    end
    countp = length(mdata(i,vflag)) ;
    countn = length(mdata(i,~vflag)) ;
    if (varp == 0) && (varn == 0)    %  Both var's are 0
      if meanp == meann
        olmeas = 0.5 ;    %  Inconclusive version of p
      elseif meanp > meann
        olmeas = 0 ;    %  Strongly conclude Class +1 to the right
      elseif meanp < meann
        olmeas = 1 ;    %  Strongly conclude Class +1 to the left
      end
    elseif varp == 0
      olmeas = (countn / n) * (1 - normcdf(meanp,meann,sqrt(varn))) ;
    elseif varn == 0
      olmeas = (countp / n) * normcdf(meann,meanp,sqrt(varp)) ;
    else    %  Neither is 0
      coeff2 = varn - varp ;    %  Compute square coeff of quadratic
      coeff1 = 2 * (varp * meann - varn * meanp) ;
      coeff0 = varn * meanp^2 - varp * meann^2 - ...
                  2 * log(sqrt(varn / varp) * countp / countn) ;
      vr = roots([coeff2, coeff1, coeff0]) ;    %  Roots of polynomial
      if isreal(vr)
        if length(vr) >= 1    %  polynomial is linear or quadratic
          if length(vr) == 1    %  polynomial is linear (coeff2 = 0)
            vr = [vr; vr] ;    %#ok<AGROW> %  turn into 2 for easy use of following
          end
          if normpdf(vr(1),meanp,sqrt(varp)) > normpdf(vr(2),meanp,sqrt(varp))
            olmeas = (countp / n) * normcdf(vr(1),meanp,sqrt(varp)) + ...
                          (countn / n) * (1 - normcdf(vr(1),meann,sqrt(varn))) ;
          else
            olmeas = (countp / n) * normcdf(vr(2),meanp,sqrt(varp)) + ...
                          (countn / n) * (1 - normcdf(vr(2),meann,sqrt(varn))) ;
          end
        else    %  Have linear & quadratic coefficients both 0  (so no roots)
          olmeas = 0.5 ;    %  Inconclusive version of p
        end
      else    %  Have complex roots (curves have no intersection)
        olmeas = 0.5 ;    %  Inconclusive version of p
      end
    end
  elseif ioverlap == 5
    [~,AUC] = ROCcurveSM(mdata(i,vflag)',mdata(i,~vflag)',0) ;
    olmeas = AUC ;
  end
  volmeas = [volmeas; olmeas] ; %#ok<AGROW>
end

[svolmeas,vindsort] = sort(volmeas) ;
vi = (1:d)' ;
vis = vi(vindsort) ;
varnamecellstrs = varnamecellstr(vindsort) ;

if igenvip    %  then need to generate viplot
  if d <= (nplot - 1)    %  then will use all variables
    viplot = (1:d)' ;
  else    %  use default grid split between extremes
    if (nplot / 2) == floor(nplot / 2)    %  nplot even 
      viplot = (1:((nplot / 2) - 1))' ;
      viplot = [viplot; round(d / 2)] ;
      viplot = [viplot; (((d - (nplot / 2) + 2)):d)'] ;
    else    %  nplot odd
      viplot = (1:floor(nplot / 2))' ;
      viplot = [viplot; (((d - floor(nplot / 2) - 1)):d)'] ;
    end
  end
end
visplot = vis(viplot) ;
varnamecellstrsp = varnamecellstrs(viplot) ;
svolmeasp = svolmeas(viplot) ;


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
plot((1:d)',svolmeas,colstr,'LineWidth',3) ;
  vax = axisSM(svolmeas) ;
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
  paramstruct = struct('icolor',mcolor, ...
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
         [statstr ' = ' num2str(svolmeasp(ip - 1))]) ;
  hold off ;

  if ~(vifig == 1)    %  are putting plots in individual figures
    if ~isempty(savestr)   %  then create postscript file
      orient landscape ;
      if ~strcmp(colstr,'k')     %  then make color postscript
        print('-dpsc2',savestr) ;
      else                %  then make black and white
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





