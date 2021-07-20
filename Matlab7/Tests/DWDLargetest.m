disp('Running MATLAB script file DWDLargetest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DWDLarge,
%    Function from Kim-Chuab Toh
%    Website:    https://blog.nus.edu.sg/mattohkc/softwares/dwd/


itest = 28 ;     %  1 - simple test
                %  2 - Xi Yang no signal example, n = d = 100
                %  3 - No signal, n = d = 100, compare with DWD2 
                %           and explore DWD parameter
                %  4 - Very small signal, n = d = 100, compare with DWD2 
                %  5 - Small signal, n = d = 100, compare with DWD2 
                %  6 - Medium signal, n = d = 100, compare with DWD2 
                %  7 - Large signal, n = d = 100, compare with DWD2 
                %  8 - Compare DiProPerms, n = d = 100, Medium Signal
                %  9 - Compare DiProPerms, n = 50, d = 200, Medium Signal
                %  10 - Compare DiProPerms, n = 200, d = 50, Medium Signal
                %  11 - Compare DiProPerms, n = d = 100, Small Signal
                %  12 - Compare DiProPerms, n = 50, d = 200, Small Signal
                %  13 - Compare DiProPerms, n = 200, d = 50, Small Signal
                %  14 - Compare DiProPerms, n = d = 100, Large Signal
                %  15 - Compare DiProPerms, n = 50, d = 200, Large Signal
                %  16 - Compare DiProPerms, n = 200, d = 50, Large Signal
                %  17 - Check classification using unbalanced ns 
                %                for DWDLarge vs. DWD2, n1 = 200, n2 = 50, d = 10
                %  18 - Like 17, but n1 = 400, n2 = 25, d = 10
                %  19 - Like 17, but n1 = 100, n2 = 100, d = 10
                %  18 - Like 17, but n1 = 400, n2 = 25, d = 10
                %  20 - Like 17, but n1 = 2000, n2 = 500, d = 10
                %  21 - Like 17, but n1 = 4000, n2 = 250, d = 10
                %  22 - Like 17, but n1 = 1000, n2 = 1000, d = 10
                %  23 - Like 17, but n1 = 200, n2 = 500, d = 1000
                %  24 - Like 17, but n1 = 400, n2 = 25, d = 1000
                %  25 - Like 17, but n1 = 100, n2 = 100, d = 1000
                %  26 - Like 17, but n1 = 200, n2 = 500, d = 100
                %  27 - Like 17, but n1 = 400, n2 = 25, d = 100
                %  28 - Like 17, but n1 = 100, n2 = 100, d = 100




if itest == 1 ;    % simple test 

  rng(66430983) ;
  n1 = 10 ;
  n2 = 10 ;
  mdata1 = randn(50,n1) ;
  mdata2 = 1 + randn(50,n2) ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, simple call', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


elseif itest == 2 ;    % simple test, Xi Yang no signal example 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = randn(100,n2) ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, simple call, Xi Yang example', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


elseif itest == 3 ;    %  Xi Yang no signal example, compare with DWD2 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = randn(100,n2) ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, simple call, Xi Yang example', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


  %  Make corresponding default DWD2 graphic
  %
  vdirDWD2 = DWD2XQ(mdata1,mdata2) ;
  vdirDWD2 = vdirDWD2 ./ norm(vdirDWD2);

  figure(2) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, simple call, Xi Yang example', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2,paramstruct) ;


  %  Experiment with DWDLarge parameter
  %
  Ca = C / median(ddist)^2 ;
  vdira = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  vdira = vdira./norm(vdira);

  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, input parameter', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdira,paramstruct) ;


  %  Experiment with DWD2 parameter
  %
  DWDpar = 100 * median(ddist)^2 ;
  vdirDWD2a = DWD2XQ(mdata1,mdata2,2,[],DWDpar) ;
  vdirDWD2a = vdirDWD2a ./ norm(vdirDWD2a);

  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, input parameter', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2a,paramstruct) ;


  disp(['Angle DWDLarge & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & DWD2 (mod) dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2a)) / pi)]) ;
  disp(['Angle DWDLarge (mod) & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdira' * vdirDWD2)) / pi)]) ;


