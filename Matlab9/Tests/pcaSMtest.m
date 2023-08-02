disp('Running MATLAB script file pcaSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION pcaSM,
%    Principal Component Analysis

itestdat = 1 ;     %  1 - random 5 x 3 matrix
                   %  2 - random 3 x 5 matrix

%vitest = [1:13] ;
%vitest = [14] ;
%vitest = [21 22 23] ;
%vitest = [24 25 26] ;
vitest = [24] ;
              %  1 - no paramstruct
              %  2 - empty paramstruct
              %  3 - screenwrite
              %  4 - viout = [1]
              %  5 - viout = [1 0]
              %  6 - viout = [1 1]
              %  7 - viout = [1 0 1]
              %  8 - viout = [1 1 1 1]
              %  9 - viout = [1 1 1 1 1 1]
              %  10 - viout = ones(1,10)
              %  11 - viout = ones(10,1)   
              %  12 - viout = ones(12,1) 
              %  13 - viout = [1 2 3 1]
              %  14 - viout = ones(2,2)    {Expect Error}
              %  21 - check dual against direct   (not working)
              %  22 - check eigen decomp
              %  23 - check reconstruction of data
              %  24 - check full set of inputs
              %  25 - check eigenvector flip
              %  26 - check eigenvector flip, towards 45 degree line


if itestdat == 1 ;

  mdata = rand(5,3)

elseif itestdat == 2 ;

  mdata = rand(3,5)

end ;    %  of itestdat if-block



for itest = vitest ;  

  if itest == 1 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('No Paramstruct') ;

    outstruct = pcaSM(mdata) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 2 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('empty paramstruct') ;

    paramstruct = struct([]) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 3 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('screenwrite') ;

    paramstruct = struct('iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 4 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1]') ;

    paramstruct = struct('viout',[1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 5 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 0]') ;

    paramstruct = struct('viout',[1 0],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 6 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 1]') ;

    paramstruct = struct('viout',[1 1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 7 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 0 1]') ;

    paramstruct = struct('viout',[1 0 1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 8 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 1 1 1]') ;

    paramstruct = struct('viout',[1 1 1 1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 9 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 1 1 1 1 1]') ;

    paramstruct = struct('viout',[1 1 1 1 1 1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 10 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = ones(1,10)') ;

    paramstruct = struct('viout',ones(1,10),...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 11 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = ones(10,1)') ;

    paramstruct = struct('viout',ones(10,1),...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 12 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = ones(12,1)    {Expect Error}') ;

    paramstruct = struct('viout',ones(12,1),...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 13 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = [1 2 3 1]    {Expect Error}') ;

    paramstruct = struct('viout',[1 2 3 1],...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 14 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('viout = ones(2,2)    {Expect Error}') ;

    paramstruct = struct('viout',ones(2,2),...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) 

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 21 ;

%{
    paramstruct = struct('viout',[1 1 0 0 1], ...
                         'idual',-1, ...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    veigval1 = getfield(outstruct,'veigval') ;
    meigvec1 = getfield(outstruct,'meigvec') ;
    mpc1 = getfield(outstruct,'mpc') ;

    paramstruct = struct('viout',[1 1 0 0 1], ...
                         'idual',1, ...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    veigval2 = getfield(outstruct,'veigval') ;
    meigvec2 = getfield(outstruct,'meigvec') ;
    mpc2 = getfield(outstruct,'mpc') ;

    disp('Check that these are all 0') ;
    max(abs(veigval1 - veigval2)) 
    max(max(abs(meigvec1 - meigvec2)) )
    max(max(abs(mpc1 - mpc2)) )

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;
%}

  elseif itest == 22 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('check eigen decomp') ;

    paramstruct = struct('viout',[1 1 0 0], ...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    veigval = getfield(outstruct,'veigval') ;
    meigvec = getfield(outstruct,'meigvec') ;

    mcov = cov(mdata') ;

    disp('Check that these are both 0') ;
    max(max(abs(mcov - meigvec * diag(veigval) * meigvec')))
    max(max(abs(diag(veigval) - meigvec' * mcov * meigvec)))

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 23 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('check reconstruction of data') ;

    paramstruct = struct('viout',[1 1 1 0 1], ...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    veigval = getfield(outstruct,'veigval') ;
    meigvec = getfield(outstruct,'meigvec') ;
    vmean = getfield(outstruct,'vmean') ;
    mpc = getfield(outstruct,'mpc') ;


    disp('Check that this is 0') ;
    max(max(abs(mdata - (vec2matSM(vmean,size(mdata,2)) + meigvec * mpc))))

    pauseSM ;
    disp(' ') ;
    disp(' ') ;
    disp(' ') ;


  elseif itest == 24 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('check full set of inputs') ;

    paramstruct = struct('viout',ones(10,1), ...
                         'iscreenwrite',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    outstruct

    veigval = getfield(outstruct,'veigval') ;
    sstot = getfield(outstruct,'sstot') ;
    mmeanresid = getfield(outstruct,'mmeanresid') ;
    vmean = getfield(outstruct,'vmean') ;
    ssmresid = getfield(outstruct,'ssmresid') ;
    vpropSSmr = getfield(outstruct,'vpropSSmr') ;
    vpropSSprev = getfield(outstruct,'vpropSSpr') ;


    disp('Check that this is 0') ;
    abs(sstot - sum(sum(mdata.^2))) 


    disp('Check that this is 0') ;
    abs(ssmresid - (size(mdata,2) - 1) * sum(veigval)) 


    disp('Check that this is 0') ;
    abs(sstot - (ssmresid + size(mdata,2) * sum(vmean.^2))) 


    disp('Check that this is 0') ;
    sum(sum(abs(mmeanresid - (mdata - vec2matSM(vmean,size(mdata,2))))))


    disp('Check that this is 0') ;
    sum(abs(vpropSSmr - (veigval ./ (ssmresid  / (size(mdata,2) - 1)))))


    disp('Check that this is 0') ;
    sum(abs(vpropSSprev - (veigval ./ [ssmresid / (size(mdata,2) - 1); ...
                                  veigval(1:(length(veigval) - 1))]))) 


  elseif itest == 25 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('check eigenvector flip') ;

    paramstruct = struct('viout',[0 1 0 0 1], ...
                         'iscreenwrite',1, ...
                         'iorient',0) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    meigvec0 = getfield(outstruct,'meigvec') ;
    mpc0 = getfield(outstruct,'mpc') ;


    paramstruct = struct('viout',[0 1 0 0 1], ...
                         'iscreenwrite',1, ...
                         'iorient',1) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    meigvec1 = getfield(outstruct,'meigvec') ;
    mpc1 = getfield(outstruct,'mpc') ;


    paramstruct = struct('viout',[0 1 0 0 1], ...
                         'iscreenwrite',1, ...
                         'iorient',2) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    meigvec2 = getfield(outstruct,'meigvec') ;
    mpc2 = getfield(outstruct,'mpc') ;


    disp('Eigenvectors, no orientation') ;
    meigvec0 


    disp('Eigenvectors, orientation 1') ;
    meigvec1 


    disp('Eigenvectors, orientation 2') ;
    meigvec2 


    disp('Projections, no orientation') ;
    mpc0 


    disp('Projections, orientation 1') ;
    mpc1 


    disp('Projections, orientation 2') ;
    mpc2 


  elseif itest == 26 ;

    disp(['itest = ' num2str(itest)]) ;
    disp('check eigenvector flip, towards 45 degree line') ;

    paramstruct = struct('viout',[0 1 0 0 1], ...
                         'iscreenwrite',1, ...
                         'iorient',0) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    meigvec0 = getfield(outstruct,'meigvec') ;
    mpc0 = getfield(outstruct,'mpc') ;


    paramstruct = struct('viout',[0 1 0 0 1], ...
                         'iscreenwrite',1, ...
                         'iorient',3) ;

    outstruct = pcaSM(mdata,paramstruct) ;

    meigvec3 = getfield(outstruct,'meigvec') ;
    mpc3 = getfield(outstruct,'mpc') ;


    disp('Eigenvectors, no orientation') ;
    meigvec0 

    disp('Eigenvectors, orientation 3') ;
    meigvec3 

    disp('Projections, no orientation') ;
    mpc0 

    disp('Projections, orientation 3') ;
    mpc3 



  end ;    %  of itest if-block

end ;    %  of itest loop



