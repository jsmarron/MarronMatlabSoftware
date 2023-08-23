function sss2cntrSM(msiggloc,fh,n,m,ncontr,contrsp)
% SSS2CNTRSM, Function for SSS2, this overlays contours, on the current image.
%     Intended to be used by SSS2, for plotting gradient information
%   Steve Marron's matlab function
%     Notes:  This assumes "matrix style coordinates", where
%                   indices are (i,j), 
%                              i indexes rows (vertical),
%                              j indexes columns (horizontal).
%             This drops "strange contours", where too large
%                   a shift is needed to connect endpoints.  This
%                   may result in blank regions (i.e. no contours
%                   drawn where they may be expected) for examples
%                   with a lot of "winding".
% Inputs:
%     msiggloc - 3 column matrix of significant gradient information
%                    one row for each pixel
%                      column 1:  one when gradient is significant
%                      column 2:  i location of center (vert. "y" coord.)
%                      column 3:  j location of center (horiz. "x" coord.)
%            fh - matrix of smooths
%             n - number of rows in image
%             m - number of columns in image
%        ncontr - number of contours
%       contrsp - contour spacing parameter
%                       1 - equally spaced (default)
%                       2 - gray level quantile spaced
%
% Outputs:
%       Only graphics added to current axes.
%
% Assumes path can find personal functions:
%    cquantSM
%    vec2matSM


%    Copyright (c) J. S. Marron 2000, 2001, 2004, 2023


nsigg = sum(msiggloc(:,1)) ;
          %  number of significant pixels 
          %       (i.e. number of rows of marrow)
nind = size(msiggloc,1) ;
          %  total number of pixels


if nsigg > 0    %  then have some pixels for contours

  %  Initialize vector of heights
  %
  if  contrsp == 1
    sbottom = min(min(fh)) ;
    stop = max(max(fh)) ;
    vhts = linspace(sbottom,stop,ncontr + 2) ;
    vhts = vhts(2:ncontr+1) ;
  elseif  contrsp == 2
    vfh = fh(:) ;
    vprob = linspace(0,1,ncontr+2) ;
    vprob = vprob(2:ncontr+1) ;
    vhts = cquantSM(vfh,vprob) ;
  elseif  contrsp == 3
    vfh = fh(:) ;
    vprob = linspace(0,1,ncontr-2) ;
    vprobleft = [0.1 * vprob(2), 0.4 * vprob(2)] ;
        %  this heavily uses "start at 0"
    vprobright = [1 - 0.4 * vprob(2), 1 - 0.1 * vprob(2)] ;
        %  this heavily uses "start at 0" and "end at 1"
    vprob = vprob(2:ncontr-3) ;
    vprob = [vprobleft, vprob, vprobright] ;
    vhts = cquantSM(vfh,vprob) ;
  end


  mcont = contourc(1:m,1:n,fh,vhts) ;
       %  conmpute contour matrix


  hold on ;

    indnpair = 1 ;
        %  index of number of pairs for current contour
        
    while indnpair < size(mcont,2)    %  loop through contours

      indnpairnew = indnpair + mcont(2,indnpair) + 1 ;
          %  pull of next index of number of pairs

      vx = mcont(1,(indnpair+1):(indnpairnew-1))' ;
      vy = mcont(2,(indnpair+1):(indnpairnew-1))' ;
          %  pull off data for this contour line

      %  check whether nearest grid points are signficant
      %
      npair = length(vx) ;
      if nind < 10000    %  then do matrix wise distance calcuation
        mdist = (vec2matSM(msiggloc(:,3),npair) - ...
                                       vec2matSM(vx',nind)).^2 + ...
                (vec2matSM(msiggloc(:,2),npair) - ...
                                       vec2matSM(vy',nind)).^2 ;
            %  matrix of squared distances from (vx,vy) points to grid points
        [~,vind] = min(mdist,[],1) ;
      else    %  the do looping distance calculation
        vind = [] ;
        for ipair = 1:npair    %  loop through contour pairs
          vdist = (msiggloc(:,3) - vx(ipair)).^2 + ...
                    (msiggloc(:,2) - vy(ipair)).^2 ;
              %  squared distance from (vx,vy) points to grid points
          [~,ind] = min(vdist,[],1) ;
          vind = [vind, ind] ; %#ok<AGROW>
        end
      end

      flag0 = msiggloc(vind,1) == 0 ;
          %  one where this point is near insignificant gradient pixel

      vxmask = vx ;
      vymask = vy ;
      nflag0 = sum(flag0) ;
      if nflag0 > 0    %  have some insignificant points,
                             %  so replace by NaNs
        vxmask(flag0) = NaN * ones(nflag0,1) ;
        vymask(flag0) = NaN * ones(nflag0,1) ;
      end
      

      plot(vxmask,vymask,'m-') ;
      
      indnpair = indnpairnew ;

    end    %  of loop through contours



    %flagsig =  (msiggloc(:,1) == 1)  ;
    %plot(msiggloc(flagsig,3),msiggloc(flagsig,2),'r+', ...
    %               'MarkerSize',2) ;
    %plot(msiggloc(~flagsig,3),msiggloc(~flagsig,2),'b+', ...
    %               'MarkerSize',2) ;
         %  these lines provide very helpful diagnostic,
         %  by overlaying small symbols showing where
         %  gradient is significant


  hold off ;



end    %  of have signifcant pixel if-block
