disp('Running MATLAB script file MaxDatPilJAtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION MaxDatPilJA,
%    MAXimal DATa Piling, direction vector, gap and intercept


itest = 4 ;     %  Parts 1 & 2 do check against earlier 
                %      generalized inverse version
                %  To test warning level, use  3
                %      together with idat = 11,12,13
                %  To test against FLD, use   4
                %      together with idat = 20 


idat = 20 ;      %  index of data sets:
                %    1 - simple standard normal, d = 50, n1 = n2 = 20,
                %            piecewise mu = +-5
                %    2 - simple standard normal, d = 50, n1 = n2 = 20,
                %            piecewise mu = -+5
                %    3 - simple standard normal, d = 50, n1 = n2 = 20,
                %            piecewise mu = +-0.5
                %    4 - simple standard normal, d = 50, n1 = n2 = 20,
                %            piecewise mu = 0
                %    5 - simple standard normal, d = 500, n1 = n2 = 100,
                %            piecewise mu = -10,-20
                %    6 - simple standard normal, d = 1000, n1 = n2 = 100,
                %            piecewise mu = -10,-20
                %    7 - simple standard normal, d = 2000, n1 = n2 = 100,
                %            piecewise mu = -10,-20
                %    8 - simple standard normal, d = 100, n1 = n2 = 2000,
                %            piecewise mu = -10,-20
                %   10 - decreasing eigenvalues, d = 60, n1 = n2 = 20,
                %            piecewise mu = 0
                %   11 - faster decreasing eigenvalues, d = 60, n1 = n2 = 20,
                %            piecewise mu = 0
                %   12 - faster decreasing eigenvalues, d = 60, n1 = n2 = 100,
                %            piecewise mu = 0
                %   13 - some 0 eigenvalues, d = 60, n1 = n2 = 20,
                %            piecewise mu = 0
                %   20 - not HDLSS, d = 20, n1 = n2 = 50 
                %            piecewise mu = 1


figure(1) ;
clf ;


if  idat == 1  | ...
    idat == 2  | ...
    idat == 3  | ...
    idat == 4  ;

  d = 50 ;
  n1 = 20 ;
  n2 = 20; ;
  if idat == 1 ; 
    mu = 5 ;
  elseif idat == 2 ; 
    mu = -5 ;
  elseif idat == 3 ; 
    mu = 0.5 ;
  elseif idat == 4 ; 
    mu = 0 ;
  end ;

  seed = 57027509327 ;
  rng(seed) ;

  mdata1 = randn(d,n1) + mu * ones(d,n1) ;
  mdata2 = randn(d,n2) - mu * ones(d,n2) ;


elseif  idat == 5  | ...
        idat == 6  | ...
        idat == 7  | ...
        idat == 8  ;

  if idat == 5 ;
    d = 500 ;
    n1 = 100 ;
    n2 = 100; ;
  elseif idat == 6 ;
    d = 1000 ;
    n1 = 100 ;
    n2 = 100; ;
  elseif idat == 7 ;
    d = 2000 ;
    n1 = 100 ;
    n2 = 100; ;
  elseif idat == 8 ;
    d = 100 ;
    n1 = 2000 ;
    n2 = 2000; ;
  end ;
  mu1 = -10 ;
  mu2 = -20 ;

  seed = 57027509327 ;
  rng(seed) ;

  mdata1 = randn(d,n1) + mu1 * ones(d,n1) ;
  mdata2 = randn(d,n2) + mu2 * ones(d,n2) ;


elseif  idat == 10  | ...
        idat == 11  | ...
        idat == 12  | ...
        idat == 13  ;

  d = 60 ;
  if idat == 10  ;
    n1 = 20 ;
    n2 = 20 ;
    veigv = (10.^(-1:-1:-20))' ;
    veigv = [veigv; veigv; veigv] ;
  elseif idat == 11  ;
    n1 = 20 ;
    n2 = 20 ;
    veigv = (10.^(-1:-1:-60))' ;
  elseif idat == 12  ;
    n1 = 100 ;
    n2 = 100 ;
    veigv = (10.^(-1:-1:-60))' ;
  elseif idat == 13  ;
    n1 = 20 ;
    n2 = 20 ;
    veigv = [ones(30,1); zeros(30,1)] ;
  end ;

  seed = 787450897520 ;
  rng(seed) ;

  mdata1 = (veigv * ones(1,n1)) .* randn(d,n1) ;
  mdata2 = (veigv * ones(1,n1)) .* randn(d,n2) ;


elseif  idat == 20  ;

  d = 20 ;
  n1 = 50 ;
  n2 = 50 ;
  mu = 1 ;

  seed = 702938897520 ;
  rng(seed) ;

  mdata1 = randn(d,n1) + mu * ones(d,n1) ;
  mdata2 = randn(d,n2) - mu * ones(d,n2) ;



end ;    %  of idat if-block




if itest == 1 ;     %  test Original vs. Fast implementations

  np = size(mdata1,2) ;
  nn = size(mdata2,2) ;
  mdata = [mdata1 mdata2] ;
  mresid = mdata - vec2matSM(mean(mdata,2),np+nn) ;
  mcov = cov(mresid') ;
      %  Get covariance matrix, transpose, since want 
      %               "coordinates as variables"
      %  This gives "overall covariance"
  mcovinv = pinv(mcov) ;
      %  pseudo-inverse

  vmeanp = mean(mdata1,2) ;
  vmeann = mean(mdata2,2) ;
  vmeandiff = vmeanp - vmeann ;
  MDPdir = mcovinv * vmeandiff ;
  dirO = MDPdir / norm(MDPdir) ;
      %  maximal data piling direction vector
  gapO = vmeandiff' * dirO ;
  intO = ((vmeanp + vmeann) / 2)' * dirO ;


  [dirF,gapF,intF] = MaxDatPilJA(mdata1,mdata2) ;

%  disp('  Original direction vector is:') ;
%  dirO

%  disp('  Fast direction vector is:') ;
%  dirF

  disp('  Euclidean distance between is: ') ;
  norm(dirO - dirF)

  disp('  Max Difference is: ') ;
  max(abs(dirO - dirF)) ;


  disp('  Original gap is: ') ;
  gapO

  disp('  Fast gap is: ') ;
  gapF

  disp('  Difference between gaps is: ') ;
  gapO - gapF


  disp('  Original Intercept is: ') ;
  intO

  disp('  Fast Intercept is: ') ;
  intF

  disp('  Difference between Intercepts is: ') ;
  intO - intF


  disp('  Standard Deviation of Original Projected 1st data set is:') ;
  std(mdata1' * dirO)

  disp('  Standard Deviation of Fast Projected 1st data set is:') ;
  std(mdata1' * dirF)

  disp('  Standard Deviation of Original Projected 2nd data set is:') ;
  std(mdata2' * dirO)

  disp('  Standard Deviation of Fast Projected 2nd data set is:') ;
  std(mdata2' * dirF)



  %  Show 1-d Projections
  %
  subplot(2,1,1) ;
    icolor = [[ones(n1,1) * [0 0 1]]; [ones(n1,1) * [1 0 0]]] ;
    markerstr = 'o' ;
    for i = 2:n1 ;
      markerstr = strvcat(markerstr,'o') ;
    end ;
    for i = 1:n2 ;
      markerstr = strvcat(markerstr,'+') ;
    end ;

    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'datovlaymax',0.8, ...
                         'datovlaymin',0.2, ...
                         'titlestr',['Test Data Piling Directions, idat = ' num2str(idat)], ...
                         'xlabelstr','Original MDP Direction', ...
                         'iscreenwrite',1) ;
    projplot1SM([mdata1 mdata2],dirO,paramstruct) ;

  subplot(2,1,2) ;
    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'datovlaymax',0.8, ...
                         'datovlaymin',0.2, ...
                         'xlabelstr','Fast MDP Direction', ...
                         'iscreenwrite',1) ;
    projplot1SM([mdata1 mdata2],dirF,paramstruct) ;



elseif itest == 2 ;     %  time trials


  tic ;

    np = size(mdata1,2) ;
    nn = size(mdata2,2) ;
    mdata = [mdata1 mdata2] ;
    mresid = mdata - vec2matSM(mean(mdata,2),np+nn) ;
    mcov = cov(mresid') ;
        %  Get covariance matrix, transpose, since want 
        %               "coordinates as variables"
        %  This gives "overall covariance"
    mcovinv = pinv(mcov) ;
        %  pseudo-inverse

    vmeanp = mean(mdata1,2) ;
    vmeann = mean(mdata2,2) ;
    vmeandiff = vmeanp - vmeann ;
    MDPdir = mcovinv * vmeandiff ;
    dirO = MDPdir / norm(MDPdir) ;
        %  maximal data piling direction vector
    gapO = vmeandiff' * MDPdir ;
    intO = ((vmeanp + vmeann) / 2)' * MDPdir ;

  rtimeO = toc ;
  
  disp(['Original Implementation took: ' num2str(rtimeO) ' secs']) ;


  tic ;
    [dirF,gapF,intF] = MaxDatPilJA(mdata1,mdata2) ;
  rtimeF = toc ;
  
  disp(['Original Implementation took: ' num2str(rtimeF) ' secs']) ;



elseif itest == 3 ;     %  test warning levels

  disp('  Test No Warning:') ;
  [MDPdir,MDPgap,MDPint] = MaxDatPilJA(mdata1,mdata2,0) ;
  MDPdir([1 2 (end-1) end])'
  MDPgap
  MDPint
  pauseSM ;

  disp('  Test Print Warning Only:') ;
  [MDPdir,MDPgap,MDPint] = MaxDatPilJA(mdata1,mdata2,1) ;
  MDPdir([1 2 (end-1) end])'
  MDPgap
  MDPint
  pauseSM ;

  disp('  Test Print Warning and 0s:') ;
  [MDPdir,MDPgap,MDPint] = MaxDatPilJA(mdata1,mdata2,2) ;
  if length(MDPdir) > 1 ;
    MDPdir([1 2 (end-1) end])'
  else ;
    MDPdir
  end ;
  MDPgap
  MDPint
  pauseSM ;

  disp('  Test Bad wrning reverts to default:') ;
  if length(MDPdir) > 1 ;
    MDPdir([1 2 (end-1) end])'
  else ;
    MDPdir
  end ;
  MDPgap
  MDPint
  [MDPdir,MDPgap,MDPint] = MaxDatPilJA(mdata1,mdata2,3) ;



elseif itest == 4 ;     %  test MDP vs. FLD

  np = size(mdata1,2) ;
  nn = size(mdata2,2) ;
  vmeanp = mean(mdata1,2) ;
  vmeann = mean(mdata2,2) ;
  mresidp = mdata1 - vec2matSM(vmeanp,np) ;
  mresidn = mdata2 - vec2matSM(vmeann,nn) ;
  mcovp = cov(mresidp') ;
  mcovn = cov(mresidn') ;
  mcov = ((np - 1) * mcovp + (nn - 1) * mcovn) / (np + nn - 1) ;
      %  Get covariance matrix, transpose, since want 
      %               "coordinates as variables"
      %  This gives "overall covariance"
  mcovinv = pinv(mcov) ;
      %  pseudo-inverse

  vmeandiff = vmeanp - vmeann ;
  FLDdir = mcovinv * vmeandiff ;
  FLDdir = FLDdir / norm(FLDdir) ;
      %  maximal data piling direction vector
  FLDgap = vmeandiff' * FLDdir ;
  FLDint = ((vmeanp + vmeann) / 2)' * FLDdir ;


  [MDPdir,MDPgap,MDPint] = MaxDatPilJA(mdata1,mdata2) ;

%  disp('  Original direction vector is:') ;
%  FLDdir

%  disp('  Fast direction vector is:') ;
%  MDPdir

  disp('  Euclidean distance between is: ') ;
  norm(FLDdir - MDPdir)

  disp('  Max Difference is: ') ;
  max(abs(FLDdir - MDPdir)) 


  disp('  Original gap is: ') ;
  FLDgap

  disp('  Fast gap is: ') ;
  MDPgap

  disp('  Difference between gaps is: ') ;
  FLDgap - MDPgap


  disp('  Original Intercept is: ') ;
  FLDint

  disp('  Fast Intercept is: ') ;
  MDPint

  disp('  Difference Between Intercepts is: ') ;
  FLDint - MDPint


  disp('  Standard Deviation of Original Projected 1st data set is:') ;
  std(mdata1' * FLDdir)

  disp('  Standard Deviation of Fast Projected 1st data set is:') ;
  std(mdata1' * MDPdir)

  disp('  Standard Deviation of Original Projected 2nd data set is:') ;
  std(mdata2' * FLDdir)

  disp('  Standard Deviation of Fast Projected 2nd data set is:') ;
  std(mdata2' * MDPdir)



  %  Show 1-d Projections
  %
  subplot(2,1,1) ;
    icolor = [[ones(n1,1) * [0 0 1]]; [ones(n1,1) * [1 0 0]]] ;
    markerstr = 'o' ;
    for i = 2:n1 ;
      markerstr = strvcat(markerstr,'o') ;
    end ;
    for i = 1:n2 ;
      markerstr = strvcat(markerstr,'+') ;
    end ;

    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'datovlaymax',0.8, ...
                         'datovlaymin',0.2, ...
                         'titlestr',['Test MDP against FLD, idat = ' num2str(idat)], ...
                         'xlabelstr','FLD Direction', ...
                         'iscreenwrite',1) ;
    projplot1SM([mdata1 mdata2],FLDdir,paramstruct) ;

  subplot(2,1,2) ;
    paramstruct = struct('icolor',icolor, ...
                         'markerstr',markerstr, ...
                         'datovlaymax',0.8, ...
                         'datovlaymin',0.2, ...
                         'xlabelstr','MDP Direction', ...
                         'iscreenwrite',1) ;
    projplot1SM([mdata1 mdata2],MDPdir,paramstruct) ;



end ;    %  of itest if-block



