disp('Running MATLAB script file vec2matSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION vec2matSM,
%    turns vectors int matrices, by Steve Marron

itest = 14 ;     %  1,...,14


if itest == 1 ; 
  invec = [1; 3; 5] 
  num = 4 
  
  vec2matSM(invec,num)

elseif itest == 2 ; 
  invec = [2 4 6 8] 
  num = 3 
  
  vec2matSM(invec,num)

elseif itest == 3 ; 
  invec = 1 
  num = 3 
  
  vec2matSM(invec,num)

elseif itest == 4 ; 
  invec = [1 2; 3 4] 
  num = 2 
  
  vec2matSM(invec,num)

elseif itest == 5 ; 
  invec = [1; 3; 5] 
  num = 4 
  iscalehand = 0
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 6 ; 
  invec = [1; 3; 5] 
  num = 4 
  iscalehand = 1
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 7 ; 
  invec = [1; 3; 5] 
  num = 4 
  iscalehand = 2
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 8 ; 
  invec = [1; 3; 5] 
  num = 4 
  iscalehand = 3
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 9 ; 
  invec = [1; 3; 5] 
  num = 4 
  iscalehand = 4
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 10 ; 
  invec = 1 
  num = 4 
  iscalehand = 0
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 11 ; 
  invec = 1 
  num = 4 
  iscalehand = 1
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 12 ; 
  invec = 1 
  num = 4 
  iscalehand = 2
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 13 ; 
  invec = 1 
  num = 4 
  iscalehand = 3
  
  vec2matSM(invec,num,iscalehand)

elseif itest == 14 ; 
  invec = 1 
  num = 4 
  iscalehand = 4
  
  vec2matSM(invec,num,iscalehand)

end ;


