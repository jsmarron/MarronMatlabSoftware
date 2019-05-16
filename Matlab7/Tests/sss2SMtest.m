disp('Running MATLAB script file sss2SMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION sss2SM,
%    User friendly version of Significance in Scale Space



itest = 51 ;      %  1 - standard examples from sizer/2d
                 %  2 - test streamlines (different sample sizes)
                 %  3 - test streamlines (different targets and noises)
                 %  4 - test contours (different sample sizes)
                 %  5 - test streamlines and contours
                 %          (different targets and noises)
                 %  10 - test 0 signal case
                 %  11 - test single line case
                 %  12 - test m ~= n, and also m or n odd
                 %  13 - test 0 signal, different alphas
                 %  > 50 but < 100, density estimation tests
                 %             (currently 51-52)
                 %  > 100 but < 200, various parameter tests
                 %             (currently 101-145)
                 %  > 200, some special tests
                 %             (currently 201-204)
                 %  > 300, test (and experiment with) movies saves
                 %             (currently 301-315)


basefilestr = '\Documents and Settings\J S Marron\My Documents' ;


if itest == 1 ;     %  some standard tests

  idecim = 0 ;     %  0 - use given 64 x 64 image
                   %  1 - decimate to 32 x 32 to increase speed

  ieg = 0 ;    %   0  -  loop through all
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 0 ;    %  0  -  loop through all
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise




  %  set looping parameters
  %
  if ieg == 0 ;
    ies = 1 ;
    iee = 5 ;
  else ;
    ies = ieg ;
    iee = ieg ;
  end ;

  if inoise == 0 ;
    ins = 1 ;
    ine = 3 ;
  else ;
    ins = inoise ;
    ine = inoise ;
  end ;




  %  Main loop
  %
  for ie = ies:iee ;


    %  Loop through noise levels
    %
    for in = ins:ine ;

%      eval(['load \Research\sss\data\sss1d' num2str(ie) ...
%                                num2str(in) ';']) ;
%      eval(['load ' basefilestr ...
%                  '\Research\sss\data\sss1d' num2str(ie) ...
%                                num2str(in) ';']) ;
load([basefilestr '\Research\sss\data\sss1d' num2str(ie) ...
                                num2str(in)]) ;
          % this loads the variables: xgridygrid mdat sig titstr noistr

      figure(1) ;
      clf ;

      if idecim == 1 ;
        mdat = mdat(1:2:63,1:2:63) ;
           %  decimation of data (to keep run time short for testing)
      end ;



      savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                               't' num2str(itest) ...
                               'ie' num2str(ie) ...
                               'in' num2str(in)] ;

      paramstruct = struct('iscreenwrite',1, ...
                           'stype',3, ...
                           'savestr',savestr, ...
                           'imovie',1 ...
                                              ) ;


      sss2SM(mdat,paramstruct) ;


    end ;


  end ;



elseif itest == 2 ;     %  test streamlines
   
   
  idec = 3 ;   %  0 - loop through all
               %  1 - 16x16
%  Note: the idec = 1 16x16 case gives an error message,
%          after creating the movie.  But the moive looks OK
               %  2 - 32x32
               %  3 - 64x64
               %  4 - 128x128
               %  5 - 256x256

  ieg = 2 ;    % 
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 2 ;    % 
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise




  %  set looping parameters
  %
  if idec == 0 ;
    ids = 1 ;
    ide = 5 ;
  else ;
    ids = idec ;
    ide = idec ;
  end ;

  %  load data
  %
%  eval(['load \Research\sss\data\sss1dbig' num2str(ieg) ...
%                                num2str(inoise) ';']) ;
load([basefilestr '\Research\sss\data\sss1dbig' num2str(ieg) ...
                                num2str(inoise)]) ;
          % this loads the variables: xgrid ygrid mdat sig titstr noistr
  mdatbig = mdat ;
          
          

  %  Main loop
  %
  for id = ids:ide ;

    if id == 1 ;    %  decimate to 16x16
      mdat = mdatbig(1:16:256,1:16:256) ;      
      decstr = '16 x 16' ;
    elseif id == 2 ;    %  decimate to 32x32
      mdat = mdatbig(1:8:256,1:8:256) ;      
      decstr = '32 x 32' ;
    elseif id == 3 ;    %  decimate to 64x64
      mdat = mdatbig(1:4:256,1:4:256) ;      
      decstr = '64 x 64' ;
    elseif id == 4 ;    %  decimate to 128x128
      mdat = mdatbig(1:2:256,1:2:256) ;      
      decstr = '128 x 128' ;
    elseif id == 5 ;    %  use full 256x256 image
      mdat = mdatbig ;      
      decstr = '256 x 256' ;
    end ;



    disp(' ') ;
    disp(['Working on ' decstr ', type ' num2str(4)]) ;


    figure(1) ;
    clf ;



    savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                             't' num2str(itest) ...
                             'id' num2str(id)] ;

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',4, ...
                         'savestr',savestr, ...
                         'imovie',1 ...
                                            ) ;


    sss2SM(mdat,paramstruct) ;



  end ;




elseif itest == 3 ;     %  repeat standard tests for streamlines


  ieg = 0 ;    %   0  -  loop through all
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 0 ;    %  0  -  loop through all
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise




  %  set looping parameters
  %
  if ieg == 0 ;
    ies = 1 ;
    iee = 5 ;
  else ;
    ies = ieg ;
    iee = ieg ;
  end ;

  if inoise == 0 ;
    ins = 1 ;
    ine = 3 ;
  else ;
    ins = inoise ;
    ine = inoise ;
  end ;




  %  Main loop
  %
  for ie = ies:iee ;


    %  Loop through noise levels
    %
    for in = ins:ine ;

%      eval(['load \Research\sss\data\sss1d' num2str(ie) ...
%                                num2str(in) ';']) ;
load([basefilestr '\Research\sss\data\sss1d' num2str(ie) ...
                                num2str(in)]) ;
          % this loads the variables: xgrid ygrid mdat sig titstr noistr

      figure(1) ;
      clf ;



      savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                               't' num2str(itest) ...
                               'ie' num2str(ie) ...
                               'in' num2str(in)] ;

      paramstruct = struct('iscreenwrite',1, ...
                           'stype',4, ...
                           'savestr',savestr, ...
                           'imovie',1 ...
                                              ) ;


      sss2SM(mdat,paramstruct) ;



    end ;


  end ;



