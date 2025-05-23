disp('Running MATLAB script file bwsjpiSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION bwsjpiSM,
%    Sheather Jones Plug In bandwidth (binned)
%    Compares results to those from GAUSS program NMSJPI.TST

itest = 4 ;   %  1,2  (test against old GAUSS implementation, etc.)
              %  3    (look carefully at default h range, for real data)            
              %  4    (look carefully at default h range, for nm data)            

%    Last two tests suggest that bandwidth range is an adequate default,
%    since only time was out of range was for:
%        Ray's dust data (VERY challenging, since so "discrete")
%        #16 Distant Bimodal, n = 1000,10000 (very challenging
%              since "sd" is so noninformative).

format compact ;


if itest <= 2 ;
  format long ;

  %  Read in test data:
  load C:\Users\marron\Documents\Research\MatlabSoftware\gauss\steve\nmstuff\tests\nmsjpi.dat ;
          %  assumes this ascii file is in the current directory
          %  (usually lives in \gauss\steve\nmstuff\tests)
  data = nmsjpi ;
          %  recall thsi load uses the filename for the variable


  %  Old value, copied from NMSJPI.OUT
  osjpi = 0.20792378354257 ;


  %  Get new value
  if itest == 1 ;       %  Just do quick default SJPI
    nsjpi = bwsjpiSM(data) ;
    %  Also throw in the binned outside version:
    bcts = lbinrSM(data,0) ;
    pbsjpi = bwsjpiSM(bcts,[min(data),max(data)],0,-1) ;
  elseif itest == 2 ;   %  Pay more attention to getting xgrid right
    nsjpi = bwsjpiSM(data,[-4,4,401],0,0,0) ;
    %  Also throw in the binned outside version:
    bcts = lbinrSM(data,[-4,4,401]) ;
    pbsjpi = bwsjpiSM(bcts,[-4,4,401],0,-1) ;
  end ;


  %  Compare:
  disp('Old SJPI was:') ;
  osjpi

  disp('New SJPI was:') ;
  nsjpi

  disp('Prebinned SJPI was:') ;
  nsjpi


elseif itest == 3 ;    %  Then do real data examples

  vidat = [1:10] ;
                     %  1 - Income Data
                     %  2 - Geyser Data
                     %  3 - Stamp Data
                     %  4 - Chondrite Data
                     %  5 - Buffalo Snowfall Data
                     %  6 - Suicide Data
                     %  7 - Coal Seam Data
                     %  8 - Marine Data
                     %  9 - Dust Data
                     %  10 - Galactic Cluster Data


  for idat = vidat ;

    figure(1) ;
    clf ;

    if idat == 1 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\incomes' ;
      vrange = [0;3] ;
    elseif idat == 2 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\geyser' ;
      vrange = [] ;
    elseif idat == 3 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\stamps' ;
      vrange = [] ;
    elseif idat == 4 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\chondrit' ;
      vrange = [] ;
    elseif idat == 5 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\snowfall' ;
      vrange = [] ;
    elseif idat == 6 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\suicides' ;
      vrange = [] ;
    elseif idat == 7 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\coalseam' ;
      vrange = [] ;
    elseif idat == 8 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\fredmari' ;
      vrange = [] ;
    elseif idat == 9 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\raydust' ;
      vrange = [] ;
    elseif idat == 10 ;
      matfilestr = 'C:\Users\marron\Documents\Research\GeneralData\galaxy' ;
      vrange = [] ;
    end ;


    load(matfilestr) ;

    disp(['  Working on ' dtitstr ' Data']) ;
    disp(dcomments) ;
    disp(['    Read in ' num2str(length(data)) ' data points']) ;



    hsjpi = bwsjpiSM(data) ;
    
    titstr = [dtitstr ' Data, h_{SJPI} = ' num2str(hsjpi)] ;
    paramstruct = struct('vh',hsjpi, ...
                         'titlestr',titstr, ...
                         'xlabelstr',xstr, ...
                         'ylabelstr',ystr) ;
    if length(vrange) == 2 ;
      paramstruct = setfield(paramstruct,'vxgrid',vrange) ;
    end ;
    kdeSM(data,paramstruct) ;


    pauseSM

  end ;


elseif itest == 4 ;    %  Then do normal mixture examples

  %  Load Normal mixtures parameters from nnpar.mat
  %  !!!   Careful:  file nmpar.mat needs to be in the current directory  !!!
  %  Then all parameter matrices are in current directory
%  load nmpar.mat
  load C:\Users\marron\Documents\Research\GeneralData\nmstuff\nmpar.mat

  figure(1) ;

  %  Loop through distributions
  idiste = 16 ;
  for idist = 1:idiste ;
    eval(['parmat = nmpar' num2str(idist) ' ;']) ;
    eval(['titstr = nmtit' num2str(idist) ' ;']) ;
    disp(['    Working on ' titstr]) ;

    clf ;
    xgrid = linspace(-3,3,401)' ;
    f = nmfSM(xgrid,parmat) ;
    plot(xgrid,f,'k','LineWidth',3) ;
      title(['#' num2str(idist) ' ' titstr]) ;
      vax = axis ;

      disp('Any key to continue') ;
      pauseSM ;

    hold on ;
    for inobs = 2:4 ;
      nobs = 10^inobs ;
      disp(['      Working on n = ' num2str(nobs)]) ;

      %  Generate psuedo data and plot 
      data = nmdataSM(nobs,parmat) ;
      hsjpi = bwsjpiSM(data) ;
      paramstruct = struct('vh',hsjpi, ...
                           'vxgrid',xgrid, ...
                           'imptyp',1) ;
      kde = kdeSM(data,paramstruct) ;
      if inobs == 2 ;
        colstr = 'g' ;
      elseif inobs == 3 ;
        colstr = 'b' ;
      elseif inobs == 4 ;
        colstr = 'r' ;
      end ;
      plot(xgrid,kde,colstr,'LineWidth',3) ;
      text(vax(1) + 0.1 * (vax(2) - vax(1)), ...
           vax(3) + (1.1 - 0.1 * inobs) * (vax(4) - vax(3)), ...
           ['n = ' num2str(nobs)],'Color',colstr) ;

      disp('Any key to continue') ;
      pauseSM ;

    end ;
    hold off ;

  end ;


end ;


