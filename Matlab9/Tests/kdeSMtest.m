disp('Running MATLAB script file kdeSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION kdeSM,
%    General Purpose Kernel Density Estimation

itest = 31 ;     %  1,2,...,31

format compact ;
format short ;


figure(1) ;
clf ;


if itest == 1 ;   %  Simplest visual check of implementations
  indat = [1; 2; 2; 3; 3.5] ;
  invh = .2 ;
  vxg = [0; 4] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;
  titstr = 'looped implementation'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;
  titstr = 'binned implementation' 
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;

 
elseif itest == 2 ;   %  Check of numerical integrals
  format long ;
  indat = 2 * rand(100,1) ;
  invh = .2 ;
  vxg = [-1, 3, 9] ;
  disp('Check these are 1 (9 grid points):') ;
    disp('    Matrix:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .5) 
    disp('    Looped:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .5) 
    disp('    Binned:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .5) 

  vxg = [-1, 3, 17] ;
  disp('Check these are 1 (17 grid points):') ;
    disp('    Matrix:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .25) 
    disp('    Looped:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .25) 
    disp('    Binned:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .25) 

  vxg = [-1, 3] ;
  disp('Check these are 1 (401 grid points):') ;
    disp('    Matrix:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .01) 
    disp('    Looped:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .01) 
    disp('    Binned:') ;  
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    vkde = kdeSM(indat,paramstruct) ;
  int = sum(vkde * .01) 


elseif itest == 3 ;   %  Check multiple bandwidths
  indat = [(randn(2500,1) - 1.5); (randn(2500,1) + 1.5)] ;
  invh = [.2 .6 1.8] ;
  vxg = [-4; 4] ;
  titstr = 'matrix implementation'
  subplot(2,2,1) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',1) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;
  titstr = 'looped implementation'
  subplot(2,2,2) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',2) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;
  titstr = 'binned implementation' 
  subplot(2,2,3) ;
    tic ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',vxg,...
                         'imptyp',0) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;
  titstr = 'binned impl., all defaults' 
  subplot(2,2,4) ;
    tic ;
    paramstruct = struct('vh',invh) ;
    kdeSM(indat,paramstruct) ;
    toc
      title(titstr) ;

  
elseif itest == 4 ;   %  Check implementations against each other
  format long ;
  indat = randn(100,1) ;
  invh = [.2 .6 1.8] ;
  vxg = [-3, 3, 13] ;
  disp('Check these are 0 (13 grid points):') ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',1) ;
  mkde = kdeSM(indat,paramstruct) ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',2) ;
  lkde = kdeSM(indat,paramstruct) ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',0) ;
  bkde = kdeSM(indat,paramstruct) ;

  disp('    Matrix - Looped:') ;  
  max(abs(mkde - lkde)) 
  disp('    Matrix - Binned:') ;  
  max(abs(mkde - bkde)) 

  vxg = [-3, 3] ;
  disp('Check these are 0 (401 grid points):') ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',1) ;
  mkde = kdeSM(indat,paramstruct) ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',2) ;
  lkde = kdeSM(indat,paramstruct) ;

  paramstruct = struct('vh',invh,...
                       'vxgrid',vxg,...
                       'imptyp',0) ;
  bkde = kdeSM(indat,paramstruct) ;

  disp('    Matrix - Looped:') ;  
  max(abs(mkde - lkde)) 
  disp('    Matrix - Binned:') ;  
  max(abs(mkde - bkde)) 


elseif itest == 5 ;   %  Check grid choice defaults
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;
  invh = [.2 .6 1.8] ;

  subplot(2,2,1) ;
    paramstruct = struct('vh',invh) ;
    kdeSM(indat,paramstruct) ;
    title('Default # grid points') ;

  subplot(2,2,2) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-5,5]) ;
    kdeSM(indat,paramstruct) ;
    title('Default # grid points') ;

  subplot(2,2,3) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-5,5,401]) ;
    kdeSM(indat,paramstruct) ;
    title('Set 401 grid points') ;

  subplot(2,2,4) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-5,5,21]) ;
    kdeSM(indat,paramstruct) ;
    title('Set 21 grid points') ;


elseif itest == 6 ;   %  Check endpt handling
  indat = randn(100,1) ;
  invh = [.1 .3 .9] ;
  disp('N(0,1) data') ;

  subplot(2,2,1) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-1,1],...
                         'imptyp',0) ;
    kdeSM(indat,paramstruct) ;
    title('vxg = [-1,1], default eptflag') ;

  subplot(2,2,2) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-1,1,17],...
                         'imptyp',0,...
                         'eptflag',0) ;
    kdeSM(indat,paramstruct) ;
    title('vxg = [-1,1,17], eptflag = 0') ;

  subplot(2,2,3) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-1,1],...
                         'imptyp',0,...
                         'eptflag',1) ;
    kdeSM(indat,paramstruct) ;
    title('vxg = [-1,1], eptflag = 1') ;

  subplot(2,2,4) ;
    paramstruct = struct('vh',invh,...
                         'vxgrid',[-1,1,17],...
                         'imptyp',0,...
                         'eptflag',1) ;
    kdeSM(indat,paramstruct) ;
    title('vxg = [-1,1,17], eptflag = 1') ;

