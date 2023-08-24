function mk = k2dgSM(igrid,jgrid,h,ideriv,inorm) 
% K2DG, Kernel: 2 Dimensional Gaussian
%     Creates a matrix of Gaussian Kernel Weights,
%       for image smoothing
%   Steve Marron's matlab function
%     Designed for use in conv2(image,kernel),
%       [in the form kernel = k2dg(((1-n):(n-1))',(1-m):(m-1),h) ;]
%     Note:  the assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
%            For "Cartesian style coordinates", where
%                   indices are (xgrid,ygrid), 
%                              xgrid horizontal (running in columns),
%                              ygrid vertical (running in rows),
%            use k2dg(ygrid,xgrid) ;
%   Can use first 3, 4 or 5 arguments.
% Inputs:
%     igrid  -  n x 1 column vector of "i-values"
%                     at which to evaluate the kernel
%     jgrid  -  1 x m row vector of "j-values"
%                     at which to evaluate the kernel
%     h      -  scalar bandwidth, must be > 0
%                     (later may implement vector and matrix versions)
%     ideriv -  scalar indexing partial derivatives
%                     (optional, default is 0)
%                          0  - take no derivatives
%                          1  - partial derivative with respect to i
%                          2  - partial derivative with respect to j
%                          11 - partial derivatives with respect to i,i
%                          12 - partial derivatives with respect to i,j
%                          22 - partial derivatives with respect to/ j,j
%     inorm  -  scalar indicating type of normalization of weights
%                     (optional, default is 1)
%                           1 - regression weights (sum to 1)
%                           2 - density estimation (integrate to 1)
%
% Output:
%     mk     -  matrix of kernel weights (ready for use in conv2)
%
% Assumes path can find personal function:
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2023



%  Set parameters and defaults according to number of input arguments
%
if nargin <= 3    %  at most 3 arguments input
  iideriv = 0 ;    %  Default
else
  iideriv = ideriv ;    %  use input number of derivatives
end

if nargin <= 4    %  at most 4 arguments input
  iinorm = 1 ;    %  Default
else
  iinorm = inorm ;    %  use input type of normalization
end



%  Do checks of inputs
%
if size(igrid,2) == 1
  istop = 0 ; %#ok<NASGU>

  if size(jgrid,1) == 1
    istop = 0 ; %#ok<NASGU>

    if (iideriv == 0) || (iideriv == 1) || (iideriv == 2) || ...
               (iideriv == 11) || (iideriv == 12) || (iideriv == 22)   
      istop = 0 ; %#ok<NASGU>

      if (iinorm == 1) || (iinorm == 2)
        istop = 0 ;
      else
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Warning from k2dg.m:  inorm is not valid   !!!') ;
        disp('!!!        returning an empty weight matrix      !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        istop = 1 ;
      end

    else
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from k2dg.m:  ideriv is not valid   !!!') ;
      disp('!!!         returning an empty weight matrix      !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      istop = 1 ;
    end

  else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from k2dg.m:  jgrid is not a row vector,   !!!') ;
    disp('!!!           returning an empty weight matrix           !!!') ;
    disp('!!!   (if using Cartesian coordinates, see "help k2dg"   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    istop = 1 ;
  end

else
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from k2dg.m:  igrid is not a col vector,   !!!') ;
  disp('!!!           returning an empty weight matrix           !!!') ;
  disp('!!!   (if using Cartesian coordinates, see "help k2dg"   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  istop = 1 ;
end




%  Now do main evaluation
%
if istop == 0   %  all inputs were OK, so proceed

  n = length(igrid) ;     %  same notation as in conv2
  m = length(jgrid) ;


  %  Evaluate marginal kernels
  %
  ioverh = igrid / h ;
  ki = exp(-ioverh.^2 / 2) / h ;

  joverh = jgrid / h ;
  kj = exp(-joverh.^2 / 2) / h ;


  %  do normalization
  %
  if iinorm == 1     % use regression normalization
    ki = ki ./ sum(ki) ;
    kj = kj ./ sum(kj) ;
  else    %  use density estimation normalization
    ki = ki ./ sqrt(2 * pi) ;
    kj = kj ./ sqrt(2 * pi) ;
  end
          %  !!! Caution, this assumes a circular bandwidth



  %  add suitable factors for derivatives, if needed
  %
  if (iideriv == 1) || (iideriv == 12)
                     %  then want first partial deriv with respect to i
    ki = ki .* (- ioverh / h) ;
  elseif iideriv == 11
                     %  then want second partial deriv with respect to i
    ki = ki .* ((ioverh.^2 - 1) / h^2) ;
  end

  if (iideriv == 2) || (iideriv == 12)
                     %  then want first partial deriv with respect to j
    kj = kj .* (- joverh / h) ;
  elseif iideriv == 22
                     %  then want second partial deriv with respect to j
    kj = kj .* ((joverh.^2 - 1) / h^2) ;
  end



  %  combine to get product kernel
  %
  mk = vec2matSM(ki,m) .* vec2matSM(kj,n) ;
          %  !!! Caution, this whole approach assumes a circular bandwidth



else    %  had bad inputs, so return empty matrix

  mk = [] ;

end


