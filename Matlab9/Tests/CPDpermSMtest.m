disp('Running MATLAB script file CPDpermSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION CPDpermSM,
%    Caonical Parallel Direction PERMutation test

itest = 106 ;     %  1,...,29    paramter tests
                 %  101    Toy Example, 10 x 100
                 %  102    Stretched Example, 10 x 100
                 %  103    Standard Normal, 10 x 100
                 %  104    Standard Normal, 100 x 500
                 %  105    50-50 Strong Mixture, 40 x 200
                 %  106    50-50 Weak Mixture, 40 x 200


if itest == 1 ;
  teststr = 'Complete Defaults with Simple Example Data' ;
  idata = 1 ;
elseif itest == 2 ;
  teststr = 'Test nsim = 100' ;
  paramstruct = struct('nsim',100) ;
  idata = 1 ;
elseif itest == 3 ;
  teststr = 'Test nsim = 100, nreport = 0' ;
  paramstruct = struct('nsim',100, ...
                       'nreport',0) ;
  idata = 1 ;
elseif itest == 4 ;
  teststr = 'Test nsim = 100, nreport = 10' ;
  paramstruct = struct('nsim',100, ...
                       'nreport',10) ;
  idata = 1 ;
elseif itest == 5 ;
  teststr = 'Test nsim = 100, nreport = 10, and iscreenwrite = 1' ;
  paramstruct = struct('nsim',100, ...
                       'nreport',10, ...
                       'iscreenwrite',1) ;
  idata = 1 ;
elseif itest == 6 ;
  teststr = 'Test nsim = 1000, nreport = 100' ;
  paramstruct = struct('nsim',1000, ...
                       'nreport',100, ...
                       'iscreenwrite',1) ;
  idata = 1 ;
elseif itest == 7 ;
  teststr = 'Test manually input seed' ;
  paramstruct = struct('nsim',1000, ...
                       'nreport',100, ...
                       'seed',29384798, ...
                       'iscreenwrite',1) ;
  idata = 1 ;
elseif itest == 8 ;
  teststr = 'Test ishowperm = 0' ;
  paramstruct = struct('ishowperm',0) ;
  idata = 1 ;
elseif itest == 9 ;
  teststr = 'Test ishowperm = 1' ;
  paramstruct = struct('ishowperm',1) ;
  idata = 1 ;
elseif itest == 10 ;
  teststr = 'Test ishowperm = 2' ;
  paramstruct = struct('ishowperm',2) ;
  idata = 1 ;
elseif itest == 11 ;
  teststr = 'icolor = 0' ;
  paramstruct = struct('icolor',0) ;
  idata = 1 ;
elseif itest == 12 ;
  teststr = 'icolor = 1' ;
  paramstruct = struct('icolor',1) ;
  idata = 1 ;
elseif itest == 13 ;
  teststr = 'manually set icolor' ;
  paramstruct = struct('icolor',[[1 0 1]; [0 1 0]]) ;
  idata = 1 ;
elseif itest == 14 ;
  teststr = 'statstrcol set to blue' ;
  paramstruct = struct('statstrcol','b') ;
  idata = 1 ;
elseif itest == 15 ;
  teststr = 'statstrcol set to gray' ;
  paramstruct = struct('statstrcol',[0.5 0.5 0.5]) ;
  idata = 1 ;
elseif itest == 16 ;
  teststr = 'Set markerstr to single diamond' ;
  paramstruct = struct('markerstr','d') ;
  idata = 1 ;
elseif itest == 17 ;
  teststr = 'Set markerstr to star and square' ;
  paramstruct = struct('markerstr',['*'; 's']) ;
  idata = 1 ;
elseif itest == 18 ;
  teststr = 'ipval = 1, pvalue & PDC' ;
  paramstruct = struct('ipval',1) ;
  idata = 1 ;
elseif itest == 19 ;
  teststr = 'ipval = 2, pvalue only' ;
  paramstruct = struct('ipval',2) ;
  idata = 1 ;
  idata = 1 ;
elseif itest == 20 ;
  teststr = 'ipval = 3, PDC only' ;
  paramstruct = struct('ipval',3) ;
  idata = 1 ;
elseif itest == 21 ;
  teststr = 'ibigdot = 1' ;
  paramstruct = struct('ibigdot',1) ;
  idata = 1 ;
elseif itest == 22 ;
  teststr = 'Wide data overlay range' ;
  paramstruct = struct('datovlaymax',0.8, ...
                       'datovlaymin',0.2) ;
  idata = 1 ;
elseif itest == 23 ;
  teststr = 'Test Legend' ;
  paramstruct = struct('legendcellstr',{{'Data1' 'Data2'}}) ;
  idata = 1 ;
elseif itest == 24 ;
  teststr = 'Test Different titles' ;
  paramstruct = struct('title1str','Test Title 1', ...
                       'title2str','Test Title 2') ;
  idata = 1 ;
elseif itest == 25 ;
  teststr = 'Small Title & Lable Font Sizes' ;
  paramstruct = struct('titlefontsize',8, ...
                       'labelfontsize',4) ;
  idata = 1 ;
elseif itest == 26 ;
  teststr = 'Test manual axis labels' ;
  paramstruct = struct('xlabel1str','Test X1 label', ...
                       'ylabel1str','Test Y1 label', ...
                       'xlabel2str','Test X2 label', ...
                       'ylabel2str','Test Y2 label') ;
  idata = 1 ;
elseif itest == 27 ;
  teststr = 'Test File Save, Check for file CPDpermSMtest.png' ;
  paramstruct = struct('savestr','CPDpermSMtest', ...
                       'savetype',2) ;
  idata = 1 ;
elseif itest == 28 ;
  teststr = 'Test Many things at once' ;
  paramstruct = struct('nsim',100, ...
                       'nreport',10, ...
                       'seed',29384798, ...
                       'ishowperm',2, ...
                       'icolor',[[1 0 1]; [0 1 0]], ...
                       'statstrcol','b', ...
                       'markerstr',['*'; 's'], ...
                       'ipval',3, ...
                       'ibigdot',1, ...
                       'datovlaymax',0.8, ...
                       'datovlaymin',0.2, ...
                       'legendcellstr',{{'Data1' 'Data2'}}, ...
                       'title1str','Test Title 1', ...
                       'title2str','Test Title 2', ...
                       'titlefontsize',6, ...
                       'labelfontsize',4, ...
                       'xlabel1str','Test X1 label', ...
                       'ylabel1str','Test Y1 label', ...
                       'xlabel2str','Test X2 label', ...
                       'ylabel2str','Test Y2 label', ...
                       'iscreenwrite',1) ;
  idata = 1 ;
elseif itest == 29 ;
  teststr = 'Wrong Size Data, n = 20, d = 30, Check for Error Message' ;
  paramstruct = struct('nsim',100) ;
  idata = 2 ;
elseif itest == 30 ;
  teststr = '' ;
  idata = 1 ;




elseif itest == 101 ;
  teststr = '' ;
  teststr = 'Toy Example, 10 x 100' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','Toy Example, 10 x 100', ...
                       'iscreenwrite',1) ;
  idata = 1 ;
