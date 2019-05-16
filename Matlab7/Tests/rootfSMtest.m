disp('Running MATLAB script file rootfSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION rootfSM,
%    General Purpose Root Finder

itest = 6 ;     %  1,2,3,4,5,6

nin = 5 ;       %  2,3,4,5
irt = 0 ;       %  -1,0,1    (root type, up, down, all)
lf = 1 ;        %  -1,1      (smallest or largest local root)
numout = 3 ;    %  1,2,3

format compact ;


if itest == 1 ;   %  Check how well cubic fit works
  x = (1:10)' ;
  y = (x - 6.54321).^3 ; 
elseif itest == 2 ;   %  Bunch of local crossings
  x = (1:8)' ;
  y = [1 2 -1 -2 1 2 -1 3]' ;
elseif itest == 3 ;   %  Check everbody above
  x = (1:5)' ;
  y = [1 2 3 2 3]' ;
elseif itest == 4 ;   %  Check everybody below
  x = (1:5)' ;
  y = -[3 2 3 2 1]' ;
elseif itest == 5 ;   %  Check linear downcrossing
  x = (1:7)' ;
  y = 5.67 - x ;
elseif itest == 6 ;   %  Check parabola
  x = (-3:3)' ;
  y = 4 - x.^2 ;
end ;

if nin == 2 ;
  rootout = rootfSM(x,y) ;
elseif nin == 3 ;
  rootout = rootfSM(x,y,irt) ;
elseif nin == 4 ;
  rootout = rootfSM(x,y,irt,lf) ;
elseif nin == 5 ;
  rootout = rootfSM(x,y,irt,lf,numout) ;
end ;

disp('for the inputs:') ;
xin = x'
yin = y'

disp('   the output vector was:') ;
answer = rootout'


