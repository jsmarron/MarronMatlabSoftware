function vdata = nmdataSM(nobs,vmu,vsig2,vw) 
% NMDATASM, Normal Mixture pseudo random DATA generator
%   Steve Marron's matlab function
%   Can use 2 or 4 arguments.
% Inputs:
%     nobs - Number of observations desired
%      vmu - Column vector of means
%             or if no other arguments, a 3 column matrix of:
%                  means, variances and weights
%    vsig2 - Column vector of variances
%       vw - Column vector of weights (should sum to 1)
% Output:
%    vdata - nobs x 1 column vector of normal mixture
%
%   Uses both MATLAB functions RAND & RANDN, recall seeds are currently set by:
%      "rng(...)"
%   was formerly set by
%      "rand('seed',...) ;"   and   "randn('seed',...)".
%

%    Copyright (c) J. S. Marron 1996-2023


%  Set parameters according to number of input arguments
%
if nargin == 2        %  only 1 argument input, use columns as params
  w = vmu(:,3) ;
  sig2 = vmu(:,2) ;
  mu = vmu(:,1) ;
elseif nargin == 4    %  then parameter vector vectors input separately
  mu = vmu ;
  sig2 = vsig2 ;
  w = vw ;
end 

sig = sqrt(sig2) ;
ncomp = length(mu) ;
          %  number of components

%  Get initial vector of N(0,1)'s
vdata = randn(nobs,1) ;


%  Get vector of indices 1,...,ncomp. w.p. w
vunif = rand(nobs,1) ;
          %  Unif(0,1)
vind = ones(nobs,1) ;
cumw = cumsum(w) ;
for icomp = 2:ncomp 
  flag = (vunif > cumw(icomp - 1)) ;
  vind(flag) = icomp * ones(sum(flag),1) ;
end 


%  Do mean and var adjustment according to vind
vdata = mu(vind) + sig(vind) .* vdata ;


