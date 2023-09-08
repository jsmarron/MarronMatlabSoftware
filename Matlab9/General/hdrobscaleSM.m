function [mdataell,mdatasph,mdatamad] = hdrobscaleSM(mdata,robpar) 
% HDROBSCALE, High Dimensional data ROBust reSCAling
%     Does various types of robust normalizations of the data
%       for use in robust PCA, etc.
%   Can use first 1 or 2 arguments.
%   Steve Marron's matlab function
% Inputs:
%     mdata   -  matrix of high dimensional data,
%                     where columns are data vectors
%                     (must have more than one column)
%     robpar  -  robustness parameter:
%                     0 - calculate all 3 types (default)
%                     1 - subtract Elliptical L1 center,
%                                project to Ellipse
%                         (default, when only one input given
%                              and only one output requested)
%                     2 - subtract Spherical L1 center,
%                                project to Sphere
%                     3 - subtract componentwise median,
%                                divide by componentwise mad
%
% Outputs:
%     for robpar = 0:
%         mdataell  -  data transformed as for robpar = 1
%         mdatasph  -  data transformed as for robpar = 2
%         mdatamad  -  data transformed as for robpar = 3
%     for robpar not 0:
%         single matrix of data, transformed according to robpar
%
% Assumes path can find personal function:
%    vec2matSM.m
%    madSM.m
%    rmeanSM.m

%    Copyright (c) J. S. Marron 1999,2001,2004,2023



%  Set parameters and defaults according to number of input arguments
%
if nargin == 1    %  one argument input
  if nargout == 1
    irobpar = 1 ;    %  Default for one output
  else
    irobpar = 0 ;    %  Default for multiple outputs
  end
else
  irobpar = robpar ;    %  use input
end



