function [bindat,bincent] = CHlbinrSM(data,vgridp,eptflag,ibtype) 
% CHLBINRSM, Censored Hazard Linear BINneR 
%   Steve Marron's matlab function
%     for binned censored density and hazard estimation
%     Does linear binning of censored data,
%     to an equally spaced grid.
%   Can use first 1, 2, 3, or 4 arguments.
% Inputs:
%     data   - n x 3 matrix of censored data:
%                  X's in first column,
%                  delta's in second column, with values:
%                      1 - when X is the actual value
%                      0 - when X is the (right) censoring time
%                            (i.e. the actual value is only
%                                  known to be larger)
%                  CDF values in third column, these are:
%                      1       for density estimation,
%                      1-F(X)  for hazard estimation,
%                      1-G(X)  for censored density estimation,
%                      1-L(X)  for censored hazard estimation,
%                         where these are empirical c.d.f.s
%                         evaluated at the data,
%                         G is the censoring c.d.f.,
%                             usually estimate by KMcdf,
%                         1-L = (1-F)*(1-G) 
%                         Note:  these get 1/(2*n) added, 
%                                to avoid 0 denominators
%                            (thus for density estimation purposes, 
%                             it might be good to renormalize at  
%                             end to make bin counts sum to n)
%                         CAUTION:  be sure these match the
%                                data appropriately,
%                                e.g. through sorting
%     vgridp - vector of grid parameters:
%                  0 (or not specified)  -  use endpts of data and 401 bins
%                  [le; lr]  -  le is left end, re is right, 401 bins
%                         (get error message and no return if le > lr)
%                  [le; lr; nb] - le left, re right, and nb bins
%    eptflag - endpoint truncation flag:
%                  0  -  move data outside range to nearest endpoint
%                  1 (or not specified)  -  truncate data outside range
%                        CAUTION:  this default is the opposite
%                            of lbinrSM, but makes sense, since
%                            often want to eliminate wierd edge
%                            effects in these settings
%     ibtype - flag indicating binning type:
%                  0 - Simple (histogram) binning
%                            Note:  for larger data sets, this is MUCH
%                                  faster than matlab's HIST.
%                  1 - (or unspecified) - Linear binning 
%                            (default, when ibtype not specified)
% Output:
%     bindat  - binned data:
%                  nb x 1 column vector of cdf weighted bin counts
%     bincent - nb x 1 vector of bin centers,
%                  can also get this from linspace(le,re,nb)'  
%

%    Copyright (c) J. S. Marron 2000-2001


xdat = data(:,1) ;
          %  unpack X values
vdel = data(:,2) ;
          %  unpack censoring values
vHbar = data(:,3) ;
          %  unpack 1 - cdf H values

n = length(xdat) ;

vHbar = vHbar + 1 / (2 * n) ;
%vHbar = vHbar + 10^(-12) ;


%  Set parameters and defaults according to number of input arguments
if nargin == 1 ;    %  only 1 argument input
  lend = min(xdat) ;
  rend = max(xdat) ;
  nbin = 401 ;
else ;              %  Then some grid parameters have been input
  if length(vgridp) == 1 ;    %  then use default grid
    lend = min(xdat) ;
    rend = max(xdat) ;
    nbin = 401 ;
  elseif length(vgridp) == 2 ;   % use given endpoints, but default number
    lend = vgridp(1) ;
    rend = vgridp(2) ;
    nbin = 401 ;
  else ;
    lend = vgridp(1) ;
    rend = vgridp(2) ;
    nbin = vgridp(3) ;
  end ;
end ;

if nargin <= 2 ;    %  Then at most 2 inputs, so use default endpt trunc.
  ieptflag = 1 ;    %  Default
else ;
  ieptflag = eptflag ;    %  Have value, so use it
end ;

if nargin <= 3 ;    %  Then at most 3 inputs, so use default bintype
  iibtype = 1 ;     %  Default
else ;
  iibtype = ibtype ;  %  Have value, so use it
end ;




