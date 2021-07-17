%%%********************************************************************
%% main function for genDWDweighted
%%********************************************************************

   function [w,beta,xi,r,alpha,runhist] = genDWDweighted_main(Z,y,Cvec,expon,options)

   tstart = clock;       
   tol     = options.tol;
   tau     = options.tau; 
   maxIter = options.maxIter; 
   method  = options.method;
   sigma   = options.sigma; 
   Zscale  = options.Zscale;
   printlevel = options.printlevel; 
%%   
   [dim,n] =size(Z); 
   normZ = 1+sqrt(max(sum(Z.*Z)));
   maxC = max(Cvec); 
%%
%% initial iterate
%%   
   r = ones(n,1); wbeta = zeros(dim+1,1); 
   u = zeros(dim,1); % u=Zscale*ones(dim,1)/sqrt(dim); 
   xi = zeros(n,1); 
   alpha = zeros(n,1);  %% important for url-svm
   p = zeros(dim,1);
%%     
%% chol of M 
%%
   const = 1;
   if (dim > 5000)
       if (n < 0.2*dim && n <= 2500)
          Solver = 'SMW2';
       else
          Solver = 'iterative'; 
       end
   else
      Solver = 'direct';
   end
   if strcmp(Solver,'iterative')
      ff = @(x) vecMultiply(Z,y,x,const);       
      diagM = sum(Z.*Z,2) + const;      
      L.invdiagM = 1./[diagM; 1]; %%better to use 1
      L.precond = 1;
   elseif strcmp(Solver,'direct')
      if (nnz(Z) > 0.4*dim*n) 
         Z = full(Z); 
      else
         Z = sparse(Z); 
      end      
      M = [Z*Z'+ const*speye(dim),Z*y; (Z*y)',y'*y];  
      if (nnz(M)/prod(size(M)) > 0.4)
         L.R = full(chol(M)); L.matfct = 'chol';    
      else
         [L.R,indef,L.perm] = chol(M,'vector'); 
         L.Rt  = L.R'; L.matfct = 'spchol';     
      end
   elseif strcmp(Solver,'SMW2') 
      normy = norm(y);
      yunit = y/norm(y);
      H11 = speye(n) + (1/const)*(Z'*Z);
      if (nnz(H11)/prod(size(H11)) > 0.4)
         L.R = full(chol(H11)); L.matfct = 'chol';    
      else
         [L.R,indef,L.perm] = chol(H11,'vector'); 
         L.Rt  = L.R'; L.matfct = 'spchol';     
      end
      invH11yunit = linsysolve(L,yunit);
      schurmat = yunit'*invH11yunit;     
      L.schurvec = [invH11yunit; -1];
   end
%%  
if (printlevel>1)
   fprintf('\n initial sigma = %3.2e',sigma);
   fprintf('\n Zscale = %3.2e',Zscale);   
   fprintf('\n norm(scaled Z) = %3.2e',mexFnorm(Z));
   fprintf('\n Linear system solver = %s',Solver);
   fprintf('\n------------------------------------------------------')
   fprintf('--------------------------------')
   fprintf('\n iter  time    sigma    primfeas  dualfeas')
   fprintf(' relcomp   primobj    dualobj    relgap'); 
   fprintf('   errNewton  max-r  doublecompute')
   fprintf(' psqmr train_err')
   fprintf('\n------------------------------------------------------')
   fprintf('--------------------------------')
end
%%   
%% main loop   
%%
   breakyes = false; 
   doublecompute = 0;  psqmriter = 0; 
   rhs = zeros(dim+1,1); rhsnew = zeros(dim+1,1);
   for iter=1:maxIter   
      rold = r; wbetaold = wbeta; uold = u; xiold = xi; 
      alphaold = alpha; pold = p;
      %% update w,beta
      tmp = full(rold -xiold+alphaold/sigma);
      rhs(1:dim) = mexMatvec(Z,tmp,0,const*uold+pold/sigma); 
      rhs(dim+1) = y'*tmp;     
      if strcmp(Solver,'iterative')       
         psqmrTol = max(min(5e-2,1/(iter^2)),1e-8)*max(1,sqrt(norm(rhs))); 
         psqmrMaxiter = 100;
         [wbeta,resnrm,solve_ok]=psqmr(ff,rhs,L,wbetaold,psqmrTol,psqmrMaxiter);
         psqmriter = psqmriter + length(resnrm)-1; 
         if (solve_ok~=1) && (printlevel>1)
            fprintf('\n iter=%2.0f: PSQMR not successful,num iter=%3.0f,residual=%3.2e',iter,length(resnrm)-1,resnrm(end)/norm(rhs));
         end
         if (false) %%(rem(iter,10)==1)
            semilogy(resnrm/norm(rhs),'*'); title(sprintf('iter = %2.0f',iter)); pause(0.01)
         end
      elseif strcmp(Solver,'direct') 
         wbeta = linsysolve(L,rhs);
      elseif strcmp(Solver,'SMW2')         
         wbeta = smw2(L,Z,yunit,schurmat,normy,const,rhs);          
      end  
      %% update r 
      w = wbeta(1:dim); beta = wbeta(dim+1);  
      ZTwpbetay = mexMatvec(Z,w,1,beta*y); 
      cc = ZTwpbetay +xiold -alphaold/sigma; 
      epsilon = 0; %% not useful to set it positive
      if (epsilon > 0); cc = cc-epsilon; end
      [r,errNewton,iterNewton] = polyRootsNewton(cc,expon,sigma,rold);
      if (epsilon > 0); r = r - epsilon; end  
      r = max(r,0); 
      %% update w,beta again   
      if (method==1) 
         doublecompute_measure = normZ*norm(r-rold)*iter^1.5;           
         if ((doublecompute_measure > 10) || (iter < 50))
            %% important to use for covtype,w7a,w8a
            doublecompute = doublecompute+1;
            tmpnew = full(r -xiold+alphaold/sigma);  
            rhsnew(1:dim) = mexMatvec(Z,tmpnew,0,const*uold+pold/sigma); 
            rhsnew(dim+1) = y'*tmpnew;
            if strcmp(Solver,'iterative')            
               [wbeta,resnrm,solve_ok]=psqmr(ff,rhsnew,L,wbeta,psqmrTol,psqmrMaxiter);
               psqmriter = psqmriter + length(resnrm)-1;             
               if (solve_ok~=1) && (printlevel>1)
                  fprintf('\n iter=%2.0f: PSQMR not successful,num iter=%3.0f,residual=%3.2e',iter,length(resnrm)-1,resnrm(end)/norm(rhs));                
               end
            elseif strcmp(Solver,'direct')
               wbeta = linsysolve(L,rhsnew);       
            elseif strcmp(Solver,'SMW2')
               wbeta = smw2(L,Z,yunit,schurmat,normy,const,rhsnew);
            end
            w = wbeta(1:dim); beta = wbeta(dim+1);   
            ZTwpbetay = mexMatvec(Z,w,1,beta*y);            
         end
      else %% directly extended ADMM
         doublecompute_measure = 0; 
         doublecompute = 0; 
      end
      %% update u,xi
      uinput = w -pold/(const*sigma);
      u = Zscale*uinput/max(Zscale,norm(uinput));     
      xiinput = r - ZTwpbetay +(alphaold-Cvec)/sigma;
      xi = max(xiinput,0);      
      %% update alpha,p
      Rp = ZTwpbetay +xi-r; 
      alpha = alphaold -tau*sigma*Rp;
      p = pold -(tau*sigma*const)*(w-u);
%%
%% check for termination
%%
      rexpon1 = (r+epsilon).^(expon+1); 
      comp(1) = abs(y'*alpha); 
      comp(2) = abs(xi'*(Cvec-alpha));      
      comp(3) = min(norm(alpha.*rexpon1-expon),norm(alpha-expon./rexpon1).^2); 
      relcomp = max(comp)/(1+maxC); 
      primfeas = max([norm(Rp),norm(w-u),max(norm(w)-Zscale,0)])/(1+maxC);      
      dualfeas = max([norm(min(0,alpha)),norm(max(alpha-Cvec,0))])/(1+maxC);   
      trainerr = length(find(ZTwpbetay<=0))/n*100;   
      if ((max(primfeas,dualfeas) < tol) && rem(iter,20)==1) ...
         || (rem(iter,100)==1)
         primobj1 = sum((r+epsilon)./rexpon1); primobj2 = sum(Cvec.*xi)+1e-8;
         primobj = primobj1 + primobj2;
         kappa = (expon+1)/expon* expon^(1/(expon+1));          
         dualobj = kappa*sum(alpha.^(expon/(expon+1)))-Zscale*norm(mexMatvec(Z,alpha,0));
         dualobj = dualobj - epsilon*sum(alpha);
         relgap = abs(primobj-dualobj)/(1+abs(primobj)+abs(dualobj));
      end
      tol2 = 0.05; 
      if (iter > 50) && (max(primfeas,dualfeas) < tol) && (min(relcomp,relgap) < sqrt(tol)) ...
         && (((relcomp < tol2) && (relgap < sqrt(tol))) ...
             || ((relcomp < sqrt(tol)) && (relgap < tol2))) %% new
         KKTerr = max(max([primfeas,dualfeas]),min(relcomp,relgap));
         breakyes=1;
         if (printlevel)
            fprintf('\n Stop with error %3.2e, breakyes = %2.0f',KKTerr,breakyes);
         end
      end          
      if (iter > 50) && (max(primfeas,dualfeas) < 5*tol) && (min(relcomp,relgap) < 10*tol) ...
         && (((relcomp < tol2) && (relgap < sqrt(tol))) ...
             || ((relcomp < sqrt(tol)) && (relgap < tol2)))       
         KKTerr = max(max([primfeas,dualfeas]),min(relcomp,relgap));
         breakyes=2;
         if (printlevel)
            fprintf('\n Stop with error %3.2e, breakyes = %2.0f',KKTerr,breakyes);
         end
      end            
      if (iter > 50) && (max(primfeas,dualfeas) < tol) && (norm(alpha)/(1+maxC) < 1e-3)
         KKTerr = max(max([primfeas,dualfeas]),min(relcomp,relgap));
         breakyes=3;
         if (printlevel)
            fprintf('\n Stop with error %3.2e, breakyes = %2.0f',KKTerr,breakyes);
         end
      end      
      if (iter <= 100)
         print_iter = 20;
      else
         print_iter = 100;
      end
      if (printlevel>1) && ((rem(iter,print_iter)==1) || (breakyes))        
         ttime = etime(clock,tstart);  
         fprintf('\n%4.0f| %6.2f| %3.2e| %3.2e %3.2e %3.2e| %5.4e %5.4e %3.2e| %3.2e %3.2e| %3.2e %3.0f| %5.0f %5.2f|',...
         iter,ttime,sigma,primfeas,dualfeas,relcomp,primobj,abs(dualobj),relgap,errNewton,min(r),...
         doublecompute_measure,doublecompute,psqmriter,trainerr);
      end         
      runhist.primfeas(iter) = primfeas;
      runhist.dualfeas(iter) = dualfeas;
      runhist.relcomp(iter)  = relcomp;    
      runhist.trainerr(iter) = trainerr;
      runhist.primobj(iter) = primobj;
      runhist.dualobj(iter) = dualobj;
      runhist.relgap(iter)  = relgap; 
      runhist.psqmr(iter)   = psqmriter; 
      runhist.Newton(iter)  = iterNewton; 
      runhist.sigma(iter)   = sigma; 
      runhist.doublecompute(iter) = doublecompute;
%%     
%% adjust sigma 
%%
      sigma_update_iter = sigma_update(iter);
      if (rem(iter,sigma_update_iter)==0)
         primfeas2 = max(primfeas,0.2*tol);
         dualfeas2 = max(dualfeas,0.2*tol);
         ratio = primfeas2/dualfeas2; 
         const2 = 1.1; %% important to use 1.1
         if (max(ratio,1/ratio) > 500)
            const2 = const2*2;
         elseif (max(ratio,1/ratio) > 50)
            const2 = const2*1.5; 
         end
         if (ratio > 5)
            sigma = min(sigma*const2,1e6);
         elseif (1/ratio > 5)
            sigma = max(sigma/const2,1e-3);
         end        
      end
      if (breakyes)
         if (printlevel); fprintf('\n'); end
         break; 
      end
   end
%%
%% end of main loop
%%

   w = w/Zscale; 
%%**********************************************************************
%%**********************************************************************
   function sigma_update_iter = sigma_update(iter)
           
   const = 0.5;
   if (iter <= 25)
      sigma_update_iter = 10*const;
   elseif (iter <= 50)
      sigma_update_iter = 20*const;
   elseif (iter <= 100)
      sigma_update_iter = 40*const;
   elseif (iter <= 500)
      sigma_update_iter = 60*const;
   elseif (iter <= 1000)
      sigma_update_iter = 80*const;
   else
      sigma_update_iter = 100; 
   end
%%**********************************************************************
    function q = linsysolve(L,r) 

    if isfield(L,'perm')
       if strcmp(L.matfct,'chol')
          q(L.perm,1) = mextriang(L.R, mextriang(L.R,r(L.perm),2) ,1);
       elseif strcmp(L.matfct,'spchol')
          q(L.perm,1) = mexbwsolve(L.Rt,mexfwsolve(L.R,r(L.perm)));
       end
    else
       if strcmp(L.matfct,'chol')
          q = mextriang(L.R, mextriang(L.R,r,2) ,1);
       elseif strcmp(L.matfct,'spchol')
          q = mexbwsolve(L.Rt,mexfwsolve(L.R,r));
       end        
    end
%%**********************************************************************
%%**********************************************************************
    function q = smw2(L,Z,yunit,schurmat,normy,const,r)
    
    n = length(yunit); 
    dim = length(r)-1; 
    b1 = (1/const)*mexMatvec(Z,r(1:dim),1) + (r(dim+1)/normy)*yunit; 
    b2 = r(dim+1)/normy;
    b = [b1; b2];
%%    
    tmpvec = (L.schurvec'*b/schurmat)*L.schurvec;          
    if isfield(L,'perm')
       b1 = b(1:n);
       if strcmp(L.matfct,'chol')
          a1(L.perm,1) = mextriang(L.R, mextriang(L.R,b1(L.perm),2) ,1)-tmpvec(1:n);
       elseif strcmp(L.matfct,'spchol')
          a1(L.perm,1) = mexbwsolve(L.Rt,mexfwsolve(L.R,b1(L.perm)))-tmpvec(1:n);
       end
    else
       if strcmp(L.matfct,'chol')
          a1 = mextriang(L.R, mextriang(L.R,b1,2) ,1)-tmpvec(1:n); 
       elseif strcmp(L.matfct,'spchol')
          a1 = mexbwsolve(L.Rt,mexfwsolve(L.R,b1))-tmpvec(1:n);
       end        
    end 
    a2 = -b2-tmpvec(n+1);     
    q = zeros(dim+1,1);
    q(1:dim) = (1/const)*mexMatvec(Z,-a1,0,r(1:dim));
    q(dim+1) = (1/normy)*(r(dim+1)/normy-yunit'*a1-a2);        
%%**********************************************************************