disp('Running MATLAB script file DIVASDoubJointSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DIVASDoubJointSM,
%    Doubly Joint DIVAS

itest = 1 ;     %  1,...,6        Simple paramegter tests
                %  101,...,116    Toy examples from DoublyJointToy8.m


if itest < 100      %  Simple paramegter tests

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
%  mX = mX1 + mX2 ;
  mY1 = u2 * v2' ;
  mY2 = 0.8 * u3 * v3' ;
  mY = mY1 + mY2 + sig * randn(d,n) ;
%  mY = mY1 + mY2 ;
  disp(' ') ;

  if itest == 1 
    disp('Defauts only') ;
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



  end ;    %  of inner itest if-block



else      %  Toy examples from DoublyJointToy8.m






end ;    %  of itest < 0r > 100 if-block




