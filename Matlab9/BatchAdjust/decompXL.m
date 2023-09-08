function  [mdir,mdatp] = decompXL(mdat)
%% Decompostion for Matrix mdat
%% Decomposite one column by another. 
%% Output Direction Vector
%% Output Projections on these directions
%%  means ith column decomposite to 1 to k th direction vector 

d = size(mdat,1) ; 
n = size(mdat,2) ;
index(1) = 1 ; 
k = 1 ; 
mdir(:,1) = mdat(:,1)./sqrt(mdat(:,1)'*mdat(:,1)) ; 
for i = 1:(n-1) 
    vec = mdat(:,i+1) - mdir(:,1:k)*[mdat(:,i+1)'*mdir(:,1:k)]';
    if sum(vec == zeros(d,1))~=d ; 
        mdir(:,i+1) = vec./sqrt(vec'*vec) ; 
        k = k+1 ; 
        index(i+1) = k ; 
    else 
        index(i+1) = k ; 
    end
end

mdir = mdir(:,1:index(n));
mdatp = mdir'*mdat ; 
    