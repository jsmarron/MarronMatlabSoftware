function [c, vv] = modeSUfitSM(mdata,vu) 
%  MODESUFITSM, FIT of Singly joint U space MODE of Variation
%   Steve Marron's matlab function
%   For an input matrix of data,
%   assumed to be appropriately centered (double centered?),
%   and a given U, i.e. column space, vector vu
%      (e.g. from doubly joint analysis)
%   this calculates the best L2 fit by a single mode of variation
%   of the form:    c * vu * v'
%      (assuming vu is a unit vector, i.e. length 1)
%
% Inputs:
%
%   mdata    - d x n matrix of data
%
%   vu - d x 1 column vector = given left vector of mode
%
% Outputs:
%
%   c - scalar coefficient of mode of variation
%
%   vv - n x 1 column vector - transpose is right vector of mode
%


%    Copyright (c) J. S. Marron 2026

%  First check input
%
d = size(mdata,1) ;
n = size(mdata,2) ;

if ~((size(vu,1) == d) & (size(vu,2) == 1))     % invalid input
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from modeSUfitSM   !!!') ;
  disp('!!!   Invalid Input vu         !!!') ;
  disp('!!!   Giving empty returns     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  c = [] ;
  vv = [] ;

else     %  Do needed computations

  vu = vu / norm(vu) ;
      %  Be sure this is a unit vector

  vv = mdata' * vu ;
      %  corresponding scores vector

  c = norm(vv) ;
  vv = vv / c ;

end ;


