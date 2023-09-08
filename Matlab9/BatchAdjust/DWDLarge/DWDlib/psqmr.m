%%%*************************************************************************
%% psqmr:  preconditioned symmetric QMR with left (symmetric) preconditioner. 
%%
%% b = rhs vector.
%% resnrm = norm of qmr-generated residual vector b-Ax. 
%%
%% SDPNAL: 
%% Copyright (c) 2008 by
%% Xinyuan Zhao, Defeng Sun, and Kim-Chuan Toh 
%%*************************************************************************

   function  [x,resnrm,solve_ok] = psqmr(matvecfname,b,L,x0,tol,maxit) 

   N = length(b); 
   if ~exist('maxit'); maxit = max(1000,sqrt(length(b))); end;
   if ~exist('tol'); tol = 1e-8*norm(b); end; 
   if ~exist('L');  L.precond = 0; end;
   if ~exist('x0'); x0 = zeros(N,1); end;

   solve_ok = 1; 
   stagnate_check = 20*1; 
   miniter = 0; 
   printlevel = 0; 
%%
   x = x0; 
   if (norm(x) > 0) 
      Aq = matvecfname(x);  
   else
      Aq = zeros(N,1);  
   end
   r = b-Aq;  
   err = norm(r); resnrm(1) = err; minres = err; 
%% 
   q = precondfun(L,r); 
   tau_old  = norm(q);      
   rho_old  = r'*q; 
   theta_old = 0; 
   d = zeros(N,1); 
   res = r; Ad = zeros(N,1);   
%%      
%% main loop
%%
   tiny = 1e-30; 
   for iter = 1:maxit 
       Aq = matvecfname(q);
       sigma = q'*Aq; 
       if (abs(sigma) < tiny)
          solve_ok = 2; 
          if (printlevel); fprintf('s1'); end
          break;
       else
          alpha = rho_old/sigma; 
          r = r - alpha*Aq;
       end
       u = precondfun(L,r); 
       %%
       theta = norm(u)/tau_old; c = 1/sqrt(1+theta^2); 
       tau = tau_old*theta*c;
       gam = (c^2*theta_old^2); eta = (c^2*alpha); 
       d = gam*d + eta*q;
       x = x + d; 
       %%----- stopping conditions ----
       Ad = gam*Ad + eta*Aq;
       res = res - Ad; 
       err = norm(res); resnrm(iter+1) = err; 
       if (err < minres); minres = err; end
       if (err < tol) && (iter > miniter) && (b'*x > 0); break; end  
       if (iter > stagnate_check) && (iter > 10)
          ratio = resnrm(iter-9:iter+1)./resnrm(iter-10:iter); 
          if (min(ratio) > 0.997) && (max(ratio) < 1.003)
             if (printlevel); fprintf('s'); end
             solve_ok = -1; 
             break;
          end       
       end
       %%----------------------------- 
       if (abs(rho_old) < tiny)
          solve_ok = 2; 
          fprintf('s2');
          break;
       else
          rho  = r'*u; 
          beta = rho/rho_old; 
          q = u + beta*q; 
       end
       rho_old = rho; 
       tau_old = tau; 
       theta_old = theta; 
   end
   if (iter == maxit); solve_ok = -2; end
   if (solve_ok ~= -1); 
      if (printlevel); fprintf(' '); end
   end
%%*************************************************************************
%%*************************************************************************
   function  q = precondfun(L,r)

   precond = L.precond; 

   if (precond == 0)
      q = r; 
   elseif (precond == 1)
      q = L.invdiagM.*r;
   elseif (precond == 2)
      if strcmp(L.matfct_options,'chol')
         q(L.perm,1) = mextriang(L.R, mextriang(L.R,r(L.perm),2) ,1);
      elseif strcmp(L.matfct_options,'spchol')
         q(L.perm,1) = mexbwsolve(L.Rt,mexfwsolve(L.R,r(L.perm,1)));
      end
   end
%%*************************************************************************
