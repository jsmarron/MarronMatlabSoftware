disp('Running MATLAB script file LabeledBarPlotSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION LabeledBarPlotSM,
%    For making a Labeled Bar Plot

itest = 43 ;     %  1,...,43



figure(1) ;
clf

if itest == 1 ;    %  Very simple with pure defaults

  vhts = rand(3,1)' ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1'; 'Feat. 2'; 'Feature 3'} ;

  LabeledBarPlotSM(vhts,Lab) ;


elseif itest == 2 ;    %  Very simple, with title for explanation

  paramstruct = struct('titlestr','Very simple, plus test title') ;

  vhts = rand(3,1)' ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1'; 'Feat. 2'; 'Feature 3'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 3 ;    %  Very simple, check can have row cellstr input

  paramstruct = struct('titlestr','Very simple, check row cellstr input allowed') ;

  vhts = rand(3,1)' ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1' 'Feat. 2' 'Feature 3'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 4 ;    %  Very simple, check can have col cellstr & row vector input

  paramstruct = struct('titlestr','Very simple, check col cellstr & row vector input allowed') ;

  vhts = rand(3,1) ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1'; 'Feat. 2'; 'Feature 3'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 5 ;    %  Very simple, check too few labels

  paramstruct = struct('titlestr','Very simple, testing too few labels') ;

  vhts = rand(3,1) ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1' 'Feat. 2'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 6 ;    %  Very simple, check too few labels

  paramstruct = struct('titlestr','Very simple, testing too few labels') ;

  vhts = rand(10,1) ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1' 'Feat. 2'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 7 ;    %  Very simple, check too many labels

  paramstruct = struct('titlestr','Very simple, testing too many labels') ;
  vhts = rand(3,1) ;
  vhts = vhts / norm(vhts) ;
  Lab = {'Feature 1' 'Feat. 2' 'Feat. 3' 'Feat. 4'} ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 8 ;    %  Test manual isort default

  paramstruct = struct('isort',0, ...
                       'titlestr','Test manual isort default') ;
  vhts = 1:10 ;
  vhts = vhts .* (-1).^mod(1:10,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 9 ;    %  Test isort

  paramstruct = struct('isort',1, ...
                       'titlestr','Test isort = 1, Sort in order smallest to largest') ;
  vhts = 1:10 ;
  vhts = vhts .* (-1).^mod(1:10,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 10 ;    %  Test isort

  paramstruct = struct('isort',2, ...
                       'titlestr','Test isort = 2, Sort absolute values, largest to smallest') ;
  vhts = 1:10 ;
  vhts = vhts .* (-1).^mod(1:10,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 11 ;    %  Test isort

  paramstruct = struct('isort',3, ...
                       'titlestr','Test isort = 3, Sort and plot absolute values, largest to smallest') ;
  vhts = 1:10 ;
  vhts = vhts .* (-1).^mod(1:10,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 12 ;    %  Test isort

  paramstruct = struct('isort',4, ...
                       'titlestr','Test isort = 4, not valid choice') ;
  vhts = 1:10 ;
  vhts = vhts .* (-1).^mod(1:10,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 13 ;    %  Test nshow

  paramstruct = struct('isort',2, ...
                       'nshow',0, ...
                       'titlestr','Test nshow = 0, default of show all bars') ;
  vhts = 1:50 ;
  vhts = vhts .* (-1).^mod(1:50,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 14 ;    %  Test nshow

  paramstruct = struct('isort',2, ...
                       'nshow',20, ...
                       'titlestr','Test nshow = 20, out of input 50 bars') ;
  vhts = 1:50 ;
  vhts = vhts .* (-1).^mod(1:50,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 15 ;    %  Test nshow

  paramstruct = struct('isort',2, ...
                       'nshow',30, ...
                       'titlestr','Test nshow = 30, out of input 20 bars') ;
  vhts = 1:20 ;
  vhts = vhts .* (-1).^mod(1:20,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 16 ;    %  Test nshow

  paramstruct = struct('isort',2, ...
                       'nshow',-20, ...
                       'titlestr','Test nshow = -20, out of input 50 bars') ;
  vhts = 1:50 ;
  vhts = vhts .* (-1).^mod(1:50,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 17 ;    %  Test nshow

  paramstruct = struct('isort',2, ...
                       'nshow',10.8, ...
                       'titlestr','Test nshow = 10.8, out of input 50 bars') ;
  vhts = 1:50 ;
  vhts = vhts .* (-1).^mod(1:50,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 18 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',[], ...
                       'titlestr','Test fontsize at manually input default') ;
  vhts = 1:20 ;
  vhts = vhts .* (-1).^mod(1:20,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 19 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',18, ...
                       'titlestr','Test fontsize = 18') ;
  vhts = 1:20 ;
  vhts = vhts .* (-1).^mod(1:20,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 20 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',6, ...
                       'titlestr','Test nbar = 100, fontsize = 6', ...
                       'savestr','Temp') ;
  nbar = 100 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 21 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',4, ...
                       'titlestr','Test nbar = 200, fontsize = 4', ...
                       'savestr','Temp') ;
  nbar = 200 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps, and zoom in') ;


elseif itest == 22 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',8, ...
                       'titlestr','Test nbar = 50, fontsize = 8', ...
                       'savestr','Temp') ;
  nbar = 50 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 23 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',10, ...
                       'titlestr','Test nbar = 50, fontsize = 10', ...
                       'savestr','Temp') ;
  nbar = 50 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 24 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',12, ...
                       'titlestr','Test nbar = 20, fontsize = 12', ...
                       'savestr','Temp') ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 25 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',15, ...
                       'titlestr','Test nbar = 20, fontsize = 15', ...
                       'savestr','Temp') ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 26 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',18, ...
                       'titlestr','Test nbar = 10, fontsize = 18', ...
                       'savestr','Temp') ;
  nbar = 10 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 27 ;    %  Test fontsize

  paramstruct = struct('isort',2, ...
                       'fontsize',24, ...
                       'titlestr','Test nbar = 10, fontsize = 24', ...
                       'savestr','Temp') ;
  nbar = 10 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 28 ;    %  Test labelhtfrac

  paramstruct = struct('isort',2, ...
                       'titlestr','Test labelhtfrac = 0.1', ...
                       'labelhtfrac',0.1) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 29 ;    %  Test vaxlim

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vaxlim = [] (default, but manually specified)', ...
                       'vaxlim',[]) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 30 ;    %  Test vaxlim

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vaxlim = 1, Use [-1,1], good for common loading plots', ...
                       'vaxlim',1) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 31 ;    %  Test vaxlim

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vaxlim = 2, Use [0,1], good for common absolute loading plots', ...
                       'vaxlim',2) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 32 ;    %  Test vaxlim

  paramstruct = struct('isort',2, ...
                       'titlestr','Test input vaxlim', ...
                       'vaxlim',[-0.2 0.7]) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 33 ;    %  Test vaxlim

  paramstruct = struct('isort',2, ...
                       'titlestr','Test bad input vaxlim', ...
                       'vaxlim',[-0.2; 0.7]) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 34 ;    %  Test vcolor

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vcolor for purple bars', ...
                       'vcolor',[1 0 1]) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 35 ;    %  Test vcolor

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vcolor for gray bars', ...
                       'vcolor',[0.5 0.5 0.5], ...
                       'savestr','Temp') ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 36 ;    %  Test vcolor

  paramstruct = struct('isort',2, ...
                       'titlestr','Test vcolor for gray bars', ...
                       'vcolor',[0.7 0.7 0.7], ...
                       'savestr','Temp') ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;

  disp('    Look at file Temp.ps') ;


