disp('Running MATLAB script file SigClustCovEstHHtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClustCovEstHH
%     Does soft thresholded COVariance ESTimate 


itest = 37 ;     %  1,2,3,4,5,6,7    very simple tests
                 %  11,12,13,14,15            various ties and special cases
                 %  21,22,23,24,25,26,27,28       bigger examples, with graphics
                 %  31   Standard normal simulated data
                 %  32   Spike normal simulated data
                 %  33   Sloped normal simulated data
                 %  34   Slope Drop normal simulated data
                 %  35   Flat & Drop normal simulated data
                 %  36   Two Cluster (45deg) simulated data
                 %  37   Two Cluster (1 entry) simulated data


if itest == 1 ;    %  Simple toy data, just for construction purposes

  vsampeigv = [7; 6; 4; 2; 1; 1] 
  sig2b = 3 

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

   %  this is a really easy clear example, 
   %  where one can easily see what all the answers 
   %  should be, for simple model checking



elseif itest == 2 ;     %  Simple Test Data, all too big

  vsampeigv = [7; 6; 5] 
  sig2b = 3 

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for warning message



elseif itest == 3 ;     %  Simple Test Data, sum too small

  vsampeigv = [5; 4; 3; 2; 1] 
  sig2b = 4

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for warning message



elseif itest == 4 ;     %  Simple Test Data, nondecreasing eigenvalues

  vsampeigv = [5; 4; 2; 3; 1] 
  sig2b = 2

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for error message
  %  and empty returns



elseif itest == 5 ;     %  Simple Test Data, with a negative eigenvalue

  vsampeigv = [5; 4; 2; 0; -1] 
  sig2b = 2

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for error message
  %  and empty returns



elseif itest == 6 ;     %  Simple Test Data, matrix argument

  vsampeigv = rand(6,2)
  sig2b = 0

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for error message
  %  and empty returns



elseif itest == 7 ;     %  Simple Test Data, row vector argument

  vsampeigv = rand(1,5)
  sig2b = 0

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  Look for error message
  %  and empty returns



elseif itest == 11 ;     %  Simple ties data set

  vsampeigv = [5; 3; 3; 3; 2]
  sig2b = 3

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  From pencil and paper calculations, expect:
  %    Power moved = 1
  %    tau = 1
  %    Final Cov est = [4; 3; 3; 3; 3]



elseif itest == 12 ;     %  Another ties data set

  vsampeigv = [7; 6; 3; 3; 3; 1; 1]
  sig2b = 3

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  From pencil and paper calculations, expect:
  %    Power moved = 4
  %    tau = 2
  %    Final Cov est = [5; 4; 3; 3; 3; 3]




elseif itest == 13 ;     %  A big spike, low sig2b example

  vsampeigv = [10; 3; 2; 0]
  sig2b = 2

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  From pencil and paper calculations, expect:
  %    Power moved = 2
  %    tau = 1
  %    Final Cov est = [9; 2; 2; 2]



elseif itest == 14 ;     %  Single big spike example

  vsampeigv = [12; 3; 2; 1]
  sig2b = 4

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  From pencil and paper calculations, expect:
  %    Power moved = 6
  %    tau = 6
  %    Final Cov est = [6; 4; 4; 4]



elseif itest == 15 ;     %  all but one above sig2b

  vsampeigv = [6; 5; 4; 0]
  sig2b = 3

  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) 

  %  From pencil and paper calculations, expect:
  %    Power moved = 3
  %    tau = 1
  %    Final Cov est = [5; 4; 3; 3]