elseif itest == 4 ;     %  test contours
   
   
  idec = 0 ;   %  0 - loop through all
               %  1 - 16x16
               %  2 - 32x32
               %  3 - 64x64
               %  4 - 128x128
               %  5 - 256x256

  ieg = 2 ;    % 
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 2 ;    % 
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise




  %  set looping parameters
  %
  if idec == 0 ;
    ids = 4 ;
    ide = 5 ;
  else ;
    ids = idec ;
    ide = idec ;
  end ;

  %  load data
  %
%  eval(['load \Research\sss\data\sss1dbig' num2str(ieg) ...
%                                num2str(inoise) ';']) ;
load([basefilestr '\Research\sss\data\sss1dbig' num2str(ieg) ...
                                num2str(inoise)]) ;
          % this loads the variables: xgrid ygrid mdat sig titstr noistr
  mdatbig = mdat ;
          
          

  %  Main loop
  %
  for id = ids:ide ;

    if id == 1 ;    %  decimate to 16x16
      mdat = mdatbig(1:16:256,1:16:256) ;      
      decstr = '16 x 16' ;
    elseif id == 2 ;    %  decimate to 32x32
      mdat = mdatbig(1:8:256,1:8:256) ;      
      decstr = '32 x 32' ;
    elseif id == 3 ;    %  decimate to 64x64
      mdat = mdatbig(1:4:256,1:4:256) ;      
      decstr = '64 x 64' ;
    elseif id == 4 ;    %  decimate to 128x128
      mdat = mdatbig(1:2:256,1:2:256) ;      
      decstr = '128 x 128' ;
    elseif id == 5 ;    %  use full 256x256 image
      mdat = mdatbig ;      
      decstr = '256 x 256' ;
    end ;



    disp(' ') ;
    disp(['Working on ' decstr ', type ' num2str(5)]) ;


    figure(1) ;
    clf ;



    savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                             't' num2str(itest) ...
                             'id' num2str(id)] ;

%    paramstruct = struct('iscreenwrite',1, ...
%                         'nh',1, ...
%                         'hmin',2.181, ...
%                         'hmax',2.181, ...
%                         'stype',5, ...
%                         'imovie',0 ...
%                                            ) ;
%    %   early testing version, used with:    idec = 2
%    %       have used h = 5.2, 2.181

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',5, ...
                         'ishowh',1, ...
                         'savestr',savestr, ...
                         'imovie',1 ...
                                            ) ;


    sss2SM(mdat,paramstruct) ;



  end ;




elseif itest == 5 ;     %  repeat standard tests for 
                        %  conbined streamlines and contours


  ieg = 0 ;    %   0  -  loop through all
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

% get strangest effects for low noise, ieg = 1, 4, 5
%

  inoise = 0 ;    %  0  -  loop through all
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise

  icontr = 0 ;    %  0  -  loop through all
                  %  1  -  equal height
                  %  2  -  quantile spaced
                  %  3  -  modified quantile spaced



  %  set looping parameters
  %
  if ieg == 0 ;
    ies = 1 ;
    iee = 5 ;
  else ;
    ies = ieg ;
    iee = ieg ;
  end ;

  if inoise == 0 ;
    ins = 1 ;
    ine = 3 ;
  else ;
    ins = inoise ;
    ine = inoise ;
  end ;

  if icontr == 0 ;
    ics = 1 ;
    ice = 3 ;
  else ;
    ins = icontr ;
    ice = icontr ;
  end ;



  %  Main loop
  %
  for ie = ies:iee ;


    %  Loop through noise levels
    %
    for in = ins:ine ;

%      eval(['load \Research\sss\data\sss1d' num2str(ie) ...
%                                num2str(in) ';']) ;
load([basefilestr '\Research\sss\data\sss1d' num2str(ie) ...
                                num2str(in)]) ;
          % this loads the variables: xgrid ygrid mdat sig titstr noistr

      figure(1) ;
      clf ;



      for ic = ics:ice ;


        savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                                 't' num2str(itest) ...
                                 'ie' num2str(ie) ...
                                 'in' num2str(in) ...
                                 'ic' num2str(ic)] ;

%        paramstruct = struct('iscreenwrite',1, ...
%                           'nh',1, ...
%                          'hmin',4, ...
%                           'hmax',4, ...
%                           'stype',6, ...
%                           'imovie',0 ...
%                                            ) ;
%    %   early testing version, used with:    ieg = 4   inoise = 1
%    %       have used h = 7 (one bad contour)
%    %                 h = 7.5 (bad one + wierd one)
%    %                 h  = 7.3 (3 bad ones + weird one)
%    %   and with:    ieg = 1   inoise = 1
%    %       have used h = 7 (many bad contours)
%    %                 h = 7.5 (many bad ones)
%    %                 h  = 7.3 (also many)
%    %   and with:    ieg = 5   inoise = 1
%    %       have used h = 4
%    %                 h = 7.3 
%
%       sss2Early1(mdat,paramstruct) ;


        paramstruct = struct('iscreenwrite',1, ...
                             'stype',6, ...
                             'contrsp',ic, ...
                             'savestr',savestr, ...
                             'imovie',1 ...
                                                ) ;


        sss2SM(mdat,paramstruct) ;


      end ;


    end ;


  end ;



elseif itest == 10 ;     %  test 0 signal


  n = 32 ;

  seed = 60234852 ;
  randn('seed',seed) ;

  nsim = 10 ;
  for isim = 1:nsim ;

    disp('  ') ;
    disp(['    Working on isim = ' num2str(isim) ...
                            ' of ' num2str(nsim)]) ;

    mdat = randn(n,n) ;  

    for ivarp = 1:3 ;   
                      %  1 - known variance
                      %  2 - pooled est.
                      %  3 - local est.

      if ivarp == 1 ;
        ivarlocal = 0 ;
        ivarunknown = 0 ;
        varinput = 1 ;
        varstr = 'Known variance' ;
      elseif ivarp == 2 ;
        ivarlocal = 0 ;
        ivarunknown = 1 ;
        varstr = 'Pooled estimated variance' ;
      elseif ivarp == 3 ;
        ivarlocal = 1 ;
        ivarunknown = 1 ;
        varstr = 'Local estimated variance' ;
      end ;

      figure(1) ;
      clf ;



      savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                               't' num2str(itest) ...
                               'iv' num2str(ivarp) ...
                               'isim' num2str(isim)] ;

      paramstruct = struct('iscreenwrite',1, ...
                           'stype',3, ...
                           'igrid',1, ...
                           'savestr',savestr, ...
                           'imovie',1 ...
                                              ) ;


      sss2SM(mdat,paramstruct) ;

    end ;

  end ;