elseif itest == 37 ;    %  Test vcolor

  paramstruct = struct('isort',2, ...
                       'titlestr','Test bad input vcolor', ...
                       'vcolor',[0.7 0.7]) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 38 ;    %  Test titlefontsize

  paramstruct = struct('isort',2, ...
                       'titlestr','Test titlefontsize = 18', ...
                       'titlefontsize',18) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 39 ;    %  Test titlefontsize

  paramstruct = struct('isort',2, ...
                       'titlestr','Test titlefontsize = 18', ...
                       'titlefontsize',18) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 40 ;    %  Test xlabelstr & ylabelstr

  paramstruct = struct('isort',2, ...
                       'titlestr','Test xlabelstr & ylabelstr', ...
                       'xlabelstr','X label', ...
                       'ylabelstr','Y label') ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 41 ;    %  Test label fontsize

  paramstruct = struct('isort',2, ...
                       'titlestr','Test label fontsize', ...
                       'xlabelstr','X label', ...
                       'ylabelstr','Y label', ...
                       'labelfontsize',18) ;
  nbar = 20 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 42 ;    %  Test look of 300 bars

  paramstruct = struct('isort',2, ...
                       'titlestr','Test look of 300 bars', ...
                       'xlabelstr','X label', ...
                       'ylabelstr','Y label', ...
                       'labelfontsize',18) ;
  nbar = 300 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


elseif itest == 43 ;    %  Test look of 3000 bars

  paramstruct = struct('isort',2, ...
                       'titlestr','Test look of 3000 bars', ...
                       'xlabelstr','X label', ...
                       'ylabelstr','Y label', ...
                       'labelfontsize',18) ;
  nbar = 3000 ;
  vhts = 1:nbar ;
  vhts = vhts .* (-1).^mod(1:nbar,2) ;
  vhts = vhts / norm(vhts) ;
  Lab = {} ;
  for i = 1:length(vhts) ;
    Lab{i} = ['Feature ' num2str(i)] ;
  end ;

  LabeledBarPlotSM(vhts,Lab,paramstruct) ;


end ;



