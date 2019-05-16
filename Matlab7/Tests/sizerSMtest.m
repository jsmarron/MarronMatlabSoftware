disp('Running MATLAB script file sizerSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION sizerSM,
%    Default version of SiZer,

clear all
close all

itest = 84 ;    %  1  real data tests (density estimation)
                %  2  normal mixture tests (density estimation)
                %  11 real data tests (regression)
                %  12 NR book examples (regression)
                %  13 B-spline test examples (regression)
                %  14 ER Wavelet Examples (regression)
                %  15 Censored - Hazard data tests
                %  16 Length biased data tests (theoretical)
                %  17 Length biased data tests (empirical)
                %  20 simple test with no signal
                %  21,22,...,84  parameter tests


format compact ;


%basefilestr = '\Documents and Settings\J S Marron\My Documents' ;
basefilestr = '\Users\marron\Documents' ;


if itest == 1 ;    %  then do real data tests

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
    matfilestr = [basefilestr matfilestr] ;


    load(matfilestr) ;

    disp(['  Working on ' dtitstr ' Data']) ;
    disp(dcomments) ;
    disp(['    Read in ' num2str(length(data)) ' data points']) ;



    paramstruct = struct('iout',2, ...
                         'imovie',0, ...
                         'famoltitle',[dtitstr ' Data'], ...
                         'xlabelstr',xstr, ...
                         'ylabelstr',ystr, ...
                         'simflag',4,...
                         'iscreenwrite',1) ;
 
    if length(vrange) == 2 ;
      paramstruct = setfield(paramstruct,'minx',vrange(1)) ;
      paramstruct = setfield(paramstruct,'maxx',vrange(2)) ;
    end ;
    
%    sizerSM(data,paramstruct) ;
%original version

    figure(1) ;
    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM

    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM


  end ;



elseif itest == 2 ;    %  then do normal mixture tests

  %  Load Normal mixtures parameters from nmpar.mat
%  load \Research\GeneralData\nmstuff\nmpar.mat
  load([basefilestr '\Research\GeneralData\nmstuff\nmpar.mat']) ;

  %  Loop through distributions
  idiste = 16 ;
  for idist = 1:idiste ;
    eval(['parmat = nmpar' num2str(idist) ' ;']) ;
    eval(['titstr = nmtit' num2str(idist) ' ;']) ;
    disp(['    Working on #' num2str(idist) titstr]) ;

    xgrid = linspace(-3,3,401)' ;
    f = nmfSM(xgrid,parmat) ;

    for inobs = 2:4 ;
      nobs = 10^inobs ;
      disp(['      Working on n = ' num2str(nobs)]) ;

      figure(1) ;
      clf ;

      %  Generate psuedo data and do SiZer
      data = nmdataSM(nobs,parmat) ;

      ptitstr = ['#' num2str(idist) ' ' titstr ', n = ' num2str(nobs)] ;
      paramstruct = struct('iout',2, ...
                           'famoltitle',ptitstr, ...
                           'imovie',0, ...
                           'minx',-3, ...
                           'maxx',3, ...
                           'iscreenwrite',1) ;
 
%      sizerSM(data,paramstruct) ;
%original version

      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
        hold on ;
          plot(xgrid,f,'r','LineWidth',2) ;
        hold off ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
        hold on ;
          plot(xgrid,f,'r','LineWidth',2) ;
        hold off ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;

    end ;

  end ;


elseif itest == 11 ;    %  then do real data regression

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
    matfilestr = [basefilestr matfilestr] ;


    load(matfilestr) ;

    disp(['  Working on ' dtitstr ' Data']) ;
    disp(dcomments) ;

    
    if size(data,2) == 1 ;  %  then have only one column
                            %  so add dummy column for x's
      data = [(1:length(data))', data] ;
    end ;
    disp(['    Read in ' num2str(size(data,1)) ' data points']) ;


    if length(datatran) ~= 0 ;    %  Then do some data transformation
      eval(datatran) ;
    end ;



    paramstruct = struct('title',dtitstr,...
                         'iout',2, ...
                         'imovie',0, ...
                         'famoltitle',[dtitstr ' Data'], ...
                         'xlabelstr',xstr, ...
                         'ylabelstr',ystr, ...
                         'ibigdot',0, ...
                         'iscreenwrite',1) ;

%    sizerSM(data,paramstruct) ;
%original version

    figure(1) ;
    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM

    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM ;


  end ;


elseif itest == 12 ;    %  then do NR Book regression examples

  iset = 0 ;    %  0 - Loop through all
                %  1 - Range of Noise Levels
                %  2 - Shifting Design Points
                %  3 - Heteroscedasticity
                %  4 - (Not ready yet)
                %  5 - 2 extreme data sets


  if iset == 1 | iset == 0 ;
    disp('Running example 1') ;

%    fid = fopen('\Research\GeneralData\nrbook\nrdat1.dat','r') ;
    fid = fopen([basefilestr '\Research\GeneralData\nrbook\nrdat1.dat'],'r') ;
      indata = fscanf(fid,'%g %g %g %g %g %g %g %g',[8, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:6 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      paramstruct = struct('iout',2, ...
                           'famoltitle',['NR Book e.g. 1, part ' num2str(ieg)], ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%      sizerSM([data(:,1), data(:,ieg+2)],paramstruct) ;
%
%        orient tall ;
%      eval(['print -dpsc \Research\GeneralData\nrbook\NRbookEg1p' ...
%                                       num2str(ieg) 'SiZer.ps']) ;
%original version

      data = [indata(:,1), indata(:,ieg+2)] ;
      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


    end ;

  end ;


  if iset == 2 | iset == 0 ;
    disp('Running example 2') ;

%    fid = fopen('\Research\GeneralData\nrbook\nrdat2.dat','r') ;
    fid = fopen([basefilestr '\Research\GeneralData\nrbook\nrdat2.dat'],'r') ;
      indata = fscanf(fid,'%g %g %g %g %g %g %g %g',[8, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:6 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      paramstruct = struct('iout',2, ...
                           'famoltitle',['NR Book e.g. 2, part ' num2str(ieg)], ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%      sizerSM([data(:,ieg), data(:,8)],paramstruct) ;
%
%        orient tall ;
%      eval(['print -dpsc \Research\GeneralData\nrbook\NRbookEg2p' ...
%                                       num2str(ieg) 'SiZer.ps']) ;
%original version

      data = [indata(:,ieg), indata(:,8)] ;
      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


    end ;

  end ;

  if iset == 3 | iset == 0 ;
    disp('Running example 3') ;

%    fid = fopen('\Research\GeneralData\nrbook\nrdat3.dat','r') ;
    fid = fopen([basefilestr '\Research\GeneralData\nrbook\nrdat3.dat'],'r') ;
      indata = fscanf(fid,'%g %g %g %g %g %g %g',[7, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    for ieg = 1:5 ;
      disp(['        Working on part ' num2str(ieg)]) ;
      paramstruct = struct('iout',2, ...
                           'famoltitle',['NR Book e.g. 3, part ' num2str(ieg)], ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%      sizerSM([data(:,1), data(:,ieg+2)],paramstruct) ;
%
%        orient tall ;
%      eval(['print -dpsc \Research\GeneralData\nrbook\NRbookEg3p' ...
%                                       num2str(ieg) 'SiZer.ps']) ;
%original version

      data = [indata(:,1), indata(:,ieg+2)] ;
      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


    end ;

  end ;

  if iset == 4 | iset == 0 ;
    disp('Example 4 was not finished') ;
  end ;

  if iset == 5 | iset == 0 ;
    disp('Running example 5') ;

%    fid = fopen('\Research\GeneralData\nrbook\nrdat5a.dat','r') ;
    fid = fopen([basefilestr '\Research\GeneralData\nrbook\nrdat5a.dat'],'r') ;
      indata = fscanf(fid,'%g %g %g',[3, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
      paramstruct = struct('iout',2, ...
                           'famoltitle','NR Book e.g. 5a', ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%    sizerSM([data(:,1), data(:,3)],paramstruct) ;
%      title('NR Book, e.g. 5a') ;
%      
%
%        orient tall ;
%      eval(['print -dpsc \Research\GeneralData\nrbook\NRbookEg5aSiZer.ps']) ;


      data=[indata(:,1), indata(:,3)] ;
      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


%    fid = fopen('\Research\GeneralData\nrbook\nrdat5b.dat','r') ;
    fid = fopen([basefilestr '\Research\GeneralData\nrbook\nrdat5b.dat'],'r') ;
      indata = fscanf(fid,'%g %g %g',[3, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
      paramstruct = struct('iout',2, ...
                           'famoltitle','NR Book e.g. 5b', ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%    sizerSM([data(:,1), data(:,3)],paramstruct) ;
%      title('NR Book, e.g. 5b') ;
%        orient tall ;
%      eval(['print -dpsc \Research\GeneralData\nrbook\NRbookEg5bSiZer.ps']) ;

      data=[indata(:,1), indata(:,3)]
      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


  end ;

elseif itest == 13 ;    %  then do B-spline regression examples 

  clf
  for ifile = 1:9 ;
    disp(['        Working on part ' num2str(ifile)]) ;

    infstr = ['\Research\GeneralData\bspline\bs3' num2str(ifile) '.dat'] ;
    infstr = [basefilestr infstr] ;
    fid = fopen(infstr,'r') ;
      indata = fscanf(fid,'%g %g %g',[3, inf]) ;
      indata = indata' ;
          %  since data rows are read in as columns
    fclose(fid) ;

      paramstruct = struct('iout',2, ...
                           'famoltitle','B-spline Targets', ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%    sizerSM([data(:,1), data(:,3)],paramstruct) ;
%
%    disp('Any key to continue') ;
%    pause ;
%
%      orient tall ;
%    eval(['print -dpsc \Research\GeneralData\bspline\bslineEG' ...
%                               num2str(ifile) 'SiZer.ps']) ;


    data=[indata(:,1), indata(:,3)]
    figure(1) ;
    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',6) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM

    clf ;
    subplot(4,1,1) ;
      paramstruct = setfield(paramstruct,'iout',4) ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,2) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',1) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,3) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',2) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
      sizerSM(data,paramstruct) ;
    subplot(4,1,4) ;
      paramstruct = setfield(paramstruct,'iout',7) ;
      paramstruct = setfield(paramstruct,'simflag',4) ;
      paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
      sizerSM(data,paramstruct) ;
    pauseSM ;


  end ;

elseif itest == 14 ;    %  then do ER wavelet regression examples 

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


%      figure(1) ;
      paramstruct = struct('famoltitle',[tarstr ', ' sigstr],...
                           'iout',2, ...
                           'imovie',0, ...
                           'iscreenwrite',1) ;
%      sizerSM(data,paramstruct) ;
%
%      subplot(3,1,1) ;
%      hold on ;
%        plot(xgrid,m,'r-') ;
%      hold off ;


      figure(1) ;
      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
        hold on ;
          plot(xgrid,m,'r-') ;
        hold off ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
        hold on ;
          plot(xgrid,m,'r-') ;
        hold off ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM ;


    end ;

  end ; 



elseif itest == 15 ;    %  then do censored - hazard type tests

  n = 1000 ;
  rand('seed',74520938) ;
  randn('seed',75209573) ;

  for idist = 1:4 ;

    if idist == 1 ;
      dstr = 'Uniform [0,1]' ;

      vt = rand(n,1) ;
      vc = rand(n,1) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 2 ;
      dstr = 'Gaussian(0,1)' ;

      vt = randn(n,1) ;
      vc = randn(n,1) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 3 ;
      dstr = 'Exponential(1)' ;

      vt = -log(rand(n,1)) ;
      vc = -log(rand(n,1)) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 4 ;
      dstr = 'Bathtub' ;

      vt = (1 - rand(n,1).^2).^2 ;
      vc = (1 - rand(n,1).^2).^2 ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    end ;    %  of idist if-block


    for icensor = 0:1 ;
%    for icensor = 1:1 ;

      if icensor == 0 ;
        cdstr = dstr ;
        data = vt ;
      else ;
        cdstr = [dstr ', 50% Cen''d'] ;
        data = [vdata, vdel] ;
      end ;

      for ihazard = 0:1 ;

        if ihazard == 0 ;
          hcdstr = [cdstr ', Den. Est.'] ;
        else ;
          hcdstr = [cdstr ', Haz. Est.'] ;
        end ;

        figure(1) ;
        clf ;

        paramstruct = struct('iout',1,...
                             'famoltitle',hcdstr,...
                             'imovie',0,...
                             'iscreenwrite',1,...
                             'ibigdot',0,...
                             'icensor',icensor,...
                             'ihazard',ihazard...
                                              ) ;
%        paramstruct = struct('iout',1,...
%                             'famoltitle',hcdstr,...
%                             'imovie',0,...
%                             'nfh',1,...
%                             'fhmin',0.01,...
%                             'fhmax',0.01,...
%                             'nsh',1,...
%                             'shmin',0.01,...
%                             'shmax',0.01,...
%                             'iscreenwrite',1,...
%                             'icensor',icensor,...
%                             'ihazard',ihazard...
%                                              ) ;

        sizerSM(data,paramstruct) ;

        pauseSM ;

      end ;    %  of ihazard loop

    end ;    %  of icensor loop


  end ;    %  of idist loop



elseif itest == 16 ;    %  then do length biased type tests  (theoretical)

  n = 1000 ;
  rand('seed',74520938) ;
  randn('seed',75209573) ;

  for idist = 1:2 ;

    if idist == 1 ;
      dstr = 'Length Biased Uniform [0,1]' ;

      vt = sqrt(rand(n,1)) ;
      vc = rand(n,1) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 2 ;
      dstr = 'Exponential(1)' ;

      vt = -log(rand(n,2)) ;
      vt = sum(vt,2) ;
      vc = -log(rand(n,1)) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    end ;    %  of idist if-block


    for icensor = 0:1 ;
%    for icensor = 1:1 ;

      if icensor == 0 ;
        cdstr = dstr ;
        data = vt ;
      else ;
        cdstr = [dstr ', 50% Cen''d'] ;
        data = [vdata, vdel] ;
      end ;

      for ihazard = 0:1 ;

        if ihazard == 0 ;
          hcdstr = [cdstr ', Den. Est.'] ;
        else ;
          hcdstr = [cdstr ', Haz. Est.'] ;
        end ;

        figure(1) ;
        clf ;

%        paramstruct = struct('iout',1,...
%                             'famoltitle',hcdstr,...
%                             'imovie',0,...
%                             'iscreenwrite',1,...
%                             'icensor',icensor,...
%                             'ihazard',ihazard,...
%                             'ilengthb',1 ...
%                                              ) ;
        paramstruct = struct('iout',1,...
                             'famoltitle',hcdstr,...
                             'imovie',0,...
                             'nfh',1,...
                             'fhmin',0.01,...
                             'fhmax',0.01,...
                             'nsh',1,...
                             'shmin',0.01,...
                             'shmax',0.01,...
                             'iscreenwrite',1,...
                             'icensor',icensor,...
                             'ihazard',ihazard,...
                             'ilengthb',1 ...
                                              ) ;

        sizerSM(data,paramstruct) ;

        pauseSM ;

      end ;    %  of ihazard loop

    end ;    %  of icensor loop


  end ;    %  of idist loop



elseif itest == 17 ;    %  then do length biased type tests (empirical)

  n = 1000 ;
  rand('seed',74520938) ;
  randn('seed',75209573) ;

  for idist = 1:4 ;

    if idist == 1 ;
      dstr = 'Uniform [0,1] (treated as length biased)' ;

      vt = rand(n,1) ;
      vc = rand(n,1) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 2 ;
      dstr = 'Gaussian(0,1) (treated as length biased)' ;

      vt = randn(n,1) ;
      vc = randn(n,1) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 3 ;
      dstr = 'Exponential(1) (treated as length biased)' ;

      vt = -log(rand(n,1)) ;
      vc = -log(rand(n,1)) ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    elseif idist == 4 ;
      dstr = 'Bathtub (treated as length biased)' ;

      vt = (1 - rand(n,1).^2).^2 ;
      vc = (1 - rand(n,1).^2).^2 ;
      vdata = min(vt,vc) ;
      vdel = vdata == vt ;

    end ;    %  of idist if-block


    for icensor = 0:1 ;
%    for icensor = 1:1 ;

      if icensor == 0 ;
        cdstr = dstr ;
        data = vt ;
      else ;
        cdstr = [dstr ', 50% Cen''d'] ;
        data = [vdata, vdel] ;
      end ;

      for ihazard = 0:1 ;

        if ihazard == 0 ;
          hcdstr = [cdstr ', Den. Est.'] ;
        else ;
          hcdstr = [cdstr ', Haz. Est.'] ;
        end ;

        figure(1) ;
        clf ;

        paramstruct = struct('iout',1,...
                             'famoltitle',hcdstr,...
                             'imovie',0,...
                             'iscreenwrite',1,...
                             'icensor',icensor,...
                             'ihazard',ihazard,...
                             'ilengthb',1 ...
                                              ) ;

min(data)
        sizerSM(data,paramstruct) ;

        pauseSM ;

      end ;    %  of ihazard loop

    end ;    %  of icensor loop


  end ;    %  of idist loop



elseif itest == 20 ;    %  then do simple test with no signal data

  n = 1000 ;
%  randn('seed',97571948) ;

  for i = 1:20 ;

    data = [(1:n)',randn(n,1)] ;

  %  sizerSM(data) ;

      figure(1) ;
      clf ;
      paramstruct = struct('famoltitle','No Signal Regression Data',...
                           'imovie',0,...
                           'iscreenwrite',1) ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'sizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',6) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'sizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

      clf ;
      subplot(4,1,1) ;
        paramstruct = setfield(paramstruct,'iout',4) ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,2) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',1) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Original SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,3) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',2) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Row-wise SiZer') ;
        sizerSM(data,paramstruct) ;
      subplot(4,1,4) ;
        paramstruct = setfield(paramstruct,'iout',7) ;
        paramstruct = setfield(paramstruct,'simflag',4) ;
        paramstruct = setfield(paramstruct,'curvsizertitle','Current Global SiZer') ;
        sizerSM(data,paramstruct) ;
      pauseSM

  end ;


elseif itest >= 21 ;    %  then do parameter tests


  matfilestr = '\Research\GeneralData\incomes' ;
  matfilestr = [basefilestr matfilestr] ;

  load(matfilestr) ;



  if itest == 21 ;    %  Try dummy paramstruct
    paramstruct = 3 ;
    sizerSM(data,paramstruct) ;

  elseif itest == 22 ;
    paramstruct = struct('iscreenwrite',1 ...
                                          ) ;
    sizerSM(data,paramstruct) ;

  elseif itest == 23 ;
    paramstruct = struct('iscreenwrite',1,...
                         'iout',1 ...
                                          ) ;
    sizerSM(data,paramstruct) ;

  elseif itest == 24 ;  
    paramstruct = struct('iscreenwrite',1,...
                         'iout',2 ...
                                          ) ;
    sizerSM(data,paramstruct) ;

  elseif itest == 25 ;  
    paramstruct = struct('iscreenwrite',1,...
                         'iout',3 ...
                                          ) ;
    sizerSM(data,paramstruct) ;

  elseif itest == 26 ;
    figure(2) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 27 ;
    figure(3) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',5 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 28 ;
    figure(4) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',6 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 29 ;
    figure(5) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',7 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 30 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'icolor',0 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 31 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'savestr','test1' ...
                                          ) ;
    sizerSM(data,paramstruct)
    dir ;

  elseif itest == 32 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'savestr','\TEMP\test2' ...
                                          ) ;
    sizerSM(data,paramstruct)
    dir \TEMP\*.ps ;

  elseif itest == 33 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ...
                         'ndataoverlay',0 ...
                                          ) ;
    clf ;
    sizerSM(data,paramstruct)

  elseif itest == 34 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ...
                         'ndataoverlay',2 ...
                                          ) ;
    clf ;
    sizerSM(data,paramstruct)

  elseif itest == 35 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ...
                         'ndataoverlay',50 ...
                                          ) ;
    clf ;
    sizerSM(data,paramstruct)

  elseif itest == 36 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'nbin',41 ...
                                          ) ;
    clf ;
    sizerSM(data,paramstruct)

  elseif itest == 37 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'minx',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 38 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'maxx',2 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 39 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'maxx',-1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 40 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'minx',2, ...
                         'maxx',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 41 ;
    figure(2) ;
    clf ;

    subplot(2,1,1) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ...
                         'maxx',1.5, ...
                         'bpar',0 ...
                                          ) ;
    sizerSM(data,paramstruct)

    subplot(2,1,2) ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ...
                         'maxx',1.5, ...
                         'bpar',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 42 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',3, ...
                         'maxx',3, ...
                         'hhighlight',0.01, ....
                         'bpar',1 ...
                                          ) ;
    %  try hhighlight = 0, -1, 10^(-1.5), 10^(-0.2), 10, 0.01
    %  paramstruct = rmfield(paramstruct,'hhighlight') ;
    sizerSM(data,paramstruct)

  elseif itest == 43 ;
    paramstruct = struct('iscreenwrite',1,...
                         'maxx',3, ...
                         'bpar',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 44 ;
    paramstruct = struct('iscreenwrite',1,...
                         'maxx',3, ...
                         'iout',3, ...
                         'viewangle',[195,30], ...
                         'bpar',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 45 ;
    paramstruct = struct('iscreenwrite',1,...
                         'maxx',3, ...
                         'bpar',1, ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 46 ;
    paramstruct = struct('iscreenwrite',1,...
                         'maxx',3, ...
                         'bpar',1, ...
                         'iout',3, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'famoltitle','pic1', ...
                         'famsurtitle','pic2', ...
                         'sizertitle','pic3', ...
                         'curvsizertitle','pic4', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 47 ;
    paramstruct = struct('iscreenwrite',1,...
                         'savestr','sizerSMttest', ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)
    disp(['Now check file sizerSMtest.avi']) ;

  elseif itest == 48 ;
    paramstruct = struct('iscreenwrite',1,...
                         'savestr','sizerSMtest', ...
                         'imovie',0, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)
    disp(['Now check file sizerSMtest.ps']) ;

  elseif itest == 49 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',21, ...
                         'fhmin',.01, ...
                         'fhmax',1, ...
                         'nsh',81, ...
                         'shmin',.001, ...
                         'shmax',100, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 50 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',21, ...
                         'fhmin',.01, ...
                         'fhmax',1, ...
                         'nsh',81, ...
                         'shmin',.001, ...
                         'shmax',100, ...
                         'titlefontsize',24,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 51 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',21, ...
                         'fhmin',.01, ...
                         'fhmax',1, ...
                         'nsh',81, ...
                         'shmin',.001, ...
                         'shmax',100, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 52 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 53 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18,...
                         'nrepeat',1 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 54 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',1, ...
                         'fhmin',0.08, ...
                         'fhmax',0.08, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 55 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',1, ...
                         'fhmin',0.08, ...
                         'fhmax',1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 56 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nfh',10, ...
                         'fhmin',0.08, ...
                         'fhmax',0.08, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 57 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nsh',1, ...
                         'shmin',0.1, ...
                         'shmax',0.1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 58 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nsh',1, ...
                         'shmin',0.1, ...
                         'shmax',1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 59 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'nsh',10, ...
                         'shmin',0.1, ...
                         'shmax',0.1, ...
                         'titlefontsize',18,...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density', ...
                         'labelfontsize',18 ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 60 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',1, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 61 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',1, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',0.5, ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 62 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',1, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'moviecstr','None', ...
                         'famoltitle','No compression', ...
                         'savestr','sizerSMtestNoComp', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
%                       'None'   (no compression)
%                            looks good but big file
    sizerSM(data,paramstruct)

  elseif itest == 63 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',1, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'moviecstr','Cinepak', ...
                         'famoltitle','Cinepak compression', ...
                         'savestr','sizerSMtestCinepak', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
%                       'Cinepak'   (default)
%                            looks good, small file
    sizerSM(data,paramstruct)

  elseif itest == 64 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',1, ...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'moviecstr','Indeo5', ...
                         'famoltitle','Indeo5 compression', ...
                         'savestr','sizerSMtestIndeo5', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
%                       'Indeo5'
%                            gives warning about "frame size"
%                            good color, but blurry, small file
    sizerSM(data,paramstruct)

  elseif itest == 65 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'minx',0.25, ...
                         'maxx',2.5, ...
                         'bpar',1, ...
                         'ibdryadj',0, ...
                         'famoltitle','No B''dry Adjustment', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 66 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'minx',0.25, ...
                         'maxx',2.5, ...
                         'bpar',1, ...
                         'ibdryadj',1, ...
                         'famoltitle','Mirror Image B''dry Adjustment', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 67 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',2, ... 
                         'minx',0.25, ...
                         'maxx',2.5, ...
                         'bpar',1, ...
                         'ibdryadj',2, ...
                         'famoltitle','Circular Design B''dry Adjustment', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 68 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',0.08, ...
                         'famoltitle','Manually chosen h = 0.08', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 69 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',0.001, ...
                         'famoltitle','Manually chosen h = 0.001', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 70 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',10, ...
                         'famoltitle','Manually chosen h = 10', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 71 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',6, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',0.08, ...
                         'sizertitle','Manually chosen h = 0.08', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 72 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',7, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',0.08, ...
                         'curvsizertitle','Manually chosen h = 0.08', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 73 ;
    paramstruct = struct('iscreenwrite',1,...
                         'imovie',0, ...
                         'iout',4, ... 
                         'minx',0, ...
                         'maxx',3, ...
                         'bpar',1, ...
                         'hhighlight',0.08, ...
                         'ibigdot',1, ...
                         'famoltitle','Test ibigdot, density estimation', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 74 ;
     paramstruct = struct('iscreenwrite',1,...
                         'simflag', 0,...
                         'imovie',0,...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'famoltitle','Test simflag = 0', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 75 ;
     paramstruct = struct('iscreenwrite',1,...
                         'simflag', 1,...
                         'imovie',0,...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'famoltitle','Test simflag = 1', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)
    
  elseif itest == 76 ;
     paramstruct = struct('iscreenwrite',1,...
                         'simflag',2,...
                         'imovie',0,...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'famoltitle','Test simflag = 2', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 77 ;
     paramstruct = struct('iscreenwrite',1,...
                         'simflag',3,...
                         'imovie',0,...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'famoltitle','Test simflag = 3', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 78 ;
     paramstruct = struct('iscreenwrite',1,...
                         'simflag',4,...
                         'imovie',0,...
                         'iout',3, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'moviefps',15, ...
                         'famoltitle','Test simflag = 4', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 79 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'famoltitle','Test default data overlay', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 80 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'ndatovlay',100, ...
                         'famoltitle','Only overlay 100 points', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 81 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'ndatovlay',2, ...
                         'famoltitle','Overlay all data points', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 82 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'ndatovlay',2, ...
                         'idatovlay',0, ...
                         'datovlaymax',0.9, ...
                         'datovlaymin',0.2, ...
                         'famoltitle','Turn Off Data Overlay', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 83 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'ndatovlay',2, ...
                         'idatovlay',1, ...
                         'dolcolor',1, ...
                         'datovlaymax',0.9, ...
                         'datovlaymin',0.2, ...
                         'famoltitle','Matlab Color Overlay', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)

  elseif itest == 84 ;
     paramstruct = struct('iscreenwrite',1,...
                         'imovie',0,...
                         'iout',1, ... 
                         'maxx',3, ...
                         'bpar',1, ...
                         'ndatovlay',2, ...
                         'idatovlay',1, ...
                         'dolcolor',2, ...
                         'datovlaymax',0.9, ...
                         'datovlaymin',0.2, ...
                         'famoltitle','Rainbow Color Overlay', ...
                         'xlabelstr','incomes', ...
                         'ylabelstr','density' ...
                                          ) ;
    sizerSM(data,paramstruct)        

  end ;



end ;


