function makeplot = sss2SM(data,paramstruct) 
% SSS2SM, Significance in Scale Space, for finding features in 2d
%     based on slopes, curvatures or both
%     (improves sss1, by more user friendly features, 
%             and by AVI movie format)
%   Steve Marron's matlab function
%
%     For each bandwidth, creates a gray level map of smoothed data
%     and overlays matrix of symbols, showing significance
%
%     This is based on circular (i.e. same bandwidth in all directions)
%     Gaussian kernel convolution smoothing
%
% Inputs:
%   data        - either n x m matrix of image data  
%                            (requires m > 2, otherwise interpreted as 
%                             density estimation data)
%                  or n x 2 matrix of 2d density estimation data
%                            X's in first column,  Y's in second
%
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1,...
%                            'field2',values2,...
%                                             ) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    stype            0 - just do smooths only 
%                               (same format as others)
%                     1 - arrows based on gradient only
%                               (default, when not specified)
%                     2 - dots for curvature only
%                     3 - combine arrows and dots (show dot only 
%                                    when no significant arrow)
%                     4 - streamlines, showing only gradient 
%                                    information
%                     5 - contours, showing only gradient 
%                                    information
%                     6 - combine streamlines and contours
%
%    igrid            1 - use 1x1 grid (i.e. single pixels)
%                     2 - use 2x2 boxes (bigger symbols, 
%                                default, when not specified)
%                                (this has no effect when only 
%                                  smoothing or using streamlines)
%
%    imovie           1  (default)  make movie version
%                     0  make a single still plot
%                            (reset to this for iout > 4)
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%    itoobigctrl      0  give warning and option prompt, when 
%                             image size is too large (default)
%                     1  just continue with 2 x 2 array of plots,
%                             regardless of image size, no prompts
%                     2  force switch to single page plots.
%                          (Note: has effect only for imovie = 0)
%
%    ismallessctrl    0  draw circles for small ESS in 
%                             regression, but not for density 
%                             estimation (default)
%                     1  no circles for small ESS in regression,
%                             but draw for density estimation
%
%    ivarunknown      1  (default) unknown variance, need to 
%                             estimate
%                     0  known variance (requires varinput given)
%
%    ivarlocal        0  (default) pool variance estimates,
%                             i.e. assume homoscedastic
%                     1  use local variance estimate,
%                             i.e. assume heteroscedastic
%
%    varinput         input known variance (no default, only 
%                             has effect for image data and 
%                             ivarunknown = 0)
%                      
%    alpha            Usual "level of significance".  
%                             I.e. C.I.s have coverage probability
%                             1 - alpha.  (0.05 when not specified)
%
%    hmin             Smallest smoothing bandwidth, h
%                             0 gives default:
%                             1 is default for images
%                             2 is default for densities
%
%    hmax             Largest smoothing bandwidth, h
%                             0 gives default:
%                             8 is default for images
%                             16 is default for densities
%
%    nh               Number of bandwidths, h
%                             0 gives default:
%                             25 is default for movies
%                             1 or 4 allowed for static plot
%                                 (use h = hmin for nh = 1)
%                             hmin = hmax changes this to 1
%
%    vgp              Vector of grid parameters:
%                         for image data, this has no effect
%                                 (since size of data determines 
%                                 this, and use pixel numbers)
%                         for density estimation:
%                           0 (or not specified)  -  use maxes 
%                                 and mins of data and 64 x 64 
%                                 grid, and linear binning
%                           1  -  use maxes and mins of data 
%                                 and 64 x 64 grid, 
%                                 and nearest neighbor binning
%                           [xmin, xmax, nxg, ymin, ymax, nyg] 
%                              -  use these input values and 
%                                 linear binning
%                           [xmin, xmax, nxg, ymin, ymax, nyg, 1]
%                              -  use these input values and 
%                                 nearest neighbor binning
%
%    bdryp            boundary parameter:
%                         for image data:
%                           0  -  No boundary adjustment
%                           1 (or not specified) -  Adjust for 
%                                 boundary effects, by subtracting 
%                                 the overall mean
%                           2  -  Adjust for boundary effects,
%                                 by subtracting the overall median
%                         for density estimation:
%                           0  -  truncate data outside range
%                           1 (or not specified)  -  move data 
%                                 outside range to nearest endpoint
%
%    contrsp          contour spacing parameter
%                         only has effect for stype = 5 or 6
%                           1  -  equally spaced (default)
%                           2  -  gray level quantile spaced
%                           3  -  modified gray level quantile spaced
%                                 (add a few at each end
%                                  ncontr = 13 gives quantiles at:
%                                  0.01, 0.04, 0.1, 0.2, ...
%                                      & symmetric at other end)
%
%    ncontr           number of contours to draw
%                         only has effect for stype = 5 or 6
%                             for contrsp = 1, 10 (default)
%                                 is recommended at first
%                             for contrsp = 2, ncontr = 9 means that
%                                 each contour contains 10% of pixels
%                             for contrsp = 3, ncontr = 13 means that
%                                 each contour contains 10% of pixels,
%                                 except 1% and 4% at ends
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                     unspecified:  results only appear on screen
%                     movie version (imovie = 1):
%                         add .avi and create AVI file
%                     static version (imovie = 0):  
%                         Will add file suffix determined by savetype
%                         Note:  when savestr is nonempty, and ifigure = 0,
%                              give warning and reset ifigure to 1
%
%    savetype         indicator of output file type:
%                         1 - (default)  Matlab figure file (.fig)
%                         2 - (.png)  raster graphics
%                         3 - (.pdf)  vector graphics
%                         4 - (.eps)  Color vector 
%                                     (use when icolor is not 0)
%                         5 - (.eps)  Black and White vector 
%                                     (use when icolor = 0)
%                         6 - (.jpg)  raster
%                         7 - (.svg)  vector
%
%    nrepeat          number of times to repeat movie (default = 1)
%
%    moviefps         movie speed, in frames per second (default = 2)
%
%    titlestr         string with a (fixed) title
%
%    ishowh           controls display of bandwidth h in title
%                       0 - don't show h (default for movies)
%                       1 - show h (default for static plots)
%
%
% Output:
%     Draws a 2x2 array of images, in the current window
%     Or 4 full page images in figure windows 1-4
%     Or a single movie
%     When savestr exists,
%        For imovie = 1:  AVI file saved in 'savestr'.avi
%        For imovie = 0:  Postscript file saved in 'savestr'.ext
%                        (extension determined by savetype)
% Assumes have function:
%    conv2.m
% From Matlab's Image Processing Toolbox,
% and path can find personal functions:
%    sss2arrpSM.m
%    sss2aspSM.m
%    sss2dotpSM.m
%    sss2sspSM.m
%    sss2strmlnSM.m

