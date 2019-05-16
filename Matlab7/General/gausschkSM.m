function gausschkSM(mdat,paramstruct) 
% GAUSSCHK, Check's goodness of fit of multivariate Gaussian distribution
%      to functional data (where "curves are data")
%      Views include parallel coordinate views of marginals
%      Combined Q-Q plot of morginals
%      (might add ICA approach to joint distributions,
%       via "directions of maximal non-Gaussianity")
%   Steve Marron's matlab function
% Inputs:
%   mdat        - d x n matrix of multivariate data
%                         (each col is a data vector, i.e. digitized curve)
%                         d = dimension of each data vector
%                         n = number of data vectors 
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1,...
%                            'field2',values2,...
%                                             ) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%    fields            values
%
%    viout            vector of indices 0 or 1 for various types of output
%                                   1 in a given entry will include that 
%                                   in output structure
%                     Entry 1:  Parallel Coordinate Plots  
%                                   Shows raw data, mean centered,
%                                   and standardized versions
%                     Entry 2:  Overlay of Q-Q plots
%                                   of standardized data,
%                                   with simulated envelope
%                     Entry 3:  (not working yet) ICA based investigation of
%                                   directions of "maximal non-Gaussianity"
%                         When viout has length < 10, will pad with 0's
%                         Default is [1, 1]
%
%    icolor           0  fully black and white version (everywhere)
%                     1  (default)  color version (Matlab defaults)
%                     2  time series version (ordered spectrum of colors)
%                     nx3 color matrix:  a color label for each data point
%                             (to be used everywhere, except SiZer & QQ,
%                              useful for comparing classes)
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory,
%                         will add .ps, and save as either
%                              color postscript (icolor = 1)
%                         or
%                              black&white postscript (when icolor = 0)
%                     unspecified:  results only appear on screen
%
%    istd             Standardization method:
%                         0 - Assume data already standardized,
%                                 so leave as is.
%                         1 - (default) Standard
%                                 Subtract mean (each coordinate), 
%                                 divide by standard deviation
%                         2 - Robust
%                                 Subtract median (each coordinate), 
%                                 divide by (Gaussian normalized) MAD
%
%    PCtitlestr1      Parallel Coordinate plot title for raw data
%                                 (default is 'Parallel Coord. Plot, Raw Data')
%
%    PCtitlestr2      Parallel Coordinate plot title for raw data
%                                 (default is 'Centered Data')
%
%    PCtitlestr3      Parallel Coordinate plot title for raw data
%                                 (default is 'Standardized Data')
%
%    PCtitlefontsize    Font Size for title (uses Matlab default)
%                                   (15 is "fairly large")
%
%    QQnsim           number of psuedo data sets to simulate in QQ-plot,
%                              to display random variability
%                     (default = 100)
%                     0  no simulation, only straight QQ plot
%                         Note:  this creates an n x nsim matrix.
%                                When this is too big for memory, 
%                                then use a negative value (e.g. -100),
%                                for a slow, one at a time computation
%
%    QQsimseed        seed for simulated overlay in Q-Q plot 
%                                (to display randomness)
%                         default is [] (for using current Matlab seed) 
%                                (should be an integer with <= 8 digits)
%
%    QQnsimplotval    number of values to use in Q-Q plot display of
%                     simulated versions to assess variability
%                     (useful to speed graphics with large
%                      sample sizes, uses nsimplotval/3 values
%                      at each end, and the rest equally spaced
%                      in the middle, ignored when ndata is
%                      smaller or when nsim = 0)
%                     0  use default nsimplotval = 900
%                         (tests suggest:
%                              3000  "no visual difference"
%                              900   "small visual difference"
%                              300   "larger visual difference"
%
%    QQtitlestr       Q-Q plot title (default is 'Q-Q Plot')
%
%    QQtitlefontsize    Font Size for title (uses Matlab default)
%                                   (18 is "fairly large")
%
%    QQxlabelstr        String for labeling x axes in Q-Q plot
%                                  (default is Dist. Name + Q')
%
%    QQylabelstr        String for labeling y axes in Q-Q plot 
%                                  (default is 'Data Q')
%
%    QQlabelfontsize    Font Size for axis labels of Q-Q plot 
%                                  (uses Matlab default)
%                                  (18 is "fairly large")
%
%    QQleft           left end of plot range in Q-Q plot
%                             (default is min of standardized data)
%
%    QQright          right end of plot range in Q-Q plot
%                             (default is max of standardized data)
% 
%    QQbottom         bottom of plot range in Q-Q plot
%                             (default is min of standardized data)
%
%    QQtop            top of plot range in Q-Q plot
%                             (default is max of standardized data)
% 
%    QQioverlay       0  no overlay line in QQ plot
%                     1  (default) overlay 45 degree line
%                     2  overlay least squares fit line
%
%    iscreenwrite     0  (default)  don't write progress to screen
%                     1  write messages to screen to show progress
%
%
% Outputs:
%     Graphics, will create a new Figure for each output,
%         depending on iout
%
% Assumes path can find personal functions:
%    vec2matSM.m
%    madSM.m
%    axisSM.m

%    Copyright (c) J. S. Marron 2004



%  First set parameters to defaults
%
viout = [1, 1] ;
icolor = 1 ;
savestr = [] ;
istd = 1 ;
PCtitlestr1 = 'Parallel Coord. Plot, Raw Data' ;
PCtitlestr2 = 'Centered Data' ;
PCtitlestr3 = 'Standardized Data' ;
PCtitlefontsize = [] ;
QQnsim = 100 ;
QQsimseed = [] ;
QQnsimplotval = 900 ;
QQtitlestr = 'Q-Q Plot' ;
QQtitlefontsize = [] ;
QQxlabelstr = ', Q' ;
QQylabelstr = 'Data Q' ;
QQlabelfontsize = [] ;
QQleft = [] ;
QQright = [] ;
QQbottom = [] ;
QQtop = [] ;
QQioverlay = 1 ;
iscreenwrite = 0 ;



%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1 ;   %  then paramstruct has been added

  if isfield(paramstruct,'iout') ;    %  then change to input value
    iout = getfield(paramstruct,'iout') ; 
  end ;

  if isfield(paramstruct,'icolor') ;    %  then change to input value
    icolor = getfield(paramstruct,'icolor') ; 
  end ;

  if isfield(paramstruct,'savestr') ;    %  then change to input value
    savestr = getfield(paramstruct,'savestr') ; 
    if ~ischar(savestr) ;    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from gausschkSM.m:   !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end ;
  end ;

  if isfield(paramstruct,'PCtitlestr1') ;    %  then change to input value
    PCtitlestr1 = getfield(paramstruct,'PCtitlestr1') ; 
  end ;

  if isfield(paramstruct,'PCtitlestr2') ;    %  then change to input value
    PCtitlestr2 = getfield(paramstruct,'PCtitlestr2') ; 
  end ;

  if isfield(paramstruct,'PCtitlestr3') ;    %  then change to input value
    PCtitlestr3 = getfield(paramstruct,'PCtitlestr3') ; 
  end ;

  if isfield(paramstruct,'PCtitlefontsize') ;    %  then change to input value
    PCtitlefontsize = getfield(paramstruct,'PCtitlefontsize') ; 
  end ;

  if isfield(paramstruct,'QQnsim') ;    %  then change to input value
    QQnsim = getfield(paramstruct,'QQnsim') ; 
  end ;

  if isfield(paramstruct,'QQsimseed') ;    %  then change to input value
    QQsimseed = getfield(paramstruct,'QQsimseed') ; 
  end ;

  if isfield(paramstruct,'QQnsimplotval') ;    %  then change to input value
    QQnsimplotval = getfield(paramstruct,'QQnsimplotval') ; 
  end ;

  if isfield(paramstruct,'QQtitlestr') ;    %  then change to input value
    QQtitlestr = getfield(paramstruct,'QQtitlestr') ; 
  end ;

  if isfield(paramstruct,'QQtitlefontsize') ;    %  then change to input value
    QQtitlefontsize = getfield(paramstruct,'QQtitlefontsize') ; 
  end ;

  if isfield(paramstruct,'QQxlabelstr') ;    %  then change to input value
    QQxlabelstr = getfield(paramstruct,'QQxlabelstr') ; 
  end ;

  if isfield(paramstruct,'QQylabelstr') ;    %  then change to input value
    QQylabelstr = getfield(paramstruct,'QQylabelstr') ; 
  end ;

  if isfield(paramstruct,'QQlabelfontsize') ;    %  then change to input value
    QQlabelfontsize = getfield(paramstruct,'QQlabelfontsize') ; 
  end ;

  if isfield(paramstruct,'QQleft') ;    %  then change to input value
    QQleft = getfield(paramstruct,'QQleft') ; 
  end ;

  if isfield(paramstruct,'QQright') ;    %  then change to input value
    QQright = getfield(paramstruct,'QQright') ; 
  end ;

  if isfield(paramstruct,'QQbottom') ;    %  then change to input value
    QQbottom = getfield(paramstruct,'QQbottom') ; 
  end ;

  if isfield(paramstruct,'QQtop') ;    %  then change to input value
    QQtop = getfield(paramstruct,'QQtop') ; 
  end ;

  if isfield(paramstruct,'QQioverlay') ;    %  then change to input value
    QQioverlay = getfield(paramstruct,'QQioverlay') ; 
  end ;

  if isfield(paramstruct,'iscreenwrite') ;    %  then change to input value
    iscreenwrite = getfield(paramstruct,'iscreenwrite') ; 
  end ;

else ;   %  create a dummy structure

  paramstruct = struct('nothing',[]) ;

end ;  %  of resetting of input parameters



%  Readjust viout as needed
%
maxviout = 3 ;
    %  largest useful size for viout 
if size(viout,1) > 1 ;    %  if have more than one row
  viout = viout' ;
end ;
if size(viout,1) == 1 ;    %  then have row vector

  if length(viout) < maxviout ;    %  then pad with 0s
    viout = [viout zeros(1,maxviout - length(viout))] ;
  end ;

else ;    %  invalid viout, so indicate and quit

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from gausschkSM:  !!!') ;
  disp('!!!   Invalid viout           !!!') ;
  disp('!!!   Terminating exceution   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;

end ;



%  get dimensions from data matrix
%
d = size(mdat,1) ;
          %  dimension of each data vector (col)
n = size(mdat,2) ;
          %  number of data vectors (cols)



%  Set up appropriate colors
%
if  size(icolor,1) == 1   &  size(icolor,2) == 1 ;    %  then have scalar input

  if icolor == 0 ;    %  then do everything black and white

    datacolor = 'k' ;
    meancolor = 'k' ;
    sdcolor = 'k' ;

    indivcolorflag = 0 ;
    icolorprint = 0 ;

  elseif icolor == 1 ;    %  then do full color 

    datacolor = [] ;    % use default matlab mixed colors
    meancolor = 'k' ;
    sdcolor = 'k' ;

    indivcolorflag = 0 ;
    icolorprint = 1 ;

  elseif icolor == 2 ;    %  then do spectrum for ordered time series

    %  set up color map stuff
    %
    %  1st:    R  1      G  0 - 1    B  0
    %  2nd:    R  1 - 0  G  1        B  0
    %  3rd:    R  0      G  1        B  0 - 1
    %  4th:    R  0      G  1 - 0    B  1
    %  5th:    R  0 - 1  G  0        B  1

    nfifth = ceil((n - 1) / 5) ;
    del = 1 / nfifth ;
    vwt = (0:del:1)' ;
    colmap = [flipud(vwt), zeros(nfifth+1,1), ones(nfifth+1,1)] ;
    colmap = colmap(1:size(colmap,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmap = [colmap; ...
              [zeros(nfifth+1,1), vwt, ones(nfifth+1,1)]] ;
    colmap = colmap(1:size(colmap,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmap = [colmap; ...
              [zeros(nfifth+1,1), ones(nfifth+1,1), flipud(vwt)]] ;
    colmap = colmap(1:size(colmap,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmap = [colmap; ...
              [vwt, ones(nfifth+1,1), zeros(nfifth+1,1)]] ;
    colmap = colmap(1:size(colmap,1)-1,:) ;
          %  cutoff last row to avoid having it twice
    colmap = [colmap; ...
              [ones(nfifth+1,1)], flipud(vwt), zeros(nfifth+1,1)] ;

          %  note: put this together upside down


    meancolor = 'k' ;
    sdcolor = 'k' ;

    indivcolorflag = 1 ;
    icolorprint = 1 ;

  end ;


elseif  size(icolor,2) == 3  ;    %  then have valid color matrix

  colmap = icolor ;

  meancolor = 'k' ;
  sdcolor = 'k' ;

  indivcolorflag = 1 ;
  icolorprint = 1 ;

else ;    %   invalid color matrix input

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from GaussChkSM.m:            !!!') ;
  disp('!!!   Invalid icolor input,               !!!') ;
  disp('!!!   must be a scalar, or color matrix   !!!') ;
  disp('!!!   Terminating execution               !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;

end ;



%  Standardize Data (if needed) 
%
if istd == 0 ;    %  assume already standardized

  mdatc = mdat ;
  mdats = mdat ;

elseif istd == 1 ;    %  do mean - sd standardization

  mdatc = mdat - vec2matSM(mean(mdat,2),n) ;
  mdats = mdatc ./ vec2matSM(std(mdatc,0,2),n) ;

elseif istd == 2 ;    %  do median - MAD standardization

  mdatc = mdat - vec2matSM(median(mdat,2),n) ;
  mdats = mdatc ./ vec2matSM(madSM(mdatc')',n) ;
      %  Notes: madSM gives the MAD of each COLUMN, 
      %      hence did double transpose,
      %      output is on scale of standard deviation

end ;    %  of istd if-block



%  make main outputs
%
figcount = 0 ;
if viout(1) == 1 ;    %  Then make parallel coordinate plots

  figcount = figcount + 1 ;
  figure(figcount) ;

  if iscreenwrite == 1 ;
    disp('  Making parallel coordinates plot') ;
  end ;


  if indivcolorflag == 0 ;    %  then can plot everything with global colors

    subplot(3,1,1) ;
      plot((1:d)',mdat,[datacolor '-']) ;
        if ~isempty(PCtitlestr1) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr1) ;
          else ;
            title(PCtitlestr1,'FontSize',PCtitlefontsize) ;
          end ;
        end ;
        vax = axisSM(mdat) ;
        axis([0.5,d+0.5,vax(1),vax(2)]) ;

    subplot(3,1,2) ;
      plot((1:d)',mdatc,[datacolor '-']) ;
        if ~isempty(PCtitlestr2) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr2) ;
          else ;
            title(PCtitlestr2,'FontSize',PCtitlefontsize) ;
          end ;
        end ;
        vaxc = axisSM(mdatc) ;
        axis([0.5,d+0.5,vaxc(1),vaxc(2)]) ;
        hold on ;
          plot([0; (d+1)],[0; 0],'-','Color',meancolor,'LineWidth',2) ;
        hold off ;

    subplot(3,1,3) ;
      plot((1:d)',mdats,[datacolor '-']) ;
        if ~isempty(PCtitlestr3) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr3) ;
          else ;
            title(PCtitlestr3,'FontSize',PCtitlefontsize) ;
          end ;
        end ;
        vaxs = axisSM(mdats) ;
        axis([0.5,d+0.5,vaxs(1),vaxs(2)]) ;
        hold on ;
          plot([0; (d+1)],[0; 0],'-','Color',meancolor,'LineWidth',2) ;
          plot([zeros(1,3) ; (d+1) * ones(1,3)], ...
               [-1.96 * ones(2,1), zeros(2,1), 1.96 * ones(2,1)], ...
               '--','Color',sdcolor,'LineWidth',2) ;
        hold off ;


  elseif indivcolorflag == 1 ;    %  then need to do individual 
                                  %  plots and colors


    subplot(3,1,1) ;
      plot((1:d)',mdat(:,1),'-','Color',colmap(1,:)) ;
        vax = axisSM(mdat) ;
        axis([0.5,d+0.5,vax(1),vax(2)]) ;
        hold on ;
          for idat = 2:n ;
            plot((1:d)',mdat(:,idat),'-','Color',colmap(idat,:)) ;
          end ;
        hold off ;
        if ~isempty(PCtitlestr1) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr1) ;
          else ;
            title(PCtitlestr1,'FontSize',PCtitlefontsize) ;
          end ;
        end ;

    subplot(3,1,2) ;
      plot((1:d)',mdatc(:,1),'-','Color',colmap(1,:)) ;
        vaxc = axisSM(mdatc) ;
        axis([0.5,d+0.5,vaxc(1),vaxc(2)]) ;
        hold on ;
          for idat = 2:n ;
            plot((1:d)',mdatc(:,idat),'-','Color',colmap(idat,:)) ;
          end ;
        hold off ;
        if ~isempty(PCtitlestr2) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr2) ;
          else ;
            title(PCtitlestr2,'FontSize',PCtitlefontsize) ;
          end ;
        end ;
        hold on ;
          plot([0; (d+1)],[0; 0],'-','Color',meancolor,'LineWidth',2) ;
        hold off ;

    subplot(3,1,3) ;
      plot((1:d)',mdats(:,1),'-','Color',colmap(1,:)) ;
        vaxs = axisSM(mdats) ;
        axis([0.5,d+0.5,vaxs(1),vaxs(2)]) ;
        hold on ;
          for idat = 2:n ;
            plot((1:d)',mdats(:,idat),'-','Color',colmap(idat,:)) ;
          end ;
        hold off ;
        if ~isempty(PCtitlestr3) ;
          if isempty(PCtitlefontsize) ;
            title(PCtitlestr3) ;
          else ;
            title(PCtitlestr3,'FontSize',PCtitlefontsize) ;
          end ;
        end ;
        hold on ;
          plot([0; (d+1)],[0; 0],'-','Color',meancolor,'LineWidth',2) ;
          plot([zeros(1,3) ; (d+1) * ones(1,3)], ...
               [-1.96 * ones(2,1), zeros(2,1), 1.96 * ones(2,1)], ...
               '--','Color',sdcolor,'LineWidth',2) ;
        hold off ;


  end ;    %  of indivcolorflag if-block



  %  Save results (if needed)
  %
  if ~isempty(savestr) ;     %  then save results

    if iscreenwrite == 1 ;
      disp('    gausschkSM.m saving Para. Coor. results') ;
    end ;

    orient tall ;

    if icolorprint ~= 0 ;     %  then make color postscript
      print('-dpsc', [savestr '.ps']) ;
    else ;                %  then make black and white
      print('-dps', [savestr '.ps']) ;
    end ;

    if iscreenwrite == 1 ;
      disp('    gausschkSM.m finished Para. Coor. save') ;
      disp('  ') ;
    end ;

  end ;



end ;    %  of Parallel Coordinate Plot if-block




if viout(2) == 1 ;    %  Then make Q-Q plot

  figcount = figcount + 1 ;
  figure(figcount) ;

  if iscreenwrite == 1 ;
    disp('  Making joint Q-Q plot') ;
  end ;


  if QQleft == [] ;
    QQleft = min(min(mdats)) ;
  end ; 

  if QQright == [] ;
    QQright = max(max(mdats)) ;
  end ; 

  if QQbottom == [] ;
    QQbottom = min(min(mdats)) ;
  end ; 

  if QQtop == [] ;
    QQtop = max(max(mdats)) ;
  end ; 


  %  Set internal parameters
  %
  if icolor == 0 ;
    colorcell = {'k' 'k' [0.2 0.2 0.2]} ;
    ltypestr = '--' ;
    simltypestr = ':' ;
  else ;
    colorcell = {'r' 'g' 'b'} ;
            %  1st - data
            %  2nd - line
            %  3rd - simulated versions
    ltypestr = '-' ;
    simltypestr = '-' ;
  end ;
  paramout = [] ;


  %  Get data quantiles
  qdata = sort(mdats',1) ;
            %  transpose puts vector entries into columns
            %  sort puts them in increasing order


  %  Get theoretical quantiles
  %
  pgrid = (1:n)' / (n + 1) ;
  ididqalign = 0 ;

  diststr = 'Standard Gaussian' ;

  mu = 0 ;
  sigma = 1 ;

  qtheory = mu + sigma * norminv(pgrid) ;


  if iscreenwrite == 1 ;
    disp(['   Comparing with ' diststr ' distribution']) ;
  end;


  if strcmp(QQxlabelstr,', Q') ;    %  default value
    QQxlabelstr = [diststr, QQxlabelstr] ;
  end ;


  if ~isfield(paramstruct,'QQleft') ;    %  then change to theoretical left
    QQleft = min(qtheory) ; 
  end ;

  if ~isfield(paramstruct,'QQright') ;    %  then change to theoretical right
    QQright = max(qtheory) ; 
  end ;


  %  Make main graphic in current axes
  %
  plot(qtheory,qdata, ...
      [colorcell{1} '-'], ...
      'LineWidth',1) ;
    axis equal ;
    axis([QQleft,QQright,QQbottom,QQtop]) ;

    th = title(QQtitlestr) ;
    if ~isempty(QQtitlefontsize) ;
      set(th,'FontSize',QQtitlefontsize) ;
    end ;

    xlh = xlabel(QQxlabelstr) ;    
    ylh = ylabel(QQylabelstr) ;    
    if ~isempty(QQlabelfontsize) ;
      set(xlh,'FontSize',QQlabelfontsize) ;
      set(ylh,'FontSize',QQlabelfontsize) ;
    end ;


  %  Add lines (if needed)
  %
  if QQioverlay == 1 ;    %  then overlay 45 degree line
    minmin = min(QQleft,QQbottom) ;
    maxmax = max(QQright,QQtop) ;
    hold on ;
      plot([minmin,maxmax],[minmin,maxmax], ...
           [colorcell{2} ltypestr], ...
           'LineWidth',2) ;
    hold off ;

  elseif QQioverlay == 2 ;    %  then overlay least squares fit line
    minmin = min(QQleft,QQbottom) ;
    maxmax = max(QQright,QQtop) ;
    lincoeffs = polyfit(qtheory,qdata,1) ;
            %  coefficients of simple least squares fit
    lineval = polyval(lincoeffs,[minmin;maxmax]) ;
    hold on ;
      plot([minmin;maxmax],lineval, ...
           [colorcell{2} ltypestr], ...
           'LineWidth',2) ;
    hold off ; 

  end ;


  %  Add simulated realizations (if needed)
  %
  if QQnsim > 0 ;

    if iscreenwrite == 1 ;
      disp('      generating simulated data') ;
    end ;


    if ~isempty(QQsimseed) ;
      randn('seed',QQsimseed) ;
    end ;
          %  set seed
    msimdat = mu + sigma * randn(n,QQnsim) ;


    if iscreenwrite == 1 ;
      disp('      sorting simulated data') ;
    end ;
    msimdat = sort(msimdat) ;
            %  sort each column


    if QQnsimplotval < n ;    %  then get reduced version for 
                            %  efficient plotting

      nspvo3 = floor(QQnsimplotval / 3) ;
            %  one third of total, to put at each end
      vindleft = (1:nspvo3)' ;
            %  left end  (include all)
      vindright = ((n-nspvo3+1):n)' ;
            %  right end  (include all)

      nspvlo = QQnsimplotval - length(vindleft) ...
                           - length(vindright) ;
            %  number of grid points left over (for use in middle)
      vindmid = round(linspace(nspvo3+1,n-nspvo3,nspvlo)') ;

      vind = [vindleft; vindmid; vindright] ;
            %  vector of indices, full

      qtheoryp = qtheory(vind,:) ;
      msimdatp = msimdat(vind,:) ;

    else ;  

      qtheoryp = qtheory ;
      msimdatp = msimdat ;

    end ;


    hold on  ;
      plot(qtheoryp,msimdatp,simltypestr,'Color',colorcell{3}) ;

      %  replot important stuff
      %
      plot(qtheory,qdata, ...
           [colorcell{1} '-'], ...
           'LineWidth',1) ;
      if QQioverlay == 1 ;    %  then overlay 45 degree line
        plot([minmin,maxmax],[minmin,maxmax], ...
             [colorcell{2} ltypestr], ...
             'LineWidth',2) ;
      elseif QQioverlay == 2 ;    %  then overlay least squares fit line
        plot([minmin;maxmax],lineval, ...
             [colorcell{2} ltypestr], ...
             'LineWidth',2) ;
      end ;


    hold off ;


  elseif QQnsim < 0 ;    %  then compute and plot these individually
                       %  to avoid memory problems


    if ~isempty(QQsimseed) ;
      randn('seed',QQsimseed) ;
    end ;
        %  set seed

    pnsim = abs(QQnsim) ;    %  positive version of number to simulate
  
    for isim = 1:pnsim ;    %  loop through simulation steps

      if iscreenwrite == 1 ;
        disp(['      working on simulated data set ' num2str(isim) ...
                                              ' of ' num2str(pnsim)]) ;
      end ;

      vsimdat = mu + sigma * randn(n,1) ;
      vsimdat = sort(vsimdat) ;
            %  sort this column


      if QQnsimplotval < n ;    %  then get reduced version for 
                              %  efficient plotting

        nspvo3 = floor(QQnsimplotval / 3) ;
              %  one third of total, to put at each end
        vindleft = (1:nspvo3)' ;
              %  left end  (include all)
        vindright = ((n-nspvo3+1):n)' ;
              %  right end  (include all)

        nspvlo = QQnsimplotval - length(vindleft) ...
                             - length(vindright) ;
              %  number of grid points left over (for use in middle)
        vindmid = round(linspace(nspvo3+1,n-nspvo3,nspvlo)') ;

        vind = [vindleft; vindmid; vindright] ;
              %  vector of indices, full

        qtheoryp = qtheory(vind,:) ;
        vsimdatp = vsimdat(vind,:) ;

      else ;  

        qtheoryp = qtheory ;
        vsimdatp = vsimdat ;

      end ;

      hold on  ;
        plot(qtheoryp,vsimdatp,simltypestr,'Color',colorcell{3}) ;
      hold off ;

    end ;    %  of loop through simulated data sets


    %  replot important stuff
    %
    hold on ;
      plot(qtheory,qdata, ...
           [colorcell{1} '-'], ...
           'LineWidth',1) ;
      if QQioverlay == 1 ;    %  then overlay 45 degree line
        plot([minmin,maxmax],[minmin,maxmax], ...
             [colorcell{2} ltypestr], ...
             'LineWidth',2) ;
      elseif QQioverlay == 2 ;    %  then overlay least squares fit line
        plot([minmin;maxmax],lineval, ...
             [colorcell{2} ltypestr], ...
             'LineWidth',2) ;
      end ;
    hold off ;

  end ;    %  of simulated data if block


  %  Save results (if needed)
  %
  if ~isempty(savestr) ;     %  then save results

    if iscreenwrite == 1 ;
      disp('    gausschkSM.m saving Q-Q results') ;
    end ;

    orient tall ;

    if icolorprint ~= 0 ;     %  then make color postscript
      print('-dpsc', [savestr 'QQ.ps']) ;
    else ;                %  then make black and white
      print('-dps', [savestr 'QQ.ps']) ;
    end ;

    if iscreenwrite == 1 ;
      disp('    gausschkSM.m finished Q-Q save') ;
      disp('  ') ;
    end ;

  end ;


end ;    %  of QQ plot if-block








