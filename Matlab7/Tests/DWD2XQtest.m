disp('Running MATLAB script file DWD2XQtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION DWD2XQ,
%    2nd generation of DWD

itest = 14 ;     %  1,2,...,9
                 %  11, 12, 13, 14      tests against earlier versions
                 %  21, 22, 23, 24, 25
                 %  101, 102    simple error checks

disp(['    Running test ' num2str(itest)]) ;

figure(1) ;
clf ;

randn('state',348530487) ;


if itest < 10 ;    %  Simple tests

  datp = [(randn(1,200) + 6); 3 * randn(1,200)] ;
  datn = [(randn(1,50) - 2); 3 * randn(1,50)] ;

  if itest == 1 ; 

    titstr = '1st Check with all defaults' ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn) ;

  elseif itest == 2 ;  

    titstr = 'Manually set weight = 2' ;
    weight = 2 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 3 ;  

    titstr = 'Manually set weight = 1' ;
    weight = 1 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 4 ;  

    titstr = 'Manually set weight = [0.25,0.75]' ;
    weight = [0.25,0.75] ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 5 ;  

    titstr = 'Manually set weight = [0.75,0.25]' ;
    weight = [0.75,0.25] ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 6 ;  

    disp('Manually set weight = [1 2 3] (wrong size vector), to generate error') ;
    titstr = 'Manually set weight = [1 2 3], to generate error' ;
    weight = [1 2 3] ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 7 ;  

    disp('Manually set weight = [1 -1] (not allowable numbers), to generate error') ;
    titstr = 'Manually set weight = [1 -1], to generate error' ;
    weight = [1 -1] ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;

  elseif itest == 8 ;  

    titstr = 'Check explicitly entered empty testdata' ;
    weight = 2 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,[]) ;

  elseif itest == 9 ;  

    DWDpar = 10^(-1) ;
    titstr = ['Check manually input DWDpar = ' num2str(DWDpar)] ;
    weight = 2 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,[],DWDpar) ;

  end ;


  if isempty(dirvec) ;
    disp('dirvec is empty, so no plot is made') ;
  else ;
    plot(datp(1,:)',datp(2,:)','r+') ;
    title(titstr) ;
    hold on ;
      plot(datn(1,:)',datn(2,:)','bo') ;
      plot([0,dirvec(1)],[0,dirvec(2)],'k-','LineWidth',10) ;
      plot([-beta * dirvec(1) - 10 * dirvec(2); ...
            -beta * dirvec(1) + 10 * dirvec(2)], ...
           [-beta * dirvec(2) + 10 * dirvec(1); ...
            -beta * dirvec(2) - 10 * dirvec(1)],'k--') ;
    hold off ;
  end ;

  disp('Check dr is empty') ;
  dr


