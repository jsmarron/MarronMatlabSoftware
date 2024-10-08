%%%********************************************************************
%% [C,ddist] = penaltyParameter(X,y,expon)
%% Find a good choice of C by using the data X, 
%% where each column of X is a sample
%%********************************************************************
    function [C,ddist] = penaltyParameter(X,y,expon)

    rng('default')
    
    if (nargin < 3); expon = 1; end

    [dim,sampsize]=size(X);   
    positive=find(y==1);
    negative=find(y==-1);
    if (dim > 1e4) && (sampsize > 1e4)
       len = 100;
    else
       len = 200; 
    end
    if (length(positive) > len)
       idx = randperm(length(positive));
       positive = positive(idx(1:len));
    end   
    if (length(negative) > len)
       idx = randperm(length(negative));
       negative = negative(idx(1:len));
    end   
%%    
    posX=X(:,positive);
    n1=size(posX,2);
    negX=X(:,negative);
    n2=size(negX,2);
    ddist = zeros(n2,n1);
    for i=1:n2
       for j=1:n1
          Xtmp = posX(:,j) - negX(:,i);
          ddist(i,j) = sqrt(sum(Xtmp.*Xtmp));
       end
    end
    ddist = ddist(:);   
    dd = median(ddist);
    %%const = 1e4; %% important to use 1e4, not as good
    if (expon==1)       
       const = log(sampsize)*max(1000,dim)^(1/3);
    else
       const = 10*log(sampsize)*max(1000,dim)^(1/3);        
    end
    C = 10^(expon+1)*max(1,const/dd^(expon+1));  
%    fprintf('\n estimated typical distance = %3.2e\n',dd);
%%********************************************************************

