disp('Running MATLAB script file minrSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION minrSM,
%    General Purpose Minimizer

itest = 7 ;     %  1,2,3,4,5,6,7

numout = 3 ;    %  1,2,3
lmf = 0 ;       %  -1,0,1
nin = 4 ;       %  2,3,4

format compact ;


if itest == 1 ;   %  Check how well quadratic fit works
  x = (1:10)' ;
  y = (x - 6.54321).^2 ; 
elseif itest == 2 ;   %  Check what happens for ties
  x = (1:7)' ;
  y = [2 1 2 1 2 1 2]' ;
elseif itest == 3 ;   %  Check left endpoint
  x = (1:5)' ;
  y = [1 2 3 2 3]' ;
elseif itest == 4 ;   %  Check right endpoint
  x = (1:5)' ;
  y = [3 2 3 2 1]' ;
elseif itest == 5 ;   %  Check flat spot in middle
  x = (1:7)' ;
  y = [2 1 1 1 1 1 2]' ;
elseif itest == 6 ;   %  Check flat spot on left
  x = (1:5)' ;
  y = [1 1 1 2 2]' ;
elseif itest == 7 ;   %  Check flat spot on right
  x = (1:5)' ;
  y = [3 2 1 1 1]' ;
end ;

if nin == 2 ;
  minout = minrSM(x,y) ;
elseif nin == 3 ;
  minout = minrSM(x,y,lmf) ;
elseif nin == 4 ;
  minout = minrSM(x,y,lmf,numout) ;
end ;

disp('for the inputs:') ;
xin = x'
yin = y'

disp('   the output vector was:') ;
answer = minout'


