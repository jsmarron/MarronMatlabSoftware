function [teststat, epval, ci] = SWISSoriCC(data1,data2,groups,paramstruct) 
% SWISS, Standardized WithIn class Sum of Squares 
%   Calculates SWISS and Permutation test for significant differences between    
%        sum of squares decomposition of data1 and data2
%   Main idea is these are two different representations of the same
%        data set, with common group labels.  The group separation
%        of each representation is quantified by the SWISS score.   
%        Statistical significance of the difference is quantified by
%        a permutation test.
%   Essentially Chris Cabanski's matlab function, SWISS.m
%        but renamed to make it easier to find
%   This is the original version of SWISS, that was written up in:
%        Cabanski, C. et al. (2009) SWISS MADE: Standardized WithIn class 
%            Sum of Squares to evaluate Methodologies And Data set Elements. 
%            PloS one, 5(3), e9905.
%   For more than two groups, an improved version of the score used here
%        is the pairwise SWISS score, which is computed using SWISSpwCC.m 
%                   (although no hypo test has been programmed yet)
%
% Inputs:
%     data1    - (d1 x n) matrix with d1 genes and n samples
%     data2    - (d2 x n) matrix with d2 genes and n samples
%              - If you want to calculate SWISS for one data set only,
%                    set data2 = [], in which case teststat is only output
%     groups   - (n x 1) vector with labels (1,2,3,...,k) for each group
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
%    fields            values
%
%    option            option for centering
%		                   1 - (default) usual sum of squares decomposition 
%                            (uses overall mean)
%		                   2 - uses mean of the group means 
%                            (this weighs all groups equally)
%
%    nsim             Number of simulated relabellings to use
%                           (default is 1000)
%
%    curve            0  (default) fit kde curve of simulated relabeling points
%                     1  fit gaussian curve to simulated data (suggested when n is small)
%                     2  no curve 
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default) line color version (Red for Data Set 1, Blue for Data Set 2)
%
%    dotcolor         0  black dots (default)
%                     a string of one color for dots (i.e., 'g' or 'm') or a 
%                        1 x 3 color matrix  
%
%    titlestr         string with title for left hand plot (showing projected data)
%                           default is 'Sum of Squares Permutation Hypothesis Test'
%
%    titlefontsize    font size for title
%                                    (only has effect when the titlestr is nonempty)
%                           default is empty [], for Matlab default
%
%    xlabelstr        string with x axis label 
%                           default is empty string, '', for no xlabel
%
%    ylabelstr        string with y axis label 
%                           default is empty string, '', for no ylabel
%
%    data1str        string with data1 test stat label 
%                           default is 'SWISS 1'
%
%    data2str        string with data2 test stat label 
%                           default is 'SWISS 2'
%
%    labelfontsize     font size for axis labels
%                                    (only has effect when plot is made here,
%                                     and when a label str is nonempty)
%                           default is empty [], for Matlab default
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                         Will add file suffix determined by savetype
%                         Unspecified (or empty):
%                             Results only appear on screen
%
%    savetype         indicator of output file type:
%                         1 - (default)  Matlab figure file (.fig)
%                         2 - (.png)  raster graphics
%                         3 - (.pdf)  vector graphics
%                         4 - (.eps)  Color vector 
%                         5 - (.eps)  Black and White vector 
%                         6 - (.jpg)  raster
%                         7 - (.svg)  vector
%
%
% Output:
%     Graphics in current Figure, 
%         showing population of simulated pvalues 
%     When savestr exists,
%        Postscript files saved in 'savestr'.ps
%                 (color postscript for icolor ~= 0)
%                 (B & W postscript for icolor = 0)
%
%      teststat - test statistic based on ratio of within group
%                 sum of squares divided by total sum of squares
%
%      epval - empirical pvalue, based on simulated quantiles.
%                 summarizing results of permuation test
%
%      ci - 90% confidence interval of permuted population
%

% Assumes path can find personal functions:
%     cprobSM.m
%     kdeSM.m
%     cquantSM.m
%     axisSM.m
%     vec2matSM.m
%     lbinrSM.m
%     bwsjpiSM.m
%     bwosSM.m
%     bwrotSM.m
%     bwsnrSM.m
%     iqrSM
%     cquantSM
%     bwrfphSM.m
%     rootfSM

%    Copyright (c) Chris Cabanski & J. S. Marron 2009, 2023

%{
%  First set paths to find needed subroutines
%
addpath SubRoutines -end ;
%}


