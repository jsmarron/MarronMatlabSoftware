function outstruct = DIVASDoubJointSM(mX,mY,paramstruct) 
% DIVAS Doubly Joint version
%     For matrices with both rows (scores) and columns (loadings) 
%     that correspond, does doubly joint (then other) decompositions
%     in an iterative fashion, stopping when there seems to be no 
%     remaining signal (or at a pre-specified number of steps)
%
%
% Inputs:
%   mX          - d x n matrix of X data
%                     Recommend both row and column recentering first
%
%   mY          - d x n matrix of Y data
%                     with corresponding rows and columns
%                     Recommend both row and column recentering first
%
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1, ...
%                            'field2',values2, ...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    imptype          implementation type:
%                          1 - original greedy implementation
%                                  from DoublyJointToy8.m
%                          2 - QZ based implementation
%                                  from DoublyJointToy9.m
%    
%    iScaleStand      indicator for Scale Standardization 
%                          0 - Do not Scale Standardize
%                                  In this case, each data block should have
%                                  overall noise standard deviation 1
%                          1 - (default) Estimate overall standard 
%                                  deviation for each block and
%                                  rescale each
%
%    nmaxstep         maximum number of steps (default of 10)
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%
% Outputs:
%     Graphics in current Figure
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
%
% Assumes path can find personal functions:
%    modeDfitSM
%    modeSUfitSM
%    modeSVfitSM
%    modeIfitSM
%

%    Copyright (c) J. S. Marron 2026


%  First set all parameters to defaults
%
imptype = 1 ;
iScaleStand = 1 ;
nmaxstep = 10 ;
iscreenwrite = 0 ;

%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2   %  then paramstruct is an argument

  if isfield(paramstruct,'imptype')    %  then change to input value
    imptype = paramstruct.imptype ;
  end

  if isfield(paramstruct,'iScaleStand')    %  then change to input value
    iScaleStand = paramstruct.iScaleStand ;
  end

  if isfield(paramstruct,'nmaxstep')    %  then change to input value
    nmaxstep = paramstruct.nmaxstep ;
  end

%{
  if isfield(paramstruct,'')    %  then change to input value
     = paramstruct. ;
  end
%}

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ;
  end

end    %  of resetting of input parameters


if iscreenwrite == 1 
  disp('Running function DIVASDoubJointSM.m') ;
  disp(' ') ;
end


%  Check input data
%
d = size(mX,1) ;
         %  number of rows of input mX
n = size(mX,2) ;
         %  number of columns of input mX
if  (size(mY,1) ~= d)  |  (size(mY,2) ~= n)
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DIVASDoubJointSM.m:   !!!') ;
  disp('!!!   Inputs mX and mY must have       !!!') ;
  disp('!!!   the same dimensions              !!!') ;
  disp('!!!   Terminating execution            !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  outstruct = 'Not defined yet' ;
  return ;
end


%  Estimate noise levels for each input and normalize
%
beta = min(d,n) / max(d,n) ;
    %  Marcenko Pasturnparameter
[mU_X,dmlam_X,mV_X] = svd(mX,'econ') ;
[mU_Y,dmlam_Y,mV_Y] = svd(mY,'econ') ;
    %  minimal rank versions of svd
    %  Organized as o. n. Basis matrices 
    %  diagonal matrix of singular values
vlam_X = diag(dmlam_X) ;
vlam_Y = diag(dmlam_Y) ;
    %  vectors of singular values
if iScaleStand == 1     %  Need to standardize

  %  Calculate Emma Mitchell's estimate of noise standard deviation
  %  Described in her PhD dissertation:
  %      "STATISTICAL METHODS FOR GENOMIC DATA ANALYSIS"
  %
  c = min(d,n) / max(d,n) ;
  SigEstX = TriME(c,vlam_X/max(d,n),1,'/temp',0.01,0,0.25,false) ;
  SigEstY = TriME(c,vlam_Y/max(d,n),1,'/temp',0.01,0,0.25,false) ;
      %  1 and '/temp' not relevant, since don't make graphics
      %  Other parameters are defaults suggested in dissertation:
      %      alpha1 = 0.01 
      %      alpha2 = 0
      %      omega = 0.25
      %  sve = false turns off graphics

  mXs = mX / SigEstX ;
  mYs = mY / SigEstY ;
      %  Normalize so noise part of each block has overall SD 1

else     %  Proceed with original data

  mXs = mX ;
  mYs = mY ;

end 


if imptype == 1     %  Original greedy implementation
                    %      from DoublyJointToy8.m









%nmaxstep




  outstruct = 'Not defined yet' ;


elseif imptype == 2     %  QZ based implementation
                        %      from DoublyJointToy9.m


  outstruct = 'Not defined yet' ;


else ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DIVASDoubJointSM   !!!') ;
  disp('!!!   Invalid value of imptype      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

end     %  of imptype if-block


