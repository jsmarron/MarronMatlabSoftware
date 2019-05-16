function [dirvec,beta] = SVMdir1SM(trainp,trainn,SVMpar) ;
% SVM1SM, Support Vector Machine DIRection vector
%   Steve Marron's matlab function
%     Essentially pared down version of hdd1SM.m
%     Based on Mike Todd's sepelimsvm.m
%
% Inputs:
%     trainp - d x n1 training data for the class "positive"
%     trainn - d x n2 training data for the class "negative"
%     SVMpar - penalty factor,
%                  (SVMpar = C, when >= 0,
%                   SVMpar = penalty factor, when < 0
%                        (will adjust by median pairwise dist.)
%                  SVMpar = 1000 is default
%     
% Outputs:
%     dirvec - direction vector pointing towards positive class,
%                  unit vector (i.e. length 1)
%
%     beta - intercept which indicates the separating hyperplane. 
%            Classify the vector x as positive when:
%                               dirvec' * x + beta > 0
%                Note: to show cutoff on projection plot, use -beta
%
%

%    Copyright (c) J. S. Marron 2005-2016



if nargin > 2 ;    %  then have input a threshfact, so use it
  threshfact = SVMpar ;
else ;    %  then use default threshfact
  threshfact = 1000 ;
end ;


d = size(trainp,1) ;
np = size(trainp,2) ;
nn = size(trainn,2) ;

if threshfact < 0 ;    %  then have signalled should adjust using
                       %  median pairwise dist.

  %  Compute median of pairwise distances squared between classes
  %
  vpwdist2 = [] ;
  for ip = 1:np ;
    pwdist2 = sum((vec2matSM(trainp(:,ip),nn) - trainn).^2,1) ;
    vpwdist2 = [vpwdist2 pwdist2] ;
  end ;
  medianpwdist2 = median(vpwdist2) ;

  C = -threshfact / medianpwdist2 ;
      %  threshfact "makes this large", 
      %  and 1 / medianpwdist2 "puts on correct scale"
      %      [recall minus sign unencodes parameter]

else ;

  C = threshfact ;

end ;

global CACHE_SIZE   % cache size in kbytes
global LOOP_LEVEL   % loop unrolling level
CACHE_SIZE = 256;
LOOP_LEVEL = 8;
    %% set global variables for functions imported from LIPSOL

[w,beta,residp,residn,alp,totalviolation,dualgap,flag] = sepelimsvm(trainp,trainn,C) ;


if flag == -1 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from SVM1SM:                           !!!') ;
  disp('!!!   sep optimization gave an inaccurate solution   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
elseif flag == -2 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SVM1SM:                             !!!') ;
  disp('!!!   Infeasible or unbounded optimization problem   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  dr = [] ;
  dirvec = [] ;
  return ;
end ;

dirvec = w / norm(w) ;