elseif itest == 4 ;    %  Very small signal example, compare with DWD2 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = 0.01 + randn(100,n2) ;
  vdirdiag = -ones(100,1) / 10 ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, very small signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


  %  Make corresponding default DWD2 graphic
  %
  vdirDWD2 = DWD2XQ(mdata1,mdata2) ;
  vdirDWD2 = vdirDWD2 ./ norm(vdirDWD2);

  figure(2) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, very small signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2,paramstruct) ;


  %  Experiment with DWDLarge parameter
  %
  Ca = C / median(ddist)^2 ;
  vdira = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  vdira = vdira./norm(vdira);

%{
%  This graphics looks very similar, so not constructed
  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWDLarge, input parameter, ' ...
                                      'very small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdira,paramstruct) ;
%}

  %  Experiment with DWD2 parameter
  %
  DWDpar = 100 * median(ddist)^2 ;
  vdirDWD2a = DWD2XQ(mdata1,mdata2,2,[],DWDpar) ;
  vdirDWD2a = vdirDWD2a ./ norm(vdirDWD2a);

  
%{
%  This graphics looks very similar, so not constructed
  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWD2, input parameter, ' ...
                                       'very small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2a,paramstruct) ;
%}


  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Projections on Diagonal, ' ...
                                      'very small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirdiag,paramstruct) ;


  %  Calculate Mean Difference direction
  %
  vdirMD = mean(mdata1,2) - mean(mdata2,2) ;
  vdirMD = vdirMD ./ norm(vdirMD) ;

  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Mean Difference, ' ...
                                      'very small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirMD,paramstruct) ;


  disp(['Angle DWDLarge & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & DWD2 (mod) dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2a)) / pi)]) ;
  disp(['Angle DWDLarge (mod) & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdira' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & truth dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirdiag)) / pi)]) ;
  disp(['Angle DWD2 & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirdiag)) / pi)]) ;
  disp(['Angle DWDLarge & MD dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirMD)) / pi)]) ;
  disp(['Angle DWD2 & MD dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirMD)) / pi)]) ;
  disp(['Angle MD & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirMD' * vdirdiag)) / pi)]) ;


elseif itest == 5 ;    %  Small signal example, compare with DWD2 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = 0.1 + randn(100,n2) ;
  vdirdiag = -ones(100,1) / 10 ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, Small signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


  %  Make corresponding default DWD2 graphic
  %
  vdirDWD2 = DWD2XQ(mdata1,mdata2) ;
  vdirDWD2 = vdirDWD2 ./ norm(vdirDWD2);

  figure(2) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, Small signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2,paramstruct) ;


  %  Experiment with DWDLarge parameter
  %
  Ca = C / median(ddist)^2 ;
  vdira = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  vdira = vdira./norm(vdira);

%{
%  This graphics looks very similar, so not constructed
  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWDLarge, input parameter, ' ...
                                      'Small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdira,paramstruct) ;
%}


  %  Experiment with DWD2 parameter
  %
  DWDpar = 100 * median(ddist)^2 ;
  vdirDWD2a = DWD2XQ(mdata1,mdata2,2,[],DWDpar) ;
  vdirDWD2a = vdirDWD2a ./ norm(vdirDWD2a);

%{
%  This graphics looks very similar, so not constructed
  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWD2, input parameter, ' ...
                                       'Small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2a,paramstruct) ;
%}


  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Projections on Diagonal, ' ...
                                      'Small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirdiag,paramstruct) ;


  %  Calculate Mean Difference direction
  %
  vdirMD = mean(mdata1,2) - mean(mdata2,2) ;
  vdirMD = vdirMD ./ norm(vdirMD) ;

  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Mean Difference, ' ...
                                      'Small signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirMD,paramstruct) ;


  disp(['Angle DWDLarge & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & DWD2 (mod) dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2a)) / pi)]) ;
  disp(['Angle DWDLarge (mod) & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdira' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & truth dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirdiag)) / pi)]) ;
  disp(['Angle DWD2 & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirdiag)) / pi)]) ;
  disp(['Angle DWDLarge & MD dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirMD)) / pi)]) ;
  disp(['Angle DWD2 & MD dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirMD)) / pi)]) ;
  disp(['Angle MD & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirMD' * vdirdiag)) / pi)]) ;


elseif itest == 6 ;    %  Medium signal example, compare with DWD2 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = 0.2 + randn(100,n2) ;
  vdirdiag = -ones(100,1) / 10 ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, Medium signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


  %  Make corresponding default DWD2 graphic
  %
  vdirDWD2 = DWD2XQ(mdata1,mdata2) ;
  vdirDWD2 = vdirDWD2 ./ norm(vdirDWD2);

  figure(2) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, Medium signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2,paramstruct) ;


  %  Experiment with DWDLarge parameter
  %
  Ca = C / median(ddist)^2 ;
  vdira = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  vdira = vdira./norm(vdira);

  %{
%  This graphics looks very similar, so not constructed
figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWDLarge, input parameter, ' ...
                                      'Medium signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdira,paramstruct) ;
%}


  %  Experiment with DWD2 parameter
  %
  DWDpar = 100 * median(ddist)^2 ;
  vdirDWD2a = DWD2XQ(mdata1,mdata2,2,[],DWDpar) ;
  vdirDWD2a = vdirDWD2a ./ norm(vdirDWD2a);

%{
%  This graphics looks very similar, so not constructed
  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWD2, input parameter, ' ...
                                       'Medium signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2a,paramstruct) ;
%}


  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Projections on Diagonal, ' ...
                                      'Medium signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirdiag,paramstruct) ;


  %  Calculate Mean Difference direction
  %
  vdirMD = mean(mdata1,2) - mean(mdata2,2) ;
  vdirMD = vdirMD ./ norm(vdirMD) ;

  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Mean Difference, ' ...
                                      'Medium signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirMD,paramstruct) ;


  disp(['Angle DWDLarge & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & DWD2 (mod) dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2a)) / pi)]) ;
  disp(['Angle DWDLarge (mod) & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdira' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & truth dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirdiag)) / pi)]) ;
  disp(['Angle DWD2 & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirdiag)) / pi)]) ;
  disp(['Angle DWDLarge & MD dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirMD)) / pi)]) ;
  disp(['Angle DWD2 & MD dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirMD)) / pi)]) ;
  disp(['Angle MD & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirMD' * vdirdiag)) / pi)]) ;


elseif itest == 7 ;    %  Large signal example, compare with DWD2 

  rng(66430983) ;
  n1 = 100 ;
  n2 = 100 ;
  mdata1 = randn(100,n1) ;
  mdata2 = 0.5 + randn(100,n2) ;
  vdirdiag = -ones(100,1) / 10 ;

  %  Call version from DiProPermXY.m
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  vdir = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  vdir = vdir./norm(vdir);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  %  Study projection of data onto this direction
  %
  figure(1) ;
  clf ;
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWDLarge, Large signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdir,paramstruct) ;

  disp(' ') ;
  disp(['Value of DWD parameter C = ' num2str(C)]) ;


  %  Make corresponding default DWD2 graphic
  %
  vdirDWD2 = DWD2XQ(mdata1,mdata2) ;
  vdirDWD2 = vdirDWD2 ./ norm(vdirDWD2);

  figure(2) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr','DWD2, Large signal, n = d = 100', ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2,paramstruct) ;


  %  Experiment with DWDLarge parameter
  %
  Ca = C / median(ddist)^2 ;
  vdira = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  vdira = vdira./norm(vdira);

  %{
%  This graphics looks very similar, so not constructed
figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWDLarge, input parameter, ' ...
                                      'Large signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdira,paramstruct) ;
%}


  %  Experiment with DWD2 parameter
  %
  DWDpar = 100 * median(ddist)^2 ;
  vdirDWD2a = DWD2XQ(mdata1,mdata2,2,[],DWDpar) ;
  vdirDWD2a = vdirDWD2a ./ norm(vdirDWD2a);

%{
%  This graphics looks very similar, so not constructed
  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['DWD2, input parameter, ' ...
                                       'Large signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirDWD2a,paramstruct) ;
%}


  figure(3) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Projections on Diagonal, ' ...
                                      'Large signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirdiag,paramstruct) ;


  %  Calculate Mean Difference direction
  %
  vdirMD = mean(mdata1,2) - mean(mdata2,2) ;
  vdirMD = vdirMD ./ norm(vdirMD) ;

  figure(4) ;
  clf ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',['Mean Difference, ' ...
                                      'Large signal, n = d = 100'], ...
                       'iscreenwrite',1) ;
  projplot1SM(DWDLarge_X,vdirMD,paramstruct) ;


  disp(['Angle DWDLarge & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & DWD2 (mod) dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirDWD2a)) / pi)]) ;
  disp(['Angle DWDLarge (mod) & DWD2 dirns = ' ...
                     num2str(180 * acos(abs(vdira' * vdirDWD2)) / pi)]) ;
  disp(['Angle DWDLarge & truth dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirdiag)) / pi)]) ;
  disp(['Angle DWD2 & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirdiag)) / pi)]) ;
  disp(['Angle DWDLarge & MD dirns = ' ...
                     num2str(180 * acos(abs(vdir' * vdirMD)) / pi)]) ;
  disp(['Angle DWD2 & MD dirns = ' ...
                     num2str(180 * acos(abs(vdirDWD2' * vdirMD)) / pi)]) ;
  disp(['Angle MD & truth dirns = ' ...
                     num2str(180 * acos(abs(vdirMD' * vdirdiag)) / pi)]) ;


elseif  itest == 8  | ...
        itest == 9  | ...
        itest == 10 | ...
        itest == 11 | ...
        itest == 12 | ...
        itest == 13 | ...
        itest == 14 | ...
        itest == 15 | ...
        itest == 16  ;    %  Do DiProPerm Comparisons

  if  itest == 8  | ...
      itest == 11  | ...
      itest == 14  ;    %  Compare DiProPerms, n = d = 100
    n1 = 100 ;
    n2 = 100 ;
    d = 100 ;
  elseif  itest == 9  | ...
          itest == 12  | ...
          itest == 15  ;    %  Compare DiProPerms, n = 50, d = 200
    n1 = 50 ;
    n2 = 50 ;
    d = 200 ;
  elseif itest == 10  | ...
         itest == 13  | ...
         itest == 16  ;    %  Compare DiProPerms, n = 200, d = 50
    n1 = 200 ;
    n2 = 200 ;
    d = 50 ;
  end ;

  if  itest == 8  | ...
      itest == 9  | ...
      itest == 10  ;    %  Compare DiProPerms, Medium Signal
    sigstr = 'Medium' ;
    mdata1 = randn(d,n1) ;
    mdata2 = 0.2 + randn(d,n2) ;
  elseif  itest == 11  | ...
          itest == 12  | ...
          itest == 13  ;    %  Compare DiProPerms, Small Signal
    sigstr = 'Small' ;
    mdata1 = randn(d,n1) ;
    mdata2 = 0.1 + randn(d,n2) ;
  elseif  itest == 14  | ...
          itest == 15  | ...
          itest == 16  ;    %  Compare DiProPerms, Large Signal
    sigstr = 'Large' ;
    mdata1 = randn(d,n1) ;
    mdata2 = 0.5 + randn(d,n2) ;
  end ;

  tic ;
  figure(1) ;    %  Mean Difference
  clf ;
  titlestr = [sigstr ' Signal, n = ' num2str(n1) ', d = ' num2str(d)] ;
  paramstruct = struct('idir',2, ...
                       'iper',2, ...
                       'ishowperm',2, ...
                       'title1str',titlestr, ...
                       'nreport',50, ...
                       'iscreenwrite',1) ;
  DiProPermXY(mdata1,mdata2,paramstruct) ;
  MDsec = toc ;

  tic ;
  figure(2) ;    %  DWD2
  clf ;
  titlestr = [sigstr ' Signal, n = ' num2str(n1) ', d = ' num2str(d)] ;
  paramstruct = struct('idir',1, ...
                       'iper',2, ...
                       'ishowperm',2, ...
                       'title1str',titlestr, ...
                       'nreport',50, ...
                       'iscreenwrite',1) ;
  DiProPermXY(mdata1,mdata2,paramstruct) ;
  DWD2sec = toc ;

  tic ;
  figure(3) ;    %  DWDlarge
  clf ;
  titlestr = [sigstr ' Signal, n = ' num2str(n1) ', d = ' num2str(d)] ;
  paramstruct = struct('idir',6, ...
                       'iper',2, ...
                       'ishowperm',2, ...
                       'title1str',titlestr, ...
                       'nreport',50, ...
                       'iscreenwrite',1) ;
  DiProPermXY(mdata1,mdata2,paramstruct) ;
  DWDLargesec = toc ;

  tic ;
  figure(4) ;    %  SVM
  clf ;
  titlestr = [sigstr ' Signal, n = ' num2str(n1) ', d = ' num2str(d)] ;
  paramstruct = struct('idir',5, ...
                       'iper',2, ...
                       'ishowperm',2, ...
                       'title1str',titlestr, ...
                       'nreport',50, ...
                       'iscreenwrite',1) ;
  DiProPermXY(mdata1,mdata2,paramstruct) ;
  SVMsec = toc ;

  disp(' ') ;
  disp(['Time for MD = ' num2str(MDsec) ' secs']) ;
  disp(['Time for DWD2 = ' num2str(DWD2sec) ' secs']) ;
  disp(['Time for DWD Large = ' num2str(DWDLargesec) ' secs']) ;
  disp(['Time for SVM = ' num2str(SVMsec) ' secs']) ;


elseif  itest == 17  | ...
        itest == 18  | ...
        itest == 19  | ...
        itest == 20  | ...
        itest == 21  | ...
        itest == 22  | ...
        itest == 23  | ...
        itest == 24  | ...
        itest == 25  | ...
        itest == 26  | ...
        itest == 27  | ...
        itest == 28  ;    %  Check classification using unbalanced ns 
                        %      for DWDLarge vs. DWD2

  if itest == 17 ;
    d = 10 ;
    n1 = 200 ;
    n2 = 50 ;
    mu = 1 ;
  elseif itest == 18 ;
    d = 10 ;
    n1 = 400 ;
    n2 = 25 ;
    mu = 1 ;
  elseif itest == 19 ;
    d = 10 ;
    n1 = 100 ;
    n2 = 100 ;
    mu = 1 ;
  elseif itest == 20 ;
    d = 10 ;
    n1 = 2000 ;
    n2 = 500 ;
    mu = 1 ;
  elseif itest == 21 ;
    d = 10 ;
    n1 = 4000 ;
    n2 = 250 ;
    mu = 1 ;
  elseif itest == 22 ;
    d = 10 ;
    n1 = 1000 ;
    n2 = 1000 ;
    mu = 1 ;
  elseif itest == 23 ;
    d = 1000 ;
    n1 = 200 ;
    n2 = 50 ;
    mu = 0.1 ;
  elseif itest == 24 ;
    d = 1000 ;
    n1 = 400 ;
    n2 = 25 ;
    mu = 0.1 ;
  elseif itest == 25 ;
    d = 1000 ;
    n1 = 100 ;
    n2 = 100 ;
    mu = 0.1 ;
  elseif itest == 26 ;
    d = 100 ;
    n1 = 200 ;
    n2 = 50 ;
    mu = 1 / sqrt(10) ;
  elseif itest == 27 ;
    d = 100 ;
    n1 = 400 ;
    n2 = 25 ;
    mu = 1 / sqrt(10) ;
  elseif itest == 28 ;
    d = 100 ;
    n1 = 100 ;
    n2 = 100 ;
    mu = 1 / sqrt(10) ;
  end ;

         
  rng(66430983) ;
  mdata1 = randn(d,n1) ;
  mdata2 = mu + randn(d,n2) ;
      %  training data
  mdata1t = randn(d,testfactor * n1) ;
  mdata2t = mu + randn(d,testfactor * n2) ;
      %  testing data


  vdirdiag = -ones(d,1) / sqrt(d) ;

  %  Make plot showing training data projected on the diagonal
  %
  figure(1) ;
  clf ;  
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  titlestr = 'Project training data onto diagonal, to check overlap' ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',titlestr, ...
                       'iscreenwrite',1) ;
  projplot1SM([mdata1 mdata2],vdirdiag,paramstruct) ;


  %  Run DWD2
  %
  [dirDWD2,betaDWD2,dr] = DWD2XQ(mdata1,mdata2,2,[mdata1t mdata2t]) ;

  disp(' ') ;
  drPtrain = dirDWD2' * mdata1 + betaDWD2 > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2errPtrain = sum(drPtrain == 0) ;
  drNtrain = dirDWD2' * mdata2 + betaDWD2 > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2errNtrain = sum(drNtrain == 1) ;
  tn1 = testfactor * n1 ;
  tn2 = testfactor * n2 ;
  DWD2errPtest = sum(dr(1:tn1) == -1) / tn1 ;
  disp(['Proportion of + cases misclassified by DWD2 = ' num2str(DWD2errPtest)]) ;
  DWD2errNtest = sum(dr((tn1 + 1):(tn1 + tn2)) == 1) / tn2 ;
  disp(['Proportion of - cases misclassified by DWD2 = ' num2str(DWD2errNtest)]) ;

  figure(2) ;
  clf ;  
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  titlestr = ['Project training data onto DWD2 direction, nP = ' ...
                  num2str(n1) ', nN = ' num2str(n2) ', d = ' num2str(d)] ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',titlestr, ...
                       'iscreenwrite',1) ;
  projplot1SM([mdata1 mdata2],dirDWD2,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-betaDWD2; -betaDWD2],[vax(3); vax(4)],'k--','LineWidth',2) ;
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train - Wrong = ' num2str(DWD2errNtrain)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train + Wrong = ' num2str(DWD2errPtrain)]) ;
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test - Wrong = ' num2str(DWD2errNtest)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test + Wrong = ' num2str(DWD2errPtest)]) ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.2 * (vax(4) - vax(3)), ...
         ['Angle Truth & DWD2 dirns = ' ...
              num2str(180 * acos(abs(vdirdiag' * dirDWD2)) / pi,4) ' deg']) ;
  hold off ;


  %  Run DWD2 (DWDLarge Implementation)
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  Ca = C / median(ddist)^2 ;
  [dirDWD2L,betaDWD2L] = genDWDweighted(DWDLarge_X,DWDLarge_y,Ca,1,options);
  dirDWD2L = dirDWD2L./norm(dirDWD2L);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  disp(' ') ;
  drPtrain = dirDWD2L' * mdata1 + betaDWD2L > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2LerrPtrain = sum(drPtrain == 0) ;
  drNtrain = dirDWD2L' * mdata2 + betaDWD2L > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2LerrNtrain = sum(drNtrain == 1) ;
  tn1 = testfactor * n1 ;
  tn2 = testfactor * n2 ;
  drPtest = dirDWD2L' * mdata1t + betaDWD2L > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2LerrPtest = sum(drPtest == 0) / tn1 ;
  disp(['Proportion of + cases misclassified by DWD2(L) = ' num2str(DWD2LerrPtest)]) ;
  drNtest = dirDWD2L' * mdata2t + betaDWD2L > 0 ;
      %  one for class'ed positive, zero for negative
  DWD2LerrNtest = sum(drNtest == 1) / tn2 ;
  disp(['Proportion of - cases misclassified by DWDLarge = ' num2str(DWD2LerrNtest)]) ;

  figure(3) ;
  clf ;  
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  titlestr = ['Project training data onto DWD2 (L) direction, nP = ' ...
                  num2str(n1) ', nN = ' num2str(n2) ', d = ' num2str(d)] ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',titlestr, ...
                       'iscreenwrite',1) ;
  projplot1SM([mdata1 mdata2],dirDWD2L,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-betaDWD2L; -betaDWD2L],[vax(3); vax(4)],'k--','LineWidth',2)
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train - Wrong = ' num2str(DWD2LerrNtrain)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train + Wrong = ' num2str(DWD2LerrPtrain)]) ;
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test - Wrong = ' num2str(DWD2LerrNtest)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test + Wrong = ' num2str(DWD2LerrPtest)]) ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.2 * (vax(4) - vax(3)), ...
         ['Angle Truth & DWD2 (L) dirns = ' ...
              num2str(180 * acos(abs(vdirdiag' * dirDWD2L)) / pi,4) ' deg']) ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.1 * (vax(4) - vax(3)), ...
         ['Angle DWD2 & DWD2 (L) dirns = ' ...
              num2str(180 * acos(abs(dirDWD2' * dirDWD2L)) / pi,4) ' deg']) ;
  hold off ;


  %  Run DWDLarge
  %
  DWDLarge_X = [mdata1 mdata2];
  DWDLarge_y = [ones(1, size(mdata1, 2)) -ones(1, size(mdata2, 2))]';
  options.method = 1; 
  options.printlevel = 0 ;
  [C,ddist] = penaltyParameter(DWDLarge_X,DWDLarge_y,1);
  [dirDWDL,betaDWDL] = genDWDweighted(DWDLarge_X,DWDLarge_y,C,1,options);
  dirDWDL = dirDWDL./norm(dirDWDL);
      %  DWD new algorithm direction vector, pointing from 2nd group towards first

  disp(' ') ;
  drPtrain = dirDWDL' * mdata1 + betaDWDL > 0 ;
      %  one for class'ed positive, zero for negative
  DWDLerrPtrain = sum(drPtrain == 0) ;
  drNtrain = dirDWDL' * mdata2 + betaDWDL > 0 ;
      %  one for class'ed positive, zero for negative
  DWDLerrNtrain = sum(drNtrain == 1) ;
  tn1 = testfactor * n1 ;
  tn2 = testfactor * n2 ;
  drPtest = dirDWDL' * mdata1t + betaDWDL > 0 ;
      %  one for class'ed positive, zero for negative
  DWDLerrPtest = sum(drPtest == 0) / tn1 ;
  disp(['Proportion of + cases misclassified by DWDLarge = ' num2str(DWDLerrPtest)]) ;
  drNtest = dirDWDL' * mdata2t + betaDWDL > 0 ;
      %  one for class'ed positive, zero for negative
  DWDLerrNtest = sum(drNtest == 1) / tn2 ;
  disp(['Proportion of - cases misclassified by DWDLarge = ' num2str(DWDLerrNtest)]) ;

  figure(4) ;
  clf ;  
  mcolor = [ones(n1,1) * [1 0 0] ; ...
            ones(n2,1) * [0 0 1]] ;
  vmarkerstr = [] ;
  for i = 1:n1 ;
    vmarkerstr = strvcat(vmarkerstr,'+') ;
  end ;
  for i = 1:n2 ;
    vmarkerstr = strvcat(vmarkerstr,'o') ;
  end ;
  titlestr = ['Project training data onto DWDLarge direction, nP = ' ...
                  num2str(n1) ', nN = ' num2str(n2) ', d = ' num2str(d)] ;
  paramstruct = struct('icolor',mcolor, ...
                       'markerstr',vmarkerstr, ...
                       'isubpopkde1',1, ...
                       'titlestr',titlestr, ...
                       'iscreenwrite',1) ;
  projplot1SM([mdata1 mdata2],dirDWDL,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-betaDWDL; -betaDWDL],[vax(3); vax(4)],'k--','LineWidth',2)
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train - Wrong = ' num2str(DWDLerrNtrain)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.9 * (vax(4) - vax(3)), ...
         ['Num Train + Wrong = ' num2str(DWDLerrPtrain)]) ;
    text(vax(1) + 0.55 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test - Wrong = ' num2str(DWDLerrNtest)]) ;
    text(vax(1) + 0.05 * (vax(2) - vax(1)), ...
         vax(3) + 0.8 * (vax(4) - vax(3)), ...
         ['Prop Test + Wrong = ' num2str(DWDLerrPtest)]) ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.2 * (vax(4) - vax(3)), ...
         ['Angle Truth & DWD Large dirns = ' ...
              num2str(180 * acos(abs(vdirdiag' * dirDWDL)) / pi,4) ' deg']) ;
    text(vax(1) + 0.2 * (vax(2) - vax(1)), ...
         vax(3) + 0.1 * (vax(4) - vax(3)), ...
         ['Angle DWD2 & DWDLarge dirns = ' ...
              num2str(180 * acos(abs(dirDWD2' * dirDWDL)) / pi,4) ' deg']) ;
  hold off ;




end ;
