disp('Running MATLAB script file ClustIndSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION ClustIndSM,
%     Index of clustering, that underlies 2-means (k = 2) clustering

itest = 11 ;     %  0,1,2,3,4,5,6,7,8,9,11
                %       0 just tests at default 


%  Generate generic test data
%
seed = 309475394573957 ;
randn('state',seed) ;

mdata = [(10 * ones(2,3) + randn(2,3)) (-10 * ones(2,4) + randn(2,4))] ;


%  Generic Indices
%
Class1Flag = logical([0 0 0 1 1 1 1]) ;
Class2Flag = logical([1 1 1 0 0 0 0]) ;


if itest == 1 ; 

  Class1Flag = logical([0 0; 0 1]) ;

elseif itest == 2 ; 

  Class2Flag = logical([0 0; 0 1]) ;

elseif itest == 3 ; 

  Class1Flag = logical([0 1]) ;

elseif itest == 4 ; 

  Class2Flag = logical([0 1]) ;

elseif itest == 5 ; 

  Class1Flag = [0 0 0 1 1 1 1] ;

elseif itest == 6 ; 

  Class2Flag = [0 0 0 1 1 1 1] ;

elseif itest == 7 ; 

  Class2Flag = logical([0 0 1 1 1 1 1]) ;

elseif itest == 8 ; 

  totd = sum(sum((mdata - vec2matSM(mean(mdata,2),size(mdata,2))).^2)) ;
      %  Total sum of square distance from mean of column vectors
  [idx,c,sumd] = kmeans(mdata',2,'EmptyAction','singleton') ;
  index = sum(sumd)/totd ;

  disp(['    Check against value from kmeans.m = ' num2str(index)]) ;

elseif itest == 9 ; 

  mdata = mdata(1,:) ;
  totd = sum(sum((mdata - mean(mdata,2)).^2)) ;
      %  Total sum of square distance from mean of column vectors
  [idx,c,sumd] = kmeans(mdata',2,'EmptyAction','singleton') ;
  index = sum(sumd)/totd ;

  disp(['    For 1-d data, Check against value from kmeans.m = ' num2str(index)]) ;

elseif itest == 10 ; 

  mdata = mdata(:,[1 7]) ;
  Class1Flag = Class1Flag([1 7]) ;
  Class2Flag = Class2Flag([1 7]) ;
  totd = sum(sum((mdata - vec2matSM(mean(mdata,2),size(mdata,2))).^2)) ;
      %  Total sum of square distance from mean of column vectors
  [idx,c,sumd] = kmeans(mdata',2,'EmptyAction','singleton') ;
  index = sum(sumd)/totd ;

  disp(['    For n = 2, Check against value from kmeans.m = ' num2str(index)]) ;

elseif itest == 11 ; 

  mdata = mdata(:,[1 1 1 7 7 7 7]) ;
  totd = sum(sum((mdata - vec2matSM(mean(mdata,2),size(mdata,2))).^2)) ;
      %  Total sum of square distance from mean of column vectors
  [idx,c,sumd] = kmeans(mdata',2,'EmptyAction','singleton') ;
  index = sum(sumd)/totd ;

  disp(['    For common means, Check against value from kmeans.m = ' num2str(index)]) ;

end ;



OutPutClusterIndex = ClustIndSM(mdata,Class1Flag,Class2Flag) 


