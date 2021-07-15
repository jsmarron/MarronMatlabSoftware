%%%********************************************************************
%% [w,beta,xi,r,alpha,info,runhist] = genDWDweighted(X,y,C0,expon,options)
%% An sGS-ADMM method for solving 
%%    min sum_j (1/rj^q) + C*<e,xi> 
%%    s.t  r = ZT*w + beta*y + xi, r > 0, xi>=0, norm(w)<=1
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
%%--------------------------------------------------------------------
%% Copyright (c) 2016 by
%% Xin-Yee Lam, J.S. Marron, Defeng Sun,
%% Kim-Chuan Toh (corresponding author)
%%********************************************************************

   function [w,beta,xi,r,alpha,info,runhist] = genDWDweighted(X,y,C0,expon,options)

   if (nargin < 5); options = []; end
   if ~isfield(options,'tol'); options.tol = 1e-5; end
   if ~isfield(options,'maxIter'); options.maxIter = 5000; end
   if ~isfield(options,'method'); options.method = 1; end
   if ~isfield(options,'tau'); options.tau = 1.618; end
%%   
   [dim,n] =size(X); 
   idxpos = find(y>0); idxneg = find(y<0); 
   np = length(idxpos); nn = length(idxneg);    
   tstart = clock;       
   use_balanced = true; 
   if (use_balanced)   
      K = n/log(n); 
      tmpvec = zeros(n,1);
      tmpvec(idxpos) = (nn/K)*ones(np,1);
      tmpvec(idxneg) = (np/K)*ones(nn,1);   
weightoptions = 2;      
      if (weightoptions==0) %%standard weight
         resweight = 1;
         penweight = 1; 
      elseif (weightoptions==1) %%good for rcv1
         resweight = tmpvec.^(1/(2+expon));
         penweight = tmpvec.^(1/(2+expon));
      elseif (weightoptions==2) %%best overall
         resweight = tmpvec.^(1/(1+expon));
         penweight = 1; 
      elseif (weightoptions==3) %%good for rcv1
         resweight = 1;
         penweight = tmpvec.^(1/(2+expon)); 
      end
      resweight = resweight/max(resweight);      
      y = y./resweight;   
      Cvec = C0*(penweight.*resweight);          
   else
      Cvec = C0*ones(n,1);    
   end
%%   
   Z = X*spdiags(y,0,n,n);   
   scale_data = 1; 
   if (scale_data == 1) %% good to use
      Zscale = sqrt(mexFnorm(X));
      Z = Z/Zscale;
      sigma = min([10*C0,1*n]); 
   else
      Zscale = 1; 
      sigma = max(1,log(n/dim))*mexFnorm(X); %% yet to be fully tested
   end
   sigma = sigma^(expon); 
   options.sigma = sigma;
   options.Zscale = Zscale; 
%%   
   fprintf('\n------------------------------------------------------')
   fprintf('--------------------------------')  
   fprintf('\n sample size = %3.0f, feature dimension = %3.0f',n,dim);
   fprintf('\n expon = %2.1f, penalty constant C = %4.2e',expon,C0); 
   fprintf('\n------------------------------------------------------')
   fprintf('--------------------------------')     
%%   
   [w,beta,xi,r,alpha,runhist] = genDWDweighted_main(Z,y,Cvec,expon,options);
   ttime = etime(clock,tstart);
   info.iter = length(runhist.primfeas); 
   info.time = ttime; 
   info.sampsize  = n; info.np = np; info.nn = nn;
   info.dimension = dim; 
   info.penaltyParameter = C0;    
   info.weightoptions = weightoptions;
   info.sigmastart = runhist.sigma(1);
   info.primfeas = runhist.primfeas(end);
   info.dualfeas = runhist.dualfeas(end);
   info.relcomp  = runhist.relcomp(end);
   info.relgap   = runhist.relgap(end); 
   info.primobj  = runhist.primobj(end);
   info.dualobj  = runhist.dualobj(end);
   info.trainerr = runhist.trainerr(end);
   info.psqmr    = runhist.psqmr(end);
   info.doublecompute = runhist.doublecompute(end);   
%%
   fprintf('\n sample size = %3.0f, feature dimension = %3.0f',n,dim);
   fprintf('\n positve sample = %3.0f, negative sample = %3.0f',np,nn);    
   fprintf('\n norm(Z*alpha)=%3.2e, norm(w)=%3.2e',Zscale*norm(Z*alpha),norm(w));
   fprintf('\n number of iterations = %3.0f',info.iter);
   fprintf('\n number of PSQMR iterations = %3.0f',info.psqmr);
   fprintf('\n number of double compute   = %3.0f',info.doublecompute); 
   fprintf('\n average number of Newton iterations = %3.0f',mean(runhist.Newton));
   fprintf('\n time taken = %3.2f',ttime); 
   fprintf('\n primfeas = %3.2e',info.primfeas);
   fprintf('\n dualfeas = %3.2e',info.dualfeas);
   fprintf('\n relative gap = %3.2e\n',info.relgap);
%%********************************************************************
