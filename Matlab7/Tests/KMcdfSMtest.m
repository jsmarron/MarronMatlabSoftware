disp('Running MATLAB script file KMcdfSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION KMcdfSM,
%    Kaplan Meier cumulative distribution function

itest = 19 ;     %  1,...,19,51,...,55,61




if itest == 1 ; 

  vdata = rand(10,1) ;
  vcensor = ones(10,1) ;

  output = KMcdfSM(vdata,vcensor) 


elseif itest == 2 ;

  vdata = rand(10,1) ;
  vcensor = logical(ones(10,1)) ;

  output = KMcdfSM(vdata,vcensor) 


elseif itest == 3 ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 1; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 4 ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 0; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 5 ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 1; 0] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 6 ;

  vdata = (1:4)' ;
  vcensor = zeros(4,1) ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 7 ;

  vdata = (1:10)' ;
  vcensor = [1; 1; 0; 0; 0; 0; 1; 1; 0; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 8 ;

  vdata = rand(100,4) ;

  output = KMcdfSM(vdata) ;


elseif itest == 9 ;

  vdata = rand(100,4) ;
  vcensor = ones(100,4) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 10 ;

  vdata = rand(1,100) ;
  vcensor = ones(100,4) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 11 ;

  vdata = rand(100,4) ;
  vcensor = ones(1,100) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 12 ;

  vdata = rand(1,100) ;
  vcensor = ones(200,1) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 13 ;

  vdata = rand(1,100) ;
  vcensor = ones(1,100) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 14 ;

  vdata = 1:5 ;
  vcensor = 2 * ones(5,1) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 15 ;

  vdata = 1:5 ;
  vcensor = [0; 1; 1; 0; 3] ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 16 ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata] = KMcdfSM(vdata,vcensor) ;

  sortdata


elseif itest == 17 ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata] = KMcdfSM(vdata,vcensor,1) ;
          %  1 - assume presorted

  sortdata


elseif itest == 18 ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata, sortcensor] = KMcdfSM(vdata,vcensor) ;

  [vdata, vcensor]
  sortcensor


elseif itest == 19 ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata, sortcensor] = KMcdfSM(vdata,vcensor,1) ;
          %  1 - assume presorted

  [vdata, vcensor]
  sortcensor


elseif itest == 51 ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [vdata,vind] = sort(vdata) ;
  vcensor = vcensor(vind) ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 52 ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 53 ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  output = KMcdfSM(vdata,vcensor,0) ;
          %  do not assume presorted

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 54 ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  output = KMcdfSM(vdata,vcensor,1) ;
          %  assume presorted

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 55 ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [output,sortdata] = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(sortdata,output) ;


elseif itest == 61 ;

  vt = randn(10000,1) ;
  vc = randn(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [vdata,vind] = sort(vdata) ;
  vcensor = vcensor(vind) ;

  output = KMcdfSM(vdata,vcensor,1) ;

  figure(1) ;
  plot(vdata,output,'y-', ...
       vdata,normcdf(vdata),'c-') ;




end ;


