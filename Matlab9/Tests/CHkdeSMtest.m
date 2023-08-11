disp('Running MATLAB script file CHkdeSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION CHkdeSM,
%    Censored, Hazard Kernel Density estimation


itest = 96 ;       %  1,...,20  Simple Parameter Tests
                  %  51,52,53,54  Uniform Tests
                  %  61,62,63,64  Gaussian Tests
                  %  71,72,73,74,75,76  Exponential Tests
                  %  81,82,83,83  Uniform, length biased
                  %  91,92,93,94,95,96  Exponential, length biased

%  to do:  add more parts about new parameters,
%  especially to check out colors of added dots



format compact ;
format short ;

figure(1) ;
clf ;


if itest == 1 ;     %  test against kdeSM

  disp('') ;

  data = rand(100,1) ;
  vh = [0.1; 1; 10] ;


%    eptflag = 0 ;
%    eptflag = 1 ;
%    paramstruct = struct('vh',vh, ...
%                         'eptflag',eptflag) ;
    paramstruct = struct('vh',vh) ;
  [oldkde, oldgrid] = kdeSM(data,paramstruct) ;


%    paramstruct = struct('eptflag',eptflag) ;
%  [newkde, newgrid] = CHkdeSM(data,vh,paramstruct) ;
  [newkde, newgrid] = CHkdeSM(data,vh) ;

  dif = max(max(abs(oldkde - newkde)))


elseif itest == 2 ;    %   everything censored

  disp('') ;

  data = rand(100,1) ;
  data = sort(data) ;
  vh = 1 ;

  cdfbar = 1 - KMcdfSM(data,zeros(100,1)) ;

  data = [data, zeros(100,1), cdfbar] ;

  kde = CHkdeSM(data,vh) ;

  figure(1) ;
  plot(kde) ;


elseif itest == 3 ;    %   everything below left end

  disp('') ;

  n = 100 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = 1 ;
  paramstruct = struct('itype',2, ...
                       'vxgrid',[2,5,10]) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;
          %  grid above the data

  kde


elseif itest == 4 ;    %   everything above right end

  disp('') ;

  n = 100 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = 1 ;
  paramstruct = struct('itype',2, ...
                       'vxgrid',[-3,-2,10]) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;
          %  grid above the data

  kde


elseif itest == 5 ;    %   half the data hanging out at each end,
                       %   default truncation

  disp('') ;

  n = 1000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = .02 ;
  paramstruct = struct('itype',2, ...
                       'vxgrid',[.25,.75,50]) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;
          %  grid in the middle of the data

  figure(1) ;
  plot(xgrid,kde) ;


elseif itest == 6 ;    %   half the data hanging out at each end,
                       %   chosen no truncation

  disp('') ;

  n = 1000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = .02 ;
  paramstruct = struct('itype',2, ...
                       'vxgrid',[.25,.75,50], ...
                       'eptflag',0) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;
          %  grid in the middle of the data
          %  0 to move data to ends

  figure(1) ;
  plot(xgrid,kde) ;


elseif  itest == 7  | ...
        itest == 8  | ...
        itest == 9  | ...
        itest == 10  | ...
        itest == 11  | ...
        itest == 12  | ...
        itest == 13  | ...
        itest == 14  | ...
        itest == 15  | ...
        itest == 16  | ...
        itest == 17  | ...
        itest == 18  | ...
        itest == 19  ;    %   half the data hanging out at each end,
                         %   chosen truncation

  n = 1000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = .02 ;
  if itest == 7 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1) ;
  elseif itest == 8 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ndataoverlay',100) ;
  elseif itest == 9 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ndataoverlay',1000) ;
  elseif itest == 10 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ndataoverlay',100000) ;
  elseif itest == 11 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ndataoverlay',1) ;
  elseif itest == 12 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ndataoverlay',2) ;
  elseif itest == 13 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'dolcolor','m') ;
  elseif itest == 14 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'dolcolor','m', ...
                         'cdolcolor','r') ;
  elseif itest == 15 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'linewidth',6) ;
  elseif itest == 16 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'linecolor','k') ;
  elseif itest == 17 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'titlestr','test title', ...
                         'xlabelstr','test X', ...
                         'ylabelstr','test Y') ;
  elseif itest == 18 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'titlestr','test title', ...
                         'titlefontsize',24, ...
                         'xlabelstr','test X', ...
                         'ylabelstr','test Y', ...
                         'labelfontsize',15) ;
  elseif itest == 19 ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'ndataoverlay',2, ...
                         'plotbottom',3, ...
                         'plottop',12) ;
  end ;
  CHkdeSM(data,vh,paramstruct) ;
          %  grid in the middle of the data
          %  1 to truncate data beyond ends


