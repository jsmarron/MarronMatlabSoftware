disp('Running MATLAB script file MargDistPlotSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION MargDistPlotSM,
%    Marginal Distribution Plot



itest = 102 ;     %  1,2,...,58       tests beased on d = 50, n = 100
                 %  71,72     tests based on d = 16, n = 100
                 %  101 shifting normal means: mean, sd, skewness, kurtosis
                 %  102 shifting sd: mean, sd, skewness, kurtosis
                 %  103 power transformed: mean, sd, skewness, kurtosis
                 %  104 bimodal, separating and tightening: mean, sd, skewness, kurtosis
                 %  105 bimodal, shifting weight: mean, sd, skewness, kurtosis
                 %  106 Bernoulli, shifting p: mean, sd, skewness, kurtosis
                 %  107 Bernoulli, shifting p: range, # unique, # most freq, # 0s 
                 %  108 Poisson, shifting lambda: mean, sd, skewness, kurtosis
                 %  109 Poisson, shifting lambda: range, # unique, # most freq, # 0s
                 %  110 Mixtures of 0 and Gaussian: mean, sd, skewness, kurtosis
                 %  111 Mixtures of 0 and Gaussian: range, # unique, # most freq, # 0s
                 %  112 Poisson, shifting lambda: median, IQR, MAD, Bowley Skewness
                 %  113 Poisson, shifting lambda: # most freq, # unique, Cont Ind, Entropy
                 %  114 Poisson, shifting lambda: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
                 %  115 Mixtures of 0 and Gaussian: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
                 %  116 Bernoulli, shifting p: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
                 %  117 bimodal, shifting weight: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
                 %  118 bimodal, separating and tightening: Mean,1st L-stat, 2nd L-stat, 3rd L-stat
                 %  119 power transformed: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
                 %  201 Rescaled Gaussians & Outliers, SD, MAD, IQR, Entropy, 2nd L-stat
                 %  202 Skewed Gaussian Mixtures & Outliers, Skewness, Bowley's Skewness, 3rd L-stat
                 %  203 Kurtotic Gaussian Mixtures & Outliers, Kurtosis, 4th L-stat


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
    itest == 58  ;    %  Work with simplest data set

  figure(1) ;
  clf ;

  %  Generate Data
  %
  d = 50 ;
  n = 100 ;
  rng(93874209) ;
  mdata = randn(d,n) ;
  scalefact = logspace(log10(0.2),log10(20),d) ;
  mdata = diag(flipud(scalefact')) * mdata ;

  if itest == 1 ; 

    disp('  Running with all defaults only') ;
    MargDistPlotSM(mdata) ;

  elseif itest == 2 ;

    paramstruct = struct('titlecellstr',{{'Test' 'Title' 'Cell' 'String'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 3 ;

    paramstruct = struct('titlecellstr',{{'' 'Test Title Cell String' '' 'Leaving 1st & 3rd cells empty'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 4 ;

    paramstruct = struct('istat',1, ...
                         'titlecellstr',{{'' 'Test istat = 1' 'Mean'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 5 ;

    paramstruct = struct('istat',2, ...
                         'titlecellstr',{{'' 'Test istat = 2' 'SD'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 6 ;

    paramstruct = struct('istat',3, ...
                         'titlecellstr',{{'' 'Test istat = 3' 'Skewness'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 7 ;

    paramstruct = struct('istat',4, ...
                         'titlecellstr',{{'' 'Test istat = 4' 'Kurtosis'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 8 ;

    paramstruct = struct('istat',5, ...
                         'titlecellstr',{{'' 'Test istat = 5' 'Median'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 9 ;

    paramstruct = struct('istat',6, ...
                         'titlecellstr',{{'' 'Test istat = 6' 'MAD'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 10 ;

    paramstruct = struct('istat',7, ...
                         'titlecellstr',{{'' 'Test istat = 7' 'IQR'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 11 ;

    paramstruct = struct('istat',8, ...
                         'titlecellstr',{{'' 'Test istat = 8' 'min'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 12 ;

    paramstruct = struct('istat',9, ...
                         'titlecellstr',{{'' 'Test istat = 9' 'max'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 13 ;

    paramstruct = struct('istat',10, ...
                         'titlecellstr',{{'' 'Test istat = 10' 'range'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 14 ;

    paramstruct = struct('istat',11, ...
                         'titlecellstr',{{'' 'Test istat = 11' '# unique'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 15 ;

    paramstruct = struct('istat',12, ...
                         'titlecellstr',{{'' 'Test istat = 12' '# most freq'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 16 ;

    paramstruct = struct('istat',13, ...
                         'titlecellstr',{{'' 'Test istat = 13' '# zeroes'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 17 ;

    paramstruct = struct('istat',14, ...
                         'titlecellstr',{{'' 'Test istat = 14' 'Smallest non-0 spacing'}}) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 18 ;

    varnamecellstr = {} ;
    for i = 1:d ;
      varnamecellstr = cat(1,varnamecellstr,{['Ext. Named Variable ' num2str(i)]}) ;
    end ;
    varnamecellstr = {varnamecellstr} ;
    paramstruct = struct('titlecellstr',{{'' 'Test varnamecellstr'}}, ...
                         'varnamecellstr',varnamecellstr) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 19 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 4'}}, ...
                         'nplot',4) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 20 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 9'}}, ...
                         'nplot',9) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 21 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 16'}}, ...
                         'nplot',16) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 22 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 25'}}, ...
                         'nplot',25) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 23 ;

    paramstruct = struct('titlecellstr',{{'' 'Test nplot = 10'}}, ...
                         'nplot',10) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 24 ;

    viplot = (1:15)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test small viplot'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 25 ;

    viplot = (36:50)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test large viplot'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 26 ;

    viplot = (1:4)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'not enough entries'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 27 ;

    viplot = (1:33)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'too many entries'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 28 ;

    viplot = (-1:13)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'negative entries'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 29 ;

    viplot = (37:51)' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'entries too big'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 30 ;

    viplot = [1 ones(1,14)]' ;
    paramstruct = struct('titlecellstr',{{'' 'Test invalid viplot' 'duplicate entries'}}, ...
                         'viplot',viplot) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 31 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 1'}}, ...
                         'icolor',1) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 32 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 0, all black'}}, ...
                         'icolor',0) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 33 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'icolor = 2, rainbow'}}, ...
                         'icolor',2) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 34 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'input icolor matrix'}}, ...
                         'icolor',icolor) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 35 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'markerstr = o'}}, ...
                         'markerstr','o') ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 36 ;

    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'markerstr = x'}}, ...
                         'markerstr','x') ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 37 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
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
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 38 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 0' 'main kde only'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',0) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 39 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 1' 'main & sub kdes'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',1) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 40 ;

    icolor = ones(n / 2,1) * [0 1 0] ;
    icolor = [icolor; (ones(n / 2,1) * [1 0 1])] ;
    paramstruct = struct('titlecellstr',{{'' 'Test manually set' 'isubplotkde = 2' 'sub kdes only'}}, ...
                         'icolor',icolor, ...
                         'isubpopkde',2) ;
    MargDistPlotSM(mdata,paramstruct) ;

  elseif itest == 41 ;

    paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 0' 'no data overlay on diagonals'}}, ...
                         'idatovlay',0) ;
    MargDistPlotSM(mdata,paramstruct) ;

  else ;

    smdata = [] ;
    for id = 1:d ;
      smdata = [smdata; sort(mdata(id,:))] ;
    end ;

    if itest == 42 ;

      paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 1' 'data set ordering'}}, ...
                           'idatovlay',1) ;
      MargDistPlotSM(smdata,paramstruct) ;

    elseif itest == 43 ;

      smdata = [] ;
      for id = 1:d ;
        smdata = [smdata; sort(mdata(id,:))] ;
      end ;
      paramstruct = struct('titlecellstr',{{'' 'Test idatovlay = 2' 'random ordering' 'despite sorting'}}, ...
                           'idatovlay',2) ;
      MargDistPlotSM(smdata,paramstruct) ;

    elseif itest == 44 ;

      paramstruct = struct('titlecellstr',{{'' 'Test ndatovlay = 10'}}, ...
                           'ndatovlay',10) ;
      MargDistPlotSM(smdata,paramstruct) ;

    elseif itest == 45 ;

      paramstruct = struct('titlecellstr',{{'' 'Test ndatovlay = 10' 'and idatovlay = seed'}}, ...
                           'idatovlay',3948573, ...
                           'ndatovlay',10) ;
      MargDistPlotSM(smdata,paramstruct) ;

    elseif itest == 46 ;

      paramstruct = struct('titlecellstr',{{'' 'Test datovlaymax = 0.4' 'datovlaymin = 0.1'}}, ...
                           'datovlaymax',0.4, ...
                           'datovlaymin',0.1) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 47 ;

      paramstruct = struct('titlecellstr',{{'' 'Test textht = 0.1'}}, ...
                           'textht',0.1) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 48 ;

      paramstruct = struct('titlecellstr',{{'' 'Test titlefontsize = 15'}}, ...
                           'titlefontsize',15) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 49 ;

      paramstruct = struct('titlecellstr',{{'' 'Test labelfontsize = 15'}}, ...
                           'labelfontsize',15) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 50 ;

      paramstruct = struct('titlecellstr',{{'' 'Test savestr' 'full color'}}, ...
                           'savestr','temp') ;
      MargDistPlotSM(mdata,paramstruct) ;
      disp('    Check file temp.ps') ;

    elseif itest == 51 ;

      paramstruct = struct('titlecellstr',{{'' 'Test savestr' 'black & white'}}, ...
                           'icolor',0, ...
                           'savestr','temp') ;
      MargDistPlotSM(mdata,paramstruct) ;
      disp('    Check file temp.ps') ;

    elseif itest == 52 ;

      paramstruct = struct('istat',15, ...
                           'titlecellstr',{{'' 'Test istat = 15' 'Continuity Index'}}) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 53 ;

      paramstruct = struct('istat',16, ...
                           'titlecellstr',{{'' 'Test istat = 16' 'Entropy'}}) ;
      MargDistPlotSM(mdata,paramstruct) ;
      disp(['    Note: log(n) = ' num2str(log(n))]) ;

    elseif itest == 54 ;

      paramstruct = struct('istat',17, ...
                           'titlecellstr',{{'' 'Test istat = 17' 'BowleySkewness'}}) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 55 ;

      paramstruct = struct('istat',18, ...
                           'titlecellstr',{{'' 'Test istat = 18' '2nd L-stat Ratio'}}) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 56 ;

      paramstruct = struct('istat',19, ...
                           'titlecellstr',{{'' 'Test istat = 19' '3rd L-stat Ratio'}}) ;
      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 57 ;

      paramstruct = struct('istat',20, ...
                           'titlecellstr',{{'' 'Test istat = 20' '4th L-stat Ratio'}}) ;

      MargDistPlotSM(mdata,paramstruct) ;

    elseif itest == 58 ;

      paramstruct = struct('istat',2, ...
                           'titlecellstr',{{'' 'Test istat = 2' 'SD' 'With 0-var variable'}}) ;
      MargDistPlotSM([mdata; ones(1,n)],paramstruct) ;

    end ;    %  of inner-inner itest if-block


  end ;    %  of inner itest if-block

elseif itest < 100 ;    %  do test with 16 variables


  figure(1) ;
  clf ;

  %  Generate Data
  %
  d = 16 ;
  n = 100 ;
  randn('state',9387420937) ;
  mdata = randn(d,n) ;
  scalefact = logspace(log10(0.2),log10(20),d) ;
  mdata = diag(flipud(scalefact')) * mdata ;


  if itest == 71 ;

    paramstruct = struct('istat',2, ...
                         'titlecellstr',{{'' 'Test istat = 2' 'SD' ['d = ' num2str(d)]}}) ;
    MargDistPlotSM(mdata,paramstruct) ;


  elseif itest == 72 ;


    varnamecellstr = {} ;
    for i = 1:d ;
      varnamecellstr = cat(1,varnamecellstr,{['Ext. Named Variable ' num2str(i)]}) ;
    end ;
    varnamecellstr = {varnamecellstr} ;
    paramstruct = struct('istat',2, ...
                         'titlecellstr',{{'' 'Test varnamecellstr' ['d = ' num2str(d)]}}, ...
                         'varnamecellstr',varnamecellstr) ;
    MargDistPlotSM(mdata,paramstruct) ;


  end ;


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

  elseif itest == 102 ;  %  shifting sd: mean, sd, skewness, kurtosis
    datstr = 'Gaussian, Shifting SD' ;
    vistat = [1 2 3 4] ;
    mdata = randn(d,n) ;
    mdata = mdata .* (linspace(0.3,3,d)' * ones(1,n)) ;

  elseif itest == 103 ;  %  power transformed: mean, sd, skewness, kurtosis
    datstr = 'Gaussian, power transd' ;
    vistat = [1 2 3 4] ;
    mdata = randn(d,n) + 4 ;
    mdata = mdata .^ (linspace(0.3,3,d)' * ones(1,n)) ;

  elseif itest == 104 ;  %  bimodal, separating and tightening: mean, sd, skewness, kurtosis
    datstr = 'Bimodal, sep & tight' ;
    vistat = [1 2 3 4] ;
    mdata = (randn(d,n / 2) + (linspace(2,5,d)' * ones(1,n / 2))) ...
                                .* (linspace(1,0.2,d)' * ones(1,n / 2)) ;
    mdata = [mdata ((randn(d,n / 2) - (linspace(2,5,d)' * ones(1,n / 2))) ...
                                .* (linspace(1,0.2,d)' * ones(1,n / 2)))] ;

  elseif itest == 105 ;  %  bimodal, shifting weight: mean, sd, skewness, kurtosis
    datstr = 'Bimodal, shifting wt' ;
    vistat = [1 2 3 4] ;
    mdata = [] ;
    for id = 1:d ;
      mdata = [mdata; [(randn(1,round(n * (id / (d + 1))))  + 4) ...
                       (randn(1,round(n * ((d - id + 1) / (d + 1)))) - 4)]] ;
    end ;

  elseif itest == 106 ;  %  Bernoulli, shifting p: mean, sd, skewness, kurtosis
    datstr = 'Bernoulli, shifting p' ;
    vistat = [1 2 3 4] ;
    mdata = rand(d,n) ;
    mdata = (mdata > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;

  elseif itest == 107 ;  %  Bernoulli, shifting p: range, # unique, # most freq, # 0s 
    datstr = 'Bernoulli, shifting p' ;
    vistat = [10 11 12 13] ;
    mdata = rand(d,n) ;
    mdata = (mdata > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;

  elseif itest == 108 ;  %  Poisson, shifting lambda: mean, sd, skewness, kurtosis
    datstr = 'Poisson, shifting \lambda' ;
    vistat = [1 2 3 4] ;
    lambda = vec2matSM(logspace(log10(0.2),log10(20),d)',n) ;
    mdata = poissrnd(lambda) ;

  elseif itest == 109 ;  %  Poisson, shifting lambda: range, # unique, # most freq, # 0s
    datstr = 'Poisson, shifting \lambda' ;
    vistat = [10 11 12 13] ;
    lambda = vec2matSM(logspace(log10(0.2),log10(20),d)',n) ;
    mdata = poissrnd(lambda) ;

  elseif itest == 110 ;  %  Mixtures of 0 and Gaussian: mean, sd, skewness, kurtosis
    datstr = 'Mix of Gaussian & 0' ;
    vistat = [1 2 3 4] ;
    mdata = randn(d,n) + 2 ;
    flag = (rand(d,n) > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;
    mdata = mdata .* flag ;

  elseif itest == 111 ;  %  Mixtures of 0 and Gaussian: range, # unique, # most freq, # 0s
    datstr = 'Mix of Gaussian & 0' ;
    vistat = [10 11 12 13] ;
    mdata = randn(d,n) + 2 ;
    flag = (rand(d,n) > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;
    mdata = mdata .* flag ;

  elseif itest == 112 ;  %  Poisson, shifting lambda: median, IQR, MAD, Bowley Skewness
    datstr = 'Poisson, shifting \lambda' ;
    vistat = [5 6 7 17] ;
    lambda = vec2matSM(logspace(log10(0.2),log10(20),d)',n) ;
    mdata = poissrnd(lambda) ;

  elseif itest == 113 ;  %  Poisson, shifting lambda: # most freq, # unique, Cont Ind, Entropy
    datstr = 'Poisson, shifting \lambda' ;
    vistat = [12 11 15 16] ;
    lambda = vec2matSM(logspace(log10(0.2),log10(20),d)',n) ;
    mdata = poissrnd(lambda) ;

  elseif itest == 114 ;  %  Poisson, shifting lambda: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Poisson, shifting \lambda' ;
    vistat = [1 18 19 20] ;
    lambda = vec2matSM(logspace(log10(0.2),log10(20),d)',n) ;
    mdata = poissrnd(lambda) ;

  elseif itest == 115 ;  %  Mixtures of 0 and Gaussian: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Mix of Gaussian & 0' ;
    vistat = [1 18 19 20] ;
    mdata = randn(d,n) + 2 ;
    flag = (rand(d,n) > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;
    mdata = mdata .* flag ;

  elseif itest == 116 ;  %  Bernoulli, shifting p: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Bernoulli, shifting p' ;
    vistat = [1 18 19 20] ;
    mdata = rand(d,n) ;
    mdata = (mdata > (linspace(1 / (d + 1),d / (d + 1),d)' * ones(1,n))) ;

  elseif itest == 117 ;  %  bimodal, shifting weight: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Bimodal, shifting wt' ;
    vistat = [1 18 19 20] ;
    mdata = [] ;
    for id = 1:d ;
      mdata = [mdata; [(randn(1,round(n * (id / (d + 1))))  + 4) ...
                       (randn(1,round(n * ((d - id + 1) / (d + 1)))) - 4)]] ;
    end ;

  elseif itest == 118 ;  %  bimodal, separating and tightening: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Bimodal, sep & tight' ;
    vistat = [1 18 19 20] ;
    mdata = (randn(d,n / 2) + (linspace(2,5,d)' * ones(1,n / 2))) ...
                                .* (linspace(1,0.2,d)' * ones(1,n / 2)) ;
    mdata = [mdata ((randn(d,n / 2) - (linspace(2,5,d)' * ones(1,n / 2))) ...
                                .* (linspace(1,0.2,d)' * ones(1,n / 2)))] ;

  elseif itest == 119 ;  %  power transformed: Mean, 1st L-stat, 2nd L-stat, 3rd L-stat
    datstr = 'Gaussian, power transd' ;
    vistat = [1 18 19 20] ;
    mdata = randn(d,n) + 4 ;
    mdata = mdata .^ (linspace(0.3,3,d)' * ones(1,n)) ;

  end ;



  %  randomly reshuffle data rows
  %
  [temp,vind] = sort(rand(d,1)) ;
  mdata = mdata(vind,:) ;

  for ifig = 1:4 ;
    figure(ifig) ;

    titlecellstr = {{'' datstr 'Simulated Data' ['n = ' num2str(n) ',   d = ' num2str(d)]}} ;
    savestr = ['MargDistPlotSMtestPart' num2str(itest) 'Stat' num2str(vistat(ifig))] ;
    paramstruct = struct('istat',vistat(ifig), ...
                         'titlecellstr',titlecellstr, ...
                         'savestr',savestr) ;
    MargDistPlotSM(mdata,paramstruct) ;

  end ;


else ;

  randn('state',6543656035) ;
  rand('state',1346333864) ;
  d = 15 ;
  n = 2000 ;


  if itest == 201 ;    %  Rescaled Gaussians & Outliers, SD, MAD, IQR, Entropy, 2nd L-stat
    datstr = 'Rescaled Gaussians & Outliers' ;
    vistat = [2 6 7 16 18] ;

    vsig = 2 .^ linspace(-3,0,d) ;
    mdata = diag(vsig) * randn(d,n) ;
    noutmax = 15 ;
    mdata(:,1) = -15 * ones(d,1) ; 
    mdata(:,2) = 15 * ones(d,1) ; 
    for i = 1:d ;
      inout = floor(noutmax * rand(1)) ;
      mdata(i,3:(inout + 2)) = 10 * rand(1,inout) - 15 ;
      mdata(i,(inout + 3):(2 * inout + 2)) = 10 * rand(1,inout) + 5 ;
    end ;

  elseif itest == 202 ;    %  Skewed Gaussian Mixtures & Outliers, Skewness, Bowley's Skewness, 3rd L-stat
    datstr = 'Skewed Mixtures & Outliers' ;
    vistat = [3 17 19] ;

    vwt = linspace(0.1,0.9,d)' ;
    mdata = randn(d,n) -2 + 4 * (rand(d,n) > (vwt * ones(1,n))) ;
    noutmax = 15 ;
    mdata(:,1) = -30 * ones(d,1) ; 
    mdata(:,2) = 30 * ones(d,1) ; 
    for i = 1:d ;
      inout = floor(noutmax * rand(1)) ;
      mdata(i,3:(inout + 2)) = 15 * rand(1,inout) - 30 ;
      mdata(i,(noutmax - inout + 3):(2 * (noutmax - inout) + 2)) = 15 * rand(1,noutmax - inout) + 15 ;
    end ;

  elseif itest == 203 ;    %  Kurtotic Gaussian Mixtures & Outliers, Kurtosis, 4th L-stat
    datstr = 'Kurtotic Mixtures & Outliers' ;
    vistat = [4 20] ;

    vwt = linspace(0,0.5,d)' ;
    flag = (rand(d,n) > (vwt * ones(1,n))) ;
    mdata = randn(d,n) .* (1 + 4 * flag)  ;
    mdata = mdata ./ (std(mdata,0,2) * ones(1,n)) ;
    noutmax = 15 ;
    mdata(:,1) = -15 * ones(d,1) ; 
    mdata(:,2) = 15 * ones(d,1) ; 
    for i = 1:d ;
      inout = floor(noutmax * rand(1)) ;
      mdata(i,3:(inout + 2)) = 10 * rand(1,inout) - 15 ;
      mdata(i,(inout + 3):(2 * inout + 2)) = 10 * rand(1,inout) + 5 ;
    end ;

  end ;    %  of inner itest if-block


  %  randomly reshuffle data rows
  %
  [temp,vind] = sort(rand(d,1)) ;
  mdata = mdata(vind,:) ;

  for ifig = 1:length(vistat) ;
    figure(ifig) ;

    titlecellstr = {{'' datstr 'Simulated Data' ['n = ' num2str(n) ',   d = ' num2str(d)]}} ;
    savestr = ['MargDistPlotSMtestPart' num2str(itest) 'Stat' num2str(vistat(ifig))] ;
    paramstruct = struct('istat',vistat(ifig), ...
                         'titlecellstr',titlecellstr, ...
                         'savestr',savestr) ;
    MargDistPlotSM(mdata,paramstruct) ;

  end ;



end ;    %  of outer itest if-block



