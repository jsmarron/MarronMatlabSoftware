function printSM(savestr,itype) 
% PRINTSM, Print Graphic to File
%   Steve Marron's matlab function
%     For the current figure window, creates a graphical
%     output file, with a given filename
%
% Inputs:
%   savestr -  string controlling saving of output,
%                either a full path, or a file prefix to
%                save in matlab's current directory
%                Will add file suffix determined by itype
%
%     itype - indicator of output file type:
%                1  - (default)  Save as Matlab figure file (.fig)
%                2  - (.png)  Portable Network Graphics - raster graphics
%                3  - (.pdf)  Portable Document Format - vector graphics
%                4  - (.eps)  Color Encapsulated Postscript- vector 
%                5  - (.eps)  Black and White EPS - vector 
%                6  - (.jpg)  Joint Photograph Experts Group - raster
%                7  - (.svg)  Scalable Vector Graphics - vector
%
% Output:
%      Creates a graphic file in the current directory 
%      

%    Copyright (c) J. S. Marron 2023

if nargin == 1 ;   %  then set itype to default .fig
  itype = 1 ;      
end ;

if itype == 1 ;    %  (.fig)
  savefig(savestr) ;
elseif itype == 2 ;    %  (.png)
  print(savestr,'-dpng') ;
elseif itype == 3 ;    %]  (.pdf)
  print(savestr,'-dpdf') ;
elseif itype == 4 ;    %  (.eps) Color
  print(savestr,'-depsc') ;
elseif itype == 5 ;    %  (.eps) B&W
  print(savestr,'-deps') ;
elseif itype == 6 ;    %  (.jpg)
  print(savestr,'-djpeg') ;
elseif itype == 7 ;    %  (.svg)
  print(savestr,'-dsvg') ;
end ;

