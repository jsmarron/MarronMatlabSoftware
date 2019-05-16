disp('Running MATLAB script file ranksSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION ranskSM,
%    ranks of data

itest = 7 ;     %  1,2,3,4,5,6,7


format compact ;


if itest == 1 ;  

  indat = [9; 5; 0; 8; 4] 
  output = ranksSM(indat,0)

elseif itest == 2 ;   

  indat = [2, 3, 1] 
  output = ranksSM(indat,0)

elseif itest == 3 ;   

  indat = [[1;3;5],[2;5;8]] 
  output = ranksSM(indat,0)

elseif itest == 4 ;   

  indat = [5; 3; 1; 4; 2; 3; 1; 1] 
  output = ranksSM(indat,0)

elseif itest == 5 ;   

  indat = [5; 3; 1; 4; 2; 3; 1; 1] 
  output = ranksSM(indat,1)

elseif itest == 6 ;   

  indat = [5; 0; 3; 1; 4; 4; 2; 3; 1; 1] 
  output = ranksSM(indat,1)

elseif itest == 7 ;   

  indat = [4; 4; 4; 4; 3; 1] 
  output = ranksSM(indat,1)

end ;



