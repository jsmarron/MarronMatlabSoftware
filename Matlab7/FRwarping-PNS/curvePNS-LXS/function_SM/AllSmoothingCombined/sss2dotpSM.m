function sss2dotpSM(mdot,vsigc,vsigg,colormask,mcol,n,m,symboltype,nres,dotsize) 
% SSS2DOTPSM, Function for SSS2, this overlays dots, on the current image.
%     Intended to be used by SSS2, for plotting curvature information
%   Steve Marron's matlab function
%     Note:  this assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
% Inputs:
%          mdot - matrix of dot information, as from ssscurv.m
%         vsigc - vector of significant curvature information, also from sssgrad.m
%         vsigg - vector of significant gradient information, from sssgrad.m
%     colormask - matrix indicating colors to use for each dot
%          mcol - matrix where rows give RGB colors to use
%             n - number of rows in image
%             m - number of columns in image
%    symboltype - indicator of symbol type
%                     2 - dots only
%                     3 - dots and arrows
%          nres - resolution of SSS symbols:
%                     1  -  1x1 single pixels
%                     2  -  2x2 blocks
%       dotsize - size of dots, for 2x2 case
% Outputs:
%       Only graphics added to current axes.

%    Copyright (c) J. S. Marron 1999, 2001




ndot = sum(vsigc) ;    
          %  number of dots to draw


if ndot > 0 ;    %  then have some dots to draw

  if nres == 1 ;    %  then are working with single pixels
    vcolormask = reshape(colormask,n*m,1) ;
                % vector version of colormask
  elseif nres == 2 ;    %  then are working with 2x2 blocks
    mo2 = floor(m/2) ;
    no2 = floor(n/2) ;
    vcolormask = reshape(colormask,no2*mo2,1) ;
                % vector version of colormask
  end ;

  vcolormask = vcolormask(vsigc) ;
                %  only keep locations where have significant curvature,
                %  i.e. make same size as mdot


  hold on ;
    for icolor = 1:5 ;     
                              %  then loop through curvature colors, 
                              %  adding dots (as appropriate)

      flag = (vcolormask == icolor) ;
                  %  ones where have current color

      if symboltype == 3 ;   %  then are plotting both arrows and dots
                             %  so show only dots where no arrow
        vsiggc = vsigg(vsigc) ;
                      %  keeps entries of vsigg, where have a one in vsigc
                      %  i.e. only have entries where there is a sig dot,
                      %  there have one where there is an arrow
        flag = flag & ~vsiggc ;
                      %  only keep dots, of this color, 
                      %  where there is no arrow
      end ;

      nflag = sum(flag) ;
      if nflag > 0 ;    %  then plot some dots of this color

        icent = mdot(flag,3) ;
        jcent = mdot(flag,4) ;

        plot(jcent,icent,'m.') ;
                        %    Note:  reverse i and j, since "plot"
                        %           works in Cartesian coordinates
          vachil = get(gca,'Children') ;
          set(vachil(1),'MarkerSize',dotsize) ;
          set(vachil(1),'Color',mcol(icolor,:)) ;


      end ;

    end ;

  hold off ;

end ;

