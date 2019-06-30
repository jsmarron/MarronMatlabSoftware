disp('Running MATLAB script file HeatMapSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION HeatMapSM,
%    Heat Map visualization of data

itest = 23 ;     %  1,...,23  Simple parameter tests
                %      Take careful look at color specific data sets


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

  %  Generate generic data similar to that in OODAbookChpPFigAToyCentering.m
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

  figure (1) ; 
  clf ;

  if itest == 1 ;
    disp('  Test all defaults') ;
    HeatMapSM(mdata) ;
  elseif itest == 2 ;
    disp('  Test setting title, and others at default') ;
    paramstruct = struct('titlestr','Testing input title + defaults') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 3 ;
    disp('  Test setting title axis lables, with others at default') ;
    paramstruct = struct('titlestr','Test Title, axis labels + defaults', ...
                         'xlabelstr','Parabola', ...
                         'ylabelstr','Sine Wave') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 4 ;
    disp('  Test setting icolor = 0') ;
    paramstruct = struct('icolor',0, ...
                         'titlestr','Test icolor = 0') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 5 ;
    disp('  Test setting icolor = 1') ;
    paramstruct = struct('icolor',1, ...
                         'titlestr','Test icolor = 1') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 6 ;
    disp('  Test setting icolor = 2') ;
    paramstruct = struct('icolor',2, ...
                         'titlestr','Test icolor = 2') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 7 ;
    disp('  Test setting icolor = 3') ;
    paramstruct = struct('icolor',3, ...
                         'titlestr','Test icolor = 3') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 8 ;
    disp('  Test setting icolor = 4') ;
    paramstruct = struct('icolor',4, ...
                         'titlestr','Test icolor = 4') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 9 ;
    disp('  Test manually input icolor small') ;
    mcolor = RainbowColorsQY(6) ;
    paramstruct = struct('icolor',mcolor, ...
                         'titlestr','Test small manual icolor') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 10 ;
    disp('  Test small alpha') ;
    paramstruct = struct('icolor',3, ...
                         'alpha',0.001, ...
                         'titlestr','Test alpha = 0.001') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 11 ;
    disp('  Test large alpha') ;
    paramstruct = struct('icolor',3, ...
                         'alpha',0.2, ...
                         'titlestr','Test alpha = 0.2') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 12 ;
    disp('  Test small ncolor') ;
    paramstruct = struct('icolor',0, ...
                         'ncolor',10, ...
                         'titlestr','Test ncolor = 10') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 13 ;
    disp('  Test large ncolor') ;
    paramstruct = struct('icolor',0, ...
                         'ncolor',300, ...
                         'titlestr','Test ncolor = 300') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 14 ;
    disp('  Turn off pixel color distribution') ;
    paramstruct = struct('icolor',2, ...
                         'icolordist',0, ...
                         'titlestr','Test no color distribution') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 15 ;
    disp('  Put pixel color distribution in Figure 5') ;
    paramstruct = struct('icolor',3, ...
                         'icolordist',5, ...
                         'titlestr','Check Distribution in Figure 5') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 16 ;
    disp('  Make B&W prints') ;
    savestr = 'HeatMapSMtestGray' ;
    paramstruct = struct('icolor',0, ...
                         'titlestr','Check for B&W .pdfs', ...
                         'savestr',savestr) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 17 ;
    disp('  Make color prints') ;
    savestr = 'HeatMapSMtestColor' ;
    paramstruct = struct('icolor',3, ...
                         'titlestr','Check for Color .pdfs', ...
                         'savestr',savestr) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 18 ;
    disp('  Check Nonstring title') ;
    paramstruct = struct('icolor',0, ...
                         'titlestr',123) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 19 ;
    disp('  Check Nonstring xlabel') ;
    paramstruct = struct('icolor',0, ...
                         'titlestr','Check bad xlabelstr', ...
                         'xlabelstr',123) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 20 ;
    disp('  Check Nonstring xlabel') ;
    paramstruct = struct('icolor',0, ...
                         'titlestr','Check bad ylabelstr', ...
                         'ylabelstr',123) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 21 ;
    disp('  Check Nonstring savestr') ;
    paramstruct = struct('icolor',0, ...
                         'titlestr','Check bad savestr', ...
                         'savestr',123) ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 22 ;
    disp('  Check bad icolor = 5') ;
    paramstruct = struct('icolor',5, ...
                         'titlestr','Check bad icolor') ;
    HeatMapSM(mdata,paramstruct) ;
  elseif itest == 23 ;
    disp('  Check bad icolor size') ;
    paramstruct = struct('icolor',[1 2], ...
                         'titlestr','Check bad icolor') ;
    HeatMapSM(mdata,paramstruct) ;
  end ;


end ;



