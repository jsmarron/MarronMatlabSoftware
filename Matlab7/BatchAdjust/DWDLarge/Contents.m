
 Directory: DWDSolver
 %********************************************************************
 % [w,beta,xi] = DWDrq(X,y,penalty,expon)
 % An interior-point method for solving
 %    min  sum_j 1/rj^expon + C*e'*xi
 %    s.t. ZT*w+beta*y+xi-r=0, norm(w)<=1, r,xi >= 0. 
 % expon = 1,2,4,8;
 % Z=X*diag(y), y=label;
 %********************************************************************

 %********************************************************************
 % [w,beta,xi,r,alpha,info,runhist] = genDWDweighted(X,y,C0,expon,options)
 % An sGS-ADMM method for solving 
 %    min sum_j (1/rj^q) + C*<e,xi> 
 %    s.t  r = ZT*w + beta*y + xi, r > 0, xi>=0, norm(w)<=1
 % INPUT:
 % X = dim x n, n = sample size, dim = feature dimension
 % y = nx1 (+1,-1 labels)
 % C = penalty parameter
 % expon = exponent q
 % options: (optional) for setting stopping tolerance and maximum iterations.
 % options.tol = stopping tolerance (default:1e-5)
 % options.method = 1 (default): sGS-ADMM
 %                = 2 directly extended ADMM
 % options.maxIter = maximum iterations allowed (default:5000)
 % OUTPUT:
 % w,beta,xi,r = variables for primal problem
 % alpha = variable for dual problem
 % info = run information 
 %********************************************************************
