disp('Running MATLAB script file SigClust2meanFastSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClust2meanFastSM
%     computes 2-MEAN clustering using a FAST algorithm

itest = 18 ;     %  1,2,3,4,5,6,7,11,12,13,15,16,17,18,19,20,21,22,23,31,32,33,34,35


if itest == 1 ;    %  Simple strongly clustered data, all defaults

  randn('state',70374372402) ;
  data = randn(2,5) ;
  data = [data (10 * ones(2,5) + randn(2,5))] ; 

  [bestClass, bestCI] = SigClust2meanFastSM(data) 


elseif itest == 2 ;    %  Simple strongly clustered data, with full screen write

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',70374372402) ;
  data = randn(2,5) ;
  data = [data (10 * ones(2,5) + randn(2,5))] ; 

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


elseif itest == 3 ;    %  Simple Gaussian data, with full screen write

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',2398344375) ;
  data = randn(10,10) ;

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


elseif itest == 4 ;    %  Data on 5-simplex in 10-d 

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',424856325) ;
  data = randn(10,50) ;
  data(1,1:10) = data(1,1:10) + 100 * ones(1,10) ;
  data(2,11:20) = data(2,11:20) + 100 * ones(1,10) ;
  data(3,1:30) = data(3,21:30) + 100 * ones(1,10) ;
  data(4,31:40) = data(4,31:40) + 100 * ones(1,10) ;
  data(5,41:50) = data(5,41:50) + 100 * ones(1,10) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


elseif itest == 5 ;    %  Data in 4 balanced clusters

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',9834757345) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,5) + randn(2,5))] ; 
  data = [data ([(100 * ones(1,5)); zeros(1,5)] + randn(2,5))] ; 
  data = [data ([zeros(1,5); (100 * ones(1,5))] + randn(2,5))] ; 

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


elseif itest == 6 ;    %  Data in 4 unbalanced clusters

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',9834757345) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,8) + randn(2,8))] ; 
  data = [data ([(100 * ones(1,7)); zeros(1,7)] + randn(2,7))] ; 
  data = [data ([zeros(1,6); (100 * ones(1,6))] + randn(2,6))] ; 

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


elseif itest == 7 ;    %  1-d Data in 2 unbalanced clusters

  paramstruct = struct('iscreenwrite',1) ;

  randn('state',9834757345) ;
  data = randn(1,6) ;
  data = [data (100 * ones(1,4) + randn(1,4))] ; 

  [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 

  disp('Check Computed CI vs:') ;
  ClustIndSM(data,logical([1 1 1 1 1 1 0 0 0 0]),logical([0 0 0 0 0 0 1 1 1 1]))


elseif itest <= 30 ;    %  Do parameter tests, Data in 4 unbalanced clusters


  paramstruct = struct('iscreenwrite',1) ;

  randn('state',9834757345) ;
  data = randn(3,5) ;
  data = [data (100 * ones(3,8) + randn(3,8))] ; 
  data = [data ([(100 * ones(1,7)); zeros(2,7)] + randn(3,7))] ; 
  data = [data ([zeros(1,6); (100 * ones(2,6))] + randn(3,6))] ; 

  if itest == 11 ;    %  paramstruct, with all defaults 

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',0,...
                         'ibelowdiag',1,...
                         'titlestr',[],...
                         'titlefontsize',[],...
                         'labelfontsize',[],...
                         'savestr',[],...
                         'iscreenwrite',0) ;

    %  Update to properly handle empty components
    %
    labelcellstr = {} ;
    if ~(isempty(labelcellstr)) ;
      paramstruct = setfield(paramstruct,'xlabelstr',labelcellstr{1}) ;
    end ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 12 ;    %  Test Titles

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',0,...
                         'ibelowdiag',1,...
                         'titlestr','Test Title',...
                         'titlefontsize',[],...
                         'labelfontsize',[],...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    %  Update to properly handle empty components
    %
    labelcellstr = {} ;
    if ~(isempty(labelcellstr)) ;
      paramstruct = setfield(paramstruct,'xlabelstr',labelcellstr{1}) ;
    end ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 13 ;    %  Test Title Font Size

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',0,...
                         'ibelowdiag',1,...
                         'titlestr','Test Title Font Size',...
                         'titlefontsize',18,...
                         'labelfontsize',[],...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    %  Update to properly handle empty components
    %
    labelcellstr = {} ;
    if ~(isempty(labelcellstr)) ;
      paramstruct = setfield(paramstruct,'xlabelstr',labelcellstr{1}) ;
    end ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 14 ;    %  Test Label Font Size

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',0,...
                         'ibelowdiag',1,...
                         'titlestr','Test Label Font Size',...
                         'titlefontsize',12,...
                         'labelcellstr',{{{'Label 1' 'Label 2' 'Label 3'}}},...
                         'labelfontsize',18,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 15 ;    %  Test ibelowdiag

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',0,...
                         'ibelowdiag',0,...
                         'titlestr','Test ibelowdiag = 0',...
                         'titlefontsize',12,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 16 ;    %  Test iplotaxes

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',0,...
                         'titlestr','Test iplotaxes = 0',...
                         'titlefontsize',12,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 17 ;    %  Test symmetric maxlim

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',1,...
                         'titlestr','Test symmetric maxlim',...
                         'titlefontsize',12,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 18 ;    %  Test given maxlim

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[[-100 200]; [-150 100]; [-5 3]],...
                         'titlestr','Test given maxlim',...
                         'titlefontsize',12,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 19 ;    %  Test given markerstr

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('s','v'),...
                         'titlestr','Test markers',...
                         'titlefontsize',12,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 20 ;    %  Test given colors

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[0 1 0]; [1 0 1]],...
                         'titlestr','Test Colors',...
                         'titlefontsize',18,...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 21 ;    %  Test savestr

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'titlestr','Test File Save',...
                         'titlefontsize',12,...
                         'savestr','temp',...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 

    disp('  ') ;
    disp('    Look for files starting with temp') ;


  elseif itest == 22 ;    %  Test ioutplot

    paramstruct = struct('maxstep',10,...
                         'ioutplot',0,...
                         'titlestr','Test ioutplot = 0',...
                         'titlefontsize',12,...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 23 ;    %  Test ioutplot = 2

    paramstruct = struct('maxstep',10,...
                         'ioutplot',2,...
                         'titlestr','Test ioutplot = 2',...
                         'titlefontsize',12,...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  end ;


elseif itest <= 40 ;    %  Do parameter tests, Data on 4-simplex in 10-d 

  randn('state',424856325) ;
  data = randn(10,40) ;
  data(1,1:10) = data(1,1:10) + 10 * ones(1,10) ;
  data(2,11:20) = data(2,11:20) + 10 * ones(1,10) ;
  data(3,21:30) = data(3,21:30) + 10 * ones(1,10) ;
  data(4,31:40) = data(4,31:40) + 10 * ones(1,10) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;


  if itest == 31 ;    %  Test iplotdirvec = 1

    paramstruct = struct('maxstep',10,...
                         'ioutplot',1,...
                         'icolor',[[1 0 0]; [0 0 1]],...
                         'markerstr',strvcat('o','+'),...
                         'maxlim',[],...
                         'iplotaxes',1,...
                         'iplotdirvec',1,...
                         'titlestr','Test iplotdirvec = 1',...
                         'savestr',[],...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 32 ;    %  Test ioutplot = 2

    paramstruct = struct('maxstep',5,...
                         'ioutplot',2,...
                         'titlestr','Test ioutplot = 2',...
                         'titlefontsize',12,...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 33 ;    %  Test ioutplot = 2 & labels

    paramstruct = struct('maxstep',5,...
                         'ioutplot',2,...
                         'titlestr','Test ioutplot = 2 & given labels',...
                         'labelcellstr',{{{'Label 1' 'Label 2' 'Label 3' 'Label 4'}}},...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 34 ;    %  Test ioutplot = 2 & labels & labelfontsize

    paramstruct = struct('maxstep',5,...
                         'ioutplot',2,...
                         'titlestr','Test ioutplot = 2 & given labels & labelfontsize',...
                         'labelcellstr',{{{'Label 1' 'Label 2' 'Label 3' 'Label 4'}}},...
                         'labelfontsize',12,...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  elseif itest == 35 ;    %  Test ioutplot = 2 & labelfontsize

    paramstruct = struct('maxstep',5,...
                         'ioutplot',2,...
                         'titlestr','Test ioutplot = 2 & labelfontsize',...
                         'labelfontsize',12,...
                         'iscreenwrite',1) ;

    [bestClass, bestCI] = SigClust2meanFastSM(data,paramstruct) 


  end ;


end ;


