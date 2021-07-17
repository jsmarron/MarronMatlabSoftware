%%%*****************************************************
%% polyRootsNewton: 
%% roots of cubic polynomial x^(q+2)-c*x^(q+1)-d=0
%% starting pt x0
%%*****************************************************
  function [x,err,iter] = polyRootsNewton(c,q,sigma,x0)
    
  tol = 1e-12;
  x = x0;
  d = q/sigma; cq1 = c*(q+1); q2 = q+2; 
  maxiter = 50;
  if (q==1)
      for iter = 1:maxiter
         idx = find(x <=0); 
         if ~isempty(idx), x(idx) = max(0,0.5+c(idx)); end     
         xq1 = x.*x; xq = x;     
         grad = xq1.*(x-c)-d; hess = xq.*(q2*x-cq1);
         x = x-grad./hess; err = max(abs(grad));
         if (err < tol), break; end
      end
  elseif (q==2)
      for iter = 1:maxiter
         idx = find(x <=0); 
         if ~isempty(idx), x(idx) = max(0,0.5+c(idx)); end     
         xq = x.*x; xq1 = xq.*x; 
         grad = xq1.*(x-c)-d; hess = xq.*(q2*x-cq1);
         x = x-grad./hess; err = max(abs(grad));
         if (err < tol), break; end
      end
  elseif (q==3)
      for iter = 1:maxiter
         idx = find(x <=0); 
         if ~isempty(idx), x(idx) = max(0,0.5+c(idx)); end     
         x2 = x.*x; xq = x2.*x; xq1 = x2.*x2;         
         grad = xq1.*(x-c)-d; hess = xq.*(q2*x-cq1);
         x = x-grad./hess; err = max(abs(grad));
         if (err < tol), break; end
      end
  elseif (q==4)
      for iter = 1:maxiter
         idx = find(x <=0); 
         if ~isempty(idx), x(idx) = max(0,0.5+c(idx)); end     
         x2 = x.*x; xq = x2.*x2; xq1 = xq.*x;           
         grad = xq1.*(x-c)-d; hess = xq.*(q2*x-cq1);
         x = x-grad./hess; err = max(abs(grad));
         if (err < tol), break; end
      end    
  end
%%*****************************************************
