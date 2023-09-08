disp('Running MATLAB script file NearlyNullSpaceBasisSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION NearlyNullSpaceBasisSM,
%    which finds the Nearly Null Space Bases

itest = 27 ;     %  1,...,27


if itest == 1 ;

  disp('Simple 5-d, nullnum = 3, trial') ;
  G = eye(5) ;
  vx = [] ;
  nullnum = 3 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum)

elseif itest == 2 ;

  disp('Test Non-square G') ;
  G = ones(3,5) ;
  vx = [] ;
  nullnum = 3 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum)

elseif itest == 3 ;

  disp('Test manually input vx (column)') ;
  G = eye(5) ;
  vx = linspace(2,10,5)' 
  nullnum = 3 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum)

elseif itest == 4 ;

  disp('Test manually input vx (row)') ;
  G = eye(5) ;
  vx = linspace(2,10,5)
  nullnum = 3 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum)

elseif itest == 5 ;

  disp('Test vx too big') ;
  G = eye(5) ;
  vx = linspace(1,10,10)
  nullnum = 3 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum)

elseif itest == 6 ;

  disp('Test npcout = 1') ;
  G = eye(5) ;
  vx = [] ;
  nullnum = 3 ;
  npcout = 1 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout)

elseif itest == 7 ;

  disp('Test npcout = 1 & nsmoothout = 1') ;
  G = eye(5) ;
  vx = [] ;
  nullnum = 3 ;
  npcout = 1 ;
  nsmoothout = 1 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout)

elseif itest == 8 ;

  disp('Test npcout = 0 & nsmoothout = 1') ;
  G = eye(5) ;
  vx = [] ;
  nullnum = 3 ;
  npcout = 0 ;
  nsmoothout = 1 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout)

elseif itest == 9 ;

  disp('Test npcout = 1 & nsmoothout = 0') ;
  G = eye(5) ;
  vx = [] ;
  nullnum = 3 ;
  npcout = 1 ;
  nsmoothout = 0 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout)