elseif itest == 11 ;

  disp('No Test Data Comparison with old DWD1SM') ;

  datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
  datn = [(randn(1,50) - 2); 3 * randn(99,50)] ;

  icolorbase = [] ;
  markerstrbase = [] ;
  for i = 1:size(datp,2) ;
    markerstrbase = strvcat(markerstrbase, '+');
    icolorbase = [icolorbase; [1 0 0]] ;
  end ;
  for i = 1:size(datn,2) ;

    markerstrbase = strvcat(markerstrbase, 'o');
    icolorbase = [icolorbase; [0 0 1]] ;
  end ;


  figure(1) ;
  clf ;
  titstr = 'd = 100, Earlier DWD1, no test data' ;
  dirvec = DWD1SM(datp,datn) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class') ;
  hold off ;


  figure(2) ;
  clf ;
  titstr = 'd = 100, Check weight = 1, no test data' ;
  weight = 1 ;
  [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class') ;
  hold off ;


  figure(3) ;
  clf ;
  titstr = 'd = 100, Weight = 2, no test data' ;
  weight = 2 ;
  [dirvec,beta,dr] = DWD2XQ(datp,datn,weight) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class') ;
  hold off ;


  figure(4) ;
  clf
  titstr = 'd = 100, default weight, no test data' ;
  [dirvec,beta] = DWD2XQ(datp,datn) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class') ;
  hold off ;


elseif itest == 12 ;

  disp('Use Test Data in Comparison with unbalanced version') ;

  datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
  datn = [(randn(1,50) - 2); 3 * randn(99,50)] ;


  testdat = [[(randn(1,100) + 5); 3 * randn(99,100)], ...
             [(randn(1,100) - 2); 3 * randn(99,100)]] ;

  icolorbase = [] ;
  markerstrbase = [] ;
  for i = 1:size(datp,2) ;
    markerstrbase = strvcat(markerstrbase, '+');
    icolorbase = [icolorbase; [1 0 0]] ;
  end ;
  for i = 1:size(datn,2) ;
    markerstrbase = strvcat(markerstrbase, 'o');
    icolorbase = [icolorbase; [0 0 1]] ;
  end ;


  figure(1) ;
  clf ;
  titstr = 'd = 100, Manually set weight = 1, ignore unbalanced sample sizes' ;
  weight = 1 ;
  [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  for i = 1:size(testdat,2) ;
    if dr(i) > 0 ;
      icolor = [icolor; [1 0.5 0]] ;
    else ;
      icolor = [icolor; [0 0.5 1]] ;
    end ;
    if i < ((size(testdat,2) + 1) / 2) ;
      markerstr = strvcat(markerstr, '^');
    else ;
      markerstr = strvcat(markerstr, 'v');
    end ;
  end ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn,testdat],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class,       Colors = Classification Result') ;
  hold off ;


  figure(2) ;
  clf
  titstr = 'd = 100, Manually set weight = 2, correctly handle unbalanced sample sizes' ;
  weight = 2 ;
  [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat) ;
  icolor = icolorbase ;
  markerstr = markerstrbase ;
  for i = 1:size(testdat,2) ;
    if dr(i) > 0 ;
      icolor = [icolor; [1 0.5 0]] ;
    else ;
      icolor = [icolor; [0 0.5 1]] ;
    end ;
    if i < ((size(testdat,2) + 1) / 2) ;
      markerstr = strvcat(markerstr, '^');
    else ;
      markerstr = strvcat(markerstr, 'v');
    end ;
  end ;
  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn,testdat],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class,       Colors = Classification Result') ;
  hold off ;


elseif itest == 13 ;

  disp('Investigate Old vs. New DWD for multiple realizations') ;


  for irep = 1:10 ;

    figure(irep) ;
    clf ;

    datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
    datn = [(randn(1,50) - 2); 3 * randn(99,50)] ;

    icolorbase = [] ;
    markerstrbase = [] ;
    for i = 1:size(datp,2) ;
      markerstrbase = strvcat(markerstrbase, '+');
      icolorbase = [icolorbase; [1 0 0]] ;
    end ;
    for i = 1:size(datn,2) ;
      markerstrbase = strvcat(markerstrbase, 'o');
      icolorbase = [icolorbase; [0 0 1]] ;
    end ;

    testdat = [[(randn(1,100) + 5); 3 * randn(99,100)], ...
               [(randn(1,100) - 2); 3 * randn(99,100)]] ;

    subplot(2,1,1) ;
    titstr = ['d = 100, Manually set weight = 1, irep = ' num2str(irep)] ;
    weight = 1 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat) ;
    icolor = icolorbase ;
    markerstr = markerstrbase ;
    for i = 1:size(testdat,2) ;
      if dr(i) > 0 ;
        icolor = [icolor; [1 0.5 0]] ;
      else ;
        icolor = [icolor; [0 0.5 1]] ;
      end ;
      if i < ((size(testdat,2) + 1) / 2) ;
        markerstr = strvcat(markerstr, '^');
      else ;
        markerstr = strvcat(markerstr, 'v');
      end ;
    end ;
    paramstruct = struct('icolor',icolor,...
                         'markerstr',markerstr,...
                         'isubpopkde',1,...
                         'datovlaymin',0.3,...
                         'datovlaymax',0.8,...
                         'titlestr',titstr,...
                         'iscreenwrite',1) ;
    projplot1SM([datp,datn,testdat],dirvec,paramstruct) ;
    hold on ;
      vax = axis ;
      plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
      text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
           (vax(3) + 0.9 * (vax(4) - vax(3))), ...
           'Symbols = Original Class,       Colors = Classification Result') ;
    hold off ;


    subplot(2,1,2) ;
    titstr = ['d = 100, Manually set weight = 2, irep = ' num2str(irep)] ;
    weight = 2 ;
    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat) ;
    icolor = icolorbase ;
    markerstr = markerstrbase ;
    for i = 1:size(testdat,2) ;
      if dr(i) > 0 ;
        icolor = [icolor; [1 0.5 0]] ;
      else ;
        icolor = [icolor; [0 0.5 1]] ;
      end ;
      if i < ((size(testdat,2) + 1) / 2) ;
        markerstr = strvcat(markerstr, '^');
      else ;
        markerstr = strvcat(markerstr, 'v');
      end ;
    end ;
    paramstruct = struct('icolor',icolor,...
                         'markerstr',markerstr,...
                         'isubpopkde',1,...
                         'datovlaymin',0.3,...
                         'datovlaymax',0.8,...
                         'titlestr',titstr,...
                         'iscreenwrite',1) ;
    projplot1SM([datp,datn,testdat],dirvec,paramstruct) ;
    hold on ;
      vax = axis ;
      plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
      text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
           (vax(3) + 0.9 * (vax(4) - vax(3))), ...
           'Symbols = Original Class,       Colors = Classification Result') ;
    hold off ;

  end ;


