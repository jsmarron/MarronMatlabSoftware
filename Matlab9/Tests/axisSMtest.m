disp('Running MATLAB script file axisSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION axisSM,
%    sets axis in graphics

itest = 8 ;     %  1,2,3,4,5,6,7,8


if itest == 1 ;

  xmat = [[4 2]; [3 1]]
  ymat = [[5 5]; [8 7]]

  axisout = axisSM(xmat,ymat)


elseif itest == 2 ;

  xmat = [[4 2]; [3 1]]

  axisout = axisSM(xmat)


elseif itest == 3 ;

  xmat = 4
  
  axisout = axisSM(xmat)


elseif itest == 4 ;

  xmat = [[4 2]; [3 1]]
  ymat = []

  axisout = axisSM(xmat,ymat)


elseif itest == 5 ;

  xmat = [[4 2]; [3 1]]
  ymat = [[5 5]; [8 7]]
  alpha = 0.05

  axisout = axisSM(xmat,ymat,alpha)


elseif itest == 6 ;

  xmat = [[4 2]; [3 1]]
  ymat = [[5 5]; [8 7]]
  alpha = 1

  axisout = axisSM(xmat,ymat,alpha)


elseif itest == 7 ;

  figure(1) ;
  clf ;

  xmat = [[4 2]; [3 1]] ;
  ymat = [[5 5]; [8 7]] ;

  plot(xmat,ymat) ;

  pauseSM ;

  axisSM(xmat,ymat) ;

  pauseSM ;

    alpha = 0 
  axisSM(xmat,ymat,alpha) ;

  pauseSM ;

    alpha = 1 
  axisSM(xmat,ymat,alpha) ;


elseif itest == 8 ;

  figure(1) ;
  clf ;

  xmat = [[4 2]; [3 1]] ;
  ymat = [[5 5]; [8 7]] ;

  plot(xmat,ymat) ;

  axisSM(xmat) ;

    alpha = 1 
  axisSM(xmat,[],alpha) ;


end ;    %  of itest if-block