elseif itest == 20 ;    %  test big dots

  n = 1000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = .02 ;



    figure(1)
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ibigdot',1, ...
                         'titlestr','Test of Big Dots', ...
                         'ndataoverlay',100000) ;
    CHkdeSM(data,vh,paramstruct) ;

    figure(2)
    paramstruct = struct('itype',2, ...
                         'vxgrid',[.25,.75,50], ...
                         'eptflag',1, ...
                         'ibigdot',0, ...
                         'titlestr','Default Dot Size', ...
                         'ndataoverlay',100000) ;
    CHkdeSM(data,vh,paramstruct) ;



elseif itest == 51 ;    %   Uniform Density Estimation test

  n = 10000 ;
  vdata = rand(n,1) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Unif. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,ones(length(kde),1),'r-') ;
  hold off ;

elseif itest == 52 ;    %   Uniform Censored Density Estimation test

  n = 10000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

%[vdata,vind] = sort(vdata) ;
%vdel = vdel(vind) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;

  data = [svdata, svdel, vgbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Cens. Unif. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,ones(length(kde),1),'r-') ;
  hold off ;


elseif itest == 53 ;    %   Uniform Hazard Estimation test

  n = 10000 ;
  vdata = rand(n,1) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Unif. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,1 ./ (1 - xgrid),'r-') ;
  hold off ;


elseif itest == 54 ;    %   Uniform Censored Hazard Estimation test

  n = 10000 ;
  vt = rand(n,1) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Cen. Unif. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,1 ./ (1 - xgrid),'r-') ;
  hold off ;


