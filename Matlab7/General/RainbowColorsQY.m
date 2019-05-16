function colmap = RainbowColorsQY(n)
% RAINBOWCOLORSQY, Creates Rainbow Colormap
%    Values given are in RGB (Red - Green Blue) coordinates,
%    But are computed to be equally spaced in HSV 
%        (Hue Saturation Value) space
%
% Input:
%          n - number of colors (rows of color matrix) to generate
%
% Output:
%     colmap - n x 3 colormap, in RGB coordinates,
%                  to be used in rainbow color schemes
%                  Starts at Magenta
%                    Runs through Blue, Green, Yellow
%                      Ends at Red

%    Copyright (c) Qunqun Yu, J. S. Marron, 2014


%  Set inputs to HSV
%
saturation=ones(n,1);
    %  saturation is whiteness, runs over:
    %     0 - completely white
    %     1 - full color
    %  this is the radius of the HSV color cone
    
value=ones(n,1);
    %  value is brightness, runs over:
    %     0 - black
    %     1 - full color
    %  this is the vertical axis of the HSV color cone

hue=[0:(5/6)/(n-1):5/6];
 % Get equally spaced hue of the color
 
colmap = hsv2rgb([flipud(hue'), saturation, value] );


