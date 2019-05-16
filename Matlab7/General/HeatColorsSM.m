function colmap = HeatColorsQY(n,FracUse)
% HEATCOLORSQY, Creates Heat Colormap
%    Similar to Matlab's hot
%    Values given are in RGB (Red - Green Blue) coordinates,
%    and are truncated to bottom 90%, as white does not plot well
%
% Input:
%          n       - number of colors (rows of color matrix) to generate
%
%          FracUse - Fraction of Matlab's hot to use.  Avoids colors too
%                        close to white, which don't plot well
%                        (default FracUse = 0.9)
%
% Output:
%     colmap - n x 3 colormap, in RGB coordinates,
%                     first are nearly black, 
%                     last are shades of yellow

%    Copyright (c) J. S. Marron, 2019

if nargin == 1 ;   %  then FracUse is not unput
  FracUse = 0.9 ;
      %  default value
end ;

colmap = hot(round(n / FracUse)) ;
colmap = colmap(1:n,:) ;


