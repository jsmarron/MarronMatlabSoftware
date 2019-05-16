disp('Running MATLAB script file CHlbinrSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION CHlbinrSM,
%    Censored, Hazard Linear Binner

itest = 7 ;       %  1,...,7  Simple Parameter Tests
                  %  51,52,53,54  Uniform Tests
                  %  61,62,63,64  Gaussian Tests

format compact ;
format short ;



if itest == 1 ;     %  test against lbinrSM

  data = rand(100,1) ;

  oldcts = lbinrSM(data) ;

  data = [data, ones(100,2)] ;

  newcts = CHlbinrSM(data,0,0) ;
      %  0 - default grid
      %  0 - eptflag (same as regular default)

  newcts = 100 * newcts / sum(newcts) ;
      %  this is needed, since otherwise the 0 denominator
      %  adjustment leaves this a little small

  dif = max(abs(oldcts - newcts))


elseif itest == 2 ;    %   everything censored

  data = rand(100,1) ;
  data = sort(data) ;

  cdfbar = 1 - KMcdfSM(data,zeros(100,1)) ;

  data = [data, zeros(100,1), cdfbar] ;

  cts = CHlbinrSM(data) ;

  figure(1) ;
  plot(cts) ;




elseif itest == 3 ;    %   everything below left end

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

  [cts,bcents] = CHlbinrSM(data,[2,5,10]) ;
          %  grid above the data

  cts


elseif itest == 4 ;    %   everything above left end

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

  [cts,bcents] = CHlbinrSM(data,[-3,-2,10]) ;
          %  grid above the data

  cts


elseif itest == 5 ;    %   half the data hanging out at each end,
                       %   default truncation

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

  [cts,bcents] = CHlbinrSM(data,[.25,.75,50]) ;
          %  grid above the data

  figure(1) ;
  plot(bcents,log10(cts)) ;


elseif itest == 6 ;    %   half the data hanging out at each end,
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

  [cts,bcents] = CHlbinrSM(data,[.25,.75,50],0) ;
          %  grid above the data
          %  0 to move data to ends

  figure(1) ;
  plot(bcents,log10(cts)) ;


elseif itest == 7 ;    %   half the data hanging out at each end,
                       %   chosen no truncation

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

  [cts,bcents] = CHlbinrSM(data,[.25,.75,50],1) ;
          %  grid above the data
          %  1 to truncate data beyond ends

  figure(1) ;
  plot(bcents,log10(cts)) ;



elseif itest == 51 ;    %   Uniform Density Estimation test

  n = 10000 ;
  vdata = rand(n,1) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  plot(bcents,cts,'r-',...
       bcents,25*ones(length(cts),1),'b-') ;


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

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  plot(bcents,cts,'r-',...
       bcents,25*ones(length(cts),1),'b-') ;


elseif itest == 53 ;    %   Uniform Hazard Estimation test

  n = 10000 ;
  vdata = rand(n,1) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  plot(bcents,log10(cts),'r-',...
       bcents,log10(25 ./ (1 - bcents)),'b-') ;


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

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  plot(bcents,log10(cts),'r-',...
       bcents,log10(25 ./ (1 - bcents)),'b-') ;


elseif itest == 61 ;    %   Gaussian Density Estimation test

  n = 10000 ;
  vdata = randn(n,1) ;
  vdel = ones(n,1) ;
  vcdfbar = ones(n,1) ;  

  data = [vdata, vdel, vcdfbar] ;

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  vf = nmfSM(bcents,0,1,1) ;
  nbin = length(cts) ;
  dfact = (n / nbin) * (bcents(nbin) - bcents(1))  ;
  plot(bcents,cts,'r-',...
       bcents,dfact*vf,'b-') ;


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

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  vf = nmfSM(bcents,0,1,1) ;
  nbin = length(cts) ;
  dfact = (n / nbin) * (bcents(nbin) - bcents(1))  ;
  plot(bcents,cts,'r-',...
       bcents,dfact*vf,'b-') ;


elseif itest == 63 ;    %   Gaussian Hazard Estimation test

  n = 10000 ;
  vdata = randn(n,1) ;
  vdel = ones(n,1) ;

  [vcdf, svdata, svdel] = KMcdfSM(vdata,vdel) ;
  vfbar = 1 - vcdf  ;  

  data = [svdata, svdel, vfbar] ;

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  vh = nmfSM(bcents,0,1,1) ;
  vh = vh ./ (1 - normcdf(bcents)) ;
  nbin = length(cts) ;
  dfact = (n / nbin) * (bcents(nbin) - bcents(1))  ;
  plot(bcents,log10(cts),'r-',...
       bcents,log10(dfact * vh),'b-') ;


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

  [cts,bcents] = CHlbinrSM(data) ;

  figure(1) ;
  vh = nmfSM(bcents,0,1,1) ;
  vh = vh ./ (1 - normcdf(bcents)) ;
  nbin = length(cts) ;
  dfact = (n / nbin) * (bcents(nbin) - bcents(1))  ;
  plot(bcents,log10(cts),'r-',...
       bcents,log10(dfact * vh),'b-') ;


end ;
