disp('Running MATLAB script file ClusterOrderSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION ClusterOrderSM,
%    Medianb Absolute Deviation

itest = 13 ;     %  1,...,5     Parameter tests
                 %  11,12,13    Tests using graphics


%  Toy Data
mdata = [[4 10 2 11 20 5]; zeros(1,6)] ;

disp(' ') ;
disp(' ') ;


if itest == 1 ;  

  disp('Test data input only') ;
  mdata 
  voutput = ClusterOrderSM(mdata) 

elseif itest == 2 ;   

  disp('Test explicit average linkage') ;
  mdata 
  voutput = ClusterOrderSM(mdata,1) 

elseif itest == 3 ;   

  disp('Test explicit ward linkage') ;
  mdata 
  voutput = ClusterOrderSM(mdata,2) 

elseif itest == 4 ;   

  disp('Test unsupported linkage') ;
  mdata 
  voutput = ClusterOrderSM(mdata,5) 

elseif itest == 5 ;   

  disp('Test text linkage') ;
  mdata 
  voutput = ClusterOrderSM(mdata,'average') 

elseif itest == 11 ;   

  disp('Exploring 10 x 10 toy example') ;

  mdata = [(ones(3,1) * [20 20 20 20 20 20 20 20 30 30]); ...
           (ones(5,1) * [20 20 20 30 30 30 30 30 10 10]); ...
           (ones(2,1) * [40 40 40 40 40 40 40 40 30 30])] ;
  rng(16385638) ;
      %  Seed for random number generators
  mdata = (mdata / 2) - 2 * rand(10,10) ;
  mdata = mdata(randperm(10),randperm(10)) ;
  cmap = (linspace(0,20,21)' / 20) * ones(1,3) ;

  figure(1) ;
  clf ;
  colormap(cmap) ;
  image(mdata) ;
  title('Random Rows and Columns') ;

  figure(2) ;
  clf ;
  vcolindex = ClusterOrderSM(mdata) ;
  colormap(cmap) ;
  image(mdata(:,vcolindex)) ;
  title('Clustered Columns') ;

  figure(3) ;
  clf ;
  vrowindex = ClusterOrderSM(mdata') ;
  colormap(cmap) ;
  image(mdata(vrowindex,vcolindex)) ;
  title('Clustered Rows and Columns') ;

elseif itest == 12 ;   

  disp('Exploring 50 x 50 Uniform Random Example') ;

  rng(74092387) ;
  mdata = 20 * rand(50,50) ;
      %  Seed for random number generators
  cmap = (linspace(0,20,21)' / 20) * ones(1,3) ;

  figure(1) ;
  clf ;
  colormap(cmap) ;
  image(mdata) ;
  title('Uniform Random Raw') ;

  figure(2) ;
  clf ;
  vcolindex = ClusterOrderSM(mdata) ;
  colormap(cmap) ;
  image(mdata(:,vcolindex)) ;
  title('Uniform Random Clustered Columns') ;

  figure(3) ;
  clf ;
  vrowindex = ClusterOrderSM(mdata') ;
  colormap(cmap) ;
  image(mdata(vrowindex,vcolindex)) ;
  title('Uniform Random Clustered Rows and Columns') ;

elseif itest == 13 ;   

  disp('Exploring 50 x 50 Patterned Random Example') ;

  rng(34659896) ;
      %  Seed for random number generators
  mdata = 12 * rand(50,50) ;
  mdata(1:25,:) = mdata(1:25,:) + 4 ;
  mdata(:,1:25) = mdata(:,1:25) + 4 ;
  mdata = mdata(randperm(50),randperm(50)) ;
  cmap = (linspace(0,20,21)' / 20) * ones(1,3) ;

  figure(1) ;
  clf ;
  colormap(cmap) ;
  image(mdata) ;
  title('Patterned Random Raw') ;

  figure(2) ;
  clf ;
  vcolindex = ClusterOrderSM(mdata) ;
  colormap(cmap) ;
  image(mdata(:,vcolindex)) ;
  title('Patterned Random Clustered Columns') ;

  figure(3) ;
  clf ;
  vrowindex = ClusterOrderSM(mdata') ;
  colormap(cmap) ;
  image(mdata(vrowindex,vcolindex)) ;
  title('Patterned Random Clustered Rows and Columns') ;


end ;



