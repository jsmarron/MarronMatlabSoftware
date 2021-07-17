function [ obj, runhist ] = SVMsolve( y, X, nu, options )
%A function for solving nu-SVM
%Inputs:
% y: m by 1 vector of training labels
% X: m by n matrix of m training samples with n features.
% nu: parameter in [0,1) for nu-SVM
% options: structure array for other parameters
%     method: method to solve nu-SVM ('APG', 'LIBSVM' or 'SeDuMi')
%     kernel: kernel to use ('lin': xi'*xj, or 'rbf': exp(-|xi-xj|^2/(2*sigma^2))
%     sigma: parameter for RBF kernel (default: sqrt(n/2))
%
%     eps, maxit, and other parameters for each method can be set,
%     e.g. 'heuristic' for LIBSVM (0 or 1).
%     See also APG() for its parameters.
%

if nargin == 3
    options.method = 'APG';
    options.kernel = 'lin';
    display('Auto setting: APG with linear kernel.');
end
obj.kernel = options.kernel;

switch options.method
    case {'LIBSVM','SMO'}
%         addpath('libsvm/matlab');
        %mm = length(y);
        [mm,nn] = size(X);
%         args = ['-s 0 -c ',num2str(nu),' ']; % C-SVM
        args = ['-s 1 -n ',num2str(nu),' ']; % nu-SVM 
%         args = ['-s 1 -n 0.5 '];
        if(isfield(options,'eps')); args = [args,'-e ',num2str(options.eps),' ']; end
        if(isfield(options,'heuristic')); args = [args,'-h ',num2str(options.heuristic),' ']; end
        switch options.kernel
            case {'lin','linear',0,'0'}; args = [args,'-t 0 '];
            case {'poly','polynomial',1,'1'}; args = [args,'-t 1 '];
            case {'rbf','RBF','Gaussian',2,'2'}; args = [args,'-t 2 '];
        end
        if(isfield(options,'sigma')); args = [args,'-g ',num2str(1/(2*options.sigma^2)),' ']; end
        if(isfield(options,'gamma')); args = [args,'-g ',num2str(options.gamma),' ']; end;
        if(isfield(options,'d')); args = [args,'-d ',num2str(options.d),' ']; end;
        if(isfield(options,'b')); args = [args,'-b ',num2str(options.b),' ']; end; 
%         display(args);
        tstart = clock;
        svm = svmtrain(y, X, args);
        ttime = etime(clock,tstart);
        obj.model = svm;
        q = zeros(mm,1);
        q(svm.sv_indices) = svm.sv_coef;
        obj.q = q .* y;
        obj.l = sum(obj.q);
        obj.b = svm.rho/obj.l;
        obj.q = obj.q/obj.l;
        spy = spdiags(y,0,mm,mm);
        if strcmp(options.kernel,'lin')
            obj.val = norm(X'*spy*obj.q)^2/2;
        else
            K = kernelmatrix(options.kernel,X,[],options);
            obj.val = obj.q'*spy*K*spy*obj.q/2;
        end
        obj.time = ttime;
        fprintf('\nm=%2.0f, n=%2.0f, time=%3.2f\n',mm,nn,obj.time);
        q = obj.q;
        ind_sv = (q > 0) & (q < 1/(mm*nu));
        ind_svp = ind_sv & (y==1);
        ind_svn = ind_sv & (y==-1);
        sp = sum(ind_svp); sn = sum(ind_svn);
        s = min(sp,sn);
        if sp ~= 0 && sn ~= 0
            Sp = find(ind_svp,s);
            Sn = find(ind_svn,s);
        elseif sp == 0 && sn~=0;
            [tmp,Sp] = max(q(y==1));
            Sn = find(ind_svn,1);
        elseif sp~=0 && sn==0;
            Sp = find(ind_svp,1);
            [tmp,Sn] = max(q(y==-1));
        else
            [tmp,Sp] = max(q(y==1));
            [tmp,Sn] = max(q(y==-1));
        end
        XSp = X(Sp,:);
        XSn = X(Sn,:);
        if strcmp(options.kernel,'lin')
            w = X'*(y.*q);
            sumSp = sum(XSp*w); sumSn = sum(XSn*w);
        else
            sumSp = sum(kernelmatrix(options.kernel,X,XSp,options)'*spdiags(y,0,mm,mm)*q);
            sumSn = sum(kernelmatrix(options.kernel,X,XSn,options)'*spdiags(y,0,mm,mm)*q);
        end
        obj.b = -(sumSp+sumSn)/(2*s);
        obj.accuracy = length(find(y.*(X*w+obj.b)>=0))/mm*100; %% newly added
        obj.w = w;
        
    case {'LIBLINEAR'}
%       addpath('libsvm/matlab');
        %mm = length(y);
        [mm,nn] = size(X);
%         args =  ['-s 2 -C '];
        args = ['-s 3 -c ',num2str(nu),' '];
        if(isfield(options,'eps')); args = [args,'-e ',num2str(options.eps),' ']; end
        if(isfield(options,'b')); args = [args,'-B ',num2str(options.b),' ']; end; 
%         display(args);
        tstart = clock;
        svm = train(y, X, args);
        ttime = etime(clock,tstart);

        obj.model = svm;
        obj.penaltyParameter = nu;
        obj.time = ttime;
        
    case {'SeDuMi','interior'}
%         addpath('sedumi');
        pars.maxiter = 200;
        if isfield(options,'eps'); pars.eps = options.eps; end
        if isfield(options,'maxit'); pars.maxiter = options.maxit; end
        [mm,nn] = size(X);
        X = full(X);

        eta = 1/(nu*mm);

        tstart = clock;
        % max_{(q,t)} -t
        b = sparse(mm+1,1,-1);
        
        % s.t.
        % two equality constraints
        K.f = 2;
        % sum(q) = 1
        Atlin1 = [ones(1,mm),0]; clin1 = 1;
        % y'*q = 0
        Atlin2 = [y',0]; clin2 = 0;
        
        % 2*mm inequality constraints (upper and lower bounds)
        K.l = 2*mm;
        % -q <= 0
        Atineq1 = [-speye(mm),zeros(mm,1)]; cineq1 = sparse(1,1,0,mm,1); % allzero
        % q <= eta
        Atineq2 = [speye(mm),zeros(mm,1)]; cineq2 = ones(mm,1)*eta;
        
        % Second order cone constraint
        % |(yKy)^{1/2}q| <= t
        spy = spdiags(y,0,mm,mm);
        switch options.kernel
            case {'lin','linear',0,'0'}
                L = X'*spy;
                Atsoc = [sparse(1,mm+1,-1);...
                       -L,zeros(nn,1)];
                csoc = sparse(1,1,0,nn+1,1); % allzero
                K.q = nn+1;
                
            case {'poly','polynomial',1,'1'} 
                display('Unrecommended: SeDuMi with Polynomial Kernel');
                Kmat = spy*kernelmatrix('poly',X,[],options)*spy;
                try
                    L = sparse(chol(Kmat));
                catch 
                    L = sparse(chol(Kmat+spdiags(ones(mm,1),0,mm,mm)*1e-12));
                    %L = sqrtm(Ker);
                end
                clear('Kmat');
                Atsoc = [sparse(1,mm+1,-1);-L,zeros(mm,1)];
                csoc = sparse(1,1,0,mm+1,1); % allzero
                K.q = mm+1;
                
            case {'rbf','RBF','Gaussian',2,'2'} 
                Kmat = spy*kernelmatrix('rbf',X,[],options)*spy;
                try
                    L = sparse(chol(Kmat));
                catch 
                    L = sparse( chol( Kmat + spdiags(ones(mm,1),0,mm,mm)*1e-12 ) );
                    %L = sqrtm(Ker);
                end
                clear('Kmat');
                Atsoc = [sparse(1,mm+1,-1);-L,zeros(mm,1)];
                csoc = sparse(1,1,0,mm+1,1); % allzero
                K.q = mm+1;
        end
        % Aggregate A and c
        A = [Atlin1;Atlin2;Atineq1;Atineq2;Atsoc]';
        %c = sparse([1,(mm+3):(2*mm+2)]',ones(mm+1,1),[1;ones(mm,1)*eta],1+1+mm+mm+(K.q),1);
        c = [clin1;clin2;cineq1;cineq2;csoc];

        % calc
        [xs,ys,info] = sedumi(A,b,c,K,pars);
        ttime = etime(clock,tstart);

        obj.time = ttime;
        obj.info = info;
        obj.q = ys(1:mm);

        % recalc
        ind_pos = y==1; ind_neg = y==-1;
%         obj.q(ind_pos) = projOntoRS(obj.q(ind_pos),1/2,eta);
%         obj.q(ind_neg) = projOntoRS(obj.q(ind_neg),1/2,eta);
        obj.q = projOntoUpperBoundedSimplex(obj.q,ind_pos,ind_neg,eta);
        obj.val = norm(L*obj.q)^2/2;
        
    case 'APG'
        [mm, nn] = size(X);
        ind_pos = y == 1;
        ind_neg = y == -1;
        m_pos = sum(ind_pos);
        m_neg = sum(ind_neg);
        eta = 1/(nu*mm);
        initq = zeros(mm,1);
        initq(ind_pos) = 0.5/m_pos;
        initq(ind_neg) = 0.5/m_neg;
        
        functime = clock;
        switch options.kernel
            case {'lin','linear',0,'0'}
                X = cmp_sp_full(X);
                Ztil = X' * spdiags(y,0,mm,mm);
                func = @(q) norm(Ztil*q)^2/2;
                grad = @(q) Ztil'*(Ztil*q);
                if(~isfield(options,'Lip')); 
                    options.Lip = full(max(sum(Ztil.*Ztil)));
                    %tmp = initq + randn(length(initq),1)/sqrt(length(initq));
                    %options.Lip = norm(grad(initq)-grad(tmp))/norm(initq - tmp);
                end
                
            case {'poly','polynomial',1,'1'}
                X = full(X);
                spy = spdiags(y,0,mm,mm);
                yKy = spy*kernelmatrix('poly',X,[],options)*spy;
                func = @(q) q'*yKy*q/2;
                grad = @(q) yKy*q;
                if(~isfield(options,'Lip')); 
                    options.Lip = full(max(diag(yKy)));
                    %tmp = initq + randn(length(initq),1)/sqrt(length(initq));
                    %options.Lip = norm(grad(initq)-grad(tmp))/norm(initq - tmp);
                end
                
            case {'rbf','RBF','Gaussian',2,'2'}
                X = full(X);
                spy = spdiags(y,0,mm,mm);
                yKy = spy*kernelmatrix('rbf',X,[],options)*spy;
                func = @(q) q'*yKy*q/2;
                grad = @(q) yKy*q;
                if(~isfield(options,'Lip')); 
                    options.Lip = full(max(diag(yKy)));
                    %tmp = initq + randn(length(initq),1)/sqrt(length(initq));
                    %options.Lip = norm(grad(initq)-grad(tmp))/norm(initq - tmp);
                end
        end%switch kernel
        functime = etime(clock,functime);
        proj = @(q) projOntoUpperBoundedSimplex(q,ind_pos,ind_neg,eta);
        [obj,runhist] = APG(initq,func,grad,proj,options);
        obj.apgtime = obj.time;
        obj.functime = functime;
        obj.time = obj.apgtime + obj.functime;
        obj.q = obj.x;
        obj.L = obj.Lip;
    otherwise
        error(['Undefined method: ',options.method]);
end%switch method
end%function

function q = projOntoUpperBoundedSimplex(q,ind_pos,ind_neg,eta)
    q(ind_pos) = projOntoRS(q(ind_pos),0.5,eta);
    q(ind_neg) = projOntoRS(q(ind_neg),0.5,eta);
end