elseif itest == 10 ;

  disp('Generate & Plot 5-d simple smooth basis') ;
  G = zeros(5) ;
  vx = [] ;
  nullnum = 5 ;
  npcout = 0 ;
  nsmoothout = 5 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  figure(1) ;
  clf ;
  plot((1:5)',msmoothprobes) ;  
  title('5-d Simple probe basis') ;
  legend('1','2','3','4','5','Location','Southeast') ;

elseif itest == 11 ;

  disp('Generate & Plot first 5 of 10-d simple smooth basis') ;
  G = zeros(10) ;
  vx = [] ;
  nullnum = 10 ;
  npcout = 0 ;
  nsmoothout = 5 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  figure(1) ;
  clf ;
  plot((1:10)',msmoothprobes) ;  
  title('In 10-d, 1st 5 of Simple probe basis') ;
  legend('1','2','3','4','5','Location','Southeast') ;

elseif itest == 12 ;

  disp('Generate & Plot first 5 of 100-d simple smooth basis') ;
  G = zeros(100) ;
  vx = [] ;
  nullnum = 100 ;
  npcout = 0 ;
  nsmoothout = 5 ;
  [mpcprobes,msmoothprobes] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  figure(1) ;
  clf ;
  plot((1:100)',msmoothprobes) ;  
  title('In 100-d, 1st 5 of Simple probe basis') ;
  legend('1','2','3','4','5','Location','Southeast') ;

elseif itest == 13 ;

  disp('Generate & Plot 2 Smooth Basis Functions in Simple 4d example') ;
  G = [[3 1 0 0]; ...
       [1 2 0 0]; ...
       [0 0 1 0]; ...
       [0 0 0 1]] 
  vx = [] ;
  nullnum = 2 ;
  npcout = 2 ;
  nsmoothout = 2 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, 1st 2 of PC probe basis') ;
  legend('1','2','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, 1st 2 of Simple probe basis') ;
  legend('1','2','Location','Southeast') ;

elseif itest == 14 ;

  disp('Simple 4d example, try to avoid boundary effects') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 2 ;
  npcout = 2 ;
  nsmoothout = 2 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, 1st 2 of PC probe basis') ;
  legend('1','2','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, 1st 2 of Simple probe basis') ;
  legend('1','2','Location','Southeast') ;

elseif itest == 15 ;

  disp('Simple 4d example, test full pc basis') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 0 ;
  npcout = 4 ;
  nsmoothout = 0 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','2','3','4','Location','Southeast') ;

elseif itest == 16 ;

  disp('Simple 4d example, 1 null basis element') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 1 ;
  npcout = 3 ;
  nsmoothout = 1 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, 1st 3 of PC probe basis') ;
  legend('1','2','3','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, Simple probe basis') ;
  legend('1','Location','Southeast') ;

elseif itest == 17 ;

  disp('Simple 4d example, 3 null basis elements') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 3 ;
  npcout = 1 ;
  nsmoothout = 3 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, 3 Simple probe basis') ;
  legend('1','2','3','Location','Southeast') ;

elseif itest == 18 ;

  disp('Simple 4d example, Plot Reduced Number of both elements') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 2 ;
  npcout = 1 ;
  nsmoothout = 1 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, Simple probe basis') ;
  legend('1','Location','Southeast') ;

elseif itest == 19 ;

  disp('Generate & Plot first 5 of 100-d simple smooth basis, log spaced xs') ;
  G = zeros(100) ;
  vx = (10.^linspace(-2,0,100))' ;
  nullnum = 100 ;
  npcout = 0 ;
  nsmoothout = 5 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  plot(vx,msmoothprobes) ;  
  title('In 100-d, 1st 5 of Simple probe basis, log spaced xs') ;
  legend('1','2','3','4','5','Location','Southwest') ;

elseif itest == 20 ;

  disp('Simple 4d example, Check handling of 0 eigenvalues') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 0 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 2 ;
  npcout = 2 ;
  nsmoothout = 2 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','2','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, Simple probe basis') ;
  legend('1','2','Location','Southeast') ;

elseif itest == 21 ;

  disp('Simple 4d example, Check handling of negative eigenvalues') ;
  G = [[3 0 0 1]; ...
       [0 1 0 0]; ...
       [0 0 -1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 2 ;
  npcout = 2 ;
  nsmoothout = 2 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  subplot(1,2,1) ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','2','Location','Southeast') ;

  subplot(1,2,2) ;
  plot((1:4)',msmoothprobes) ;  
  title('In 4-d, Simple probe basis') ;
  legend('1','2','Location','Southeast') ;

elseif itest == 22 ;

  disp('Simple 4d example, Check handling of 2 negative eigenvalues') ;
  G = [[3 0 0 1]; ...
       [0 -1 0 0]; ...
       [0 0 -1 0]; ...
       [1 0 0 2]] 
  vx = [] ;
  nullnum = 0 ;
  npcout = 4 ;
  nsmoothout = 0 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

  figure(1) ;
  clf ;
  plot((1:4)',mpcprobes) ;  
  title('In 4-d, PC probe basis') ;
  legend('1','2','3','4','Location','Southeast') ;

elseif itest == 23 ;

  disp('Simple 4d example, Check eigenvalues of smooth basis') ;
  G = eye(4) ; 
  vx = [] ;
  nullnum = 4 ;
  npcout = 0 ;
  nsmoothout = 4 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

elseif itest == 24 ;

  disp('Simple 10d example, Check eigenvalues of smooth basis') ;
  G = eye(10) ; 
  vx = [] ;
  nullnum = 10 ;
  npcout = 0 ;
  nsmoothout = 10 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

elseif itest == 25 ;

  disp('Simple 100d example, Check eigenvalues of smooth basis') ;
  G = eye(100) ; 
  vx = [] ;
  nullnum = 100 ;
  npcout = 0 ;
  nsmoothout = 100 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vpceigval = getfield(indexstruct,'vpceigval')
  vsmootheigval = getfield(indexstruct,'vsmootheigval')
  vpcsmooth = getfield(indexstruct,'vpcsmooth')
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth')

elseif itest == 26 ;

  disp('100d example, Compute all smooth indices') ;
  temp = randn(100,100) ;
  G = temp * temp' ; 
  vx = [] ;
  nullnum = 0 ;
  npcout = 5 ;
  nsmoothout = 0 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;

  vallsmosmooth = getfield(indexstruct,'vallsmosmooth')

elseif itest == 27 ;

  disp('10d example, Compare 2 calculations of all smooth bases') ;

  temp = randn(10,10) ;
  G = temp * temp' ; 
  vx = [] ;
  nullnum = 0 ;
  npcout = 5 ;
  nsmoothout = 0 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;
  vallsmosmooth1 = getfield(indexstruct,'vallsmosmooth') ;

  G = zeros(10) ; 
  vx = [] ;
  nullnum = 10 ;
  npcout = 0 ;
  nsmoothout = 10 ;
  [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) ;
  vallsmosmooth2 = getfield(indexstruct,'vsmoothsmooth') ;

  disp('Check this is 0:') ;
  max(abs(vallsmosmooth1 - vallsmosmooth2))

end ;



