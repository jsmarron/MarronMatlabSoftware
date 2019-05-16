disp('Running MATLAB script file nprSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION nprSM,
%    NonParametric Regression


itest = 26 ;     %  1,2,...,26

format compact ;
format short ;

figure(1) ;
clf ;


if itest == 1 ;   %  Simplest visual check of implementations of LL
  indat = [[.2, 1];...
           [.3, 2];...
           [.5, 1];...
           [.8, 3];...
           [.4, 2]];
  invh = .1 ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

  titstr = 'formula looped impl.'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

  titstr = 'polyfit looped impl.'
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',1) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;


  titstr = 'binned implementation' 
  subplot(2,2,4) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

elseif itest == 2 ;   %  Simplest visual check of implementations of NW
  indat = [[.2, 1];...
           [.3, 2];...
           [.5, 1];...
           [.8, 3];...
           [.4, 2]];
  invh = .1 ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

  titstr = 'formula looped impl.'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

  titstr = 'polyfit looped impl.'
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

  titstr = 'binned implementation' 
  subplot(2,2,4) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'x') ;
      hold off ;

elseif itest == 3 ;   %  Simple check of higher degree poly's
  clf ;
  indat = [[.2, 1];...
           [.3, 2];...
           [.5, 1];...
           [.8, 3];...
           [.4, 2]];
  invh = .1 ;
  vxg = [0; 1] ;
  titstr = 'Check poly degrees 0-3'
  tic ;
  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',1,...
                       'polydeg',0) ;
  nprSM(indat,paramstruct) ;
  toc
    title(titstr) ;
    hold on ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',1) ;
    nprSM(indat,paramstruct) ;
    toc
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',2) ;
    nprSM(indat,paramstruct) ;
    toc
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',3) ;
    nprSM(indat,paramstruct) ;
    toc
    plot(indat(:,1),indat(:,2),'x') ;
   hold off ;

elseif itest == 4 ;   %  Check multiple bandwidths, LL
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  invh = [.01 .03 .1] ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'formula looped implementation'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'polyfit looped implementation'
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',1) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'binned implementation' 
  subplot(2,2,4) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;

elseif itest == 5 ;   %  Check multiple bandwidths, NW
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  invh = [.01 .03 .1] ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'formula looped implementation'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'polyfit looped implementation'
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;
  titstr = 'binned implementation' 
  subplot(2,2,4) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
    toc
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.') ;
      hold off ;

elseif itest == 6 ;   %  Check implementations against each other, LL
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  invh = .03 ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1,...
                         'polydeg',1) ;
    onpr1 = nprSM(indat,paramstruct) ;
  titstr = 'formula looped implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2,...
                         'polydeg',1) ;
    onpr2 = nprSM(indat,paramstruct) ;
  titstr = 'polyfit looped implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',1) ;
    onpr3 = nprSM(indat,paramstruct) ;
  titstr = 'binned implementation' 
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0,...
                         'polydeg',1) ;
    onpr0 = nprSM(indat,paramstruct) ;
  titstr = 'pre-binned implementation' 
    bincts = lbinrSM(indat,vxg) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',-1,...
                         'polydeg',1) ;
    onprm1 = nprSM(bincts,paramstruct) ;

  disp('Check these are 0 (401 grid points):') ;
  disp('    matrix - formula loop:') ;
  max(abs(onpr1 - onpr2)) 
  disp('    matrix - polyfit loop:') ;
  max(abs(onpr1 - onpr3)) 
  disp('    matrix - binned:') ;
  max(abs(onpr1 - onpr0)) 
  disp('    matrix - prebinned:') ;
  max(abs(onpr1 - onprm1)) 
  disp('    binned - prebinned:') ;
  max(abs(onpr0 - onprm1)) 

