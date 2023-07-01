disp('Running MATLAB script file iqrSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION iqrSM,
%    interquartile range

itest = 4 ;     %  1,2,3,4

format compact ;

if itest == 1 ;   %  Check simple one first
  data = (-3:1:3)' ;
  out = iqrSM(data,0)  ;
elseif itest == 2 ;   %  Check another simple one
  data = (1:9)' ;
  out = iqrSM(data,0)  ;
elseif itest == 3 ;   %  Check a random one
  data = rand(7,3) ;
  out = iqrSM(data,1)  ;
elseif itest == 4 ;   %  Check another random one
  data = rand(9,2) ;
  out = iqrSM(data)  ;
end ;


disp('for the input:') ;
datain = data

disp('   the output was:') ;
answer = out


