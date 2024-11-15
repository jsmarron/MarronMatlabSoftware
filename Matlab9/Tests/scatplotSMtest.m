disp('Running MATLAB script file scatplotSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION scatplotSM,
%    SCATterplot MATrix view of data


itest = 85 ;     %  1,...,85



disp(['    itest = ' num2str(itest)]) ;

if itest == 1 ;     %  very simple test

  disp('Test all defaults, simple example') ;
  vunif = rand(1,50) - 0.4 ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  figure(1) ;
  scatplotSM(mdata,mdir) ;


elseif itest == 2 ;

  disp(['Test icolor = 2, iplotaxes = 1, iplotdirvec = 1, savestr = ''temp'', iscreenwrite = 1, simple example']) ;
  vunif = rand(1,50) - 0.4 ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 3 ;

  disp(['same as above, but sort data for better rainbow view']) ;
  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 4 ;

  disp('Add some titles') ;
  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{strvcat('Title Top Left',' ','Title Bottom Left') ...
                   strvcat(' ',' ',' ') ...
                   strvcat('Title Top Right',' ','Title Bottom Right')}} ;

  
  {{['Test Tit. Top L'; 'Test Tit. Bot L'] ...
                   ['Test Tit. Top R'; 'Test Tit. Bot R']}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 5 ;   

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{'A Test' 'of Titles' 'in a row'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 6 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{strvcat('A Test','of Titles','in a col')}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 7 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{'A Test' 'of Title' 'Font Size'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',18, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 8 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Labels'}} ;

  labelcellstr = {{'Dir. 1'; 'Dir. 2'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 9 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Labels' 'some empty'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;
  disp('labelcellstr = ') ;
  labelcellstr{1}

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 10 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Labels' 'Fontsize'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'labelfontsize',18, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 11 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Labels' 'Fontsize'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelfontsize',6, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 12 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'All Black' '& White'}} ;

  paramstruct = struct('icolor',0, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 13 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'All' 'Green'}} ;

  paramstruct = struct('icolor','g', ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 14 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Matlab Default' 'Colors'}} ;

  paramstruct = struct('icolor',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 15 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Input' 'Multi Colors'}} ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(30,1) * [0 0 1])] ;

  paramstruct = struct('icolor',mcolor, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 16 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Adding a' 'PCA Dirn'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 17 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Adding a' 'PCA Dirn' 'given labels'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 18 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Adding a' 'PCA Dirn' 'given labels'}} ;

  labelcellstr = {{'Dir. 1'; ''; 'dir 3'; 'pc1'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 19 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Marker' 'String'}} ;

  paramstruct = struct('icolor',2, ...
                       'markerstr','x', ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 20 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Multiple' 'Markers'}} ;

  vmarker = [] ;
  for i = 1:30 ;
    vmarker = strvcat(vmarker,'+') ;
  end ;
  for i = 1:20 ;
    vmarker = strvcat(vmarker,'x') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'markerstr',vmarker, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 21 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test Subpop''s' 'Default to none' 'when icolor = 2'}} ;

  paramstruct = struct('icolor',2, ...
                       'isubpopkde',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 22 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Subpop' 'KDEs'}} ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(30,1) * [0 0 1])] ;

  paramstruct = struct('icolor',mcolor, ...
                       'isubpopkde',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 23 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Subpop' 'KDEs only'}} ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(30,1) * [0 0 1])] ;

  paramstruct = struct('icolor',mcolor, ...
                       'isubpopkde',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 24 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Data' 'Connections'}} ;
  mdataconn = [(1:49);(2:50)]' ;

  paramstruct = struct('icolor',2, ...
                       'idataconn',mdataconn, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 25 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Data' 'Connection Color'}} ;
  mdataconn = [(1:49);(2:50)]' ;

  paramstruct = struct('icolor',2, ...
                       'idataconn',mdataconn, ...
                       'idataconncolor','g', ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 26 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Data Connections' 'Different Colors'}} ;
  mdataconn = [(1:49);(2:50)]' ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(29,1) * [0 0 1])] ;

  paramstruct = struct('icolor',2, ...
                       'idataconn',mdataconn, ...
                       'idataconncolor',mcolor, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 27 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Data Connections' 'Line Color & Type'}} ;
  mdataconn = [(1:49);(2:50)]' ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(29,1) * [0 0 1])] ;
  vtype = [] ;
  for i = 1:29 ;
    vtype = strvcat(vtype,'--') ;
  end ;
  for i = 1:20 ;
    vtype = strvcat(vtype,'-') ;
  end ;

  paramstruct = struct('icolor',2, ...
                       'idataconn',mdataconn, ...
                       'idataconncolor',mcolor, ...
                       'idataconntype',vtype, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 28 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'Data Connections' 'Line Color & Type'}} ;
  mdataconn = [(1:49);(2:50)]' ;
  mcolor = ones(20,1) * [1 0 0] ;
  mcolor = [mcolor; (ones(29,1) * [0 0 1])] ;

  paramstruct = struct('icolor',2, ...
                       'idataconn',mdataconn, ...
                       'idataconncolor',mcolor, ...
                       'idataconntype','--', ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 29 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'ibigdot' '& wrong linetype'}} ;

  paramstruct = struct('icolor',2, ...
                       'markerstr','+', ...
                       'ibigdot',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 30 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'ibigdot = 1' 'see .fig file'}} ;

  paramstruct = struct('icolor',2, ...
                       'markerstr','.', ...
                       'ibigdot',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 31 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'ibigdot = 0' 'see .fig file'}} ;

  paramstruct = struct('icolor',2, ...
                       'markerstr','.', ...
                       'ibigdot',0, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 32 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'idatovlay = 0'}} ;

  paramstruct = struct('icolor',2, ...
                       'idatovlay',0, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 33 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'idatovlay = 2' 'random heights'}} ;

  paramstruct = struct('icolor',2, ...
                       'idatovlay',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 34 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'ndatovlay = 10' }} ;

  paramstruct = struct('icolor',2, ...
                       'ndatovlay',10, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 35 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'data overlay' 'range'}} ;

  paramstruct = struct('icolor',2, ...
                       'datovlaymin',0.1, ...
                       'datovlaymax',0.5, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 36 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;

  paramstruct = struct('icolor',2, ...
                       'legendcellstr',{{'Test Legend Top' 'Test Legend Bottom'}}, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 37 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;

  paramstruct = struct('icolor',2, ...
                       'legendcellstr',{{'Test Leg 1' 'Test Leg 2' 'T L 3' 'T l 4'}}, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 38 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'legendcellstr' 'colors'}} ;

  paramstruct = struct('icolor',2, ...
                       'legendcellstr',{{'Test Leg 1' 'Test Leg 2' 'T L 3' 'T l 4'}}, ...
                       'mlegendcolor',[[1 0 0]; [0 0 1]; [1 0 0]; [0 0 1]], ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 39 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'symmetric' 'axis limits'}} ;

  paramstruct = struct('icolor',2, ...
                       'maxlim',1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 40 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'input' 'axis limits'}} ;

  paramstruct = struct('icolor',2, ...
                       'maxlim',[[-1,2];[-0.2,0.3];[-1,10]], ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 41 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'no plot' 'of axes'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',0, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 42 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'no plot of' 'direction vectors'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotdirvec',0, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 43 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' '2nd & 3rd Dir' 'PC 1 & 2'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',2, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 44 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [] ;

  titlecellstr = {{'Test' 'all PC' 'Directions'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',3, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 45 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(2,50) - 1] ;
  
  mdir = [] ;

  titlecellstr = {{'Test all PC' 'Directions' '& forgotten' 'npcadiradd'}} ;

  paramstruct = struct('icolor',2, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 46 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test input' 'axis limits' 'when pc dirs added'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',2, ...
                       'maxlim',[[-1,2];[-10,10];[-10,10]], ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 47 ;

  disp('testing maxlim = [-1,2,3,5];[-10,-5,5,10]') ;
  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test input' 'axis limits' 'with errors'}} ;

  paramstruct = struct('icolor',2, ...
                       'maxlim',[[-1,2,3,5];[-10,-5,5,10]], ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 48 ;   

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{'A Test of' 'below diagonals plots:' 'ibelowdiag = 1'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'ibelowdiag',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 49 ;   

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;
  
  titlecellstr = {{'A Test of' 'below diagonals plots:' 'ibelowdiag = 0'}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'ibelowdiag',0, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 50 ;

  %  Note:  This is similar to itest = 36
  %         except that "setfield" is used on mlegendcolor
  %         which causes a size error 
  %         (due to double braces in legendcellstr)
  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   Expect error from this part,') ;
  disp('???   Since are using wrong number of braces') ;
  disp('???   in creating of text cell string') ;
  disp('???') ;


  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;
  paramstruct = setfield(paramstruct,'legendcellstr',{{'Test Legend Top' 'Test Legend Bottom'}}) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 51 ;

  %  Note:  This is similar to itest = 50
  %         except that the error is fixed by
  %         using single braces in legendcellstr

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;

  paramstruct = struct('icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;
  paramstruct = setfield(paramstruct,'legendcellstr',{'Test Legend Top' 'Test Legend Bottom'}) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 52 ;


  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;
  paramstruct = struct('npcadiradd',3, ...
                       'titlecellstr',{{'Test no icolor' 'and title' '& labels'}}, ...
                       'labelcellstr',{{'L1' 'L2' 'L3'}}, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;


elseif itest == 53 ;


  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  idataconn = [(1:49)' (2:50)'] ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',2, ...
                       'idataconn',idataconn, ...
                       'idataconncolor',2, ...
                       'titlecellstr',{{'Test idataconn' 'and rainbow coloring'}}, ...
                       'labelcellstr',{{'L1' 'L2' 'L3'}}, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;


elseif itest == 54 ;


  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  idataconn = [[(1:49)' (2:50)']; [2 42; 3 43; 4 44; 5 45]] ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',2, ...
                       'idataconn',idataconn, ...
                       'idataconncolor',2, ...
                       'titlecellstr',{{'Test bad idataconn' 'for rainbow colors'}}, ...
                       'labelcellstr',{{'L1' 'L2' 'L3'}}, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;


elseif itest == 55 ;


  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  idataconn = [2 42; 3 43; 4 44; 5 55] ;

  titlecellstr = {{'Test' 'legendcellstr' ''}} ;
  paramstruct = struct('npcadiradd',3, ...
                       'icolor',2, ...
                       'idataconn',idataconn, ...
                       'idataconncolor',2, ...
                       'titlecellstr',{{'Test bad idataconn' 'since outside range'}}, ...
                       'labelcellstr',{{'L1' 'L2' 'L3'}}, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;


elseif itest == 56 ;

  %  Note:  This is similar to itest = 43
  %         except that "npcadiradd" is negative
  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   Interesting to compare this to') ;
  disp('???   itest = 43') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' '2nd & 3rd Dir' 'Ortho PC 1 & 2'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 57 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 4') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;
  
  titlecellstr = {{strvcat('Title Top Left',' ','Title Bottom Left') ...
                   strvcat(' ',' ',' ') ...
                   strvcat('Title Top Right',' ','Title Bottom Right')}} ;

  
  {{['Test Tit. Top L'; 'Test Tit. Bot L'] ...
                   ['Test Tit. Top R'; 'Test Tit. Bot R']}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 58 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 7') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;
  
  titlecellstr = {{'A Test' 'of Title' 'Font Size'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',18, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 59 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 8') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Labels'}} ;

  labelcellstr = {{'Dir. 1'; 'Dir. 2'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 60 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 9') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Labels' 'some empty'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;
  disp('labelcellstr = ') ;
  labelcellstr{1}

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 61 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 10') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Labels' 'Fontsize'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'labelfontsize',18, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 62 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 11') ;
  disp('???   with npcadiradd = -2') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Labels' 'Fontsize'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelfontsize',18, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 63 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 16') ;
  disp('???   with npcadiradd = -1') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test Adding an' 'Ortho PCA Dirn' 'to Full Rank Display'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 64 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test Adding 3' 'Ortho PCA Dirns' 'to Rank 1 Display'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-3, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 65 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Adding 3' 'PCA Dirns'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',3, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 66 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [1; 0; 0] ;

  titlecellstr = {{'Test' 'Adding 4' 'PCA Dirns'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',4, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 67 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 17') ;
  disp('???   with npcadiradd = -1') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test' 'Adding an Ortho' 'PCA Dirn' 'given labels'}} ;

  labelcellstr = {{'Dir. 1'; ''}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 68 ;

  disp('???   Note from scatplotSMtest.m:') ;
  disp('???   This is similar to') ;
  disp('???   itest = 18') ;
  disp('???   with npcadiradd = -1') ;
  disp('???') ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test' 'Adding an Ortho' 'PCA Dirn' 'given labels'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('icolor',2, ...
                       'npcadiradd',-1, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 69 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test' 'No Mean' 'Recentering'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'irecenter',0, ...
                       'icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 70 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test' 'Explicit Mean' 'Recentering'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'irecenter',1, ...
                       'icolor',2, ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 71 ;

  vtheta = 2 * pi * (1:50) / 50 ;
  mdata = [100 + cos(vtheta); -200 + sin(vtheta)] ;
  
  mdir = [[1; 0] [0.95; sqrt(1 - (0.95)^2)]] ;

  titlecellstr = {{'Explore Hard Case' 'No Recentering'}} ;

  paramstruct = struct('irecenter',0, ...
                       'icolor',2, ...
                       'iplotaxes',1, ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 72 ;

  vtheta = 2 * pi * (1:50) / 50 ;
  mdata = [100 + cos(vtheta); -200 + sin(vtheta)] ;
  
  mdir = [[1; 0] [0.95; sqrt(1 - (0.95)^2)]] ;

  titlecellstr = {{'Explore Hard Case' 'With Normalization'}} ;

  paramstruct = struct('irecenter',1, ...
                       'icolor',2, ...
                       'iplotaxes',1, ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 73 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test Color' 'All Gray'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'icolor',0.5 * ones(50,3), ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 74 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test Bad Color Input' 'Transpose of color matrix'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'icolor',0.5 * ones(3,50), ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 75 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test Bad Color Input' 'Test 2 column icolor'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'icolor',0.5 * ones(50,2), ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 76 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test Bad Color Input' 'Test icolor too long'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'icolor',0.5 * ones(60,3), ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 77 ;

  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = [[1; 0; 0] [0; 1; 0]] ;

  titlecellstr = {{'Test Bad Color Input' 'Test icolor too short'}} ;

  labelcellstr = {{''; 'dir 2'; 'ortho pc1'}} ;

  paramstruct = struct('npcadiradd',-1, ...
                       'icolor',0.5 * ones(40,3), ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'labelcellstr',labelcellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 78 ;

  disp('see also itest = 39, 40, 46, 47') ;
  disp('    testing maxlim = [-1,2]') ;
  vunif = rand(1,50) - 0.4 ;
  vunif = sort(vunif) ;
  mdata = [vunif; vunif.^2 - 0.1; 10 * rand(1,50) - 1] ;
  
  mdir = eye(3) ;

  titlecellstr = {{'Test input' 'axis limits' 'with errors'}} ;

  paramstruct = struct('icolor',2, ...
                       'maxlim',[-1,2], ...
                       'iplotaxes',1, ...
                       'iplotdirvec',1, ...
                       'savestr','temp', ...
                       'titlecellstr',titlecellstr, ...
                       'titlefontsize',15, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 79 ;

  rng(20934847) ;
      %  Set seed so can continue with same example 

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  mdir = eye(2) ;

  titlecellstr = {{'2-d Toy, High Correlation' ...
                   'Raw Data, Uncentered, itest = 79'}} ;

  paramstruct = struct('irecenter',0, ...
                       'icolor',2, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(2) ;
  clf
  disp('Put in Figure 2, to compare with later examples') ;
  scatplotSM(mdata,mdir,paramstruct) ;


elseif itest == 80 ;

  rng(20934847) ;
      %  Use seed to continue with same data as in Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  mdir = eye(2) ;

  titlecellstr = {{'2-d Toy, High Correlation' 'Raw Data, iorient = 1 (see note)'}} ;

  paramstruct = struct('irecenter',0, ...
                       'iorient',1, ...
                       'icolor',2, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;

  disp('Recall iorient only has effect for added PCs') ;


elseif itest == 81 ;

  rng(20934847) ;
      %  Use seed to continue with same data as n Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  titlecellstr = {{'2-d Toy, High Correlation' 'Default PCA'}} ;

  paramstruct = struct('npcadiradd',2, ...
                       'icolor',2, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;


elseif itest == 82 ;

  rng(20934847) ;
      %  Use seed to continue with same data as in Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  titlecellstr = {{'2-d Toy, High Correlation' ...
                   'Default PCA, uncentered (see note)'}} ;

  paramstruct = struct('npcadiradd',2, ...
                       'irecenter',0, ...
                       'icolor',2, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;

  disp('Recall iorient only computed on centered data') ;


elseif itest == 83 ;

  rng(20934847) ;
      %  Use seed to continue with same data as n Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  titlecellstr = {{'2-d Toy, High Correlation' ...
                   'Uncentered PCA, iorient = 0 (see note)'}} ;

  paramstruct = struct('npcadiradd',2, ...
                       'irecenter',0, ...
                       'iorient',0, ...
                       'icolor',2, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,[],paramstruct) ;

  disp('Recall iorient only computed on centered data') ;


elseif itest == 84 ;

  rng(20934847) ;
      %  Use seed to continue with same data as n Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  mdir = [0.49 0.51 ; ...
          -0.51 -0.49 ] ;

  titlecellstr = {{'2-d Toy, High Correlation' 'Input dir''ns near negative diagonal'}} ;

  paramstruct = struct('npcadiradd',0, ...
                       'irecenter',1, ...
                       'icolor',2, ...
                       'iplotdirvec',1, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;
  
  disp('Note:  Direction vectors are close to 135 degree line,') ;
  disp('        i.e. negative diagonal ') ;
  disp('        and do not have length 1 (hence get normalization messages)') ;


elseif itest == 85 ;

  rng(20934847) ;
      %  Use seed to continue with same data as n Figure 2

  mdata = (ones(2,1) * (1:100) - 80) / 25 ;
  mdata(2,:) = -4 - mdata(2,:) ;
  mdata = mdata + 0.1 * randn(2,100) ;

  mdir = [0.49 0.51 ; ...
          -0.51 -0.49 ] ;

  titlecellstr = {{'2-d Toy, High Correlation' 'Input dir''ns, Force Naive SP'}} ;

  paramstruct = struct('npcadiradd',0, ...
                       'irecenter',0, ...
                       'iforcenaivesp',1, ...
                       'icolor',2, ...
                       'iplotdirvec',1, ...
                       'titlecellstr',titlecellstr, ...
                       'iscreenwrite',1) ;

  figure(1) ;
  scatplotSM(mdata,mdir,paramstruct) ;

  disp('Note:  Direction vectors are close to 135 degree line,') ;
  disp('        i.e. negative diagonal ') ;
  disp('        and do not have length 1 (hence get normalization messages)') ;




end ;

