function [vCPD,vCOD] = CanParDirSM(mX,mY,iout) 
% CanParDirSM, CANonical PARallel DIRection
%     For matrices of paired column vectors, 
%     finds the direction vCPD of maximal sum of paried distances
%     and the direction vCOD (Canonical Orthogonal Direction)
%     for intuitive display of parallelness in combined data set
%         Algorithm comes from Xuxin Liu dissertation (2007)
%         "New statistical tools for microarray data and 
%          comparison with existing tools" 
%   Steve Marron's matlab function
% Inputs:
%
%     mX    - d x n matrix of multivariate data
%                 (each col is a data vector)
%                 d = dimension of each data vector
%                 n = number of data vectors 
%
%     mY    - d x n matrix of multivariate data
%                 (each col is a data vector, 
%                     paried to columns of mX)
%                 d = dimension of each data vector
%                 n = number of data vectors 
%
%     iout  - scalar controlling output options:
%                 0 - calculate only vCPD (empty vCOD return)
%                 1 - calculate both vCPD and vCOD
%                 2 - calculate both, and plot (default) 
%
% Outputs:
%
%     vCPD  - Canonical Parallel Direction
%                 Direction (unit) vector in R^d that
%                 maximizes the sum of squared lengths of
%                 differences between corresponding columns
%
%     vCOD  - Canonical Orthogonal Direction
%                 Direction (unit) vector in R^d that is
%                 orthogonal to space of those differences
%                 that maximizes variation
%
%     Graphics in current figure (if requested)                 
%
% Assumes path can find personal function:
%    vec2matSM.m

%    Copyright (c) J. S. Marron 2026

%  Check Inputs
%
d = size(mX,1) ;
n = size(mX,2) ;
if ~((size(mX,1) == d) & (size(mX,2) == n))
    %  input mY has wrong size
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from CanParDirSM.m:       !!!') ; 
  disp('!!!   size of mX different from mY    !!!') ;
  disp('!!!   Giving empty returns            !!!') ; 
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vCPD = [] ;
  vCOD = [] ;
  return ;
end 

if nargin == 2
  iout = 2 ;
else
  if ~((iout == 0) | (iout == 1) | (iout == 2))
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from CanParDirSM.m:       !!!') ; 
    disp('!!!   Invalid iout                    !!!') ;
    disp('!!!   Resetting to default iout = 2   !!!') ; 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    iout = 2 ;
  end
end


%  Calculate vCPD
%
[vCPD,sv,~] = svds(mX - mY,1) ;
      %  First eigenvector


if iout >= 1     %  Calculate vCOD

  if d < 2 * n
      %  Cannot compute vCOD
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from CanParDirSM.m:       !!!') ; 
    disp(['!!!   (d = ' num2str(d) ')  <  (2n = ' num2str(2 * n) ')']) ;
    disp('!!!   Giving empty return vCOD        !!!') ; 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    vCOD = [] ;
    return ;
  end 

  [mQ,mR] = qr([(mX-mY) mY]) ;
  mQ2 = mQ(:,(n + 1):(2 * n)) ;
      %  last n columns of Q
  mXcent = mX - vec2matSM(mean(mX,2),n) ;
      %  Column Object Mean centered version of mX
  [vC,sv,~] = svds(mQ2' * mXcent * mXcent' * mQ2,1) ;
      %  First eigenvector
  vCOD = mQ2 * vC ;

  if iout == 2     %  Make graphic in current figure

    paramstruct = struct('icolor','k', ...
                         'idataconn',[(1:n)' ((n + 1):(2 * n))']) ;
    projplot2SM([mX mY],[vCOD vCPD],paramstruct) ;

  end 

else

  vCOD = [] ;     %  Empty return

end 

