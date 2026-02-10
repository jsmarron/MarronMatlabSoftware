function [c, vu] = modeSVfitSM(mdata,vv) 
%  MODESVFITSM, FIT of Singly joint V space MODE of Variation
%   Steve Marron's matlab function
%   For an input matrix of data,
%   assumed to be appropriately centered (double centered?),
%   and a given V, i.e. row space, vector vv
%      (e.g. from doubly joint analysis)
%   this calculates the best L2 fit by a single mode of variation
%   of the form:    c * u * vv'
%      (assuming vv is a unit vector, i.e. length 1)
%
% Inputs:
%
%   mdata    - d x n matrix of data
%
%   vv - n x 1 column vector = given right vector of mode
%
% Outputs:
%
%   c - scalar coefficient of mode of variation
%
%   vu - d x 1 column vector - left vector of mode
%


%    Copyright (c) J. S. Marron 2026

%  First check input
%
d = size(mdata,1) ;
n = size(mdata,2) ;

if ~((size(vv,1) == n) & (size(vv,2) == 1))     % invalid input
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from modeSVfitSM   !!!') ;
  disp('!!!   Invalid Input vv         !!!') ;
  disp('!!!   Giving empty returns     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  c = [] ;
  vu = [] ;

else     %  Do needed computations

  vv = vv / norm(vv) ;
    %  Be sure this is a unit vector

  vu = mdata * vv ;
      %  corresponding loadings vector

  c = norm(vu) ;
  vu = vu / c ;

end 

