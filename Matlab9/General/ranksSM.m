function vranks = ranksSM(data,itiebreak) 
% RANKSSM, RANKS of data
%     Gives ranks, i.e. label indicating relative size
%   Can use 1 or 2 arguments.
%   Steve Marron's matlab function
% Inputs:
%     data    - column vector of data, a single data set
%   itiebreak - rule for breaking ties
%               0 - (default) no special tie-breaking,
%                        results in ties being broken by 
%                        smaller ranks going to values 
%                        appearing first in data vector
%               1 - break ties by "fractional ranks", 
%                        i.e. giving average values to 
%                        all that are same
%                       
% Output:
%      vranks - vector of ranks of corresponding observations
%

%    Copyright (c) J. S. Marron 2002, 2004, 2023


if nargin == 1    %  then set to default value
  itiebreak = 0 ;
end


if size(data,2) > 1
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from ranksSM:     !!!') ;
  disp('!!!   Input "data" must be    !!!') ;
  disp('!!!   a column vector.        !!!') ;
  disp('!!!   Terminating execution   !!!') ;
  disp('!!!   with empty outputs      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vranks = [] ;
  return ;
end



[sortdata,indsort] = sort(data) ;
    %  sorted in increasing order of data values



if itiebreak == 1    %  then need to carefully handle ties

  n = length(data) ;
  sdsameaslast = [0; (sortdata(2:n) == sortdata(1:(n-1)))] ;
      %  one where entry of sorted data is same as last
  sdstartblocksame = [((sdsameaslast(2:n) - sdsameaslast(1:(n-1))) > 0); 0] ;
      %  one where a block of more than one of the same entry
      %  (in sorted data) starts
  sdendblocksame = [((sdsameaslast(2:n) - sdsameaslast(1:(n-1))) < 0); ...
                               sdsameaslast(n)] ;
      %  one where a block of more than one of the same entry
      %  (in sorted data) ends
      %  note last entry is 1 exactly when end of sdsameaslast is
  nblocksame = sum(sdstartblocksame) ;
      %  number of blocks of more than one of the same entry
  vi = (1:n)' ;
  visdsbs = vi(logical(sdstartblocksame)) ;
      % indices of starting points of blocks that are same
  visdebs = vi(logical(sdendblocksame)) ;
      % indices of ending points of blocks that are same
  for i = 1:nblocksame   %  loop through blocks that are the same
    blockmean = mean(vi(visdsbs(i):visdebs(i))) ;
    vi(visdsbs(i):visdebs(i)) = ...
        blockmean * ones(visdebs(i) - visdsbs(i) + 1,1) ;
  end

  [~,vind] = sort(indsort) ;
  vranks = vi(vind) ;
      %  get ranks of data, by inverting sort indices

else

  [~,vranks] = sort(indsort) ;
      %  get ranks of data, by inverting sort indices

end