elseif itest == 7 ;   %  Check implementations against each other, NW
  indat = rand(500,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(500,1)] ;
  invh = .03 ;
  vxg = [0; 1] ;
  titstr = 'matrix implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1,...
                         'polydeg',0) ;
    onpr1 = nprSM(indat,paramstruct) ;
  titstr = 'formula looped implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2,...
                         'polydeg',0) ;
    onpr2 = nprSM(indat,paramstruct) ;
  titstr = 'polyfit looped implementation'
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',3,...
                         'polydeg',0) ;
    onpr3 = nprSM(indat,paramstruct) ;
  titstr = 'binned implementation' 
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0,...
                         'polydeg',0) ;
    onpr0 = nprSM(indat,paramstruct) ;
  titstr = 'pre-binned implementation' 
    bincts = lbinrSM(indat,vxg) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',-1,...
                         'polydeg',0) ;
    onprm1 = nprSM(bincts,paramstruct) ;

  disp('Check these are 0 (401 grid points):') ;
  disp('    matrix - formula loop:') ;
  max(abs(onpr1 - onpr2)) 
  disp('    matrix - polyfit loop:') ;
  max(abs(onpr1 - onpr3)) 
  disp('    matrix - binned:') ;
  max(abs(onpr1 - onpr0)) 
  disp('    matrix - prebinned:') ;
  max(abs(onpr1 - onprm1)) 
  disp('    binned - prebinned:') ;
  max(abs(onpr0 - onprm1)) 

elseif itest == 8 ;   %  Check endpt handling
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .05*randn(100,1)] ;
  invh = .03 ;
  subplot(2,2,1) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[.2,.5],...
                         'imptyp',0,...
                         'polydeg',1) ;
    nprSM(indat,paramstruct) ;
      title('LL - no trunc.') ;
      axis(axis) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;
  subplot(2,2,2) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[.2,.5],...
                         'imptyp',0,...
                         'polydeg',1,...
                         'eptflag',1) ;
    nprSM(indat,paramstruct) ;
      title('LL - trunc.') ;
      axis(axis) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;
  subplot(2,2,3) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[.2,.5],...
                         'imptyp',0,...
                         'polydeg',0,...
                         'eptflag',0) ;
    nprSM(indat,paramstruct) ;
      title('NW - no trunc.') ;
      axis(axis) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;
  subplot(2,2,4) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[.2,.5],...
                         'imptyp',0,...
                         'polydeg',0,...
                         'eptflag',0) ;
    nprSM(indat,paramstruct) ;
      title('NW - trunc.') ;
      axis(axis) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

elseif itest == 9 ;   %  Check kernel plot LL
  clf ;
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  paramstruct = struct('vh',[.01; .03; .3],...
                       'vxgrid',[0,1],...
                       'imptyp',0,...
                       'polydeg',1,...
                        'eptflag',0) ;
  [okde,oxgrid,omker] = nprSM(indat,paramstruct) ;
  plot(oxgrid,[okde (omker - 1.5)]) ;
    axis(axis) ;
    hold on ;
      plot(indat(:,1),indat(:,2),'.w') ;
    hold off ;

elseif itest == 10 ;   %  Check kernel plot NW
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  paramstruct = struct('vh',[.01; .03; .3],...
                       'vxgrid',[0,1],...
                       'imptyp',0,...
                       'polydeg',0,...
                        'eptflag',0) ;
  [okde,oxgrid,omker] = nprSM(indat,paramstruct) ;
  plot(oxgrid,[okde (omker - 1.5)]) ;
    axis(axis) ;
    hold on ;
      plot(indat(:,1),indat(:,2),'.w') ;
    hold off ;

elseif itest == 11 ;   %  Check data based bandwidth selection
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;
  subplot(2,2,1) ;
    paramstruct = struct('vh',-1) ;
    nprSM(indat,paramstruct) ;
      title('RSW ROT') ;
    hold on ;
      plot(indat(:,1),indat(:,2),'.k') ;
    hold off ;
  subplot(2,2,2) ;
    paramstruct = struct('vh',-2) ;
    nprSM(indat,paramstruct) ;
      title('RSW DPI') ;
    hold on ;
      plot(indat(:,1),indat(:,2),'.k') ;
    hold off ;
 
elseif itest == 12 ;    %  Check small h part, LL

  indat = [1,2; 2,4; 2.5,2; 4.1,1; 4.2,5; 5.5, 4] ;
%  h = .1 ;
%  h = .05 ;
%  h = .03 ;
%  h = .01 ;
  h = .001 ;
  invxg = [0; 6; 31] ;
%  invxg = [0; 6; 101] ;

