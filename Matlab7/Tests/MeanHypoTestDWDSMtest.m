disp('Running MATLAB script file MeanHypoTestSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION MeanHypoTestSM,
%    
%    Also gives toy examples of how to use that function
%




itest = 25 ;      %  1  Full scale test with toy data (everything at defaults)
                  %  2,...,25  parameter tests



idat = 2 ;    %  1 - Familiar 40 d data set as in DWD1figB.m
              %  2 - Similar, but less mean difference, to make test harder
              %                 (interesting to study non-trivial p-values)



%  Generate toy data, similar to DWD1figB.m
%

d = 40 ;
n1 = 20 ;
n2 = 20 ;
seed = 7543870734 ;
randn('state',seed) ;
if idat == 1 ;
  mu0 = 2.2 ;
elseif idat == 2 ;
  mu0 = 0.5 ;
end ;
sig0 = 1 ;
mtraindat1 = mu0 + sig0 * randn(1,n1) ;
mtraindat2 = -mu0 + sig0 * randn(1,n2) ;
mtraindat1 = [mtraindat1; randn((d-1),n1)] ;
mtraindat2 = [mtraindat2; randn((d-1),n2)] ;



figure(1) ;
clf ;



if itest == 1 ;

  MeanHypoTestDWDSM(mtraindat1,mtraindat2) ;


elseif itest == 2 ;

  paramstruct = struct('nsim',10) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 3 ;

  paramstruct = struct('nsim',10, ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 4 ;

  paramstruct = struct('nsim',10, ...
                       'title1str','Test Title 1', ...
                       'title2str','Test Title 2', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 5 ;

  paramstruct = struct('nsim',10, ...
                       'title1str','Default ipval', ...
                       'title2str',['Data Set, idat = ' num2str(idat)], ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 6 ;

  paramstruct = struct('nsim',10, ...
                       'ipval',1, ...
                       'title1str','Set ipval = 1', ...
                       'title2str',['Data Set, idat = ' num2str(idat)], ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 7 ;

  paramstruct = struct('nsim',10, ...
                       'ipval',2, ...
                       'title1str','Set ipval = 1', ...
                       'title2str',['Data Set, idat = ' num2str(idat)], ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 8 ;

  paramstruct = struct('nsim',10, ...
                       'seed',[], ...
                       'title1str','Testing No Seed', ...
                       'title2str','Run twice, check different', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 9 ;

  paramstruct = struct('nsim',10, ...
                       'seed',49038275093, ...
                       'title1str','Testing Chosen Seed', ...
                       'title2str','Run twice, check same', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 10 ;

  paramstruct = struct('nsim',10, ...
                       'seed',49038275093, ...
                       'title1str','Testing Chosen Seed', ...
                       'title2str','Run twice, check same', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 11 ;

  paramstruct = struct('nsim',10, ...
                       'icolor',0, ...
                       'title1str','Test Colors', ...
                       'title2str','Fully Black & White', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 12 ;

  paramstruct = struct('nsim',10, ...
                       'icolor',[[1 0 1]; [0 1 1]], ...
                       'title1str','Test Colors', ...
                       'title2str','Purple & Cyan', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 13 ;

  paramstruct = struct('nsim',10, ...
                       'markerstr','+', ...
                       'title1str','Test Markers', ...
                       'title2str','all +', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 14 ;

  paramstruct = struct('nsim',10, ...
                       'markerstr',['x';'d'], ...
                       'title1str','Test Markers', ...
                       'title2str','x''s and diamonds', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 15 ;

  paramstruct = struct('nsim',10, ...
                       'datovlaymin',0.2, ...
                       'datovlaymax',0.4, ...
                       'title1str','Test Markers', ...
                       'title2str','x''s and diamonds', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 16 ;

  paramstruct = struct('nsim',10, ...
                       'legendcellstr',{{'Class 1' 'Class 2'}}, ...
                       'title1str','Test Class Labels', ...
                       'title2str','', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 17 ;

  paramstruct = struct('nsim',10, ...
                       'titlefontsize',5, ...
                       'title1str','Test titlefontsize', ...
                       'title2str','Small', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 18 ;

  paramstruct = struct('nsim',10, ...
                       'titlefontsize',24, ...
                       'title1str','Test titlefontsize', ...
                       'title2str','Large', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 19 ;

  paramstruct = struct('nsim',10, ...
                       'xlabel1str','X1 str', ...
                       'ylabel1str','Y1 str', ...
                       'xlabel2str','X2 str', ...
                       'ylabel2str','Y2 str', ...
                       'title1str','Test axis labels', ...
                       'title2str',' ', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 20 ;

  paramstruct = struct('nsim',10, ...
                       'xlabel1str','X1 str', ...
                       'ylabel1str','Y1 str', ...
                       'xlabel2str','X2 str', ...
                       'ylabel2str','Y2 str', ...
                       'labelfontsize',6, ...
                       'title1str','Test axis labels', ...
                       'title2str','Font Size', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 21 ;

  axh1 = subplot(2,2,4) ;
  axh2 = subplot(2,2,3) ;
  vaxh = [axh1; axh2] ;

  paramstruct = struct('nsim',10, ...
                       'vaxh',vaxh, ...
                       'title1str','Manual Plot location Choice', ...
                       'title2str','Bottom & Reversed', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 22 ;

  paramstruct = struct('nsim',10, ...
                       'savestr','MeanHypoTestDWD', ...
                       'title1str','Save as .ps file', ...
                       'title2str','Look for MeanHypoTestDWDSM.ps', ...
                       'iscreenwrite',1) ;
 
  MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;


elseif itest == 23 ;

  paramstruct = struct('nsim',10, ...
                       'title1str','Test Output p-value', ...
                       'title2str','Look in Matlab Window', ...
                       'iscreenwrite',1) ;
 
  pval = MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;

  disp(' ') ;
  disp(['    Returned p-val = ' num2str(pval)]) ;


elseif itest == 24 ;

  paramstruct = struct('nsim',10, ...
                       'title1str','Test Output t-statistic', ...
                       'title2str','Look in Matlab Window', ...
                       'iscreenwrite',1) ;
 
  [pval,tstat] = MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;

  disp(' ') ;
  disp(['    Returned p-val = ' num2str(pval)]) ;
  disp(['   Returned t-stat = ' num2str(tstat)]) ;


elseif itest == 25 ;

  paramstruct = struct('nsim',0, ...
                       'title1str','Test nsim = 0', ...
                       'title2str','This should not show up!', ...
                       'iscreenwrite',1) ;
 
  [pval,tstat] = MeanHypoTestDWDSM(mtraindat1,mtraindat2,paramstruct) ;

  disp(' ') ;
  disp(['   Returned t-stat = ' num2str(tstat)]) ;
  disp(['   This should be 1: ' num2str(isempty(pval))]) ;


end ;


