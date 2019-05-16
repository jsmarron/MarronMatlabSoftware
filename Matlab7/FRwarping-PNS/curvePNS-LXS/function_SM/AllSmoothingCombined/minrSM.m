function vmin = minrSM(vx,vy,lflag,iout) 
% MINRSM, General Purpose MINimizeR.
%   Steve Marron's matlab function
%     Fits quadratic near smallest value, as approx to continuous min.
%     In case of ties, finds the first one.
%   Can use first 2, 3 or 4 arguments.
% Inputs:
%     vx    - column vector of arguments of a function to minimize
%     vy    - col. vec. of corresponding values of the func. to min.
%     lflag - local min handling flag.  Finds:
%                 smallest local min, when lflag < 0
%                         global min, when lflag = 0 (or not specified)
%                  largest local min, when lflag > 0
%     iout  - integer for type of output:
%                1 (or not included) - output only minimizing x value
%                2      - output vec. with x and number of local mins
%                3      - output vec. with x, #min's and "error flag".
% Output:
%    vmin  - column vector with:
%               minimizing x, when iout = 1 (or not included in call)
%               min'ing x and #min's, when iout = 2
%               min'ing x, #min's, and "error flag" when iout = 3
%                     error flag has values:
%                            = -1, when left end is hit
%                            = 0,  when min is in interior
%                            = 1,  when right end is hit
% See also: rootfSM.m

%    Copyright (c) J. S. Marron 1996-2001

%  Set parameters and defaults according to number of input arguments
if nargin == 2 ;    %  only 2 arguments input
  ilflag = 0 ;      
          %  Use default: Global minimizer
else ;              %  more than two arguments input
  ilflag = lflag ;
          %  Use input local minimizer flag
end ;
if nargin <= 3 ;    %  2 or 3 arguments input
  iiout = 1 ;
          %  Use default: Output only minimizing value
else ;              %  4 argumnets input
  iiout = iout ;
          %  Use input choice of output type
end ;

nx = length(vx) ;


%  Find index of important local min
ymax2 = 2 * max(abs(vy)) ;
difs = [vy; ymax2] - [ymax2; vy] ;
posflag = (difs >= 0) ;
          %  flag where difs are positive
negflag = (difs <= 0) ;
          %  flag where difs are negative
minflag = [1; negflag] .* [posflag; 1] ;
          %  flags local minima
nmin = sum(minflag) ;
          %  number of local minima
if ilflag < 0 ;
  [temp, imin] = max(minflag) ;
  imin = imin - 1 ;
          %  index of first min
elseif ilflag > 0 ;
  [temp, imin] = max(flipud(minflag)) ;
  imin = nx + 2 - imin ;
          %  index of first min
else ;
  [temp, imin] = min(vy) ;
end ;


%  Check endpts
if imin <= 1 ;
  disp('!!!   Warning: minrSM hit left end   !!!') ;
  xmin = vx(1) ;
  errflag = -1 ;
elseif imin >= nx ;
  disp('!!!   Warning: minrSM hit right end   !!!') ;
  xmin = vx(nx) ;
  errflag = 1 ;
else ;     % have min in interior, so fit a parabola
  locx = vx((imin-1):(imin+1)) ;
  locy = vy((imin-1):(imin+1)) ;
          %  x & y values around min
  pcoeffs = polyfit(locx,locy,2) ;
          %  Coefficients of interpolating quadratic
  dcoeffs = polyder(pcoeffs) ;
          %  Coefficients of derivative of quadratic
  xmin = roots(dcoeffs) ;
          %  vector of roots, which give approx to min'r
  errflag = 0 ;
end ;


%  Construct output vector
if iiout == 1 ;   %  then only output x to min
  vmin = xmin ;
elseif iiout == 2 ;   %  then output x & # local mins
  vmin = [xmin; nmin] ;
elseif iiout == 3 ;   %  then output x, # mins, and errflag
  vmin = [xmin; nmin; errflag] ;
end ;

