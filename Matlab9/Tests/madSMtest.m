disp('Running MATLAB script file madSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION madSM,
%    Medianb Absolute Deviation

itest = 4 ;     %  1,2,3,4


format compact ;


if itest == 1 ;  

  indat = [1,3,5] 
  output = madSM(indat,0)

elseif itest == 2 ;   

  indat = [1;3;5] 
  output = madSM(indat,0)

elseif itest == 3 ;   

  indat = [[1;3;5],[2;5;8]] 
  output = madSM(indat,0)

elseif itest == 4 ;   

  n = 101 ;      %  99,100,101
  nsamp = 1000 ;    %  10,100,1000

    seed = 29348792 ;
    randn('seed',seed) ;
  indat = randn(n,nsamp) ;

  vmad = madSM(indat) ;

  avgmad = mean(vmad) 
  cirad = norminv(.975) * std(vmad) / sqrt(nsamp) 


end ;



