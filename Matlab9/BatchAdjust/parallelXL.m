function  [vdir,var]= parallelXL(mdat,part)
%Load data  d*(2n)
n = size(mdat,2)/2 ; 
d = size(mdat,1) ; 
%%% Decomposite data; User lower dimension
%% Don't Use QR, For large Matrix, it's too slow; 
%% use decompXL instead 
[q,s] = decompXL(mdat) ;  
mdat = s ; 

%%%% Parelle direction 
mdat1 = mdat(:,1:n) ; 
mdat2 = mdat(:,(n+1):2*n) ; 
datdiff = mdat1- mdat2; 
%%%% X axis direction 
datcomb= [datdiff,mdat2] ; 
[EignM0,Eignv] = qr(datcomb) ;  
EignM1 = EignM0(:,(n+1):2*n) ;  
datM = EignM1'*mdat1 ; 
[V1,D1]= eigs(datM*datM') ; 
vdir(:,1)= EignM1*V1(:,1) ;  %%% Recover direction
var(1) = D1(1,1) ; 

%%%% Y axis direction 
if  part == 1 
    datdiff1 = datdiff - vec2matSM(mean(datdiff,2),n); 
    datdiff2 = datdiff1*datdiff1' ; 
    [V2,D2] = eigs(datdiff2) ; 
    vdir(:,2) = V2(:,1) ; 
    var(2) = D2(1,1) ; 
elseif part == 2 
   datdiff2 = datdiff*datdiff' ; 
   [V2,D2] = eigs(datdiff2) ; 
    vdir(:,2) = V2(:,1) ; 
    var(2) = D2(1,1) ; 
end
%%% Recover the vector
vdir = q * vdir ; 
if vdir(1,1) < 0
   vdir(:,1) = -vdir(:,1) ;
end
if vdir(1,2) <0 
    vdir(:,2) = -vdir(:,2) ;
end