%    sss2cntr.m
%    sss2curvSM.m
%    sss2fhSM.m
%    sss2fhdSM.m
%    sss2fh1SM.m
%    sss2fh1dSM.m
%    sss2fh2SM.m
%    sss2fh2dSM.m
%    sss2gradSM.m
%    k2dgSM.m
%    vec2matSM.m

%    Copyright (c) J. S. Marron 2000, 2001, 2023





%  First set all parameter to defaults
stype = 1 ;
igrid = 2 ;
imovie = 1 ;
iscreenwrite = 0 ;
itoobigctrl = 0 ;
ismallessctrl = 0 ;
ivarunknown = 1 ;
ivarlocal = 0 ;
varinput = 0 ;
alpha = 0.05 ;
hmin = 0 ;
hmax = 0 ;
nh = 0 ;
vgp = 0 ;
bdryp = 1 ;
contrsp = 1 ;
ncontr = 10 ;
savestr = [] ;
savetype = 1 ;
nrepeat = 1 ;
moviefps = 2 ;
titlestr = [] ;
ishowh = [] ;




%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 1   %  then paramstruct has been added

  if isfield(paramstruct,'stype')    %  then change to input value
    stype = paramstruct.stype ; 
  end

  if isfield(paramstruct,'igrid')    %  then change to input value
    igrid = paramstruct.igrid ; 
  end

  if isfield(paramstruct,'imovie')    %  then change to input value
    imovie = paramstruct.imovie ; 
  end

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ; 
  end

  if isfield(paramstruct,'itoobigctrl')    %  then change to input value
    itoobigctrl = paramstruct.itoobigctrl ; 
  end

  if isfield(paramstruct,'ismallessctrl')    %  then change to input value
    ismallessctrl = paramstruct.ismallessctrl ; 
  end

  if isfield(paramstruct,'ivarunknown')    %  then change to input value
    ivarunknown = paramstruct.ivarunknown ; 
  end

  if isfield(paramstruct,'ivarlocal')    %  then change to input value
    ivarlocal = paramstruct.ivarlocal ; 
  end

  if isfield(paramstruct,'varinput')    %  then change to input value
    varinput = paramstruct.varinput ; 
  end

  if isfield(paramstruct,'alpha')    %  then change to input value
    alpha = paramstruct.alpha ; 
  end

  if isfield(paramstruct,'hmin')    %  then change to input value
    hmin = paramstruct.hmin ; 
  end

  if isfield(paramstruct,'hmax')    %  then change to input value
    hmax = paramstruct.hmax ; 
  end

  if isfield(paramstruct,'nh')    %  then change to input value
    nh = paramstruct.nh ; 
  end

  if isfield(paramstruct,'vgp')    %  then change to input value
    vgp = paramstruct.vgp ; 
  end

  if isfield(paramstruct,'bdryp')    %  then change to input value
    bdryp = paramstruct.bdryp ; 
  end

  if isfield(paramstruct,'contrsp')    %  then change to input value
    contrsp = paramstruct.contrsp ; 
  end

  if isfield(paramstruct,'ncontr')    %  then change to input value
    ncontr = paramstruct.ncontr ; 
  end
  
  if isfield(paramstruct,'savestr')    %  then use input value
    savestr = paramstruct.savestr ; 
    if ~ischar(savestr)    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from sss2SM.m:     !!!') ;
      disp('!!!   Invalid savestr,           !!!') ;
      disp('!!!   using default of no save   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end
  end

  if isfield(paramstruct,'savetype')    %  then use input value
    savestr = paramstruct.savetype ; 
  end

  if isfield(paramstruct,'nrepeat')    %  then change to input value
    nrepeat = paramstruct.nrepeat ; 
  end

  if isfield(paramstruct,'moviefps')    %  then change to input value
    moviefps = paramstruct.moviefps ; 
  end

  if isfield(paramstruct,'titlestr')    %  then change to input value
    titlestr = paramstruct.titlestr ; 
  end

  if isfield(paramstruct,'ishowh')    %  then change to input value
    ishowh = paramstruct.ishowh ; 
  end


end  %  of resetting of input parameters





%  Set internal parameters
%
arrowlength = 1.2 ;    %  in s2m1b, used 1.5
          %  length of arrows showing gradient direction
dotsize = 5 ;          %  from s2m7c, 5 was best for 64x64
          %  size of dots representing curvature
linelength = 0.2 ;     %  from s2m7c
          %  line length in pixel units  (0.8 gave "connected line segments")
          %  calibrated to be "1" for usual static set of four 64x64 images
zerosize = 2 ;         %  from s2m7c, used to use 3
          %  size of 0's representing low effective sample size

if stype >= 4    %  then are doing streamlines and/or contours,
  igrid = 1 ;      %  so reset to 1x1 single pixel analysis
end

if igrid == 2
          %  if have chosen 2 x 2 blocks, and are not doing streamlines
          %  then need to modify size parameters for 2x2 blocks
  dotsize = 2 * dotsize ;
  zerosize = 2 * zerosize ;
          %  don't need similar change for arrowlength or linelength,
          %  since use one or the other
end



strmlntpb = 2.0 ; 
          %  for streamlines, average number of touches per pixel box
          %  This was chosen to be "right" for 16 x 16
          %  is appropriately rescaled below (after n,m are defined)
seed = 92374092 ;
rng(seed) ;
          %  set Uniform random seed for use with streamlines





%  Set up colors for symbols
%
mcol = [1, 1, 0; ...
        1, .5, 0; ...
        1, 0, 0; ...
        .5, 0, 1; ...
        0, 0, .5] ; ...
%  yellow 
%  orange 
%  red 
%  purple 
%  dark blue 






%  detect whether image or density estimation data
%
if size(data,2) == 2    %  Then is 2-d density estimation

  idatyp = 2 ;

  if ismallessctrl == 1    %  then draw small ESS circles for density est.
    circleflag = 1 ;
  else    %  no circles for ESS (default)
    circleflag = 0 ;
  end

else   %  Then this is image data

  idatyp = 1 ;

  if ismallessctrl == 1    %  then no small ESS circles for images
    circleflag = 0 ;
  else    %  draw circles for ESS (default)
    circleflag = 1 ;
  end

end




%  Set h grid stuff
%
if idatyp == 1    %  then are doing images

  if hmin == 0
    hmin = 1 ;
  end

  if hmax == 0
    hmax = 8 ;
  end

elseif idatyp == 2    %  then are doing density est.

  if hmin == 0
    hmin = 2 ;
  end

  if hmax == 0
    hmax = 16 ;
  end

end


if imovie == 0    %  then are doing static plot

  if nh == 0
    nh = 4 ;
  end

  if nh == 1

    iplottype = 4 ;
          %  1 - put 4x4 plot into current figure window
          %  2 - put 4 plots into figures 1,2,3,4
          %  3 - put single plot into current figure window
          %  4 - put single plot into current axes

  elseif nh == 4

    iplottype = 1 ;
          %  1 - put 4x4 plot into current figure window
          %  2 - put 4 plots into figures 1,2,3,4
          %  3 - put single plot into current figure window
          %  4 - put single plot into current axes

  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sss2SM.m:                     !!!') ;
    disp('!!!   For Static plot, must use nh = 1 or 4    !!!') ;
    disp('!!!   Terminating sss2SM.m                     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    return ;
          %  Stop all of sss2SM.m, and return to calling program

  end


  if isempty(ishowh)    %  then use default value
    ishowh = 1 ;
  end


elseif  imovie == 1     %  then are doing dynamic plot

  if nh == 0
    nh = 25 ;
  elseif nh < 0

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sss2SM.m:           !!!') ;
    disp('!!!   For Movie, must have nh >= 0   !!!') ;
    disp('!!!   Terminating sss2SM.m           !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    return ;

  end

  iplottype = 3 ;
          %  1 - put 4x4 plot into current figure window
          %  2 - put 4 plots into figures 1,2,3,4
          %  3 - put single plot into current figure window
          %  4 - put single plot into current axes


  if isempty(ishowh)    %  then use default value
    ishowh = 0 ;
  end


end



if hmin == hmax

  if nh ~= 1
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from sss2SM.m:     !!!') ;
    disp('!!!   hmin = hmax,               !!!') ;
    disp('!!!   so are resetting nh to 1   !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  end

  nh = 1 ;

  iplottype = 4 ;
          %  1 - put 4x4 plot into current figure window
          %  2 - put 4 plots into figures 1,2,3,4
          %  3 - put single plot into current figure window
          %  4 - put single plot into current axes

elseif hmin > hmax

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from sss2SM.m:     !!!') ;
  disp('!!!   input has hmin > hmax    !!!') ;
  disp('!!!   Terminating sss2SM.m     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

  return ;

end


if nh == 1

  if imovie == 1

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sss2SM.m:                        !!!') ;
    disp('!!!   Can''t make a one frame movie,              !!!') ;
    disp('!!!   i.e. when imovie = 1, can''t have nh = 1    !!!') ;
    disp('!!!   Terminating sss2SM.m                        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

    return

  end

  vh = hmin ;
else
  vh = logspace(log10(hmin),log10(hmax),nh) ;
end




%  Do preliminary calculations
%
if idatyp == 2    %  Then is 2-d density estimation

  %  Set x grid stuff
  %
  if length(vgp) == 1   %  then use standard default x grid
    xmin = min(data(:,1)) ;
    xmax = max(data(:,1)) ;
    xrange = xmax - xmin ;
    xmin = xmin - 0.05 * xrange ;
    xmax = xmax + 0.05 * xrange ;
    nxg = 64 ;
    ymin = min(data(:,2)) ;
    ymax = max(data(:,2)) ;
    yrange = ymax - ymin ;
    ymin = ymin - 0.05 * yrange ;
    ymax = ymax + 0.05 * yrange ;
    nyg = 64 ;

    if vgp == 1     %  then use nearest neighbor binning
      bintype = 1 ;    
    else
      bintype = 2 ;    
    end

  else
    xmin = vgp(1) ;
    xmax = vgp(2) ;
    nxg = vgp(3) ;
    ymin = vgp(4) ;
    ymax = vgp(5) ;
    nyg = vgp(6) ;

    if (round(nxg) ~= nxg)  ||  (round(nyg) ~= nyg)
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from sss2SM:  input grid sizes      !!!') ;
      disp('!!!   are not integers, will use rounded values   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

      nxg = round(nxg) ;
      nyg = round(nyg) ;
    end

    if length(vgp) == 6     %  then use linear binning
      bintype = 2 ;    
    else
      bintype = 1 ;    
    end

  end



  %  Bin the data
  %
  data = sss2binSM(data,xmin,xmax,nxg,ymin,ymax,nyg,bintype,bdryp) ;
          %  Note data are converted from Cartesian to 
          %  Matrix coordinates inside this
          


else                    %  Then assume image data


  if bdryp == 1    %  then do boundary adjustment, based on mean
    data = data - mean(mean(data)) ;
  elseif bdryp == 2    %  then do boundary adjustment, based on median
    data = data - median(median(data)) ;
  end


end





%  Set additional parameters
%
m = size(data,2) ;
          %  number of cols of data matrix 
          %  (i.e. j-values in matrix coordinate system)
n = size(data,1) ;
          %  for images: number of rows of data matrix 
          %  (i.e. i-values in matrix coordinate system)
maxnm = max([n; m]) ;
dotsize = (64 / maxnm) * dotsize ;
zerosize = (64 / maxnm) * zerosize ;
          %  resize, since original calibration was for n = 64,
          %  i.e. put dot size on pixel scale
          %  Note:  need to do this with dots, and not with arrows,
          %      since, arrows are naturally (by their construction)
          %      scaled to pixel size, but dots are not.

strmlntpb = strmlntpb * (16 / maxnm) ; 
          %  for streamlines, average number of touches per pixel box
strmlnsf = .5 * (maxnm / 16) ;  
          %  for streamlines, step size factor, for multiplying pixel
          %  width to get step size



%  Check for reasonable image sizes
%
if imovie == 0  && (nh == 4)
                        %  only worry for static plot, and
                        %  if don't already have single page
  if (itoobigctrl == 0)
                        %  then do sample size warnings and prompts

    if stype == 1  ||  stype == 3    %  then have some arrows

      if ((igrid == 1) && (maxnm > 64)) ||...
              ((igrid == 2) && (maxnm > 128))
                   %  if working with 1x1 single pixels and n > 64
                   %  or working on 2x2 blocks and n > 128
                   %  then arrows won't look good, so give warning

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from sss2SM.m:                      !!!!') ;
      disp(['!!!   Image Size = ' num2str(maxnm)]) ;
      disp('!!!   is too large for Good Resolution of Arrows   !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      innum = input(['!!!   Choose from: \n' ...
         '!!!      1.  Continue anyway (press Enter)\n' ...
         '!!!      2.  Make full page plots (press 2 + Enter)\n' ...
         '!!!      3.  Quit processing  (press 3 + Enter)\n' ...
         '!!!            (e.g. go to movie, or single h)\n']) ;

        if innum == 2

          iplottype = 2 ;  
            %  1 - put 4x4 plot into current figure window
            %  2 - put 4 plots into figures 1,2,3,4
            %  3 - put single plot into current figure window
            %  4 - put single plot into current axes

        elseif innum == 3    %  Then want to quit executing

          return ;
            %  Stop all of sss2SM.m, and return to calling program
        end

      end

    end

  elseif itoobigctrl == 2    %  then force single pages

    iplottype = 2 ;  
          %  1 - put 4x4 plot into current figure window
          %  2 - put 4 plots into figures 1,2,3,4
          %  3 - put single plot into current figure window
          %  4 - put single plot into current axes

  end

end



if iplottype == 1
  clf ;
          %  clear current figure window
end




%  Loop through bandwidths, i.e. pictures
%
if imovie == 1
  clear moviestruct ;
end
for ih = 1:nh

  h = vh(ih) ;


  if iscreenwrite == 1    %  then display progress messages
    disp(['    sss2SM:  Working on h = ' num2str(h)]) ;
  end



  %  First do smooths and Effective Sample Size
  %
  if idatyp == 1    %  then are doing regression

    if stype == 0   %  then are doing only smooths

      fh = sss2fhSM(data,h,-1) ;

    elseif ivarunknown == 0   %  then use input sigma^2 (noise level of data)

      [fh,ess] = sss2fhSM(data,h) ;

      if varinput <= 0

        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Error from sss2SM.m:          !!!') ;
        disp('!!!   must use positive varinput    !!!') ;
        disp('!!!   Terminating sss2SM.m          !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;

        return ;

      end

      sig2 = varinput ;
      sig2 = sig2 * ones(n,m) ;


    elseif ivarunknown == 1    %  then work with estimated variance

      [fh,ess,sig2] = sss2fhSM(data,h,ivarlocal) ;

    end

  elseif idatyp == 2    %  then are doing density estimation

    if stype == 0   %  then are doing only smooths

      fh = sss2fhdSM(data,h,-1) ;

    else    %  then work with estimated variance

      [fh,ess,sig2] = sss2fhdSM(data,h) ;

    end

  end

  if iscreenwrite == 1    %  then display progress messages
    disp('    sss2SM:    fh, ESS and sig2 finished') ;
  end




  %  Plot current smooth as gray level image
  %
  if iplottype == 1       %  1 - put 4x4 plot into current figure window
    subplot(2,2,ih) ;
  elseif iplottype == 2   %  2 - put 4 plots into figures 1,2,3,4
    figure(ih) ;
    clf ;
    subplot(1,1,1) ;
  elseif iplottype == 3   %  3 - put single plot into current figure window

    subplot(1,1,1) ;

  else                    %  4 - put single plot into current axes

  end


  colormap(gray) ;
    mfh = fh - min(min(fh)) ;
    mfh = mfh / max(max(mfh)) ;
    mfh = mfh * size(gray,1) ;
          %  version of fh, mapped to [0, #gray levels]
    image([1,m],[1,n],mfh) ;
      if ~isempty(titlestr)
        if ishowh == 1    %  then add h to title
          title([titlestr ', h = ' num2str(h)]) ;
        elseif ishowh == 0
          title(titlestr) ;
        end
      else
        if ishowh == 1    %  then make an h title
          title(['h = ' num2str(h)]) ;
        end
      end

  if idatyp == 1    %   then are doing regression,
                    %   so want each pixel to be a square
    axis('image') ;

  elseif idatyp == 2    %  then are doing density estimation, 
                          %  so relabel axes, and
                          %  want to set aspect ratio for density
                          %  with respect to 2-d Lebesgue measure

    axis('image') ;

    imxticks = get(gca,'XTick') ;
    imyticks = get(gca,'YTick') ;
          %  Value for tick marks, in image coordinates

    caxticks = (xmax - xmin) * (imxticks / nxg) + xmin ;
    cayticks = (ymin - ymax) * (imyticks / nyg) + ymax ;
          %  Value for tick marks, in cartesian coordinates
          %  (recall y axis is reversed)

    caxticklabels = num2str(caxticks',3) ;
    cayticklabels = num2str(cayticks',3) ;
          %  Convert these to strings for use in graphics

    set(gca,'XTickLabel',caxticklabels) ;
    set(gca,'YTickLabel',cayticklabels) ;

  end




  if stype ~= 0   %  then want to add some SSS parts

    if circleflag == 1    %  then want to draw small ESS circles

      %  Do Small Effective Sample Size Calculations
      %
      smallessflag = ess < 5 ;
          %  ones where ess < 5 ;
      if igrid == 1    %  then are working with single pixels
        nsmalless = sum(sum(smallessflag)) ;
          %  number of pixels with small ess
        allsmalless = (nsmalless == n * m) ;
          %  1 when every pixel has small ess
        nosmalless = (nsmalless == 0) ;
          %  1 when no pixel has small ess
        smallessflagdec = [] ;
          %  can pass this into sss1ssp.m
      elseif igrid == 2    %  then are working with 2x2 blocks
        mo2 = floor(m/2) ;
        no2 = floor(n/2) ;
        smallessflagdec = conv2(double(smallessflag),ones(2,2),'valid') ;
          %  do 2x2 simple sum
        smallessflagdec = smallessflagdec((1:2:(2*no2)),(1:2:(2*mo2))) ;
          %  reduce to just block centers
        smallessflagdec = smallessflagdec > 0 ;
          %  puts a one if any cell has small ess
        nsmalless = sum(sum(smallessflagdec)) ;
          %  number of 2x2 blocks with small ess
        allsmalless = (nsmalless == no2 * mo2) ;
          %  1 when every 2x2 block has small ess
        nosmalless = (nsmalless == 0) ;
          %  1 when no 2x2 block has small ess
      end


    else    %  Don't draw any smalless circles

      nsmalless = 0 ;
          %  number of pixels with small ess
      allsmalless = false ;
          %  1 when every pixel has small ess
      nosmalless = true ;
          %  1 when no pixel has small ess
      smallessflag = false(n,m) ;

      if igrid == 1    %  then are working with single pixels
        smallessflagdec = [] ;
          %  can pass this into sss1ssp.m
      elseif igrid == 2    %  then are working with 2x2 blocks
        mo2 = floor(m/2) ;
        no2 = floor(n/2) ;
        smallessflagdec = false(no2,mo2) ;
          %  puts a one if any cell has small ess
      end


    end




    if allsmalless          %  then Effective Sample Size is nowhere
                              %  large enough, so don't do hard calculations
                              %  but overlay 0's everywhere


      sss2aspSM(n,m,igrid,zerosize) ;



    else       %  then go ahead with derivative calculations


      if stype == 1  ||  stype == 3  ||  stype == 4  || ...
                        stype == 5  ||  stype == 6 
                                      %  Then do gradient type calcs


        [vsigg, marrow, msiggloc] = sss2gradSM(data,h,igrid,ess,sig2,alpha,idatyp) ;


        %  eliminate arrows in small sample size areas
        %
        if igrid == 1    %  then are working with single pixels
          vsigg = vsigg & ~reshape(smallessflag,n*m,1) ;
            %  ones where have arrows & enough data
        elseif igrid == 2    %  then are working with 2x2 blocks
          vsigg = vsigg & ~reshape(smallessflagdec,no2*mo2,1) ;
            %  ones where have arrows & enough data
        end
        flag = (vsigg(marrow(:,1)) == 1) ;
          %  ones in rows of marrow, that will keep
        marrow = marrow(flag,:) ;


        if iscreenwrite == 1    %  then display progress messages
          disp('    sss2SM:    gradient calculations finished') ;
        end

      else

        vsigg = [] ;
            %  create this for passing to sss1dot.m

      end




      if stype == 2  ||  stype == 3  %  Then do curvature type calcs

        [vsigc, mdot] = sss2curvSM(data,h,igrid,ess,sig2,alpha,idatyp) ;


        %  eliminate dots in small sample size areas
        %
        if igrid == 1    %  then are working with single pixels
          vsigc = vsigc & ~reshape(smallessflag,n*m,1) ;
            %  ones where have dots & enough data
        elseif igrid == 2    %  then are working with 2x2 blocks
          vsigc = vsigc & ~reshape(smallessflagdec,no2*mo2,1) ;
            %  ones where have dots & enough data
        end
        flag = (vsigc(mdot(:,1)) == 1) ;
          %  ones in rows of mdot, that will keep
        mdot = mdot(flag,:) ;


        if iscreenwrite == 1    %  then display progress messages
          disp('    sss2SM:    curvature calculations finished') ;
        end

      end




      %  First set up colors (both arrows and dots)
      %
      if igrid == 1    %  then are working with single pixels
        colormask = zeros(n,m) ;
      elseif igrid == 2    %  then are working with 2x2 blocks
        mo2 = floor(m/2) ;
        no2 = floor(n/2) ;
        colormask = zeros(no2,mo2) ;
      end
          %  initially set to "no significant curvature"

      if stype == 2  ||  stype == 3
                    %  Then update colormap with curvature colors

        ndot = sum(vsigc) ;    
          %  number of dots to draw

        if ndot > 0    %  then have some dots

          colormask(mdot(:,1)) = mdot(:,2) ;
            %  replace entry numbers in mdot(:,1), 
            %  with sig codes in mdot(:,2)

        end

      end




      %  Draw arrows
      %
      if stype == 1  ||  stype == 3 
                    %  Then have done gradient calculations, so plot arrows

        sss2arrpSM(marrow,vsigg,colormask,mcol,n,m,igrid, ...
                                              linelength, arrowlength) ;

      end




      %  Draw dots
      %
      if stype == 2  ||  stype == 3  
                    %  Then have done curvature calculations

        sss2dotpSM(mdot,vsigc,vsigg,colormask,mcol,n,m,stype,...
                                                     igrid,dotsize) ;
      end




      %  Draw Streamlines
      %
      if  stype == 4  ||  stype == 6 
                    %  Then have done gradient calculations

        sss2strmlnSM(marrow,vsigg,n,m,strmlntpb,strmlnsf) ;

      end




      %  Draw Contours
      %
      if  stype == 5  ||  stype == 6 
                    %  Then have done gradient calculations

        sss2cntrSM(msiggloc,fh,n,m,ncontr,contrsp) ;
        
      end




      %  Put down Small ESS Zeros as needed
      %
      if nosmalless == 0     %  then have some small ess parts to show

        sss2sspSM(smallessflag,smallessflagdec,n,m,igrid,zerosize) ;

      end

    end


  end




  if  imovie == 1     %  then are doing dynamic plot

    %  Store current image as a frame
    %
    if isempty(titlestr) && ishowh == 0    %  then save axes only
 			moviestruct(ih) = getframe(gca) ;
    else    %  then save whole figure
 			moviestruct(ih) = getframe(gcf) ;
    end 

  end


end    %  of ih loop through bandwidths






%  Play movie  (if needed)
%
if imovie == 1    %  then make movie

  vmorder = [(1:nh),((nh-1):-1:2)] ;
  moviestruct = moviestruct(vmorder) ;
          %  reorder frames, to loop back to beginning

  if isempty(titlestr) && ishowh == 0    %  then save axes only
    movie(moviestruct,nrepeat,moviefps) ;
  else    %  then save whole figure
    movie(gcf,moviestruct,nrepeat,moviefps) ;
  end
          %  Play movie on screen


end





%  Save results (if needed)
%
if ~isempty(savestr)     %  then save results

  if iscreenwrite == 1
    disp('    sss2SM saving results') ;
  end


  if imovie == 0     %  then save as postscript file

    printSM(savestr,savetype) ;

  elseif imovie == 1    %  then save as AVI file

%{
    movie2avi(moviestruct,savestr,'compression',moviecstr, ...
                              'keyframe',moviefps,'fps',moviefps) ;
%}
    vh = VideoWriter(savestr) ;
    vh.FrameRate = moviefps ;
    open(vh) ;
    writeVideo(vh,moviestruct) ;
    close(vh) ;


  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from sss2SM.m:     !!!') ;
    disp('!!!   invalid "imovie",        !!!') ;
    disp('!!!   Terminating Execution    !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    return ;

  end


  if iscreenwrite == 1
    disp('    sss2SM finished save') ;
    disp('  ') ;
  end

end