%  Check outputs are as expected
%
if (nargout > 1) && (irobpar > 0)
          %  then robpar asks for a single output,
          %  but more requested in code

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from hdrobscale.m:   !!!') ;
  disp('!!!   multiple outputs requested,  !!!') ;
  disp(['!!!   but are using robpar = ' num2str(irobpar) ...
                                      '     !!!']) ;
  disp('!!!   other outputs will be empty  !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

end

if (nargout == 1) && (irobpar == 0)
          %  then robpar asks for multiple outputs,
          %  but only one requested

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from hdrobscale.m:   !!!') ;
  disp('!!!   single output requested,     !!!') ;
  disp(['!!!   but are using robpar = ' num2str(irobpar) ...
                                      '     !!!']) ;
  disp('!!!   will give only Ell. rescale  !!!') ;
  disp('!!!   i.e. switch to robpar = 1    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  irobpar = 1 ;

end




%  Start with all empty outputs, then fill as needed
%
mdatasph = [] ;
mdatamad = [] ;
mdataell = [] ;




n = size(mdata,2) ;
          %  number of columns, i.e. data vectors
d = size(mdata,1) ;
          %  number of rows, i.e. dimensions



if n <= 1     %  then only one datapoint, give error message

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from hdrobscale.m:  !!!') ;
  disp('!!!   Only one data point,      !!!') ;
  disp('!!!   so cannot rescale,         !!!') ;
  disp('!!!   giving empty returns      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;



else    %   have enough data, so go to work


  if irobpar ~= 2
          %  then need to work with component-wise MAD

    vmad = madSM(mdata')' ;
          %  componentwise MAD,
          %  use transpose, since madSM works on columns

    vnondegflag = (abs(vmad) > eps) ;
          %  true for nondegenerate components,
          %  i.e. where there is some variance

    numnondeg = sum(vnondegflag) ;
          %  number of nondegenerate components
    
    if numnondeg == 0    %  then all components degenerate

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Error from hdrobscale.m:        !!!') ;
      disp('!!!   All components have 0 variance  !!!') ;
      disp('!!!   So give empty returns           !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

      return ;

    elseif numnondeg < d    %  then there are some
                              %  nondegenerate components 

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from hdrobscale.m:       !!!') ;
      disp('!!!   Some components have 0 variance  !!!') ;
      disp('!!!   These will be set to 0           !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

      rdata = mdata(vnondegflag,:) ;
      vmad = vmad(vnondegflag) ;
          %  reduce to only nondegenerate components

    else

      rdata = mdata ;
          %  reduced data is full data

    end



    if numnondeg > 1
      mmad = vec2matSM(vmad,n) ;
          %  expand out to matrix version
    else
      mmad = vmad ;
    end


    srdata = rdata ./ mmad ;
          %  scaled reduced data


  end 




  if  (irobpar == 0)  ||  (irobpar == 3)
          %  then do mad type rescaling


    vmed = median(srdata,2) ;
          %  component-wise median
          %  2 is for "over entry 2", i.e. along rows

    if numnondeg > 1
      mmed = vec2matSM(vmed,n) ;
          %  expand to matrix
    else
      mmed = vmed * ones(1,n) ;
    end

    zrdata = srdata - mmed ;
          %  mad standardized data


    if numnondeg < d    %  then did some reduction, so expand back
      zdata = zeros(d,n) ;
      zdata(vnondegflag,:) = zrdata ;
    else
      zdata = zrdata ;
         %  full data is same as reduced data
    end


    if irobpar == 3
          %  then need to make this only output
      mdataell = zdata ;
    elseif irobpar == 0
          %  then set this up for multiple outputs
      mdatamad = zdata ;
    end


  end




  if  (irobpar == 0)  ||  (irobpar == 2)
          %  then work with sphered version

    vcenter = rmeanSM(mdata',10^(-6),20,0)' ;
          %  Robust L1 M-estimation of center
          %  transpose, since this takes "average along columns"
          %  10^(-6) - relative accuracy, when last step was smaller 
          %       20 - maximum number of steps to take
          %        0 - no screen writes

    if d < 1
      mcenter = vec2matSM(vcenter,n) ;
          %  expand to matrix
    else
      mcenter = vcenter * ones(1,n) ;
    end

    zdata = mdata - mcenter ;
          %  centered data

    vlength = sqrt(sum(zdata.^2,1)) ;
          %  sum is along dimension 1,
          %  gives vector of lengths of data vectors

    ln0flag = (vlength ~= 0) ;
          %  ones where length is not 0, i.e. vector at center

    mlength = vec2matSM(vlength,d) ;
          %  expand out to matrix version

    zdata(:,ln0flag) = zdata(:,ln0flag) ./ mlength(:,ln0flag) ;
          %  divide each vector by its length


    if irobpar == 2
          %  then need to make this only output
      mdataell = zdata ;
    elseif irobpar == 0
          %  then set this up for multiple outputs
      mdatasph = zdata ;
    end


  end    %  of sphere if-block




  if  (irobpar == 0)  ||  (irobpar == 1)
          %  then work with ellipsed version

    vcenter = rmeanSM(rdata',10^(-6),20,0)' ;
          %  Robust L1 M-estimation of center
          %  transpose, since this takes "average along columns"
          %  10^(-6) - relative accuracy, when last step was smaller 
          %       20 - maximum number of steps to take
          %        0 - no screen writes

    if numnondeg < 1
      mcenter = vec2matSM(vcenter,n) ;
          %  expand to matrix
    else
      mcenter = vcenter * ones(1,n) ;
    end

    zrdata = rdata - mcenter ;
          %  centered data

    vlength = sqrt(sum(zrdata.^2,1)) ;
          %  sum is along dimension 1,
          %  gives vector of lengths of data vectors

    ln0flag = (vlength ~= 0) ;
          %  ones where length is not 0, i.e. vector at center

    if numnondeg > 1
      mlength = vec2matSM(vlength,numnondeg) ;
          %  expand out to matrix version
    else
      mlength = vlength ;
    end

    zrdata(:,ln0flag) = zrdata(:,ln0flag) ./ mlength(:,ln0flag) ;
          %  divide each vector by its length


    if numnondeg < d    %  then did some reduction, so expand back
      zdata = zeros(d,n) ;
      zdata(vnondegflag,:) = zrdata ; %#ok<NASGU>
    else
      zdata = zrdata ; %#ok<NASGU>
         %  full data is same as reduced data
    end



    if  (irobpar == 0)  ||  (irobpar == 1)
          %  then need to "undo mad rescale"

      zrdata = zrdata .* mmad ;

      if numnondeg < d    %  then did some reduction, so expand back
        zdata = zeros(d,n) ;
        zdata(vnondegflag,:) = zrdata ;
      else
        zdata = zrdata ;
         %  full data is same as reduced data
      end

      mdataell = zdata ;

    end


  end    %  of ellipse if-block


end    %  of main if-block







