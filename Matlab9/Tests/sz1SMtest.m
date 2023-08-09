disp('Running MATLAB script file sz1SMtest.m') ;
%
%    Test program for sz1SM.m
%    General Purpose Significant derivative Zero crossings

ipart = 0 ;     %  0  simple tests, using itestpar below
                %  1  real data sets (density estimation)
                %  2  normal mixture examples (density estimation)
                %  3  real data sets (regression)
                %  4  NR book examples (regression)
                %  5  B-spline test examples (regression)
                %  6  ER Wavelet Examples (regression)

itestpar = 13 ;  %  test various parameter settings (when ipart = 0)
                %  1 kde, entered xgrid
                %  2 kde, entered xgrid and hgrid
                %  3 kde, entered hgrid
                %  4 kde, wierd range no truncation
                %  5 kde, wierd range with truncation
                %  6 kde, like 1, but alpha = .2
                %  7 kde, like 1, but alpha = .01
                %  8 kde, like 1, but ptwise
                %  9 llr, entered xgrid
                %  10 llr, just 1 row (for additive models)
                %  11 kde, check out boundary adjustments
                %  12 kde, with bad vhgp
                %  13 kde, uniform test of simultaneity
                %  14 llr, white noise test of simultaneity


autop = 0 ;     %  0 - create no postscript files, and pause at each pic
                %  1 - create postscript files, and pause at each pic
                %  2 - create postscript files, and no pause

format compact ;


if ipart == 0 ;   %  then do simple tests

  figure(1) ;
  clf ;
  
  rand('seed',29384729) ;
  if itestpar == 1 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,2,31]) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 2 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,2,31], ...
                         'vhgp',[.1,5,10]) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 3 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',0, ...
                         'vhgp',[.1,5,5]) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 4 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,.5,31], ...
                         'vhgp',0, ...
                         'eptflag',0) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 5 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,.5,31], ...
                         'vhgp',0, ...
                         'eptflag',1) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 6 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,2,31], ...
                         'vhgp',0, ...
                         'eptflag',1, ...
                         'alpha',0.2) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 7 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,2,31], ...
                         'vhgp',0, ...
                         'eptflag',1, ...
                         'alpha',0.01) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 8 ;
    data = rand(20,1) ;
    paramstruct = struct('vxgp',[-1,2,31], ...
                         'vhgp',0, ...
                         'eptflag',1, ...
                         'alpha',0.05, ...
                         'simflag',0) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 9 ;
    data = rand(50,1) ;
    flag = data < .5 ;
    data = [data, flag .* data + (1 - flag) .* (1 - data)] ;
    paramstruct = struct('vxgp',[-1,2,31], ...
                         'vhgp',0, ...
                         'eptflag',1, ...
                         'alpha',0.05, ...
                         'simflag',1) ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 10 ;
    data = rand(50,1) ;
    data = [data, (data < .7) & (data > .3)] ;
    paramstruct = struct('vxgp',[0,1,40], ...
                         'vhgp',[.1,.1,1]) ;
    vecout = sz1SM(data,paramstruct) ;
    vecout
  elseif itestpar == 11 ;
    data = [rand(50,1)/2; 0.5+rand(150,1)/2] ;
    subplot(2,2,1) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','Default Boundary Adjustment') ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,2) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','No Boundary Adjustment', ...
                           'ibdryadj',0) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,3) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','Mirror Image Adjustment', ...
                           'ibdryadj',1) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,4) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','Circular Design Adjustment', ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
  elseif itestpar == 12 ;
    data = [rand(50,1)/2; 0.5+rand(150,1)/2] ;
    paramstruct = struct('vhgp',[10,1,11], ...
                           'titlestr','Default Boundary Adjustment') ;
    sz1SM(data,paramstruct) ;
  elseif itestpar == 13 ;
    rand('seed',29384740) ;
    data = rand(500,1) ;
    subplot(2,2,1) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','500 Unif''s, Circ. B. A., Default Simul.', ...
                           'simflag',1, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,2) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','500 Unif''s, Circ. B. A., Global Simul.', ...
                           'simflag',2, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,3) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','500 Unif''s, Circ. B. A., Mix 1 Simul.', ...
                           'simflag',2, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,4) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','500 Unif''s, Circ. B. A., Mix 2 Simul.', ...
                           'simflag',4, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
  elseif itestpar == 14 ;
    randn('seed',40209347) ;
    randn('seed',49028374) ;
    datax = ((1:400)' - 0.5) / 400 ;
    datay = randn(400,1) ;
    data = [datax datay] ;
    subplot(2,2,1) ;
      paramstruct = struct('vxgp',[0,1,400], ...
                           'titlestr','400 N(0,1)''s, Default Simul.', ...
                           'simflag',1, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,2) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','400 N(0,1)''s, Global Simul.', ...
                           'simflag',2, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,3) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','400 N(0,1)''s, Mix 1 Simul.', ...
                           'simflag',2, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
    subplot(2,2,4) ;
      paramstruct = struct('vxgp',[0,1,401], ...
                           'titlestr','400 N(0,1)''s, Mix 2 Simul.', ...
                           'simflag',4, ...
                           'ibdryadj',2) ;
      sz1SM(data,paramstruct) ;
  end ;