elseif   itest == 21  | ...
         itest == 22  | ...
         itest == 23  | ...
         itest == 24  | ...
         itest == 25  | ...
         itest == 26  | ...
         itest == 27  | ...
         itest == 28  ;  %  Make bigger tests, with graphics

  if itest == 21 ;
    vsampeigv = 1.2.^(10:-1:1)' ;
    sig2b = 1 ;
  elseif itest == 22 ;
    vsampeigv = 1.2.^(10:-1:1)' ;
    sig2b = 2 ;
  elseif itest == 23 ;
    vsampeigv = 1.2.^(10:-1:1)' ;
    sig2b = 4 ;
  elseif itest == 24 ;
    vsampeigv = 1.2.^(10:-1:1)' ;
    sig2b = 2.8 ;
  elseif itest == 25 ;
    vsampeigv = 1.2.^(10:-1:1)' ;
    sig2b = 3.1 ;
  elseif itest == 26 ;
    vsampeigv = 8 - flipud(1.2.^(10:-1:1)') ;
    sig2b = 2 ;
  elseif itest == 27 ;
    vsampeigv = 8 - flipud(1.2.^(10:-1:1)') ;
    sig2b = 4 ;
  elseif itest == 28 ;
    vsampeigv = 8 - flipud(1.2.^(10:-1:1)') ;
    sig2b = 4.85 ;
  end ;


  %  Make graphics to view results
  %
  figure(1) ;
  clf ; 
  [veigvest, tau] = SigClustCovEstHH(vsampeigv,sig2b) ;
  vi = (1:length(vsampeigv))' ;
  plot(vi,vsampeigv,'ko','MarkerSize',8,'LineWidth',2) ;
    title(['Test Graphic for SigClustCovEstHH,   itest = ' num2str(itest)],'FontSize',15) ;
    axisSM(vi,vsampeigv) ;
    vax = axis ;
    hold on ;
      plot([vax(1); vax(2)],[sig2b; sig2b],'m-') ;
      plot(vi,veigvest,'r--','LineWidth',4) ;
      text(vax(1) + 0.7 * (vax(2) - vax(1)), ...
           vax(3) + 0.9 * (vax(4) - vax(3)), ...
           ['tau = ' num2str(tau)],'FontSize',15) ;
    hold off ;



elseif   itest == 31  | ...
         itest == 32  | ...
         itest == 33  | ...
         itest == 34  | ...
         itest == 35  | ...
         itest == 36  | ...
         itest == 37  ;  %  Make bigger tests, with graphics

  d = 100 ;
  n = 40 ;
  nsim = 20 ;
  if itest == 31 ;
    seedn = 49384597835 ;
    randn('state',seedn) ;
    titstr = 'Standard Normal' ;
  elseif itest == 32 ;
    seed = 7943872550 ;
    titstr = 'Spiked Normal' ;
  elseif itest == 33 ;
    seed = 723098475 ;
    titstr = 'Sloped Normal' ;
  elseif itest == 34 ;
    seed = 3794750875 ;
    titstr = 'Slope Drop Normal' ;
  elseif itest == 35 ;
    seed = 4384350583 ;
    titstr = 'Flat & Drop Normal' ;
  elseif itest == 36 ;
    seed = 2938475752 ;
    titstr = '2 Cluster (45 deg)' ;
  elseif itest == 37 ;
    seed = 9375432875 ;
    titstr = '2 Cluster (1 entry)' ;
  end ;


  vsig2b = [] ;
  vstd2 = [] ;
  vtau = [] ;
  mveigval = [] ;
  mveigvest = [] ;
  for isim = 1:nsim ;

    if itest == 31 ;    %  Standard Normal
      mdata = randn(d,n) ;
    elseif itest == 32 ;    %  Spiked Normal
      mdata = randn(d,n) ;
      mdata(1,:) = 10 * mdata(1,:) ;
    elseif itest == 33 ;    %  Sloped Normal
      mdata = randn(d,n) ;
      mdata(1:30,:) = (sqrt((30:-1:1)') * ones(1,n)) .* mdata(1:30,:) ;
    elseif itest == 34 ;    %  Slope Drop Normal
      mdata = randn(d,n) ;
      mdata(1:45,:) = (sqrt((60:-1:16)') * ones(1,n)) .* mdata(1:45,:) ;
    elseif itest == 35 ;    %  Flat & Drop Normal
      mdata = randn(d,n) ;
      mdata(1:15,:) = (20 * ones(15,n)) .* mdata(1:15,:) ;
    elseif itest == 36 ;    %  2 Cluster (45 deg)
      mdata = randn(d,n) ;
      mdata(:,1:(n/2)) = mdata(:,1:(n/2)) + 1 * ones(d,n/2) ;
      mdata(:,(n/2+1):n) = mdata(:,(n/2+1):n) - 1 * ones(d,n/2) ;
    elseif itest == 37 ;    %  2 Cluster (1 entry)
      mdata = randn(d,n) ;
      mdata(1,1:(n/2)) = mdata(1,1:(n/2)) + 1 * sqrt(100) * ones(1,n/2) ;
      mdata(1,(n/2+1):n) = mdata(1,(n/2+1):n) - 1 * sqrt(100) * ones(1,n/2) ;
    end ;

    %  Get background noise estimate
    %
    npix = d * n ;
    vdata = reshape(mdata,npix,1) ;
        %  all pixel data
    amad = madSM(vdata) ;
        %  MAD, but on sd scale
    sig2b = amad^2 ;    
    vsig2b = [vsig2b; sig2b] ;
    std2 = std(vdata) ;
    vstd2 = [vstd2; std2] ;

    %  Get Sample Eigenvalues
    %
    paramstruct = struct('iscreenwrite',1, ...
                         'viout',[1]) ;
    outstruct = pcaSM(mdata,paramstruct) ;
    veigval = getfield(outstruct,'veigval') ;
    veigval = [veigval; zeros((d - length(veigval)),1)] ;
    mveigval = [mveigval veigval] ;

    %  Run Soft Thresholding
    %
    [veigvest, tau] = SigClustCovEstHH(veigval,sig2b) ;
    vtau = [vtau; tau] ;
    mveigvest = [mveigvest veigvest] ;

  end ;


  %  Make graphics to view results
  %
  figure(1) ;
  clf ; 
  nev = size(mveigvest,1) ;
  subplot(2,1,1) ;
    plot((1:nev)',mveigval,'b-') ;
    hold on ;
      plot((1:nev)',mveigvest,'r-') ;
      title([titstr ' Simulations, Empirical (blue), Thresh (red)']) ;
    hold off ;

  subplot(2,2,3) ;
    plot(vsig2b,vstd2,'go') ;
      title('Estimated variances') ;
      xlabel('MAD based var. est.') ;
      ylabel('sd based var. est.') ;
      vax = axisSM([vsig2b; vstd2]) ;
      axis([vax(1) vax(2) vax(1) vax(2)]) ;
      hold on ;
        plot([vax(1); vax(2)],[vax(1); vax(2)],'m-') ;
      hold off ;

  subplot(2,2,4) ;
    paramstruct = struct('titlestr','Estimated tau values') ;
    kdeSM(vtau,paramstruct) ;




end ;    %  of outer itest if-block