%  Set all parameters to defaults
%
opt = 1 ;
nsim = 1000 ;
seed = [] ;
icolor = 1 ;
dotcolor = 'k' ;
titlestr = 'Sum of Squares Permutation Hypothesis Test' ;
titlefontsize = [] ;
xlabelstr = '' ;
ylabelstr = '' ;
data1str = 'SWISS 1' ;
data2str = 'SWISS 2' ;
labelfontsize = 10 ;
savestr = [] ;
savetype = 1 ;
curve = 0 ;


if nargin < 3 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SWISSoriCC:             !!!') ;
  disp('!!!   Not enough inputs,                 !!!') ;
  disp('!!!   mdata1,                            !!!') ;
  disp('!!!   mdata2 (can be empty, i.e. = [])   !!!') ;
  disp('!!!   groups,                            !!!') ;
  disp('!!!   are all required                   !!!') ;
  disp('!!!   Terminating Execution              !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end 


%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 3    %  then paramstruct is an argument

  if isfield(paramstruct,'option')    %  then change to input value
    opt = paramstruct.option ; 
  end 

  if isfield(paramstruct,'nsim')    %  then change to input value
    nsim = paramstruct.nsim ; 
  end 

  if isfield(paramstruct,'curve')    %  then change to input value
    curve = paramstruct.curve ; 
  end 

  if isfield(paramstruct,'seed')    %  then change to input value
    seed = paramstruct.seed ; 
  end 

  if isfield(paramstruct,'icolor')    %  then change to input value
    icolor = paramstruct.icolor ; 
  end 

  if isfield(paramstruct,'dotcolor')    %  then change to input value
    dotcolor = paramstruct.dotcolor ; 
    if dotcolor == 0 
      dotcolor = 'k' ;
    end 
  end 

  if isfield(paramstruct,'titlestr')    %  then change to input value
    titlestr = paramstruct.titlestr ; 
  end 

  if isfield(paramstruct,'titlefontsize')    %  then change to input value
    titlefontsize = paramstruct.titlefontsize ; 
  end 

  if isfield(paramstruct,'xlabelstr')    %  then change to input value
    xlabelstr = paramstruct.xlabelstr ; 
  end 

  if isfield(paramstruct,'ylabelstr')    %  then change to input value
    ylabelstr = paramstruct.ylabelstr ; 
  end 

  if isfield(paramstruct,'data1str')    %  then change to input value
    data1str = paramstruct.data1str ; 
  end 

  if isfield(paramstruct,'data2str')    %  then change to input value
    data2str = paramstruct.data2str ; 
  end 

  if isfield(paramstruct,'labelfontsize')    %  then change to input value
    labelfontsize = paramstruct.labelfontsize ; 
  end 

  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstruct.savestr ; 
    if ~(ischar(savestr) || isempty(savestr))    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from SWISS.m:          !!!') ;
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

k = max(groups) ;
    if min(groups) ~= 1    %  print warning message
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from SWISS: groups labeling does not                 !!!') ; 
      disp('!!!   start at 1, returning empty outputs                          !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
%        mat = [] ;
        teststat = [] ;
        epval = [] ;
        ci = [] ;
        return ;
    end 

n = size(data1,2) ;
d1 = size(data1,1) ;


if isempty(data2)    % Only Calculate SWISS if data2 is empty

%% Calculate group means (gmean), number of elts in each group (tempn)
  gmeanA = zeros(d1,k) ;
  tempn = zeros(k,1) ;
  for i = 1:k 
    temp = zeros(d1,1) ;
    for j = 1:n 
      if groups(j) == i 
	    temp = [temp,data1(:,j)] ; %#ok<AGROW>
      end
    end
  tempn(i) = size(temp,2) - 1 ;
  rmeanA = zeros(d1,1) ;
    for m = 1:d1 
      rmeanA(m) = 0 ;
      for j = 1:tempn(i) 
	    rmeanA(m) = rmeanA(m) + temp(m,j+1) ;
      end 
      rmeanA(m) = rmeanA(m) / tempn(i) ;
    end
  centdatA = zeros(d1,tempn(i)) ;
    for m = 1:d1 
      for j = 1:tempn(i) 
        centdatA(m,j) = temp(m,j+1) - rmeanA(m) ;
      end 
    end
  gmeanA(:,i) = rmeanA ;
  end 

%% Calculate overall mean (center)
omeanA = zeros(d1,1) ;
  if opt == 1 
    for i = 1:d1 
      omeanA(i,1) = sum(data1(i,:)) / n ;
    end 
  elseif opt == 2 
    for i = 1:d1 
      omeanA(i,1) = sum(gmeanA(i,:)) / k ;
    end 
  else    %  print warning message
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from SWISS: option does not equal 1 or 2         !!!') ; 
      disp('!!!   returning empty outputs                                  !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
%        mat = [] ;
        teststat = [] ;
        epval = [] ;
        ci = [] ;
        return ;
  end 

%% Calculate distance matrices
distA = zeros(2,n) ;
  for i = 1:n 
    g = groups(i) ;
    distA(1,i) = sum((data1(:,i)-gmeanA(:,g)).^2) ;
    distA(2,i) = sum((data1(:,i)-omeanA).^2) ;
  end 

%% Calculate Ratio A
  RatioA = sum(distA(1,:)) / sum(distA(2,:)) ;
  teststat = RatioA ;
  epval = [] ;
  ci = [] ;

 
else       % Have data2, so calculate hypothesis test

  d2 = size(data2,1) ;
  if ~isempty(seed)
    rng(seed)
  end
  

%% Calculate group means (gmean), number of elts in each group (tempn)
  gmeanA = zeros(d1,k) ;
  tempn = zeros(k,1) ;
  for i = 1:k 
    temp = zeros(d1,1) ;
    for j = 1:n 
      if groups(j) == i 
	    temp = [temp,data1(:,j)] ; %#ok<AGROW>
      end
    end
  tempn(i) = size(temp,2) - 1 ;
  rmeanA = zeros(d1,1) ;
    for m = 1:d1 
      rmeanA(m) = 0 ;
      for j = 1:tempn(i) 
	    rmeanA(m) = rmeanA(m) + temp(m,j+1) ;
      end 
      rmeanA(m) = rmeanA(m) / tempn(i) ;
    end
  centdatA = zeros(d1,tempn(i)) ;
    for m = 1:d1 
      for j = 1:tempn(i) 
	    centdatA(m,j) = temp(m,j+1) - rmeanA(m) ;
      end 
    end
  gmeanA(:,i) = rmeanA ;
  end 

  gmeanB = zeros(d2,k) ;
  for i = 1:k 
    temp = zeros(d2,1) ;
    for j = 1:n 
      if groups(j) == i 
	    temp = [temp,data2(:,j)] ; %#ok<AGROW>
      end
    end
  rmeanB = zeros(d2,1) ;
    for m = 1:d2 
      rmeanB(m) = 0 ;
      for j = 1:tempn(i) 
	     rmeanB(m) = rmeanB(m) + temp(m,j+1) ;
      end 
      rmeanB(m) = rmeanB(m) / tempn(i) ;
    end
  centdatB = zeros(d2,tempn(i)) ;
    for m = 1:d2 
      for j = 1:tempn(i) 
	    centdatB(m,j) = temp(m,j+1) - rmeanB(m) ;
      end 
    end
  gmeanB(:,i) = rmeanB ;
  end 

%% Calculate overall mean (center)
omeanA = zeros(d1,1) ;
omeanB = zeros(d2,1) ;
  if opt == 1 
    for i = 1:d1 
      omeanA(i,1) = sum(data1(i,:)) / n ;
    end 
    for i = 1:d2 
      omeanB(i,1) = sum(data2(i,:)) / n ;
    end 
  elseif opt == 2 
    for i = 1:d1 
      omeanA(i,1) = sum(gmeanA(i,:)) / k ;
    end 
    for i = 1:d2 
      omeanB(i,1) = sum(gmeanB(i,:)) / k ;
    end 
  else    %  print warning message
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from SSHypoTestCC: option does not equal 1, 2, or 3  !!!') ; 
      disp('!!!   returning empty matrix                                       !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
%        mat = [] ;
        teststat = [] ;
        epval = [] ;
        ci = [] ;
        return ;
  end 
	

%% Calculate distance matrices
distA = zeros(2,n) ;
distB = zeros(2,n) ;
  for i = 1:n 
    g = groups(i) ;
    distA(1,i) = sum((data1(:,i)-gmeanA(:,g)).^2) ;
    distB(1,i) = sum((data2(:,i)-gmeanB(:,g)).^2) ;
    distA(2,i) = sum((data1(:,i)-omeanA).^2) ;
    distB(2,i) = sum((data2(:,i)-omeanB).^2) ;
  end 


%% Calculate Ratio A and B
  RatioA = sum(distA(1,:)) / sum(distA(2,:)) ;
  RatioB = sum(distB(1,:)) / sum(distB(2,:)) ;

%% Standardize Matrices
   distA = distA / sum(distA(2,:)) ;
   distB = distB / sum(distB(2,:)) ;

%% Calculate Permuted Population of Ratios

  perm = rand(nsim,n) ;
%  ratio = [] ;
  ratio = zeros(nsim,1) ;

  for i = 1:nsim 
    pdata = zeros(2,n) ;
    for j = 1:n 
      if perm(i,j) < 0.5 
        pdata(:,j) = distA(:,j) ;
      else 
        pdata(:,j) = distB(:,j) ;
      end 
    end 
    ratio(i) = sum(pdata(1,:)) / sum(pdata(2,:)) ;
  end 

  if RatioA > RatioB 
      epvalA = 1 - cprobSM(ratio,RatioA,1) ;      
      epvalB = cprobSM(ratio,RatioB,1) ;    
    else 
      epvalA = cprobSM(ratio,RatioA,1) ;      
      epvalB = 1 - cprobSM(ratio,RatioB,1) ;    
  end 

  left = cquantSM(ratio,0.05,1) ;
  right = cquantSM(ratio,0.95,1) ;

  epval = [epvalA epvalB] ;
  teststat = [RatioA RatioB] ;
  ci = [left, right] ;

%% Plot results

  vax = axisSM([ratio; RatioA; RatioB]) ;

if curve == 0      % kde curve

    kdeparamstruct = struct('vxgrid',vax, ...
                          'linecolor',dotcolor, ...
                          'dolcolor',dotcolor, ...
                          'titlestr',titlestr, ...
                          'markerstr','.',...
                          'titlefontsize',titlefontsize, ...
                          'xlabelstr',xlabelstr, ...
                          'ylabelstr',ylabelstr, ...
                          'labelfontsize',labelfontsize) ;


  kdeSM(ratio,kdeparamstruct) ;

elseif  curve == 1  |  curve == 2   

  m = mean(ratio) ;
  sd = std(ratio) ;
  x = vax(1):(vax(2)-vax(1))/100:vax(2) ;
  y = normpdf(x,m,sd) ;
  
  hold on ;
     vax2 = axisSM(y) ;
     hts = (0.5 + 0.1 * rand(nsim,1)) * vax2(2) ;
   axis([vax vax2]) ;
   plot(ratio,hts,'.','Color',dotcolor) ;
   if ~isempty(titlefontsize) 
     title(titlestr,'FontSize',titlefontsize) ;
   else
     title(titlestr) ;
   end 
   xlabel(xlabelstr,'FontSize',labelfontsize) ;
   ylabel(ylabelstr,'FontSize',labelfontsize) ;

  if curve == 1    % gaussian curve

    plot(x,y,'Color',dotcolor,'LineWidth',2) ;

  end 
  

end 

  vax = axis ;
  hold on ;
   if icolor == 0 
    plot([RatioA RatioA], [vax(3) vax(4)], 'k-', 'LineWidth',1.5) ;
    plot([RatioB RatioB], [vax(3) vax(4)], 'k-', 'LineWidth',1.5) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         [data1str ' = ' num2str(RatioA)],...
         'Color','k','FontSize',labelfontsize) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         [data2str ' = ' num2str(RatioB)],...
         'Color','k','FontSize',labelfontsize) ;
    text(vax(1) + 0.7 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Empirical pval = ' num2str(epvalA,'%.2f')],...
         'Color','k','FontSize',labelfontsize) ;
    text(vax(1) + 0.7 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Empirical pval = ' num2str(epvalB,'%.2f')],...
         'Color','k','FontSize',labelfontsize) ;
   else 
    plot([RatioA RatioA], [vax(3) vax(4)], 'r-', 'LineWidth',1.5) ;
    plot([RatioB RatioB], [vax(3) vax(4)], 'b-', 'LineWidth',1.5) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         [data1str ' = ' num2str(RatioA)],...
         'Color','r','FontSize',labelfontsize) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         [data2str ' = ' num2str(RatioB)],...
         'Color','b','FontSize',labelfontsize) ;
    text(vax(1) + 0.7 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Empirical pval = ' num2str(epvalA,'%.2f')],...
         'Color','r','FontSize',labelfontsize) ;
   text(vax(1) + 0.7 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Empirical pval = ' num2str(epvalB,'%.2f')],...
         'Color','b','FontSize',labelfontsize) ;
   end 
  hold off ;


  %  Save graphical output (if needed)
  %
  if ~isempty(savestr)    %  then create postscript file

    printSM(savestr,savetype) ;

  end 


end 
