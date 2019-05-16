function vindex = ClusterOrderSM(mdata,ilinkage) 
% ClusterOrder
%     Index of input data vectors in a hierarchical clustering
%     using:  Squared Euclidean distance
%     This is useful in heatmap visualizations as this index vector
%     provides intuitive visual orderings
%     Through giving leaf numbers of data points in full dendogram
%   Steve Marron's matlab function
% Inputs:
%     mdata     - d x n matrix of multivariate data
%                       (each col is a data vector)
%                       d = dimension of each data vector
%                       n = number of data vectors
%     ilinkage  - Choice of linkage method.  Currently supported:
%                       1 - 'average'  (default)
%                       2 - 'ward'
%
% Output:
%     vindex    - 1 x n vector of indices, showing where each 
%                       column belongs in the clustering order.
%                       Use this e.g. by plotting mdata(:,vindex)
%

%    Copyright (c) J. S. Marron 2018


d = size(mdata,1) ;
n = size(mdata,2) ;

%  Check Inputs
%
if nargin == 1 ;
  linkagestr = 'average' ;
else ;
  if ilinkage == 1 ;
    linkagestr = 'average' ;
  elseif ilinkage == 2 ;
    linkagestr = 'ward' ;
  else;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from ClusterOrderSM.m:          !!!') ; 
    disp('!!!   Invalid ilinkage input                !!!') ;
    disp('!!!   Resetting to default of Average       !!!') ; 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    linkagestr = 'average' ;
  end ;
end ;

%  Compute Linkage
%
Z = linkage(mdata',linkagestr) ;

%  Compute Indices, showing leaf numbers of each data point
%
vindex = optimalleaforder(Z,1 - eye(n)) ;


