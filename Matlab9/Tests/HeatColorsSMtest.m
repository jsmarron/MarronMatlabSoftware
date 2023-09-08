disp('Running MATLAB script file HeatColorsSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION HeatColorsSM,
%    which creates Heat Colormap, similar to Matlab's hot

itest = 6 ;     %  1,...,6


%  Create test data set
%
d = 100 ;
n = 50 ;
vx = (1:d)' ;
mdata = ((vx - 50) / 50) * linspace(-1,1,n) ;

disp(' ') ;

if itest == 1 ;  
  titstr = 'Default' ;
  icolor = HeatColorsSM(n) ;

elseif itest == 2 ;
  FracUse = 1 ;
  titstr = ['FracUse = ' num2str(FracUse)] ;
  icolor = HeatColorsSM(n,FracUse) ;

elseif itest == 3 ;
  FracUse = 0.9 ;
  titstr = ['FracUse = ' num2str(FracUse)] ;
  icolor = HeatColorsSM(n,FracUse) ;

elseif itest == 4 ;
  FracUse = 0.8 ;
  titstr = ['FracUse = ' num2str(FracUse)] ;
  icolor = HeatColorsSM(n,FracUse) ;

elseif itest == 5 ;
  FracUse = 0.7 ;
  titstr = ['FracUse = ' num2str(FracUse)] ;
  icolor = HeatColorsSM(n,FracUse) ;

elseif itest == 6 ;
  FracUse = 0.5 ;
  titstr = ['FracUse = ' num2str(FracUse)] ;
  icolor = HeatColorsSM(n,FracUse) ;

end ;


%  Make Output Graphic
%
disp(['Test ' titstr]) ;

figure(1) ;
clf ;
plot(vx,mdata(:,1),'-','Color',icolor(1,:),'LineWidth',2) ;
hold on ;
for i=2:n ;
  plot(vx,mdata(:,i),'-','Color',icolor(i,:),'LineWidth',2) ;
end ;
hold off ;
axis([0 (d + 1) min(min(mdata)) max(max(mdata))]) ;
title(titstr) ;


%{
%  Save Graphic
%
if itest >= 2 ;

  pstr = ['HeatColorsSMtest' num2str(itest)] ;  
  orient landscape ;
  print('-dpsc2',pstr) ;

end ;
%}


