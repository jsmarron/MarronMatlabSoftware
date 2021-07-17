%%%********************************************************************
%% vecMultiply: Compute [Z*Z'+I Zy;y'*Z' y'*y]*[w;belta]  
%%********************************************************************

    function Aq= vecMultiply(Z,y,x,const)

    d = length(x)-1;
    w = x(1:d); beta = x(d+1);
    tmp = mexMatvec(Z,w,1,y*beta);
    Aq = zeros(d+1,1); 
    Aq(1:d) = mexMatvec(Z,tmp,0,const*w); 
    Aq(d+1) = y'*tmp;
%%********************************************************************
