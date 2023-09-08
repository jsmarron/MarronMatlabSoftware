function [eigvec, score, eigval, order] = CDMpcaMA(X, method, ite)
% --------------------------------------------------------------
%
%   Principal Component Analysis for High-Dimensional Data
%   We use the cross-data-matrix (CDM) methodology originally given by Yata and Aoshima [6].
%
% -------------- Input ----------------
%   X: p x n Data matrix, X=[x1,...,xn]
%        p: The number of variables
%        n: The number of samples
%   method: Select one of the following CDM methods
%        'cdm'(default): Standard CDM method (which splits the data matrix, X, into two column subsets at random)
%               Recommended for n >= 100
%        'minmean': Minimum mean distance method (which chooses the partition to minimize a distance between the two divided marices)
%               Recommended for mixture models
%        'gcdm': Generalized CDM method (which repeats the CDM method and takes the average of the results)
%               Recommended for n < 100
%   ite: Iteration times (default = 100)
%
% -------------- Output ---------------
%   eigvec: Estimated eigenvectors (The i-th column vector corredponds to the i-th PC direction)
%   score:  Principal component scores (The (i,j) component corresponds to the i-th PC score of the j-th data, xj)
%   eigval: Estimated eigenvalues (The i-th component corresponds to the i-th eigenvalue)
%   order:  The order of the permutation for the data splitting 
%-------------------------
%
%   Copyright \[Copyright] Aoshima Lab. (Makoto AOSHIMA), University of Tsukuba. All Rights Reserved.
%   URL: http://www.math.tsukuba.ac.jp/~aoshima-lab/
%   E-MAIL: aoshima[at]math[dot]tsukuba[dot]ac[dot]jp
%
%----------------------------------------------------------------------------------------
%
%   REFERENCES:
%   [1] Aoshima, M. and Yata, K. (2011a). 
%       Two-stage procedures for high-dimensional data, 
%       Sequential Anal. (Editor's special invited paper), 30, 356-399.
%   [2] Aoshima, M. and Yata, K. (2011b).
%       Effective methodologies for statistical inference on microarray studies,
%       In: Prostate Cancer -From Bench to Bedside (ed. P. E. Spiess), 13-32, InTech.
%   [3] Aoshima, M. and Yata, K. (2013a).
%       A distance-based, misclassification rate adjusted classifier for multiclass, high-dimensional data,
%       Ann. Inst. Statist. Math., in press.
%   [4] Aoshima, M. and Yata, K. (2013b). 
%       The JSS Research Prize Lecture: Effective methodologies for high-dimensional data, 
%       J. Japan Statist. Soc. Ser. J, 43, 123-150.
%   [5] Aoshima, M. and Yata, K. (2013c). 
%       Invited Review Article: Statistical inference in high-dimension, low-sample-size settings, 
%       Sugaku, 65, 225-247.
%   [6] Yata, K. and Aoshima, M. (2010). 
%       Effective PCA for high-dimension, low-sample-size data with singular value decomposition of cross data matrix, 
%       J. Multivariate Anal., 101, 2060-2077.
%   [7] Yata, K. and Aoshima, M. (2013). 
%       PCA consistency for the power spiked model in high-dimensional settings, 
%       J. Multivariate Anal., 122, 334-354. 
%

%---------- Initialization ----------
if nargin < 3, ite = 100; end
if isempty(ite), ite = 100; end


if nargin < 2, method = 'cdm'; end
if isempty(method), method = 'cdm'; end

if strcmp(method,'cdm') == 0 && strcmp(method,'minmean') == 0 && strcmp(method,'gcdm') == 0,method = 'cdm';disp(['Method you input is not difined.' char (10) 'Data are analyzed by a standard CDM method.'])
end



[p,n]=size(X);
n1 = ceil(n/2);
n2 = n-n1;
r = min(n2-1,p);
eigval = zeros(r,1);
score = zeros(r,n);
eigvec = zeros(p,r);

if strcmp(method,'cdm')==1 || strcmp(method,'minmean')==1
    
    %---------- Estimate eigenvalue and eigenvector ----------
    
    switch method
        case 'cdm'
            order = randsample(1:n,n);
            Xperm = zeros(p,n);
            
            for i = 1:n
                Xperm(:,i) = X(:,order(i));
            end
            
            X1 = Xperm(:,1:n1);
            X2 = Xperm(:,n1 + 1:n);
            
            for i = 1:p
                X1(i,:) = X1(i,:) - mean(X1(i,:));
                X2(i,:) = X2(i,:) - mean(X2(i,:));
            end
            
        case 'minmean'
            md = inf;
            Xperm = zeros(p,n);
            for k = 1:ite
                temporder = randsample(1:n,n);
                
                for i = 1:n
                    Xperm(:,i) = X(:,temporder(i));
                end
                
                X1 = Xperm(:,1:n1);
                X2 = Xperm(:,n1 + 1:n);
                md2 = abs((norm(mean(X1,2)-mean(X2,2)))^2 - trace (cov(X1))/n1 - trace (cov(X2))/n2);
                if md > md2
                    md = md2;
                    order = temporder;
                end
            end
            
            for i = 1:n
                Xperm(:,i) = X(:,order(i));
            end
            X1 = Xperm(:,1:n1);
            X2 = Xperm(:,n1 + 1:n);
            
            for i = 1:p % Centering
                X1(i,:) = X1(i,:) - mean(X1(i,:));
                X2(i,:) = X2(i,:) - mean(X2(i,:));
            end
    end
    
    
    
    
    Sd1 = X1'*X2/sqrt((n1-1)*(n2-1));   % The cross-data-matrix
    [U,S,V] = svd(Sd1);
    eigval = diag(S(1:r,1:r));
    
    for j = 1:r
        V(:,j) = sign(U (:,j)'*X1'*X2*V(:,j))*V(:,j);
    end
    
    for i = 1:r
        eigvec(:,i) = (X1*U (:,i)/sqrt(n1 - 1) + X2*V (:,i)/sqrt(n2 - 1))/(2*sqrt(eigval(i)));
        eigvec(:,i) = eigvec (:,i)/norm(eigvec(:,i));
    end
    
    %---------- Calculate score ----------
    score1 = zeros(r,n1);
    score2 = zeros(r,n2);
    for i = 1:r
        for j = 1:n1
            score1(i,j) = U(j,i)*sqrt((n1)*eigval(i));
        end
    end
    
    for i = 1:r
        for j = 1:n2
            score2(i,j) = V(j,i)*sqrt((n2)*eigval(i));
        end
    end
    
    permscore = horzcat(score1,score2);
    
    for i = 1:n    % Reordering
        score(:,order(i)) = permscore(:,i);
    end
    
else    % GCDM
    order=zeros(ite,n);
    
    for t = 1:ite
        order(t,:) = randsample(1:n,n);
    end
    
    
    for t = 1:ite
        Xperm = zeros(p,n);
        
        for i = 1:n
            Xperm(:,i) = X(:,order(t,i));
        end
        
        X1 = Xperm(:,1:n1);
        X2 = Xperm(:,n1 + 1:n);
        
        for i = 1:p   % Centering
            X1(i,:) = X1(i,:) - mean(X1(i,:));
            X2(i,:) = X2(i,:) - mean(X2(i,:));
        end
        
        Sd1 = X1'*X2/sqrt((n1-1)*(n2-1));   % The cross-data-matrix
        [U,S,V] = svd(Sd1);
        eigval = eigval + diag(S(1:r,1:r));
       
        if t==1
            U1=U;
        end
        
        
        if t ~= 1
            for j = 1:r
              U(:,j) = sign(U (:,j)'*U1(:,j))*U(:,j);
            end
        end
        
        for j = 1:r
           V(:,j) = sign(U (:,j)'*Sd1*V(:,j))*V(:,j);
        end
        
        
        
        eigvectemp = zeros(p,r);
        
        for i = 1:r
           eigvectemp(:,i) = (X1*U (:,i)/sqrt(n1 - 1) + X2*V (:,i)/sqrt(n2 - 1))/2*sqrt(S(i,i));
           eigvectemp(:,i) = eigvectemp (:,i)/norm(eigvectemp(:,i));
        end

        
        eigvec = eigvec + eigvectemp;
        
        %-------Calculate score-------
        score1 = zeros(r,n1);
        score2 = zeros(r,n2);
        scoretemp = zeros(r,n);
        for i = 1:r
            for j = 1:n1
                score1(i,j) = U(j,i)*sqrt((n1)*S(i,i));
            end
        end
        
        for i = 1:r
            for j = 1:n2
                score2(i,j) = V(j,i)*sqrt((n2)*S(i,i));
            end
        end
        
        permscore = horzcat(score1,score2);
        
        for i = 1:n
            scoretemp(:,order(t,i)) = permscore(:,i);
        end
        
        if t==1
            scoret1=scoretemp;
        end
        
        if t ~= 1
            for i = 1:r
                scoretemp(i,:) = sign(scoretemp(i,:)*scoret1 (i,:)')*scoretemp(i,:);
            end
        end
        
        score = score + scoretemp;
        
    end
    
    score = score/ite;
    eigval = eigval/ite;
    
    eigvec = eigvec/ite;
       
    for i = 1:r
        eigvec(:,i) = eigvec (:,i)/norm(eigvec(:,i));
    end
    
 
    
end

