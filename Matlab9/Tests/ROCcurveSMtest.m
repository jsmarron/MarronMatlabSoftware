disp('Running MATLAB script file ROCcurveSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION ROCcurveSM,
%    Receiver Operating Characteristic Curve

itest = 102 ;     %  1     default mode, write out ROCcurve and AUC
                 %  2,...,23     parameter checks
                 %  101     Theoretical N(0,1) vs. {N(0,1) N(1,1) N(2,1) N(3,1) N(4,1)}
                 %  102     Theoretical N(0,1) vs. {N(1,1/16) N(1,1/4) N(1,1) N(1,4) N(1,16)}

itestdata = 8 ;    %  1 - dataplus not a column vector  (generates error)
                   %  2 - dataminus not a column vector  (generates error)
                   %  3 - overlapping simple example
                   %  4 - nonoverlapping example
                   %  5 - totally equal example
                   %  6 - mislabel plus vs. minus example
                   %  7 - both cell arrays, uneven sizes  (generates error)
                   %  8 - both cell arrays, even sizes
                   %  9 - dataplus cell array, not dataminus
                   %  10 - dataminus cell array, not dataplus
                   %  11 - dataminus = [0.1 ... 0.8],  data plus = 12 U(0,1) random vectors
                   %            meant for testing color schemes


if itestdata == 1 ;

  dataplus = [[5; 6], [7; 8]] ;
  dataminus = [1 2] ;

elseif itestdata == 2 ;

  dataplus = [5; 6] ;
  dataminus = [1 2] ;

elseif itestdata == 3 ;

  dataplus = [2; 4; 5] ;
  dataminus = [0; 1; 3] ;

elseif itestdata == 4 ;

  dataplus = [12; 14; 15] ;
  dataminus = [0; 1; 3] ;

elseif itestdata == 5 ;

  dataplus = [1; 2; 3] ;
  dataminus = dataplus ;

elseif itestdata == 6 ;

  dataplus = [0; 1; 3] ;
  dataminus = [2; 4; 5] ;

elseif itestdata == 7 ;

  dataplus = {[2; 4; 5] [5; 6; 9] [4; 9; 10]} ;
  dataminus = {[0; 1; 3] [4; 5; 8]} ;

elseif itestdata == 8 ;

  dataplus = {[2; 4; 5] [4; 9; 10]} ;
  dataminus = {[0; 1; 3] [4; 5; 8]} ;

elseif itestdata == 9 ;

  dataplus = {[2; 4; 5] [4; 9; 10]} ;
  dataminus = [0; 1; 7] ;

elseif itestdata == 10 ;

  dataplus = [2; 9; 10] ;
  dataminus = {[0; 1; 3] [4; 5; 8]} ;

elseif itestdata == 11 ;

  dataminus = (0:0.1:0.8)' ;
  dataplus = {} ;
  rng(98723948) ;
  for i = 1:12 ;
    dataplus{i} = rand(20,1) ;
  end ;

end ;



figure(1) ;
clf ;


if itest == 1 ;     %  default mode, just write to screen curve and AUC

  dataplus
  dataminus

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus) ;
  ROCcurve
  AUC
  disp('  Recommend testing this with all of itestdata = 3, 8, 11') ;

elseif itest == 2 ;   

  paramstruct = 0 ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  ROCcurve
  AUC
  disp('Check no graphics') ;

elseif itest == 3 ;   

  paramstruct = 3 ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('Check graphics appear') ;

elseif itest == 4 ;   

  paramstruct = struct('iplot',0) ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  ROCcurve
  AUC
  disp('Check no graphics') ;

elseif itest == 5 ;   

  paramstruct = struct('iplot',2) ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('Check graphics appear') ;

elseif itest == 6 ;   

  paramstruct = struct('titlestr','Check input title') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 7 ;   

  paramstruct = struct('titlestr','Check title fontsize', ...
                       'titlefontsize',18) ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 8 ;   

  paramstruct = struct('titlestr','Check x and y labels', ...
                       'xlabelstr','input x label', ...
                       'ylabelstr','input y label') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 9 ;   

  paramstruct = struct('titlestr','Check x and y label font size', ...
                       'xlabelstr','input x label', ...
                       'ylabelstr','input y label', ...
                       'labelfontsize',18) ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 10 ;   

  paramstruct = struct('titlestr','Check no labels', ...
                       'xlabelstr',[], ...
                       'ylabelstr','') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 11 ;   

  paramstruct = struct('titlestr','Check fat linewidth', ...
                       'linewidth',10) ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 12 ;   

  paramstruct = struct('titlestr','Check Color Print to .fig file', ...
                       'savestr','temp') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('Look for file:   temp.fig') ;

