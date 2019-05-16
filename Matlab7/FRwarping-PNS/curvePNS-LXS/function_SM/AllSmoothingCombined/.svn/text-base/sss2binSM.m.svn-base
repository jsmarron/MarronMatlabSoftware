function mcts = sss2binSM(data,xmin,xmax,nxg,ymin,ymax,nyg,bintype,bdryp) 
% SSS2BINSM, Function for SSS2, this bins density estimation data
%   Steve Marron's matlab function
%     Note:  the uses "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
% Inputs:
%      data - 2 column matrix of bivariate data
%                            X's in first column,  Y's in second
%                               (i. e. Cartesian coordinates)
%      xmin - lower endpoint of grid in x - direction
%      xmax - upper endpoint of grid in x - direction
%       nxg - number of gridpoints in x - direction
%      ymin - lower endpoint of grid in y - direction
%      ymax - upper endpoint of grid in y - direction
%       nyg - number of gridpoints in y - direction
%   bintype - type of binning:
%                      1  -  Nearest neighbor binning
%                      2  -  Linear binning
%     bdryp - boundary handling parameter
%                       0  -  truncate data outside range
%                       1 (or not specified)  -  move data outside range to
%                                   nearest endpoint
% Outputs:
%     mcts - matrix of bin counts
%                             In matrix coordinates 
%                             (i.e. x and y trade places, and y flips)
%

%    Copyright (c) J. S. Marron 1999, 2001




mcts = [] ;



%  rescale data to lie over integer grid
%
xrange = xmax - xmin ;
yrange = ymax - ymin ;

