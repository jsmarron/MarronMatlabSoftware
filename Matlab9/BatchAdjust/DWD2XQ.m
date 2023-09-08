function [dirvec,beta,dr] = DWD2XQ(trainp,trainn,weight,testdata,DWDpar)
% DWD2XQ, Distance Weighted Discrimination 
%   Improves the original DWD1SM by properly handling imbalanced classes,
%   and also allows other types of weights, when needed.
%   In addition to giving the direction vector, this also gives the 
%   "cutoff" value, beta, and will do classification of a new data set.
%
%   Xingye Qiao has written this code based on Mike Todd, J.S. Marron, 
%   Brent Johnson and Hao (Helen) Zhang's work.
%
% Inputs:
%
%     trainp   - d x np training data for the class "positive"
%
%     trainn   - d x nn training data for the class "negative"
%
%     weight   - scalar, or 1 x 2 vector of weights for binary classes.
%                  for scalar 1, will set to [1,1] 
%                      (the old default of conventional DWD)
%                  for scalar 2, will set to [nn,np]/(np+nn) 
%                      (current default for correct handling 
%                             of unbalanced classes)
%                  for 1 x 2 vector, use input numbers as weights
%                (this input is optional, default is 2)
%
%     testdata - d x nt additional (testing) data set to be classified
%                (this input is optional, default is [] for no 
%                       classification and dr is returned as [])
%
%     DWDpar   - penalty factor in DWD optimization,
%                  actual parameter is DWDpar / median pairwise dist 
%                (this input is optional, default is 100)
%     
% Outputs:
%
%     dirvec - direction vector pointing towards positive class,
%                  unit vector (i.e. length 1)
%
%     beta - intercept which indicates the separating hyperplane. A data
%            vector x will be classified as positive if dirvec' * x + beta > 0
%                Note: to show cutoff on projection plot, use -beta
%
%     dr   - 1 x nt classification result for testing data. +1 for positive
%            class and -1 for negative class.
%

%    Copyright (c) J. S. Marron 2002-2012, Xingye Qiao 2009-2010


global CACHE_SIZE   % cache size in kbytes
global LOOP_LEVEL   % loop unrolling level
CACHE_SIZE = 256 ;
LOOP_LEVEL = 8 ;

np = size(trainp,2) ;
nn = size(trainn,2) ;

%  Adjust input parameters
%-
if nargin > 4 ;    %  then have input a threshfact, so use it
  threshfact = DWDpar ;
else ;    %  then use default threshfact
  threshfact = 100 ;
end ;

if ~(nargin > 3) ;    %  then don't have test data, so set to empty
  testdata = [] ;
  dr = [] ;
end ;

if ~(nargin > 2) ;    %  then don't have weight specified, so set to default
  weight = 2 ;
end ;


%  Check dimensions of training data 
%
dtp = size(trainp,1) ;
dtn = size(trainn,1) ;
if ~(dtp == dtn) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DWD2XQ.m                      !!!') ;
  disp(['!!!   Dimension of positive training set is ' num2str(dtp)]) ;
  disp(['!!!   Dimension of negative training set is ' num2str(dtn)]) ;
  disp('!!!   But these must be the same               !!!') ;
  disp('!!!   Terminating Execution                    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  dr = [] ;
  dirvec = [] ;
  beta = [] ;
  return ;
end ;

if ~isempty(testdata) ;
  dtest = size(testdata,1) ;
  if ~(dtp == dtest) ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from DWD2XQ.m                      !!!') ;
    disp(['!!!   Dimension of training data set is ' num2str(dtp)]) ;
    disp(['!!!   Dimension of testing data set is ' num2str(dtest)]) ;
    disp('!!!   But these must be the same               !!!') ;
    disp('!!!   Terminating Execution                    !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    dr = [] ;
    dirvec = [] ;
    beta = [] ;
    return ;
  end ;
end ;


%  Calculate penalty
%
vpwdist2 = [] ;
for ip = 1:np ;
  pwdist2 = sum((vec2matSM(trainp(:,ip),nn) - trainn).^2,1) ;
  vpwdist2 = [vpwdist2 pwdist2] ;
end ;
medianpwdist2 = median(vpwdist2) ;

penalty = threshfact / medianpwdist2 ;
    %  threshfact "makes this large", 
    %  and 1 / medianpwdist2 "puts on correct scale"


%  Set weights of binary classes
%
if weight == 1 ;
    weight = [1,1] ;
elseif weight == 2 ;
    weight = [nn,np]/(np+nn) ;
elseif  ~((max(size(weight)) == 2) & (min(size(weight)) == 1))  | ...
           min(weight) < 0 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DWD2XQ:       !!!') ;
  disp('!!!   Invalid input: weight    !!!') ;
  disp('!!!   Terminating execution    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  dr = [] ;
  dirvec = [] ;
  beta = [] ;
  return ;
end ;

% set penalty parameters and weight parameters in DWD framework
%
ppp = ones(np,1) * weight(1) * penalty ;
ppn = ones(nn,1) * weight(2) * penalty ;
wtp = ones(np,1) * weight(1) ;
wtn = ones(nn,1) * weight(2) ;

nonlin=0;

[w,beta,residp,residn,alp,totalviolation,dualgap,flag]...
    = sepelimdwdnonlinXQ(trainp,trainn,penalty,nonlin,ppp,ppn,wtp,wtn) ;

if flag == -1 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from DWD2XQ:                           !!!') ;
  disp('!!!   sep optimization gave an inaccurate solution   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
elseif flag == -2 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DWD2XQ:                             !!!') ;
  disp('!!!   Infeasible or unbounded optimization problem   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  dr = [] ;
  dirvec = [] ;
  beta = [] ;
  return ;
end ;

dirvec = w / norm(w) ; % normalize w and beta by norm of w
beta= beta / norm(w) ;


if ~isempty(testdata) ;    %  then classify additional data set
  dr = dirvec' * testdata + beta >= 0 ;  %  1 where choose plus class, 0 otherwise
  dr = 2 * dr - 1 ;  %  1 where choose plus class, -1 otherwise
else ;
  dr = [] ;
end ;

