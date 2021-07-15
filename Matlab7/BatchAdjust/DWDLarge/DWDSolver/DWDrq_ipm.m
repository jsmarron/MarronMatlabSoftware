%%%********************************************************************
%% [w,beta,xi] = DWDrq(X,y,penalty,expon)
%% An interior-point method for solving
%%    min  sum_j 1/rj^expon + C*e'*xi
%%    s.t. ZT*w+beta*y+xi-r=0, norm(w)<=1, r,xi >= 0. 
%% expon = 1,2,4,8;
%% Z=X*diag(y), y=label;
%%-------------------------------------------------------------------- 
%% When expon = 2, we have
%% min sum_i ui + C*e'*xi
%% s.t ZT*w+beta*y+xi-r=0, norm(w)<=1, r,xi >= 0;
%%     2 <= 2*ri*si <=> (ri;si;ti) \in R3 and ti = sqrt2;
%%     (0.5;ui;uibar) \in R3 
%%     <=> (ui0;ui;uibar) \in R3 and ui0=0.5,si-uibar=0.
%%********************************************************************
%% Copyright (c) 2016 by
%% Xin-Yee Lam, J.S. Marron, Defeng Sun,
%% Kim-Chuan Toh (corresponding author)
%%********************************************************************

   function [w,beta,xi,info] = DWDrq_ipm(X,y,penalty,expon)

   if (nargin < 2); penalty = 100; end
   if (nargin < 3); expon = 1; end     
   if (min(abs(expon-[1,2,4,8])) > 0)
      error(' expon must be 1,2,4, or 8');
   end
   [dim,nt] = size(X);
   np = length(find(y > 0));
   nn = nt-np;   
   Z = X*spdiags(y,0,nt,nt);
   weight = [ones(np,1)*nn/nt; ones(nn,1)*np/nt];
   %weight = ones(n,1);    
   II = speye(nt,nt); 
   blk{1,1} = 'q'; blk{1,2} = dim+1;
   blk{2,1} = 'u'; blk{2,2} = 1; 
   blk{3,1} = 'l'; blk{3,2} = nt;
   blk{4,1} = 'r'; blk{4,2} = 3*ones(1,nt);
   if (expon >= 2); blk{5,1} = 'r'; blk{5,2} = 3*ones(1,nt); end
   if (expon >= 4); blk{6,1} = 'r'; blk{6,2} = 3*ones(1,nt); end
   if (expon >= 8); blk{7,1} = 'r'; blk{7,2} = 3*ones(1,nt); end   
%%
   bb = [zeros(nt,1); 1; sqrt(2)*ones(nt,1)];
   if (expon >= 2); bb = [bb; 0.5*ones(nt,1); zeros(nt,1)]; end
   if (expon >= 4); bb = [bb; 0.5*ones(nt,1); zeros(nt,1)]; end
   if (expon >= 8); bb = [bb; 0.5*ones(nt,1); zeros(nt,1)]; end   
   CC{1,1} = zeros(dim+1,1);
   CC{2,1} = 0;
   CC{3,1} = penalty*ones(nt,1);  
   if (expon==1)
      CC{4,1} = kron(weight,[0;1;0]);
   end
   if (expon==2)
      CC{4,1} = zeros(3*nt,1); 
      CC{5,1} = kron(weight,[0;1;0]);
   end
   if (expon==4)
      CC{4,1} = zeros(3*nt,1); 
      CC{5,1} = zeros(3*nt,1);
      CC{6,1} = kron(weight,[0;1;0]); 
   end
   if (expon==8)
      CC{4,1} = zeros(3*nt,1); 
      CC{5,1} = zeros(3*nt,1);
      CC{6,1} = zeros(3*nt,1);      
      CC{7,1} = kron(weight,[0;1;0]); 
   end   