elseif itest == 7 ;   %  Check already binned data
  format long ;
  indat = randn(1000,1) ;
  invh = [.1 .3 .9] ;
  paramstruct = struct('vh',invh,...
                       'vxgrid',0,...
                       'imptyp',0) ;
  kde1 = kdeSM(indat,paramstruct) ;
  bcts = lbinrSM(indat) ;
  paramstruct = struct('vh',invh,...
                       'vxgrid',[min(indat) max(indat)],...
                       'imptyp',-1) ;
  kde2 = kdeSM(bcts,paramstruct) ;
  disp('Check this is 0:') ;
  max(max(abs(kde1 - kde2))) 
  disp('Check above warning does not reappear, when idatovlay set to 0') ;
  paramstruct = struct('vh',invh,...
                       'vxgrid',[min(indat) max(indat)],...
                       'imptyp',-1,...
                       'idatovlay',0) ;
  kde3 = kdeSM(bcts,paramstruct) ;

elseif itest == 8 ;   %  Check data based bandwidth selection
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;
  subplot(2,2,1) ;
    paramstruct = struct('vh',-1) ;
    kdeSM(indat,paramstruct) ;
      title('Simple Normal Reference') ;
  subplot(2,2,2) ;
    paramstruct = struct('vh',-2) ;
    kdeSM(indat,paramstruct) ;
      title('ROT2') ;
  subplot(2,2,3) ;
    paramstruct = struct('vh',-3) ;
    kdeSM(indat,paramstruct) ;
      title('Oversmoothed') ;
  subplot(2,2,4) ;
    kdeSM(indat) ;
      title('SJPI') ;


elseif itest == 9 ;   %  Check kernel plot
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  paramstruct = struct('vh',[.2; .6; 1.8],...
                       'vxgrid',[-5; 5],...
                       'imptyp',0,...
                       'eptflag',0) ;
  [okde,oxgrid,omker] = kdeSM(indat,paramstruct) ;
  subplot(2,1,1) ;
    plot(oxgrid,[okde omker]) ;
      title('Check Kernel Calculations') ;

  paramstruct = struct('vh',.6) ;
  [okde,oxgrid,omker] = kdeSM(indat,paramstruct) ;
  subplot(2,1,2) ;
    plot(oxgrid,[okde omker]) ;
      title('Uses Matlab plot function outside of kdeSM') ;


elseif itest == 10 ;  %  try to stretch nbin
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  paramstruct = struct('vh',0,...
                       'vxgrid',[-5,5,101]) ;
  [okde,oxgrid] = kdeSM(indat,paramstruct) ;

  disp('Check these are:     101    1') ;
  size(okde)
  size(oxgrid)


elseif itest == 11 ;  %  test linewidth defaults
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  subplot(2,3,1) ;
    kdeSM(indat) ;
    title('Default Line Width') ;

  subplot(2,3,2) ;
    paramstruct = struct('linewidth',0.5) ;
    kdeSM(indat,paramstruct) ;
    title('Thin Line Width') ;

  subplot(2,3,3) ;
    paramstruct = struct('linewidth',2) ;
    kdeSM(indat,paramstruct) ;
    title('Fat Line Width') ;

  hsjpi = bwsjpiSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hsjpi ;

  subplot(2,3,4) ;
    paramstruct = struct('vh',vh) ;
    kdeSM(indat,paramstruct) ;
    title('Default Line Width') ;

  subplot(2,3,5) ;
    paramstruct = struct('linewidth',0.5,...
                         'vh',vh) ;
    kdeSM(indat,paramstruct) ;
    title('Thin Line Width') ;

  subplot(2,3,6) ;
    paramstruct = struct('linewidth',2,...
                         'vh',vh) ;
    kdeSM(indat,paramstruct) ;
    title('Fat Line Width') ;