%function [mapout,xgrid] = sz1SM(data,vxgp,vhgp,eptflag,alpha,simflag,llflag) 

elseif ipart == 1 ;    %  then do real density estimation data sets


  vidat = [1:10] ;
                     %  1 - Income Data
                     %  2 - Geyser Data
                     %  3 - Stamp Data
                     %  4 - Chondrite Data
                     %  5 - Buffalo Snowfall Data
                     %  6 - Suicide Data
                     %  7 - Coal Seam Data
                     %  8 - Marine Data
                     %  9 - Dust Data
                     %  10 - Galactic Cluster Data


  for idat = vidat ;

    figure(1) ;
    clf ;

    if idat == 1 ;
      matfilestr = '\Research\GeneralData\incomes' ;
      vrange = [0;3] ;
    elseif idat == 2 ;
      matfilestr = '\Research\GeneralData\geyser' ;
      vrange = [] ;
    elseif idat == 3 ;
      matfilestr = '\Research\GeneralData\stamps' ;
      vrange = [] ;
    elseif idat == 4 ;
      matfilestr = '\Research\GeneralData\chondrit' ;
      vrange = [] ;
    elseif idat == 5 ;
      matfilestr = '\Research\GeneralData\snowfall' ;
      vrange = [] ;
    elseif idat == 6 ;
      matfilestr = '\Research\GeneralData\suicides' ;
      vrange = [] ;
    elseif idat == 7 ;
      matfilestr = '\Research\GeneralData\coalseam' ;
      vrange = [] ;
    elseif idat == 8 ;
      matfilestr = '\Research\GeneralData\fredmari' ;
      vrange = [] ;
    elseif idat == 9 ;
      matfilestr = '\Research\GeneralData\raydust' ;
      vrange = [] ;
    elseif idat == 10 ;
      matfilestr = '\Research\GeneralData\galaxy' ;
      vrange = [] ;
    end ;


    load(matfilestr) ;

    disp(['  Working on ' dtitstr ' Data']) ;
    disp(dcomments) ;
    disp(['    Read in ' num2str(length(data)) ' data points']) ;


      titstr = [dtitstr ' Data'] ;
    paramstruct = struct('titlestr',titstr, ...
                         'titlefontsize',24, ...
                         'xlabelstr',xstr, ...
                         'labelfontsize',15) ;
    sz1SM(data,paramstruct) ;


    if autop < 2 ;
      pauseSM
    end ;

  end ;

