function CurveOut = MedianRescaleSM(CurveIn,Target) 
% MedianRescaleSM, Finds RESCALing of (digitized) input curve, 
%     that gives best least MEDIAN fit to target curve.
%     Since 0 entries of either vector can't be rescaled, 
%     these are excluded from the median calculation, but included 
%     in rescaling.  Note: this is intended for nonnegative curves,
%     such as histograms of counts.  May give strange results for
%     curves that take on negative values.
%   Steve Marron's matlab function
% Inputs:
%   CurveIn - vector of digitized values of curve to be rescaled
%    Target - vector of digitized values of target curve
%                 (must have same length as CurveIn)
% Output:
%   CurveOut - vector of same length as input vectors, which is the
%                  rescaling of CurveIn, that "best fits" the Target
%                  curve, in the sense of least median distance.
%

%    Copyright (c) J. S. Marron 2009



if  (size(CurveIn,1) ~= size(Target,1))  | ...
    (size(CurveIn,2) ~= size(Target,2))  | ...
    ((size(CurveIn,1) > 1) & (size(CurveIn,2) > 1)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from MedianRescaleSM:                  !!!') ;
  disp('!!!   Input must be vectors with same dimensions   !!!') ;
  disp('!!!   Returning empty result                       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  CurveOut = [] ;
  return ;
end ;



%  Define flag where either entry is 0 (thus not part of the rescaling process)
%
maxinput = max(abs(CurveIn)) ;
flag0 = ((abs(CurveIn) / maxinput) < 10^(-12)) ;
    %  one in locations where CurveIn is essentially 0
maxinput = max(abs(Target)) ;
flag0 = flag0 | ((abs(Target) / maxinput) < 10^(-12)) ;
    %  one in locations where either CurveIn or Target is essentially 0


if sum(~flag0) > 0 ;    %  then have some non-zero elements, so rescale

  %  Find median of difference of logs
  %
  mdl = median(log(Target(~flag0)) - log(CurveIn(~flag0))) ;


  %  Use median to rescale entire curve
  %
  CurveOut = exp(mdl) * CurveIn ;

else ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from MedianRescaleSM:    !!!') ;
  disp('!!!   Can''t rescale, since no        !!!') ;
  disp('!!!   common nonzero entries         !!!') ;
  disp('!!!   Returning empty result         !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  CurveOut = [] ;

end ;