elseif itest == 12 ;  %  test color schemes
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  subplot(2,3,1) ;
    paramstruct = struct('linewidth',2,...
                         'titlestr','Default Color') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,2) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','r',...
                         'titlestr','Red Color String') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,3) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','',...
                         'titlestr','Matlab Default Color') ;
    kdeSM(indat,paramstruct) ;

  hsjpi = bwsjpiSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hsjpi ;

  subplot(2,3,4) ;
    paramstruct = struct('linewidth',2,...
                         'vh',vh,...
                         'titlestr','Default Color') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,5) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','r',...
                         'vh',vh,...
                         'titlestr','Red Color String') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,6) ;
    paramstruct = struct('linewidth',2,...
                         'linecolor','',...
                         'vh',vh,...
                         'titlestr','Matlab Default Color') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 13 ;  %  test title stuff
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  subplot(2,2,1) ;
    kdeSM(indat) ;

  subplot(2,2,2) ;
    paramstruct = struct('titlestr','Test Title') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('titlestr','Test Title',...
                         'titlefontsize',24) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('titlestr','Test Title',...
                         'titlefontsize',8) ;
    kdeSM(indat,paramstruct) ;


elseif itest == 14 ;  %  test label stuff
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  subplot(2,2,1) ;
    kdeSM(indat) ;

  subplot(2,2,2) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label',...
                         'labelfontsize',24) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('xlabelstr','Test X Label',...
                         'ylabelstr','Test Y Label',...
                         'labelfontsize',6) ;
    kdeSM(indat,paramstruct) ;


elseif itest == 15 ;  %  test data overlay. and colors
  indat = [(randn(2500,1) - 1.5); (randn(2500,1) + 1.5)] ;
  indat = sort(indat) ;
  disp(['n = ' num2str(length(indat))]) ;

  subplot(2,3,1) ;
    paramstruct = struct('titlestr','Default data overlay') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,2) ;
    paramstruct = struct('titlestr','No data Overlay',...
                         'idatovlay',0) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,3) ;
    paramstruct = struct('titlestr','Overlay All',...
                         'dolcolor','m',...
                         'idatovlay',1,...
                         'ndatovlay',2) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,4) ;
    paramstruct = struct('titlestr','Random Overlay',...
                         'idatovlay',2) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,5) ;
    paramstruct = struct('titlestr','Seeded Random',...
                         'dolcolor','r',...
                         'idatovlay',490357209,...
                         'ndatovlay',50) ;
    kdeSM(indat,paramstruct) ;

  subplot(2,3,6) ;
    paramstruct = struct('titlestr','Seeded Random (like left???)',...
                         'dolcolor','r',...
                         'idatovlay',490357209,...
                         'ndatovlay',50) ;
    kdeSM(indat,paramstruct) ;


elseif itest == 16 ;  %  test forced plot
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;

  hsjpi = bwsjpiSM(indat) ;
  vh = [1/4; 1/2; 1; 2; 4] * hsjpi ;

  subplot(2,1,1) ;
    paramstruct = struct('vh',vh,...
                         'iplot',1,...
                         'titlestr','Forced Plot Inside kdeSM',...
                         'ndataoverlay',2) ;
    [mkde,xgrid,mker] = kdeSM(indat,paramstruct) ;

  subplot(2,1,2) ;
    plot(xgrid,mkde) ;
    hold on ;
      plot(xgrid,mker) ;
    hold off ;
    title('Plot Outside kdeSM') ;


