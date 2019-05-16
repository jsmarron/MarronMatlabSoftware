disp('Running MATLAB script file cprobSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION cprobSM,
%    Continuous version of empirical probabilities

itest = 5 ;     %  1,2,3,4,5

format compact ;

if itest == 1 ; 
  indat = [2; 3; 8.5; 9] ;
elseif itest == 2 ; 
  indat = [3; 3; 4; 4; 4; 4; 6; 6.5; 9] ;
elseif itest == 3 ; 
  indat = [3; 3; 4; 6; 6.5; 6.5; 8; 8; 8] ;
elseif itest == 4 ; 
  indat = [3; 3; 3; 3] ;
elseif itest == 5 ; 
  indat = 8 * rand(24,1) + 1 ;
end ;

xgrid = linspace(0,10,401)' ;

out = cprobSM(indat,xgrid) ;

  nindat = length(indat) ;
  d = 1 / (nindat + 1) ;
plot(xgrid,out,'-y',sort(indat),(d:d:1-d)','or') ;

