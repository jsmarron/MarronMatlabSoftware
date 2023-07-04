disp('Running MATLAB script file Plot1SMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION Plot1SM,
%    PLOT of 1 dimensonal data


itest = 83 ;     %  0,...,83


figure(1) ;
clf ;


if itest == 0 ;     %  input data only

  disp('Test All Defaults') ;

  vdata = randn(1,20) ;

  Plot1dSM(vdata) ;


elseif itest == 1 ;  

  disp('Test iscreenwrite = 1') ;

  vdata = randn(1,20) ;

  paramstruct = struct('iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 2 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('titlestr','Check titlestr & Default Colors', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 3 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check ifigure & Default Colors', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 4 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('icolor',1, ...
                       'ifigure',1, ...
                       'titlestr','Check Matlab Default Colors', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 5 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'titlestr','Check All Black', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 6 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 7 ; 

  vdata = randn(1,20) ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'titlestr','Check Magenta Color', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 8 ; 

  vdata = randn(1,20) ;

  mcolor = ones(10,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(10,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'titlestr','Check 1/2 Red, 1/2 Blue', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 9 ; 

  disp('Test input more than one row') ;

  vdata = randn(3,20) ;

  paramstruct = struct('ifigure',1, ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 10 ; 

  vdata = randn(1,100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 11 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 12 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'titlestr','Check Upper Right subplot', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 13 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',-1, ...
                       'titlestr','Check Lower Left & Upper Right subplot', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,2,3) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 14 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Resets subplot structure to single page', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 15 ; 

  disp('Test vaxlim = 2') ;

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 16 ; 

  disp('Test vaxlim = [2 3], data at integers') ;

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[2 3], ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 17 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[], ...
                       'ifigure',1, ...
                       'titlestr','Check default vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 18 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',1, ...
                       'ifigure',1, ...
                       'titlestr','Check symmetric vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 19 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[-40 60 -0.02 0.08], ...
                       'ifigure',1, ...
                       'titlestr','Check manually input vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 20 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'titlestr','Check save to file temp1.fig', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 21 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1.fig', ...
                       'titlestr','Check save to file temp1.fig (can include .fig, or not)', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 22 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1.png', ...
                       'savetype',2, ...
                       'titlestr','Check save to file temp1.png', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 23 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'savestr','temp1.png', ...
                       'savetype',2, ...
                       'titlestr','Check B&W save to file temp1.png', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 24 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'savestr','temp1.eps', ...
                       'savetype',4, ...
                       'titlestr','Check black and white save to file temp1.eps', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 25 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'savestr','temp1.eps', ...
                       'savetype',5, ...
                       'titlestr','Check bad black and white save to file temp1.eps', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 26 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'savestr','temp1.jpg', ...
                       'savetype',6, ...
                       'titlestr','Check B&W save to file temp1.jpg', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 27 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'savestr','temp1.svg', ...
                       'savetype',7, ...
                       'titlestr','Check B&W save to file temp1.svg', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 28 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr',35, ...
                       'titlestr','Check savestr is not a string', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 29 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'savestr','temp1', ...
                       'titlestr','Check over-ride of ifigure=0 by savestr', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 30 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',0.5 * ones(100,3), ...
                       'titlestr','Check for all gray colors', ...
                       'iscreenwrite',0) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 31 ; 

  vdata = 1:100 ;

  subplot(2,2,1) ;
    paramstruct = struct('icolor',0.5 * ones(3,100), ...
                         'titlestr','Check for colormap warning (icolor is 3 x 100)', ...
                         'iscreenwrite',0) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('icolor',0.5 * ones(100,1), ...
                         'titlestr','Check for colormap warning (icolor is 100 x 1)', ...
                         'iscreenwrite',0) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('icolor',0.5 * ones(90,3), ...
                         'titlestr','Check for colormap warning (icolor is 90 x 3)', ...
                         'iscreenwrite',0) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('icolor',0.5 * ones(110,3), ...
                         'titlestr','Check for colormap warning (icolor is 110 x 3)', ...
                         'iscreenwrite',0) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 32 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Labels', ...
                       'xlabelstr','X', ...
                       'ylabelstr','Y', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 33 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check for big font in titles', ...
                       'titlefontsize',24, ...
                       'xlabelstr','X: Check for small font in labels', ...
                       'ylabelstr','Y: Check for small font in labels', ...
                       'labelfontsize',6, ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 34 ; 

  vdata = 1:100 ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out legends', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 35 ; 

  vdata = 1:100 ;

  legendcellstr = {{'Legend 1'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out single legend', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 36 ; 

  vdata = 1:100 ;

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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 37 ; 

  vdata = 1:100 ;

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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 38 ; 

  vdata = 1:100 ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',zeros(4,4), ...
                       'titlestr','Check out invalid mlegendcolor', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 39 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','o', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 40 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','+', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 41 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','b', ...
                       'ifigure',1, ...
                       'markerstr','*', ...
                       'titlestr','Check chosen symbol and common color', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 42 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'ibigdot',1, ...
                       'titlestr','Check reset of ibigdot, for non-dot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 43 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','.', ...
                       'ibigdot',1, ...
                       'titlestr','Check effect of ibigdot, recall need to see temp1.fig', ...
                       'savestr','temp1', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 44 ; 

  vdata = 1:100 ;
  markerstr = strvcat('r+','bo') ;

  disp('Check effect of wrong size of markerstr') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of wrong size of markerstr', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 45 ; 

  vdata = 1:100 ;
  markerstr = ones(100,1) ;

  disp('Check effect of non-char array markerstr') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of non-char array markerstr', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 46 ; 

  vdata = 1:100 ;
  markerstr = [] ;
  for i=1:100 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check manual feed of char array markerstr', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 47 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 48 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 49 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 50 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 51 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 52 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 53 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 54 ; 

  vdata = 1:100 ;
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

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 55 ; 

  vdata = 1:100 ;
  markerstr = [] ;
  for i=1:25 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;
  for i=1:50 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i=1:25 ;
    markerstr = strvcat(markerstr,'*') ;
  end ;
  mcol = [] ;
  for i=1:50 ;
    mcol = [mcol; [0 0 1]] ;
  end ;
  for i=1:50 ;
    mcol = [mcol; [1 0 0]] ;
  end ;

  paramstruct = struct('icolor',mcol, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check input colors, and markers', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 56 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'markerstr','*', ...
                       'titlestr','Single input color, single input marker', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 57 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',0, ...
                       'titlestr','Check no data overlay, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 58 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',0, ...
                       'titlestr','Check no overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 59 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'titlestr','Check required overlay, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 60 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'titlestr','Check reqired overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 61 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'titlestr','Check random overlay, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 62 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'titlestr','Check random overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 63 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',0, ...
                       'idatovlay',2, ...
                       'titlestr','Check unseeded random overlay, for common plot', ...
                       'iscreenwrite',1) ;

  clf ;
  subplot(2,1,1) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,1,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 64 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'idatovlay',23984236, ...
                       'titlestr','Check Seeded random overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  clf ;
  subplot(2,1,1) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(2,1,2) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 65 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 66 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for indiv plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 67 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 68 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for indiv plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 69 ; 

  vdata = 1:100 ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',0, ...
                       'titlestr','Check 1/3 Red, 1/3 Magenta, 1/3 Blue', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 70 ; 

  vdata = 1:100 ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',1, ...
                       'titlestr','Check Subpopulation KDEs', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 71 ; 

  vdata = 1:100 ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',2, ...
                       'titlestr','Check Subpopulation KDEs only', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 72 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'ndatovlay',20, ...
                       'titlestr','Check 20 point overlay, for common plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 73 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'ndatovlay',20, ...
                       'titlestr','Check 20 point overlay, for indiv. plot', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 74 ; 

  vdata = 1:100000 ;

  subplot(1,2,1) ;
    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'titlestr','Default overlay, n = 100,000', ...
                         'iscreenwrite',1) ;

    Plot1dSM(vdata,paramstruct) ;

  subplot(1,2,2) ;
    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',1, ...
                         'titlestr','ndatovlay = 1, n = 100,000', ...
                         'iscreenwrite',1) ;

    Plot1dSM(vdata,paramstruct) ;


elseif itest == 75 ; 

  vdata = 1:100000 ;

  subplot(1,2,1) ;
    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',2, ...
                         'titlestr','Force Default overlay, n = 100,000', ...
                         'iscreenwrite',1) ;
    Plot1dSM(vdata,paramstruct) ;

  subplot(1,2,2) ;
    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',20, ...
                         'titlestr','20 point overlay, n = 100,000', ...
                         'iscreenwrite',1) ;
    Plot1dSM(vdata,paramstruct) ;


elseif itest == 76 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[-40 120], ...
                       'ifigure',1, ...
                       'titlestr','Manually input x vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 77 ; 

  disp('Note:  This is similar to itest = 36') ;
  disp('       except that "setfield" is used on mlegendcolor') ;
  disp('       which causes a size error ') ;
  disp('       (due to double braces in legendcellstr)') ;

  vdata = 1:100 ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;
  mlegendcolor = [1 0 0 ; ...
                  1 0 1 ; ...
                  0 0 1 ; ...
                  0 1 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check out legends and colors', ...
                       'iscreenwrite',1) ;
  paramstruct = setfield(paramstruct,'legendcellstr',legendcellstr) ;
  paramstruct = setfield(paramstruct,'mlegendcolor',mlegendcolor) ;
  Plot1dSM(vdata,paramstruct) ;


elseif itest == 78 ; 

  disp('Note:  This is similar to itest = 77') ;
  disp('       except that the error is fixed by') ;
  disp('       using single braces in legendcellstr') ;

  vdata = 1:100 ;

  legendcellstr = {'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'} ;
  mlegendcolor = [1 0 0 ; ...
                  1 0 1 ; ...
                  0 0 1 ; ...
                  0 1 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check out legends and colors', ...
                       'iscreenwrite',1) ;

  paramstruct = setfield(paramstruct,'legendcellstr',legendcellstr) ;
  paramstruct = setfield(paramstruct,'mlegendcolor',mlegendcolor) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 79 ; 

  disp('Note:  This is similar to itest = 22,24, ') ;
  disp('       except that it tests .ps save with') ;
  disp('       an input color matrix') ;

  vdata = 1:100 ;

  mcolor = ones(50,1) * [1 0 1] ; 
  mcolor = [mcolor; ones(50,1) * [0 1 1]] ;

  legendcellstr = {'Legend 1' 'Legend 2'} ;
  mlegendcolor = [1 0 1 ; ...
                  0 1 1] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',2, ...
                       'titlestr','Check color save to file temp1.png', ...
                       'iscreenwrite',1) ;

  paramstruct = setfield(paramstruct,'legendcellstr',legendcellstr) ;
  paramstruct = setfield(paramstruct,'mlegendcolor',mlegendcolor) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 80 ; 

  vdata = 1:100 ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'titlestr','Check Gray Spectrum', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 81 ; 

  vdata = 2 * ones(1,100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check All Variables = 2', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 82 ; 

  vdata = 2 * ones(1,100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'vaxlim',1, ...
                       'titlestr','Check All Variables = 2, symmetric axes', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


elseif itest == 83 ; 

  vdata = 2 * ones(1,100) ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'vaxlim',[1.9 2.1], ...
                       'titlestr','Check All Variables = 2, input axes', ...
                       'iscreenwrite',1) ;

  Plot1dSM(vdata,paramstruct) ;


end ;