if lend < rend ;   %  Have good end points, so proceed with binning

  %  Initialize count vector to 0
  bxdat = zeros(nbin,1) ;


  %  Work with data below bin range
  loflag = ((xdat - lend) < (10^(-10) * (rend - lend))) ;
          %  this is a "numerically more robust" version of "xdat<=lend"
  numlo = sum(loflag) ;
  if numlo > 0 ;    %  If there are some below left end

    if numlo == n ;    %  Then all the data is below the left end, so:
      disp('!!! Caution from CHlbinrSM: all data below binning range !!!') ;
    end ;

    if ieptflag ~= 1 ;    %  Then move data to end, not truncate
      bxdat(1) = bxdat(1) + ...
                     sum(vdel(loflag) ./ vHbar(loflag)) ;
    end ;

  end ;


  %  Work with data above bin range
  hiflag = ((xdat - rend) > -(10^(-10) * (rend - lend))) ;
          %  this is a "numerically more robust" version of "xdat >= rend"
  numhi = sum(hiflag) ;
  if numhi > 0 ;    %  If there are some above right end

    if numhi == n ;    %  Then all the data is above the right end, so:
      disp('!!! Caution from CHlbinrSM: all data above binning range !!!') ;
    end ;

    if ieptflag ~= 1 ;    %  Then move data to end, not truncate
      bxdat(nbin) = bxdat(nbin) + ...
                        sum(vdel(hiflag) ./ vHbar(hiflag)) ;
    end ;

  end ;


  %  Work with interior data
  iflag = (~loflag) & (~hiflag) ;        
  numi = sum(iflag) ;
  if numi > 0 ;    %  If there are some interior points

    ixdat = xdat(iflag) ;    %  Interior points
    iori = 1:n ;
    intiori = iori(iflag) ;  %  Indices (original system)
                             %  of the interior points

    isixdat = ((nbin - 1) * (ixdat - lend) ./ (rend - lend)) + 1 ;
          %  linear transformation, that maps  lend ---> 1
          %                              and   rend ---> nbin

    if iibtype == 0 ;    % Then do simple (histogram) binning

      vibinc = floor(isixdat + .5) ;
          %  indices of closest bin centers
      for idati = 1:numi ;    %  loop through data points in interior
        ioridati = intiori(idati) ;
          %  index of data point, in orignal system
        bxdat(vibinc(idati)) = bxdat(vibinc(idati)) + ...
                                vdel(ioridati) ./ vHbar(ioridati) ;
          %  put one in bin, for each data point
      end ;
          %  Implementation note:  Loops such as this seem to be needed,
          %  since the obvious matrix version:
          %       bxdat(vibinc) = bxdat(vibinc) + ones(numi,1)
          %  would not m updates, when there m duplications in vibinc,
          %  but instead would only do one (the last one).

    else ;    %  Then do linear binning (default)

      vibinl = floor(isixdat) ;
          %  indices of bin center to left (integer part of isixdat)
      vwt = isixdat - vibinl ;
          %  weights to use in linear binning (fractional part)

      for idati = 1:numi ;    %  loop through data points in interior
        ioridati = intiori(idati) ;
          %  index of data point, in orignal system
        bxdat(vibinl(idati)) = bxdat(vibinl(idati)) + ...
                                 (1 - vwt(idati)) .* ...
                                vdel(ioridati) ./ vHbar(ioridati) ;
          %  update of bins on left side
          %  put (1 - wt) in bin, for each data point
        bxdat(vibinl(idati) + 1) = bxdat(vibinl(idati) + 1) + ...
                                 vwt(idati) .* ...
                                vdel(ioridati) ./ vHbar(ioridati) ;
          %  update of bins on right side
          %  put wt in bin, for each data point
      end ;
    end ;

  end ;


  %  Combine results, and output
  bindat = bxdat ;
  bincent = linspace(lend,rend,nbin)' ;


else ;    %  Then give error message since range is invalid
  disp('!!!   Error in CHlbinrSM: invalid binning range   !!!') ;
end ;