%Tried this one, but the replaced it by polyfit
%  titstr = 'Small h, prebinned LL'
%  subplot(2,2,1) ;
%    inbcts = gplbinr(indat,invxg) ;
%    nprSM(inbcts,h,invxg,-1) ;
%      title(titstr) ;
%      hold on ;
%        plot(indat(:,1),indat(:,2),'or') ;
%      hold off ;

  titstr = 'Small h, Poly Fit LL'
  subplot(2,2,1) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',3) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Binned LL'
  subplot(2,2,2) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Matrix LL'
  subplot(2,2,3) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',1) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Looped LL'
  subplot(2,2,4) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',2) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

elseif itest == 13 ;    %  Check small h part, NW

  indat = [1,0; 2,4; 2.5,2; 4.5,1; 5,5] ;
%  h = .1 ;
%  h = .03 ;
  h = .01 ;
  invxg = [0; 6; 31] ;

  titstr = 'Small h, prebinned NW'
  subplot(2,2,1) ;
    inbcts = lbinrSM(indat,invxg) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',-1,...
                         'polydeg',0) ;
    nprSM(inbcts,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Binned NW'
  subplot(2,2,2) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',0,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Matrix NW'
  subplot(2,2,3) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',1,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

  titstr = 'Small h, Looped NW'
  subplot(2,2,4) ;
    paramstruct = struct('vh',h,...
                         'vxgrid',invxg,...
                         'imptyp',2,...
                         'polydeg',0) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;

elseif itest == 14 ;    %  Test widely spaced data
  titstr = 'Widely Spaced Test'
  indat = [rand(20,1); (10 + rand(20,1)); (20 + rand(20,1))] ;
  indat = [indat, abs(indat - 10.5)] ;
  vh = [.1; .3; 1; 3; 10] ;

  subplot(1,1,1) ;
    paramstruct = struct('vh',vh) ;
    nprSM(indat,paramstruct) ;
      title(titstr) ;
      legend('h=0.1','h=0.3','h=1','h=3','h=10') ;
      hold on ;
        plot(indat(:,1),indat(:,2),'or') ;
      hold off ;
      text(5,10,'Try Command: axis([9.5,11.5,0,1])') ;


elseif itest == 15 ;  %  test linewidth defaults
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

  subplot(2,3,1) ;
    nprSM(indat) ;

  subplot(2,3,2) ;
    paramstruct = struct('linewidth',0.5) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,3) ;
    paramstruct = struct('linewidth',2) ;
    nprSM(indat,paramstruct) ;

  hrsw = bwrswSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hrsw ;

  subplot(2,3,4) ;
    paramstruct = struct('vh',vh) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,5) ;
    paramstruct = struct('linewidth',0.5,...
                         'vh',vh) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,6) ;
    paramstruct = struct('linewidth',2,...
                         'vh',vh) ;
    nprSM(indat,paramstruct) ;


elseif itest == 16 ;  %  test color schemes
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

  subplot(2,3,1) ;
    paramstruct = struct('linewidth',2) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,2) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','r') ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,3) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','') ;
    nprSM(indat,paramstruct) ;

  hrsw = bwrswSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hrsw ;

  subplot(2,3,4) ;
    paramstruct = struct('linewidth',2,...
                         'vh',vh) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,5) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','r',...
                         'vh',vh) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,6) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','',...
                         'vh',vh) ;
    nprSM(indat,paramstruct) ;


elseif itest == 17 ;  %  test title stuff
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

  subplot(2,2,1) ;
    nprSM(indat) ;

  subplot(2,2,2) ;
    paramstruct = struct('titlestr','Test Title') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('titlestr','Test Title',...
                         'titlefontsize',24) ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('titlestr','Test Title',...
                         'titlefontsize',8) ;
    nprSM(indat,paramstruct) ;


elseif itest == 18 ;  %  test label stuff
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

  subplot(2,2,1) ;
    nprSM(indat) ;

  subplot(2,2,2) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label',...
                         'labelfontsize',24) ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label',...
                         'labelfontsize',6) ;
    nprSM(indat,paramstruct) ;