if  (xrange <= 0)  |  (yrange <= 0) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from sss1bin:            !!!') ;
  disp('!!!   Invalid binning range          !!!') ;
  disp('!!!   Returning empty count matrix   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  return ;
end ;


rsdata = nxg * (data(:,1) - xmin) / xrange ;
rsdata = [rsdata, nyg * (data(:,2) - ymin) / yrange] ;




%  Do Boundary Adjustment
%
flagxlo = (rsdata(:,1) <= 0) ;
flagxhi = (rsdata(:,1) >= nxg) ;
flagylo = (rsdata(:,2) <= 0) ;
flagyhi = (rsdata(:,2) >= nyg) ;

if bdryp == 0 ;    %  then truncate data outside boundary

  flagxin = ~(flagxlo | flagxhi) ;
  flagyin = ~(flagylo | flagyhi) ;
  flagin = flagxin & flagyin ;


  if sum(flagin) > 0 ;    %  then some data are within range, truncate rest
    rsdata = rsdata(flagin,:) ;
  else ;    %  no data within range, report error
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sss1bin:            !!!') ;
    disp('!!!   No data inside binning range   !!!') ;
    disp('!!!   Returning empty count matrix   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    return ;

  end ;

end ;



ndat = size(rsdata,1) ;
          %  number of data points is number of rows of data matrix





if bintype == 1 ;    %  then do nearest neighbor binning


  if bdryp ~= 0 ;    %  then move data to closest edge,
                     %  for nearest neighbor binning

    nxlo = sum(flagxlo) ;
    if nxlo > 0 ;    %  then some x's too low, move up
      rsdata(flagxlo,1) = 1 * ones(nxlo,1) ;
    end ;

    nxhi = sum(flagxhi) ;
    if nxhi > 0 ;    %  then some x's too high, move down
      rsdata(flagxhi,1) = nxg * ones(nxhi,1) ;
    end ;

    nylo = sum(flagylo) ;
    if nylo > 0 ;    %  then some y's too low, move up
      rsdata(flagylo,2) = 1 * ones(nylo,1) ;
    end ;

    nyhi = sum(flagyhi) ;
    if nyhi > 0 ;    %  then some y's too high, move down
      rsdata(flagyhi,2) = nyg * ones(nyhi,1) ;
    end ;

  end ;




  mcts = zeros(nxg,nyg) ;

  ix = ceil(rsdata(:,1)) ;
  iy = ceil(rsdata(:,2)) ;
          %  indices of nearest bin centers

  for i = 1:ndat ;

    mcts(ix(i),iy(i)) = mcts(ix(i),iy(i)) + 1 ;
          %  update this bincnt by 1

  end ;


else ;    %  then do linear binning


  if bdryp ~= 0 ;    %  then move data to closest edge,
                     %  for nearest neighbor binning

    nxlo = sum(flagxlo) ;
    if nxlo > 0 ;    %  then some x's too low, move up
      rsdata(flagxlo,1) = 0 * ones(nxlo,1) ;
    end ;

    nxhi = sum(flagxhi) ;
    if nxhi > 0 ;    %  then some x's too high, move down
      rsdata(flagxhi,1) = nxg * ones(nxhi,1) ;
    end ;

    nylo = sum(flagylo) ;
    if nylo > 0 ;    %  then some y's too low, move up
      rsdata(flagylo,2) = 0 * ones(nylo,1) ;
    end ;

    nyhi = sum(flagyhi) ;
    if nyhi > 0 ;    %  then some y's too high, move down
      rsdata(flagyhi,2) = nyg * ones(nyhi,1) ;
    end ;

  end ;



  mcts = zeros(nxg,nyg) ;

  ix = round(rsdata(:,1)) ;
  iy = round(rsdata(:,2)) ;
          %  indices of nearest 2x2 block centers


  delx = rsdata(:,1) - (ix - .5) ;
  dely = rsdata(:,2) - (iy - .5) ;
          %  weights to use in linear binning


  for idat = 1:ndat ;

    i = ix(idat) ;
    j = iy(idat) ;


    if  i == 0  &  j == 0 ;    %  in corner, but all mass in corner bin
      mcts(1,1) = mcts(1,1) + 1 ;

    elseif  i == 0  &  j == nyg ;    %  in corner, but all mass in corner bin
      mcts(1,nyg) = mcts(1,nyg) + 1 ;

    elseif  i == nxg  &  j == 0 ;    %  in corner, but all mass in corner bin
      mcts(nxg,1) = mcts(nxg,1) + 1 ;

    elseif  i == nxg  &  j == nyg ;    %  in corner, but all mass in corner bin
      mcts(nxg,nyg) = mcts(nxg,nyg) + 1 ;

    elseif  i == 0  ;    %  at edge, spread mass between 2 bins
      mcts(1,j) = mcts(1,j) + (1 - dely(idat)) ;
      mcts(1,j+1) = mcts(1,j+1) + dely(idat) ;

    elseif  i == nxg  ;    %  at edge, spread mass between 2 bins
      mcts(nxg,j) = mcts(nxg,j) + (1 - dely(idat)) ;
      mcts(nxg,j+1) = mcts(nxg,j+1) + dely(idat) ;

    elseif  j == 0  ;    %  at edge, spread mass between 2 bins
      mcts(i,1) = mcts(i,1) + (1 - delx(idat)) ;
      mcts(i+1,1) = mcts(i+1,1) + delx(idat) ;

    elseif  j == nyg  ;    %  at edge, spread mass between 2 bins
      mcts(i,nyg) = mcts(i,nyg) + (1 - delx(idat)) ;
      mcts(i+1,nyg) = mcts(i+1,nyg) + delx(idat) ;

    else ;     %  in central region, spread mass betwen 4 bins
      mcts(i,j) = mcts(i,j) + (1 - delx(idat)) * (1 - dely(idat)) ;
      mcts(i+1,j) = mcts(i+1,j) + delx(idat) * (1 - dely(idat)) ;
      mcts(i,j+1) = mcts(i,j+1) + (1 - delx(idat)) * dely(idat) ;
      mcts(i+1,j+1) = mcts(i+1,j+1) + delx(idat) * dely(idat) ;
          %  update bincnts
    end ;

  end ;


end ;   %  of bintype if-block




%  Convert to Matrix coordinates for image type analysis
%
mcts = rot90(mcts) ;


