disp('Running MATLAB script file DIVASDoubJointSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DIVASDoubJointSM,
%    Doubly Joint DIVAS

itest = 1 ;     %  1,...,15        Simple paramegter tests
                %  101,...,116    Toy examples from DoublyJointToy8.m


if itest < 100      %  Simple parameter tests

  %  Use very simple noiseless data from DoublyCrossJointSim
  %  Called "unballanced Doubly Joint"
  %
  d = 16 ;
  n = 12 ;
  rng(12387632) ;
  sig = 10^(-2) ;
  u2 = [ones(d / 2,1); -ones(d / 2,1)] ;
  u3 = [ones(d / 4,1); -ones(d / 2,1); ones(d / 4,1)] ;
  v2 = [ones(n / 2,1); -ones(n / 2,1)] ;
  v3 = [ones(n / 4,1); -ones(n / 2,1); ones(n / 4,1)] ;
  mX1 = u2 * v2' ;
  mX2 = 0.9 * u3 * v3' ;
  mX = mX1 + mX2 + sig * randn(d,n) ;
  mY1 = u2 * v2' ;
  mY2 = 0.8 * u3 * v3' ;
  mY = mY1 + mY2 + sig * randn(d,n) ;
  disp(' ') ;

  if itest == 1 
    disp('Defaults only') ;
    outstruct = DIVASDoubJointSM(mX,mY)

  elseif itest == 2
    disp('test iscreenwrite = 0, only') ;
    paramstruct = struct('iscreenwrite',0) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 3
    disp('test iscreenwrite = 1, only') ;
    paramstruct = struct('iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 4
    disp('test wrong number rows in inputs') ;
    paramstruct = struct('iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY(1:5,:),paramstruct)

  elseif itest == 5
    disp('test wrong number columns in inputs') ;
    paramstruct = struct('iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX(:,1:5),mY,paramstruct)

  elseif itest == 6
    disp('test no diagnostic plots') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 7
    disp('test save figures as output Matlab files') ;
    paramstruct = struct('DiagPlotStr','DIVASDoubJointSMtest', ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 8
    disp('test explicitly saving figures as output Matlab files') ;
    paramstruct = struct('DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',1, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 9
    disp('test save figures as output .png files') ;
    paramstruct = struct('DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',2, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 10
    disp('test save figures as output .pdf files') ;
    paramstruct = struct('DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',3, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 11
    disp('test iScaleStand = 0, graphics off') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  elseif itest == 12
    disp('test iScaleStand = 0, magnified mX, shrunken mY, graphics off') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(100 * mX,mY / 100,paramstruct)

  elseif itest == 13
    disp('test iScaleStand = 0, shrunken mX, graphics off') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX/100,mY,paramstruct)

  elseif itest == 14
    disp('test iScaleStand = 0, shrunken mX and mY, graphics off') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX / 100,mY / 100,paramstruct)

  elseif itest == 15
    disp('test iScaleStand = 1, shrunken mX and mY, graphics off') ;
    paramstruct = struct('iDiagPlot',0, ...
                         'iScaleStand',1, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX / 100,mY / 100,paramstruct)



%{
  elseif itest == 
    disp('test ') ;
    paramstruct = struct('',, ...
                         '',, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
%}


  end ;    %  of inner itest if-block



else      %  Toy examples from DoublyJointToy8.m






end ;    %  of itest < 0r > 100 if-block




