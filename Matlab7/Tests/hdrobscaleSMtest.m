disp('Running MATLAB script file hdrobscaleSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION hdrobscaleSM,
%    High Dimensional data ROBust reSCAling

itest = 12 ;     %  1,2,3,4,5,6,7,8,9,10,11,12


format compact ;



disp(['Test Number ' num2str(itest)]) ;


if itest == 1 ;  

  disp('  Check Defaults') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = rand(3,2) 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 

  disp('      Just 1:') ;
  mout1 = hdrobscaleSM(mdat) 


elseif itest == 2 ;   

  disp('  Check Parameters') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = rand(3,2) 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 

  disp('      Just 1:') ;
  mout1 = hdrobscaleSM(mdat,1) 

  disp('      Just 2:') ;
  mout2 = hdrobscaleSM(mdat,2) 

  disp('      Just 3:') ;
  mout3 = hdrobscaleSM(mdat,3) 


elseif itest == 3 ;   

  disp('  Check d = 1 Case') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = rand(1,2) 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 

  disp('      Just 1:') ;
  mout1 = hdrobscaleSM(mdat,1) 

  disp('      Just 2:') ;
  mout2 = hdrobscaleSM(mdat,2) 

  disp('      Just 3:') ;
  mout3 = hdrobscaleSM(mdat,3) 


elseif itest == 4 ;   

  disp('  Check some constant parts') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = [rand(1,3); ...
          [2, 2, 2]; ...
          rand(1,3); ...
          [0, 0, 0]] 
  
  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 

  disp('      Just 1:') ;
  mout1 = hdrobscaleSM(mdat,1) 

  disp('      Just 2:') ;
  mout2 = hdrobscaleSM(mdat,2) 

  disp('      Just 3:') ;
  mout3 = hdrobscaleSM(mdat,3) 


elseif itest == 5 ;   

  disp('  Check only one data vector') ;

  mdat = 27 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 


  mdat = [5;7]

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 


elseif itest == 6 ;   

  disp('  Check all zero variances') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = vec2matSM(rand(5,1),3) 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 


elseif itest == 7 ;   

  disp('  Check all components same') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = vec2matSM(rand(1,5),4) 

  disp('      All 3:') ;
  [mout1, mout2, mout3] = hdrobscaleSM(mdat) 


elseif itest == 8 ;   

  disp('  Check parametrizations') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = rand(4,5) 

  [mout1, mout2, mout3] = hdrobscaleSM(mdat,2) 

  mout1 = hdrobscaleSM(mdat,1) 

  mout1 = hdrobscaleSM(mdat,0) 


elseif itest == 9 ;   

  disp('  Check lengths for sphered') ;

  seed = 29487503 ;
  rand('seed',seed) ;
  mdat = rand(5,2) 

  mout2 = hdrobscaleSM(mdat,2) ;

  norm(mout2(:,1))
  norm(mout2(:,1))


elseif itest == 10 ;   

  disp('  Do some graphical tests, Ellipsed') ;

  seed = 29487503 ;
  randn('seed',seed) ;


  subplot(2,2,1) ;
    mdat = randn(2,20) ;
    mout2 = hdrobscaleSM(mdat) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-3,3,-3,3]) ;
      title('Elliptical') ;


  subplot(2,2,2) ;
    mdat = randn(2,20) ;
    mdat = mdat - vec2matSM([-2;2],20) ;
    mout2 = hdrobscaleSM(mdat) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo', ...
         mean(mdat(1,:)),mean(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Elliptical') ;


  subplot(2,2,3) ;
    mdat = randn(2,20) ;
    mdat(1,:) = 2 * mdat(1,:) ;
    mdat(2,:) = .5 * mdat(2,:) ;
    mout2 = hdrobscaleSM(mdat) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Elliptical') ;


  subplot(2,2,4) ;
    mdat = randn(2,20) ;
    mdat(1,:) = .2 * mdat(1,:) - 3.5 ;
    mdat(2,:) = 2 * mdat(2,:) ;
    mdat = [mdat, [3.9; 0]] ;
    mout2 = hdrobscaleSM(mdat) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo', ...
         mean(mdat(1,:)),mean(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Elliptical') ;


elseif itest == 11 ;   

  disp('  Do some graphical tests, sphered') ;

  seed = 29487503 ;
  randn('seed',seed) ;


  subplot(2,2,1) ;
    mdat = randn(2,20) ;
    mout2 = hdrobscaleSM(mdat,2) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-3,3,-3,3]) ;
      title('Spherical') ;


  subplot(2,2,2) ;
    mdat = randn(2,20) ;
    mdat = mdat - vec2matSM([-2;2],20) ;
    mout2 = hdrobscaleSM(mdat,2) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo', ...
         mean(mdat(1,:)),mean(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Spherical') ;


  subplot(2,2,3) ;
    mdat = randn(2,20) ;
    mdat(1,:) = 2 * mdat(1,:) ;
    mdat(2,:) = .5 * mdat(2,:) ;
    mout2 = hdrobscaleSM(mdat,2) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Spherical') ;


  subplot(2,2,4) ;
    mdat = randn(2,20) ;
    mdat(1,:) = .2 * mdat(1,:) - 3.5 ;
    mdat(2,:) = 2 * mdat(2,:) ;
    mdat = [mdat, [3.9; 0]] ;
    mout2 = hdrobscaleSM(mdat,2) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo', ...
         mean(mdat(1,:)),mean(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('Spherical') ;


elseif itest == 12 ;   

  disp('  Do some graphical tests, MAD rescaled') ;

  seed = 29487503 ;
  randn('seed',seed) ;


  subplot(2,2,1) ;
    mdat = randn(2,20) ;
    mout2 = hdrobscaleSM(mdat,3) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-3,3,-3,3]) ;
      title('MAD rescaled') ;


  subplot(2,2,2) ;
    mdat = randn(2,20) ;
    mdat = mdat - vec2matSM([-2;2],20) ;
    mout2 = hdrobscaleSM(mdat,3) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo', ...
         median(mdat(1,:)),median(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('MAD rescaled') ;


  subplot(2,2,3) ;
    mdat = randn(2,20) ;
    mdat(1,:) = 2 * mdat(1,:) ;
    mdat(2,:) = .5 * mdat(2,:) ;
    mout2 = hdrobscaleSM(mdat,3) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'bo') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('MAD rescaled') ;


  subplot(2,2,4) ;
    mdat = randn(2,20) ;
    mdat(1,:) = .2 * mdat(1,:) - 3.5 ;
    mdat(2,:) = 2 * mdat(2,:) ;
    mdat = [mdat, [3.9; 0]] ;
    mout2 = hdrobscaleSM(mdat,3) ;

    plot(mdat(1,:),mdat(2,:),'r+', ...
         mout2(1,:),mout2(2,:),'co', ...
         median(mdat(1,:)),median(mdat(2,:)),'bs') ;
      axis('square') ;
      axis([-4,4,-4,4]) ;
      title('MAD rescaled') ;


end ;



