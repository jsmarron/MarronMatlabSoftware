disp('Running MATLAB script file BatchAdjustCCtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION BatchAdjustCC,
%    updated version of BatchAdjustSM, written by J. S. Marron
%    and Chris Cabanski
%    
%    Also gives examples of how to use that function
%
%    This gives a "template", intended to be copied and modified
%    to do batch adjustment of other data sets
%
%    For simple tasks, the itest = 1  part should be enough
%    For more complex tasks, it may be worth understanding itest = 2




itest = 2 ;      %  1  Stanford Public data, Source adjustment
                 %         (this illustrates a simple use of 
                 %          BatchAdjustCC.m)
                 %  2  Stanford Public data, Source & Batch adjustment
                 %         (this illustrates a complex sequence
                 %          of applications of BatchAdjustCC.m)
                 %  101,...,130  parameter tests
                 %         (not interesting for most purposes)



disp(['        doing test ' num2str(itest)]) ;

if  itest == 1  | ...
    itest == 2  ;    %  then do Stanford Public data


  %  First read in Perou Public data
  %
  %  Assumes file:
  %    107_public_5900_genes_imputed+Class.xls
  %  is in the current Matlab directory:
  %
  % Class label info:
  %   chuck class 550 intrinsic LumA=1, LumB=2, NB=3, ERBB2=4, Basal=5

  infilestr = '107_public_5900_genes_imputed+Class.xls' ;

  [numin, textin] = xlsread(infilestr) ;

      %%%%
      %%%%  Caution:  Excel Spreadsheet must be Excel version 5.0 
      %%%%  compatible!     (at least for the versions of Matlab that I run)
      %%%%  May need to do "Save as", to version 5.0, in Excel first
      %%%%



  %  Check Data read
  %
  disp(['  Size of numin = ' num2str(size(numin))]) ;
  disp(['  Size of textin = ' num2str(size(textin))]) ;

  disp(' ') ;
  disp('  Check if numin and textin are matrices:') ;
  isa(numin,'double') 
  isa(textin,'double') 

  disp(' ') ;
  disp('  Check if numin and textin are cell arrays:') ;
  iscell(numin) 
  iscell(textin) 

  disp(' ') ;
  disp('  Check if numin and textin are character arrays:') ;
  ischar(numin) 
  ischar(textin) 


  disp(' ') ;
  disp('  Check values in some cells:') ;

  disp(' ') ;
  disp('  This should give: CLID') ;
  textin(4,1)
  textin{4,1}
      %  2nd one seems to give more useful form (see below)

  disp(' ') ;
  disp('  This should give the 1st case name: BC503B-BE') ;
  textin{4,3}
      %    Note here and below:    
      %        coordinates come from spreadsheet

  disp(' ') ;
  disp('  This should give the 1st CLID: IMAGE:252515') ;
  textin{6,1}

  disp(' ') ;
  disp('  This should give the first gene name: kynureninase (L-kynurenine hydrolase) H87471') ;
  textin{6,2}


  disp(' ') ;
  disp('  This should give the 1st data value, -2.01:') ;
  numin(6,3)

  disp(' ') ;
  disp('  This should give the last data value, 0.56:') ;
  numin(end,end)

  disp(' ') ;
  disp('  This should be 0:') ;
  numin(8,3)

  disp(' ') ;
  disp('  This should be 4:') ;
  numin(5,5)

  disp(' ') ;
  disp('  These should be empty:') ;
  textin{5,5}
  textin{8,4}


  mdata = numin(6:end,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st data value, -2.01:') ;
  mdata(1,1)

  disp(' ') ;
  disp('  This should give the last data value, 0.56:') ;
  mdata(end,end)


  vSource = numin(1,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st source value, 1:') ;
  vSource(1)

  disp(' ') ;
  disp('  This should give the last source value, 2:') ;
  vSource(end)


  vBatch = numin(2,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st batch value, 1:') ;
  vBatch(1)

  disp(' ') ;
  disp('  This should give the last batch value, NaN:') ;
  vBatch(end)


  vArrayName = textin(3,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st Array Name value, shac091:') ;
  vArrayName(1)

  disp(' ') ;
  disp('  This should give the last Array Name value, svo088:') ;
  vArrayName(end)


  vName = textin(4,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st Name value, BC503B-BE:') ;
  vName(1)

  disp(' ') ;
  disp('  This should give the last Name value, BC11-FA:') ;
  vName(end)


  vClass = numin(5,3:end) ;

  disp(' ') ;
  disp('  This should give the 1st class value, 1:') ;
  vClass(1)

  disp(' ') ;
  disp('  This should give the last class value, 3:') ;
  vClass(end)


  vCLID = textin(6:end,1) ;

  disp(' ') ;
  disp('  This should give the 1st CLID value, IMAGE:252515:') ;
  vCLID(1)

  disp(' ') ;
  disp('  This should give the last class value, IMAGE:325355:') ;
  vCLID(end)


  vGeneName = textin(6:end,2) ;

  disp(' ') ;
  disp('  This should give the 1st CLID value, kynureninase (L-kynurenine hydrolase) H87471:') ;
  vGeneName(1)

  disp(' ') ;
  disp('  This should give the last class value, latent transforming growth factor beta binding protein 2 W52204:') ;
  vGeneName(end)




  if itest == 1 ;    %  then do just source adjustment

    batchlabels = 2 * vSource - 3 ;
        %  vSource has values 1 or 2,
        %  this maps these to -1 or + 1

    legcellstr = {{'Source 1' 'Source 2'}} ;

    paramstruct = struct('viplot',ones(4,1), ...
                         'savestr','BatchAdjustCCtestStanfordSource', ...
                         'titlestr','Stanford Public Source', ...
                         'legcellstr',legcellstr, ...
                         'iscreenwrite',1) ;
 

    BatchAdjustCC(mdata,batchlabels,paramstruct) ;



  elseif itest == 2 ;    %  then do both source and batch adjustment


    genoutstr = 'BatchAdjustCCtestStanfordSoBa' ;
        %  generic output string

    %  delete columns with missing "batch"
    %
    flag = ~isnan(vBatch) ;
    mdata = mdata(:,flag) ;
    vSource = vSource(flag) ;
    vBatch = vBatch(flag) ;
    vArrayName = vArrayName(flag) ;
    vName = vName(flag) ;
    vClass = vClass(flag) ;
    n = sum(flag) ;
    d = size(mdata,1) ;


    %  First do Source adjustment as above
    batchlabels = 2 * vSource - 3 ;
        %  vSource has values 1 or 2,
        %  this maps these to -1 or + 1
    paramstruct = struct('savestr',[genoutstr 'Sadj'], ...
                         'titlestr','Stanford Public, Source Adjust', ...
                         'legcellstr',{{'Source 1' 'Source 2'}}, ...
                         'iscreenwrite',1) ;
    mdataSoAd = BatchAdjustCC(mdata,batchlabels,paramstruct) ;


    %  Second do Batch Adjustment Batches 1 & 2 vs. Batch 3
    batchlabels = ((vBatch == 1) | (vBatch == 2))  +  ...
                      -1 * (vBatch == 3) ;
    paramstruct = struct('savestr',[genoutstr 'SAdjB12v3Adj'], ...
                         'titlestr','Stanford Public, after Source Adjust', ...
                         'legcellstr',{{'Batch 1 & 2' 'Batch 3'}}, ...
                         'iscreenwrite',1) ;
    mdataSoAdBa12v3Ad = BatchAdjustCC(mdataSoAd,batchlabels,paramstruct) ;


    %  Third do Batch Adjustment 1 vs. 2
    subsetflag = ((vBatch == 1) | (vBatch == 2)) ;
    batchlabels = (vBatch(subsetflag) == 1)  +  ...
                      -1 * (vBatch(subsetflag) == 2) ;
    paramstruct = struct('savestr',[genoutstr 'SAdjB12v3AdjB1v2Adj'], ...
                         'titlestr','Stan. Pub., aft. So. and Ba. 1,2 vs. 3 Adj.', ...
                         'legcellstr',{{'Batch 1' 'Batch 2'}}, ...
                         'iscreenwrite',1) ;
    mdataSoAdBa1v2Ad = BatchAdjustCC(mdataSoAdBa12v3Ad(:,subsetflag), ...
                                     batchlabels,paramstruct) ;



  end ;



elseif itest == 101 ;    %  then test size of batchlabels

  disp('Check for bad size of batchlabels') ;

  rawdata = rand(5,3) ;
  batchlabels = [1 0] ;

  BatchAdjustCC(rawdata,batchlabels) ;


elseif itest == 102 ;    %  then test content of batchlabels

  disp('Check for bad contents (not +-1) of batchlabels') ;

  rawdata = rand(5,3) ;
  batchlabels = [1 0 0] ;

  BatchAdjustCC(rawdata,batchlabels) ;


elseif itest == 103 ;    %  then test defaults

  disp('Testing all simple defaults') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  BatchAdjustCC(rawdata,batchlabels) ;


elseif itest == 104 ;    %  then test no plots, but output matrix

  disp('Testing no plots, but output adjusted data matrix') ;

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',zeros(4,1)) ;

  OutPutMatrix = BatchAdjustCC(rawdata,batchlabels,paramstruct) 


elseif itest == 105 ;    %  then test some plots, and output matrix

  disp('    Testing DWD only plots and output adjusted data matrix') ;

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0]) ;

  OutPutMatrix = BatchAdjustCC(rawdata,batchlabels,paramstruct) 


elseif itest == 106 ;    %  then test all plots

  disp('    Testing all 4 plots') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1)) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 107 ;    %  then test bad viplot

  disp('    Testing bad value of viplot') ;

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 0 1]) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 108 ;    %  then test all plots, and save as files

  disp('    Test all plots, and save as files') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'savestr','TestOutputBatchAdjustCC') ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;

  disp('Check for 4 output files:') ;
  disp(' ') ;
  
  dir TestOutput*.ps


