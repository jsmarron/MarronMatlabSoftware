disp('Running MATLAB script file gausschkSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION gausschkSM,
%    checks Gaussian assumption for functional data


ieg = 5 ;
               %  1 - IID Gaussian
               %  2 - IID Exponentials
               %  3 - IID Chi Square 1
               %  4 - Parabolas toy example
               %  5 - Exponential Parabolas
               %  6 - Chi Square 1 Parabolas


vitest = 7 ;
%vitest = [2 3 5 7] ;     
                %  1 - Defaults
                %  2 - Choose Matlab default colors
                %  3 - Black and white
                %  4 - Rainbow colors - random
                %  5 - Rainbow colors - by 5th entry
                %  6 - Two Colors - random
                %  7 - Two colors - by 5th entry


if ieg == 1 ;    %  IID Gaussian

  d = 10 ;
  n = 50 ;
  randn('state',7257958727) ;
  mdata = randn(d,n) ;


elseif ieg == 2 ;    %  IID Exponentials

  d = 10 ;
  n = 50 ;
  rand('state',298374874) ;
  mdata = -log(rand(d,n)) ;


elseif ieg == 3 ;    %  IID Chi Square 1

  d = 10 ;
  n = 50 ;
  randn('state',5738752724) ;
  mdata = randn(d,n).^2 ;


elseif ieg == 4 ;    %  Simple parabolas toy example
    %  from curvdatSMtest.m
    %  Original Example from classes\322\s322eg12.m  "Parabs"

  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('seed',88769874) ;
    eps1 = 4 * randn(1,n) ;
    eps2 = .5 * randn(1,n) ;
    eps3 = 1 * randn(d,n) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;


elseif ieg == 5 ;    %  Exponential parabolas toy example

  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    rand('state',9587454845) ;
    eps1 = 4 * -log(rand(1,n)) ;
    eps2 = .5 * -log(rand(1,n)) ;
    eps3 = 1 * -log(rand(d,n)) ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;


elseif ieg == 6 ;    %  Chi Square 1 parabolas toy example

  d = 10 ;
  n = 50 ;
  xgrid = (.5:1:d)' ;
  mdata = (xgrid - 6).^2 ;
    randn('state',163263164) ;
    eps1 = 4 * randn(1,n).^2 ;
    eps2 = .5 * randn(1,n).^2 ;
    eps3 = 1 * randn(d,n).^2 ;
  mdata = vec2matSM(mdata,n) + vec2matSM(eps1,d) + ...
                 vec2matSM(eps2,d) .* vec2matSM(xgrid-d/2,n) + eps3 ;


end ;    %  of ieg if-block




figure(1) ;
clf ;




for itest = vitest ;

  if itest == 1 ;    %  all defaults
  
    gausschkSM(mdata) ;


  elseif itest == 2 ;    %  Choose Matlab default colors

      paramstruct = struct('icolor',1, ...
                           'savestr','DefaultColorTest') ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 3 ;    %  Black and white

      paramstruct = struct('icolor',0, ...
                           'savestr','BWColorTest') ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 4 ;    %  Rainbow colors

      paramstruct = struct('icolor',2) ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 5 ;    %  Rainbow colors - by 5th entry

    [temp,vi] = sort(mdata(5,:)) ;
    mdata = mdata(:,vi) ;

      paramstruct = struct('icolor',2, ...
                           'savestr','RainbowColorTest') ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 6 ;    %  Two Colors - random

    mcol = [ones(n/2,1) * [0 1 0]; ...
            ones(n/2,1) * [1 0 1]] ;

      paramstruct = struct('icolor',mcol) ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 7 ;    %  Two colors - by 5th entry

    flag = (mdata(5,:) > median(mdata(5,:)))' ;
    mcol = flag * [0 1 0] + (1 - flag) * [1 0 1] ;

      paramstruct = struct('icolor',mcol, ...
                           'savestr','TwoColorTest') ;
    gausschkSM(mdata,paramstruct) ;


  elseif itest == 8 ;    %  



  
  end ;    %  of itest if-block

end ;    %  of itest loop


