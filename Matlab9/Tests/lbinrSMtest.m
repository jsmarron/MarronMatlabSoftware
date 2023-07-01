disp('Running MATLAB script file lbinrSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION lbinrSM,
%    General Purpose Binner

itest = 203 ;     %  1,...,11   Simple Density Estimation
                  %  51,52,53             Simple, Regression
                  %  100,101,102,103      Serious, accuracy
                  %  200,201,202,203      Serious, time trials

format compact ;
format short ;

centers = [] ;    %  Empty , unless otherwise specified

if itest == 1 ;   %  Simplest check of linearity
  indat = .65432 ;
  counts = lbinrSM(indat,[0,1,2]) ;

elseif itest == 2 ;   %  Check lower endpoint stuff
  indat = [-5; -4; -2] ;
  counts = lbinrSM(indat,[1,10,10],0) ;

elseif itest == 3 ;   %  Check lower endpoint stuff, w truncation
  indat = [-5; -4; -2] ;
  counts = lbinrSM(indat,[1,10,10],1) ;

elseif itest == 4 ;   %  Check upper endpoint stuff
  indat = [11; 14; 15] ;
  counts = lbinrSM(indat,[1,10,10],0) ;

elseif itest == 5 ;   %  Check upper endpoint stuff, w/ truncation
  indat = [11; 14; 15] ;
  counts = lbinrSM(indat,[1,10,10],1) ;

elseif itest == 6 ;   %  Check slightly serious example
  indat = [.05; .11; .41; .4; .55; .97; 1; .6; 1.01] ;
  counts = lbinrSM(indat,[.1,1,10],0) ;

elseif itest == 7 ;   %  Check slightly serious example, w/o endpoints
  indat = [.05; .11; .41; .4; .55; .97; 1; .6; 1.01] ;
  counts = lbinrSM(indat,[.1,1,10],1) ;

elseif itest == 8 ;   %  Check slightly serious example, with binning grid
  indat = [.05; .11; .41; .4; .55; .97; 1; .6; 1.01] ;
  [counts, centers] = lbinrSM(indat,[.1,1,10],0) ;

elseif itest == 9 ;   %  Check slightly serious example, simple binning
  indat = [.05; .11; .41; .4; .55; .97; 1; .6; 1.01] ;
  [counts, centers] = lbinrSM(indat,[.1,1,10],0,0) ;

elseif itest == 10 ;   %  Check endpoint stuff, default grid
  indat = [5; 2; 4] ;
  [counts, centers] = lbinrSM(indat,0,0) ;

elseif itest == 11 ;   %  Check endpoint stuff, default grid, w truncation
  indat = [5; 2; 4] ;
  [counts, centers] = lbinrSM(indat,0,1) ;


elseif itest == 51 ;   %  Simple example, regression
  indat = [.2,2; .25,6; .57,1; .57,5; .8333,3; .8667,6; 1.1,7] ;
  [counts, centers] = lbinrSM(indat,[.1,1,10]) ;

elseif itest == 52 ;   %  Simple example, regression, simple, w/ trunc
  indat = [(2 * rand(10,1) - .5) randn(10,1)] ;
  [counts, centers] = lbinrSM(indat,[.1,1,10],1,0) ;

elseif itest == 53 ;   %  Simple example, regression, simple
  indat = [(2 * rand(10,1) - .5) randn(10,1)] ;
  [counts, centers] = lbinrSM(indat,[.1,1,10],0,0) ;


elseif itest == 100 ;   %  Check serious example, simple binning
  indat = rand(10000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat,[.05,.95,10],0,0) ;
  toc
  disp(['Binomial(10000,.1) Mean is: ' num2str(10000 * .1)]) ;
  disp(['  and s.d. is: ' num2str(sqrt(10000 * .1 * .9))]) ;

elseif itest == 101 ;   %  Check serious example, linear binning
  indat = rand(10000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat,[.05,.95,10],0,1) ;
  toc
  disp(['Binomial(10000,.1) Mean is: ' num2str(10000 * .1)]) ;
  disp(['  and s.d. is: ' num2str(sqrt(10000 * .1 * .9))]) ;

elseif itest == 102 ;   %  Check serious example, simple binning
  indat = randn(10000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat,[-3,3,601],0,0) ;
  toc 
  tic ;
  disp(['Now run MATLAB''s HIST, as a check']) ;
  [vn,vx] = hist(indat,-3:.01:3) ;
  toc
  disp(['Check this is 0: ' num2str(max(abs(vn' - counts)))]) ;
  disp('Hit Ctrl-C to Avoid seeing results') ;
  pause ;

elseif itest == 103 ;   %  Check serious example, simple binning
  indat = randn(1000000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat,[-3,3,601],0,0) ;
  toc 
  tic ;
  disp(['Now run MATLAB''s HIST, as a check']) ;
  [vn,vx] = hist(indat,-3:.01:3) ;
  toc
  disp(['Check this is 0: ' num2str(max(abs(vn' - counts)))]) ;
  disp('Hit Ctrl-C to Avoid seeing results') ;
  pause ;


elseif itest == 200 ;   %  Serious Time Trial, simple binning
  indat = randn(100000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat,0,0,0) ;
  toc

elseif itest == 201 ;   %  Serious Time Trial, linear binning
  indat = randn(100000,1) ;
  tic ;
  [counts, centers] = lbinrSM(indat) ;
  toc

elseif itest == 202 ;   %  Serious Time Trial, simple binning, reg.
  indat = [randn(100000,1) randn(100000,1)] ;
  tic ;
  [counts, centers] = lbinrSM(indat,0,0,0) ;
  toc

elseif itest == 203 ;   %  Serious Time Trial, linear binning, reg.
  indat = [randn(100000,1) randn(100000,1)] ;
  tic ;
  [counts, centers] = lbinrSM(indat) ;
  toc

end ;
% [bindat,bincent] = lbinrSM(data,vgridp,eptflag,ibtype) 


if itest <= 99 ;
  disp('for the data:') ;
  indat
else ;
  format long ;
end  ;


if itest <= 199 ;
  disp('   the output was:') ;
  answer = [centers, counts]
end ;