elseif itest == 102 ;
  teststr = 'Stretched Example, 10 x 100' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','Stretched Example, 10 x 100', ...
                       'iscreenwrite',1) ;
  idata = 3 ;
elseif itest == 103 ;
  teststr = 'Standard Normal, 10 x 100' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','Standard Normal, 10 x 100', ...
                       'iscreenwrite',1) ;
  idata = 4 ;
elseif itest == 104 ;
  teststr = 'Standard Normal, 100 x 500' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','Standard Normal, 100 x 500', ...
                       'iscreenwrite',1) ;
  idata = 5 ;
elseif itest == 105 ;
  teststr = '50-50 Strong Mixture, 40 x 200' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','50-50 Strong Mixture, 40 x 200', ...
                       'iscreenwrite',1) ;
  idata = 6 ;
elseif itest == 106 ;
  teststr = '50-50 Weak Mixture, 40 x 200' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','50-50 Weak Mixture, 40 x 200', ...
                       'iscreenwrite',1) ;
  idata = 7 ;
elseif itest == 107 ;
  teststr = '' ;
  paramstruct = struct('ishowperm',2, ...
                       'title1str','', ...
                       'iscreenwrite',1) ;
  idata = 1 ;


end


rng(74093987) ;
    %  Seed for random number generation

if idata == 1     %  Simple Example Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = ones(d,n) + randn(d,n) ;

elseif idata == 2     %  Wrong Size Data

  n = 20 ;
  d = 30 ;
  mX = randn(d,n) ;
  mY = 100 * ones(d,n) + randn(d,n) ;

elseif idata == 3     %  Stretched Example Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = 100 * ones(d,n) + randn(d,n) ;

elseif idata == 4     %  Standard Normal Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = randn(d,n) ;

elseif idata == 5     %  Bigger Standard Normal Data

  n = 100 ;
  d = 500 ;
  mX = randn(d,n) ;
  mY = randn(d,n) ;

elseif idata == 6     %  50-50 Strong Mixture

  n = 40 ;
  d = 200 ;
  mX = [(ones(d,n/2) + randn(d,n/2)) (-ones(d,n/2) + randn(d,n/2))] ;
  mY = [(-ones(d,n/2) + randn(d,n/2)) (ones(d,n/2) + randn(d,n/2))] ;

elseif idata == 7     %  50-50 Weak Mixture

  n = 40 ;
  d = 200 ;
  mu = 0.12 ;
  mX = [(mu * ones(d,n/2) + randn(d,n/2)) ...
            (mu * -ones(d,n/2) + randn(d,n/2))] ;
  mY = [(mu * -ones(d,n/2) + randn(d,n/2)) ...
            (mu * ones(d,n/2) + randn(d,n/2))] ;



                 %  106    50-50 Weak Mixture, 40 x 200


end


disp(teststr) ;
figure(1) ;
clf ;

if itest == 1 ;    %  Complete defaults

  CPDpermSM(mX,mY) ;

elseif itest < 100

  CPDpermSM(mX,mY,paramstruct) ;

else

  %  First make PCA scatterplot of input data
  %
  disp(' ') ;
  disp('First View (Connected) Input Data')
  icolor = [ones(n,1) * [1 0 0] ; ...
            ones(n,1) * [0 0 1]] ;
  titlecellstr = {{['CPDperm Test ' num2str(itest)] 'Input Data PCA' teststr}} ;
  paramstructpca = struct('npcadiradd',3, ...
                       'icolor',icolor, ...
                       'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',0) ;
  scatplotSM([mX mY],[],paramstructpca) ;   

  %  Next do CPDperm
  %
  disp(' ') ;
  disp('Next run CPDperm')
  figure(2) ;
  clf ;
  CPDpermSM(mX,mY,paramstruct) ;


end