elseif itest == 11 ;     %  test single line


  seed = 12943809 ;
  seed = 38474095 ;
  seed = 98723947 ;
  randn('seed',seed) ;

  n = 32 ;
  ht = 100 ;
  ht = 10 ;
  ht = 2 ;
  mdat = diag(ht * ones(n,1)) + randn(n,n) ;  

   
   
  ivarp = 3 ;     %  1 - known variance
                  %  2 - pooled est.
                  %  3 - local est.

  if ivarp == 1 ;
    ivarlocal = 0 ;
    ivarunknown = 0 ;
    varinput = 1 ;
    varstr = 'Known variance' ;
  elseif ivarp == 2 ;
    ivarlocal = 0 ;
    ivarunknown = 1 ;
    varstr = 'Pooled estimated variance' ;
  elseif ivarp == 3 ;
    ivarlocal = 1 ;
    ivarunknown = 1 ;
    varstr = 'Local estimated variance' ;
  end ;



  figure(1) ;
  clf ;



  savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                           't' num2str(itest) ...
                           'iv' num2str(ivarp)] ;

  paramstruct = struct('iscreenwrite',1, ...
                       'stype',3, ...
                       'igrid',1, ...
                       'savestr',savestr, ...
                       'imovie',1 ...
                                          ) ;


  sss2SM(mdat,paramstruct) ;



elseif itest == 12 ;     %  test out n ~= m and also odd

  n = 25 ;
  m = 40 ;

  ieg = 2 ;    % 
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 1 ;    % 
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise

  %  load data
  %
%  eval(['load \Research\sss\data\sss1d' num2str(ieg) ...
%                                num2str(inoise) ';']) ;
load([basefilestr '\Research\sss\data\sss1d' num2str(ieg) ...
                                num2str(inoise)]) ;
          % this loads the variables: xgrid ygrid mdat sig titstr noistr


  mdat = mdat(65-n:64,21:20+m) ;
          %  a nonsquare piece, with interesting features


  savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                           't' num2str(itest) ...
                           'ie' num2str(ieg) ...
                           'in' num2str(inoise)] ;

  paramstruct = struct('iscreenwrite',1, ...
                       'stype',4, ...
                       'igrid',1, ...
                       'savestr',savestr, ...
                       'imovie',1 ...
                                          ) ;


  sss2SM(mdat,paramstruct) ;







elseif itest == 13 ;     %  test 0 signal, different alphas


  seed = 12943809 ;
  seed = 38474095 ;
  seed = 98723947 ;
  randn('seed',seed) ;

  n = 32 ;
  mdat = randn(n,n) ;  

   
   
  ivarp = 0 ;     %  0 - loop through all
                  %  1 - known variance
                  %  2 - pooled est.
                  %  3 - local est.


  ialpha = 0 ;    %  0 - loop through all
                  %  1 - alpha = .001
                  %  2 - alpha = .01
                  %  3 - alpha = .05
                  %  4 - alpha = .2
                  %  5 - alpha = .5
                  %  6 - alpha = .9


  if ivarp == 0 ;
    ivs = 1 ;
    ive = 3 ;
  else ;
    ivs = ivarp ;
    ive = ivarp ;
  end ;


  if ialpha == 0 ;
    ias = 1 ;
    iae = 6 ;
  else 
    ias = ialpha ;
    iae = ialpha ;
  end ;


  for iv = ivs:ive ;     %    loop through variance choices



    if ivarp == 1 ;
      ivarlocal = 0 ;
      ivarunknown = 0 ;
      varinput = 1 ;
      varstr = 'Known variance' ;
    elseif ivarp == 2 ;
      ivarlocal = 0 ;
      ivarunknown = 1 ;
      varstr = 'Pooled estimated variance' ;
    elseif ivarp == 3 ;
      ivarlocal = 1 ;
      ivarunknown = 1 ;
      varstr = 'Local estimated variance' ;
    end ;


    for ia = ias:iae ;     %   loop though alphas

      if ia == 1 ;
        alpha = 0.001 ;
      elseif ia == 2 ;
        alpha = 0.01 ;
      elseif ia == 3 ;
        alpha = 0.05 ;
      elseif ia == 4 ;
        alpha = 0.2 ;
      elseif ia == 5 ;
        alpha = 0.5 ;
      elseif ia == 6 ;
        alpha = 0.9 ;
      end ;



      disp(['Working on ' varstr ', alpha = ' num2str(alpha)]) ;




      savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                           't' num2str(itest) ...
                           'iv' num2str(ivarp) ...
                           'ia' num2str(ia)] ;

      paramstruct = struct('iscreenwrite',1, ...
                           'stype',3, ...
                           'igrid',1, ...
                           'savestr',savestr, ...
                           'imovie',1 ...
                                          ) ;


      sss2SM(mdat,paramstruct) ;



    end ;    %  ialpha loop

  end ;    %  ivarp loop





