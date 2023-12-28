disp('Running MATLAB script file SWISSpwCCtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SWISSpwCC,
%    Multiclass PairWise version of SWISS, Standardized WithIn class Sum of Squares


itest = 4 ;     %  0,...,4



d = 10 ;
rng(10948571) ;
mdata = [randn(d,90)] ;
mdata1 = mdata ;
mdata1(1,31:60) = mdata1(1,31:60) + 3 ;
mdata1(2,31:60) = mdata1(2,31:60) + 4 ;
mdata1(1,61:90) = mdata1(1,61:90) + 3 ;
mdata1(2,61:90) = mdata1(2,61:90) - 4 ;

mdata2 = mdata ;
mdata2(1,31:60) = mdata2(1,31:60) + 1 ;
mdata2(2,31:60) = mdata2(2,31:60) + 2 ;
mdata2(1,61:90) = mdata2(1,61:90) + 1 ;
mdata2(2,61:90) = mdata2(2,61:90) - 2 ;

mdata3 = mdata ;
mdata3(1,31:60) = mdata3(1,31:60) + 0.8 ;
mdata3(2,31:60) = mdata3(2,31:60) + 1.8 ;
mdata3(1,61:90) = mdata3(1,61:90) + 0.0 ;
mdata3(2,61:90) = mdata3(2,61:90) - 1.8 ;

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
                       'titlecellstr',{{'Test Data Set 2'}}) ;
  scatplotSM(mdata2,[],paramstruct) ;

  figure(3) ;
  clf ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',mcolor, ...
                       'titlecellstr',{{'Test Data Set 3'}}) ;
  scatplotSM(mdata3,[],paramstruct) ;


elseif itest == 1 ;      

  disp('Compare scores for these data sets') ;

  disp('    For mdata1:') ;
  SWISSscore = SWISSpwCC(mdata1,groups) ;
  SWISSscore
  figure(1) ;
  subplot(3,3,2) ;
  title(['SWISS score = ' num2str(SWISSscore)]) ; ;

  disp('    For mdata2:') ;
  SWISSscore = SWISSpwCC(mdata2,groups) ;
  SWISSscore
  figure(2) ;
  subplot(3,3,2) ;
  title(['SWISS score = ' num2str(SWISSscore)]) ; ;

  disp('    For mdata3:') ;
  SWISSscore = SWISSpwCC(mdata3,groups) ;
  SWISSscore
  figure(3) ;
  subplot(3,3,2) ;
  title(['SWISS score = ' num2str(SWISSscore)]) ; ;


elseif itest == 2 ;      

  disp('Check error for input of mdata only') 

  SWISSscore = SWISSpwCC(mdata1) ;
  SWISSscore


elseif itest == 3 ;

  disp('Check error for invalid groups') 

  groups1 = [[1 2]; [1 3]] 
  SWISSscore = SWISSpwCC(mdata1,groups1) ;
  SWISSscore

  groups2 = groups(1:20) 
  groups2'
  SWISSscore = SWISSpwCC(mdata1,groups2) ;
  SWISSscore

  groups3 = groups ;
  groups3(1:30) = 4 * ones(30,1) ;
  groups3' 
  SWISSscore = SWISSpwCC(mdata1,groups3) ;
  SWISSscore


elseif itest == 4 ;

  disp('Check: optionin') 

  mdata1d = mdata1(:,29:end) ;
  groupsd = groups(29:end) ;
  figure(3) ;
  clf ;
  paramstruct = struct('npcadiradd',2, ...
                       'icolor',mcolor(29:end,:), ...
                       'titlecellstr',{{'DecimatedTest Data Set 1'}}) ;
  scatplotSM(mdata1d,[],paramstruct) ;

  disp('    For Decimated Data1, default')
  SWISSscore = SWISSpwCC(mdata1d,groupsd) ;
  SWISSscore

  disp('    For Decimated Data1, optionin = 1:')
  SWISSscore = SWISSpwCC(mdata1d,groupsd,1) ;
  SWISSscore

  disp('    For Decimated Data1, optionin = 2:')
  SWISSscore = SWISSpwCC(mdata1d,groupsd,2) ;
  SWISSscore


end ;


