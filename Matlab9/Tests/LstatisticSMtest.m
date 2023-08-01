disp('Running MATLAB script file LstatisticSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION LstatisticSM,
%    Computation of L-statistics, through L-moments and L-ratios

itest = 29 ;     %  1,...,29



if itest == 1 ;  

  disp('For 1000 N(0,1)s, try out k = 1') ;
  data = randn(1000,1) ;
  k = 1
  Lstat = LstatisticSM(data,k)

  disp('Compare to sample mean:') ;
  Xbar = mean(data) 

  disp(['Abs Difference = ' num2str(Lstat - Xbar)]) ;

elseif itest == 2 ;   

  disp('For 1000 N(0,1)s, try out k = 2') ;
  data = randn(1000,1) ;
  k = 2
  Lstat = LstatisticSM(data,k)

  disp('Compare to theoretical value:') ;
  Theoretical = 1 / sqrt(pi)  

  disp(['Abs Difference = ' num2str(Lstat - Theoretical)]) ;

elseif itest == 3 ;   

  disp('For 1000 N(0,1)s, try out k = 3') ;
  data = randn(1000,1) ;
  k = 3
  Lstat = LstatisticSM(data,k)

  disp('Compare to theoretical value:') ;
  Theoretical = 0

  disp(['Abs Difference = ' num2str(Lstat - Theoretical)]) ;

elseif itest == 4 ;   

  disp('For 1000 N(0,1)s, try out k = 4') ;
  data = randn(1000,1) ;
  k = 4
  Lstat = LstatisticSM(data,k)

  disp('Compare to theoretical value:') ;
  Theoretical = 0.1226  

  disp(['Abs Difference = ' num2str(Lstat - Theoretical)]) ;

elseif itest == 5 ;   

  disp('For small seeded data set of 20 N(5,1)s, try out k = 2') ;
  rng(34985730) ;
  data = randn(20,1) + 5
  k = 2
  Lstat = LstatisticSM(data,k)

elseif itest == 6 ;   

  disp('For small seeded data set of 20 N(5,1)s, try out k = 3') ;
  rng(34985730) ;
  data = randn(20,1) + 5
  k = 3
  Lstat = LstatisticSM(data,k)

elseif itest == 7 ;   

  disp('For small seeded data set of 20 N(5,1)s, try out k = 4') ;
  rng(34985730) ;
  data = randn(20,1) + 5
  k = 4
  Lstat = LstatisticSM(data,k)

elseif itest == 8 ;   

  disp('For 200 runs of 1000 N(0,1)s, try out k = 2') ;
  k = 2 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = randn(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 1 / sqrt(pi) ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', N(0,1), n = 1000']) ;
  hold off ;


elseif itest == 9 ;   

  disp('For 200 runs of 1000 N(0,1)s, try out k = 3') ;
  k = 3 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = randn(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 0 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', N(0,1), n = 1000']) ;
  hold off ;


elseif itest == 10 ;   

  disp('For 200 runs of 1000 N(0,1)s, try out k = 4') ;
  k = 4 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = randn(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 0.1226 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', N(0,1), n = 1000']) ;
  hold off ;


