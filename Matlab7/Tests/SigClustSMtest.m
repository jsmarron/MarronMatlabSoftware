disp('Running MATLAB script file SigClustSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClustSM
%      statistical SIGnificance of CLUSTers

itest = 204 ;     %  1,2,3,3.5 ,4,5,5.5 ,6,7,8,9,10,11,12,13,14,15,16,
                 %       17,17.1,17.2,17.3, 18,19,20,
                 %       21,22,22.1,22.2 ,23,24,25,26,27,28,29,30,31
                 %       101,102,103  
                 %       111,112,113
                 %       121,122,123
                 %       131,132,133
                 %       201,202,203,204


close all ;

if itest == 1 ;    %  Simple Gaussian Spike data, all defaults

  disp('Simple Gaussian Spike data, all defaults') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  SigClustSM(mdata) ;


elseif itest == 2 ;    %  Simple Gaussian Spike data, iscreenwrite set to off

  disp('Simple Gaussian Spike data, iscreenwrite set to off') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iscreenwrite',0) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 3 ;    %  iscreenwrite set to minimal

  disp('iscreenwrite set to minimal') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 3.5 ;    %  iscreenwrite set to in between

  disp('iscreenwrite set to in between') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iscreenwrite',2) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 4 ;    %  iscreenwrite set to maximal

  disp('iscreenwrite set to maximal') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iscreenwrite',3) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 5 ;    %  nsim set to 50, maximal screenwrite

  disp('nsim set to 50, maximal screenwrite') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',3) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 5.5 ;    %  nsim set to 50, in between screenwrite

  disp('nsim set to 50, in between screenwrite') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',2) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 6 ;    %  nsim set to 50, minimal screenwrite

  disp('nsim set to 50, minimal screenwrite') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 7 ;    %  vclass set to 0

  disp('vclass set to 0') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('vclass',0, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 8 ;    %  vclass set to 1s and 2s

  disp('vclass set to 1s and 2s') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('vclass',[ones(1,10) 2*ones(1,10)], ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 9 ;    %  vclass set to 1s and 2s, column vector

  disp('vclass set to 1s and 2s, column vector') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('vclass',[ones(10,1) ; 2*ones(10,1)], ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 10 ;    %  vclass set to 1s and 2s, wrong size

  disp('vclass set to 1s and 2s, wrong size') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('vclass',[ones(1,10) 2*ones(1,11)], ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 11 ;    %  vclass set to 1s and 2s, but have a 3

  disp('vclass set to 1s and 2s, but have a 3') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('vclass',[ones(1,10) 2*ones(1,9) 3], ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 12 ;    %  sigbackg set to 0

  disp('sigbackg set to 0') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('sigbackg',0, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 13 ;    %  sigbackg set to 1

  disp('sigbackg set to 1') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('sigbackg',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 14 ;    %  sigbackg set to 0.1

  disp('sigbackg set to 0.1') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('sigbackg',0.1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 15 ;    %  sigbackg set to 10

  disp('sigbackg set to 10') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('sigbackg',10, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 16 ;    %  check single numerical output

  disp('check single numerical output') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',1) ;
  pvalQ = SigClustSM(mdata,paramstruct) 


elseif itest == 17 ;    %  check double numerical output

  disp('check double numerical output') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',1) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 17.1 ;    %  check Empirical p only

  disp('check Empirical p only') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('ipvaltype',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 17.2 ;    %  check Z score only

  disp('check Z score only') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('ipvaltype',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 17.3 ;    %  check explicitly both p-val & Z Score

  disp('check explicitly both p-val & Z Score') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('ipvaltype',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 18 ;    %  check effect of not specifying seeds

  disp('check effect of not specifying seeds') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  disp(' ') ;
  disp('Testing unspecified seeds') ;
  disp(' ') ;
  disp('1st call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 

  disp(' ') ;
  disp('2nd call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 19 ;    %  check effect of specifying seeds

  disp('check effect of specifying seeds') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  disp(' ') ;
  disp('Testing chosen seeds') ;
  disp(' ') ;
  disp('1st call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 

  disp(' ') ;
  disp('2nd call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 20 ;    %  check effect of specifying seeds, specify PCA starts

  disp('check effect of specifying seeds, specify PCA starts') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  disp(' ') ;
  disp('Testing chosen seeds') ;
  disp(' ') ;
  disp('1st call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('twoMtype',2, ...
                       'InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 

  disp(' ') ;
  disp('2nd call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('twoMtype',2, ...
                       'InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 21 ;    %  check effect of specifying seeds, specify random starts

  disp('check effect of specifying seeds, specify random starts') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  disp(' ') ;
  disp('Testing chosen seeds') ;
  disp(' ') ;
  disp('1st call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('twoMtype',1, ...
                       'InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 

  disp(' ') ;
  disp('2nd call to SigClustSM.m') ;
  disp(' ') ;
  paramstruct = struct('twoMtype',1, ...
                       'InitRandstate',4759357, ...
                       'InitRandnstate',8934774, ...
                       'SimRandstate',7924729474, ...
                       'SimRandnstate',62896144, ...
                       'nsim',50, ...
                       'iscreenwrite',0) ;
  [pvalQ,pvalZ] = SigClustSM(mdata,paramstruct) 


elseif itest == 22 ;    %  test datastr

  disp('test datastr') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'datastr','Simulated Gaussian spike data', ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 22.1 ;    %  test datastr & Empirical p only

  disp('test datastr & Empirical p only') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('ipvaltype',1, ...
                       'nsim',50, ...
                       'datastr','Simulated Gaussian spike data', ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 22.2 ;    %  test datastr & Z Score only

  disp('test datastr & Z Score only') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('ipvaltype',2, ...
                       'nsim',50, ...
                       'datastr','Simulated Gaussian spike data', ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 23 ;    %  turn graphics off

  disp('turn graphics off') ;

  close all ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'iBGSDdiagplot',0, ...
                       'iCovEdiagplot',0, ...
                       'ipValplot',0, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 24 ;    %  check graphics file save

  disp('check graphics file save') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'datastr','Simulated Gaussian spike data', ...
                       'BGSDsavestr','TempAllPixel', ...
                       'CovEsavestr','TempEstEigVal', ...
                       'pValsavestr','TempPval', ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;

  disp('Check for files:    temp___.ps,      then delete') ;


elseif itest == 25 ;    %  test twoMsteps, for twoMtype = 1

  disp('test twoMsteps, for twoMtype = 1') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('twoMtype',1, ...
                       'twoMsteps',3, ...
                       'nsim',5, ...
                       'iscreenwrite',3) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 26 ;    %  test twoMsteps, for twoMtype = 2

  disp('test twoMsteps, for twoMtype = 2') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('twoMtype',2, ...
                       'twoMsteps',3, ...
                       'nsim',5, ...
                       'iscreenwrite',3) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 27 ;    %  test simple legend

  disp('test simple legend') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'legendcellstr',{{'Testing Best 2-means Split'}}, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 28 ;    %  test more complicated legend

  disp('test more complicated legend') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('nsim',50, ...
                       'legendcellstr',{{'Class 1' 'vs.' 'Class 2'}}, ...
                       'mlegendcolor',[[1 0 0]; [0 0 0]; [0 0 1]], ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 29 ;    %  test default covariance estimation

  disp('test default covariance estimation') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iCovEst',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 30 ;    %  test crude empirical covariance estimation

  disp('test crude empirical (sample eigenvalue) covariance estimation') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iCovEst',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 31 ;    %  test old covariance estimation

  disp('test old (Hard Thresholded) covariance estimation') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;

  SigClustSM(mdata,paramstruct) ;


elseif itest == 32 ;    %  test old covariance estimation

  disp('test original Ming Yuan (Soft Thresholded) covariance estimation') ;

  randn('state',265342034687) ;
  d = 5 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = 10 * mdata(1,:) ;

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 101 ;    %  try higher dimensional problem, good covariance

  disp('try higher dimensional problem, good covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 10 * mdata(1:10,:) ;

  paramstruct = struct('iCovEst',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 102 ;    %  try higher dimensional problem, sample covariance

  disp('try higher dimensional problem, sample covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 10 * mdata(1:10,:) ;

  paramstruct = struct('iCovEst',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 103 ;    %  try higher dimensional problem, old covariance

  disp('try higher dimensional problem, old covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 10 * mdata(1:10,:) ;

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 111 ;    %  try higher dimensional clusters, good covariance

  disp('try higher dimensional clusters, good covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 4 * mdata(1:10,:) ;
  mdata(11:21,1:(n/2)) = 3 + mdata(11:21,1:(n/2)) ;
  mdata(11:21,(n/2)+1:n) = -3 + mdata(11:21,(n/2)+1:n) ;

  paramstruct = struct('iCovEst',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 112 ;    %  try higher dimensional clusters, sample covariance

  disp('try higher dimensional clusters, sample covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 4 * mdata(1:10,:) ;
  mdata(11:21,1:(n/2)) = 3 + mdata(11:21,1:(n/2)) ;
  mdata(11:21,(n/2)+1:n) = -3 + mdata(11:21,(n/2)+1:n) ;

  paramstruct = struct('iCovEst',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 113 ;    %  try higher dimensional clusters, old covariance

  disp('try higher dimensional clusters, old covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 40 ;
  mdata = randn(d,n) ; 
  mdata(1:10,:) = 4 * mdata(1:10,:) ;
  mdata(11:21,1:(n/2)) = 3 + mdata(11:21,1:(n/2)) ;
  mdata(11:21,(n/2)+1:n) = -3 + mdata(11:21,(n/2)+1:n) ;

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 121 ;    %  create deliberate error, good covariance

  disp('create deliberate error, good covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata = mdata + 2 * mflip ;
      % shift a random half of the entries to the right
  mdata = mdata - 2 * (1 - mflip) ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 122 ;    %  create deliberate error, sample covariance

  disp('create deliberate error, sample covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata = mdata + 2 * mflip ;
      % shift a random half of the entries to the right
  mdata = mdata - 2 * (1 - mflip) ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 123 ;    %  create deliberate error, old covariance

  disp('create deliberate error, old covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata = mdata + 2 * mflip ;
      % shift a random half of the entries to the right
  mdata = mdata - 2 * (1 - mflip) ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 131 ;    %  shift cluster, good covariance

  disp('shift cluster, good covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata(:,1:n/2) = mdata(:,1:n/2) + 2 ;
      % shift a systemtic half of the entries to the right
  mdata(:,n/2+1:n) = mdata(:,n/2+1:n) - 2 ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',1, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 132 ;    %  shift cluster, sample covariance

  disp('shift cluster, sample covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata = mdata + 2 * mflip ;
      % shift a random half of the entries to the right
  mdata = mdata - 2 * (1 - mflip) ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',2, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 133 ;    %  shift cluster, old covariance

  disp('shift cluster, old covariance') ;

  randn('state',265342034687) ;
  d = 200 ;
  n = 20 ;
  mdata = randn(d,n) ; 
  mflip = randn(d,n) > 0 ;
      %  ones at random locations
  mdata = mdata + 2 * mflip ;
      % shift a random half of the entries to the right
  mdata = mdata - 2 * (1 - mflip) ;
      % shift the other half to the left

  paramstruct = struct('iCovEst',3, ...
                       'nsim',50, ...
                       'iscreenwrite',1) ;
  SigClustSM(mdata,paramstruct) ;


elseif itest == 201 ;    %  Explore anti-conservatism of Hard (Gaussian Big Single Spike)

  disp('Explore anti-conservatism of Hard (Gaussian Big Single Spike)') ;

  randn('state',8797685) ; 
  d = 1000 ;
  n = 100 ;
  mdata = randn(d,n) ; 
  mdata(1,:) = sqrt(200) * mdata(1,:) ;

  disp(' ') ;
  disp('    iCovEst = 1, Default (Soft)') ;
  paramstruct = struct('iCovEst',1, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 2, Sample') ;
  paramstruct = struct('iCovEst',2, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 3, Hard') ;
  paramstruct = struct('iCovEst',3, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 4, Old Soft') ;
  paramstruct = struct('iCovEst',4, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;


elseif itest == 202 ;    %  Explore anti-conservatism of Old Soft(Gaussian Small Spike)

  disp('Explore anti-conservatism of Old Soft (Gaussian Small Spike)') ;

  randn('state',8797685) ; 
  d = 1000 ;
  n = 100 ;
  mdata = randn(d,n) ; 
  mdata(1:2,:) = sqrt(10) * mdata(1:2,:) ;

  disp(' ') ;
  disp('    iCovEst = 1, Default (Soft)') ;
  paramstruct = struct('iCovEst',1, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 2, Sample') ;
  paramstruct = struct('iCovEst',2, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 3, Hard') ;
  paramstruct = struct('iCovEst',3, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 4, Old Soft') ;
  paramstruct = struct('iCovEst',4, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;


elseif itest == 203 ;    %  Explore Power for 2 Gaussian Clusters

  disp('Explore Power for 2 Gaussian Clusters') ;

  randn('state',8797685) ; 
  d = 1000 ;
  n = 100 ;
  mdata = randn(d,n) ; 
  mdata(1,1:50) = 10 + mdata(1,1:50) ;

  disp(' ') ;
  disp('    iCovEst = 1, Default (Soft)') ;
  paramstruct = struct('iCovEst',1, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 2, Sample') ;
  paramstruct = struct('iCovEst',2, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 3, Hard') ;
  paramstruct = struct('iCovEst',3, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 4, Old Soft') ;
  paramstruct = struct('iCovEst',4, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;


elseif itest == 204 ;    %  Explore Power for 2 Gaussian Clusters (45 deg shift)

  disp('Explore Power for 2 Gaussian Clusters') ;

  randn('state',8797685) ; 
  d = 1000 ;
  n = 100 ;
  mdata = randn(d,n) ;
  mdata(:,1:(n/2)) = mdata(:,1:(n/2)) + 1 * ones(d,n/2) ;
  mdata(:,(n/2+1):n) = mdata(:,(n/2+1):n) - 1 * ones(d,n/2) ;


  disp(' ') ;
  disp('    iCovEst = 1, Default (Soft)') ;
  paramstruct = struct('iCovEst',1, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 2, Sample') ;
  paramstruct = struct('iCovEst',2, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 3, Hard') ;
  paramstruct = struct('iCovEst',3, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;
  pauseSM ;

  disp(' ') ;
  disp('    iCovEst = 4, Old Soft') ;
  paramstruct = struct('iCovEst',4, ...
                       'nsim',100, ...
                       'iscreenwrite',0) ;
  [pval,zscore] = SigClustSM(mdata,paramstruct) ;
  disp(['p-value = ' num2str(pval) '    Z-score = ' num2str(zscore)]) ;


end ;



