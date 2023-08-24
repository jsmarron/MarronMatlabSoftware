function sss2sspSM(smallessflag,smallessflagdec,n,m,nres,zerosize) 
% SSS2SSPSM, Function for SSS2, this overlays some 0's, on the current image.
%     Intended to be used by SSS2, when the Effective Sample Size is
%     somewhere not large enough.
%   Steve Marron's matlab function
% Inputs:
%       smallessflag - matrix with 1 where ESS is small
%    smallessflagdec - decimated version, used when nres = 2
%                  n - number of rows in image
%                  m - number of columns in image
%               nres - resolution of SSS symbols:    (called ivitype(2) in sss1.m)
%                          1  -  1x1 single pixels
%                          2  -  2x2 blocks
%           zerosize - Size of Zeros to Plot
% Outputs:
%
%       Only graphics added to current axes.
% Assumes path can find personal functions:
%    vec2matSM

%    Copyright (c) J. S. Marron 1999, 2001, 2004, 2023



if nres == 1    %  then are working with single pixels

  i0cent = vec2matSM((1:n)',m) ;
  j0cent = vec2matSM((1:m),n) ;

  i0cent = i0cent(smallessflag) ;
  j0cent = j0cent(smallessflag) ;

elseif nres == 2    %  then are working with 2x2 blocks
  mo2 = floor(m/2) ;
  no2 = floor(n/2) ;

  i0cent = reshape((1:(2*no2))',2,no2)' ;
  i0cent = mean(i0cent') ; %#ok<UDIM>
          %  midpoints of 2 x 2 blocks
  i0cent = vec2matSM(i0cent',mo2) ;
  i0cent = reshape(i0cent,no2*mo2,1) ;

  j0cent = reshape((1:(2*mo2))',2,mo2)' ;
  j0cent = mean(j0cent') ; %#ok<UDIM>
          %  midpoints of 2 x 2 blocks
  j0cent = vec2matSM(j0cent,no2) ;
  j0cent = reshape(j0cent,no2*mo2,1) ;

  i0cent = i0cent(smallessflagdec) ;
  j0cent = j0cent(smallessflagdec) ;

end


hold on ;    %  overlay 0's where sample size is small
  plot(j0cent,i0cent,'go') ;
          %  recall "plot" works on cartesian scale, not image scale
    vachil = get(gca,'Children') ;
    set(vachil(1),'MarkerSize',zerosize) ;

hold off ;


