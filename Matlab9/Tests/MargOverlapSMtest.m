disp('Running MATLAB script file MargOverlapSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION MargOverlapSM,
%    Marginal Distribution Plot



itest = 64 ;     %  1,2,...,70
                 %  101 


if  itest == 1  | ...
    itest == 2  | ...
    itest == 3  | ...
    itest == 4  | ...
    itest == 5  | ...
    itest == 6  | ...
    itest == 7  | ...
    itest == 8  | ...
    itest == 9  | ...
    itest == 10  | ...
    itest == 11  | ...
    itest == 12  | ...
    itest == 13  | ...
    itest == 14  | ...
    itest == 15  | ...
    itest == 16  | ...
    itest == 17  | ...
    itest == 18  | ...
    itest == 19  | ...
    itest == 20  | ...
    itest == 21  | ...
    itest == 22  | ...
    itest == 23  | ...
    itest == 24  | ...
    itest == 25  | ...
    itest == 26  | ...
    itest == 27  | ...
    itest == 28  | ...
    itest == 29  | ...
    itest == 30  | ...
    itest == 31  | ...
    itest == 32  | ...
    itest == 33  | ...
    itest == 34  | ...
    itest == 35  | ...
    itest == 36  | ...
    itest == 37  | ...
    itest == 38  | ...
    itest == 39  | ...
    itest == 40  | ...
    itest == 41  | ...
    itest == 42  | ...
    itest == 43  | ...
    itest == 44  | ...
    itest == 45  | ...
    itest == 46  | ...
    itest == 47  | ...
    itest == 48  | ...
    itest == 49  | ...
    itest == 50  | ...
    itest == 51  | ...
    itest == 52  | ...
    itest == 53  | ...
    itest == 54  | ...
    itest == 55  | ...
    itest == 56  | ...
    itest == 57  | ...
    itest == 58  | ...
    itest == 59  | ...
    itest == 60  | ...
    itest == 61  | ...
    itest == 62  | ...
    itest == 63  | ...
    itest == 64  | ...
    itest == 65  | ...
    itest == 66  | ...
    itest == 67  | ...
    itest == 68  | ...
    itest == 69  | ...
    itest == 70  ;    %  Work with simplest data set

  figure(1) ;
  clf ;

  %  Generate Data
  %
  d = 41 ;
  n = 100 ;
  rng(93874209) ;

  mdata = randn(d,n) ;

  vmean = linspace(-2,2,d)' ;
  vflag = logical([ones(1,n/2) zeros(1,n/2)]) ;
  mdata(:,vflag) = mdata(:,vflag) + vmean * ones(1,n/2) ;
  mdata(:,~vflag) = mdata(:,~vflag) - vmean * ones(1,n/2) ;
  
  if itest == 1 ; 

    disp('  Running with all defaults only') ;
    MargOverlapSM(mdata,vflag) ;

  elseif itest == 2 ;

    paramstruct = struct('titlecellstr',{{'Test' 'Title' 'Cell' 'String'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 3 ;

    paramstruct = struct('titlecellstr',{{'' 'Test Title Cell String' '' 'Leaving 1st & 3rd cells empty'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 4 ;

    paramstruct = struct('ioverlap',1, ...
                         'titlecellstr',{{'' 'Test ioverlap = 1' 'tstat logp'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 5 ;

    paramstruct = struct('ioverlap',2, ...
                         'titlecellstr',{{'' 'Test ioverlap = 2' 'RankSum logp'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 6 ;

    paramstruct = struct('ioverlap',3, ...
                         'titlecellstr',{{'' 'Test ioverlap = 3' 'Norm Err'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 7 ;

    paramstruct = struct('ioverlap',4, ...
                         'titlecellstr',{{'' 'Test ioverlap = 4' 'Rob N Err'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 8 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',5, ...
                         'titlecellstr',{{'' 'Test ioverlap = 5' 'Median'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 9 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',6, ...
                         'titlecellstr',{{'' 'Test ioverlap = 6' 'MAD'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 10 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',7, ...
                         'titlecellstr',{{'' 'Test ioverlap = 7' 'IQR'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 11 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',8, ...
                         'titlecellstr',{{'' 'Test ioverlap = 8' 'min'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 12 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',9, ...
                         'titlecellstr',{{'' 'Test ioverlap = 9' 'max'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 13 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',10, ...
                         'titlecellstr',{{'' 'Test ioverlap = 10' 'range'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 14 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',11, ...
                         'titlecellstr',{{'' 'Test ioverlap = 11' '# unique'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 15 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',12, ...
                         'titlecellstr',{{'' 'Test ioverlap = 12' '# most freq'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 16 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',13, ...
                         'titlecellstr',{{'' 'Test ioverlap = 13' '# zeroes'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 17 ;

    disp('Test not functioning') ;
%{
    paramstruct = struct('ioverlap',14, ...
                         'titlecellstr',{{'' 'Test ioverlap = 14' 'Smallest non-0 spacing'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
%}

  elseif itest == 18 ;

    varnamecellstr = {} ;
    for i = 1:d ;
      varnamecellstr = cat(1,varnamecellstr,{['Ext. Named Variable ' num2str(i)]}) ;
    end ;
    varnamecellstr = {varnamecellstr} ;
    paramstruct = struct('titlecellstr',{{'' 'Test varnamecellstr'}}, ...
                         'varnamecellstr',varnamecellstr) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 19 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 4'}}, ...
                         'nplot',4) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 20 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 9'}}, ...
                         'nplot',9) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 21 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 16'}}, ...
                         'nplot',16) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 22 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 25'}}, ...
                         'nplot',25) ;

    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 23 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 10'}}, ...
                         'nplot',10) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 24 ;

    viplot = (1:15)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test small viplot'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 25 ;

    viplot = (36:50)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test large viplot'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 26 ;

    viplot = (1:4)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'not enough entries'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 27 ;

    viplot = (1:33)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'too many entries'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 28 ;

    viplot = (-1:13)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'negative entries'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 29 ;

    viplot = (37:51)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'entries too big'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 30 ;

    viplot = [1 ones(1,14)]' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'duplicate entries'}}, ...
                         'viplot',viplot) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 31 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 1'}}, ...
                         'icolor',1) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 32 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 0, all black'}}, ...
                         'icolor',0) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 33 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 2' 'invalid, so reset to black'}}, ...
                         'icolor',2) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 34 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'attempt to input' 'invalid icolor matrix'}}, ...
                         'icolor',icolor) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 35 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'markerstr = o'}}, ...
                         'markerstr','o') ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 36 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'markerstr = x'}}, ...
                         'markerstr','x') ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 37 ;

    icolor = [[0 1 0]; [1 0 1]] ;
    markerstr = [] ;
    for im = 1:(n / 2) ;
      markerstr = strvcat(markerstr,'+') ;
    end ;
    for im = 1:(n / 2) ;
      markerstr = strvcat(markerstr,'d') ;
    end ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'input icolor matrix' 'and markers'}}, ...
                         'icolor',icolor, ...
                         'markerstr',markerstr) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 38 ;

    icolor = [[0 1 1]; [0.7 0.7 0.7]] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 0' 'main kde only'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',0) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 39 ;

    icolor = [[0 1 0]; [1 0 1]] ;
    markerstr = [] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 1' 'main & sub kdes'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',1) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 40 ;

    icolor = [[0 1 0]; [1 0 1]] ;
    markerstr = [] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 2' 'sub kdes only'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',2) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 41 ;

    paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 0' 'no data overlay in marginals'}}, ...
                         'idatovlay',0) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 42 ;

    smdata = [] ;
    for id = 1:d ;
      smdata = [smdata; sort(mdata(id,:))] ;
    end ;
    paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 1' 'data set ordering'}}, ...
                         'idatovlay',1) ;
    MargOverlapSM(smdata,vflag,paramstruct) ;

  elseif itest == 43 ;

    smdata = [] ;
    for id = 1:d ;
      smdata = [smdata; sort(mdata(id,:))] ;
    end ;
    paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 2' 'random ordering' 'despite sorting'}}, ...
                         'idatovlay',2) ;
    MargOverlapSM(smdata,vflag,paramstruct) ;

  elseif itest == 44 ;

    paramstruct = struct('titlecellstr',{{'' 'Test ndatovlay = 10'}}, ...
                         'ndatovlay',10) ;
    MargOverlapSM(smdata,vflag,paramstruct) ;

  elseif itest == 45 ;

    paramstruct = struct('titlecellstr',{{'' 'Test ndatovlay = 10' 'and idatovlay = seed'}}, ...
                         'idatovlay',3948573, ...
                         'ndatovlay',10) ;
    MargOverlapSM(smdata,vflag,paramstruct) ;

  elseif itest == 46 ;

    paramstruct = struct('titlecellstr',{{'' 'Test datovlaymax = 0.4' 'datovlaymin = 0.1'}}, ...
                         'datovlaymax',0.4, ...
                         'datovlaymin',0.1) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 47 ;

    paramstruct = struct('titlecellstr',{{'' 'Test textht = 0.1'}}, ...
                         'textht',0.1) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 48 ;

    paramstruct = struct('titlecellstr',{{'' 'Test titlefontsize = 15'}}, ...
                         'titlefontsize',15) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 49 ;

    paramstruct = struct('titlecellstr',{{'' 'Test labelfontsize = 15'}}, ...
                         'labelfontsize',15) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 50 ;

    paramstruct = struct('titlecellstr',{{'' 'Test savestr' 'full color'}}, ...
                         'savestr','temp') ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
    disp('    Check file temp.fig') ;

  elseif itest == 51 ;

    paramstruct = struct('titlecellstr',{{'' 'Test savestr' 'black & white'}}, ...
                         'icolor',0, ...
                         'savestr','temp') ;
    MargOverlapSM(mdata,vflag,paramstruct) ;
    disp('    Check file temp.fig') ;

  elseif itest == 52 ;

    paramstruct = struct('ioverlap',1, ...
                         'titlecellstr',{{'' 'Test ioverlap = 1' 'tstat logp' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,vflag) = 3 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 53 ;

    paramstruct = struct('ioverlap',2, ...
                         'titlecellstr',{{'' 'Test ioverlap = 2' 'Rank Sum logp' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,vflag) = 3 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 54 ;

    paramstruct = struct('ioverlap',3, ...
                         'titlecellstr',{{'' 'Test ioverlap = 3' 'Norm Err' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,vflag) = 3 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 55 ;

    paramstruct = struct('ioverlap',4, ...
                         'titlecellstr',{{'' 'Test ioverlap = 4' 'Rob NErr' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,vflag) = 3 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 56 ;

    paramstruct = struct('ioverlap',1, ...
                         'titlecellstr',{{'' 'Test ioverlap = 1' 'tstat logp' 'With 0-var variable'}}) ;
    MargOverlapSM([mdata; ones(1,n)],vflag,paramstruct) ;

  elseif itest == 57 ;

    paramstruct = struct('ioverlap',2, ...
                         'titlecellstr',{{'' 'Test ioverlap = 2' 'Rank Sum logp' 'With 0-var variable'}}) ;
    MargOverlapSM([mdata; ones(1,n)],vflag,paramstruct) ;

  elseif itest == 58 ;

    paramstruct = struct('ioverlap',3, ...
                         'titlecellstr',{{'' 'Test ioverlap = 3' 'Norm Err' 'With 0-var variable'}}) ;
    MargOverlapSM([mdata; ones(1,n)],vflag,paramstruct) ;

  elseif itest == 59 ;

    paramstruct = struct('ioverlap',4, ...
                         'titlecellstr',{{'' 'Test ioverlap = 4' 'Rob NErr' 'With 0-var variable'}}) ;
    MargOverlapSM([mdata; ones(1,n)],vflag,paramstruct) ;

  elseif itest == 60 ;

    paramstruct = struct('ioverlap',1, ...
                         'titlecellstr',{{'' 'Test ioverlap = 1' 'tstat logp' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,~vflag) = -4 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 61 ;

    paramstruct = struct('ioverlap',2, ...
                         'titlecellstr',{{'' 'Test ioverlap = 2' 'Rank Sum logp' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,~vflag) = -4 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 62 ;

    paramstruct = struct('ioverlap',3, ...
                         'titlecellstr',{{'' 'Test ioverlap = 3' 'Norm Err' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,~vflag) = -4 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 63 ;

    paramstruct = struct('ioverlap',4, ...
                         'titlecellstr',{{'' 'Test ioverlap = 4' 'Rob NErr' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,~vflag) = -4 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 64 ;    %  ioverlap 5 version of itest = 63

    paramstruct = struct('ioverlap',5, ...
                         'titlecellstr',{{'' 'Test ioverlap = 5' 'Rob NErr' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,~vflag) = -4 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 65 ;    %  ioverlap 5 version of itest = 59

    paramstruct = struct('ioverlap',5, ...
                         'titlecellstr',{{'' 'Test ioverlap = 5' 'Rob NErr' 'With 0-var variable'}}) ;
    MargOverlapSM([mdata; ones(1,n)],vflag,paramstruct) ;

  elseif itest == 66 ;    %  ioverlap 5 version of itest = 55

    paramstruct = struct('ioverlap',5, ...
                         'titlecellstr',{{'' 'Test ioverlap = 5' 'Rob NErr' 'partly const variable'}}) ;
    mdatain = mdata ;
    mdatain(end,vflag) = 3 * ones(1,sum(vflag)) ;
    MargOverlapSM(mdatain,vflag,paramstruct) ;

  elseif itest == 67 ;    %  ioverlap 5 version of itest = 7

    paramstruct = struct('ioverlap',5, ...
                         'titlecellstr',{{'' 'Test ioverlap = 5' 'Rob N Err'}}) ;
    MargOverlapSM(mdata,vflag,paramstruct) ;

  elseif itest == 68 ;    %  test d = 17 version

    paramstruct = struct('titlecellstr',{{'' 'Test d = 17'}}) ;
    MargOverlapSM(mdata(1:17,:),vflag,paramstruct) ;

  elseif itest == 69 ;    %  test d = 17 version, externally defined names

    varnamecellstr = {} ;
    for i = 1:d ;
      varnamecellstr = cat(1,varnamecellstr,{['Ext. Named Variable ' num2str(i)]}) ;
    end ;
    varnamecellstr = {varnamecellstr} ;
    paramstruct = struct('titlecellstr',{{'' 'Test varnamecellstr' 'd = 17'}}, ...
                         'varnamecellstr',{varnamecellstr{1}(1:17)}) ;
    MargOverlapSM(mdata(1:17,:),vflag,paramstruct) ;

  elseif itest == 70 ;    %  test d = 16 version, externally defined names

    varnamecellstr = {} ;
    for i = 1:d ;
      varnamecellstr = cat(1,varnamecellstr,{['Ext. Named Variable ' num2str(i)]}) ;
    end ;
    varnamecellstr = {varnamecellstr} ;
    paramstruct = struct('titlecellstr',{{'' 'Test varnamecellstr' 'd = 16'}}, ...
                         'varnamecellstr',{varnamecellstr{1}(1:16)}) ;
    MargOverlapSM(mdata(1:16,:),vflag,paramstruct) ;


end ;    %  of inner itest if-block


elseif itest < 200 ;    %  test carefully chosen distributions

  randn('state',39759348755) ;
  rand('state',937948573275) ;
  d = 50 ;
  n = 200 ;


  if itest == 101 ;  %  shifting normal means: mean, sd, skewness, kurtosis
    datstr = 'Gaussian, Shifting Mean' ;
    vistat = [1 2 3 4] ;
    mdata = randn(d,n) ;
    mdata = mdata + (linspace(-5,5,d)' * ones(1,n)) ;


%{
  mdata = randn(d,n) ;

%  mdata = randn(1,n) ;
%  mdata = ones(d,1) * mdata ;

%  mdata = randn(1,n/2) ;
%  mdata = [mdata -mdata] ;
%  mdata = ones(d,1) * mdata ;

%  vmean = linspace(-5,5,d)' ;

  vmean = linspace(-0.2,0.2,d)' ;
%}



  end ;    %  of inner itest if-block


  %  randomly reshuffle data rows
  %
  [temp,vind] = sort(rand(d,1)) ;
  mdata = mdata(vind,:) ;

  for ifig = 1:length(vistat) ;
    figure(ifig) ;

    titlecellstr = {{'' datstr 'Simulated Data' ['n = ' num2str(n) ',   d = ' num2str(d)]}} ;
    savestr = ['MargOverlapSMtestPart' num2str(itest) 'Stat' num2str(vistat(ifig))] ;
    paramstruct = struct('istat',vistat(ifig), ...
                         'titlecellstr',titlecellstr, ...
                         'savestr',savestr) ;
    MargOverlapSM(mdata,paramstruct) ;

  end ;



end ;    %  of outer itest if-block