elseif itest == 109 ;    %  then test titlestr on projection plots

  disp('    Test titlestr = ''Title Test'' on projection plots') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'titlestr','Title Test') ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 110 ;    %  then test titlefontsize on projection plots

  disp('    Test titlefontsize on all plots') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'titlestr','Title Test', ...
                       'titlefontsize',18) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 111 ;    %  then test legends

  disp('    Test legends: ''Batch 1'' ''Batch 2''') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2'}}) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 112 ;    %  then test legends

  disp('    Test legends ''Batch 1'' only') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch 1'}}) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 113 ;    %  then test legends

  disp('    Test legends ''Batch 1'' ''Batch 2'' ''Batch 3''') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2' 'Batch 3'}}) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 114 ;    %  then test legends

  disp('    Test legends, 2 x 3 array') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2' 'Batch 3' ; ...
                                      'B1b' 'B2b' 'B3b'}}) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 115 ;    %  then test legends

  disp('    Test legends, single braces only') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{'Batch 1' 'Batch 2'}) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 116 ;    %  then test screenwrite

  disp('    Test screenwrite = 1') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(1,4), ...
                       'iscreenwrite',1) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 117 ;    %  then test minproj and maxproj

  disp('    Test minproj = -2  and  maxproj = 2') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(1,4), ...
                       'iscreenwrite',1, ...
                       'minproj',-2, ...
                       'maxproj',2) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 118 ;    %  then test minproj

  disp('    Test minproj = -2') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0], ...
                       'iscreenwrite',1, ...
                       'minproj',-2) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 119 ;    %  then test maxproj

  disp('    Test maxproj = 2') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0], ...
                       'iscreenwrite',1, ...
                       'maxproj',2) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 120 ;    %  then test npc

  disp('    Test npc = 3') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'iscreenwrite',1, ...
                       'npc',3) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 121 ;    %  then test npc

  disp('    Test npc = 1') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'iscreenwrite',1, ...
                       'npc',1) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 122 ;    %  then test empty titlestr on projection plots

  disp('    Test titlestr = [] on projection plots') ;
  disp('        this is very similar to itest = 9') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'titlestr',[]) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 123 ;    

  disp('    Test markerstr = ''x''') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'markerstr','x') ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 124 ;    

  disp('    Test markerstr has several markers') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;
  markerstr = strvcat('*','*','s','s','s','v') ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'markerstr',markerstr) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 125 ;    %  then test legend color

  disp('    Test mlegendcolor = ''g'', which generates warning messages, and no legend') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2'}}, ...
                       'mlegendcolor','g') ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 126 ;    %  then test legend color

  disp('    Test mlegendcolor = 2 x 3 input of green') ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2'}}, ...
                       'mlegendcolor',[[0 1 0]; [0 1 0]]) ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 127 ;    %  then test default imeantype

  disp('    Test default imeantype') ;

  rawdata = randn(4,100) ;
  rawdata(:,1:40) = rawdata(:,1:40) + 4 ;
  rawdata(:,41:100) = rawdata(:,41:100) - 8 ;
  batchlabels = [ones(1,40) -ones(1,60)] ;

  paramstruct = struct('viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch +1' 'Batch -1'}}, ...
                       'titlestr','Toy example in d = 4') ;

  BatchAdjustCC(rawdata,batchlabels,paramstruct) ;


