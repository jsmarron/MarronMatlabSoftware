function [stat,pval,PDC] = CPDpermSM(mdata1,mdata2,paramstruct) 
% Canonical Parallel Direction PERMutation test for
% statistical significance of CPD, intended for paired data sets
% in High Dimension, Low Sample Size settings
% Summary statistic is sum of squared CPD projected pairwise distances
%
% Inputs:
%     mdata1 - d x n data set 1
%     mdata2 - d x n data set 2
%         i.e. data objects are n paired d-dim vectors (columns) 
%                     with corresponding rows
%         d >= 2n is required
%
%     paramstruct - a Matlab structure of input parameters
%                      Use: "help struct" and "help datatypes" to
%                           learn about these.
%                      Create one, using commands of the form:
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
%    nsim             Number of simulated relabellings to use
%                           (default is 1000)
%
%    nreport          How often to report permutation step taken to screen
%                     default 100 (report after 100 steps)
%                     (only has effect when iscreenwrite = 1)
%
%    seed          Seed for random number generator, use to allow
%                     identical repetition of random relabellings.
%                     Empty (default) for using the current value
%                     Note:  This uses rng version of "seed" idea.
%                         If have made call using older versions,
%                         then need to use command:  rng('default')
%
%    ishowperm        0  -  Just show two panel (projections & p-value) display
%                     1  -  (default) Also show two panels of permuted 
%                                   projections (first 2, for 4 total panels)
%                           Note:  Permutes colors as well, so subdensities
%                                       show permuted differences, but heights
%                                       of points and symbols show original
%                                       class labels
%                     2  -  Similar to 1, except show smallest and biggest stat 
%                               Useful for diagnosing balance problems
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default)  color version 
%                        (Red for mdata1, Blue for mdata2)
%                     2x3 color matrix, top row for mdata1, 
%                                           bottom row for mdata2
%                           Note:  larger color matrices are deliberately not 
%                                  supported, since color provides important
%                                  cues as to what the two classes are.
%                                  To combine multiple classes (having the
%                                  same color), consider a formulation like:
%                                       unique(icolor,'rows')
%                                
%    statstrcol       Color for strings where stats are reported
%                             Default is dark green [0 0.6 0]
%                             (this gets over-ridden to 'k' when icolor = 0)
%
%    markerstr        Can be any of:
%                         A single string with symbol to use for marker,
%                             e.g. 'o', '.', '+', 'x'
%                             (see "help plot" for a full list)
%                         A character array (2 x 1), of these symbols,
%                             One for each data set, created using:  strvcat
%                                  or using:  ['+';'o']   (default)
%                         An 2n x 1 character array, 
%                             One for each data point
%
%    ipval            index for p-value computation:
%                         1  (default) Display all of p-value 
%                                (empirical quantile) and PDC
%                         2  Show only p-value (empirical quantile)
%                         3  Show only PDC (useful for comparisons, when
%                                            p-values are all < 1/nsim)
%
%    ibigdot          0  (default)  use Matlab default for dot sizes
%                     1  force large dot size in prints (useful since some
%                              postscript graphics leave dots too small)
%                              (Caution: shows up as small in Matlab view)
%                              Only has effect on plot of simulated t-stats 
%
%    datovlaymax      maximum (on [0,1] scale, with 0 at bottom, 
%                              1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.5
%                     This applies to both the projected data, 
%                              and the simulated stats
%
%    datovlaymin      minimum (on [0,1] scale, with 0 at bottom, 
%                              1 at top of plot)
%                     of vertical range for overlaid data.  Default = 0.4
%                     This applies to both the projected data, 
%                              and the simulated stats
%
%    legendcellstr    cell array of strings for data set labels (2 of them),
%                     useful for (colored) classes, create this using
%                     cellstr, or {{string1 string2}}
%                     Also can indicate symbols, by just adding (at least 
%                             for +,x.o) into the text
%
%    title1str         string with title for left hand plot 
%                               (showing projected data)
%                           default is empty string, '', to use:
%                               ['Canonical Parallel Direction'] 
%                           For no title, use ' '
%
%    title2str         string with title for right hand plot 
%                               (showing simulations)
%                           default is empty string, '', to use:
%                               [num2str(nsim) ' CDP stats, 
%                                               from permutations'] 
%                           For no title, use ' '
%
%    titlefontsize    font size for title
%                               (only has effect when the titlestr is nonempty)
%                           default is empty [], for Matlab default
%
%    xlabel1str        string with x axis label for left hand plot
%                           default is empty string, '', for no xlabel
%
%    xlabel2str        string with x axis label for left hand plot
%                           default is empty string, '', for no xlabel
%
%    ylabel1str        string with y axis label for left hand plot
%                           default is empty string, '', for no ylabel
%
%    ylabel2str        string with y axis label for left hand plot
%                           default is empty string, '', for no ylabel
%
%    labelfontsize     font size for axis labels
%                                    (only has effect when plot is made here,
%                                     and when a label str is nonempty)
%                           default is empty [], for Matlab default
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
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%     
% Outputs:
%     Graphics in current Figure, 
%         showing projected data in left hand plot
%         and population of simulated pvalues in right hand plot
%     When savestr exists, generate output files, 
%        as indicated by savetype
%     
%     stat - value of statistic, computed for data projected 
%                  onto direction vector
%
%     pval - pvalue, based on simulated quantiles.
%                 summarizing results of permutation test
%                 = '< 1 / nsim'  when smulated quantile is 0
%
%     PDC - Population Difference Criterion
%                 Essentially Z-score summary (in permutation population),
%                 useful for comparisons, when pval = 0
%                         (formerly called zscore)
%


% Assumes path can find personal functions:
%    Plot2dSM.m
%    projplot2SM.m
%    vec2matSM.m
%    axisSM.m
%    lbinrSM.m
%    bwrswSM.m
%    interp1s.m
%    printSM.m




%    Plot1dSM.m
%    projplot1SM.m
%    cprobSM.m
%    kdeSM.m
%    nmfSM.m
%    bwsjpiSM.m
%    bwrfphSM.m
%    bwosSM.m
%    rootfSM
%    vec2matSM.m
%    bwrotSM.m
%    bwsnrSM.m
%    iqrSM.m
%    cquantSM.m
%    ROCcurveSM

%    Copyright (c) J. S. Marron 2026


%  First set all parameters to defaults
%
nsim = 1000 ;
nreport = 100 ;
seed = [] ;
icolor = 1 ;
statstrcol = [0 0.6 0] ;
markerstr = ['+';'o'] ;
ipval = 1 ;
ishowperm = 1 ;
ibigdot = 0 ;
datovlaymax = 0.5 ;
datovlaymin = 0.4 ;
legendcellstr = {} ;
title1str = 'CPD View of Input Data' ;
title2str = '' ;
titlefontsize = [] ;
xlabel1str = 'Canonical Parallel Dir''n' ;
xlabel2str = '' ;
ylabel1str = 'Canonical Ortho Dir''n' ;
ylabel2str = '' ;
labelfontsize = [] ;
savestr = [] ;
savetype = 1 ;
iscreenwrite = 0 ;


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2    %  then paramstruct is an argument

  if isfield(paramstruct,'nsim')    %  then change to input value
    nsim = paramstruct.nsim ; 
  end 

  if isfield(paramstruct,'nreport')    %  then change to input value
    nreport = paramstruct.nreport ; 
  end 

  if isfield(paramstruct,'seed')    %  then change to input value
    seed = paramstruct.seed ; 
  end 

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ; 
  end 

  if isfield(paramstruct,'statstrcol')    %  then change to input value
    statstrcol = paramstruct.statstrcol ; 
  end 

  if isfield(paramstruct,'markerstr')    %  then change to input value
    markerstr = paramstruct.markerstr ; 
  end 

  if isfield(paramstruct,'ipval')    %  then change to input value
    ipval = paramstruct.ipval ; 
  end 

  if isfield(paramstruct,'ishowperm')    %  then change to input value
    ishowperm = paramstruct.ishowperm ; 
  end 

  if isfield(paramstruct,'ibigdot')    %  then change to input value
    ibigdot = paramstruct.ibigdot ; 
  end 

  if isfield(paramstruct,'datovlaymax')    %  then change to input value
    datovlaymax = paramstruct.datovlaymax ; 
  end 

  if isfield(paramstruct,'datovlaymin')    %  then change to input value
    datovlaymin = paramstruct.datovlaymin ; 
  end 

  if isfield(paramstruct,'legendcellstr')    %  then change to input value
    legendcellstr = paramstruct.legendcellstr ; 
  end 

  if isfield(paramstruct,'title1str')    %  then change to input value
    title1str = paramstruct.title1str ; 
  end 

  if isfield(paramstruct,'title2str')    %  then change to input value
    title2str = paramstruct.title2str ; 
  end 

  if isfield(paramstruct,'titlefontsize')    %  then change to input value
    titlefontsize = paramstruct.titlefontsize ; 
  end 

  if isfield(paramstruct,'xlabel1str')    %  then change to input value
    xlabel1str = paramstruct.xlabel1str ; 
  end 

  if isfield(paramstruct,'xlabel2str')    %  then change to input value
    xlabel2str = paramstruct.xlabel2str ; 
  end 

  if isfield(paramstruct,'ylabel1str')    %  then change to input value
    ylabel1str = paramstruct.ylabel1str ; 
  end 

  if isfield(paramstruct,'ylabel2str')    %  then change to input value
    ylabel2str = paramstruct.ylabel2str ; 
  end 

  if isfield(paramstruct,'labelfontsize')    %  then change to input value
    labelfontsize = paramstruct.labelfontsize ; 
  end 

  if isfield(paramstruct,'savestr')    %  then change to input value
    savestr = paramstruct.savestr ; 
    if ~(ischar(savestr) || isempty(savestr))    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from CDPpermSM.m:    !!!') ;
      disp('!!!   Invalid savestr,               !!!') ;
      disp('!!!   using default of no save       !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end 
  end 

  if isfield(paramstruct,'savetype')    %  then change to input value
    savetype = paramstruct.savetype ; 
  end 

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ; 
  end 

end    %  of resetting of input parameters


%  Initiate parameters
%
d = size(mdata1,1) ;
n = size(mdata1,2) ;
if ~((d == size(mdata2,1)) & (n == size(mdata2,2))) 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from CDPpermSM.m:          !!!') ;
  disp('!!!   mdata1 and mdata2 must have      !!!') ;
  disp('!!!   same number of rows & columns    !!!') ;
  disp('!!!   Terminating Execution            !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  stat = [] ;
  pval = [] ;
  PDC = [] ;
  return ;
end 

if d < 2 * n 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from CDPpermSM.m:          !!!') ;
  disp(['!!!   (d = ' num2str(d) ')  <  (2n = ' num2str(2 * n) ')']) ;
  disp('!!!   Terminating Execution            !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  stat = [] ;
  pval = [] ;
  PDC = [] ;
  return ;
end 


mdata = [mdata1 mdata2] ;


if ~isempty(seed) 
  rng(seed) ;
end 


if icolor == 0    %  fully black and white version (everywhere)
  mcolor = zeros(2 * n,3) ;
  mlegcol = zeros(2,3) ;
  statstrcol = 'k' ;
      % override input choice
elseif icolor == 1    %  (default)  color version 
                      %      (Red for Class 1, Blue for Class 2)
  mcolor = [ones(n,1) * [1 0 0] ; ...
            ones(n,1) * [0 0 1]] ;
  mlegcol = [[1 0 0]; [0 0 1]] ;
elseif  size(icolor,1) == 2  &&  size(icolor,2) == 3 
                  %  have 2 rows two icolor, as required
  mcolor = [ones(n,1) * icolor(1,:) ; ...
            ones(n,1) * icolor(2,:)] ;
  mlegcol = icolor ;
else 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from CDPpermSM:          !!!') ;
  disp('!!!   Input icolor is invalid          !!!') ;
  disp(['!!!   Need 2 rows,    input has ' num2str(size(icolor,1))]) ;
  disp(['!!!   Need 3 columns, input has ' num2str(size(icolor,2))]) ;
  disp('!!!   Replacing icolor with default    !!!') ;
  disp('!!!       and proceeding               !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  mcolor = [ones(n,1) * [1 0 0] ; ...
            ones(n,1) * [0 0 1]] ;
  mlegcol = [[1 0 0]; [0 0 1]] ;
  statstrcol = [0 0.6 0] ;
end 

if size(markerstr,1) == 1    %  then can use as single symbol
  vmarkerstr = markerstr ;
elseif size(markerstr,1) == 2    %  then need to expand out
  vmarkerstr = markerstr(1,1) ;
  for i = 2:n 
    vmarkerstr = char(vmarkerstr,markerstr(1,1)) ;
  end 
  for i = 1:n 
    vmarkerstr = char(vmarkerstr,markerstr(2,1)) ;
  end 
else    %  pass given markerstr through to graphics
  vmarkerstr = markerstr ;
end 


%  Find full data statistic
%
[vCPD, vCOD] = CanParDirSM(mdata1,mdata2,1) ;
stat = sum((vCPD' * (mdata1 - mdata2)).^2) ;

pval = [] ;
PDC = [] ;
    %  set these to empty, to give some outputs 
    %  when a terminal error is encountered


%  Start output graphics
%
%  First show input data CPD plot
%
if ishowperm == 0
  subplot(1,2,1) ;
else 
  subplot(2,2,1) ;
end 

paramstruct1 = struct('icolor',mcolor, ...
                      'isubpopkde',1, ...
                      'markerstr',vmarkerstr, ...
                      'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                      'titlestr',title1str, ...
                      'titlefontsize',titlefontsize, ...
                      'xlabelstr',xlabel1str, ...
                      'ylabelstr',ylabel1str, ...
                      'labelfontsize',labelfontsize, ...
                      'datovlaymin',datovlaymin, ...
                      'datovlaymax',datovlaymax, ...
                      'iscreenwrite',iscreenwrite) ;
if ~(isempty(legendcellstr)) 
  paramstruct1.legendcellstr = legendcellstr ;
  paramstruct1.mlegendcolor = mlegcol ;
end 
projplot2SM([mdata1 mdata2],[vCPD vCOD],paramstruct1) ;

%  overlay combined hypo test stat
%
vax = axis ;
hold on ;
  text(vax(1) + 0.1 * (vax(2) - vax(1)), ...
       vax(3) + 0.92 * (vax(4) - vax(3)), ...
       ['CPD stat = ' num2str(stat)], ...
       'Color',statstrcol) ;
hold off ;


%  Do permutation test
%

%  Recompute CPD stats over random relabellings
%
vstat = zeros(nsim,1) ;
mvCPD = [] ;
mvCOD = [] ;
mindperm = [] ;
for isim = 1:nsim 

  if (isim / nreport) == floor(isim / nreport) 
    if iscreenwrite == 1 
      disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    end 
  end 

  vunif = rand(1,n) ;
  [~,indperm] = sort(vunif) ;
      %  random re-ordering of 1,...,n

  if ishowperm == 0
    vCPDperm = CanParDirSM(mdata1,mdata2(:,indperm),0) ;
  else 
    [vCPDperm, vCODperm] = CanParDirSM(mdata1,mdata2(:,indperm),1) ;
    if ishowperm == 1
      if  isim == 1  |  isim == 2
        mvCPD = [mvCPD vCPDperm] ;
        mvCOD = [mvCOD vCODperm] ;
        mindperm = [mindperm; indperm] ;
      end
    else
      mvCPD = [mvCPD vCPDperm] ;
      mvCOD = [mvCOD vCODperm] ;
      mindperm = [mindperm; indperm] ;
    end
  end 
  statperm = sum((vCPDperm' * (mdata1 - mdata2(:,indperm))).^2) ;
  vstat(isim) = statperm ;

end    %  of isim loop through simulated permutations


%  Compute p-value
%
pval = [pval; 1 - cprobSM(vstat,stat)] ; %#ok<AGROW>
    %  empirical p-value
simmean = mean(vstat) ;
simsd = std(vstat) ;
PDC = [PDC; (stat - simmean) / simsd] ; %#ok<AGROW>


%  add results to graphics
%
if ishowperm == 0
  subplot(1,2,2) ;
else 
  subplot(2,2,2) ;
end 
vax = axisSM([vstat; stat]) ;
if isempty(title2str) 
  kdetitstr = [num2str(nsim) ' CDP stats from permutations'] ;
else
  kdetitstr = title2str ;
end 

kdeparamstruct = struct('vxgrid',vax, ...
                        'linecolor','k', ...
                        'dolcolor','k', ...
                        'ibigdot',ibigdot, ...
                        'titlestr',kdetitstr, ...
                        'titlefontsize',titlefontsize, ...
                        'xlabelstr',xlabel2str, ...
                        'ylabelstr',ylabel2str, ...
                        'labelfontsize',labelfontsize, ...
                        'datovlaymin',datovlaymin, ...
                        'datovlaymax',datovlaymax, ...
                        'iscreenwrite',1) ;
kdeSM(vstat,kdeparamstruct) ;
vax = axis ;
vax(3) = 0 ;
    %  put lower end of vertical axis at 0
axis(vax) ;
hold on ;
  plot([stat; stat],[vax(3); vax(4)],'Color',statstrcol) ;
  text(vax(1) + 0.3 * (vax(2) - vax(1)), ...
       vax(3) + 0.9 * (vax(4) - vax(3)), ...
       ['CPD stat = ' num2str(stat)],'Color',statstrcol) ;
  if ipval == 1 
    if pval == 0 
      pvalstr = ['pval < ' num2str(1 / nsim)] ;
    else
      pvalstr = ['pval = ' num2str(pval)] ;
    end
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         pvalstr,'Color','k') ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.7 * (vax(4) - vax(3)), ...
         ['PDC = ' num2str(PDC)],'Color','k') ;

  elseif ipval == 2 
    if pval == 0 
      pvalstr = ['pval < ' num2str(1 / nsim)] ;
    else
      pvalstr = ['pval = ' num2str(pval)] ;
    end
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         pvalstr,'Color','k') ;

  elseif ipval == 3 
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['PDC = ' num2str(PDC)],'Color','k') ;

  else 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from CDPpermSM.m:         !!!') ;
    disp('!!!   Invalid ipval,                      !!!') ;
    disp('!!!   using default of all displays       !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    if pval == 0 
      pvalstr = ['pval < ' num2str(1 / nsim)] ;
    else
      pvalstr = ['pval = ' num2str(pval)] ;
    end
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         pvalstr,'Color','k') ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.7 * (vax(4) - vax(3)), ...
         ['PDC = ' num2str(PDC)],'Color','k') ;

  end 

hold off ;


%  Add example perumtations (if needed)
%
if  ishowperm == 1  || ...
    ishowperm == 2  

  if ishowperm == 1 
    titlestr1 = ['1st Permuted CPD View'] ;
    titlestr2 = ['2nd Permuted CPD View'] ;
    statperm1 = vstat(1) ;
    statperm2 = vstat(2) ;
  else 
    titlestr1 = ['Min Permuted CPD View'] ;
    titlestr2 = ['Max Permuted CPD View'] ;
    [~,i1] = min(vstat) ;
    [~,i2] = max(vstat) ;
    mvCPD = mvCPD(:,[i1 i2]) ;
    mvCOD = mvCOD(:,[i1 i2]) ;
    mindperm = mindperm([i1 i2],:) ;
    statperm1 = vstat(i1) ;
    statperm2 = vstat(i2) ;
  end 

  subplot(2,2,3)
  paramstructp1 = struct('icolor',mcolor, ...
                        'isubpopkde',1, ...
                        'markerstr',vmarkerstr, ...
                        'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                        'titlestr',titlestr1, ...
                        'titlefontsize',titlefontsize, ...
                        'xlabelstr',xlabel1str, ...
                        'ylabelstr',ylabel1str, ...
                        'labelfontsize',labelfontsize, ...
                        'datovlaymin',datovlaymin, ...
                        'datovlaymax',datovlaymax, ...
                        'iscreenwrite',iscreenwrite) ;
  projplot2SM([mdata1 mdata2(:,mindperm(1,:))], ...
                  [mvCPD(:,1) mvCOD(:,1)],paramstructp1) ;
  vax = axis ;
  hold on ;
    text(vax(1) + 0.1 * (vax(2) - vax(1)), ...
         vax(3) + 0.92 * (vax(4) - vax(3)), ...
         ['Permuted CPD stat = ' num2str(statperm1)], ...
         'Color','k') ;
  hold off ;

  subplot(2,2,4)
  paramstructp2 = struct('icolor',mcolor, ...
                        'isubpopkde',1, ...
                        'markerstr',vmarkerstr, ...
                        'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                        'titlestr',titlestr2, ...
                        'titlefontsize',titlefontsize, ...
                        'xlabelstr',xlabel1str, ...
                        'ylabelstr',ylabel1str, ...
                        'labelfontsize',labelfontsize, ...
                        'datovlaymin',datovlaymin, ...
                        'datovlaymax',datovlaymax, ...
                        'iscreenwrite',iscreenwrite) ;
  projplot2SM([mdata1 mdata2(:,mindperm(2,:))], ...
                  [mvCPD(:,2) mvCOD(:,2)],paramstructp2) ;
  vax = axis ;
  hold on ;
    text(vax(1) + 0.1 * (vax(2) - vax(1)), ...
         vax(3) + 0.92 * (vax(4) - vax(3)), ...
         ['Permuted CPD stat = ' num2str(statperm2)], ...
         'Color','k') ;
  hold off ;

end     %  of ishowperm if-block


%  Save graphical output(s) (if needed)
%
if ~isempty(savestr)    %  then create postscript file(s)
  orient landscape ;
  printSM(savestr,savetype) ;
end 

