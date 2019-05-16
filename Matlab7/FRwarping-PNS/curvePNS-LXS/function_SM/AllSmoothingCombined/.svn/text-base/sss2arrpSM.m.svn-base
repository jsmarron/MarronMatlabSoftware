function sss1arrp2SM(marrow,vsigg,colormask,mcol,n,m,nres,linelength, arrowlength) 
% SSS1ARRPSM, Function for SSS2, this overlays arrows, on the current image.
%     Intended to be used by SSS2, for plotting gradient information
%   Steve Marron's matlab function
%     Note:  this assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
% Inputs:
%        marrow - matrix of arrow information, as from sssgrad.m
%         vsigg - vector of significant gradient information, also from sssgrad.m
%     colormask - matrix indicating colors to use for each arrow
%          mcol - matrix where rows give RGB colors to use
%             n - number of rows in image
%             m - number of columns in image
%          nres - resolution of SSS symbols:    (called ivitype(2) in sss1.m)
%                     1  -  1x1 single pixels
%                     2  -  2x2 blocks
%    linelength - length of line segments, for 1x1 case
%   arrowlength - length of arrows, for 2x2 case
% Outputs:
%       Only graphics added to current axes.

%    Copyright (c) J. S. Marron 1999, 2001



narrow = sum(vsigg) ;    
          %  number of arrows to draw

if narrow > 0 ;    %  then have some arrows to draw

  if nres == 1 ;    %  then are working with single pixels
    marrow(:,[4 5]) = linelength * marrow(:,[4 5]) ;
          %  adjust idir and jdir
    vcolormask = reshape(colormask,n*m,1) ;
          % vector version of colormask
  elseif nres == 2 ;    %  then are working with 2x2 blocks
    mo2 = floor(m / 2) ;
    no2 = floor(n / 2) ;
    marrow(:,[4 5]) = arrowlength * marrow(:,[4 5]) ;
          %  adjust idir and jdir
    vcolormask = reshape(colormask,no2*mo2,1) ;
          % vector version of colormask
  end ;

  vcolormask = vcolormask(vsigg) ;
          %  only keep locations where have significant curvature,
          %  i.e. make same size as marrow


  hold on ;
    for icolor = 0:5 ;     
                        %  then loop through curvature colors, 
                        %  adding lines or arrows (as appropriate)

      flag = (vcolormask == icolor) ;
            %  ones where have current color
      nflag = sum(flag) ;
      if nflag > 0 ;    %  then plot some arrows of this color

        icent = marrow(flag,2) ;
        jcent = marrow(flag,3) ;
        idir = marrow(flag,4) ;
        jdir = marrow(flag,5) ;

        if nres == 1 ;
                 %  then working with single pixels, so plot lines

          plot([(jcent-jdir)'; (jcent+jdir)'], ...
                      [(icent-idir)'; (icent+idir)'], 'g-') ;
                        %    Note:  reverse i and j, since "plot"
                        %           works in Cartesian coordinates
            if icolor > 0 ;    %  then recolor the arrow
              vachil = get(gca,'Children') ;
              set(vachil(1:nflag),'Color',mcol(icolor,:)) ;
            end ;

        elseif nres == 2 ;
                 %  then working with 2x2 blocks, so plot arrows

          quiver(jcent,icent,jdir,idir,0,'g-') ;
                %  arrow pointing uphill
                %  0 since automatic rescaling didn't work
                %          Note:  reverse i and j, since "plot"
                %                 works in Cartesian coordinates
            if icolor > 0 ;    %  then recolor the arrow
              vachil = get(gca,'Children') ;
              set(vachil(1),'Color',mcol(icolor,:)) ;
              set(vachil(2),'Color',mcol(icolor,:)) ;
            end ;

        end ;


      end ;

    end ;

  hold off ;

end ;

