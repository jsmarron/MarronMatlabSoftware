function SWISSscore = SWISSpwCC(mdata,groups,optionin) 
% Multiclass PairWise version of SWISS, Standardized WithIn class Sum of Squares 
%   Calculates Pairwise SWISS scores then takes average   
%        which is the preferred version for multiple classes  
%   Essentially Chris Cabanski's matlab function, PWSWISS.m
%        but renamed to make it easier to find
%   Note: this only computes pw SWISS score, does not do permutation 
%           test as in SWISSoriCC.m
%
% Inputs:
%     mdata      - (d x n) matrix with d genes and n samples
%     groups     - (n x 1) vector with labels (1,2,3,...,k) for each group
%     optionin   - option for centering
%		                   1 - (default) usual sum of squares decomposition 
%                            (uses overall mean)
%		                   2 - uses mean of the group means 
%                            (this weighs all groups equally)
%
% Output:
%     SWISSscore - Pairwise SWISS score 
%

%    Copyright (c) Chris Cabanski, J. S. Marron, 2010-2015



SWISSscore = [] ;
    %  Start with empty definition, in case of error

if nargin < 2 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SWISSpwCC:              !!!') ;
  disp('!!!   Not enough inputs,                 !!!') ;
  disp('!!!   mdata,                             !!!') ;
  disp('!!!   groups,                            !!!') ;
  disp('!!!   are both required                  !!!') ;
  disp('!!!   Terminating Execution              !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;

%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2 ;   %  then optionin is an argument, so use it

  opt = optionin ;

else ;    %  no optionin specified, use default

  opt = 1 ;

end ;    %  of resetting of input parameters


n = size(mdata,2) ;
d = size(mdata,1) ;

if min(size(groups)) > 1 ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SWISSpwCC: groups must be a vector        !!!') ; 
  disp('!!!   Terminating Execution                                !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;

if length(groups) ~= n ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SWISSpwCC:                !!!') ; 
  disp(['!!!   length of groups must be n = ' num2str(n)]) ; 
  disp('!!!   Terminating Execution                !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;

k = max(groups) ;
if min(groups) ~= 1 ;    %  print warning message
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from SWISSpwCC: groups labeling does not        !!!') ; 
  disp('!!!   start at 1, Terminating Execution                     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;



pws = [] ;
for ii = 1:k-1 ;
  for jj = ii+1:k ;
    temp1 = [] ;
    temp2 = [] ;
    for mm = 1:n ;   % calculate classes
      if groups(mm) == ii ;
        temp1 = [temp1, mdata(:,mm)] ;
      elseif groups(mm) == jj ;
        temp2 = [temp2, mdata(:,mm)] ;
      end ;
    end ;
    n1 = size(temp1,2) ;
    n2 = size(temp2,2) ;
    groups2 = [ones(n1,1); 2*ones(n2,1)] ;
    data = [temp1 temp2] ;
    nn = n1 + n2 ;
    k2 = 2 ;

    % Calculate group means (gmean), number of elts in each group (tempn)
    %
    gmeanA = zeros(d,k2) ;
    tempn = zeros(k2,1) ;
    for i = 1:k2 ;
      temp = zeros(d,1) ;
      for j = 1:nn ;
        if groups2(j) == i ;
          temp = [temp,data(:,j)] ;
        end;
      end;
      tempn(i) = size(temp,2) - 1 ;
      rmeanA = zeros(d,1) ;
      for m = 1:d ;
        rmeanA(m) = 0 ;
        for j = 1:tempn(i) ;
         rmeanA(m) = rmeanA(m) + temp(m,j+1) ;
       end ;
         rmeanA(m) = rmeanA(m) / tempn(i) ;
      end;
      centdatA = zeros(d,tempn(i)) ;
      for m = 1:d ;
        for j = 1:tempn(i) ;
      centdatA(m,j) = temp(m,j+1) - rmeanA(m) ;
        end ;
      end;
      gmeanA(:,i) = rmeanA ;
    end ;

    % Calculate overall mean (center)
    %
    omeanA = zeros(d,1) ;
    if opt == 1 ;
      for i = 1:d ;
        omeanA(i,1) = sum(data(i,:)) / nn ;
      end ;
    elseif opt == 2 ;
      for i = 1:d ;
        omeanA(i,1) = sum(gmeanA(i,:)) / k2 ;
      end; 
    else;    %  print warning message
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from SWISS: option does not equal 1, 2, or 3         !!!') ; 
      disp('!!!   returning empty matrix                                       !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      return ;
    end ;

    % Calculate distance matrices
    %
    distA = zeros(2,nn) ;
    for i = 1:nn ;
      g = groups2(i) ;
      distA(1,i) = sum((data(:,i)-gmeanA(:,g)).^2) ;
      distA(2,i) = sum((data(:,i)-omeanA).^2) ;
    end ;

    % Calculate Ratio A
    %
    RatioA = sum(distA(1,:)) / sum(distA(2,:)) ;
    pws = [pws; RatioA] ;

  end ;    %  of jj for-loop

end ;    %  of ii for-loop


SWISSscore = mean(pws) ;


