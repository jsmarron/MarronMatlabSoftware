disp('Running MATLAB script file SigClustLabelPlotSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION SigClustLabelPlotSM,
%    CURVes as DATa analysis


itest = 30 ;     %  1,...,30




if itest == 1 ;     %  very simple test, with all defaults

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass) ;


elseif itest == 2 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss1 = randn(1,50) ;
  vgauss1(1:20) = vgauss1(1:20) - mean(vgauss1(1:20)) ;
  vgauss1(21:50) = vgauss1(21:50) - mean(vgauss1(21:50)) ;
  vgauss2 = randn(1,50) ;
  vgauss2(1:20) = vgauss2(1:20) - mean(vgauss2(1:20)) ;
  vgauss2(21:50) = vgauss2(21:50) - mean(vgauss2(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss1; 20 * vgauss2] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass) ;


elseif itest == 3 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = [vunif; vunif + 0.1 * vunif.^2] ;

  vclass = [ones(1,20) 2 * ones(1,30)] ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass) ;


elseif itest == 4 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass) ;


elseif itest == 5 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{strvcat('Test Titles',' ','Title Bottom Left') ...
                   strvcat(' ',' ',' ') ...
                   strvcat('Title Top Right',' ','Title Bottom Right')}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 6 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test Title'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 7 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'Title Font Size'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 8 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test Title Font Size'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 9 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'Label Font Size'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'labelfontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 10 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test Label Font Size'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'labelfontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 11 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'Labels'}} ;
  labelcellstr = {{'Dir. 1'; 'Dir. 2'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'labelcellstr',labelcellstr, ...
                       'labelfontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 12 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test Label'}} ;
  labelcellstr = {{'Dir. 1'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'labelcellstr',labelcellstr, ...
                       'labelfontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 13 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'Legend & Color'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  mlegendcolor = [[0 1 1]; [1 0 1]];
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',mlegendcolor, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 14 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test Legend & Color'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  mlegendcolor = [[0 1 1]; [1 0 1]];
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',mlegendcolor, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 15 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'All Black' 'Forced Legend Color'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  mlegendcolor = [[0 1 1]; [1 0 1]];
  paramstruct = struct('icolor',0, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'mlegendcolor',mlegendcolor, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 16 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'All Black'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('icolor',0, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 17 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'Legend Color Default'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 18 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  icolor = [[0 1 0]; [1 0 1]] ;
  titlecellstr = {{'Test' 'Color'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('icolor',icolor, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 19 ;

  disp('???   Note from SigClustLabelPlotSMtest.m:') ;
  disp('???   This should give a warning message') ;
  disp('???   Has intentional error') ;
  disp('???') ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  icolor = [[0 1 0]; [1 0 1]; [0 1 1]] ;
  titlecellstr = {{'Test' 'Bad Color Input'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('icolor',icolor, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 20 ;

  disp('???   Note from SigClustLabelPlotSMtest.m:') ;
  disp('???   This should give a warning message') ;
  disp('???   Has intentional error') ;
  disp('???') ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  icolor = [0 1 0] ;
  titlecellstr = {{'Test' 'Bad Color Input'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('icolor',icolor, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 21 ;

  disp('???   Note from SigClustLabelPlotSMtest.m:') ;
  disp('???   This should give a warning message') ;
  disp('???   Has intentional error') ;
  disp('???') ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  icolor = 1 ;
  titlecellstr = {{'Test' 'Bad Color Input'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('icolor',icolor, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 22 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  markerstr = strvcat('s','*') ;
  titlecellstr = {{'Test' 'Markers'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('markerstr',markerstr, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 23 ;

  disp('???   Note from SigClustLabelPlotSMtest.m:') ;
  disp('???   This should give a warning message') ;
  disp('???   Has intentional error') ;
  disp('???') ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  markerstr = strvcat('s','*','o') ;
  titlecellstr = {{'Test' 'Markers'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('markerstr',markerstr, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 24 ;

  disp('???   Note from SigClustLabelPlotSMtest.m:') ;
  disp('???   This should give a fatal') ;
  disp('???   Has intentional error') ;
  disp('???') ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  markerstr = char('s','d') ;
  titlecellstr = {{'Test' 'Markers'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  paramstruct = struct('markerstr',markerstr, ...
                       'titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 25 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'File Save' 'Look for temp.fig'}} ;
  legendcellstr = {{'Class 1' 'Class 2'}} ;
  savestr = 'temp' ;
  paramstruct = struct('titlecellstr',titlecellstr, ...
                       'legendcellstr',legendcellstr, ...
                       'savestr',savestr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 26 ;     %  very simple test, with all defaults

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss = randn(1,50) ;
  vgauss(1:20) = vgauss(1:20) - mean(vgauss(1:20)) ;
  vgauss(21:50) = vgauss(21:50) - mean(vgauss(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'iMDdir = 0'}} ;
  paramstruct = struct('iMDdir',0, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 27 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss1 = randn(1,50) ;
  vgauss1(1:20) = vgauss1(1:20) - mean(vgauss1(1:20)) ;
  vgauss1(21:50) = vgauss1(21:50) - mean(vgauss1(21:50)) ;
  vgauss2 = randn(1,50) ;
  vgauss2(1:20) = vgauss2(1:20) - mean(vgauss2(1:20)) ;
  vgauss2(21:50) = vgauss2(21:50) - mean(vgauss2(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss1; 20 * vgauss2] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'iMDdir = 0'}} ;
  paramstruct = struct('iMDdir',0, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 28 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = [vunif; vunif + 0.1 * vunif.^2] ;

  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'iMDdir = 0'}} ;
  paramstruct = struct('iMDdir',0, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 29 ;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  data = vunif ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test iMDdir = 0'}} ;
  paramstruct = struct('iMDdir',0, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;


elseif itest == 30;

  vunif = rand(1,50)  ;
  vunif = sort(vunif) ;
  vgauss1 = randn(1,50) ;
  vgauss1(1:20) = vgauss1(1:20) - mean(vgauss1(1:20)) ;
  vgauss1(21:50) = vgauss1(21:50) - mean(vgauss1(21:50)) ;
  vgauss2 = randn(1,50) ;
  vgauss2(1:20) = vgauss2(1:20) - mean(vgauss2(1:20)) ;
  vgauss2(21:50) = vgauss2(21:50) - mean(vgauss2(21:50)) ;
  vgauss3 = randn(1,50) ;
  vgauss3(1:20) = vgauss3(1:20) - mean(vgauss3(1:20)) ;
  vgauss3(21:50) = vgauss3(21:50) - mean(vgauss3(21:50)) ;
  data = [vunif; vunif + 0.1 * vunif.^2; 10 * vgauss1; 15 * vgauss2; 20 * vgauss3] ;
  
  vclass = [ones(1,20) 2 * ones(1,30)] ;

  titlecellstr = {{'Test' 'iMDdir = 0'}} ;
  paramstruct = struct('iMDdir',0, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  clf ;
  SigClustLabelPlotSM(data,vclass,paramstruct) ;



end ;




