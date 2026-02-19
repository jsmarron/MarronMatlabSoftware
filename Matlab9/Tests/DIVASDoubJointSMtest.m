disp('Running MATLAB script file DIVASDoubJointSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DIVASDoubJointSM,
%    Doubly Joint DIVAS

itest = 118 ;     %  1,...,19        Simple parameter tests
                %  101,...,118    Toy examples from DoublyJointToy8.m


if itest < 100      %  Simple parameter tests

  %  Use very simple noiseless data from DoublyCrossJointSim
  %  Called "unballanced Doubly Joint"
  %
  d = 16 ;
  n = 12 ;
%  rng(12387632) ;    %  Original seed, with too many modes
  rng(99237447) ;    %  Improved seed from TriMEtest.m
  rng(23986486) ;
  rng(82337269) ;    %  Final nicest choice
  sig = 10^(-2) ;
  u2 = [ones(d / 2,1); -ones(d / 2,1)] ;
  u3 = [ones(d / 4,1); -ones(d / 2,1); ones(d / 4,1)] ;
  v2 = [ones(n / 2,1); -ones(n / 2,1)] ;
  v3 = [ones(n / 4,1); -ones(n / 2,1); ones(n / 4,1)] ;
  mX1 = u2 * v2' ;
%  mX2 = 0.9 * u3 * v3' ;
  mX2 = 0.5 * u3 * v3' ;
      %  Distinctly different doubly joint modes seems
      %  to avoid finding additional spurious molds
  mX = mX1 + mX2 + sig * randn(d,n) ;
  mY1 = u2 * v2' ;
%  mY2 = 0.8 * u3 * v3' ;
  mY2 = 0.5 * u3 * v3' ;
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
    vthresh = outstruct.vthresh ;
    disp('test iscreenwrite = 1, only') ;

  elseif itest == 4
    disp('test nThreshSim = 0') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test nThreshSim = 0') ;

  elseif itest == 5
    disp('test nThreshSim = 0, with input vthresh') ;
    disp('make sure have run itest=3, so have vthresh') ;
    paramstruct = struct('nThreshSim',0, ...
                         'vthresh',vthresh, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test nThreshSim = 0, and input vthresh') ;

  elseif itest == 6
    disp('test wrong number rows in inputs') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY(1:5,:),paramstruct)
    disp('test wrong number rows in inputs') ;

  elseif itest == 7
    disp('test wrong number columns in inputs') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX(:,1:5),mY,paramstruct)
    disp('test wrong number columns in inputs') ;

  elseif itest == 8
    disp('test no diagnostic plots') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test no diagnostic plots') ;

  elseif itest == 9
    disp('test save figures as output Matlab files') ;
    paramstruct = struct('nThreshSim',0, ...
                         'DiagPlotStr','DIVASDoubJointSMtest', ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test save figures as output Matlab files') ;

  elseif itest == 10
    disp('test explicitly saving figures as output Matlab files') ;
    paramstruct = struct('nThreshSim',0, ...
                         'DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',1, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test explicitly saving figures as output Matlab files') ;

  elseif itest == 11
    disp('test save figures as output .png files') ;
    paramstruct = struct('nThreshSim',0, ...
                         'DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',2, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test save figures as output .png files') ;

  elseif itest == 12
    disp('test save figures as output .pdf files') ;
    paramstruct = struct('nThreshSim',0, ...
                         'DiagPlotStr','DIVASDoubJointSMtest', ...
                         'savetype',3, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test save figures as output .pdf files') ;

  elseif itest == 13
    disp('test iScaleStand = 0, graphics off') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test iScaleStand = 0, graphics off') ;

  elseif itest == 14
    disp('test iScaleStand = 0, magnified mX, shrunken mY, graphics off') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(100 * mX,mY / 100,paramstruct)
    disp('test iScaleStand = 0, magnified mX, shrunken mY, graphics off') ;

  elseif itest == 15
    disp('test iScaleStand = 0, shrunken mX, graphics off') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX/100,mY,paramstruct)
    disp('test iScaleStand = 0, shrunken mX, graphics off') ;

  elseif itest == 16
    disp('test iScaleStand = 0, shrunken mX and mY, graphics off') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iScaleStand',0, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX / 100,mY / 100,paramstruct)
    disp('test iScaleStand = 0, shrunken mX and mY, graphics off') ;

  elseif itest == 17
    disp('test iScaleStand = 1, shrunken mX and mY, graphics off') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'iScaleStand',1, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX / 100,mY / 100,paramstruct)
    disp('test iScaleStand = 1, shrunken mX and mY, graphics off') ;

  elseif itest == 18
    disp('test small nmaxstep to cut off computation, no graphics') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'nmaxstep',1, ...
                         'iscreenwrite',1) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test small nmaxstep to cut off computation, no graphics') ;

  elseif itest == 19
    disp('test small nmaxstep to cut off computation, no screenwrite') ;
    paramstruct = struct('nThreshSim',0, ...
                         'iDiagPlot',0, ...
                         'nmaxstep',1, ...
                         'iscreenwrite',0) ;
    outstruct = DIVASDoubJointSM(mX,mY,paramstruct)
    disp('test small nmaxstep to cut off computation, no screenwrite') ;



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

  %  Set common quantities
  %
  d = 80 ;
  n = 60 ;
  seed = 56829741 ;
  rng(seed) ;
  sig = 1 ;
  cS = 15 ;
  cM = 30 ;
  cL = 60 ;
  u1 = ones(d,1) ;
  u2 = [ones(d / 2,1); -ones(d / 2,1)] ;
  u3 = [ones(d / 4,1); -ones(d / 2,1); ones(d / 4,1)] ;
  u4 = [ones(d / 4,1); -ones(d / 4,1); ones(d / 4,1); -ones(d / 4,1)] ;
  u5 = [ones(d / 8,1); -ones(d / 4,1); ones(d / 4,1); ...
        -ones(d / 4,1); ones(d / 8,1)] ;
  u8 = [ones(d / 8,1); -ones(d / 8,1); ones(d / 8,1); -ones(d / 8,1); ...
        ones(d / 8,1); -ones(d / 8,1); ones(d / 8,1); -ones(d / 8,1)] ;
  v1 = ones(n,1) ;
  v2 = [ones(n / 2,1); -ones(n / 2,1)] ;
  v3 = [ones(n / 4,1); -ones(n / 2,1); ones(n / 4,1)] ;
  v4 =  [ones(n / 4,1); -ones(n / 4,1); ones(n / 4,1); -ones(n / 4,1)] ;
  u1 = u1 / norm(u1) ;
  u2 = u2 / norm(u2) ;
  u3 = u3 / norm(u3) ;
  u4 = u4 / norm(u4) ;
  u5 = u5 / norm(u5) ;
  u8 = u8 / norm(u8) ;
  v1 = v1 / norm(v1) ;
  v2 = v2 / norm(v2) ;
  v3 = v3 / norm(v3) ;
  v4 = v4 / norm(v4) ;

  %  Generate Signal Matrices
  %
  if itest == 101    %  IxO+IyO, Pure Noise

    stitle = '1 Pure Noise' ;
    ssave = 'IxO+IyO' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = zeros(d,n) ;
    mYtrue = zeros(d,n) ;

  elseif itest == 102    %  IxS+IyS, Ind XS Ind YS

    stitle = '2 Ind XS Ind YS' ;
    ssave = 'IxS+IyS' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u4 * v3' ;
    mYtrue = cS * u2 * v1' ;

  elseif itest == 103    %  IxM+IyM, Ind XM Ind YM

    stitle = '3 Ind XM Ind YM' ;
    ssave = 'IxM+IyM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u4 * v3' ;
    mYtrue = cM * u1 * v2' ;

  elseif itest == 104    %  JuMM, Singly J UMM

    stitle = '4 Singly J UMM' ;
    ssave = 'JuMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u3 * v1' ;
    mYtrue = cM * u3 * v2' ;

  elseif itest == 105    %  JuSS, Singly J USS

    stitle = '5 Singly J USS' ;
    ssave = 'JuSS' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u3 * v1' ;
    mYtrue = cS * u3 * v2' ;

  elseif itest == 106    %  JvML, Singly J VML

    stitle = '6 Singly J VML' ;
    ssave = 'JvML' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u2 * v3' ;
    mYtrue = cL * u1 * v3' ;

  elseif itest == 107    %  JvSS, Singly J VSS

    stitle = '7 Singly J VSS' ;
    ssave = 'JvSS' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u2 * v3' ;
    mYtrue = cS * u1 * v3' ;

  elseif itest == 108    %  DLM, Doubly J LM

    stitle = '8 Doubly J LM' ;
    ssave = 'DLM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cL * u4 * v3' ;
    mYtrue = cM * u4 * v3' ;

  elseif itest == 109    %  DSS, Doubly J SS

    stitle = '9 Doubly J SS' ;
    ssave = 'DSS' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u4 * v3' ;
    mYtrue = cS * u4 * v3' ;

  elseif itest == 110    %  DMM+IXM+IYM, DoubJ & 2Ind

    stitle = '10 DoubJ & 2Ind' ;
    ssave = 'DMM+IXM+IYM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u4 * v3' + cM * u8 * v1' ;
    mYtrue = cM * u4 * v3' + cM * u5 * v2' ;

  elseif itest == 111    %  JuMM+JvMM, SingJ U & V

    stitle = '11 SingJ U & V' ;
    ssave = 'JuMM+JvMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u3 * v1' + cM * u8 * v4' ;
    mYtrue = cM * u3 * v2' + cM * u5 * v4' ;

  elseif itest == 112    %  IxS+Iy0, Ind XS only

    stitle = '12 Ind XS only' ;
    ssave = 'IxS+Iy0' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u4 * v3' ;
    mYtrue = zeros(d,n) ;

  elseif itest == 113    %  Ix0+IyM, Ind YM only

    stitle = '13 Ind YM only' ;
    ssave = 'Ix0+IyM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = zeros(d,n) ;
    mYtrue = cM * u2 * v1' ;

  elseif itest == 114     %  DMM+DMM, Cross DJ Even

    stitle = '14 Cross DJ, Even' ;
    ssave = 'DMM+DMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u3 * v3' + cM * u2 * v2' ;
    mYtrue = cM * u3 * v2' + cM * u2 * v3' ;

  elseif itest == 115     %  DSM+DLM, Cross DJ, Unb.

    stitle = '15 Cross DJ, Unb.' ;
    ssave = 'DSM+DLM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cS * u3 * v3' + cM * u2 * v2' ;
    mYtrue = cL * u3 * v2' + cM * u2 * v3' ;

  elseif itest == 116     %  DMM+DMM+DMM, Cross DJ 3

    stitle = '16 Cross DJ 3' ;
    ssave = 'DMM+DMM+DMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u3 * v3' + cM * u2 * v4' + cM * u4 * v2' ;
    mYtrue = cM * u3 * v2' + cM * u4 * v4' + cM * u2 * v3' ;

  elseif itest == 117    %  DMM+DMM, Two DJ Even

    stitle = 'Two DJ Even' ;
    ssave = 'DMM+DMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cM * u3 * v3' + cM * u2 * v2' ;
    mYtrue = cM * u3 * v3' + cM * u2 * v2' ;

  elseif itest == 118     %  DLL+DMM, Two DJ Uneven

    stitle = 'Two DJ Uneven' ;
    ssave = 'DLL+DMM' ;
    colbottom = -2.5 ; 
    coltop = 2.5 ;
        %  bottom and top of color range
    mXtrue = cL * u3 * v3' + cM * u2 * v2' ;
    mYtrue = cL * u3 * v3' + cM * u2 * v2' ;

  end

  %  Add Noise Matrices
  %
  mX = mXtrue + sig * randn(d,n) ;
  mY = mYtrue + sig * randn(d,n) ;

  paramstruct = struct('iscreenwrite',1) ;
  outstruct = DIVASDoubJointSM(mX,mY,paramstruct)

  disp(' ') ;
  disp(['Above results for ' stitle ', ' ssave]) ;


end ;    %  of itest < 0r > 100 if-block




