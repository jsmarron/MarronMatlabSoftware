disp('Running MATLAB script file Plot2dSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION projplot2SM,
%    PROJection PLOT on 2 directions


itest = 77 ;     %  0,...,77


figure(1) ;
clf ;


disp(['    itest = ' num2str(itest)]) ;

if itest == 0 ;     %  input data only

  mdata = randn(2,20) ;

  Plot2dSM(mdata) ;
  disp('Test All Defaults') ;


elseif itest == 1 ;  

  mdata = randn(2,20) ;

  paramstruct = struct('iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;
  disp('Test iscreenwrite') ;


elseif itest == 2 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('titlestr','Check Title & Default Colors', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 3 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check ifigure & Default Colors', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 4 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('icolor',1, ...
                       'ifigure',1, ...
                       'titlestr','Force Matlab Default Colors', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 5 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'titlestr','Check All Black', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 6 ; 

  mdata = ones(3,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 7 ; 

  mdata = ones(3,1) * (1:100) ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'titlestr','Check Magenta Color', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 8 ; 

  mdata = ones(3,1) * (1:100) ;

  mcolor = ones(50,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'titlestr','Check 1/2 Red, 1/2 Blue', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 9 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check Default Colors, and n = 3*7', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 10 ; 

  mdata = randn(2,20) ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check Default Colors, and n = 3*7+1', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 11 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'titlestr','Check Upper Right subplot', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 12 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'titlestr','Check Upper Right subplot & ifigure = 0', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 13 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',-1, ...
                       'titlestr','Check Lower Left & Upper Right subplot', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot2dSM(mdata,paramstruct) ;

  subplot(2,2,3) ;
    Plot2dSM(mdata,paramstruct) ;


elseif itest == 14 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Resets subplot structure to single page, using ifigure = 1', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 15 ; 

  mdata = ones(2,1) * (1:100) ;
  mdir = [1 0 ; ...
          0 1 ] ;
  disp('Test input dir vectors too short') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 16 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'savetype',5, ...
                       'titlestr','Check save to file temp2.eps (black & white)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 17 ; 

  mdata = ones(2,1) * (1:100) ;
  disp('Test vaxlim = 2') ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 18 ; 

  mdata = ones(2,1) * (1:100) ;
  disp('Test vaxlim = [2 3]') ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[2 3], ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 19 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[], ...
                       'ifigure',1, ...
                       'titlestr','Check default vaxlim= []', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 20 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',1, ...
                       'ifigure',1, ...
                       'titlestr','Check symmetric vaxlim = 1', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 21 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[-50 60 30 60], ...
                       'ifigure',1, ...
                       'titlestr','Check manually chosen vaxlim = [-50 60 30 60]', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 22 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'titlestr','Check save to file temp2.fig', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 23 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2.fig', ...
                       'titlestr','Check save to file temp2.fig (can include .fig, or not)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 24 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'titlestr','Check black and white save to file temp2.fig', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 25 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr',35, ...
                       'titlestr','Check savestr is not a string', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 26 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'savestr','temp2', ...
                       'titlestr','Check over-ride of ifigure=0 by savestr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 27 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2.png', ...
                       'savetype',2, ...
                       'titlestr','Check save to file temp2.png', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 28 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2.pdf', ...
                       'savetype',3, ...
                       'titlestr','Check save to file temp2.pdf', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 29 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2.eps', ...
                       'savetype',4, ...
                       'titlestr','Check save to file temp2.eps', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 30 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',0.5 * ones(100,3), ...
                       'ifigure',1, ...
                       'titlestr','Check for all gray color', ...
                       'iscreenwrite',0) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 31 ; 

  mdata = ones(2,1) * (1:100) ;

  subplot(2,2,1) ;
    disp('Test icolor transpose') ;
    paramstruct = struct('icolor',0.5 * ones(3,100), ...
                         'titlestr','Test icolor transpose', ...
                         'iscreenwrite',0) ;
    Plot2dSM(mdata,paramstruct) ;

  subplot(2,2,2) ;
    disp('Test 2 column icolor') ;
    paramstruct = struct('icolor',0.5 * ones(100,2), ...
                         'titlestr','Test 2 column icolor', ...
                         'iscreenwrite',0) ;
    Plot2dSM(mdata,paramstruct) ;

  subplot(2,2,3) ;
    disp('Test icolor too long') ;
    paramstruct = struct('icolor',0.5 * ones(110,3), ...
                         'titlestr','Test icolor too long', ...
                         'iscreenwrite',0) ;
    Plot2dSM(mdata,paramstruct) ;

  subplot(2,2,4) ;
    disp('Test icolor too short') ;
    paramstruct = struct('icolor',0.5 * ones(90,3), ...
                         'titlestr','Test icolor too short', ...
                         'iscreenwrite',0) ;
    Plot2dSM(mdata,paramstruct) ;


elseif itest == 32 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Labels', ...
                       'xlabelstr','X', ...
                       'ylabelstr','Y', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 33 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check for big font in titles', ...
                       'titlefontsize',24, ...
                       'xlabelstr','X: Check for small font in labels', ...
                       'ylabelstr','Y: Check for small font in labels', ...
                       'labelfontsize',6, ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 34 ; 

  mdata = ones(2,1) * (1:100) ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out legends', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 35 ; 

  mdata = ones(2,1) * (1:100) ;

  legendcellstr = {{'Legend 1'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out single legend', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 36 ; 

  mdata = ones(2,1) * (1:100) ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;
  mlegendcolor = [1 0 0 ; ...
                  1 0 1 ; ...
                  0 0 1 ; ...
                  0 1 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',mlegendcolor, ...
                       'titlestr','Check out legends and colors', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 37 ; 

  mdata = ones(2,1) * (1:100) ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;
  mlegendcolor = [1 0 0 ; ...
                  1 0 1 ; ...
                  0 0 1] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',mlegendcolor, ...
                       'titlestr','Check out incompatible color size', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 38 ; 

  mdata = ones(2,1) * (1:100) ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',zeros(4,4), ...
                       'titlestr','Check out invalid mlegendcolor', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 39 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','o', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 40 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 41 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor','b', ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'titlestr','Check chosen symbol & common colors', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 42 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'ibigdot',1, ...
                       'titlestr','Check reset of ibigdot, for non-dot', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 43 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','.', ...
                       'titlestr','Check effect of ibigdot, recall need to see temp2.fig', ...
                       'savestr','temp2', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 44 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = strvcat('r+','bo') ;
  disp(['Check effect of wrong size markerstr = strvcat(''r+'',''bo'')']) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of wrong size of markerstr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 45 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = ones(100,1) ;
  disp(['Check effect of non-char array markerstr = ones(100,1)']) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of non-char array markerstr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 46 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:100 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check manual feed of char array markerstr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 47 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:100 ;
    markerstr = strvcat(markerstr,'.') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'ibigdot',1, ...
                       'titlestr','Check reset of ibigdot for multiple entries in markerstr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 48 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check multiple entries in markerstr', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 49 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;

  paramstruct = struct('ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check default color, input different markers', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 50 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;

  paramstruct = struct('icolor','g', ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check input single color, input different markers', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 51 ; 

  mdata = ones(2,1) * (1:100) ;
  markerstr = [] ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check black and white, input different markers', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 52 ; 

  mdata = ones(2,1) * (1:100) ;
  mcol = [] ;
  for i=1:50 ;
    mcol = [mcol; [0 0 1]] ;
  end ;
  for i=1:50 ;
    mcol = [mcol; [1 0 0]] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'titlestr','Check input colors, default markers', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 53 ; 

  mdata = ones(2,1) * (1:100) ;
  mcol = [] ;
  for i=1:50 ;
    mcol = [mcol; [0 0 1]] ;
  end ;
  for i=1:50 ;
    mcol = [mcol; [1 0 0]] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'markerstr','s', ...
                       'titlestr','Check input colors, single input marker', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 54 ; 

  mdata = ones(2,1) * (1:100) ;
  mcol = [] ;
  for i=1:50 ;
    mcol = [mcol; [0 0 1]] ;
  end ;
  for i=1:50 ;
    mcol = [mcol; [1 0 0]] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'markerstr','.', ...
                       'ibigdot',1, ...
                       'titlestr','Check input colors, and ibigdot', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 55 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'savetype',6, ...
                       'titlestr','Check save to file temp2.jpg', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 56 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'markerstr','*', ...
                       'titlestr','Single input color, single input marker', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 57 ; 

  mdata = (ones(2,1) * (1:100) - 50) / 25 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'iplotaxes',1, ...
                       'titlestr','Check Axis Plot', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 58 ; 

  mdata = (ones(2,1) * (1:100) - 50) / 25 ;
  disp(['Check bad feed of idataconn = 1']) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'iplotaxes',1, ...
                       'idataconn',1, ...
                       'titlestr','Check bad feed of idataconn', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 59 ; 

  mdata = (ones(2,1) * (1:100) - 50) / 25 ;
  mdata = mdata + 0.1 * randn(2,100) ;
  mdc = [(1:99)' (2:100)'] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'titlestr','Check idataconn for time series (default color)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 60 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'titlestr','Check idataconn for Bias adjustment (default color)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 61 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','g', ...
                       'titlestr',['Check idataconncolor = ''g'''], ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 62 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',[0 1 0], ...
                       'titlestr','Check idataconncolor = [0 1 0]', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 63 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',(ones(50,1) * [0 1 0]), ...
                       'titlestr','Check idataconncolor = (ones(50,1) * [0 1 0])', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 64 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',[(ones(25,1) * [0 1 0]);(ones(25,1) * [1 0 1])], ...
                       'titlestr','Check different idataconncolor', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 65 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',[(ones(15,1) * [0 1 0]);(ones(5,1) * [1 0 1])], ...
                       'titlestr','Check bad idataconncolor (wrong #)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 66 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'idataconntype','--', ...
                       'titlestr',['Check idataconntype = ''--'''], ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 67 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;
  mdctype = [] ;
  for i = 1:25 ;
    mdctype = [mdctype; '-'; ':'] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'idataconntype',mdctype, ...
                       'titlestr','Check alternating idataconntypes', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 68 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;
  mdctype = [] ;
  for i = 1:25 ;
    mdctype = [mdctype; '- '; '--'] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'idataconntype',mdctype, ...
                       'titlestr',['Check idataconntype, alternating ''- '' & ''--'''], ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 69 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;
  mdctype = [] ;
  for i = 1:25 ;
    mdctype = [mdctype; '--'] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'idataconntype',mdctype, ...
                       'titlestr',['Check too few idataconntypes'], ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 70 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [0 1; 1 2] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'titlestr','bad mdc = [0 1; 1 2] (note: no 0 index data)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 71 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [49 50; 50 51; 100 101] ;
  mcol = [ones(50,1) * [1 0 0]; ones(50,1) * [0 0 1]] ;
  mdctype = [] ;
  for i = 1:25 ;
    mdctype = [mdctype; '--'] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor','m', ...
                       'idataconntype',mdctype, ...
                       'titlestr','bad mdc = [49 50; 50 51; 100 101]', ...
                       'iscreenwrite',1) ;
  Plot2dSM(mdata,paramstruct) ;


elseif itest == 72 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:99)' (2:100)'] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',2, ...
                       'idataconntype','--', ...
                       'titlestr','Rainbow colors and connections', ...
                       'iscreenwrite',1) ;
  Plot2dSM(mdata,paramstruct) ;


elseif itest == 73 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [(1:50)' (51:100)'] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',2, ...
                       'idataconntype','--', ...
                       'titlestr','Non standard use of rainbow idataconncolor', ...
                       'iscreenwrite',1) ;
  Plot2dSM(mdata,paramstruct) ;


elseif itest == 74 ; 

  mdata = [2 * ones(2,50),  -2 * ones(2,50) + 0.5 * randn(2,50)] ;
  mnoise = randn(2,50) ;
  mdata = mdata + [mnoise mnoise] ;
  mdc = [[(1:99)' (2:100)']; [(1:50)' (51:100)']] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'idataconncolor',2, ...
                       'idataconntype','--', ...
                       'titlestr','Too many connections for the colors', ...
                       'iscreenwrite',1) ;
  Plot2dSM(mdata,paramstruct) ;


elseif itest == 75 ; 

  disp('Note:  This is similar to itest = 22,24, ') ;
  disp('       except that it tests .ps save with') ;
  disp('       an input color matrix') ;

  mdata = ones(2,1) * (1:100) ;

  mcolor = ones(50,1) * [1 0 1] ; 
  mcolor = [mcolor; ones(50,1) * [0 1 1]] ;

  legendcellstr = {'Legend 1' 'Legend 2'} ;
  mlegendcolor = [1 0 1 ; ...
                  0 1 1] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'titlestr','Check color save to file temp2.fig', ...
                       'iscreenwrite',1) ;

  paramstruct = setfield(paramstruct,'legendcellstr',legendcellstr) ;
  paramstruct = setfield(paramstruct,'mlegendcolor',mlegendcolor) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 76 ; 

  mdata = ones(2,1) * (1:100) ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'titlestr','Check Gray Levels', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 77 ; 

  mdata = (ones(2,1) * (1:100) - 50) / 25 ;
  mdata = mdata + 0.1 * randn(2,100) ;
  mdc = [(1:99)' (2:100)'] ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'idataconn',mdc, ...
                       'titlestr','Check idataconn for time series (gray color)', ...
                       'iscreenwrite',1) ;

  Plot2dSM(mdata,paramstruct) ;


elseif itest == 78 ; 



end ;
