function Lstat = LstatisticSM(data,k,iratio) 
% LSTATISTICSM, L-statistic (Based on Linear Combination of Order Statistics)
%     Gives an order statistics based analog of moments (L-Moments)
%     And ratios of these that are analogs of moment based summaries:
%         Variance -   k = 2, iratio = 0
%         Skewness -   k = 3, iratio = 1
%         Kurtosis -   k = 4, iratio = 1
%   Can use 2 or 3 arguments.
%   Steve Marron's matlab function
% Inputs:
%     data - column vector or matrix of data, 
%                when this is a matrix, the
%                  L-Statistic of each column is computed
%
%        k - moment number, currently supported:  1, 2, 3, 4
%
%   iratio - output type:
%               0 - L-moment (straight linear combo of order statistic,
%                         i. e. analogs of centered moments)
%               1 - (or unspecified) gives L-statistic 
%                         as ratio of L-moments:
%                                k = 1   -   L-Mean
%                                k = 2   -   L-Variance
%                                k = 3   -   L-Skewness
%                                k = 4   -   L-Variance
%
% Output:
%       Lstat - scalar L-statistic for a vector input,
%                   or row vector of L-statistic's for a matrix input
%
% Assumes path can find personal function:
%    vec2matSM.m

%    Copyright (c) J. S. Marron 2012



%  Check Inputs
%
if ~((k == 1)  |  (k == 2)  |  (k == 3)  |  (k == 4)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from LstatisticSM:   !!!') ;
  disp(['!!!   Invalid input, k = ' num2str(k)]) ;
  disp('!!!   Terminating Execution      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  Lstat = [] ;
  return ;
end ;

%  Set iiratio according to number of input arguments
%
if nargin > 2 ;       %  more than 2 arguments input, use input iratio
  iiratio = iratio ;
else ;                 %  then use default value
  iiratio = 1 ;
end ;

if ~((iiratio == 0)  |  (iiratio == 1)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from LstatisticSM:   !!!') ;
  disp(['!!!   Invalid input, iiratio = ' num2str(iiratio)]) ;
  disp('!!!   Resetting to iiratio = 1     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  iiratio = 1 ;
end ;

%  Make sure input data vectors are long enough
%
if size(data,1) < k ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from LstatisticSM:   !!!') ;
  disp('!!!   Too few input rows         !!!') ;
  disp('!!!   Terminating Execution      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  Lstat = [] ;
  return ;
end ;




%  calculate Lstat
%
if k == 1 ;

  Lstat = mean(data,1) ;

else ;

  n = size(data,1) ;
  nc = size(data,2) ;

  Lstat = [] ;
  for ic = 1:nc ;

    vsdata = sort(data(:,ic)) ;
        %  vector of order statistics
    vim1 = ((1:n) - 1)' ;
        %  vector of (i - 1) values
    vnmi = (n - (1:n))' ;
        %  vector of (n - i) values

    if  iiratio == 1  |   k == 2  ;
      Lvar = (vim1 - vnmi)' * vsdata ;
      Lvar = Lvar / (n * (n - 1)) ;
    end ;

    if k == 2 ;    %  Take Lvar, computed above as output
      L = Lvar ;
    else ;    %  Need higher L-moment

      if k == 3 ;    %  Compute 3rd L-moment
        L = (vim1.^2 - vim1 ...
             - 4 * (vim1 .* vnmi) ...
             + vnmi.^2 - vnmi)' ...
                     * vsdata ;
        L = L / (n * (n - 1) * (n - 2)) ;
      else ;    %  Compute 4th L-moment
        L = (vim1.^3 - 3*vim1.^2 + 2*vim1 ...
             - 9 * (vim1.^2 - vim1) .* vnmi ...
             + 9 * vim1 .* (vnmi.^2 - vnmi) ...
             - (vnmi.^3 - 3*vnmi.^2 + 2*vnmi))' ...
                     * vsdata ;
        L = L / (n * (n - 1) * (n - 2) * (n - 3)) ;
      end ;

      if iiratio == 1 ;    %  Then need to divide by Lvar

        if Lvar == 0 ;
          disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
          disp('!!!   Warning from LstatisticSM:           !!!') ;
          disp('!!!   all inputs same, so L-variance = 0   !!!') ;
          disp('!!!   Setting output ratio to 0            !!!') ;
          disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
          L = 0 ;
        else ;
          L = L / Lvar ;
        end ;

      end ;

    end ;


    Lstat = [Lstat L] ; 
        %  Update output vector


  end ;

end ;








