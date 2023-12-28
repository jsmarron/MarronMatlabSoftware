disp('Running MATLAB script file SWISSoriCCtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SWISSoriCC,
%    original version of SWISS (from PLoS paper), 
%    Standardized WithIn class Sum of Squares


itest = 9 ;     %  0,...,9



d = 10 ;
rng(10948571) ;
mdata = [randn(d,90)] ;
mdata1 = mdata ;
mdata1(1,31:60) = mdata1(1,31:60) + 3 ;
mdata1(2,31:60) = mdata1(2,31:60) + 4 ;
mdata1(1,61:90) = mdata1(1,61:90) + 3 ;
mdata1(2,61:90) = mdata1(2,61:90) - 4 ;

mdata2 = mdata ;
mdata2(1,31:60) = mdata2(1,31:60) + 2 ;
mdata2(2,31:60) = mdata2(2,31:60) + 3 ;
mdata2(1,61:90) = mdata2(1,61:90) + 2 ;
mdata2(2,61:90) = mdata2(2,61:90) - 3 ;

groups = [ones(30,1); 2 * ones(30,1); 3 * ones(30,1)] ;

mcolor = ones(30,1) * [1 0 1] ;
mcolor = [mcolor; (ones(30,1) * [0 0.8 0.8])] ;
mcolor = [mcolor; (ones(30,1) * [0.5 0.5 0])] ;




if itest == 0 ;

  disp('Check Generic Input Data Clustering') ;

  figure(1) ;
  clf ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',mcolor, ...
                       'titlecellstr',{{'Test Data Set 1'}}) ;
  scatplotSM(mdata1,[],paramstruct) ;

  figure(2) ;
  clf ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',mcolor, ...
                       'titlecellstr',{{'Test Data Set 2' 'Slightly Less Spread'}}) ;
  scatplotSM(mdata2,[],paramstruct) ;


elseif itest == 1 ;      

  disp('Check input of only single data set (and group labels),') 
  disp('             with output of teststat') ;

  disp('    For mdata1:') ;
  teststat = SWISSoriCC(mdata1,[],groups) ;
  teststat

  disp('    For mdata2 (Slightly Less Spread):') ;
  teststat = SWISSoriCC(mdata2,[],groups) ;
  teststat


elseif itest == 2 ;      

  disp('Check input of only both data sets (and group labels)') 
  disp('             with output of teststat') ;

  figure(3) ;
  clf ;
  teststat = SWISSoriCC(mdata1,mdata2,groups) ;
  teststat


elseif itest == 3 ;      

  disp('Check input of only both data sets (and group labels)') 
  disp('             with output of teststat, epval, ci') ;

  figure(3) ;
  clf ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups) ;
  teststat
  epval
  ci


elseif itest == 4 ;      

  disp('Check input of only two copies of mdata1 (and group labels)') 
  disp('             with output of teststat, epval, ci') ;

  figure(3) ;
  clf ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata1 + randn(d,90) * 10^-5,groups) ;
  teststat
  epval
  ci


elseif itest == 5 ;      

  disp('Check error for input of mdata1 only') 

  SWISSoriCC(mdata1) ;


elseif itest == 6 ;      

  disp('Check error for input of mdata1 and mdata2 only') 

  SWISSoriCC(mdata1,mdata2) ;


elseif itest == 7 ;

  disp('Check paramstruct: "option"') 

  mdata1d = mdata1(:,29:end) ;
  figure(3) ;
  clf ;
  paramstruct = struct('npcadiradd',2, ...
                       'icolor',mcolor(29:end,:), ...
                       'titlecellstr',{{'DecimatedTest Data Set 1'}}) ;
  scatplotSM(mdata1d,[],paramstruct) ;

  disp('    For Decimated Data1, default:')
  teststat = SWISSoriCC(mdata1d,[],groups) ;
  teststat

  disp('    For Decimated Data1, option = 1:')
  paramstruct = struct('option',1) ;
  teststat = SWISSoriCC(mdata1d,[],groups,paramstruct) ;
  teststat

  disp('    For Decimated Data1, option = 2:')
  paramstruct = struct('option',2) ;
  teststat = SWISSoriCC(mdata1d,[],groups,paramstruct) ;
  teststat


elseif itest == 8 ;

  disp('Check paramstruct: "nsim"') 

  disp('    For Decimated Data1, default:')
  figure(3) ;
  clf ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups) ;
  teststat
  ci

  disp('    For Decimated Data1, nsim = 1000:')
  figure(4) ;
  clf ;
  paramstruct = struct('nsim',1000) ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups,paramstruct) ;
  teststat
  ci

  disp('    For Decimated Data1, nsim = 5:')
  figure(5) ;
  clf ;
  paramstruct = struct('nsim',5) ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups,paramstruct) ;
  teststat
  ci


elseif itest == 9 ;

  disp('Check paramstruct: "curve"') 

  disp('Set Curve = 0:')
  figure(3) ;
  clf ;
  paramstruct = struct('curve',0) ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups,paramstruct) ;

  disp('Set Curve = 1:')
  figure(4) ;
  clf ;
  paramstruct = struct('curve',1) ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups,paramstruct) ;

  disp('Set Curve = 2:')
  figure(5) ;
  clf ;
  paramstruct = struct('curve',2) ;
  [teststat,epval,ci] = SWISSoriCC(mdata1,mdata2,groups,paramstruct) ;



end ;