elseif itest == 128 ;    %  then test imeantype = 0

  disp('    Test imeantype = 0') ;

  rawdata = randn(4,100) ;
  rawdata(:,1:40) = rawdata(:,1:40) + 4 ;
  rawdata(:,41:100) = rawdata(:,41:100) - 8 ;
  batchlabels = [ones(1,40) -ones(1,60)] ;

  paramstruct = struct('imeantype',0, ...
                       'viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch +1' 'Batch -1'}}, ...
                       'titlestr','Toy example in d = 4') ;

  adjdata = BatchAdjustCC(rawdata,batchlabels,paramstruct) ;
  disp('Check Overall mean ~ 0') ;
  mean(mean(adjdata)) 



elseif itest == 129 ;    %  then test imeantype = 1

  disp('    Test imeantype = 1') ;

  rawdata = randn(4,100) ;
  rawdata(:,1:40) = rawdata(:,1:40) + 4 ;
  rawdata(:,41:100) = rawdata(:,41:100) - 8 ;
  batchlabels = [ones(1,40) -ones(1,60)] ;

  paramstruct = struct('imeantype',1, ...
                       'viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch +1' 'Batch -1'}}, ...
                       'titlestr','Toy example in d = 4') ;

  adjdata = BatchAdjustCC(rawdata,batchlabels,paramstruct) ;
  disp('Check Overall mean > 0') ;
  mean(mean(adjdata)) 


elseif itest == 130 ;    %  then test imeantype = -1

  disp('    Test imeantype = -1') ;

  rawdata = randn(4,100) ;
  rawdata(:,1:40) = rawdata(:,1:40) + 4 ;
  rawdata(:,41:100) = rawdata(:,41:100) - 8 ;
  batchlabels = [ones(1,40) -ones(1,60)] ;

  paramstruct = struct('imeantype',-1, ...
                       'viplot',[1 1 1 1], ...
                       'legcellstr',{{'Batch +1' 'Batch -1'}}, ...
                       'titlestr','Toy example in d = 4') ;

  adjdata = BatchAdjustCC(rawdata,batchlabels,paramstruct) ;
  disp('Check Overall mean < 0') ;
  mean(mean(adjdata)) 



end ;


