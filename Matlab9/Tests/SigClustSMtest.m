disp('Running MATLAB script file SigClustSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClustSM,
%    SCATterplot MATrix view of data


itest = 1 ;    %  1,...,42     Simple parameter tests
                %  101          Illustrative examples (not implemented yet)



disp(['    itest = ' num2str(itest)]) ;


if itest < 100 ;    %  Use simple common example for parameter tests

  seed = 39837869 ;
  rng(seed) ;
  mdata = randn(10,20) ;
  mdata = [mdata [(10 * ones(1,20)); zeros(9,20)] + randn(10,20)] ;

  
  %  Make scatterplot matrix illusrating data
  %
  figure(5) ;
  clf ;
  icolor = [(ones(20,1) * [1 0 0]); (ones(20,1) * [0 0 1])] ;
  titlecellstr = {{'Two Cluster Toy Example' ' ' 'For Parameter Checking'}} ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',icolor, ...
                       'isubpopkde',1, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',0) ;
  scatplotSM(mdata,[],paramstruct)


  if itest == 1    %  very simple test

    disp('Test all defaults, simple example') ;
    SigClustSM(mdata) ;


  elseif itest == 2 

    disp(['Test sigbackg set to 0']) ;
    paramstruct = struct('sigbackg',0) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 3 

    disp(['Test sigbackg set to 1, theortical value']) ;
    paramstruct = struct('sigbackg',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 4 

    disp(['Test sigbackg set to 0.5, expect small eigenvalue warning']) ;
    paramstruct = struct('sigbackg',0.5) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 5 

    disp(['Test sigbackg set to 2, expect signal power error']) ;
    paramstruct = struct('sigbackg',2) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 6 

    disp(['Test iCovEst = 1, Hanwen = default']) ;
    paramstruct = struct('iCovEst',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 7 

    disp(['Test iCovEst = 2, Sample Cov']) ;
    paramstruct = struct('iCovEst',2) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 8 

    disp(['Test iCovEst = 3, Original Hard Threshold']) ;
    paramstruct = struct('iCovEst',3) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 9 

    disp(['Test iCovEst = 4, Ming Yuan Soft Threshold']) ;
    paramstruct = struct('iCovEst',4) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 10 

    disp(['Test ipvaltype = 1, Only p-value']) ;
    paramstruct = struct('ipvaltype',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 11

    disp(['Test ipvaltype = 2, Only z-score']) ;
    paramstruct = struct('ipvaltype',2) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 12 

    disp(['Test ipvaltype = 3, Both p-value and Z-score']) ;
    paramstruct = struct('ipvaltype',3) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 13 

    disp(['Test ipvaltype = 0, Bad value, expect default']) ;
    paramstruct = struct('ipvaltype',0) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 14 

    disp(['Test twoMtype = 1, Random Restarts']) ;
    paramstruct = struct('twoMtype',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 15 

    disp(['Test twoMtype = 1, PCA start']) ;
    paramstruct = struct('twoMtype',2) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 16 

    disp(['Test twoMtype = 0, Bad value']) ;
    paramstruct = struct('twoMtype',0) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 17 

    disp(['Test twoMsteps = 10, Clustering Steps']) ;
    paramstruct = struct('twoMsteps',10) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 18 

    disp(['Test nsim = 50']) ;
    paramstruct = struct('nsim',50) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 19 

    disp(['Test nsim = 0, bad value']) ;
    paramstruct = struct('nsim',0) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 20 

    disp(['Only first two output plots']) ;
    paramstruct = struct('twoMtype',1, ...
                         'iBGSDdiagplot',1, ...
                         'iCovEdiagplot',0, ...
                         'ipValplot',0, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 21

    disp(['Bad output plot values']) ;
    paramstruct = struct('twoMtype',1, ...
                         'iBGSDdiagplot',3, ...
                         'iCovEdiagplot',4, ...
                         'ipValplot',5, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 22 

    disp(['Test seeds, random restarts, and reduced output plots']) ;
    paramstruct = struct('twoMtype',1, ...
                         'InitRandseed',12345678, ...
                         'SimRandseed',12345678, ...
                         'iBGSDdiagplot',0, ...
                         'iCovEdiagplot',0, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;

    SigClustSM(mdata,paramstruct) ;


  elseif itest == 23 

    disp(['Test main sim seed and reduced output plots']) ;
    paramstruct = struct('SimRandseed',12345678, ...
                         'iBGSDdiagplot',0, ...
                         'iCovEdiagplot',0, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;

    SigClustSM(mdata,paramstruct) ;


  elseif itest == 24 

    disp(['Test datastr = ''input datastr''']) ;
    paramstruct = struct('datastr','input datastr') ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 25 

    disp(['Test output file saves, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal') ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 26 

    disp(['Test output file saves, savetype = 1, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',1, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 27

    disp(['Test output file saves, savetype = 2, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',2, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 28

    disp(['Test output file saves, savetype = 3, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',3, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 29

    disp(['Test output file saves, savetype = 4, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',4, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 30

    disp(['Test output file saves, savetype = 5, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',5, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 31

    disp(['Test output file saves, savetype = 6, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',6, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 32

    disp(['Test output file saves, savetype = 7, look for output files']) ;
    paramstruct = struct('BGSDsavestr','tempAllPixel', ...
                         'CovEsavestr','tempEstEigVal', ...
                         'pValsavestr','tempPVal', ...
                         'savetype',7, ...
                         'iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 33

    disp(['Test iscreenwrite = 0, no screen writes']) ;
    paramstruct = struct('iscreenwrite',0) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 34

    disp(['Test iscreenwrite = 1, Major Steps']) ;
    paramstruct = struct('iscreenwrite',1) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 35

    disp(['Test iscreenwrite = 2, Most Steps']) ;
    paramstruct = struct('iscreenwrite',2) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 36

    disp(['Test iscreenwrite = 3, All Steps']) ;
    paramstruct = struct('iscreenwrite',3) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 37

    disp(['Test iscreenwrite = 4, Bad Value']) ;
    paramstruct = struct('iscreenwrite',4) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 38

    disp(['Test legend, no input classes']);
    legendcellstr = {{'Testing Best 2-means Split'}} ;
    paramstruct = struct('legendcellstr',legendcellstr) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 39

    disp(['Test legend, with class colors']);
    legendcellstr = {{'Class 1' 'Class 2'}} ;
    mlegendcolor = [[0 1 0]; [1 0 1]] ;
    paramstruct = struct('legendcellstr',legendcellstr, ...
                         'mlegendcolor',mlegendcolor) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 40

    disp(['Test good input vclass']);
    vclass = [ones(1,20) (2 * ones(1,20))] ;
    legendcellstr = {{'Class 1' 'Class 2'}} ;
    mlegendcolor = [[0 1 0]; [1 0 1]] ;
    paramstruct = struct('vclass',vclass, ...
                         'legendcellstr',legendcellstr, ...
                         'mlegendcolor',mlegendcolor) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 41

    disp(['Test very bad input vclass']);
    vclass = [ones(1,10) (2 * ones(1,10)) ones(1,10) (2 * ones(1,10))] ;
    legendcellstr = {{'Class 1' 'Class 2'}} ;
    mlegendcolor = [[0 1 0]; [1 0 1]] ;
    paramstruct = struct('vclass',vclass, ...
                         'legendcellstr',legendcellstr, ...
                         'mlegendcolor',mlegendcolor) ;
    SigClustSM(mdata,paramstruct) ;


  elseif itest == 42

    disp(['Test medium input vclass']);
    k = 2 ;
    vclass = [ones(1,k) (2 * ones(1,k)) ones(1,20 - k) (2 * ones(1,20 - k))] ;
    legendcellstr = {{'Class 1' 'Class 2'}} ;
    mlegendcolor = [[0 1 0]; [1 0 1]] ;
    paramstruct = struct('vclass',vclass, ...
                         'legendcellstr',legendcellstr, ...
                         'mlegendcolor',mlegendcolor) ;
    SigClustSM(mdata,paramstruct) ;




  end    %  of itest if-block


else    %  Explore Illusrative examples




end 
