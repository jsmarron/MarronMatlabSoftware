function [cdfy,svdata,svcensor] = LBcdfSM(vdata,vcensor,ipresorted) 
% KMCDFSM, Length Biased Cumulative Distribution Function
%   Steve Marron's matlab function
%      The maximum likelihood estimate of the c.d.f. 
%      under right censoring.
%  Can use use 2 or 3 inputs
%
% Inputs:
%       vdata - column vector of data (the X values)
%     vcensor - vector of censoring indicators (must have the 
%                          same length as vdata), with values:
%                   1 - when X is the actual value
%                   0 - when X is the (right) censoring time
%                          (i.e. the actual value is only
%                                known to be larger)
%                       these can be either real or logical values
%                       (set them all to one for no censoring)
%  ipresorted - indicator that allows skipping sort step
%                   1 - assume data are presorted
%                   0 - (default) do sort of the data
%
% Outputs:
%        cdfy - the Y values of the length biased c.d.f.
%                   (right continuous version), evaluated at
%                   the jump points.  Thus the corresponding
%                   X values are vdata.
%                   CAUTION:  If a sort is done here, then
%                       these X values must also be sorted.
%                       Safest approach is to sort first.
%      svdata - the corresponding X values, i.e. sorted 
%                       version of vdata.  This is only 
%                       useful if a sort has been done.
%    svcensor - sorted version of vcensor
%                       This is only useful if a sort has been done.
%
% Assumes path can find personal functions:
%    KMcdfSM.m

%    Copyright (c) J. S. Marron 2001-2004



%  Set default (if needed)
%
if nargin <= 2 ;    %  no indicator given
  isort = 1 ;       %  so do a sort
else ;
  isort = 1 - ipresorted ;
                    %  if data are presorted, then don't sort
                    %  if data are not presorted, then sort
end ;



%  test inputs
%
if  min(size(vdata)) > 1  |  min(size(vcensor)) > 1 ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from KMcdf.m:      !!!') ;
  disp('!!!   Inputs must be vectors   !!!') ;
  disp('!!!   Terminating Execution    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  return ;

end ;

if length(vdata) ~= length(vcensor) ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from KMcdf.m:            !!!') ;
  disp('!!!   Inputs must have same length   !!!') ;
  disp('!!!   Terminating Execution          !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  return ;

end ;

if sum(~(vcensor == 0  |  vcensor == 1)) > 0 ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from KMcdf.m:                  !!!') ;
  disp('!!!   vcensor must contain all 0''s & 1''s   !!!') ;
  disp('!!!   Terminating Execution                !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  return ;

end ;

if size(vdata,2) > 1 ;    %  then need to turn this row
                          %  vector into a column vector
  disp('!!!   Warning from KMcdf.m:         !!!') ;
  disp('!!!   turning the row vector vdata  !!!') ;
  disp('!!!   into a column vector          !!!') ;

  vdata = vdata' ;

end ;

if size(vcensor,2) > 1 ;    %  then need to turn this row
                            %  vector into a column vector
  disp('!!!   Warning from KMcdf.m:           !!!') ;
  disp('!!!   turning the row vector vcensor  !!!') ;
  disp('!!!   into a column vector            !!!') ;

  vcensor = vcensor' ;

end ;



%  Do sort if needed
%
if isort ~= 0 ;
  [vdata, vind] = sort(vdata) ;
  vcensor = vcensor(vind) ;
end ;



%  Do main calculation
%
n = length(vdata) ;
vgbar = 1 - KMcdfSM(vdata,1-vcensor,1) ;
          %  already sorted, so set ipresort to 1
vgbartrunc = vgbar + 1 / (2 * n) ;
cdfy = cumsum(vcensor ./ (vdata .* vgbartrunc)) / n ;
mu = 1 / cdfy(n) ;
cdfy =  mu * cdfy ;

svdata = vdata ;
svcensor = vcensor ;


