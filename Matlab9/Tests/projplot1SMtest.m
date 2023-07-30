disp('Running MATLAB script file projplot1SMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION projplot1SM,
%    PROJection PLOT on 1 direction


itest = 88 ;     %  0,...,88


figure(1) ;
clf ;


if itest == 0 ;     %  input data only

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  projplot1SM(mdata,vdir) ;
  title('Test All Defaults') ;


elseif itest == 1 ;  

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;
  title('Test iscreenwrite = 1') ;


elseif itest == 2 ; 

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('titlestr','Check titlestr & Default Colors', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 3 ; 

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check ifigure & Default Colors', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 4 ; 

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',1, ...
                       'ifigure',1, ...
                       'titlestr','Check Matlab Default Colors', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 5 ; 

  mdata = randn(3,20) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'titlestr','Check All Black', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 6 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 7 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'titlestr','Check Magenta Color', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 8 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  mcolor = ones(50,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(50,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'titlestr','Check 1/2 Red, 1/2 Blue', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 9 ; 

  mdata = randn(3,21) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check Default Colors, and n = 3*7', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 10 ; 

  mdata = randn(3,22) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('ifigure',1, ...
                       'titlestr','Check Default Colors, and n = 3*7+1', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 11 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Rainbow', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 12 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'titlestr','Check Upper Right subplot', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 13 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',-1, ...
                       'titlestr','Check Lower Left & Upper Right subplot', ...
                       'iscreenwrite',1) ;


  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,2,3) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 14 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Resets subplot structure to single page', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 15 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0] ;

  disp('Test vdir too short') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 16 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [[1; 0; 0] [0; 1; 0]]  ;

  disp('Test vdir with 2 columns') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 17 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  disp('Test vaxlim = 2') ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',2, ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 18 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  disp('Test vaxlim = [2 3], data at integers') ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[2 3], ...
                       'ifigure',1, ...
                       'titlestr','Check messages for funny inputs', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 19 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[], ...
                       'ifigure',1, ...
                       'titlestr','Check default vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 20 ; 

  mdata = -ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',1, ...
                       'ifigure',1, ...
                       'titlestr','Check symmetric vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 21 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[-40 60 -0.02 0.08], ...
                       'ifigure',1, ...
                       'titlestr','Check manually input vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 22 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'titlestr','Check save to file temp1.fig', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 23 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',2, ...
                       'titlestr','Check save to file temp1.png', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 24 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',0, ...
                       'ifigure',1, ...
                       'savestr','temp2', ...
                       'savetype',1, ...
                       'titlestr','Check black and white save to file temp2.fig', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 25 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr',35, ...
                       'titlestr','Check savestr is not a string', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 26 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'savestr','temp1', ...
                       'titlestr','Check over-ride of ifigure=0 by savestr', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 27 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [2; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check differing length direction vector', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 28 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [2; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check silencing of dir vec errors', ...
                       'iscreenwrite',0) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 29 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [0; 0; 0] ;

  disp('Test 0 length dir vec') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check error for 0 length dir vec', ...
                       'iscreenwrite',0) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 30 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',0.5 * ones(100,3), ...
                       'titlestr','Check for all gray colors', ...
                       'iscreenwrite',0) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 31 ; 

  subplot(2,2,1) ;
    mdata = ones(3,1) * (1:100) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor',0.5 * ones(3,100), ...
                         'titlestr','Check for colormap warning (icolor is 3 x 100)', ...
                         'iscreenwrite',0) ;

    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,2,2) ;
    mdata = ones(3,1) * (1:100) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor',0.5 * ones(100,1), ...
                         'titlestr','Check for colormap warning (icolor is 100 x 1)', ...
                         'iscreenwrite',0) ;

    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,2,3) ;
    mdata = ones(3,1) * (1:100) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor',0.5 * ones(90,3), ...
                         'titlestr','Check for colormap warning (icolor is 90 x 3)', ...
                         'iscreenwrite',0) ;

    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,2,4) ;
    mdata = ones(3,1) * (1:100) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor',0.5 * ones(110,3), ...
                         'titlestr','Check for colormap warning (icolor is 110 x 3)', ...
                         'iscreenwrite',0) ;

    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 32 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check Labels', ...
                       'xlabelstr','X', ...
                       'ylabelstr','Y', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 33 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check for big font in titles', ...
                       'titlefontsize',24, ...
                       'xlabelstr','X: Check for small font in labels', ...
                       'ylabelstr','Y: Check for small font in labels', ...
                       'labelfontsize',6, ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 34 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out legends', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 35 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  legendcellstr = {{'Legend 1'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Check out single legend', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 36 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 37 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 38 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  legendcellstr = {{'Legend 1' 'Legend 2' 'Legend 3' 'Legend 4'}} ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',zeros(4,4), ...
                       'titlestr','Check out invalid mlegendcolor', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 39 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','o', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 40 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'titlestr','Check chosen symbol', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 41 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','b', ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'titlestr','Check chosen symbol and common color', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 42 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','x', ...
                       'ibigdot',1, ...
                       'titlestr','Check reset of ibigdot, for non-dot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 43 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr','.', ...
                       'ibigdot',1, ...
                       'titlestr','Check effect of ibigdot, see temp1.png', ...
                       'savestr','temp1', ...
                       'savetype',2, ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 44 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
  markerstr = strvcat('r+','bo') ;

  disp('Check effect of wrong size of markerstr') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of wrong size of markerstr', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 45 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
  markerstr = ones(100,1) ;

  disp('Check effect of non-char array markerstr') ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check effect of non-char array markerstr', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 46 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
  markerstr = [] ;
  for i=1:100 ;
    markerstr = strvcat(markerstr,'+') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'markerstr',markerstr, ...
                       'titlestr','Check manual feed of char array markerstr', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 47 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 48 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 49 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 50 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 51 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 52 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 53 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 54 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 55 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;
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

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 56 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'markerstr','*', ...
                       'titlestr','Single input color, single input marker', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 57 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',0, ...
                       'titlestr','Check no data overlay, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 58 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',0, ...
                       'titlestr','Check no overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 59 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'titlestr','Check required overlay, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 60 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'titlestr','Check required overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 61 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'titlestr','Check random overlay, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 62 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'titlestr','Check random overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 63 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',0, ...
                       'idatovlay',2, ...
                       'titlestr','Check unseeded random overlay, for common plot', ...
                       'iscreenwrite',1) ;

  clf ;
  subplot(2,1,1) ;
    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,1,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 64 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',0, ...
                       'idatovlay',239842360, ...
                       'titlestr','Check Seeded random overlay, for indiv plot', ...
                       'iscreenwrite',1) ;

  clf ;
  subplot(2,1,1) ;
    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(2,1,2) ;
    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 65 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 66 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',1, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for indiv plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 67 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 68 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'idatovlay',2, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.3, ...
                       'titlestr','Check entered overlay range, for indiv plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 69 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',0, ...
                       'titlestr','Check 1/3 Red, 1/3 Magenta, 1/3 Blue', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 70 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',1, ...
                       'titlestr','Check Subpopulation KDEs', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 71 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  mcolor = ones(33,1) * [1 0 0] ; 
  mcolor = [mcolor; ones(34,1) * [1 0 1]] ;
  mcolor = [mcolor; ones(33,1) * [0 0 1]] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'isubpopkde',2, ...
                       'titlestr','Check Subpopulation KDEs only', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 72 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor','m', ...
                       'ifigure',1, ...
                       'ndatovlay',20, ...
                       'titlestr','Check 20 point overlay, for common plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 73 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'ndatovlay',20, ...
                       'titlestr','Check 20 point overlay, for indiv. plot', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 74 ; 

  subplot(1,2,1) ;
    mdata = ones(3,1) * (1:100000) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'titlestr','Default overlay (all), n = 100,000', ...
                         'iscreenwrite',1) ;

    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(1,2,2) ;
    mdata = ones(3,1) * (1:100000) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',1, ...
                         'titlestr','ndatovlay = 1 (1000), n = 100,000', ...
                         'iscreenwrite',1) ;

    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 75 ; 

  subplot(1,2,1) ;
    mdata = ones(3,1) * (1:100000) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',2, ...
                         'titlestr','Force Default overlay (all), n = 100,000', ...
                         'iscreenwrite',1) ;

    projplot1SM(mdata,vdir,paramstruct) ;

  subplot(1,2,2) ;
    mdata = ones(3,1) * (1:100000) ;
    vdir = [1; 0; 0] ;

    paramstruct = struct('icolor','m', ...
                         'idatovlay',2, ...
                         'ndatovlay',20, ...
                         'titlestr','20 point overlay, n = 100,000', ...
                         'iscreenwrite',1) ;

    projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 76 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'vaxlim',[-40 120], ...
                       'ifigure',1, ...
                       'titlestr','Manually input x vaxlim', ...
                       'iscreenwrite',1) ;

  subplot(2,2,2) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 77 ; 

  disp('Note:  This is similar to itest = 36') ;
  disp('       except that "setfield" is used on mlegendcolor') ;
  disp('       which causes a size error ') ;
  disp('       (due to double braces in legendcellstr)') ;

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

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


  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 78 ; 
  disp('Note:  This is similar to itest = 77') ;
  disp('       except that the error is fixed by') ;
  disp('       using single braces in legendcellstr') ;

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

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


  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 79 ; 

  disp('Note:  This is similar to itest = 22,24, ') ;
  disp('       except that it tests .ps save with') ;
  disp('       an input color matrix') ;

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  mcolor = ones(50,1) * [1 0 1] ; 
  mcolor = [mcolor; ones(50,1) * [0 1 1]] ;

  legendcellstr = {'Legend 1' 'Legend 2'} ;
  mlegendcolor = [1 0 1 ; ...
                  0 1 1] ;

  paramstruct = struct('icolor',mcolor, ...
                       'ifigure',1, ...
                       'savestr','temp1.ps', ...
                       'savetype',4, ...
                       'titlestr','Check color save to file temp1.ps', ...
                       'iscreenwrite',1) ;

  paramstruct = setfield(paramstruct,'legendcellstr',legendcellstr) ;
  paramstruct = setfield(paramstruct,'mlegendcolor',mlegendcolor) ;


  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 80 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',3, ...
                       'ifigure',1, ...
                       'titlestr','Check Gray Spectrum', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 81 ; 

  mdata = 2 * ones(3,100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'titlestr','Check All Variables = 2', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 82 ; 

  mdata = 2 * ones(3,100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'vaxlim',1, ...
                       'titlestr','Check All Variables = 2, symmetric axes', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 83 ; 

  mdata = 2 * ones(3,100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'vaxlim',[1.9 2.1], ...
                       'titlestr','Check All Variables = 2, input axes', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 84 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',3, ...
                       'titlestr','Check save to file temp1.pdf', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 85 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',4, ...
                       'titlestr','Check save to file temp1.eps', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 86 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',5, ...
                       'titlestr','Check save to file temp1.eps, black & white', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 87 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',6, ...
                       'titlestr','Check save to file temp1.jpg', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;


elseif itest == 88 ; 

  mdata = ones(3,1) * (1:100) ;
  vdir = [1; 0; 0] ;

  paramstruct = struct('icolor',2, ...
                       'ifigure',1, ...
                       'savestr','temp1', ...
                       'savetype',7, ...
                       'titlestr','Check save to file temp1.svg', ...
                       'iscreenwrite',1) ;

  projplot1SM(mdata,vdir,paramstruct) ;



end ;