elseif itest == 13 ;   

  paramstruct = struct('icolor','k', ...
                       'titlestr','Check icolor=black & Print to B&W .fig file', ...
                       'savestr','temp') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('Look for file:   temp.fig') ;

elseif itest == 14 ;   

  paramstruct = struct('icolor','g', ...
                       'titlestr','Check icolor = g') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('  Recommend testing this with all of itestdata = 3, 8, 11') ;

elseif itest == 15 ;   

  paramstruct = struct('icolor',[0.7 0.7 0.7], ...
                       'titlestr','Check icolor = [0.7 0.7 0.7]') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('  Recommend testing this with all of itestdata = 3, 8, 11') ;

elseif itest == 16 ;   

  paramstruct = struct('icolor',1, ...
                       'titlestr','Test icolor = 1, Matlab default') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;
  disp('  Recommend testing this with all of itestdata = 3, 8, 11') ;

elseif itest == 17 ;   

  paramstruct = struct('icolor',2, ...
                       'titlestr','Test icolor = 2, Rainbow Scheme') ;
  disp('  Recommend testing this with itestdata = 11') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 18 ;   

  paramstruct = struct('icolor',[[1 0 1]; [0 1 0]], ...
                       'titlestr','Test input icolor') ;
  disp('  Recommend testing this with itestdata = 8') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 19 ;   

  paramstruct = struct('icolor',[[1 0 1]; [0 1 0]], ...
                       'legendcellstr',{{'Curve 1' 'Curve 2'}}, ...
                       'titlestr','Test input icolor and legend') ;
  disp('  Recommend testing this with itestdata = 8') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 20 ;   

  paramstruct = struct('icolor',1, ...
                       'legendcellstr',{{'Curve 1' 'Curve 2'}}, ...
                       'titlestr','Test Malab default color and legend') ;
  disp('  Recommend testing this with itestdata = 8') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 21 ;   

  paramstruct = struct('icolor',2, ...
                       'legendcellstr',{{'C1' 'C2' 'C3' 'C4' 'C5' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12'}}, ...
                       'titlestr','Test rainbow color and legend') ;
  disp('  Recommend testing this with itestdata = 11') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 22 ;   

  paramstruct = struct('icolor',1, ...
                       'legendcellstr',{{'C1' 'C2' 'C3' 'C4' 'C5' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12'}}, ...
                       'titlestr','Test Matlab default color and legend') ;
  disp('  Recommend testing this with itestdata = 11') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 23 ;   

  paramstruct = struct('icolor','r', ...
                       'legendcellstr',{{'C1' 'C2' 'C3' 'C4' 'C5' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12'}}, ...
                       'titlestr','Test input color and legend') ;
  disp('  Recommend testing this with all of itestdata = 3, 8, 11') ;

  [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 101 ;   

  ng = 399 ;
  pgrid = linspace(1 / (ng + 1),1 - 1 / (ng + 1),ng)' ;
  dataminus = norminv(pgrid) ;
  dataplus = {} ;
  legendcellstr = {} ;
  for i = 1:5 ;
    dataplus{i} = norminv(pgrid) + i - 1 ;
    legendcellstr{i} = ['N(0,1) vs. N(' num2str(i) ',1)'] ;
  end ;
  legendcellstr = {legendcellstr} ;

  paramstruct = struct('icolor',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Test shifting normal distributions') ;

  ROCcurveSM(dataplus,dataminus,paramstruct) ;

elseif itest == 102 ;   

  ng = 399 ;
  pgrid = linspace(1 / (ng + 1),1 - 1 / (ng + 1),ng)' ;
  dataminus = norminv(pgrid) ;
  dataplus = {} ;
  legendcellstr = {} ;
  for i = 1:5 ;
    dataplus{i} = 0.25^(3 - i) * norminv(pgrid) + 1 ;
    legendcellstr{i} = ['N(0,1) vs. N(1, ' num2str(0.25^(3 - i)) ')'] ;
  end ;
  legendcellstr = {legendcellstr} ;

  paramstruct = struct('icolor',1, ...
                       'legendcellstr',legendcellstr, ...
                       'titlestr','Test scaled normal distributions') ;

  ROCcurveSM(dataplus,dataminus,paramstruct) ;


end ;



