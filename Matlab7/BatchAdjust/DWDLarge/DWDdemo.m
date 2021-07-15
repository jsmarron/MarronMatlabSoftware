%%**********************************************************************
%% DWD: an sGS-ADMM method for solving 
%%   min sum_j (1/rj^q) + C*<e,xi> 
%%   s.t  r = (diag(y)*XT)*w + beta*y + xi, r > 0, xi>=0, norm(w)<=1
%%
%% [w,beta,xi,r,alpha,info] = genDWDweighted(X,y,C,expon,options)
%% INPUT:
%% X = dim x n, n = sample size, dim = feature dimension
%% y = nx1 (+1,-1 labels)
%% C = penalty parameter
%% expon = exponent q
%% options: (optional) for setting stopping tolerance and maximum iterations.
%% options.tol = stopping tolerance (default:1e-5)
%% options.method = 1 (default): sGS-ADMM
%%                = 2 directly extended ADMM
%% options.maxIter = maximum iterations allowed (default:5000)
%% OUTPUT:
%% w,beta,xi,r = variables for primal problem
%% alpha = variable for dual problem
%% info = run information 
%%**********************************************************************
%% Copyright (c) 2016 by
%% Xin-Yee Lam, J.S. Marron, Defeng Sun,
%% Kim-Chuan Toh (corresponding author)
%%**********************************************************************
%% test LIBSVM dataset
%% Read file
% m: the number of samples,  n: the number of features
% y: m by 1 vector of training labels
% X: m by n matrix of m training samples with n features.
% libsvmread('Data-LIBSVM/filename') read a dataset in Data-LIBSVM/
%%**********************************************************************

    addpath(genpath(pwd))

    fname{1} = 'a8a'; 
    fname{2} = 'a9a'; 
    fname{3} = 'ijcnn1';    
    fname{4} = 'rcv1'; 
    fname{5} = 'w7a';
         
expon = 1;    
for fid = [1]
    tstart = clock;
    probname = ['UCIdata',filesep,fname{fid}]; 
    try
      [y,XT] = libsvmread(probname); %%read data in LIBSVM format
      if (min(y)==0)
         idx = find(y==0);
         y(idx) = -1; 
      end
    catch
      fprintf('\n file not found');
    end
    ttime = etime(clock,tstart);
    fprintf('\n %s: time taken to read data = %3.2f',fname{fid},ttime);
    %% Apply DWD to the data
    [sampsize,dim] = size(XT);
    tstart = clock;
    fprintf('\n Run DWD: exponent=%1.0f',expon);
    if (dim > 5*sampsize) 
       %% scale the features to have roughly same magnitude
       fprintf('\n scale columns of XT to have unit norm...');
       normXT = max(1,sqrt(sum(XT.*XT))');       
       XT = XT*spdiags(1./normXT,0,dim,dim); 
       fprintf('completed');
    else
       normXT = 1;
    end
    X = XT'; % Here we put the samples as columns 
    fprintf('\n compute penalty parameter...');
    [C,ddist] = penaltyParameter(X,y,expon); 
    %% solve using sGS-ADMM
    options.tol     = 1e-5; 
    options.maxIter = 5000; 
    options.method  = 1; 
    [w,beta,xi,r,alpha,info] = genDWDweighted(X,y,C,expon,options);  
    info.ttime = etime(clock,tstart); 
    info.w = w; info.beta = beta; info.xi = xi; info.r = r;
    info.alpha = alpha;
    info.normXT = normXT; 
    iter = info.iter; 
    res = (w'*X)'+beta;    
    info.error = length(find(y.*sign(res)<=0))/length(res);    
    %% solve using interior-point method
    if (false)
       try 
         [w2,beta2,xi2,IPMinfo] = DWDrq_ipm(X,y,C,expon);    
         res2 = (w2'*X)'+beta2;    
         IPMinfo.error = length(find(y.*sign(res2)<=0))/length(res2);           
       catch msg
         fprintf('\n\n****** Solving by IPM failed: SDPT3 is not in the path\n');
       end
    end
    %% print results    
    idxpos = find(y>0); idxneg = find(y<0);
    fprintf('\n------------------------------------------------------');    
    fprintf('\n dataset = %s',fname{fid});
    fprintf('\n sample size = %3.0f, feature dimension = %3.0f',sampsize,dim);
    fprintf('\n positve sample = %3.0f, negative sample = %3.0f',length(idxpos),length(idxneg)); 
    fprintf('\n training time   = %3.2f',info.ttime); 
    fprintf('\n number of iteration  = %3.0f',iter);
    fprintf('\n error of classification (training) = %3.2f (%%)',info.error*100);
    fprintf('\n------------------------------------------------------\n');
end    