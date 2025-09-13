function dirvec = DWD1SM(trainp,trainn,DWDpar)
% DWD1SM, Distance Weighted Discrimination DIRection vector
%   Steve Marron's matlab function
%     Essentially pared down version of hdd1SM.m
%
% Inputs:
%     trainp - d x n1 training data for the class "positive"
%     trainn - d x n2 training data for the class "negative"
%     DWDpar - penalty factor,
%                  (will adjust by median pairwise dist.
%                          100 is default)
%     
% Output:
%     dirvec - direction vector pointing towards positive class,
%                  unit vector (i.e. length 1)
%

%    Copyright (c) J. S. Marron 2002-2023



if nargin > 2    %  then have input a threshfact, so use it
  threshfact = DWDpar ;
else    %  then use default threshfact
  threshfact = 100 ;
end



global CACHE_SIZE   %#ok<GVMIS> % cache size in kbytes
global LOOP_LEVEL   %#ok<GVMIS> % loop unrolling level
CACHE_SIZE = 256;
LOOP_LEVEL = 8;
    %% set global variables for functions imported from LIPSOL


%  Compute median of pairwise distances squared between classes
%
np = size(trainp,2) ;
nn = size(trainn,2) ;
vpwdist2 = [] ;
for ip = 1:np
  pwdist2 = sum((vec2matSM(trainp(:,ip),nn) - trainn).^2,1) ;
  vpwdist2 = [vpwdist2 pwdist2] ; %#ok<AGROW>
end
medianpwdist2 = median(vpwdist2) ;

penalty = threshfact / medianpwdist2 ;
    %  threshfact "makes this large", 
    %  and 1 / medianpwdist2 "puts on correct scale"
%[w,beta,residp,residn,alp,totalviolation,dualgap,flag] = sepelimdwd(trainp,trainn,penalty) ;
[w,~,~,~,~,~,~,flag] = sepelimdwd(trainp,trainn,penalty) ;

if flag == -1
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from DWD1SM:                           !!!') ;
  disp('!!!   sep optimization gave an inaccurate solution   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
elseif flag == -2
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DWD1SM:                             !!!') ;
  disp('!!!   Infeasible or unbounded optimization problem   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  dirvec = [] ;
  return ;
end


dirvec = w / norm(w) ;





