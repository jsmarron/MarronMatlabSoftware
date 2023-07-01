disp('Running MATLAB script file cquantSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION cquantSM,
%    Continuous version of empirical quantiles

itest = 16 ;     %  1,2,3,4,5,11,12,13,14,15,16

format compact ;

if  itest == 1  |  itest == 11  ; 
  indat = [2; 3; 8.5; 9] ;
elseif  itest == 2  |  itest == 12  ; 
  indat = [3; 3; 4; 4; 4; 4; 6; 6.5; 9] ;
elseif  itest == 3  |  itest == 13  ; 
  indat = [3; 3; 4; 6; 6.5; 6.5; 8; 8; 8] ;
elseif  itest == 4  |  itest == 14  ; 
  indat = [3; 3; 3; 3] ;
elseif  itest == 5  |  itest == 15  ; 
  indat = 8 * rand(24,1) + 1 ;
elseif  itest == 16 ;
  disp('Testing matrix input, expecting error messsge') ;
  indat = rand(6,3) ;
end ;

pgrid = linspace(-.1,1.1,401)' ;

out = cquantSM(indat,pgrid) ;

figure(1) ;
clf ;
  nindat = length(indat) ;
  d = 1 / (nindat + 1) ;
plot(pgrid,out,'-b',(d:d:1-d)',sort(indat),'ok') ;

if itest > 10 ;    %  then add prob curve, to check inverse

  xgrid = linspace(0,10,401)' ;

  outp = cprobSM(indat,xgrid) ;

  hold on ;
    plot(outp,xgrid,'r--') ;
  hold off ;

end ;
