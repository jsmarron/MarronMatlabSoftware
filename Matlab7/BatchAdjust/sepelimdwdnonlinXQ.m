   function [w,beta,residp,residn,alp,alpo,totalviolation,dualgap,flag]...
      = sepelimdwdnonlinXQ(Xp,Xn,penalty,nonlin,penp,penn,wtp,wtn);
   %% Xingye Qiao has modified sepelimdwdnonlin to make it
   %% compatible to the last SPTD version. The main difference between this
   %% code and sepelimdwdnonlin is the specification of parameter and use
   %% of sqlp(...).
   
%global RpnY dgD V

   % This subroutine is designed to calculate a linear discriminator
   % based on the training data Xp and Xn and the violation cost penalty.
   % It uses the DWD method of J.S. Marron and M.J. Todd,
   % "Distance Weighted Discrimination," TR 1339, 
   % School of Operations Research and Industrial Engineering,
   % Cornell University, Ithaca, New York, available at
   % ftp://ftp.orie.cornell.edu/pub/techreps/TR1339.pdf.

   % The user will need to get the SDPT3 optimization package,
   % available at http://www.math.nus.edu.sg/~mattohkc/sdpt3.html,
   % and install it. We recommend that sep.m be run from the SDPT3
   % directory.

   % SDPT3 includes an m-file startup.m, which sets the path,
   % default parameters, and global environment variables.
   % If the user has his/her own startup routine, this may not
   % perform the necessary tasks. Either the instructions
   % in SDPT3's startup.m should be appended, or SDPT3's
   % startup.m be renamed startupSDPT3.m, say, and this called
   % at the appropriate place.

   % The subroutine contains various commented-out statements, which
   % can be reinstated by those users wishing to see the time taken in
   % various steps, the numbers of variables and constraints, etc.

   % Input:  Matrices Xp and Xn, whose columns contain the training
   %            data for positive and negative instances respectively;
   %         scalar penalty, the cost for perturbing each residual.
   %         nonlin, 0 for finding linear rules, 1 for nonlinear;
   %            if 1, user must provide a subroutine kernel(X,Z), which
   %            when called with input a d by n_x matrix X and a d by n_z matrix
   %            Z, returns the n_x by n_z matrix M with entries K(x_i,z_j),
   %            with x_i and z_j columns of X and Z, respectively.

   %         penp, vector of penalties for positive instances (penalty ignored)
   %         penn, vector of penalties for negative instances (penalty ignored)
   %         wtp, vector of weights on reciprocal residuals for pos. instances
   %         wtn, vector of weights on reciprocal residuals for neg. instances

   % Output: w and beta, such that, in the linear case, 
   %         x with w'x + beta positive (resp.,
   %            negative) is classified in the "+1" (resp. "-1") class.
   %         residp, the values of w'x + beta for x a column of Xp,
   %         residn, the values of w'x + beta for x a column of Xn.
   %         alp and alpo, related to dual solutions.
   %            In the linear case, alp is the dual solution and alpo 0.
   %              (Usually, w = [Xp, - Xn]*alp normalized.)
   %            In the nonlinear case, alpo is the dual solution and alp
   %              a related vector used to classify new points. In the usual
   %              case that norm(w) is 1, alp is (close to) 
   %              alpo / norm(RpnY*alpo).
   %              In any case, alp is chosen so that RpnY*alp is w. Then a new
   %              point x is classified via the sign of sum(alp_i kernel(x,x_i)) 
   %              (over the columns of Xp)
   %              - sum(alp_j kernel(x,x_j)) (over the columns of Xn) + beta
   %              (see test.m: a new point x is classified according to the
   %              sign of test(Xp,Xn,alp,beta,x)).
   %         totalviolation, the total amount added to the residuals.
   %         dualgap, the duality gap, a measure of the accuracy
   %            of the solutions found.
   %         flag, an indication of the success of the computation:
   %             0, success;
   %            -1, inaccurate solution;
   %            -2, problem infeasible or unbounded.

   %stime = cputime;
   if (nargin < 4), nonlin = 0; end;
   flag = 0;

   % Find the dimensions of the data.

   [dp,np] = size(Xp);
   [dn,nn] = size(Xn);
   if (dn ~= dp), error('The dimensions are incompatible.'), return, end;
   d = dp;

   XpnY = [Xp, -Xn];
   n = np + nn;

   % Set up the matrix RpnY.

   if (nonlin == 0),
      RpnY = XpnY;
   else,
      X = [Xp, Xn];
      M = kernel(X,X);
      %kerneltime = cputime - stime, stime = cputime;
      M = 0.5 * (M + M');
      [V,D] = eig(M);
      dgD = diag(D);
      index = find(abs(dgD) > 100*eps*norm(dgD,inf));
      sdgDi = sqrt(dgD(index));
      Vi = V(:,index);
      RpnY = diag(sdgDi)*Vi';
      %eigtime = cputime - stime, stime = cputime;
      RpnY(:,np+1:n) = - RpnY(:,np+1:n);
      d = size(RpnY,1);
   end;

   % Do the dimension reduction if in HDLSS setting.
 
   if (d > n),
       [Q,RpnY] = qr(RpnY,0); 
       %qrtime = cputime - stime, stime = cputime;
       dnew = n;
   else,
       dnew = d; 
   end;
   y = [ones(np,1); -ones(nn,1)];
   ym = y(2:n);

   % nv is the number of variables (eliminating beta), 
   % nc the number of constraints.

   nv = 1 + dnew + 3*n + n;
   nc = 2*n;
   %nv,
   %nc,

   % Set up the block structure, constraint matrix, rhs, and cost vector.

   blk = cell(2,2);
   blk{1,1} = 'q';
   blk{1,2} = [dnew+1, 3*ones(1, n)];
   blk{2,1} = 'l';
   blk{2,2} = n;
   %blk,

   Avec = cell(2,1);
   A = zeros(nc,nv-n);
   col1 = RpnY(:,1);
   A(1:n-1,2:dnew+1) = (RpnY(:,2:n) - col1*ym')';
   A(1:n-1,dnew+5:3:dnew+1+3*n) = - speye(n-1,n-1);
   A(1:n-1,dnew+6:3:dnew+2+3*n) = + speye(n-1,n-1);
   A(1:n-1,dnew+2) = ym;
   A(1:n-1,dnew+3) = -ym;
   A(n,1) = 1;
   A(n+1:n+n,dnew+4:3:dnew+3+3*n) = speye(n,n);
   %A,
   Avec{1,1} = A';
   Avec{2,1} = [[-ym,speye(n-1,n-1)];zeros(1+n,n)]';

   b = [zeros(n-1,1);ones(1+n,1)];
   %b,

   C = cell(2,1);
   c = zeros(nv-n,1);

   if (nargin < 8),
      c(dnew+2:3:dnew+1+3*n) = ones(n,1);
      c(dnew+3:3:dnew+2+3*n) = ones(n,1);
   else,
      c(dnew+2:3:dnew+1+3*n) = [wtp;wtn];
      c(dnew+3:3:dnew+2+3*n) = [wtp;wtn];
   end;

   %c,
   C{1,1} = c;
   
   if (nargin < 6),
      C{2,1} = penalty*ones(n,1);
   else,
      C{2,1} = [penp;penn];
   end;

   %setuptime = cputime - stime, stime = cputime;

   % Solve the SOCP problem.

   %startupSDPT3;
%   startup;
%   addpath '~/STAT/dwd/code/BatchAdjust/SubRoutines/SDPT3-3.0/Solver/' -end;
%   addpath '~/STAT/dwd/code/BatchAdjust/SubRoutines/SDPT3-3.0/Solver/mexexec' -end ;
   %%OPTIONS.vers = 2;
   %%OPTIONS.steptol = 1e-10;
   [OPTIONS] = sqlparameters ;  %% added by Xingye Qiao
   OPTIONS.maxit = 40;
   %OPTIONS.gaptol = 1e-10;
   [X0,lambda0,Z0] = infeaspt(blk,Avec,C,b);
   %startpttime = cputime - stime,
   %[obj,X,lambda,Z,info,gaphist,infeashist] = ...
   %   sqlp(blk,Avec,C,b,OPTIONS,X0,lambda0,Z0);
   %[obj,X,lambda,Z,gaphist,infeashist,info] = ...
   %   sqlp(blk,Avec,C,b,X0,lambda0,Z0,OPTIONS);
   [obj,X,lambda,Z,info] = sqlp(blk,Avec,C,b,OPTIONS,X0,lambda0,Z0); %% added by Xingye Qiao
   % If infeasible or unbounded, break.

   %%if (info(1) > 0), flag = -2; return, end;
   if (info.termcode > 0), flag = -2; return, end; %% added by Xingye Qiao
   
   % Compute the normal vector w and constant term beta.

   X1 = X{1}; X2 = X{2};
   
   barw = X1(2:dnew+1);
   if (d>n),
      w = Q*barw;
   else,
      w = barw;
   end;
   beta = X1(dnew+2) - X1(dnew+3) - X2(1) - col1'*barw;
   normw = norm(w);
   if normw < 1 - 1e-3, normw; end;
   if normw > 1 - 1e-3,
      w = w / normw;
      beta = beta / normw;
   end;

   % Compute the minimum of the supposedly positive 
   % and the maximum of the supposedly negative residuals.
   % Refine the primal solution and print its objective value.
   % disp(['Length of w = ' num2str(length(w))]) ;
   % disp(['Size of RpnY = ' num2str(size(RpnY))]) ;
   residp = RpnY(:,1:np)'*barw + beta .* ones(np,1);
   residn = -RpnY(:,np+1:n)'*barw + beta .* ones(nn,1);
   minresidp = min(residp);
   maxresidn = max(residn);
   res = RpnY'*barw + beta*y;
   rsc = 1/sqrt(penalty);
   xi = rsc - res;
   xi = max(xi,0);
   totalviolation = sum(xi);
   minresidpmod = min(residp+xi(1:np)); 
   maxresidnmod = max(residn-xi(np+1:n));
   minxi = min(xi);
   maxxi = max(xi);
   resn = res + xi;
   rresn = 1./resn;
   format long
   primalobj = penalty*sum(xi) + sum(rresn);  %%%XQ note: please be note that in wDWD case, the obj should be adjusted.

   % Compute the dual solution alp and print its objective value.

   alp = zeros(n,1);
   lambda1 = lambda(1:n-1);
   alp(1) = -ym'*lambda1;
   alp(2:n) = lambda1;
   alp = max(alp,0);
   sump = sum(alp(1:np));
   sumn = sum(alp(np+1:n));
   sum2 = (sump + sumn)/2;
   alp(1:np) = (sum2/sump)*alp(1:np);
   alp(np+1:n) = (sum2/sumn) * alp(np+1:n);
   maxalp = max(alp);
   if (maxalp > penalty | maxxi > 1e-3), 
      alp = (penalty/maxalp) * alp; 
   end;
   minalp = min(alp);
   p = RpnY*alp;
   eta = - norm(p);
   gamma = 2 * sqrt(alp);
   dualobj = eta + sum(gamma);
   format short

   % dualgap is the duality gap, a measure of the accuracy of the solution.

   dualgap = primalobj - dualobj;
   if (dualgap > 1e-4),
      flag = -1;
   end;

   % Recompute alp in the nonlinear case.

   alpo = alp;
   if (nonlin > 0),
      alp = Vi * (barw ./ sdgDi);
      alp(np+1:n) = - alp(np+1:n);
   end;
   return