elseif  itest > 50  &  itest < 100 ;    %  then test density estimation


  if itest == 51 ;     %  Simulated Examples


    ieg = 2 ;    %   0  -  loop through all
                 %   1  -  Small Simple Data Set
                 %   2  -  Bivariate Mixture

    imethod = 7 ;     %  0  -  loop through all
                      %  1  -  Simple tests, to check parametrizations
                      %  2  -  dots and arrows, 2x2 grid
                      %  3  -  dots and arrows, 2x2 grid, better boundaries
                      %  4  -  dots and arrows, 2x2 grid, crazy boundaries
                      %  5  -  streamlines, better boundaries
                      %  6  -  contours
                      %  7  -  contours and streamlines


    %  set looping parameters
    %
    if ieg == 0 ;
      ies = 1 ;
      iee = 2 ;
    else ;
      ies = ieg ;
      iee = ieg ;
    end ;

    if imethod == 0 ;
      imeths = 1 ;
      imethe = 7 ;
    else ;
      imeths = imethod ;
      imethe = imethod ;
    end ;



    %  Main loop
    %
    for ie = ies:iee ;

      if ie == 1 ;

        denstr = 'Small Simple Test Set' ;

        data = [2.5, 3.3 ; ...
                4.8, 2.2 ; ...
                2.9, 5.3 ] ;


        vgpg = [2,5,6,2,6,8] ;
            %  Good grid parameters

        vgpb = [3,9,6,0,4,8] ;
            %  Bad grid parameters

        vgpt = [5,10,5,5,10,5] ;
            %  Terrible grid parameters


      elseif ie == 2 ;

        denstr = 'Bivariate Normal Mixture' ;

        seed = 29387509 ;
        rand('seed',seed) ;
        randn('seed',seed) ;

        n = 200 ;
        sig = 8 ;

        data = sig * randn(n,2) ;
            %  N(0,sig^2)

        rand01 = (rand(n,1) > .5) ;
            %  random 0 or 1

        flag1 = logical(rand01) ;
        data(flag1,1) = .1 * data(flag1,1) ;
        data(flag1,2) = 1 * data(flag1,2) ;
            %  rescale half of them

        data = 32 * ones(n,2) + data ;
            %  shift mean to [32,32]


        randpm1 = 2 * rand01 - 1 ;
            %  random plus or minus 1
            %  (same as above)

        data = data + randpm1 * [16, 16] ;
            %  add or subtract 16 at random


        plot(data(:,1),data(:,2),'o') ;
        pauseSM ; 



        vgpg = [1,64,64,1,64,64] ;
            %  Good grid parameters

        vgpb = [33,64,32,33,64,32] ;
            %  Bad grid parameters

        vgpt = [101,120,20,101,120,20] ;
            %  Terrible grid parameters




      end ;




      %  Loop through SSS methods
      %
      for imeth = imeths:imethe ;


        if imeth == 1 ;    %  just do smooth, default grid


%          sss1(data,0,0,0.05,1) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Default Grid Parameters') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'titlestr','Default Grid Parameters', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;
 
          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpg) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Good Grid Parameters') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpg, ...
                               'titlestr','Good Grid Parameters', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpb) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Bad Grid Parameters') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpb, ...
                               'titlestr','Bad Grid Parameters', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpt) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            %  0 - bdry truncation
%            title('Terrible Grid Parameters') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpt, ...
                               'titlestr','Terrible Grid Parameters', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpg,0) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            %  0 - bdry truncation
%            title('Good Grid Parameters, Bdry deletion') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpg, ...
                               'bdryp',0, ...
                               'titlestr','Good Grid Parameters, Bdry deletion', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpb,0) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            %  0 - bdry truncation
%            title('Bad Grid Parameters, Bdry deletion') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpb, ...
                               'bdryp',0, ...
                               'titlestr','Bad Grid Parameters, Bdry deletion', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,vgpt,0) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Terrible Grid Parameters, Bdry deletion') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',vgpt, ...
                               'bdryp',0, ...
                               'titlestr','Terrible Grid Parameters, Bdry deletion', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,[vgpg,1]) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Good Grid Parameters, neighbor binning') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[vgpg 1], ...
                               'titlestr','Good Grid Parameters, neighbor binning', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,[vgpb,1]) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Bad Grid Parameters, neighbor binning') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[vgpb 1], ...
                               'titlestr','Bad Grid Parameters, neighbor binning', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,0,0,0.05,1,[vgpt,1]) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Terrible Grid Parameters, neighbor binning') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[vgpt 1], ...
                               'titlestr','Terrible Grid Parameters, neighbor binning', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          disp('Bad grid') ;
%          sss1(data,0,0,0.05,1,[3,1,18,6,2,9]) ; 
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[3,1,18,6,2,9], ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

          disp('Non-inter grid numbers') ;
%          sss1(data,0,0,0.05,1,[1,10,10.4,1,10,9.8]) ; 
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[1,10,10.4,1,10,9.8], ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,[1,1,1,1,0,1],0,0.05,1,[vgpg,1]) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Good Grid Parameters, test circles') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'ismallessctrl',1, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[vgpg,1], ...
                               'titlestr','Good Grid Parameters, test circles', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;

          pauseSM ;

%          sss1(data,[1,2,1,1,0,1],0,0.05,1,[vgpg,1]) ;
%            %  0 - just do smooth
%            %  0 - variance parameter
%            %  0.05 - alpha
%            %  1 - h
%            title('Good Grid Parameters, test circles 2x2 blocks') ;
          paramstruct = struct('stype',0, ...
                               'imovie',0, ...
                               'igrid',2, ...
                               'ismallessctrl',1, ...
                               'hmin',1, ...
                               'nh',1, ...
                               'vgp',[vgpg,1], ...
                               'titlestr','Good Grid Parameters, test circles 2x2 blocks', ...
                               'ishowh',0) ;
          sss2SM(data,paramstruct) ;



        elseif imeth == 2 ;




          figure(1) ;
          clf ;


%          sss1(data,[3,2]) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
          paramstruct = struct('stype',1, ...
                               'igrid',2, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;


%          subplot(2,2,1) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[denstr ', ' titlestr]) ;
%
%          subplot(2,2,2) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%
%          subplot(2,2,3) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',['SSS, ' titlestr]) ;
%
%          subplot(2,2,4) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[date ', ' titlestr]) ;
%


        elseif imeth == 3 ;




          figure(1) ;
          clf ;


          vgridp = [1,64,32,1,64,32] ;
          vgridp = [1,64,32,1,64,64] ;
          vgridp = [1,64,64,1,64,64] ;
            %  vector of grid parameters

