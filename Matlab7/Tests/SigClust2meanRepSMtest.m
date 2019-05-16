disp('Running MATLAB script file SigClust2meanRepSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClust2meanRepSM
%     Does repitition of 2 means clustering, over random restarts

itest = 14 ;     %  1,2,3,4,5,11,12,13,14


if itest == 1 ;    %  Simple strongly clustered data, all defaults

  randn('state',70374372402) ;
  data = randn(2,5) ;
  data = [data (10 * ones(2,5) + randn(2,5))] ; 

  [bestclass, vindex, midx] = SigClust2meanRepSM(data) 


elseif itest == 2 ;    %  Simple Gaussian data, all defaults

  randn('state',2398344375) ;
  data = randn(10,10) ;

  [bestclass, vindex, midx] = SigClust2meanRepSM(data) 


elseif itest == 3 ;    %  Data on the surface of the sphere, all defaults

  randn('state',424856325) ;
  data = randn(10,12) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;

  [bestclass, vindex, midx] = SigClust2meanRepSM(data) 


elseif itest == 4 ;    %  Data in 4 balanced clusters, all defaults

  randn('state',9834757345) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,5) + randn(2,5))] ; 
  data = [data ([(100 * ones(1,5)); zeros(1,5)] + randn(2,5))] ; 
  data = [data ([zeros(1,5); (100 * ones(1,5))] + randn(2,5))] ; 

  [bestclass, vindex, midx] = SigClust2meanRepSM(data) 


elseif itest == 5 ;    %  Data in 4 unbalanced clusters, all defaults

  randn('state',9834757345) ;
  data = randn(2,5) ;
  data = [data (100 * ones(2,8) + randn(2,8))] ; 
  data = [data ([(100 * ones(1,7)); zeros(1,7)] + randn(2,7))] ; 
  data = [data ([zeros(1,6); (100 * ones(1,6))] + randn(2,6))] ; 

  [bestclass, vindex, midx] = SigClust2meanRepSM(data) 


else ;    %  Do parameter tests, use Data on the surface of the sphere

  randn('state',424856325) ;
  data = randn(10,12) ;
  vlengths = sqrt(diag(data' * data)) ; 
  data = data ./ vec2matSM(vlengths',10) ;


  if itest == 11 ;    %  paramstruct, with all defaults 

    paramstruct = struct('nrep',100,...
                         'randstate',[],...
                         'randnstate',[],...
                         'iscreenwrite',0) ;

    [bestclass, vindex, midx] = SigClust2meanRepSM(data,paramstruct) 


  elseif itest == 12 ;    %  paramstruct, fiddle nrep 

    paramstruct = struct('nrep',1000,...
                         'iscreenwrite',1) ;

    [bestclass, vindex, midx] = SigClust2meanRepSM(data,paramstruct) 

  elseif itest == 13 ;    %  paramstruct, fiddle randstate and randnstate

    close all ;

    paramstruct = struct('randstate',[],...
                         'randnstate',[],...
                         'iscreenwrite',1) ;

    [bestclass1, vindex1, midx1] = SigClust2meanRepSM(data,paramstruct) 

    paramstruct = struct('randstate',[],...
                         'randnstate',[],...
                         'iscreenwrite',1) ;

    [bestclass2, vindex2, midx2] = SigClust2meanRepSM(data,paramstruct) 

     bestclassdif = max(abs(bestclass1 - bestclass2)) 
     vindexdif = max(abs(vindex1 - vindex2))
     midxdiff = max(max(abs(midx1 - midx2)))


  elseif itest == 14 ;    %  paramstruct, fiddle randstate and randnstate

    close all ;

    paramstruct = struct('randstate',7402873450,...
                         'randnstate',2394753757,...
                         'iscreenwrite',1) ;

    [bestclass1, vindex1, midx1] = SigClust2meanRepSM(data,paramstruct) 

    paramstruct = struct('randstate',7402873450,...
                         'randnstate',2394753757,...
                         'iscreenwrite',1) ;

    [bestclass2, vindex2, midx2] = SigClust2meanRepSM(data,paramstruct) 

     bestclassdif = max(abs(bestclass1 - bestclass2)) 
     vindexdif = max(abs(vindex1 - vindex2))
     midxdiff = max(max(abs(midx1 - midx2)))


  end ;

end ;


