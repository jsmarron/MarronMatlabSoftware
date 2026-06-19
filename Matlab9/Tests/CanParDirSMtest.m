disp('Running MATLAB script file CanParDirSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION CanParDirSM,
%    CANonical PARallel DIRection

itest = 9 ;     %  1,...,9


if itest == 1 ;
  teststr = 'Complete Defaults with Simple Example Data' ;
  idata = 1 ;
elseif itest == 2 ;
  teststr = 'Test iout = 0, with Simple Example Data' ;
  iout = 0 ;
  idata = 1 ;
elseif itest == 3 ;
  teststr = 'Test iout = 1, with Simple Example Data' ;
  iout = 1 ;
  idata = 1 ;
elseif itest == 4 ;
  teststr = 'Test iout = 2, with Simple Example Data' ;
  iout = 2 ;
  idata = 1 ;
elseif itest == 5 ;
  teststr = 'Test iout = 3, with Simple Example Data' ;
  iout = 3 ;
  idata = 1 ;
elseif itest == 6 ;
  teststr = 'Simple Example Data' ;
  iout = 2 ;
  idata = 1 ;
elseif itest == 7 ;
  teststr = 'Stretched Example Data' ;
  iout = 2 ;
  idata = 2 ;
elseif itest == 8 ;
  teststr = 'Shifted Example Data' ;
  iout = 2 ;
  idata = 3 ;
elseif itest == 9 ;
  teststr = 'Standard Normal Data' ;
  iout = 2 ;
  idata = 4 ;
end


rng(74093987) ;
    %  Seed for random number generation

if idata == 1     %  Simple Example Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = ones(d,n) + randn(d,n) ;

elseif idata == 2     %  Stretched Example Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = 100 * ones(d,n) + randn(d,n) ;

elseif idata == 3     %  Shifted Example Data

  n = 10 ;
  d = 100 ;
  mmeanX = [(20 * ones(1,n)); zeros(d - 1,n)] ;
  mX = mmeanX + randn(d,n) ;
  mmeanY = [zeros(1,n); (100 * ones(1,n)); zeros(d - 2,n)] ;
  mY = mmeanY + randn(d,n) ;

elseif idata == 4     %  Standard Normal Data

  n = 10 ;
  d = 100 ;
  mX = randn(d,n) ;
  mY = randn(d,n) ;

end


disp(teststr) ;

if itest == 1 ;    %  Complete defaults

  CanParDirSM(mX,mY) ;

elseif itest <= 5 ;    %  Explore iout choices

  [vCPD,vCOD] = CanParDirSM(mX,mY,iout) ;
  disp(['size(vCPD) = ' num2str(size(vCPD))]) ;
  disp(['size(vCOD) = ' num2str(size(vCOD))]) ;

else

  disp(' ') ;
  disp('First View (Connected) Input Data')
  figure(1) ;
  clf ;
  if itest == 8 
    mdir = [eye(2); zeros(d - 2,2)] ;
    titlecellstr = {{['CPD Test ' num2str(itest)] 'Input Data PCA' teststr}} ;
    paramstruct = struct('npcadiradd',-1, ...
                         'icolor','k', ...
                         'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                         'titlecellstr',titlecellstr, ...
                         'iscreenwrite',0) ;
    scatplotSM([mX mY],mdir,paramstruct) ;   
  else
    titlecellstr = {{['CPD Test ' num2str(itest)] 'Input Data PCA' teststr}} ;
    paramstruct = struct('npcadiradd',3, ...
                         'icolor','k', ...
                         'idataconn',[(1:n)' ((n + 1):(2 * n))'], ...
                         'titlecellstr',titlecellstr, ...
                         'iscreenwrite',0) ;
    scatplotSM([mX mY],[],paramstruct) ;   
  end

  disp(' ') ;
  disp('Next make default CPD plot')
  figure(2) ;
  clf ;
  [vCPD,vCOD] = CanParDirSM(mX,mY,iout) ;
  title(['CPD result, for test ' num2str(itest) ', ' teststr]) ;


end