elseif itest == 61 ;    %   Gaussian Density Estimation test

  n = 10000 ;
  vdata = randn(n,1) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Gaussian Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = nmfSM(xgrid,0,1,1) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 62 ;    %   Gaussian Censored Density Estimation test

  n = 10000 ;
  vt = randn(n,1) ;
  vc = randn(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

%[vdata,vind] = sort(vdata) ;
%vdel = vdel(vind) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;

  data = [svdata, svdel, vgbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Cen. Gaussian Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = nmfSM(xgrid,0,1,1) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 63 ;    %   Gaussian Hazard Estimation test

  n = 10000 ;
  vdata = randn(n,1) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Gaussian Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = nmfSM(xgrid,0,1,1) ;
    vf = vf ./ (1 - normcdf(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 64 ;    %   Gaussian Censored Hazard Estimation test

  n = 10000 ;
  vt = randn(n,1) ;
  vc = randn(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Gaussian Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = nmfSM(xgrid,0,1,1) ;
    vf = vf ./ (1 - normcdf(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 71 ;    %   Exponential Density Estimation test

  n = 10000 ;
  vdata = -log(rand(n,1)) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Exp. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = exp(-xgrid) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 72 ;    %   Exponential Censored Density Estimation test

  n = 10000 ;
  vt = -log(rand(n,1)) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

%[vdata,vind] = sort(vdata) ;
%vdel = vdel(vind) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;

  data = [svdata, svdel, vgbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',1, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Cens. Exp. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = exp(-xgrid) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 73 ;    %   Exponential Hazard Estimation test

  n = 10000 ;
  vdata = -log(rand(n,1)) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 74 ;    %   Exponential Censored Hazard Estimation test

  n = 10000 ;
  vt = -log(rand(n,1)) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',2, ...
                         'ndataoverlay',1, ...
                         'titlestr',['Cens. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 75 ;    %   Truncated Exponential Hazard Estimation test

  n = 10000 ;
  vdata = -log(rand(n,1)) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.02; .2; 2] ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[0,4], ...
                         'ndataoverlay',1, ...
                         'titlestr',['Trunc. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;



elseif itest == 76 ;    %   Truncated Exponential Censored Hazard Estimation test

  n = 10000 ;
  vt = -log(rand(n,1)) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.02; .2; 2] ;
    paramstruct = struct('itype',2, ...
                         'vxgrid',[0,4], ...
                         'ndataoverlay',1, ...
                         'titlestr',['Trunc. Cens. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 81 ;    %   Length Biased Uniform Density Estimation test

  n = 10000 ;
  vdata = sqrt(rand(n,1)) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',3, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Unif. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,ones(length(kde),1),'r-') ;
  hold off ;


elseif itest == 82 ;    %   Length Biased Uniform Censored Density Estimation test

  n = 10000 ;
  vt = sqrt(rand(n,1)) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

%[vdata,vind] = sort(vdata) ;
%vdel = vdel(vind) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;

  data = [svdata, svdel, vgbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',3, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Cens. Unif. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,ones(length(kde),1),'r-') ;
  hold off ;


elseif itest == 83 ;    %   Length Biased Uniform Hazard Estimation test

  n = 10000 ;
  vdata = sqrt(rand(n,1)) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',4, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Unif. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,1 ./ (1 - xgrid),'r-') ;
  hold off ;


elseif itest == 84 ;    %   Length Biased Uniform Censored Hazard Estimation test

  n = 10000 ;
  vt = sqrt(rand(n,1)) ;
  vc = rand(n,1) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.025; .1; .4] ;
    paramstruct = struct('itype',4, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Cens. Unif. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    plot(xgrid,1 ./ (1 - xgrid),'r-') ;
  hold off ;


elseif itest == 91 ;    %   Length Biased Exponential Density Estimation test

  n = 10000 ;
  vdata = -log(rand(n,2)) ;
  vdata = sum(vdata,2) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',3, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Exp. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = exp(-xgrid) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 92 ;    %   Length Biased Exponential Censored Density Estimation test

  n = 10000 ;
  vt = -log(rand(n,2)) ;
  vt = sum(vt,2) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

%[vdata,vind] = sort(vdata) ;
%vdel = vdel(vind) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;

  data = [svdata, svdel, vgbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',3, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Cens. Exp. Dens. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = exp(-xgrid) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 93 ;    %   Length Biased Exponential Hazard Estimation test

  n = 10000 ;
  vdata = -log(rand(n,2)) ;
  vdata = sum(vdata,2) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',4, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 94 ;    %   Length Biased Exponential Censored Hazard Estimation test

  n = 10000 ;
  vt = -log(rand(n,2)) ;
  vt = sum(vt,2) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.05; .5; 5] ;
    paramstruct = struct('itype',4, ...
                         'ndataoverlay',1, ...
                         'titlestr',['L. B. Cens. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 95 ;    %   Length Biased Truncated Exponential Hazard Estimation test

  n = 10000 ;
  vdata = -log(rand(n,2)) ;
  vdata = sum(vdata,2) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  vh = [.02; .2; 2] ;
    paramstruct = struct('itype',4, ...
                         'vxgrid',[0,4], ...
                         'ndataoverlay',1, ...
                         'titlestr',['Trunc. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


elseif itest == 96 ;    %   Length Biased Truncated Exponential Censored Hazard Estimation test

  n = 10000 ;
  vt = -log(rand(n,2)) ;
  vt = sum(vt,2) ;
  vc = -log(rand(n,1)) ;

  vdata = min(vt,vc) ;
  vdel = vdata == vt ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,1 - vdel) ;
  vgbar = 1 - vcdf  ;  
  svdel = 1 - svdel ;
          %  Note have plugged in 1- above

  vcdf = KMcdfSM(svdata,svdel,1) ;
          %  data already presorted, so don't sort again
  vfbar = 1 - vcdf  ;  

  vlbar = vfbar .* vgbar ;

  data = [svdata, svdel, vlbar] ;

  vh = [.02; .2; 2] ;
    paramstruct = struct('itype',4, ...
                         'vxgrid',[0,4], ...
                         'ndataoverlay',1, ...
                         'titlestr',['Trunc. Cens. Exp. Haz. Est., n = ' num2str(n)], ...
                         'iplot',1) ;
  [kde,xgrid] = CHkdeSM(data,vh,paramstruct) ;

  hold on ;
    vf = ones(size(xgrid)) ;
    plot(xgrid,vf,'r-') ;
  hold off ;


end ;
