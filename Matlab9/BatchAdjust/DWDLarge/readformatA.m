%% 
%% each row of X is a sample
%%

  function [y,X] = readformatA(fname)

  y = load([fname,'Y.txt']);
  X = load([fname,'X.txt']); 

  y = y(:,2:end);
  X = X(:,2:end);
  idx = find(y==0); 
  if ~isempty(idx)
     y(idx) = -1; 
  end
 
  
