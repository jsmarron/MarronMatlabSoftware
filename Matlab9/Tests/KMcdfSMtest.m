disp('Running MATLAB script file KMcdfSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION KMcdfSM,
%    Kaplan Meier cumulative distribution function

itest = 61 ;     %  1,...,19,51,...,55,61


disp(' ') ;
disp(['itest = ' num2str(itest)]) ;
disp(' ') ;

if itest == 1 ; 

  disp('No censoring, expect even quantiles') ;

  vdata = rand(10,1) ;
  vcensor = ones(10,1) ;

  output = KMcdfSM(vdata,vcensor) 


elseif itest == 2 ;

  disp('No censoring, expect even quantiles, test logical vcensoring') ;

  vdata = rand(10,1) ;
  vcensor = logical(ones(10,1)) ;

  output = KMcdfSM(vdata,vcensor) 


elseif itest == 3 ;

  disp('2nd of 4 points censored') ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 1; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 4 ;

  disp('2nd & 3rd of 4 points censored') ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 0; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 5 ;

  disp('2nd & 4th of 4 points censored') ;

  vdata = (1:4)' ;
  vcensor = [1; 0; 1; 0] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 6 ;
  
  disp('All of 4 points censored') ;

  vdata = (1:4)' ;
  vcensor = zeros(4,1) ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 7 ;
  disp('3rd-6th and 8th of 10 points censored') ;

  vdata = (1:10)' ;
  vcensor = [1; 1; 0; 0; 0; 0; 1; 1; 0; 1] ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 8 ;

  disp('Expecting an Error message, since non-vector input') ;

  vdata = rand(100,4) ;

  output = KMcdfSM(vdata) ;


elseif itest == 9 ;

  disp('Expecting an Error message, since non-vector inputs') ;

  vdata = rand(100,4) ;
  vcensor = ones(100,4) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 10 ;

  disp('Expecting an Error message, since non-vector input') ;

  vdata = rand(1,100) ;
  vcensor = ones(100,4) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 11 ;

  disp('Expecting an Error message, since non-vector input') ;

  vdata = rand(100,4) ;
  vcensor = ones(1,100) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 12 ;

  disp('Expecting an Error message, since different length inputs') ;

  vdata = rand(1,100) ;
  vcensor = ones(200,1) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 13 ;

  disp('Expecting warnings, since inputs are row vectors, not columns') ;

  vdata = rand(1,100) ;
  vcensor = ones(1,100) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 14 ;

  disp('Expecting an Error message, since vcensor needs 0s and 1s') ;

  vdata = 1:5 ;
  vcensor = 2 * ones(5,1) ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 15 ;

  disp('Expecting an Error message, since vcensor needs 0s and 1s') ;

  vdata = 1:5 ;
  vcensor = [0; 1; 1; 0; 3] ;

  output = KMcdfSM(vdata,vcensor) ;


elseif itest == 16 ;

  disp('Check sortdata output') ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata] = KMcdfSM(vdata,vcensor) ;

  sortdata


elseif itest == 17 ;

  disp('Check sortdata output, when presort is chosen') ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata] = KMcdfSM(vdata,vcensor,1) ;
          %  1 - assume presorted

  sortdata


elseif itest == 18 ;

  disp('Check sort of censoring data') ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata, sortcensor] = KMcdfSM(vdata,vcensor) ;

  [vdata, vcensor]
  sortcensor


elseif itest == 19 ;

  disp('Check sort of censoring data, when presort is chosen') ;

  vdata = rand(10,1) ;
  vcensor = rand(10,1) > 0.5 ;

  [output, sortdata, sortcensor] = KMcdfSM(vdata,vcensor,1) ;
          %  1 - assume presorted

  [vdata, vcensor]
  sortcensor


elseif itest == 51 ;

  disp('n = 10000 Uniforms, random censoring, input sorted') ;

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

  disp('n = 10000 Uniforms, random censoring, vdata on plot axis') ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  output = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(vdata,output) ;


elseif itest == 53 ;

  disp('n = 10000 Uniforms, random censoring, ipresorted = 0') ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [output,sortdata] = KMcdfSM(vdata,vcensor,0) ;
          %  do not assume presorted

  figure(1) ;
  plot(sortdata,output) ;


elseif itest == 54 ;

  disp('n = 10000 Uniforms, random censoring, ipresorted = 1') ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [output,sortdata] = KMcdfSM(vdata,vcensor,1) ;
          %  assume presorted

  figure(1) ;
  plot(sortdata,output) ;


elseif itest == 55 ;

  disp('n = 10000 Uniforms, random censoring, defaults') ;

  vt = rand(10000,1) ;
  vc = rand(10000,1) ;

  vdata = min(vt,vc) ;
  vcensor = (vt == vdata) ;

  [output,sortdata] = KMcdfSM(vdata,vcensor) ;

  figure(1) ;
  plot(sortdata,output) ;


elseif itest == 61 ;

  disp('n = 10000 Gaussians, random censoring, compare with cdf') ;

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