elseif itest == 19 ;  %  test data overlay. and colors
  indat = rand(5000,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(5000,1)] ;

  subplot(2,3,1) ;
    paramstruct = struct('titlestr','ndataoverlay = Default') ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,2) ;
    paramstruct = struct('titlestr','ndataoverlay = 0',...
                         'ndataoverlay',0) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,3) ;
    paramstruct = struct('titlestr','ndataoverlay = 1 (1st 1000)',...
                         'dolcolor','r',...
                         'ndataoverlay',1) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,4) ;
    paramstruct = struct('titlestr','ndataoverlay = 2 (all)',...
                         'ndataoverlay',2) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,5) ;
    paramstruct = struct('titlestr','ndataoverlay = 50',...
                         'dolcolor','m',...
                         'ndataoverlay',50) ;
    nprSM(indat,paramstruct) ;

  subplot(2,3,6) ;
    paramstruct = struct('titlestr','ndataoverlay = 300',...
                         'ndataoverlay',300) ;
    nprSM(indat,paramstruct) ;


elseif itest == 20 ;  %  test forced plot
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

  hrsw = bwrswSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hrsw ;

  subplot(2,1,1) ;
    paramstruct = struct('vh',vh,...
                         'iplot',1,...
                         'titlestr','Forced Plot inside',...
                         'ndataoverlay',2) ;
    [mnpr,xgrid,mker] = nprSM(indat,paramstruct) ;

  subplot(2,1,2) ;
    plot(xgrid,mnpr) ;
    hold on ;
      plot(xgrid,mker) ;
    hold off ;
    title('Plot Outside') ;


elseif itest == 21 ;  %  test vertical plot ranges (truncated data)
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;


  subplot(2,2,1) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',1,...
                         'ndataoverlay',1,...
                         'titlestr','Default Vertical range') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',1,...
                         'plottop',2,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 2') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',1,...
                         'plotbottom',-2,...
                         'ndataoverlay',1,...
                         'titlestr','Bottom Specified to -2') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',1,...
                         'plotbottom',-2,...
                         'plottop',2,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to -2, and Bottom to 2') ;
    nprSM(indat,paramstruct) ;


elseif itest == 22 ;  %  test vertical plot ranges (bdry shifted data)
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;


  subplot(2,2,1) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',0,...
                         'ndataoverlay',1,...
                         'titlestr','Default Vertical range') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',0,...
                         'plottop',2,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 2') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',0,...
                         'plotbottom',-2,...
                         'ndataoverlay',1,...
                         'titlestr','Bottom Specified to -2') ;
    nprSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vxgrid',[0.1,0.8],...
                         'eptflag',0,...
                         'plotbottom',-2,...
                         'plottop',2,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to -2, and Bottom to 2') ;
    nprSM(indat,paramstruct) ;


elseif itest == 23 ;  %  test large dots
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

    figure(1)
    paramstruct = struct('ndataoverlay',1, ...
                         'ibigdot',1, ...
                         'titlestr','Test of Big Dots') ;
    nprSM(indat,paramstruct) ;

    figure(2)
    paramstruct = struct('ndataoverlay',1, ...
                         'ibigdot',0, ...
                         'titlestr','Default Dot Size') ;
    nprSM(indat,paramstruct) ;


elseif itest == 24 ;  %  bad imptyp
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

    figure(1)
    paramstruct = struct('vh',-1, ...
                         'imptyp',2, ...
                         'titlestr','Test Bad Imptyp') ;
    nprSM(indat,paramstruct) ;


elseif itest == 25 ;  %  bad imptyp and polydeg
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

    figure(1)
    paramstruct = struct('vh',-1, ...
                         'imptyp',2, ...
                         'polydeg',5, ...
                         'titlestr','Test Bad Imptyp & polydeg') ;
    nprSM(indat,paramstruct) ;


elseif itest == 26 ;  %  bad imptyp and polydeg
  indat = rand(100,1) ;
  indat = [indat, sin(2 * pi * indat) + .2*randn(100,1)] ;

    figure(1)
    paramstruct = struct('vh',0.2, ...
                         'imptyp',2, ...
                         'polydeg',5, ...
                         'titlestr','Test Bad Imptyp & polydeg') ;
    nprSM(indat,paramstruct) ;




end ;


