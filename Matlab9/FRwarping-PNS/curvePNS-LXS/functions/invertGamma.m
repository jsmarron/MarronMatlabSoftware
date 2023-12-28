function gamI = invertGamma(gam)

N = length(gam);
x = [0:N-1]/(N-1);
gamI = spline(gam,x,x);%interp1(gam,x,x);
gamI = gamI/gamI(N);
