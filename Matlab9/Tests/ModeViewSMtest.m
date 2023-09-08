disp('Running MATLAB script file ModeViewSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION ModeViewSM,
%    Visualization of Modes of variation

itest = 19 ;     %  1,...,19  Simple parameter tests


disp(' ') ;
close all ;


if (itest == 1) | ...
   (itest == 2) | ...
   (itest == 3) | ...
   (itest == 4) | ...
   (itest == 5) | ...
   (itest == 6) | ...
   (itest == 7) | ...
   (itest == 8) | ...
   (itest == 9) | ...
   (itest == 10) | ...
   (itest == 11) | ...
   (itest == 12) | ...
   (itest == 13) | ...
   (itest == 14) | ...
   (itest == 15) | ...
   (itest == 16) | ...
   (itest == 17) | ...
   (itest == 18) | ...
   (itest == 19) | ...
   (itest == 20) | ...
   (itest == 21) | ...
   (itest == 22) | ...
   (itest == 23) ;     %  Simple paramter tests

  %  Generate generic data extending that of HeatMapSMtest.m
  %
  rng(83745347) ;
      %  Seed for random number generators
  d = 200 ;
  n = 100 ;
  sd = 0.2 ;
  hgrid = [1:n] ;
  vgrid = [1:d]' ;
  hmeanvec = 0.003 * (hgrid - 58).^2 - 6 ;
  vmeanvec = sin(vgrid * 0.15) + 3 ;

  %  Generate Raw Data
  %
  mdata = sd * rand(d,n) ;
  mdata = mdata + (ones(d,1) * hmeanvec) ;
  mdata = mdata + (vmeanvec * ones(1,n)) ;
  mdata = mdata + 0.001 * (vgrid - (d / 2)) * (hgrid - (n / 2)) ;

  figure (1) ;
  clf ;

  if itest == 1 ;
    disp('Test All Defaults') ;
    ModeViewSM(mdata) ;

  elseif itest == 2 ;
    disp('Test nmode = 1') ;
    paramstruct = struct('nmode',1) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 3 ;
    disp('Test icolorhm = 0') ;
    paramstruct = struct('icolorhm',0, ...
                         'icolorcols',1, ...
                         'icolorrows',1) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 4 ;
    disp('Test icolorhm = 1') ;
    paramstruct = struct('icolorhm',1) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 5 ;
    disp('Test icolorhm = 2') ;
    paramstruct = struct('icolorhm',2) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 6 ;
    disp('Test manually set colors to all black') ;
    paramstruct = struct('icolorhm',0, ...
                         'icolorcols',0, ...
                         'icolorrows',0) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 7 ;
    mcolorhmin = HeatColorsSM(14) ;
    mcolorhmin = mcolorhmin(1:12,:) ;
    mcolorcolsin = [(ones(n / 2,1) * [1 0 0]); ...
                  (ones(n / 2,1) * [0 0 1])] ;
    mcolorrowsin = [(ones(d / 2,1) * [0 1 0]); ...
                  (ones(d / 2,1) * [1 0 1])] ;
    disp('Test other input color matrices') ;
    paramstruct = struct('icolorhm',mcolorhmin, ...
                         'icolorcols',mcolorcolsin, ...
                         'icolorrows',mcolorrowsin) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 8 ;
    disp('Test alpha = 0.2') ;
    paramstruct = struct('alpha',0.2) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 9 ;
    disp('Test ncolor = 200') ;
    paramstruct = struct('ncolor',200) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 10 ;
    disp('Test ncolor = 9') ;
    paramstruct = struct('ncolor',9) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 11 ;
    disp('Test icolorhm = 2, ncolor = 9') ;
    paramstruct = struct('icolorhm',2, ...
                         'ncolor',9) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 12 ;
    disp('Test icolordist = 0') ;
    paramstruct = struct('icolordist',0) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 13 ;
    disp('Test Input Title') ;
    paramstruct = struct('titlestr','Input title, ') ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 14 ;
    disp('Test No Titles') ;
    paramstruct = struct('titlestr',0) ;
    ModeViewSM(mdata,paramstruct) ;
  
  elseif itest == 15 ;
    disp('Test Input Axis Labels') ;
    paramstruct = struct('titlestr','Input title, ', ...
                         'xlabelstr','Input x label', ...
                         'ylabelstr','Input y label') ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 16 ;
    disp('Test color print') ;
    disp('Look for .fig files') ;
    paramstruct = struct('savestr','ModeViewSMtestColorPrint') ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 17 ;
    disp('Test B & W print') ;
    disp('Look for .fig files') ;
    paramstruct = struct('icolorhm',0, ...
                         'icolorcols',0, ...
                         'icolorrows',0, ...
                         'savestr','ModeViewSMtestBWPrint') ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 18 ;
    disp('Test icolorhm = 3') ;
    paramstruct = struct('icolorhm',3) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 19 ;
    disp('Test icolorhm = 4') ;
    paramstruct = struct('icolorhm',4) ;
    ModeViewSM(mdata,paramstruct) ;

  elseif itest == 20 ;

  elseif itest == 21 ;

  elseif itest == 22 ;
%{
    paramstruct = struct('',, ...
                         '',, ...
                         '',) ;
%}

  elseif itest == 23 ;

  elseif itest == 24 ;

  end ;


end ;



