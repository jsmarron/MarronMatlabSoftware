disp('Running MATLAB script file DWDLargetest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DWDLarge,
%    Function from Kim-Chuab Toh
%    Website:    https://blog.nus.edu.sg/mattohkc/softwares/dwd/


itest = 3 ;     %  1,...,3



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


end ;
