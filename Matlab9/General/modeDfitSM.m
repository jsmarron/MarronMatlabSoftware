function c = modeDfitSM(mdata,vu,vv) 
%  MODESVFITSM, FIT of Doubly joint MODE of Variation
%   Steve Marron's matlab function
%   For an input matrix of data,
%   assumed to be appropriately centered (double centered?),
%   and given U & V, i.e. column and row space, vectors vu & vv
%      (e.g. from doubly joint analysis)
%   this calculates the best L2 fit by a single mode of variation
%   of the form:    c * vu * vv'
%      (assuming vu & vv are unit vectors, i.e. length 1)
%
% Inputs:
%
%   mdata    - d x n matrix of data
%
%   vu - d x 1 column vector - left vector of mode
%
%   vv - n x 1 column vector = given right vector of mode
%
% Outputs:
%
%   c - scalar coefficient of mode of variation
%


%    Copyright (c) J. S. Marron 2026

%  First check input
%
d = size(mdata,1) ;
n = size(mdata,2) ;

if ~((size(vu,1) == d) & (size(vu,2) == 1))     % invalid vu input
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from modeDfitSM   !!!') ;
  disp('!!!   Invalid Input vu         !!!') ;
  disp('!!!   Giving empty returns     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  c = [] ;
  vv = [] ;

else     %  Move on to check vv

  if ~((size(vv,1) == n) & (size(vv,2) == 1))     % invalid vv input
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from modeDfitSM   !!!') ;
    disp('!!!   Invalid Input vv         !!!') ;
    disp('!!!   Giving empty returns     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    c = [] ;
    vu = [] ;

  else     %  Do needed computations

    vu = vu / norm(vu) ;
    vv = vv / norm(vv) ;
          %  Be sure these are unit vectors

    munitmode = vu * vv' ;
        %  unit free matrix version
    vunitmode = reshape(munitmode,d * n,1) ;
    vdata = reshape(mdata,d * n,1) ;
        %  d*n vector versions
    c = vunitmode' * vdata ;


  end     %  of inner vv if-block

end     %  of outer vu if-block


