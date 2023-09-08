function [MDPdir,MDPgap,MDPint] = MaxDatPilJA(trainp,trainn,iwarn) 
% MaxDatPilSM, Maximal Data Piling
%     This finds the Maximal Data Piling Direction,
%     plus the intercept (half way between) for
%         discrimination
%     and the gap between the clusters
%     Based on mdpJA,
%         by Jeonyoun Ahn
%   Steve Marron's matlab function
% Inputs:
%        trainp - d x n1 training data for the class "positive"
%        trainn - d x n2 training data for the class "negative"
%         iwarn - integer controlling level of warning
%                         of floating point numerical problems
%                         (as determined by gap too small):
%              0  no warning, just output whatever is calculated
%              1  print warning to screen, but give output
%              2  (default)  print warning to screen, and return 0s for all outputs
%
% Outputs:
%    MDPdir - Maximal Data Piling Direction vector,
%                 Makes projection pile up completely
%                 at just two data points
%    MDPgap - Maximal Data Piling Gap,
%                 distance between data piling points
%    MDPint - Maximal Data Piling Intercept,
%                 halfway between data piling points,
%                 gives cutoff when this is used for discrimination
%
% Assumes path can find personal function:
%    vec2matSM.m

%    Copyright (c) J. Y. Ahn, J. S. Marron, 2005, 2023


%  Set parameters according to number of input arguments
%
if nargin == 2       %  only 2 argument inputs, use default icheck
  iiwarn = 2 ;
else                 %  then use input value
  iiwarn = iwarn ;
end



%  Do Main Calculation
%
mdata = [trainp,trainn] ;
n = size(mdata,2) ;
vmean = mean(mdata,2) ;
mresid = mdata - vec2matSM(vmean,n) ;

vmeanp = mean(trainp, 2) ;
vmeann = mean(trainn, 2) ;

[v,s,~] = svd(mresid,0) ;
%[v,s,u] = svd(mresid,0) ;
s = diag(s) ;
    %  vector of singular values (sqrt(eigenvalues))

flag0 = (s == 0) ;
s = s(~flag0) ;
v = v(:,~flag0) ;

if s(end) < s(end-1) * 10^(-12)
                  %  then last eigenvalue is too small,
                  %  so cut it off
  s = s(1:(end-1)) ;
  v = v(:,1:(end-1)) ;
end

s2 = s .^ (-2) ;

MDPdir = v' * (vmeanp - vmeann) ;
    %  should point from negative to positive
MDPdir = v * diag(s2) * MDPdir ;
MDPdir = MDPdir / norm(MDPdir) ;

MDPgap = MDPdir' * (vmeanp - vmeann) ;

MDPint = MDPdir' * (vmeanp + vmeann) / 2 ;


if iiwarn ~= 0

  if MDPgap < (max(s) * 10^(-15))

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from MaxDatPilSM:   !!!') ;
    disp('!!!   MDPgap is smaller than      !!!') ;
    disp('!!!   roundoff error.             !!!') ;
    disp('!!!   MDPdir could be unstable    !!!') ;

    if iiwarn == 1

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    else

      disp('!!!  Setting all outputs to 0     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      MDPdir = 0 ;
      MDPgap = 0 ;
      MDPint = 0 ;

    end

  end

end