elseif itest == 14 ;

  disp('Investigate Old vs. New DWD for many more realizations') ;

  nrep = 200 ;
%  nrep = 10 ;
  vangle = [] ;
  vmindiff1 = [] ;
  vmindiff2 = [] ;
  vmeandiff1 = [] ;
  vmeandiff2 = [] ;
  vmediandiff1 = [] ;
  vmediandiff2 = [] ;
  vmaxdiff1 = [] ;
  vmaxdiff2 = [] ;
  for irep = 1:nrep ;

    disp(['Working on irep = ' num2str(irep) '    of ' num2str(nrep)]) ;

    datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
    datn = [(randn(1,50) - 2); 3 * randn(99,50)] ;

    testdat = [[(randn(1,100) + 5); 3 * randn(99,100)], ...
               [(randn(1,100) - 2); 3 * randn(99,100)]] ;

    weight = 1 ;
    [dirvec1,beta1,dr1] = DWD2XQ(datp,datn,weight,testdat) ;
    projdat1p = dirvec1' * datp ;
    projdat1n = dirvec1' * datn ;
    vmindiff1 = [vmindiff1; (min(projdat1p) - max(projdat1n))] ;
    vmeandiff1 = [vmeandiff1; (mean(projdat1p) - mean(projdat1n))] ;
    vmediandiff1 = [vmediandiff1; (median(projdat1p) - median(projdat1n))] ;
    vmaxdiff1 = [vmaxdiff1; (max(projdat1p) - min(projdat1n))] ;

    weight = 2 ;
    [dirvec2,beta2,dr2] = DWD2XQ(datp,datn,weight,testdat) ;
    projdat2p = dirvec2' * datp ;
    projdat2n = dirvec2' * datn ;
    vmindiff2 = [vmindiff2; (min(projdat2p) - max(projdat2n))] ;
    vmeandiff2 = [vmeandiff2; (mean(projdat2p) - mean(projdat2n))] ;
    vmediandiff2 = [vmediandiff2; (median(projdat2p) - median(projdat2n))] ;
    vmaxdiff2 = [vmaxdiff2; (max(projdat2p) - min(projdat2n))] ;

    vangle = [vangle; acos(dirvec1' * dirvec2) * 180 / pi] ;

  end ;    %  of irep loop

  mdiff = [vmindiff2 vmeandiff2 vmediandiff2 vmaxdiff2] - ...
               [vmindiff1 vmeandiff1 vmediandiff1 vmaxdiff1] ;

  figure(1) ;
  clf ;
  titlecellstr = {{'Compare DWD2, weight = 1 vs. 2' ...
                   ['Based on ' num2str(nrep) 'reps'] ...
                   'Generated by DWD2XQtest.m'}} ;
  labelcellstr = {{'min gap (2 - 1)'; 'mean (2 - 1)'; ...
                        'median (2 - 1)'; 'max range (2 - 1)'}} ;
  paramstruct = struct('irecenter',0, ...
                       'datovlaymax',0.7, ...
                       'datovlaymin',0.3, ...
                       'maxlim',1, ...
                       'iplotaxes',1, ...
                       'titlecellstr',titlecellstr, ...
                       'labelcellstr',labelcellstr, ...
                       'savestr','DWD2XQtestIp14Diffs', ...
                       'iscreenwrite',1) ;
  scatplotSM(mdiff',eye(4),paramstruct) ;

  figure(2) ;
  clf ;
  paramstruct = struct('datovlaymax',0.7, ...
                       'datovlaymin',0.3, ...
                       'titlestr','DWD2 angles (deg), weight = 1 vs. 2', ...
                       'savestr','DWD2XQtestIp14Angles', ...
                       'ifigure',2, ...
                       'iscreenwrite',1) ;
  projplot1SM(vangle',1,paramstruct) ;


elseif itest < 100 ;

  datp = [(randn(1,200) + 4); 3 * randn(99,200)] ;
  datn = [(randn(1,50) - 1); 3 * randn(99,50)] ;

  weight = 2 ;

  testdat = [[(randn(1,100) + 4); 3 * randn(99,100)], ...
             [(randn(1,100) - 1); 3 * randn(99,100)]] ;
 
  if itest == 21 ;

    DWDpar = 10 ;
    titstr = ['d = 100, Test DWDpar = ' num2str(DWDpar)] ;
 
  elseif itest == 22 ;

    DWDpar = 100 ;
    titstr = ['d = 100, Test DWDpar = ' num2str(DWDpar)] ;

  elseif itest == 23 ;

    DWDpar = 1000 ;
    titstr = ['d = 100, Test DWDpar = ' num2str(DWDpar)] ;

  elseif itest == 24 ;

    DWDpar = 10000 ;
    titstr = ['d = 100, Test DWDpar = ' num2str(DWDpar)] ;

  elseif itest == 25 ;

    DWDpar = 100000 ;
    titstr = ['d = 100, Test DWDpar = ' num2str(DWDpar)] ;

  end ;

  [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat,DWDpar) ;

  icolor = [] ;
  markerstr = [] ;
  for i = 1:size(datp,2) ;
    markerstr = strvcat(markerstr, '+');
    icolor = [icolor; [1 0 0]] ;
  end ;
  for i = 1:size(datn,2) ;
    markerstr = strvcat(markerstr, 'o');
    icolor = [icolor; [0 0 1]] ;
  end ;
  for i = 1:size(testdat,2) ;
    if dr(i) > 0 ;
      icolor = [icolor; [1 0.5 0]] ;
    else ;
      icolor = [icolor; [0 0.5 1]] ;
    end ;
    if i < ((size(testdat,2) + 1) / 2) ;
      markerstr = strvcat(markerstr, '^');
    else ;
      markerstr = strvcat(markerstr, 'v');
    end ;
  end ;

  paramstruct = struct('icolor',icolor,...
                       'markerstr',markerstr,...
                       'isubpopkde',1,...
                       'datovlaymin',0.3,...
                       'datovlaymax',0.8,...
                       'titlestr',titstr,...
                       'iscreenwrite',1) ;
  projplot1SM([datp,datn,testdat],dirvec,paramstruct) ;
  hold on ;
    vax = axis ;
    plot([-beta, -beta],[vax(3),vax(4)],'k--','LineWidth',2) ;
    text((vax(1) + 0.1 * (vax(2) - vax(1))), ...
         (vax(3) + 0.9 * (vax(4) - vax(3))), ...
         'Symbols = Original Class,       Colors = Classification Result') ;
  hold off ;


else ;

  if itest == 101 ;

    disp('Check uneven dimensions of positive and negative training data') ;
    datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
    datn = [(randn(1,50) - 2); 3 * randn(199,50)] ;

    [dirvec,beta,dr] = DWD2XQ(datp,datn) ;


  elseif itest == 102 ;

    disp('Check uneven dimensions of training and testing data') ;
    datp = [(randn(1,200) + 5); 3 * randn(99,200)] ;
    datn = [(randn(1,50) - 2); 3 * randn(99,50)] ;
    weight = 2 ;
    testdat = [[(randn(1,100) + 4); 3 * randn(199,100)], ...
               [(randn(1,100) - 1); 3 * randn(199,100)]] ;

    [dirvec,beta,dr] = DWD2XQ(datp,datn,weight,testdat) ;


  end ;

end ;

