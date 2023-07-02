disp('Running MATLAB script file printSMtest.m') ;
%
%    FOR DEVELOPMENT AND TESTING OF MATLAB FUNCTION printSM,
%    print graphic to file

itest = 7 ;     %  0,1,...,7


%  Generate graphic to print to file
%
figure(1) ;
clf ;
mxdata = [[1; 4] [2; 3] [3; 1]] ;
mydata = [[3; 8] [6; 4] [5; 4]] ;
plot(mxdata(:,1),mydata(:,1),'r-','LineWidth',1) ;
hold on ;
  plot(mxdata(:,2),mydata(:,2),'k-.','LineWidth',4) ;
  plot(mxdata(:,3),mydata(:,3),'b:','LineWidth',2) ;
hold off ;
axisSM(mxdata,mydata) ;
title('Test Plot') ;
xlabel('x-axis','Fontsize',18) ;
ylabel('y-axis','Fontsize',6) ;

filestr = 'Temp' ;

if itest == 0 ;   %  Check default

  title('Default of Matlab .fig') ;
  printSM(filestr) ;

else ;

  if itest == 1 ;   
    title('Saved as Matlab .fig') ;
  elseif itest == 2 ;  
    title('Print to .png') ;
  elseif itest == 3 ;  
    title('Print to .pdf') ;
  elseif itest == 4 ;  
    title('Print to Color .eps') ;
  elseif itest == 5 ;  
    title('Print to B&W .eps') ;
  elseif itest == 6 ;  
    title('Print to .jpg') ;
  elseif itest == 7 ;  
    title('Print to .svg') ;
  end ;

  printSM(filestr,itest) ;

end ;