elseif itest == 11 ;   

  disp('For 200 runs of 1000 Unif(0,1)s, try out k = 2') ;
  k = 2 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = rand(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 1 / 6 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Unif(0,1), n = 1000']) ;
  hold off ;


elseif itest == 12 ;   

  disp('For 200 runs of 1000 Unif(0,1)s, try out k = 3') ;
  k = 3 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = rand(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 0 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Unif(0,1), n = 1000']) ;
  hold off ;


elseif itest == 13 ;   

  disp('For 200 runs of 1000 Unif(0,1)s, try out k = 4') ;
  k = 4 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = rand(1000,1) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 0 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Unif(0,1), n = 1000']) ;
  hold off ;


elseif itest == 14 ;   

  disp('For 200 runs of 1000 Exp(0,1)s, try out k = 2') ;
  k = 2 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = log(rand(1000,1)) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 1 / 2 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Exponential(1), n = 1000']) ;
  hold off ;


elseif itest == 15 ;   

  disp('For 200 runs of 1000 Exp(1)s, try out k = 3') ;
  k = 3 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = log(rand(1000,1)) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 1 / 3 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Exponential(1), n = 1000']) ;
  hold off ;


elseif itest == 16 ;   

  disp('For 200 runs of 1000 Exp(1)s, try out k = 4') ;
  k = 4 ;
  nsim = 200 ;

  vLstat = [] ;
  for isim = 1:nsim ;
    disp(['    Working on sim ' num2str(isim) ' of ' num2str(nsim)]) ;
    data = log(rand(1000,1)) ;
    Lstat = LstatisticSM(data,k) ;
    vLstat = [vLstat; Lstat] ;
  end ;

  Theoretical = 1 / 6 ;
  figure(1) ;
  clf ;
  kdeSM(vLstat) ;
  vax = axis ;
  hold on ;
  plot([Theoretical; Theoretical],[vax(3); vax(4)],'k-','LineWidth',5) ;
  title(['Test of LstatisticSM, k = ' num2str(k) ', Exponential(1), n = 1000']) ;
  hold off ;


elseif itest == 17 ;   

  disp('Test bad input k = 5') ;
  data = randn(100,1) ;
  k = 5
  Lstat = LstatisticSM(data,k)


elseif itest == 18 ;   

  disp('Test bad input k = -2') ;
  data = randn(100,1) ;
  k = -2
  Lstat = LstatisticSM(data,k)


elseif itest == 19 ;   

  disp('Test bad input k = -2') ;
  data = randn(100,1) ;
  k = -2
  Lstat = LstatisticSM(data,k)


elseif itest == 20 ;   

  disp('Test manually input iratio = 1') ;
  data = randn(100,1) ;
  k = 3 ;
  Lstat = LstatisticSM(data,k)
  iratio = 1
  Lstat = LstatisticSM(data,k,iratio)
  disp('Above should be same') ;


elseif itest == 21 ;   

  disp('Test bad input iratio = 2') ;
  data = randn(100,1) ;
  k = 3 ;
  iratio = 2
  Lstat = LstatisticSM(data,k,iratio)


elseif itest == 22 ;   

  disp('Test k = 1,  iratio = 0') ;
  data = randn(100,1) ;
  k = 1 
  iratio = 0
  Lstat = LstatisticSM(data,k,iratio)


elseif itest == 23 ;   

  disp('Test k = 2,  iratio = 0') ;
  data = randn(100,1) ;
  k = 2 
  iratio = 0
  Lstat = LstatisticSM(data,k,iratio)


elseif itest == 24 ;   

  disp('Test k = 3,  iratio = 0') ;
  data = randn(100,1) ;
  k = 3 
  iratio = 0
  Lstat = LstatisticSM(data,k,iratio)


elseif itest == 25 ;   

  disp('Test k = 4,  iratio = 0') ;
  data = randn(100,1) ;
  k = 4
  iratio = 0
  Lstat = LstatisticSM(data,k,iratio)


elseif itest == 26 ;   

  disp('Test matrix implementation') ;
  data = randn(1000,10) ;
  k = 3
  Lstat = LstatisticSM(data,k)


elseif itest == 27 ;   

  disp('Test scalar input') ;
  data = randn(1,1) ;
  k = 3
  Lstat = LstatisticSM(data,k)


elseif itest == 28 ;   

  disp('Test input too small') ;
  data = randn(2,2) ;
  k = 3
  Lstat = LstatisticSM(data,k)


elseif itest == 29 ;   

  disp('Test input just big enough') ;
  data = randn(3,3) ;
  k = 3
  Lstat = LstatisticSM(data,k)


end ;