elseif ipart == 2 ;    %  then do normal mixture density examples

  %  Load Normal mixtures parameters from nnpar.mat
  %  !!!   Careful:  file nmpar.mat needs to be in the current directory  !!!
  %  Then all parameter matrices are in current directory
  load nmstuff/nmpar.mat
  
  %  Loop through distributions
  idiste = 16 ;
  for idist = 1:idiste ;
    eval(['parmat = nmpar' num2str(idist) ' ;']) ;
    eval(['titstr = nmtit' num2str(idist) ' ;']) ;
    disp(['    Working on #' num2str(idist) titstr]) ;

    for inobs = 2:4 ;
      nobs = 10^inobs ;
      disp(['      Working on n = ' num2str(nobs)]) ;

      %  Generate psuedo data and do family plot 
      data = nmdata(nobs,parmat) ;
      sz1SM(data) ;
      title(['#' num2str(idist) ' ' titstr ...
                  ', n = ' num2str(nobs) ', ' date]) ;

      if autop >= 1 ;
          orient landscape ;
        eval(['print -dps \matlab\steve\ps\egf' ...
                   num2str(ipart) num2str(idist) num2str(inobs) '.ps']) ;
      end ;

      if autop < 2 ;
        disp(['Any key to continue']) ;
        pause ;
      end ;

    end ;

  end ;

elseif ipart == 3 ;    %  then do real regression examples


  vidat = [1:9] ;
                 %  1 - Canadian Earning Data
                 %  2 - Canadian Lynx Data
                 %  3 - Cars Data
                 %  4 - Motorcycle Data
                 %  5 - NIcFoo Data
                 %  6 - Swamp Data
                 %  7 - Sunspot Data
                 %  8 - Fossil Data
                 %  9 - Share Yield Data


  for idat = vidat ;

    figure(1) ;
    clf ;

    if idat == 1 ;
      matfilestr = '\Research\GeneralData\canearn' ;
      datatran = [] ;
    elseif idat == 2 ;
      matfilestr = '\Research\GeneralData\lynx' ;
      datatran = ['data(:,2) = log10(data(:,2) + 1) ;' ...
                  'ystr = [''log10('' ystr '' + 1)''] ;'] ;
    elseif idat == 3 ;
      matfilestr = '\Research\GeneralData\cars' ;
      datatran = [] ;
    elseif idat == 4 ;
      matfilestr = '\Research\GeneralData\motodata' ;
      datatran = 'data = data(1:800,:) ;' ;
         %  First 800 are first trace
    elseif idat == 5 ;
      matfilestr = '\Research\GeneralData\nicfoo' ;
      datatran = [] ;
    elseif idat == 6 ;
      matfilestr = '\Research\GeneralData\phosphor' ;
      datatran = 'data(:,2) = log10(data(:,2)) ;' ;
    elseif idat == 7 ;
      matfilestr = '\Research\GeneralData\sunspots' ;
      datatran = ['data(:,2) = sqrt(data(:,2)) ;' ...
                  'ystr = [''sqrt('' ystr '')''] ;'] ;
    elseif idat == 8 ;
      matfilestr = '\Research\GeneralData\fossils' ;
      datatran = [] ;
    elseif idat == 9 ;
      matfilestr = '\Research\GeneralData\sharyiel' ;
      datatran = [] ;
    end ;


    load(matfilestr) ;
    
    
    if size(data,2) == 1 ;  %  then have only one column
                            %  so add dummy column for x's
      data = [(1:length(data))', data] ;
    end ;
    disp(['    Read in ' num2str(size(data,1)) ' data points']) ;


    if length(datatran) ~= 0 ;    %  Then do some data transformation
      eval(datatran) ;
    end ;

      titstr = [dtitstr ' Data'] ;
    paramstruct = struct('titlestr',titstr, ...
                         'titlefontsize',10, ...
                         'xlabelstr',xstr, ...
                         'ylabelstr',ystr, ...
                         'labelfontsize',8) ;
    sz1SM(data,paramstruct) ;



    if autop < 2 ;
      pauseSM ;
    end ;

  end ;

elseif ipart == 4 ;    %  then do NR Book regression examples

  iset = 0 ;    %  0 - Loop through all
                %  1 - Range of Noise Levels
                %  2 - Shifting Design Points
                %  3 - Heteroscedasticity
                %  4 - (Not ready yet)
                %  5 - 2 extreme data sets


  if iset == 1 | iset == 0 ;
    disp('Running example 1') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat1.dat','r') ;
      data = fscanf(fid,'%g %g %g %g %g %g %g %g',[8, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:6 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      subplot(2,3,ieg) ;
        sz1SM([data(:,1), data(:,ieg+2)]) ;
          title(['NR Book e.g. 1, ' date]) ;
    end ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) '1.ps']) ;
    end ;

    if autop < 2 ;
      disp(['Any key to continue']) ;
      pause ;
    end ;

  end ;


  if iset == 2 | iset == 0 ;
    disp('Running example 2') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat2.dat','r') ;
      data = fscanf(fid,'%g %g %g %g %g %g %g %g',[8, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:6 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      subplot(2,3,ieg) ;
        sz1SM([data(:,ieg), data(:,8)]) ;
          title(['NR Book e.g. 2, ' date]) ;
    end ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) '2.ps']) ;
    end ;

    if autop < 2 ;
      disp(['Any key to continue']) ;
      pause ;
    end ;

  end ;

  if iset == 3 | iset == 0 ;
    disp('Running example 3') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat3.dat','r') ;
      data = fscanf(fid,'%g %g %g %g %g %g %g',[7, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:5 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      subplot(2,3,ieg) ;
        sz1SM([data(:,1), data(:,ieg+2)]) ;
          title(['NR Book e.g. 3, ' date]) ;
    end ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) '3.ps']) ;
    end ;

    if autop < 2 ;
      disp(['Any key to continue']) ;
      pause ;
    end ;

  end ;

  if iset == 4 | iset == 0 ;
    disp('Example 4 was not finished') ;
  end ;

  if iset == 5 | iset == 0 ;
    disp('Running example 5') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat5a.dat','r') ;
      data = fscanf(fid,'%g %g %g',[3, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    sz1SM([data(:,1), data(:,3)]) ;
      title(['NR Book, e.g. 5a, ' date]) ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) '5a.ps']) ;
    end ;

    if autop < 2 ;
      disp(['Any key to continue']) ;
      pause ;
    end ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat5b.dat','r') ;
      data = fscanf(fid,'%g %g %g',[3, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    sz1SM([data(:,1), data(:,3)]) ;
      title(['NR Book, e.g. 5b, ' date]) ;
          hold on ;
            plot(data(:,1),data(:,3),'.w') ;
            plot(data(:,1),data(:,2),'--b') ;
          hold off ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) '5b.ps']) ;
    end ;

  end ;

