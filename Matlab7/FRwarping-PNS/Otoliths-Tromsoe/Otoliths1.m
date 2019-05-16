disp('Running MATLAB script file Otoliths1.m') ;
%
%    Explores Fisher Rao registration of Alf Harbitz's Otolith Data
%    Base on curves from the GUI by Kristian Hindberg
%

%vidata = [1] ;    %  Simple version for testing
vidata = [1 2 3 4 5] ;    %  input file numbers


    
ipart = 3 ;     %  1 - Input data curves, and view
                %  2 - standard PCA of input curves
                %  3 - Plot curves after Fisher Rao Registration
                %


for idata = vidata ;

  infilenum = idata ;
  titfilestr = ['File ' num2str(infilenum)] ;
  outfilestr = ['File' num2str(infilenum)] ;

  %  Read in this data set
  %
  if infilenum == 1 ;
    infilestr = 'Data_out_07-Apr-2014_Time_2011-File1' ;
  elseif infilenum == 2 ;
    infilestr = 'Data_out_07-Apr-2014_Time_2017-File2' ;
  elseif infilenum == 3 ;
    infilestr = 'Data_out_07-Apr-2014_Time_2019-File3' ;
  elseif infilenum == 4 ;
    infilestr = 'Data_out_07-Apr-2014_Time_2021-File4' ;
  elseif infilenum == 5 ;
    infilestr = 'Data_out_07-Apr-2014_Time_2022-File5' ;
  end ;

  load(infilestr) ;
      %  loads:
      %      More_data    (struct)
      %      data_out     (d x n matrix)
      %      range_num    (1 x n vector)

  mcurves = data_out ;
  d = size(mcurves,1) ;
  n = size(mcurves,2) ;

  flagnan = isnan(mcurves) ;
  disp(['Number of NaNs in data = ' num2str(sum(sum(flagnan)))]) ;

  flag0 = (mcurves == 0) ;
  disp(['Number of 0s in data = ' num2str(sum(sum(flag0)))]) ;


  %  Set Common Graphics Stuff
  %
  figure(1) ;
  clf ;

  %  set up color map stuff
  %
  %  1st:    R  1      G  0 - 1    B  0
  %  2nd:    R  1 - 0  G  1        B  0
  %  3rd:    R  0      G  1        B  0 - 1
  %  4th:    R  0      G  1 - 0    B  1
  %  5th:    R  0 - 1  G  0        B  1

  nfifth = ceil((n - 1) / 5) ;
  del = 1 / nfifth ;
  vwt = (0:del:1)' ;
  colmap = [flipud(vwt), zeros(nfifth+1,1), ones(nfifth+1,1)] ;
  colmap = colmap(1:size(colmap,1)-1,:) ;
        %  cutoff last row to avoid having it twice
  colmap = [colmap; ...
            [zeros(nfifth+1,1), vwt, ones(nfifth+1,1)]] ;
  colmap = colmap(1:size(colmap,1)-1,:) ;
        %  cutoff last row to avoid having it twice
  colmap = [colmap; ...
            [zeros(nfifth+1,1), ones(nfifth+1,1), flipud(vwt)]] ;
  colmap = colmap(1:size(colmap,1)-1,:) ;
        %  cutoff last row to avoid having it twice
  colmap = [colmap; ...
            [vwt, ones(nfifth+1,1), zeros(nfifth+1,1)]] ;
  colmap = colmap(1:size(colmap,1)-1,:) ;
        %  cutoff last row to avoid having it twice
  colmap = [colmap; ...
            [ones(nfifth+1,1)], flipud(vwt), zeros(nfifth+1,1)] ;

        %  note: put this together upside down



  if ipart == 1 ;    %  Input data curves, and view

    plot((1:d)',mcurves(:,1),'-','Color',colmap(1,:)) ;
    hold on ;
      for ip = 2:n ;
        plot((1:d)',mcurves(:,ip),'-','Color',colmap(ip,:)) ;
      end ;
    hold off ;
    title(['Input Profile Curves, Rainbow Colors, ' titfilestr]) ;
    orient landscape ;
    print('-dpsc2',['InputProfiles' outfilestr '.ps'])

    

  elseif ipart == 2 ;    %  Standard PCA of input curves

    titlecellstr = {{['HDLSS Toy Data, part ' num2str(ipart)] 'N_d(0,1) data - Xbar' ...
                      'Maximum Outlier Projections' ['n = ' num2str(n) ', d = ' num2str(d)]}} ;
    savestr = ['EGhdlssToyPart' num2str(ipart) 'RandDataMaxOUtview'] ;
    paramstruct = struct('npcadiradd',0, ...
                         'titlecellstr',titlecellstr, ...
                         'savestr',savestr, ...
                         'iscreenwrite',1) ;
    scatplotSM(mdata,mdir,paramstruct) ;


  elseif ipart == 3 ;    %  Plot curves after Fisher Rao Registration

    disp(' ') ;
    disp('Make Sure Derek''s Software is in the Matlab Path for this Part') ;
    disp(' ') ;

    t = (1:d)' ;
    [fn,qn,q0,fmean,mqn,gam,psi,stats] = time_warping(mcurves,t) ;
    mregcurves = fn ;
    mwarps = gam ;
    kmean = fmean ;

    figure(7) ;
    clf ;
    plot((1:d)',mregcurves(:,1),'-','Color',colmap(1,:)) ;
    hold on ;
      for ip = 2:n ;
        plot((1:d)',mregcurves(:,ip),'-','Color',colmap(ip,:)) ;
      end ;
    hold off ;
    title(['Registered Profile Curves, Rainbow Colors, ' titfilestr]) ;
    orient landscape ;
    print('-dpsc2',['RegProfiles' outfilestr '.ps'])

    figure(8) ;
    clf ;
    plot((1:d)',kmean,'k-','LineWidth',4) ;
    [temp,icut] = max(kmean < 20) ;
        %  index of first time kmean is less than 20
    hold on ;
      vax = axis ;
      plot([icut; icut],[vax(3); vax(4)],'g-') ;
    hold off ;
    title(['Karcher Mean Curve, ' titfilestr]) ;
    orient landscape ;
    print('-dpsc2',['Karcher Mean' outfilestr '.ps'])

    figure(9) ;
    clf ;
    plot((1:icut)',kmean(1:icut),'k-','LineWidth',4) ;
    title(['Zoomed in Karcher Mean Curve, ' titfilestr]) ;
    orient landscape ;
    print('-dpsc2',['ZoomedKarcherMean' outfilestr '.ps'])

    figure(10) ;
    clf ;
    plot(linspace(0,1,d)',mwarps(:,1),'-','Color',colmap(1,:)) ;
    hold on ;
      for ip = 2:n ;
        plot(linspace(0,1,d)',mwarps(:,ip),'-','Color',colmap(ip,:)) ;
      end ;
    hold off ;
    title(['Warping Functions, Rainbow Colors, ' titfilestr]) ;
    orient landscape ;
    print('-dpsc2',['Warps' outfilestr '.ps'])


    %   Output Registration Results
    %
    outfilestr = ['FRRegResults' outfilestr] ;
    save(outfilestr,'mregcurves','mwarps','kmean') ;
        %  Save:
        %    mregcurves - matrix of registered curves
        %    mwarps     - matrix of warps
        %    kmean      - vector of Karcher mean


  end ;


end ;





