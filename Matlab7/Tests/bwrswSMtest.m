disp('Running MATLAB script file bwrswSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION bwrswSM,
%    Ruppert Sheather Wand bandwidth (binned, for regression)

itest = 1.1 ;   %  1    (simple test)
               %  1.1  (simple test with linear data)
               %  2    (look at real data examples)            
               %  3    (NR book examples)
               %  4    (B-spline test examples)
               %  10   Do detailed output

% start new stuff here

format compact ;

figure(1) ;
clf ;


if itest == 1 ;

  indat = rand(500,1) .^ 2 ;
  indat = [indat, (indat - .4).^4 + .01 * randn(500,1)] ;

  qrswrot = bwrswSM(indat,-1) 
  subplot(2,2,1) ;
    nprSM(indat,qrswrot) ;
      title('RSW - ROT, quick defaults') ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.k') ;
      hold off ;

  arswrot = bwrswSM(indat,-1,[0,1,401],0) 
  subplot(2,2,2) ;
    nprSM(indat,arswrot) ;
      title('RSW - ROT, args') ;

  qrswdpi = bwrswSM(indat) 
  subplot(2,2,3) ;
    nprSM(indat,qrswdpi) ;
      title('RSW - DPI, quick defaults') ;
      hold on ;
        plot(indat(:,1),indat(:,2),'.k') ;
      hold off ;

  arswdpi = bwrswSM(indat,0,[0,1,401],0) 
  subplot(2,2,4) ;
    nprSM(indat,arswdpi) ;
      title('RSW - DPI, args') ;

  disp('See how close these are:') ;
  dif1 = abs(qrswrot - arswrot) 
  dif2 = abs(qrswdpi - arswdpi) 

  disp('See how close these are:') ;
  dif3 = abs(qrswrot - qrswdpi) 

  %  output stuff to file for emailing
  fid = fopen('bwrswbt.out','wt') ;

  titlstr1 = 'Output from the MATLAB Script bwrswSMt.m,   ' ;
cntbytes = fprintf(fid,'%1s\n\n\n',titlstr1) ;

  forstr = '   h_ROT = %12.10f\n\n' ;
cntbytes = fprintf(fid,forstr,arswrot) ;

  forstr = '   h_DPI = %12.10f\n\n' ;
cntbytes = fprintf(fid,forstr,arswdpi) ;

  hdrstr = 'For the raw data:   ' ;
cntbytes = fprintf(fid,'%1s\n',hdrstr) ;

  forstr = '  %12.10f  %12.10f\n' ;
cntbytes = fprintf(fid,forstr,indat') ;

  fclose('all') ;


elseif itest == 1.1 ;    %  Then do linear data example

  indat = 1:6 ;
  indat = [indat', indat'] ;

  hout = bwrswSM(indat,0)


elseif itest == 2 ;    %  Then do real indat examples

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



    hrot = bwrswSM(data,-1) ;
    hdpi = bwrswSM(data) ;
    nprSM(data,hdpi) ;
      title([dtitstr ' Data, h_{ROT} = ' num2str(hrot) ...
                                ', h_{DPI} = ' num2str(hdpi)]) ;
      xlabel(xstr) ;
      ylabel(ystr) ;
      hold on ;
        [npr, xgrid] = nprSM(data,hrot) ;
        plot(xgrid,npr,'--r') ;
        plot(data(:,1),data(:,2),'.k') ;
      hold off ;

    disp(['Any key to continue']) ;
    pause ;


  end ;

elseif itest == 3 ;    %  Then do NR book examples

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
    mest = [] ;
    for ieg = 1:6 ;
      hdpi = bwrswSM([data(:,1), data(:,ieg+2)]) ;
      [est, xgrid] = nprSM([data(:,1), data(:,ieg+2)],hdpi) ;
      subplot(2,3,ieg) ;
        plot(xgrid,est) ;
          title(['h_DPI = ' num2str(hdpi)]) ;
          hold on ;
            plot(data(:,1),data(:,ieg+2),'.w') ;
            plot(data(:,1),data(:,2),'--b') ;
          hold off ;
      mest = [mest, est] ;
    end ;
    disp('Any key to continue') ;
    pause ;

    clf ;
    plot(xgrid,mest) ;
      title('NR Book e.g. 1') ;

    disp('Any key to continue') ;
    pause ;
  end ;


  if iset == 2 | iset == 0 ;
    disp('Running example 2') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat2.dat','r') ;
      data = fscanf(fid,'%g %g %g %g %g %g %g %g',[8, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    mest = [] ;
    for ieg = 1:6 ;
      hdpi = bwrswSM([data(:,ieg), data(:,8)]) ;
      [est, xgrid] = nprSM([data(:,ieg), data(:,8)],hdpi) ;
      subplot(2,3,ieg) ;
        plot(xgrid,est) ;
          title(['h_DPI = ' num2str(hdpi)]) ;
          hold on ;
            plot(data(:,ieg),data(:,8),'.w') ;
            plot(data(:,ieg),data(:,7),'--b') ;
          hold off ;
      mest = [mest, est] ;
    end ;
    disp('Any key to continue') ;
    pause ;

    clf ;
    plot(xgrid,mest) ;
      title('NR Book e.g. 2') ;

    disp('Any key to continue') ;
    pause ;
  end ;

  if iset == 3 | iset == 0 ;
    disp('Running example 3') ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat3.dat','r') ;
      data = fscanf(fid,'%g %g %g %g %g %g %g',[7, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    clf ;
    mest = [] ;
    for ieg = 1:5 ;
      hdpi = bwrswSM([data(:,1), data(:,ieg+2)]) ;
      [est, xgrid] = nprSM([data(:,1), data(:,ieg+2)],hdpi) ;
      subplot(2,3,ieg) ;
        plot(xgrid,est) ;
          title(['h_DPI = ' num2str(hdpi)]) ;
          hold on ;
            plot(data(:,1),data(:,ieg+2),'.w') ;
            plot(data(:,1),data(:,2),'--b') ;
          hold off ;
      mest = [mest, est] ;
    end ;
    disp('Any key to continue') ;
    pause ;

    clf ;
    plot(xgrid,mest) ;
      title('NR Book e.g. 3') ;

    disp('Any key to continue') ;
    pause ;
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

    hdpi = bwrswSM([data(:,1), data(:,3)]) ;
    nprSM([data(:,1), data(:,3)],hdpi) ;
      title(['NR Book, e.g. 5a, h_DPI = ' num2str(hdpi)]) ;
          hold on ;
            plot(data(:,1),data(:,3),'.w') ;
            plot(data(:,1),data(:,2),'--b') ;
          hold off ;
    disp('Any key to continue') ;
    pause ;

    fid = fopen('d:\gauss\steve\nrbook\nrdat5b.dat','r') ;
      data = fscanf(fid,'%g %g %g',[3, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    hdpi = bwrswSM([data(:,1), data(:,3)]) ;
    nprSM([data(:,1), data(:,3)],hdpi) ;
      title(['NR Book, e.g. 5b, h_DPI = ' num2str(hdpi)]) ;
          hold on ;
            plot(data(:,1),data(:,3),'.w') ;
            plot(data(:,1),data(:,2),'--b') ;
          hold off ;

  end ;

elseif itest == 4 ;    %  Then do B-spline examples

  for ifile = 1:9 ;

    infstr = ['d:\gauss\steve\bspline\bs3' num2str(ifile) '.dat'] ;
    fid = fopen(infstr,'r') ;
      data = fscanf(fid,'%g %g %g',[3, inf]) ;
      data = data' ;
          %  since data rows are read in as columns
    fclose(fid) ;

    hdpi = bwrswSM([data(:,1), data(:,3)]) ;
    subplot(3,3,ifile) ;
      nprSM([data(:,1), data(:,3)],hdpi) ;
        title(['h_DPI = ' num2str(hdpi)]) ;
        hold on ;
          plot(data(:,1),data(:,3),'.w') ;
          plot(data(:,1),data(:,2),'--b') ;
        hold off ;
        axis([0,1,0,1]) ;
          %  Comment this last out to see all of data
  end ;


elseif itest == 10 ;     %  work with modified version for detailed output
                     %  using "cars" data

    dtitstr = 'Cars' ;
           %  Subset of famous cars data, found by Matt Wand as
           %  good example of need for monotonic smoothing
    infstr = 'cars.mat' ;
    frmtstr = '%g %g' ;
    insize = [2, inf] ;
    vicol = [1, 2] ;
    datatran = [] ;
    xstr = 'Displacement' ;
    ystr = 'Mileage' ;


  disp(['    Loading ' dtitstr ' Data']) ;
    infstr = ['\Research\GeneralData\' infstr] ;
load(infstr)
%    fid = fopen(infstr,'r') ;
%      data = fscanf(fid,frmtstr,insize) ;
%      data = data' ;
          %  since data rows are read in as columns
%      data = data(:,vicol) ;
      if size(data,2) == 1 ;  %  then have only one column
                              %  so add dummy column for x's
        data = [(1:length(data))', data] ;
      end ;
%    fclose(fid) ;
  disp(['    Read in ' num2str(size(data,1)) ' data points']) ;

  diary bwrswSMt.ou3 ;

  comment = 'Intermediate values for the RSW bandwidth, and the cars data:'

  hrsw = bwrswSM2(data) ;

  hrsw

  data

  diary off ;


end ;