elseif ipart == 5 ;    %  then do B-spline regression examples 

  clf
  for ifile = 1:9 ;
    disp(['        Working on part ' num2str(ifile)]) ;

    infstr = ['d:\gauss\steve\bspline\bs3' num2str(ifile) '.dat'] ;
    fid = fopen(infstr,'r') ;
      data = fscanf(fid,'%g %g %g',[3, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    sz1SM([data(:,1), data(:,3)]) ;
      title(['B-spline Setting ' num2str(ifile) ', ' date]) ;

    if autop >= 1 ;
        orient landscape ;
      eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) num2str(ifile) '.ps']) ;
    end ;

    if autop < 2 ;
      disp(['Any key to continue']) ;
      pause ;
    end ;

  end ;

elseif ipart == 6 ;    %  then do ER wavelet regression examples 

  clf ;
  nobs = 1024 ;
  xgrid = linspace(1/(2*nobs), 1 - (1/(2*nobs)), nobs)' ;

  for idist = 1:10 ;

    %  Following lines are modifications of Sudeshna Adak's Gen_sign.m
    if idist == 1 ;
      tarstr = 'Step' ;
      m = 0.2 + 0.6*(xgrid > 1/3 & xgrid <= 0.75); 
    elseif idist == 2 ;
      tarstr = 'Wave' ;
      m = 0.5 + (0.2.*cos(4*pi*xgrid)) + (0.1.*cos(24*pi*xgrid));
    elseif idist == 3 ;
      tarstr = 'Blip' ;
       m = (0.32 + (0.6.*xgrid) + ...
                      0.3*exp(-100*((xgrid-0.3).^2))).*(xgrid <= 0.8) + ...
           (-0.28 + (0.6.*xgrid) + ... 
                      0.3*exp(-100*((xgrid-1.3).^2))).*(xgrid > 0.8);
    elseif idist == 4 ;
      tarstr = 'Blocks' ;
      pos = [ .1 .13 .15 .23 .25 .40 .44 .65  .76 .78 .81];
      hgt = [4 (-5) 3 (-4) 5 (-4.2) 2.1 4.3  (-3.1) 2.1 (-4.2)];
      m = 2*ones(size(xgrid));
      for j=1:length(pos)
        m = m + (1 + sign(xgrid-pos(j))).*(hgt(j)/2) ;
      end
      m = (0.6/9.2)*m + 0.2;
    elseif idist == 5 ;
      tarstr = 'Bumps' ;
      pos = [ .1 .13 .15 .23 .25 .40 .44 .65  .76 .78 .81];
      hgt = [ 4  5   3   4  5  4.2 2.1 4.3  3.1 5.1 4.2];
      wth = [.005 .005 .006 .01 .01 .03 .01 .01  .005 .008 .005];
      m = zeros(size(xgrid));
      for j =1:length(pos)
        m = m + hgt(j)./( 1 + abs((xgrid - pos(j))./wth(j))).^4;
      end 
      m = ((0.6/5.3437952)*m) + 0.2;
    elseif idist == 6 ;
      tarstr = 'HeaviSine' ;
      m = 4.*sin(4*pi.*xgrid) - sign(xgrid - .3) - sign(.72 - xgrid) + 5;
      m = (0.6/9)*m + 0.2;
    elseif idist == 7 ;
      tarstr = 'Doppler' ;
      m = sqrt(xgrid.*(1-xgrid)).*sin((2*pi*1.05) ./(xgrid+.05)) + 0.5;
      m = 0.6*m + 0.2;
    elseif idist == 8 ;
      tarstr = 'Angles' ;
      m = ((2*xgrid + 0.5).*(xgrid <= 0.15)) + ...
        ((-12*(xgrid-0.15) + 0.8).*(xgrid > 0.15 & xgrid <= 0.2)) + ...
        0.2*(xgrid > 0.2 & xgrid <= 0.5) + ...
        ((6*(xgrid - 0.5) + 0.2).*(xgrid > 0.5 & xgrid <= 0.6)) + ...
        ((-10*(xgrid - 0.6) + 0.8).*(xgrid > 0.6 & xgrid <= 0.65)) + ...
        ((-0.5*(xgrid - 0.65) + 0.3).*(xgrid > 0.65 & xgrid <= 0.85)) + ...
        ((2*(xgrid - 0.85) + 0.2).*(xgrid > 0.85));
    elseif idist == 9 ;
      tarstr = 'Parabolas' ;
      pos = [0.1 0.2 0.3 0.35 0.37 0.41 0.43 0.5 0.7 0.9];
      hgt = [(-30) 60 (-30) 500 (-1000) 1000 (-500) 7.5 (-15) 7.5];
      m = zeros(size(xgrid));
      for j =1:length(pos)
        m = m + hgt(j).*((xgrid-pos(j)).^2).*(xgrid > pos(j));
      end
      m = m + 0.8;
    elseif idist == 10 ;
      tarstr = 'Time Shifted Sine' ;
      u = xgrid;
      for j =1:4,
        u = 0.5*(1-cos(pi*u));
      end
      m = 0.3*sin(3*pi*(u+xgrid)) + 0.5;
    end ;

    for isig = 1:2 ;

      if isig == 1 ;
        sigstr = 'Low Noise' ;
        sig = .02 ;
      elseif isig == 2 ;
        sigstr = 'High Noise' ;
        sig = .1 ;
      end ;

        randn('seed',92394873) ;
      ydat = m + sig * randn(nobs,1) ;
      data = [xgrid, ydat] ; 

      sz1SM(data) ;
          title([tarstr ', ' sigstr ', ' date]) ;

      if autop >= 1 ;
          orient landscape ;
        eval(['print -dps \matlab\steve\ps\egf' ...
                 num2str(ipart) num2str(idist) num2str(isig) '.ps']) ;
      end ;

      if autop < 2 ;
        disp(['Any key to continue']) ;
        pause ;
      end ;

    end ;

  end ; 

end ;

