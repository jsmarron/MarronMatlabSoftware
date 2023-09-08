disp('Running MATLAB script file AutoTransQFtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION AutoTransQF,
%    General Purpose of automatical transformation of a given data vector

itest = 19 ;  % 1, 2, ..., 19

disp(' ') ;

if itest == 1;      % check default setting 
    
    idat = exprnd(2, 20, 50) ;      % 20x50 data matrix
    disp('    Running 20 x 50 example') ;
    tic ;
    [transformed_data, transformation] = AutoTransQF(idat);
    disp(['    Took ' num2str(toc) ' secs']) ;

elseif itest ==2 ; % check screenwrite
    
    idat = exprnd(2, 2, 50) ;      % 2x50 data matrix
    disp('    Running 2 x 50 example, with iscreenwrite = 1') ;
    tic ;
    paramstruct = struct ( 'iscreenwrite', 1 ) ;
    [transformed_data, transformation] = AutoTransQF(idat, paramstruct);
    disp(['    Took ' num2str(toc) ' secs']) ;
    
elseif itest == 3 ; % check transformation via minimizing skewness
    
    idat = exprnd(3, 2, 100) ;      % 2x100 data matrix
    disp('    Running 2 x 100 example, min''ing skewness') ;
    tic ;
    
    paramstruct = struct ( 'istat', 1) ;
    [transformed_data, transformation] = AutoTransQF(idat, paramstruct);
    disp(['    Took ' num2str(toc) ' secs']) ;
    
elseif itest == 4;  % transformation of variables with very large sample size 
    
    idat = exprnd (2, 5, 20000);         % 5x20000 data matrix
    disp('    Running 5 x 20000 example') ;
    tic;
    [transformed_data, transformation] = AutoTransQF(idat);
    disp(['    Took ' num2str(toc) ' secs']) ;

    %  Note:  this took 56 secs
    
elseif itest == 5 ;  % check usage of feature names
    
    idat = exprnd (2, 2, 200);         % 2x200 data matrix
    disp('    Running 2 x 200 example, to test feature names') ;
    
    testname = strvcat('Testname1', 'Testname2') ;
    paramstruct = struct ('FeatureNames', testname, ...
                          'iscreenwrite',1) ;
    [transformed_data, transformation] = AutoTransQF(idat, paramstruct);
    
elseif itest == 6; % check unmatched feature names 
    
    idat = exprnd (2, 1, 200);         % 5x200 data matrix
    disp('    Testing unmatched feature names') ;
    
    testname = strvcat('Testname1', 'Testname2') ;
    paramstruct = struct ('FeatureNames', testname, ...
                          'iscreenwrite',1) ;
    [transformed_data, transformation] = AutoTransQF(idat, paramstruct);
    
elseif itest == 7; % normal distributed data vector 
    
    paramstruct = struct ('iscreenwrite',1) ;
    idat = normrnd (1, 2, 1, 200);         % 1x200 data matrix
    
    [transformed_data, transformation] = AutoTransQF(idat, paramstruct);
    
elseif itest == 8;  % data vector with binary values (  test error message )
    
     idat = binornd (1, 0.1, 1, 200)*10 + 5;       % 1x200 data matrix
     
     [transformed_data, transformation] = AutoTransQF(idat);

elseif itest == 9;  % standard deviation is equal to 0 
    
    idat = repmat(exprnd(2), 1, 500) ;
    
    [transformed_data, transformation] = AutoTransQF(idat);
    
elseif itest == 10; % computational time of high dimension data
    
    idat = exprnd(2, 1000, 500) ;
    disp('    Running 1000 x 500 example') ;
    
    tic;
    [transformed_data, transformation] = AutoTransQF(idat);
    disp(['    Took ' num2str(toc) ' secs']) ;

    %Marron's 2014 notebook:  934 sec
    %Qing's times:
    %Elapsed time is 409.161399 seconds.
    % old version: Elapsed time is 1057.831920 seconds.
    
elseif itest == 11; % Visually Study Exponential Input

    idat = exprnd(2, 1, 500) ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 12; % Visually Study Shifted Exponential Input

    idat = exprnd(2, 1, 500) - 100 ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 13; % Visually Study Negative Exponential Input

    idat = 1 - exprnd(2, 1, 500) ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 14; % Visually Study Gaussian Input

    idat = randn(1,500) ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 15; % Visually Study Large Gaussian Input

    idat = randn(1,5000) ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 16; % Visually Study Mean Mixture Input

    idat = -5 + 2 * randn(1,250) ;
    idat = [idat (5 + randn(1,250))] ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 17; % Visually Study Scale Mixture Input

    idat = randn(1,250) ;
    idat = [idat (10 * randn(1,250))] ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 18; % Visually Gaussian and two large outliers

    idat = randn(1,498) ;
    idat = [idat 10 100] ;
    figure(1) ;
    clf ;
    subplot(1,2,1) ;
    qqLM(idat') ;

    [transformed_data, transformation] = AutoTransQF(idat);
    subplot(1,2,2) ;
    qqLM(transformed_data') ;
    
elseif itest == 19; % Input data with missing values

    idat = randn(1,499) ;
    idat = [idat NaN] ;
    
    [transformed_data, transformation] = AutoTransQF(idat);

end ;    %  of itest if-block


