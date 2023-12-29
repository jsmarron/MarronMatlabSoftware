disp('Running MATLAB script file SigClust2meanPerfSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClust2meanPerfSM
%     Index of clustering, that underlies 2-means (k = 2) clustering

itest = 23 ;     %  1,2,3,4,5,11,12,13,14,15,16,17,18,19,20,21,22,23


if itest == 1 ;    %  Simple strongly clustered data, all defaults

  rng(70374372) ;
  data = randn(2,5) ;
  data = [data (10 * ones(2,5) + randn(2,5))] ; 

  SigClust2meanPerfSM(data) ;


elseif itest == 2 ;    %  Simple Gaussian data, all defaults

  rng(23983443) ;
  data = randn(10,10) ;

  SigClust2meanPerfSM(data) ;


elseif itest == 3 ;    %  Data on the surface of the sphere, all defaults

  rng(42485632) ;
  data = randn(10,12) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;

  SigClust2meanPerfSM(data) ;


elseif itest == 4 ;    %  Data in 4 balanced clusters, all defaults

  rng(98347573) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,5) + randn(2,5))] ; 
  data = [data ([(100 * ones(1,5)); zeros(1,5)] + randn(2,5))] ; 
  data = [data ([zeros(1,5); (100 * ones(1,5))] + randn(2,5))] ; 

  SigClust2meanPerfSM(data) ;


elseif itest == 5 ;    %  Data in 4 unbalanced clusters, all defaults

  rng(98347573) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,8) + randn(2,8))] ; 
  data = [data ([(100 * ones(1,7)); zeros(1,7)] + randn(2,7))] ; 
  data = [data ([zeros(1,6); (100 * ones(1,6))] + randn(2,6))] ; 

  SigClust2meanPerfSM(data) ;


else ;    %  Do parameter tests, use Data on the surface of the sphere

  rng(42485632) ;
  data = randn(10,12) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;


  if itest == 11 ;    %  paramstruct, with all defaults 

    paramstruct = struct('nrep',100,...
                         'viplot',[1 1 1 1 1 1 1],...
                         'randstate',[],...
                         'randnstate',[],...
                         'titlestr',[],...
                         'titlefontsize',[],...
                         'labelfontsize',[],...
                         'savestr',[],...
                         'iscreenwrite',0) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 12 ;    %  paramstruct, fiddle nrep 

    paramstruct = struct('nrep',1000,...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 13 ;    %  paramstruct, fiddle viplot

    close all ;

    paramstruct = struct('viplot',[1 1 1],...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 14 ;    %  paramstruct, fiddle viplot

    close all ;

    paramstruct = struct('viplot',[0 0 1 0 0 1],...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 15 ;    %  paramstruct, fiddle titlestr

    paramstruct = struct('titlestr','Test Title, ',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 16 ;    %  paramstruct, fiddle randseed

    close all ;

    paramstruct = struct('viplot',[0 0 0 0 0 0 1],...
                         'randseed',[],...
                         'titlestr','No Seeds, Round 1,    ',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;

    pauseSM ;

    paramstruct = struct('viplot',[0 0 0 0 0 0 1],...
                         'randseed',[],...
                         'titlestr','No Seeds, Round 2,   ',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 17 ;    %  paramstruct, fiddle randstate and randnstate

    close all ;

    paramstruct = struct('viplot',[0 0 0 0 0 0 1],...
                         'randseed',74028734,...
                         'titlestr','Using Same Seeds, Round 1,    ',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;

    pauseSM ;

    paramstruct = struct('viplot',[0 0 0 0 0 0 1],...
                         'randseed',74028734,...
                         'titlestr','Using Same Seeds, Round 2,   ',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 18 ;    %  paramstruct, fiddle titlefontsize

    paramstruct = struct('titlefontsize',24,...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 19 ;    %  paramstruct, fiddle labelfontsize

    paramstruct = struct('labelfontsize',18,...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 20 ;    %  paramstruct, fiddle savestr

    paramstruct = struct('titlefontsize',15,...
                         'labelfontsize',12,...
                         'savestr','TestSave',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;

    disp('Look at 7 .ps files') ;


  elseif itest == 21 ;    %  paramstruct, try viplot as a column vector

    close all ;

    paramstruct = struct('viplot',[0 0 1 0 0 1]',...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 22 ;    %  paramstruct, try viplot as a matric

    close all ;

    paramstruct = struct('viplot',ones(2,2),...
                         'iscreenwrite',1) ;

    SigClust2meanPerfSM(data,paramstruct) ;


  elseif itest == 23 ;    %  give output

    close all ;

    paramstruct = struct('viplot',[1 0 0 0 0 0 1],...
                         'randstate',7402873450,...
                         'randnstate',2394753757,...
                         'iscreenwrite',1) ;

    [BestClass, bestCI] = SigClust2meanPerfSM(data,paramstruct) 



  end ;

end ;