%%   
%% (w0;w), beta, xi, (r,s,sbar), (u0,u,ubar), (v0,v,vbar), (z0,z,zbar)
%%
   AA{1,1} = [zeros(nt,1), Z'];
   AA{1,2} =  y; 
   AA{1,3} =  II; 
   AA{1,4} = -kron(II,[1,0,0]);    
   if (expon >= 2); AA{1,5} = sparse(nt,3*nt); end
   if (expon >= 4); AA{1,6} = sparse(nt,3*nt); end
   if (expon >= 8); AA{1,7} = sparse(nt,3*nt); end   
   %% w0=1
   AA{2,1} = [1,sparse(1,dim)]; 
   AA{2,2} = 0; 
   AA{2,3} = sparse(1,nt); 
   AA{2,4} = sparse(1,3*nt); 
   if (expon >= 2); AA{2,5} = sparse(1,3*nt); end
   if (expon >= 4); AA{2,6} = sparse(1,3*nt); end  
   if (expon >= 8); AA{2,7} = sparse(1,3*nt); end      
   %% sbar=sqrt(2)
   AA{3,1} = sparse(nt,dim+1); 
   AA{3,2} = sparse(nt,1);
   AA{3,3} = sparse(nt,nt); 
   AA{3,4} = kron(II,[0,0,1]);    
   if (expon >= 2); AA{3,5} = sparse(nt,3*nt); end
   if (expon >= 4); AA{3,6} = sparse(nt,3*nt); end
   if (expon >= 8); AA{3,7} = sparse(nt,3*nt); end   
%%  
   if (expon >= 2)
      %% u0=0.5       
      AA{4,1} = sparse(nt,dim+1); 
      AA{4,2} = sparse(nt,1); 
      AA{4,3} = sparse(nt,nt); 
      AA{4,4} = sparse(nt,3*nt);
      AA{4,5} = kron(II,[1,0,0]); 
      %% s-ubar=0      
      AA{5,1} = sparse(nt,dim+1);
      AA{5,2} = sparse(nt,1); 
      AA{5,3} = sparse(nt,nt);     
      AA{5,4} =  kron(II,[0,1,0]);
      AA{5,5} = -kron(II,[0,0,1]);      
   end
   if (expon >= 4)
      AA{4,6} = sparse(nt,3*nt);        
      AA{5,6} = sparse(nt,3*nt);       
   end   
   if (expon >= 8)
      AA{4,7} = sparse(nt,3*nt);        
      AA{5,7} = sparse(nt,3*nt);       
   end      
%% 
   if (expon >= 4)
      %% v0=0.5       
      AA{6,1} = sparse(nt,dim+1); 
      AA{6,2} = sparse(nt,1); 
      AA{6,3} = sparse(nt,nt); 
      AA{6,4} = sparse(nt,3*nt);  
      AA{6,5} = sparse(nt,3*nt);
      AA{6,6} = kron(II,[1,0,0]); 
      %% u-vbar=0
      AA{7,1} = sparse(nt,dim+1);
      AA{7,2} = sparse(nt,1); 
      AA{7,3} = sparse(nt,nt);
      AA{7,4} = sparse(nt,3*nt);
      AA{7,5} =  kron(II,[0,1,0]);
      AA{7,6} = -kron(II,[0,0,1]);     
   end
   if (expon >= 8)
      AA{6,7} = sparse(nt,3*nt);        
      AA{7,7} = sparse(nt,3*nt);       
   end    
%%   
   if (expon >= 8)
      %% z0=0.5       
      AA{8,1} = sparse(nt,dim+1); 
      AA{8,2} = sparse(nt,1); 
      AA{8,3} = sparse(nt,nt); 
      AA{8,4} = sparse(nt,3*nt);  
      AA{8,5} = sparse(nt,3*nt);
      AA{8,6} = sparse(nt,3*nt);
      AA{8,7} = kron(II,[1,0,0]); 
      %% v-zbar=0
      AA{9,1} = sparse(nt,dim+1);
      AA{9,2} = sparse(nt,1); 
      AA{9,3} = sparse(nt,nt);
      AA{9,4} = sparse(nt,3*nt);
      AA{9,5} = sparse(nt,3*nt);      
      AA{9,6} =  kron(II,[0,1,0]);
      AA{9,7} = -kron(II,[0,0,1]);     
   end   
%%   
   for p = 1:size(AA,2)
      Atmp = [AA{1,p}; AA{2,p}; AA{3,p}];
      if (expon>=2)
         Atmp = [Atmp; AA{4,p}; AA{5,p}];
      end
      if (expon>=4)
         Atmp = [Atmp; AA{6,p}; AA{7,p}];          
      end
      if (expon>=8)
         Atmp = [Atmp; AA{8,p}; AA{9,p}];          
      end      
      At{p,1} = Atmp';
   end
   [bblk,AAt,CCC,bbb,T] = convertRcone(blk,At,CC,bb);   
   options.tol = 1e-6;
   options.printlevel = 3;
   [obj,xx,lambda,zz,info] = sqlp(bblk,AAt,CCC,bbb,options);
   w = xx{1}(2:dim+1); 
   beta = xx{2}; 
   xi = xx{3}; 
   normw = norm(w); 
   if (normw > 1 - 1e-3)
      w = w / normw;
      beta = beta / normw;
   end
%%********************************************************************

   
   