elseif itest == 17 ;  %  boundary corrections, direct calculations
  indat = 1.5 * (randn(1000,1) - 2) ;

  hsjpi = bwsjpiSM(indat) ;
  vh = [1/3; 1; 3] * hsjpi ;

  subplot(2,2,1) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',1,...
                         'eptflag',1,...
                         'titlestr','No Correction') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',2,...
                         'eptflag',1,...
                         'ibdryadj',0,...
                         'titlestr','No Correction') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',2,...
                         'eptflag',1,...
                         'ibdryadj',1,...
                         'titlestr','Mirror Adjustment') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',2,...
                         'eptflag',1,...
                         'ibdryadj',2,...
                         'titlestr','Circular Bdry Adjustment') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 18 ;  %  boundary corrections, binned calculations
  indat = 1.5 * (randn(1000,1) - 2) ;

  hsjpi = bwsjpiSM(indat) ;
  vh = [1/3; 1; 3] * hsjpi ;

  subplot(2,2,1) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',0,...
                         'eptflag',1,...
                         'titlestr','No Correction') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    bncts = lbinrSM(indat,[-2; 1],1) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',-1,...
                         'idatovlay',0,...
                         'eptflag',1,...
                         'ibdryadj',0,...
                         'titlestr','No Correction') ;
    kdeSM(bncts,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',0,...
                         'eptflag',1,...
                         'ibdryadj',1,...
                         'titlestr','Mirror Adjustment') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vh',vh,...
                         'vxgrid',[-2; 1],...
                         'imptyp',0,...
                         'eptflag',1,...
                         'ibdryadj',2,...
                         'titlestr','Circular Bdry Adjustment') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 19 ;  %  test vertical plot ranges (bdry truncated)
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;


  subplot(2,2,1) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',1,...
                         'ndataoverlay',1,...
                         'titlestr','Default Vertical range') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',1,...
                         'plottop',0.5,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 0.5') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',1,...
                         'plotbottom',0.2,...
                         'ndataoverlay',1,...
                         'titlestr','Bottom Specified to 0.2') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',1,...
                         'plotbottom',0.2,...
                         'plottop',0.5,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 0.5, and Bottom to 0.2') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 20 ;  %  test vertical plot ranges (bdry shifted)
  indat = [(randn(250,1) - 1.5); (randn(250,1) + 1.5)] ;


  subplot(2,2,1) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',0,...
                         'ndataoverlay',1,...
                         'titlestr','Default Vertical range') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',0,...
                         'plottop',0.5,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 0.5') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',0,...
                         'plotbottom',0.2,...
                         'ndataoverlay',1,...
                         'titlestr','Bottom Specified to 0.2') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vxgrid',[-2; 1],...
                         'eptflag',0,...
                         'plotbottom',0.2,...
                         'plottop',0.5,...
                         'ndataoverlay',1,...
                         'titlestr','Top Specified to 0.5, and Bottom to 0.2') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 21 ;  %  test seeded random number generation of jitter heights
  rng(92387494) ;
  indat = rand(20,1) ;

  subplot(2,2,1) ;
    paramstruct = struct('titlestr','Default Jitter Heights') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('datovlaymax',0.6, ...
                         'datovlaymin',0.5, ...
                         'titlestr','Manual Choice of Default Jitter Heights') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('datovlaymax',0.9, ...
                         'datovlaymin',0.85, ...
                         'titlestr','Fiddled Jitter Heights') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('datovlaymax',0.5, ...
                         'datovlaymin',0.2, ...
                         'titlestr','Fiddled Jitter Heights') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 22 ;  %  test big dots
  rng(92387494) ;
  indat = rand(2000,1) ;

    figure(1)
    paramstruct = struct('ndataoverlay',1, ...
                         'ibigdot',1, ...
                         'titlestr','Test of Big Dots') ;
    kdeSM(indat,paramstruct) ;

    savestr = 'kdeSMtestBigDots1' ;
    orient landscape ;
    printSM(savestr,2) ;

    disp(['Check output file ' savestr]) ;


    figure(2)
    paramstruct = struct('ndataoverlay',1, ...
                         'ibigdot',0, ...
                         'titlestr','Compare with default Dots') ;
    kdeSM(indat,paramstruct) ;

    savestr = 'kdeSMtestBigDots2' ;
    orient landscape ;
    printSM(savestr,2) ;

    disp(['Check output file ' savestr]) ;


