disp('Running MATLAB script file rmeanSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION rmeanSM,
%    Robust analog of the mean

itest = 8 ;     %  1,...,8


format compact ;


if itest == 1 ;  

  seed = 29487503 ;
  randn('seed',seed) ;

  for isim = 1:10 ;

    indat = randn(100,1) ; 

    samplemean = mean(indat)

    robustmean = rmeanSM(indat) 

    pauseSM

  end ;

elseif itest == 2 ;   

  seed = 29378409 ;
  randn('seed',seed) ;

  indat = randn(9,1) ; 
  indat = [indat; 100] ;

  samplemean = mean(indat)
  samplemedian = median(indat)
  robustmean = rmeanSM(indat) 

elseif itest == 3 ;   

  seed = 29378409 ;
  randn('seed',seed) ;

  indat = randn(9,1) ; 
  indat = [indat; 1000] ;

  samplemean = mean(indat)
  samplemedian = median(indat)
  robustmean = rmeanSM(indat) 

elseif itest == 4 ;   

  seed = 29378409 ;
  randn('seed',seed) ;

  for isim = 1:10 ;

    indat = randn(9,1) ; 
    indat = [indat; 10^9] ;

    samplemean = mean(indat)
    samplemedian = median(indat)
    robustmean = rmeanSM(indat) 

    pauseSM

  end ;


elseif itest == 5 ;   

  clf ;
  seed = 29378409 ;
  randn('seed',seed) ;

  indat = randn(200,2) ;
          %  Spherical Normals
  indat(:,1) = indat(:,1) + 5 ;
          %  shift x coordinate to right
  indat(:,2) = indat(:,2) + 5 ;
          %  shift y coordinate up
  indat(1:100,1) = 5 * indat(1:100,1) ;
          %  horizontally rescale first half of data
  indat(101:200,2) = 5 * indat(101:200,2) ;
          %  horizontally rescale second half of data

  samplemean = mean(indat)
  samplemedian = median(indat)
  robustmean = rmeanSM(indat) 

  plot(indat(:,1),indat(:,2),'o') ;
    hold on ;
      plot(samplemean(1),samplemean(2),'r+') ;
      plot(samplemedian(1),samplemedian(2),'rx') ;
      plot(robustmean(1),robustmean(2),'r*') ;
      legend('data','mean','median','robust mean') ;
    hold off ;

elseif itest == 6 ;   

  clf ;
  seed = 29904754 ;
  randn('seed',seed) ;

  indat = randn(10,2) ;
          %  Spherical Normals
  indat(:,1) = indat(:,1) + 5 ;
          %  shift x coordinate to right
  indat(:,2) = indat(:,2) + 5 ;
          %  shift y coordinate up
  indat(1:5,1) = 5 * indat(1:5,1) ;
          %  horizontally rescale first half of data
  indat(6:10,2) = 5 * indat(6:10,2) ;
          %  horizontally rescale second half of data
  indat = [indat; [5,500]; [500,5]] ;

  samplemean = mean(indat)
  samplemedian = median(indat)
  robustmean = rmeanSM(indat) 

  plot(indat(:,1),indat(:,2),'o') ;
    hold on ;
      plot(samplemean(1),samplemean(2),'r+') ;
      plot(samplemedian(1),samplemedian(2),'rx') ;
      plot(robustmean(1),robustmean(2),'r*') ;
      legend('data','mean','median','robust mean') ;
    hold off ;

elseif itest == 7 ;   
  %  Example 4 from gpcd1t.m (one outlier, in curves as data)

  clf ;
  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;
  mdata = [mdata, 15 * (sin(pi * xgrid) + 1)] ;

  samplemean = mean(mdata')
  samplemedian = median(mdata')
  robustmean = rmeanSM(mdata') 
 

  plot((1:d)',mdata','y') ;
  hold on ;
    plot((1:d)',samplemean','r') ;
    plot((1:d)',samplemedian','g') ;
    plot((1:d)',robustmean','c') ;
%    vachil = get(gca,'Children') ;
%    set(vachil(1),'LineWidth',3) ;
%    set(vachil(2),'LineWidth',3) ;
%    set(vachil(3),'LineWidth',3) ;
  hold off ;
  legend('data','mean','median','robust mean') ;


elseif itest == 8 ;   

  clf ;
  d = 10 ;
  n = 11 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;
  mdata = [mdata, -30 + 40 * (sin(pi * xgrid) + 1)] ;

  samplemean = mean(mdata')
  samplemedian = median(mdata')
  robustmean = rmeanSM(mdata') 
 

  plot((1:d)',mdata','y') ;
  hold on ;
    plot((1:d)',samplemean','r') ;
    plot((1:d)',samplemedian','g') ;
    plot((1:d)',robustmean','c') ;
    vachil = get(gca,'Children') ;
    set(vachil(1),'LineWidth',3) ;
    set(vachil(2),'LineWidth',3) ;
    set(vachil(3),'LineWidth',3) ;
  hold off ;
%  legend('data','mean','median','robust mean') ;


end ;



