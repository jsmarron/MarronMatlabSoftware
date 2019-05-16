disp('Running MATLAB script file curvdatSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION curvdatSM,
%    CURVes as DATa analysis


itest = 35 ;     %  0,...,35


idata = 10 ;    %  numbers, 1,...,18 and data generation from EGCurvDat1.m
               %  Recommended are:
               %  5 (best), 10, 1, 9, 12



disp(['    running test ' num2str(itest)]) ;


%  Generate Data
%
if idata == 1 ;   
  %  Example called "Dog legs" in cdtest3.m
  n = 50 ;
  mu = [1; 0; .5] ;
  msig = [.3 0 .29; 0 .05 0; .29 0 .3] ;
  cmax = 2 ;
  randn('seed',23729877) ;
  mz = randn(3,n) ;
  mdata = sqrtm(msig) * mz + vec2matSM(mu,n) ;

elseif idata == 2 ;
  %  Example called "Fans" in cdtest3.m
  n = 50 ;
  mu = [0; .5; 1] ;
  msig = [.01 .01 .01; .01 .25 .25; .01 .25 .5] ;
  cmax = 2.5 ;
  randn('seed',97987373) ;
  mz = randn(3,n) ;
  mdata = sqrtm(msig) * mz + vec2matSM(mu,n) ;

elseif idata == 3 ;
  %  Example from classes\322\s322eg12.m  "Parabs"
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;

elseif idata == 4 ;
  %  Example from classes\322\s322eg12.m  (with outlier added)
  %                                "Parabs1out"
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;
  mdata = [mdata, 15 * (sin(pi * xgrid) + 1)] ;

elseif idata == 5 ;
  %  Example from classes\322\s322eg12.m  (with 2 outliers added)
  %                                "Parabs2out"
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;
  mdata = [mdata, 15 * (sin(pi * xgrid) + 1)] ;
  mdata = [mdata, 10 * (sin((pi / 2) * xgrid) + 1)] ;

elseif idata == 6 ;
  %  called "Sin''s, Dec. Power" in cdtest2.m
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',33399845) ;
  mdata = vec2matSM(8 * randn(1,n),d) ;
    swave = vec2matSM(sin(2 * pi * xgrid / d),n) ;
  mdata = mdata + (4 * swave .* vec2matSM(randn(1,n),d)) ;
    swave = vec2matSM(sin(4 * pi * xgrid / d),n) ;
  mdata = mdata + (2 * swave .* vec2matSM(randn(1,n),d)) ;
    swave = vec2matSM(sin(6 * pi * xgrid / d),n) ;
  mdata = mdata + (1 * swave .* vec2matSM(randn(1,n),d)) ;
  mdata = mdata + .05 * randn(d,n) ;

elseif idata == 7 ;
  %  called "Sin''s, Inc. Power" in cdtest2.m
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',98723999) ;
  mdata = vec2matSM(1 * randn(1,n),d) ;
    swave = vec2matSM(sin(2 * pi * xgrid / d),n) ;
  mdata = mdata + (2 * swave .* vec2matSM(randn(1,n),d)) ;
    swave = vec2matSM(sin(4 * pi * xgrid / d),n) ;
  mdata = mdata + (4 * swave .* vec2matSM(randn(1,n),d)) ;
    swave = vec2matSM(sin(6 * pi * xgrid / d),n) ;
  mdata = mdata + (8 * swave .* vec2matSM(randn(1,n),d)) ;
  mdata = mdata + .05 * randn(d,n) ;

elseif idata == 8 ;
  %  new example, with 2 "clusters"
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',23923874) ;
  mdata = (xgrid - 5).^2 - 5 ;
    randn('seed',88769874) ;
    mflag = vec2matSM(2 * (randn(1,n) > .5) - 1,d) ;
    eps1 = 2 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = .5 * randn(d,n) ;
  mdata = mflag .* vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;

elseif idata == 9 ;
  %  new example, with 4 "clusters"
  d = 50 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',93759872) ;
    rand('seed',30458744) ;
  mdata = 5 * (1 - cos(4 * pi * xgrid / d)) ;
  mdata = vec2matSM(mdata,n) ;
    halfd = floor(d/2) ;
    mflag = (1 - 2 * (rand(2,d) > .5)) ;
         %  random +- 1's
  mdata(1:halfd,:) = vec2matSM(mflag(1,:),halfd) .* mdata(1:halfd,:) ;
  mdata((halfd+1):d,:) = vec2matSM(mflag(2,:),d-halfd) .* ...
                                                mdata((halfd+1):d,:) ;
    eps3 = 1 * randn(d,n) ;
  mdata = mdata + eps3 ;

elseif idata == 10 ;
  %  new example, with 4 "clusters"
  d = 50 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',93759872) ;
    rand('seed',30458744) ;
  mdata = 5 * (1 - cos(4 * pi * xgrid / d)) ;
  mdata = vec2matSM(mdata,n) ;
    halfd = floor(d/2) ;
    mflag = (1 - 2 * (rand(2,d) > .5)) ;
         %  random +- 1's
  mdata(1:halfd,:) = vec2matSM(mflag(1,:),halfd) .* mdata(1:halfd,:) ;
  mdata((halfd+1):d,:) = vec2matSM(mflag(2,:),d-halfd) .* ...
                                                mdata((halfd+1):d,:) ;
    eps1 = .3 * randn(1,n) ;
    eps2 = .17 * randn(1,n) ;
    eps3 = .5 * randn(d,n) ;
  mdata = mdata + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;

elseif idata == 11 ;
  %  Shifted Parabs
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
    randn('seed',88769874) ;
    eps1 = 0.5 * randn(1,n) ;
    eps2 = 0.1 * randn(d,n) ;
  mdata = (vec2matSM(xgrid,n) - 6 - vec2matSM(eps1,d)).^2 ;
  mdata = mdata + eps2 ;

elseif idata == 12 ;
  %  Shifted Gaussians
  d = 101 ;
  n = 50 ;
  sig = 1 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = 1 * randn(1,n) ;
    eps2 = 0.001 * randn(d,n) ;
  mdata = ((vec2matSM(xgrid,n) - 5 - vec2matSM(eps1,d)) / sig) .^ 2 ;
  mdata = exp(-mdata / 2) ;
  mdata = mdata / (sqrt(2 * pi) * sig) ;
  mdata = mdata + eps2 ;

elseif idata == 13 ;
  %  Widened Gaussians
  d = 101 ;
  n = 50 ;
  sig = 1 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = 0.2 * randn(1,n) ;
    eps2 = 0.001 * randn(d,n) ;
  mdata = ((vec2matSM(xgrid,n) - 5) ./ (sig + vec2matSM(eps1,d))) .^ 2 ;
  mdata = exp(-mdata / 2) ;
  mdata = mdata / (sqrt(2 * pi) * sig) ;
  mdata = mdata + eps2 ;

elseif idata == 14 ;
  %  Narrow Shifted Gaussians
  d = 101 ;
  n = 50 ;
  sig = 0.2 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = 1 * randn(1,n) ;
    eps2 = 0.001 * randn(d,n) ;
  mdata = ((vec2matSM(xgrid,n) - 5 - vec2matSM(eps1,d)) / sig) .^ 2 ;
  mdata = exp(-mdata / 2) ;
  mdata = mdata / (sqrt(2 * pi) * sig) ;
  mdata = mdata + eps2 ;

elseif idata == 15 ;
  %  Wide Shifted Gaussians
  d = 101 ;
  n = 50 ;
  sig = 5 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = 1 * randn(1,n) ;
    eps2 = 0.001 * randn(d,n) ;
  mdata = ((vec2matSM(xgrid,n) - 5 - vec2matSM(eps1,d)) / sig) .^ 2 ;
  mdata = exp(-mdata / 2) ;
  mdata = mdata / (sqrt(2 * pi) * sig) ;
  mdata = mdata + eps2 ;

elseif idata == 16 ;
  %  3 bumps indep.
  d = 10 ;
  n = 50 ;
  sig = 0.1 ;
  sigb = 5 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = sigb * diag([1 3/2 2/3]) * randn(3,n) ;
    eps2 = sig * randn(d,n) ;
  mdata = zeros(d,n) ;
  mdata([2 5 9],:) = eps1 ;
  mdata = mdata + eps2 ;

elseif idata == 17 ;
  %  3 bumps 2 indep.
  d = 10 ;
  n = 50 ;
  sig = 0.1 ;
  sigb = 5 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = randn(2,n) ;
    eps1 = [eps1; eps1(1,:)] ;
    eps1 = sigb * diag([1 3/2 2/3]) * eps1 ;
    eps2 = sig * randn(d,n) ;
  mdata = zeros(d,n) ;
  mdata([2 5 9],:) = eps1 ;
  mdata = mdata + eps2 ;

elseif idata == 18 ;
  %  3 bumps dep.
  d = 10 ;
  n = 50 ;
  sig = 0.1 ;
  sigb = 5 ;
  xgrid = linspace(0.5,9.5,d)' ;
    randn('seed',88769874) ;
    eps1 = randn(1,n) ;
    eps1 = [eps1; eps1; eps1] ;
    eps1 = sigb * diag([1 3/2 2/3]) * eps1 ;
    eps2 = sig * randn(d,n) ;
  mdata = zeros(d,n) ;
  mdata([2 5 9],:) = eps1 ;
  mdata = mdata + eps2 ;

end ;    %  of idata if-block



if itest == 0 ;     %  input data only

  disp('Check input of data only') ;
  curvdatSM(mdata) ;


else ;     %  then use input paramstruct


  if itest == 1 ;    %  settings as in EGCurvDat1.m

    disp('Check settings as in EGCurvDat1.m') ;
    paramstruct = struct('itype',1, ...
                         'viout',1, ...
                         'icolor',1, ...
                         'jitterseed',37402983, ...
                         'iscreenwrite',1) ;


  elseif itest == 2 ;    %  pure defaults

    disp('Check pure defaults') ;
    paramstruct = struct([]) ;


  elseif itest == 3 ;    %  test 3 plot version

    disp('test 3 plot version') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'icolor',1, ...
                         'idiffigwind',0, ...
                         'iscreenwrite',1) ;


  elseif itest == 4 ;    %  test 3 plots in different figure windows

    disp('test 3 plots in different figure windows') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 5 ;    %  test 3 plots, and rainbow colors

    disp('test 3 plots, and rainbow colors') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'icolor',2, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 6 ;    %  test 3 plots, and non-standard PCs

    disp('test 3 plots, and non-standard PCs, vipcplot = [0 1 2]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'vipcplot',[0 1 2], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 7 ;    %  test 3 plots, and non-standard PCs

    disp('test 3 plots, and non-standard PCs, vipcplot = [0 5 6 7 8]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'vipcplot',[0 5 6 7 8], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 8 ;    %  test 3 plots, and non-standard PCs

    disp('test 3 plots, and non-standard PCs, vipcplot = [4 0 0 4 2]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'vipcplot',[4 0 0 4 2], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 9 ;    %  test 3 plots, and non-standard PCs

    disp('test 3 plots, and non-standard PCs, vipcplot = [0 1 2 3 20]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'vipcplot',[0 1 2 3 20], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 10 ;    %  test 3 plots, and postscript print

    disp('test 3 plots, and postscript print') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'icolor',1, ...
                         'idiffigwind',1, ...
                         'savestr','curvdatSMtest', ...
                         'iscreenwrite',0) ;
    disp('  ') ;
    disp('            NOTE: Check files curvdatSMtest__.ps') ;
    disp('  ') ;


  elseif itest == 11 ;    %  test vicolplot

    disp('test vicolplot, vicolplot = [1 3 4]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1], ...
                         'vicolplot',[1 3 4], ...
                         'icolor',1, ...
                         'iscreenwrite',0) ;


  elseif itest == 12 ;    %  test vicolplot

    disp('test vicolplot, vicolplot = [4 3 2]') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1], ...
                         'vicolplot',[4 3 2], ...
                         'icolor',1, ...
                         'iscreenwrite',0) ;


  elseif itest == 13 ;    %  test color matrix

    disp('test color matrix') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 14 ;    %  test subpop kde

    disp('test subpop kde') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'isubpopkde',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 15 ;    %  test data conn

    disp('test data conn') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    nd = size(mdata,2) ;
    idataconn = [[(nd - 4) (nd - 3)] ; ...
                 [(nd - 3) (nd - 2)] ; ...
                 [(nd - 2) (nd - 1)] ; ...
                 [(nd - 1) (nd)]] ; ...

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'isubpopkde',1, ...
                         'idataconn',idataconn, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 16 ;    %  test data conn, common color & type

    disp('test data conn, common color & type') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    nd = size(mdata,2) ;
    idataconn = [[(nd - 4) (nd - 3)] ; ...
                 [(nd - 3) (nd - 2)] ; ...
                 [(nd - 2) (nd - 1)] ; ...
                 [(nd - 1) (nd)]] ; ...

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'isubpopkde',1, ...
                         'idataconn',idataconn, ...
                         'idataconncolor','g', ...
                         'idataconntype','--', ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 17 ;    %  test data conn, different color & type

    disp('test data conn, different color & type') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    nd = size(mdata,2) ;
    idataconn = [[(nd - 4) (nd - 3)] ; ...
                 [(nd - 3) (nd - 2)] ; ...
                 [(nd - 2) (nd - 1)] ; ...
                 [(nd - 1) (nd)]] ; ...
    idataconncolor = [[0 0 0]; ...
                      [0 0 0]; ...
                      [0 1 0]; ...
                      [0 1 0]] ;
    idataconntype = strvcat('-','--','-.',':') ; 

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'isubpopkde',1, ...
                         'idataconn',idataconn, ...
                         'idataconncolor',idataconncolor, ...
                         'idataconntype',idataconntype, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 18 ;    %  test data conn, and spectrum colors

    disp('test data conn, and spectrum colors') ;
    nd = size(mdata,2) ;
    idataconn = [] ;
    ndat = size(mdata,2) ;
    for i = 1:(ndat - 1) ;
      idataconn = [idataconn; [i (i + 1)]] ;
    end ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',2, ...
                         'idataconn',idataconn, ...
                         'idataconncolor',2, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 19 ;    %  test visual axes, colored plot

    disp('test visual axes, iaxlim = 1, colored plot') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    nd = size(mdata,2) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'iaxlim',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 20 ;    %  test visual axes, default colors

    disp('test visual axes, iaxlim = 1, default colors') ;
    no2 = round(size(mdata,2) / 2) ;
    nd = size(mdata,2) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'iaxlim',1, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 21 ;    %  test symmetric visual axes, colored plot

    disp('test symmetric visual axes, iaxlim = 2, colored plot') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    nd = size(mdata,2) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'iaxlim',2, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 22 ;    %  test symmetric visual axes, default colors

    disp('test symmetric visual axes, iaxlim = 2, default colors') ;
    no2 = round(size(mdata,2) / 2) ;
    nd = size(mdata,2) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'iaxlim',2, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 23 ;    %  test common markers

    disp('test common markers') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr','+', ...
                         'iscreenwrite',1) ;


  elseif itest == 24 ;    %  test differing markers

    disp('test differing markers') ;
    ndat = size(mdata,2) ;
    no2 = round(ndat / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    markerstr = [] ;
    for i = 1:no2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;
    for i = 1:no2 ;
      markerstr = strvcat(markerstr,'x') ;
    end ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 25 ;    %  highlight last two points (outliers for idata = 5)

    disp('highlight last two points (outliers for idata = 5)') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 26 ;    %  test varimax

    disp('test varimax') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'ivarimax',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 27 ;    %  test Correlation Principal Components, itype = 2

    disp('test Correlation Principal Components, itype = 2') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',2, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 28 ;    %  test Spearman's Correlation PCA, itype = 3

    disp('test Spearman''s Correlation PCA, itype = 3') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',3, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 29 ;    %  test Shrink to sphere PCA, itype = 4

    disp('test Shrink to sphere PCA, itype = 4') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',4, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 30 ;    %  test Map to ellipse PCA, itype = 5

    disp('test Map to ellipse PCA, itype = 5') ;
    ndat = size(mdata,2) ;
    mcolor = ones(ndat - 2,1) * [0 0 0] ;
    mcolor = [mcolor; ones(2,1) * [1 0 0]] ;
    markerstr = [] ;
    for i = 1:(ndat - 2) ;
      markerstr = strvcat(markerstr,'*') ;
    end ;
    for i = 1:2 ;
      markerstr = strvcat(markerstr,'s') ;
    end ;

    paramstruct = struct('itype',5, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'markerstr',markerstr, ...
                         'iscreenwrite',1) ;


  elseif itest == 31 ;    %  test color matrix with too few columns

    disp('test color matrix with too few columns') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    mcolor = mcolor(:,[1 2]) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 32 ;    %  test color matrix with too few rows

    disp('test color matrix with too few rows') ;
    no2 = round(size(mdata,2) / 2) ;
    mcolor = ones(no2,1) * [1 0 0] ;
    mcolor = [mcolor; ones(size(mdata,2)-no2,1) * [0 0 1]] ;
    mcolor = mcolor(1:(end - 1),:) ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',mcolor, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 33 ;    %  test 3 plots, and gray level colors

    disp('test 3 plots, and gray level colors') ;
    paramstruct = struct('itype',1, ...
                         'viout',[1 2 3], ...
                         'icolor',3, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;


  elseif itest == 34 ;    %  test data conn, and gray level colors

    disp('test data conn, and gray level colors') ;
    nd = size(mdata,2) ;
    idataconn = [] ;
    ndat = size(mdata,2) ;
    for i = 1:(ndat - 1) ;
      idataconn = [idataconn; [i (i + 1)]] ;
    end ;

    paramstruct = struct('itype',1, ...
                         'viout',[1 3], ...
                         'icolor',3, ...
                         'idataconn',idataconn, ...
                         'idataconncolor',3, ...
                         'idiffigwind',1, ...
                         'iscreenwrite',1) ;



  elseif itest == 35 ;    %  test  spectrum colors, with .ps in output

    disp('test .ps in output file') ;

    paramstruct = struct('itype',1, ...
                         'viout',1, ...
                         'icolor',2, ...
                         'savestr','curvdatSMtest.ps', ...
                         'iscreenwrite',1) ;



  end ;    %  of itest if-block


  figure(1) ;
  clf ;

  curvdatSM(mdata,paramstruct) ;




end ;