%          sss1(data,[3,2],0,0.05,0,vgridp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid
          paramstruct = struct('stype',2, ...
                               'igrid',2, ...
                               'vgp',vgridp, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;


%          subplot(2,2,1) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[denstr ', ' titlestr]) ;
%
%          subplot(2,2,2) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%
%          subplot(2,2,3) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',['SSS, ' titlestr]) ;
%
%          subplot(2,2,4) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[date ', ' titlestr]) ;






        elseif imeth == 4 ;




          figure(1) ;
          clf ;


          vgridp = [1,32,32,40,64,32] ;
          vgridp = [1,64,64,33,64,32] ;
          vgridp = [-16,-1,16,65,80,16] ;
            %  vector of grid parameters

          bdp = 1 ;
            %    0 - truncate
            %    1 - move to nearest edge

%          sss1(data,[3,2],0,0.05,0,vgridp,bdp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid
          paramstruct = struct('stype',3, ...
                               'igrid',2, ...
                               'vgp',vgridp, ...
                               'bdryp',0, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;


%          subplot(2,2,1) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[denstr ', ' titlestr]) ;
%
%          subplot(2,2,2) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%
%          subplot(2,2,3) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',['SSS, ' titlestr]) ;
%
%          subplot(2,2,4) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[date ', ' titlestr]) ;





        elseif imeth == 5 ;




          figure(1) ;
          clf ;


          vgridp = [1,64,32,1,64,32] ;
  %        vgridp = [1,64,32,1,64,64] ;
  %        vgridp = [1,64,64,1,64,64] ;
            %  vector of grid parameters

