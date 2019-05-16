disp('Running MATLAB script file BatchAdjustSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION BatchAdjustSM,
%    
%    Also gives examples of how to use that function
%
%    This gives a "template", intended to be copied and modified
%    to do batch adjustment of other data sets
%
%    For simple tasks, the itest = 1  part should be enough
%    For more complex tasks, it may be worth understanding itest = 2




itest = 121 ;      %  1  Stanford Public data, Source adjustment
                 %         (this illustrates a simple use of 
                 %          BatchAdjustSM.m)
                 %  2  Stanford Public data, Source & Batch adjustment
                 %         (this illustrates a complex sequence
                 %          of applications of BatchAdjustSM.m)
                 %  101,...,121  parameter tests
                 %         (not interesting for most purposes)




if  itest == 1  | ...
    itest == 2  ;    %  then do Stanford Public data


  %  First read in Perou Public data
  %
  %  Data are from file:
  %    107_public_5900_genes_imputed+Class.xls
  %  in the subdirectory:
  %    Data
  %
  % Class label info:
  %   chuck class 550 intrinsic LumA=1, LumB=2, NB=3, ERBB2=4, Basal=5

%  infilestr = 'Data' ;
  infilestr = 'C:\Users\marron\Documents\Research\Bioinf\GeneArray\BatchAdjust\Data' ;
  infilestr = [infilestr '\107_public_5900_genes_imputed+Class.xls'] ;

  [numin, textin] = xlsread(infilestr) ;

      %%%%
      %%%%  Important Note:  Excel Spreadsheet must be Excel version 5.0 
      %%%%  compatible!     (at least for the versions of Matlab that I run)
      %%%%  Otherwise, do "Save as", to version 5.0, in Excel first
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




  if itest == 1 ;    %  then do just source adjustemnt

    batchlabels = 2 * vSource - 3 ;
        %  vSource has values 1 or 2,
        %  this maps these to -1 or + 1

    legcellstr = {{'Source 1' 'Source 2'}} ;

    paramstruct = struct('viplot',ones(4,1), ...
                         'savestr','BatchAdjustSMtestStanfordSource', ...
                         'titlestr','Stanford Public Source', ...
                         'legcellstr',legcellstr, ...
                         'iscreenwrite',1) ;
 

    BatchAdjustSM(mdata,batchlabels,paramstruct) ;



  elseif itest == 2 ;    %  the do both source and batch adjustment


    genoutstr = 'BatchAdjustSMtestStanfordSoBa' ;
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


    %  Make "before" plot, using curvdatSM
    %  Since want 3 color display of batches
    mlegendcolorBatch = [[1 0 0] ; ...
                        [0 1 0] ; ...
                        [0 0 1]] ;
    mcolorBatch = [(vBatch' == 1) zeros(n,2)] + ...
                  [zeros(n,1) (vBatch' == 2)  zeros(n,1)] + ...
                  [zeros(n,2) (vBatch' == 3)];
    legcellstr = {'Batch 1', 'Batch 2', 'Batch 3'}' ;
    paramstruct = struct('viout',[3], ...
                         'vipcplot',1:6, ...
                         'icolor',mcolorBatch, ...
                         'savestr',[genoutstr 'BeforeAll'], ...
                         'legendcellstr',{legcellstr}, ...
                         'mlegendcolor',mlegendcolorBatch, ...
                         'iscreenwrite',1) ;
    curvdatSM(mdata,paramstruct) ;



    %  First do Source adjustment as above
    %  No graphics output, since have already seen those results
    batchlabels = 2 * vSource - 3 ;
        %  vSource has values 1 or 2,
        %  this maps these to -1 or + 1
    paramstruct = struct('viplot',zeros(4,1), ...
                         'iscreenwrite',1) ;
    mdataSoAd = BatchAdjustSM(mdata,batchlabels,paramstruct) ;



    %  Second do Batch Adjustment Batches 1 & 2 vs. Batch 3
    batchlabels = ((vBatch == 1) | (vBatch == 2))  +  ...
                      -1 * (vBatch == 3) ;
    paramstruct = struct('viplot',ones(4,1), ...
                         'savestr',[genoutstr 'SAdjB12v3Adj'], ...
                         'titlestr','Stanford Public, after Source Adjust', ...
                         'legcellstr',{{'Batch 1 & 2' 'Batch 3'}}, ...
                         'iscreenwrite',1) ;
    mdataSoAdBa12v3Ad = BatchAdjustSM(mdataSoAd,batchlabels,paramstruct) ;


    %  Third do Batch Adjustment 1 vs. 2
    subsetflag = ((vBatch == 1) | (vBatch == 2)) ;
    batchlabels = (vBatch(subsetflag) == 1)  +  ...
                      -1 * (vBatch(subsetflag) == 2) ;
    paramstruct = struct('viplot',ones(4,1), ...
                         'savestr',[genoutstr 'SAdjB12v3AdjB1v2Adj'], ...
                         'titlestr','Stan. Pub., aft. So. and Ba. 1,2 vs. 3 Adj.', ...
                         'legcellstr',{{'Batch 1' 'Batch 2'}}, ...
                         'iscreenwrite',1) ;
    mdataSoAdBa1v2Ad = BatchAdjustSM(mdataSoAdBa12v3Ad(:,subsetflag), ...
                                     batchlabels,paramstruct) ;



    %  Now put everyting together
    %
    mdataSoAdBaAd = mdataSoAdBa12v3Ad ;
        %  Start with Source Adjusted, and 1,2 vs 3 Batch Adjusted
    mdataSoAdBaAd(:,subsetflag) = mdataSoAdBa1v2Ad ;
        %  Next weave in 1 vs 2 Batch adjustment



    %  Finally make "after" plot, using curvdatSM
    %  Since want 3 color display of batches
    mlegendcolorBatch = [[1 0 0] ; ...
                        [0 1 0] ; ...
                        [0 0 1]] ;
    mcolorBatch = [(vBatch' == 1) zeros(n,2)] + ...
                  [zeros(n,1) (vBatch' == 2)  zeros(n,1)] + ...
                  [zeros(n,2) (vBatch' == 3)];
    legcellstr = {'Batch 1', 'Batch 2', 'Batch 3'}' ;
    paramstruct = struct('viout',[3], ...
                         'vipcplot',1:6, ...
                         'icolor',mcolorBatch, ...
                         'savestr',[genoutstr 'AfterAll'], ...
                         'legendcellstr',{legcellstr}, ...
                         'mlegendcolor',mlegendcolorBatch, ...
                         'iscreenwrite',1) ;
    curvdatSM(mdataSoAdBaAd,paramstruct) ;



    %  Output tab delimited text file
    %
    fid = fopen([genoutstr 'BSAdj.txt'],'wt') ;
              %  'wt' is for "delete contents of this file and open 
              %               for writing" (with 't' for "text").


      %  Print first line
      %
      cntbytes = fprintf(fid,'\t%1s','source') ;
                %  '\t' says "put a tab"
      for i = 1:(n-1) ;
        cntbytes = fprintf(fid,'\t%1.0f',vSource(i)) ;
      end ;
      cntbytes = fprintf(fid,'\t%1.0f\n',vSource(n)) ;


      %  Print second line
      %
      cntbytes = fprintf(fid,'\t%1s','batch') ;
                %  '\t' says "put a tab"
      for i = 1:(n-1) ;
        cntbytes = fprintf(fid,'\t%1.0f',vBatch(i)) ;
      end ;
      cntbytes = fprintf(fid,'\t%1.0f\n',vBatch(n)) ;


      %  Print third line
      %
      cntbytes = fprintf(fid,'\t%1s','array name') ;
      for j = 1:(n-1) ;
        cntbytes = fprintf(fid,'\t%1s',vArrayName{j}) ;
      end ;
      cntbytes = fprintf(fid,'\t%1s\n',vArrayName{n}) ;


      %  Print fourth line
      %
      cntbytes = fprintf(fid,'%1s','CLID') ;
      cntbytes = fprintf(fid,'\t%1s','NAME') ;
      for j = 1:(n-1) ;
        cntbytes = fprintf(fid,'\t%1s',vName{j}) ;
      end ;
      cntbytes = fprintf(fid,'\t%1s\n',vName{n}) ;


      %  Print fifth line
      %
      cntbytes = fprintf(fid,'\t%1s','class from intrinsic list, Chuck 550') ;
      for i = 1:(n-1) ;
        cntbytes = fprintf(fid,'\t%1.0f',vClass(i)) ;
      end ;
      cntbytes = fprintf(fid,'\t%1.0f\n',vClass(n)) ;


      %  Loop through remaining lines
      %
      for i = 1:d ;
        cntbytes = fprintf(fid,'%1s',vCLID{i}) ;
        cntbytes = fprintf(fid,'\t%1s',vGeneName{i}) ;
        for j = 1:(n-1) ;
          cntbytes = fprintf(fid,'\t%6.3f',mdataSoAdBaAd(i,j)) ;
        end ;
        cntbytes = fprintf(fid,'\t%6.3f\n',mdataSoAdBaAd(i,n)) ;
      end ;


    fclose(fid) ;


  end ;



elseif itest == 101 ;    %  then test size of batchlabels

  disp('    This generates a deliberate batch labelling error') ;

  rawdata = rand(5,3) ;
  batchlabels = [1 0] ;

  BatchAdjustSM(rawdata,batchlabels) ;


elseif itest == 102 ;    %  then test content of batchlabels

  disp('    This generates a deliberate batch labelling error') ;

  rawdata = rand(5,3) ;
  batchlabels = [1 0 0] ;

  BatchAdjustSM(rawdata,batchlabels) ;


elseif itest == 103 ;    %  then test defaults

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  BatchAdjustSM(rawdata,batchlabels) ;


elseif itest == 104 ;    %  then test no plots, but output matrix

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',zeros(4,1)) ;

  OutPutMatrix = BatchAdjustSM(rawdata,batchlabels,paramstruct) 


elseif itest == 105 ;    %  then test some plots, and output matrix

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0]) ;

  OutPutMatrix = BatchAdjustSM(rawdata,batchlabels,paramstruct) 


elseif itest == 106 ;    %  then test all plots

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1)) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 107 ;    %  then test bad viplot

  disp('    Testing bad value of viplot') ;

  close all ;

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 0 1]) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 108 ;    %  then test all plots, and save as files

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'savestr','TestOutputBatchAdjustSM') ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;

  disp('Check for 4 output files:') ;
  disp(' ') ;
  
  dir TestOutput*.ps


elseif itest == 109 ;    %  then test titlestr on all plots

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'titlestr','Title Test') ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 110 ;    %  then test titlefont on all plots

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(4,1), ...
                       'titlestr','Title Test', ...
                       'titlefontsize',18) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 111 ;    %  then test legends

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2'}}) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 112 ;    %  then test legends

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1'}}) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 113 ;    %  then test legends

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2' 'Batch 3'}}) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 114 ;    %  then test legends

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{{'Batch 1' 'Batch 2' 'Batch 3' ; ...
                                      'B1b' 'B2b' 'B3b'}}) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 115 ;    %  then test legends

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'legcellstr',{'Batch 1' 'Batch 2'}) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 116 ;    %  then test screenwrite

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(1,4), ...
                       'iscreenwrite',1) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 117 ;    %  then test minproj and maxproj

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',ones(1,4), ...
                       'iscreenwrite',1, ...
                       'minproj',-2, ...
                       'maxproj',2) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 118 ;    %  then test minproj

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0], ...
                       'iscreenwrite',1, ...
                       'minproj',-2) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 119 ;    %  then test maxproj

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[0 1 1 0], ...
                       'iscreenwrite',1, ...
                       'maxproj',2) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 120 ;    %  then test npc

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'iscreenwrite',1, ...
                       'npc',3) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;


elseif itest == 121 ;    %  then test npc

  rawdata = rand(10,6) ;
  batchlabels = [1 1 1 -1 -1 -1] ;

  paramstruct = struct('viplot',[1 0 0 1], ...
                       'iscreenwrite',1, ...
                       'npc',1) ;

  BatchAdjustSM(rawdata,batchlabels,paramstruct) ;



end ;