elseif itest == 23 ;  %  test colors of overlaid data
  rng(92387494) ;
  indat = sort(rand(50,1)) ;

  subplot(3,3,1) ;
    paramstruct = struct('dolcolor','r', ...
                         'titlestr','Set Data Overlay color to Red') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,2) ;
    paramstruct = struct('dolcolor',1, ...
                         'titlestr','Default Matlab Colors') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,3) ;
    paramstruct = struct('dolcolor',2, ...
                         'titlestr','Rainbow Colors') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,4) ;
    icolor = [ones(20,1)*[0 0 1]; ones(30,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'titlestr','Input Color Matrix') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,5) ;
    disp('Plot 2,2: Input color matrix too big, 60 x 3') ;
    icolor = [ones(20,1)*[0 0 1]; ones(40,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'titlestr','Input Wrong Size') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,6) ;
    disp('Plot 2,3: Input color matrix wrong number of rows & cols, 30 x 2') ;
    icolor = [ones(20,1)*[0 0]; ones(10,1)*[1 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'titlestr','Input Wrong Size') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,7) ;
    disp('Plot 3,1: Input color matrix wrong number of cols, 50 x 4') ;
    paramstruct = struct('dolcolor',rand(50,4), ...
                         'titlestr','Input Wrong Size') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,8) ;
    disp('Plot 3,2: Input dolcolor = 0') ;
    paramstruct = struct('dolcolor',0, ...
                         'titlestr','Invalid dolcolor') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,3,9) ;
    disp('Plot 3,3: Input empty dolcolor') ;
    paramstruct = struct('dolcolor',[], ...
                         'titlestr','Empty dolcolor') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 24 ;  %  test markers
 rng(92387494) ;
  indat = sort(rand(50,1)) ;

  subplot(3,4,1) ;
    paramstruct = struct('dolcolor','r', ...
                         'dolmarkerstr','+', ...
                         'titlestr','Commom Marker') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,2) ;
    paramstruct = struct('dolcolor',1, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Commom Marker') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,3) ;
    paramstruct = struct('dolcolor',2, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Commom Marker') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,4) ;
    icolor = [ones(20,1)*[0 0 1]; ones(30,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Commom Marker') ;
    kdeSM(indat,paramstruct) ;

  markerstr = [] ;
  for i = 1:30 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i = 1:20 ;
    markerstr = strvcat(markerstr,'x') ;
  end ;

  subplot(3,4,5) ;
    paramstruct = struct('dolcolor','r', ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Differing Markers') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,6) ;
    paramstruct = struct('dolcolor',1, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Differing Markers') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,7) ;
    paramstruct = struct('dolcolor',2, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Differing Markers') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,8) ;
    icolor = [ones(20,1)*[0 0 1]; ones(30,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Differing Markers') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,9) ;
    disp('Plot 3,1: Input markerstr too short') ;
    paramstruct = struct('dolcolor','r', ...
                         'dolmarkerstr',markerstr(1:40,:), ...
                         'titlestr','Bad Marker Input') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,10) ;
    disp('Plot 3,2: Input markerstr too long') ;
    paramstruct = struct('dolcolor',1, ...
                         'dolmarkerstr',[markerstr; '*'], ...
                         'titlestr','Bad Marker Input') ;
    kdeSM(indat,paramstruct) ;
  subplot(3,4,11) ;
    disp('Plot 3,3: Input single numerical markerstr') ;
    paramstruct = struct('dolcolor',2, ...
                         'dolmarkerstr',1, ...
                         'titlestr','Bad Marker Input') ;
    kdeSM(indat,paramstruct) ;

  subplot(3,4,12) ;
    disp('Plot 3,4: Input correct size numerical markerstr') ;
    icolor = [ones(20,1)*[0 0 1]; ones(30,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'dolmarkerstr',rand(50,1), ...
                         'titlestr','Bad Marker Input') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 25 ;  %  test colors & markers when not all dat overlaid
  rng(92387494) ;
  indat = sort(rand(2000,1)) ;

  subplot(2,4,1) ;
    paramstruct = struct('dolcolor','r', ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,2) ;
    paramstruct = struct('dolcolor',1, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Default ndataoverlay') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,3) ;
    paramstruct = struct('dolcolor',2, ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,4) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Default ndataoverlay') ;
    kdeSM(indat,paramstruct) ;

  markerstr = [] ;
  for i = 1:1200 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i = 1:800 ;
    markerstr = strvcat(markerstr,'x') ;
  end ;

  subplot(2,4,5) ;
    paramstruct = struct('dolcolor','r', ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Default ndataoverlay') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,6) ;
    paramstruct = struct('dolcolor',1, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,7) ;
    paramstruct = struct('dolcolor',2, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Default ndataoverlay') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,8) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('dolcolor',icolor, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 26 ;  %  test colors & markers when not all dat overlaid
 rng(92387494) ;
  indat = sort(rand(2000,1)) ;

  subplot(2,4,1) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor','r', ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,2) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',1, ...
                         'dolmarkerstr','+', ...
                         'titlestr','ndataoverlay = 100') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,3) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',2, ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,4) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr','+', ...
                         'titlestr','ndataoverlay = 100') ;
    kdeSM(indat,paramstruct) ;

  markerstr = [] ;
  for i = 1:1200 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i = 1:800 ;
    markerstr = strvcat(markerstr,'x') ;
  end ;

  subplot(2,4,5) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor','r', ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','ndataoverlay = 100') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,6) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',1, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,7) ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',2, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','ndataoverlay = 100') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,8) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('ndatovlay',100, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 27 ;  %  test colors & markers for truncated data
  rng(92387494) ;
  indat = sort(rand(2000,1)) ;

  subplot(2,4,1) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor','r', ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,2) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',1, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,3) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',2, ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,4) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  markerstr = [] ;
  for i = 1:1200 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i = 1:800 ;
    markerstr = strvcat(markerstr,'x') ;
  end ;

  subplot(2,4,5) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor','r', ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,6) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',1, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,7) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',2, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,8) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 28 ;  %  test colors & markers for truncated data & small ndatovlay
  rng(92387494) ;
  indat = sort(rand(2000,1)) ;

  subplot(2,4,1) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor','r', ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000, ndol = 50') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,2) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',1, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,3) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',2, ...
                         'dolmarkerstr','+', ...
                         'titlestr','n = 2000, ndol = 50') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,4) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr','+', ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  markerstr = [] ;
  for i = 1:1200 ;
    markerstr = strvcat(markerstr,'o') ;
  end ;
  for i = 1:800 ;
    markerstr = strvcat(markerstr,'x') ;
  end ;

  subplot(2,4,5) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor','r', ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,6) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',1, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000, ndol = 50') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,7) ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',2, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','Truncated Grid') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,4,8) ;
    icolor = [ones(800,1)*[0 0 1]; ones(1200,1)*[1 0 0]] ;
    paramstruct = struct('vxgrid',[0.1 0.5], ...
                         'eptflag',1, ...
                         'ndatovlay',50, ...
                         'dolcolor',icolor, ...
                         'dolmarkerstr',markerstr, ...
                         'titlestr','n = 2000, ndol = 50') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 29 ;  %  test error message when input is not a column vector
  rng(92387494) ;
  indat = sort(rand(50,30)) ;

  disp('Check Get Error and Termination when input is a matrix') ;
  kdeSM(indat)

  disp('Check Get Error and Termination when input is a row vector') ;
  kdeSM(indat(:,1)')


elseif itest == 30 ;  %  test axis SM option
  rng(92387494) ;
  indat = sort(rand(50,1)) ;

  subplot(2,2,1) ;
    paramstruct = struct('dolcolor','m', ...
                         'dolmarkerstr','o', ...
                         'titlestr','Default xgrid, data range') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,2) ;
    paramstruct = struct('vxgrid',0, ...
                         'dolcolor',2, ...
                         'dolmarkerstr','o', ...
                         'titlestr','Default xgrid, data range') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,3) ;
    paramstruct = struct('vxgrid',1, ...
                         'dolcolor','m', ...
                         'dolmarkerstr','o', ...
                         'titlestr','xgrid = 1, use axisSM') ;
    kdeSM(indat,paramstruct) ;

  subplot(2,2,4) ;
    paramstruct = struct('vxgrid',1, ...
                         'dolcolor',2, ...
                         'dolmarkerstr','o', ...
                         'titlestr','xgrid = 1, use axisSM') ;
    kdeSM(indat,paramstruct) ;


elseif itest == 31 ;  %  test handling of data points all same
  indat  = 3 * ones(20,1) ;

  disp('Test Data points all same, all defaults, numerical output') ;
  out = kdeSM(indat) ;
  out

  subplot(2,2,1) ;
  title('Plot 1,1: Nothing Expected Here') ;
  disp('Test Data points all same, all defaults, graphical output') ;
  kdeSM(indat) ;

  subplot(2,2,2) ;
  disp('Plot 1,2: Test Data points all same, input vxgrid, default h') ;
  paramstruct = struct('vxgrid',[1; 5], ...
                       'titlestr','Input vxgrid, Default h') ;
  kdeSM(indat,paramstruct) ;
  
  subplot(2,2,3) ;
  disp('Plot 2,1: Test Data points all same, input vxgrid, input h') ;
  paramstruct = struct('vh',0.5, ...
                       'vxgrid',[1; 5], ...
                       'titlestr','Input vxgrid, Input h = 0.5' ) ;
  kdeSM(indat,paramstruct)  ;


end ;    %  of itest if-block