%          sss1(data,4,0,0.05,0,vgridp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid
          paramstruct = struct('stype',4, ...
                               'vgp',vgridp, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;


%          subplot(2,2,1) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[denstr ', ' titlestr]) ;
%
%          subplot(2,2,2) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%
%          subplot(2,2,3) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',['SSS, ' titlestr]) ;
%
%          subplot(2,2,4) ;
%            titlestr = get(get(gca,'Title'),'String') ;
%            set(get(gca,'Title'),'String',[date ', ' titlestr]) ;




        elseif imeth == 6 ;




          figure(1) ;
          clf ;


          vgridp = [1,64,16,1,64,16] ;
            %  vector of grid parameters

          h = 4 ;

%          sss1(data,[3,1],0,0.05,h,vgridp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
          paramstruct = struct('stype',5, ...
                               'vgp',vgridp, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;




        elseif imeth == 7 ;




          figure(1) ;
          clf ;


          vgridp = [1,64,16,1,64,16] ;
            %  vector of grid parameters

          h = 4 ;

%          sss1(data,[3,1],0,0.05,h,vgridp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
          paramstruct = struct('stype',6, ...
                               'vgp',vgridp, ...
                               'ishowh',1) ;
          sss2SM(data,paramstruct) ;





        end ;


      end ;


    end ;






  elseif itest == 52 ;     %  real data sets

    ieg = 0 ;    %   0  -  loop through all
                 %   1  -  Old Faithful Geyser (from Scott)
                 %   2  -  Lipid Data (from Scott)
                 %   3  -  Earthquake Data (from Wand and Jones)
                 %   4  -  Melbourne Temperatures (from Hyndman)
                 %   5  -  Perfusion MR
                 %   6  -  Aircraft Span (from Bowman)
                 %   7  -  Cancer Data (form Bowman)

    imethod = 0 ;     %  0  -  loop through all
                      %  1  -  Simple Scatter Plot
                      %  2  -  dots and arrows, 2x2 grid, default boundaries
                      %  3  -  dots and arrows, 2x2 grid, chosen boundaries
                      %  4  -  streamlines, chosen boundaries
                      %  5  -  movie of smooths only
                      %  6  -  movie of 2x2 dots and arrows, chosen boundaries
                      %  7  -  movie of streamlines, chosen boundaries



    %  set looping parameters
    %
    if ieg == 0 ;
      ies = 1 ;
      iee = 7 ;
    else ;
      ies = ieg ;
      iee = ieg ;
    end ;

    if imethod == 0 ;
      imeths = 1 ;
      imethe = 6 ;
    else ;
      imeths = imethod ;
      imethe = imethod ;
    end ;




    %  Main loop
    %
    for ie = ies:iee ;

      if ie == 1 ;

        datstr = 'Old Faithful' ;
        xlab = 'Duration_t' ;
        ylab = 'Duration_{t+1}' ;


%        fid = fopen('/matlab/steve/data/scott/geyser.in','rt') ;
        fid = fopen([basefilestr '/matlab/steve/data/scott/geyser.in'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ;
            %  can add a "size" parameter when don't want to read all.
            %  cnt tells how many reads were done (2 * 3 fields = 6)
        fclose(fid) ;

        data = [invec(1:cnt-1),invec(2:cnt)] ;
            %  "y" is lag one ahead version of "x"


        vgridp = [1,5.3,64,1,5.3,64] ;
            %  vector of grid parameters



      elseif ie == 2 ;

        datstr = 'Lipids' ;
        xlab = 'Cholesterol' ;
        ylab = 'log(Triglyceride)' ;


%        fid = fopen('/matlab/steve/data/scott/lipid.in','rt') ;
        fid = fopen([baswefilestr '/matlab/steve/data/scott/lipid.in'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ; 
            %  can add a "size" parameter when don't want to read all.
            %  cnt tells how many reads were done (2 * 3 fields = 6)
        fclose(fid) ;

        data = reshape(invec',2,cnt/2)' ;
            %  since matlab does reshape down columns first 

        data(:,2) = log(data(:,2)) ;
            %  log transformation of 2nd variable, as
            %  Figure 1.2 in Scott's book


        vgridp = [120,300,64,4,6,64] ;
            %  vector of grid parameters



      elseif ie == 3 ;

        datstr = 'Earthquakes' ;
        xlab = 'Longitude' ;
        ylab = 'Latitude' ;

%        fid = fopen('/matlab/steve/data/MtStHelens.txt','rt') ;
        fid = fopen([basefilestr '/matlab/steve/data/MtStHelens.txt'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ; 
            %  can add a "size" parameter when don't want to read all.
            %  cnt tells how many reads were done (2 * 3 fields = 6)
        fclose(fid) ;

        data = reshape(invec',2,cnt/2)' ;
            %  since matlab does reshape down columns first 

        data = fliplr(data) ;
            %  do "transpose" (i.e. swap x and y), so looks like
            %  Figure 4.2 in the Wand and Jones book.


        vgridp = [122.15,122.22,64,46.18,46.21,64] ;
            %  vector of grid parameters



      elseif ie == 4 ;

        datstr = 'Melbourne Temps' ;
        xlab = 'Max Temp_t' ;
        ylab = 'Max Temp_{t+1}' ;


%        fid = fopen('/matlab/steve/data/melbmax.dat','rt') ;
        fid = fopen([basefilestr '/matlab/steve/data/melbmax.dat'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ;
            %  can add a "size" parameter when don't want to read all.
            %  cnt tells how many reads were done (2 * 3 fields = 6)
        fclose(fid) ;

        data = [invec(1:cnt-1),invec(2:cnt)] ;
            %  "y" is lag one ahead version of "x"


        vgridp = [6,42,64,6,42,64] ;
            %  vector of grid parameters



      elseif ie == 5 ;

        datstr = 'Perfusion MR' ;
        xlab = 'tau' ;
        ylab = 'delta' ;

%        fid = fopen('/matlab/steve/data/perfMRI.txt','rt') ;
        fid = fopen([basefilestr '/matlab/steve/data/perfMRI.txt'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ; 
            %  can add a "size" parameter when don't want to read all.
            %  cnt tells how many reads were done (2 * 3 fields = 6)
        fclose(fid) ;

        data = reshape(invec',2,cnt/2)' ;
            %  since matlab does reshape down columns first 


        vgridp = [6,30,64,200,1800,64] ;
            %  vector of grid parameters



      elseif ie == 6 ;

        datstr = 'Aircraft Span' ;
        xlab = 'P. Comp. 1' ;
        ylab = 'P. Comp. 2' ;

%        fid = fopen('/matlab/steve/data/Bowman/airpc.in','rt') ;
        fid = fopen([basefielstr '/matlab/steve/data/Bowman/airpc.in'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ; 
        fclose(fid) ;

        data = reshape(invec',4,cnt/4)' ;
            %  since matlab does reshape down columns first 

        data = data(find(data(:,4) == 3),:) ;
            %  keep only those for "period 3"

        data = data(:,1:2) ;
            %  first 2 variables are the principal components


        vgridp = [-3.5,6.5,64,-1.5,3.5,64] ;
            %  vector of grid parameters



      elseif ie == 7 ;

        datstr = 'Cancer Data' ;
        xlab = 'Easting' ;
        ylab = 'Northing' ;

%        fid = fopen('/matlab/steve/data/Bowman/lcancer.in','rt') ;
        fid = fopen([basefilestr '/matlab/steve/data/Bowman/lcancer.in'],'rt') ;
            %  'rt' is for "read only" and "text"
          [invec,cnt] = fscanf(fid,'%f') ; 
        fclose(fid) ;

        data = reshape(invec',3,cnt/3)' ;
            %  since matlab does reshape down columns first 

        data = data(find(data(:,3) == 1),:) ;
            %  keep only those with cancer
           %  code is 2 for no cancer

        data = data(:,1:2) ;
            %  first 2 variables are the principal components

        data = data / 10000 ;
            %  rescale to make these nicer numbers

        vgridp = [34.5,36.5,64,41,43,64] ;
            %  vector of grid parameters



      end ;




      disp(' ') ;
      disp(['Working with ' datstr]) ;
      disp(' ') ;


      ndat = size(data,1) ;
            %  number of rows is number of data points




      %  Loop through SSS methods
      %
      for imeth = imeths:imethe ;

        if imeth == 1 ;    %  Simple Scatter Plot

          figure(1) ;
          clf ;

          plot(data(:,1),data(:,2),'+') ;
            title(['Scatterplot ' datstr ', ' date]) ;
            xlabel(xlab) ;
            ylabel(ylab) ;

            vax = axis ;
              tx = vax(1) + .8 * (vax(2) - vax(1)) ;
              ty = vax(3) + .9 * (vax(4) - vax(3)) ;
            text(tx,ty,['n = ' num2str(ndat)]) ;


            orient landscape ;
          eval(['print -dps \matlab\steve\ps\sss1td' ...
                                          num2str(itest) ...
                                          num2str(ie) ...
                                          num2str(imeth) ...
                                                    '.ps ;']) ;





        elseif imeth == 2 ;    %  dots and arrows, 2x2 grid, default boundaries
%

          figure(1) ;
          clf ;


%          sss1(data,[3,2]) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid




%        subplot(2,2,1) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[datstr ', ' titlestr]) ;
%
%        subplot(2,2,2) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',['n = ' num2str(ndat) ', ' titlestr]) ;
%
%        subplot(2,2,3) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[date ', ' titlestr]) ;
%
%
%            orient landscape ;
%        eval(['print -dpsc \matlab\steve\ps\sss1td' ...
%                                          num2str(itest) ...
%                                          num2str(ie) ...
%                                          num2str(imeth) ...
%                                                    '.ps ;']) ;






        elseif imeth == 3 ;    %  dots and arrows, 2x2 grid, chosen boundaries


          figure(1) ;
          clf ;


%          sss1(data,[3,2],0,0.05,0,vgridp) ;
  %                |:  1 - arrows only
  %                |:  2 - dots only
  %                |:  3 - dots and arrows
  %                |:  4 - streamlines
  %                  |:  1 - single pixels
  %                  |:  2 - 2 x 2 boxes
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid



%        subplot(2,2,1) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[datstr ', ' titlestr]) ;
%
%        subplot(2,2,2) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',['n = ' num2str(ndat) ', ' titlestr]) ;
%
%        subplot(2,2,3) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[date ', ' titlestr]) ;
%
%
%            orient landscape ;
%        eval(['print -dpsc \matlab\steve\ps\sss1td' ...
%                                          num2str(itest) ...
%                                          num2str(ie) ...
%                                          num2str(imeth) ...
%                                                    '.ps ;']) ;





        elseif imeth == 4 ;    % streamlines, chosen boundaries




          figure(1) ;
          clf ;


%          sss1(data,4,0,0.05,0,vgridp) ;
            %  0 - variance handling parameter (no effect)
            %  0.05 - alpha
            %  0 - default bandwidth grid



%        subplot(2,2,1) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[datstr ', ' titlestr]) ;
%
%        subplot(2,2,2) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',['n = ' num2str(ndat) ', ' titlestr]) ;
%
%        subplot(2,2,3) ;
%          titlestr = get(get(gca,'Title'),'String') ;
%          set(get(gca,'Title'),'String',[date ', ' titlestr]) ;
%
%
%            orient landscape ;
%        eval(['print -dpsc \matlab\steve\ps\sss1td' ...
%                                          num2str(itest) ...
%                                          num2str(ie) ...
%                                          num2str(imeth) ...
%                                                    '.ps ;']) ;



        elseif imeth == 5 ;    % movie of smooths only


          figure(1) ;
          clf ;



          type = [0,0,2] ;
  %               |:  0 - smooth only
  %               |:  1 - arrows only
  %               |:  2 - dots only
  %               |:  3 - dots and arrows
  %               |:  4 - streamlines
  %                 |:  1 - single pixels
  %                 |:  2 - 2 x 2 boxes
  %                   |:  1 - static plot
  %                   |:  2 - movie, looping through bandwidths
  %                   |:  3 - plot with slider (allows choice to print)
 


%          sss1(data,type,[1,0],0.05,[1,16,33],vgridp) ;
            %  [1,0]  -  variance parameter
            %  0.05   -  alpha
            %  [1,16,33]  -  33 frames   1-16 (adds 8 more to usual)


          %  rename mpeg file
          %
%          rnstr = ['!rename sss1.mpg sss1td' ...
%                                         num2str(itest) ...
%                                         num2str(ie) ...
%                                         num2str(imeth) ...
%                                                    '.mpg ;'] ;
%          eval(rnstr) ;



        elseif imeth == 6 ;    % movie of 2x2 dots and arrows, chosen boundaries


          figure(1) ;
          clf ;



          type = [3,2,2] ;
  %               |:  0 - smooth only
  %               |:  1 - arrows only
  %               |:  2 - dots only
  %               |:  3 - dots and arrows
  %               |:  4 - streamlines
  %                 |:  1 - single pixels
  %                 |:  2 - 2 x 2 boxes
  %                   |:  1 - static plot
  %                   |:  2 - movie, looping through bandwidths
  %                   |:  3 - plot with slider (allows choice to print)
 


%          sss1(data,type,[1,0],0.05,[1,16,33],vgridp) ;
            %  [1,0]  -  variance parameter
            %  0.05   -  alpha
            %  [1,16,33]  -  33 frames   1-16 (adds 8 more to usual)


          %  rename mpeg file
          %
%          rnstr = ['!rename sss1.mpg sss1td' ...
%                                         num2str(itest) ...
%                                         num2str(ie) ...
%                                         num2str(imeth) ...
%                                                    '.mpg ;'] ;
%          eval(rnstr) ;
%




        elseif imeth == 7 ;    % movie of streamlines, chosen boundaries


          figure(1) ;
          clf ;



          type = [4,0,2] ;
  %               |:  0 - smooth only
  %               |:  1 - arrows only
  %               |:  2 - dots only
  %               |:  3 - dots and arrows
  %               |:  4 - streamlines
  %                 |:  1 - single pixels
  %                 |:  2 - 2 x 2 boxes
  %                   |:  1 - static plot
  %                   |:  2 - movie, looping through bandwidths
  %                   |:  3 - plot with slider (allows choice to print)
 


%          sss1(data,type,[1,0],0.05,[1,16,33],vgridp) ;
            %  [1,0]  -  variance parameter
            %  0.05   -  alpha
            %  [1,16,33]  -  33 frames   1-16 (adds 8 more to usual)


          %  rename mpeg file
          %
%          rnstr = ['!rename sss1.mpg sss1td' ...
%                                         num2str(itest) ...
%                                         num2str(ie) ...
%                                         num2str(imeth) ...
%                                                    '.mpg ;'] ;
%          eval(rnstr) ;





        end ;    %  of imeth if-block


      end ;   %  of imeth loop


    end ;   %  of ie loop


  end ;    %  of itest if-block






elseif  itest > 100  &  itest < 200 ;    %  then test defaults



  if itest == 101 ;    % just do basics
    idecim = 1 ;     %  0 - use given 64 x 64 image
                     %  1 - decimate to 32 x 32 to increase speed

    ieg = 2 ;    %   1  -  parallel peaks
                 %   2  -  peaks and valleys
                 %   3  -  sombrero
                 %   4  -  volcano
                 %   5  -  piecewise linear

    inoise = 2 ;    %  1  -  low noise
                    %  2  -  medium noise
                    %  3  -  high noise


    paramstruct = [] ;


  elseif itest == 102 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = ['???'] ;


  elseif itest == 103 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1 ...
                                              ) ;


  elseif itest == 104 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 105 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',0, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 106 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 107 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 108 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 109 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',4, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 110 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',4, ...
                         'igrid',2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 111 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'igrid',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 112 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',2, ...
                         'igrid',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 113 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',1, ...
                         'igrid',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 114 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',6, ...
                         'igrid',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 115 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarunknown',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 116 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarunknown',0, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 117 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarunknown',0, ...
                         'varinput',0.001, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 118 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarunknown',0, ...
                         'varinput',10, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 119 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarlocal',0, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 120 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'ivarlocal',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 121 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'alpha',0.05, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 122 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'alpha',0.005, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 123 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'alpha',0.2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 124 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',0, ...
                         'hmax',64, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 125 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',0.5, ...
                         'hmax',4, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 126 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',4, ...
                         'hmax',4, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 127 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',4, ...
                         'hmax',4, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 128 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'nh',-25, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 129 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'nh',4, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 130 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'nh',100, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 131 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'nh',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 132 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',4, ...
                         'hmax',27, ...
                         'nh',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 133 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'hmin',4, ...
                         'hmax',2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 134 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 2 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'vgp',27, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 135 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'bdryp',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 136 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'bdryp',0, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 137 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'bdryp',2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 138 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'savestr','\temp\sss2test', ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 139 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'savestr','\temp\sss2SMtest', ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 140 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',1, ...
                         'nrepeat',10, ...
                         'moviefps',8, ...
                         'nh',8, ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 141 ;    %  nonstandard paramstruct
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'itoobigctrl',2, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 142 ;    %  titlestr
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'titlestr','Testing Title',  ...
                         'stype',6, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 143 ;    %  titlestr
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'titlestr','Testing Title',  ...
                         'stype',6, ...
                         'savestr','\temp\sss2SMtest', ...
                         'imovie',1 ...
                                              ) ;


  elseif itest == 144 ;    %  titlestr & add no h
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'titlestr','Testing Title',  ...
                         'ishowh',0, ...
                         'stype',6, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 145 ;    %  titlestr & add h
    idecim = 1 ;  
    ieg = 4 ;  
    inoise = 2 ;
          %  see itest == 101  for definitions of these

    paramstruct = struct('iscreenwrite',1, ...
                         'titlestr','Testing Title',  ...
                         'ishowh',1, ...
                         'stype',6, ...
                         'imovie',1 ...
                                              ) ;

%  things to test:
%    ncontr
%    contours in density and regression
%    contours with different grid sizes
%    contour spacings


  end ;    %  of itest if block




%  eval(['load \Research\sss\data\sss1d' num2str(ieg) ...
%                            num2str(inoise) ';']) ;
load([basefilestr '\Research\sss\data\sss1dbig' num2str(ieg) ...
                                num2str(inoise)]) ;
           % this loads the variables: xgridygrid mdat sig titstr noistr


  if idecim == 1 ;
    mdat = mdat(1:2:63,1:2:63) ;
           %  decimation of data (to keep run time short for testing)
  end ;

  close all ;
          %  this seems to avoid getting ghost colors
          %  appearing in some plots

  sss2SM(mdat,paramstruct) ;





elseif  itest > 200  &  itest < 300 ;    %  then test specialized stuff


  if itest == 201 ;

    seed = 43572098 ;
    randn('seed',seed) ;

    mdat = randn(128,128) ;

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 202 ;

    seed = 43572098 ;
    randn('seed',seed) ;

    mdat = randn(128,128) ;

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'itoobigctrl',0, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 203 ;

    seed = 43572098 ;
    randn('seed',seed) ;

    mdat = randn(128,128) ;

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'itoobigctrl',1, ...
                         'imovie',0 ...
                                              ) ;


  elseif itest == 204 ;

    seed = 43572098 ;
    randn('seed',seed) ;

    mdat = randn(128,128) ;

    paramstruct = struct('iscreenwrite',1, ...
                         'stype',3, ...
                         'itoobigctrl',2, ...
                         'imovie',0 ...
                                              ) ;



  end ;


%  itoobigctrl
%  ismallessctrl


  close all ;
          %  this seems to avoid getting ghost colors
          %  appearing in some plots

  sss2SM(mdat,paramstruct) ;



elseif itest > 300 ;    %  then test (and experiment with) movie saves

  ieg = 4 ;    %   0  -  loop through all
               %   1  -  parallel peaks
               %   2  -  peaks and valleys
               %   3  -  sombrero
               %   4  -  volcano
               %   5  -  piecewise linear

  inoise = 1 ;    %  0  -  loop through all
                  %  1  -  low noise
                  %  2  -  medium noise
                  %  3  -  high noise

%  eval(['load \Research\sss\data\sss1d' num2str(ieg) ...
%                            num2str(inoise) ';']) ;
load([basefilestr '\Research\sss\data\sss1d' num2str(ieg) ...
                                num2str(inoise)]) ;
          % this loads the variables: xgridygrid mdat sig titstr noistr

  figure(1) ;
  clf ;

  mdat = mdat(1:2:63,1:2:63) ;
         %  decimation of data (to keep run time short for testing)

  savestr = [basefilestr '\Research\sss\TestOutputs\sss2' ...
                               'test' num2str(itest)] ;


  if itest == 301 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 15 ;    %  standard AVI default
    nh = 25 ;    %  sss2SM default, for best comparison
    moviecstr = 'Cinepak' ;    %  SSS2SM default
    titlestr = ['Frames per second = ' num2str(moviefps)] ;

  elseif itest == 302 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 5 ;    %  still too fast?
    nh = 25 ;    %  sss2SM default, for best comparison
    moviecstr = 'Cinepak' ;    %  SSS2SM default
    titlestr = ['Frames per second = ' num2str(moviefps)] ;

  elseif itest == 303 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;    %  about right?
    nh = 25 ;    %  sss2SM default, for best comparison
    moviecstr = 'Cinepak' ;    %  SSS2SM default
    titlestr = ['Frames per second = ' num2str(moviefps)] ;

  elseif itest == 304 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 1 ;    %  too slow?
    nh = 25 ;    %  sss2SM default, for best comparison
    moviecstr = 'Cinepak' ;    %  SSS2SM default
    titlestr = ['Frames per second = ' num2str(moviefps)] ;
    
    
  elseif itest == 305 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'MSVC' ; 
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 306 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'None' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 307 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Cinepak' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 308 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Indeo3' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 309 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Indeo5' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 310 ;
    stype = 6 ;    %  combined streamlines and contours
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'dummy' ;    %  try one that is not a real name
    titlestr = ['Compression = ' moviecstr] ;


  elseif itest == 311 ;
    stype = 3 ;    %  combined arrows and dots
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'MSVC' ;    %  SSS2SM default
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 312 ;
    stype = 3 ;    %  combined arrows and dots
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'None' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 313 ;
    stype = 3 ;    %  combined arrows and dots
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Cinepak' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 314 ;
    stype = 3 ;    %  combined arrows and dots
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Indeo3' ;
    titlestr = ['Compression = ' moviecstr] ;

  elseif itest == 315 ;
    stype = 3 ;    %  combined arrows and dots
    moviefps = 2 ;
    nh = 3 ;    %  for quick construction
    moviecstr = 'Indeo5' ;
    titlestr = ['Compression = ' moviecstr] ;


  end ;    %  of inner itest if-block


  paramstruct = struct('iscreenwrite',1, ...
                       'stype',stype, ...
                       'nh',nh, ...
                       'moviefps',moviefps, ...
                       'moviecstr',moviecstr, ...
                       'savestr',savestr, ...
                       'titlestr',titlestr, ...
                       'imovie',1 ...
                                          ) ;


  sss2SM(mdat,paramstruct) ;




end ;    %  of itest if-block





