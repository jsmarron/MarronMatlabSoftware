function LabeledBarPlotSM(vheights,Labels,paramstruct) 
% LabeledBarPlotSM, Labeled Bar Plot
%     Given a set of bar heights, and labels, displays heights as bars
%     Especially useful for making loadings plots
%   Steve Marron's matlab function
% Inputs:
%      vheights - vector of bar heights (e.g. loadings)
%
%        Labels - cellstr of labels  (one for each bar)
%                    E.g. construct as: {'Feature 1' 'Feature 2' 'Feature 3'}
%                    Or using lines in the spirit of:
%                            Labels = {} ;
%                            for i = 1:length(vheights) ;
%                              Labels{i} = ['Feature ' num2str(i)] ;
%                            end ;
%                    Note: Matlab does tex interpretation, which e.g.
%                          turns '_' into subscripts.  To turn this off, use:
%                               set(gcf,'defaulttextinterpreter','none')
%
%   paramstruct - a Matlab structure of input parameters
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1, ...
%                            'field2',values2, ...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, unspecified values
%                          revert to defaults
%
%    fields            values
%
%    isort            Index for how to sort the bars (and corresponding labels)
%                         0  (default) Same order as in input file 
%                         1  Sort in order smallest to largest
%                         2  Sort absolute values, largest to smallest
%                         3  Sort and plot absolute values, largest to smallest
%
%    nshow            Number of bars to actually show (rest are truncated)
%                         0  (default) Show all bars, regardless of number
%                         #  Show that number of bars (in order of isort)
%
%    fontsize         Font Size for labels
%                               default is empty [], for Matlab default
%                         Some recommendations, for nicely readable:
%                                        on screen      in .ps file
%                         10 bars:           18             24
%                         20 bars:           12             15
%                         50 bars:           8              10
%                         100 bars:         none            6
%                         more:             none            (can do with zoom in)
%
%    labelhtfrac      Height of start of bar labels, as function of range
%                         0.3  (default)
%
%    vaxlim           Vector of vertical axis limits
%                         []  (default) automatically chosen, by axisSM
%                         1   Use [-1,1], good for common loading plots
%                         2   Use [0,1], good for common absolute loading plots
%                         Otherwise, must be 1 x 2 row vector of vertical axis limits
%                             Note:  Only adjusts vertical axis, since
%                                    horizontal axis is set at [0, nshow + 1]
%
%    vcolor           3 x 1 color vector, for bars:
%                         [0 1 0]   for green (default)
%                         [0.7 0.7 0.7]   gray only version 
%                                   (with black and white print)
%
%    titlestr         string with title (only has effect when plot is made here)
%                           default is empty string, '', for no title
%
%    titlefontsize    font size for title
%                                    (only has effect when plot is made here,
%                                     and when the titlestr is nonempty)
%                           default is empty [], for Matlab default
%
%    xlabelstr        string with x axis label
%                                    (only has effect when plot is made here)
%                           default is empty string, '', for no xlabel
%
%    ylabelstr        string with y axis label
%                                    (only has effect when plot is made here)
%                           default is empty string, '', for no ylabel
%
%    labelfontsize    font size for axis labels
%                                    (only has effect when plot is made here,
%                                     and when a label str is nonempty)
%                           default is empty [], for Matlab default
%
%    savestr          string controlling saving of output,
%                         either a full path, or a file prefix to
%                         save in matlab's current directory
%                         Will add .ps, and save as either
%                             color postscript (vcolor entries 
%                             not all same, i.e. gray)
%                         or
%                             black&white postscript (when icolor entries same)
%                         unspecified:  results only appear on screen
%
%
% Outputs:
%     Graphics in current axis
%            (so may wish to call "clf" first, if this is 
%                 unintentionally put into an axis window)
%     When savestr exists,
%        Postscript files saved in 'savestr'.ps
%                 (color postscript for vcolor entries not all same)
%                 (B & W postscript for vcolor entries same)
%
% Assumes path can find personal functions:
%    vec2matSM.m

%    Copyright (c) J. S. Marron 2009



%  First set all parameters to defaults
%
isort = 0 ;
nshow = 0 ;
fontsize = [] ;
labelhtfrac = 0.3 ;
vaxlim = [] ;
vcolor = [0 1 0] ;
titlestr = '' ;
titlefontsize = [] ;
xlabelstr = '' ;
ylabelstr = '' ;
labelfontsize = [] ;
savestr = [] ;



%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2 ;   %  then paramstruct is an argument

  if isfield(paramstruct,'isort') ;    %  then change to input value
    isort = getfield(paramstruct,'isort') ; 
  end ;

  if isfield(paramstruct,'nshow') ;    %  then change to input value
    nshow = getfield(paramstruct,'nshow') ; 
  end ;

  if isfield(paramstruct,'fontsize') ;    %  then change to input value
    fontsize = getfield(paramstruct,'fontsize') ; 
  end ;

  if isfield(paramstruct,'labelhtfrac') ;    %  then change to input value
    labelhtfrac = getfield(paramstruct,'labelhtfrac') ; 
  end ;

  if isfield(paramstruct,'vaxlim') ;    %  then change to input value
    vaxlim = getfield(paramstruct,'vaxlim') ; 
  end ;

  if isfield(paramstruct,'vcolor') ;    %  then change to input value
    vcolor = getfield(paramstruct,'vcolor') ; 
  end ;

  if isfield(paramstruct,'titlestr') ;    %  then change to input value
    titlestr = getfield(paramstruct,'titlestr') ; 
  end ;

  if isfield(paramstruct,'titlefontsize') ;    %  then change to input value
    titlefontsize = getfield(paramstruct,'titlefontsize') ; 
  end ;

  if isfield(paramstruct,'xlabelstr') ;    %  then change to input value
    xlabelstr = getfield(paramstruct,'xlabelstr') ; 
  end ;

  if isfield(paramstruct,'ylabelstr') ;    %  then change to input value
    ylabelstr = getfield(paramstruct,'ylabelstr') ; 
  end ;

  if isfield(paramstruct,'labelfontsize') ;    %  then change to input value
    labelfontsize = getfield(paramstruct,'labelfontsize') ; 
  end ;

  if isfield(paramstruct,'savestr') ;    %  then use input value
    savestr = getfield(paramstruct,'savestr') ; 
    if ~(ischar(savestr) | isempty(savestr)) ;    %  then invalid input, so give warning
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Warning from projplot1SM.m:  !!!') ;
      disp('!!!   Invalid savestr,             !!!') ;
      disp('!!!   using default of no save     !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      savestr = [] ;
    end ;
  end ;


end ;    %  of resetting of input parameters



%  set preliminary stuff
%
nbar = length(vheights) ;
         %  number of bars to plot

if nshow == 0 ;    %  all bars requested
  nb = nbar ;
elseif  0 < nshow  &  (nshow == round(nshow))  ;
  if nshow <= nbar ;
    nb = nshow ;
  else ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from LabeledBarPlotSM:             !!!') ;
    disp('!!!   Input nshow > length of input vheights,    !!!') ;
    disp('!!!   Will show all bars                         !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    nb = nbar ;
  end ;
else ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from LabeledBarPlotSM:     !!!') ;
  disp('!!!   Invalid value of nshow,           !!!') ;
  disp('!!!   Returning without plotting       !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;

if (size(vcolor,1) ~= 1) | (size(vcolor,2) ~= 3) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from LabeledBarPlotSM:             !!!') ;
  disp('!!!   Input vcolor invalid                       !!!') ;
  disp('!!!   Resetting to default of [0 1 0] (green)    !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vcolor = [0 1 0] ;
end ;

if std(vcolor) == 0 ;    %  then input color is gray so do B&W print
  icolorprint = 0 ;
else ;
  icolorprint = 1 ;
end ;

if isort == 0 ;
  vhtsplot = vheights ;
  LabelsPlot = Labels ;
elseif isort == 1 ;    %  Sort in order smallest to largest
  [temp,vi] = sort(vheights) ;
  vhtsplot = vheights(vi) ;
  LabelsPlot = Labels(vi) ;
elseif isort == 2 ;    %  Sort absolute values, largest to smallest
  [temp,vi] = sort(abs(vheights),'descend') ;
  vhtsplot = vheights(vi) ;
  LabelsPlot = Labels(vi) ;
elseif isort == 3 ;    %  Sort and plot absolute values, largest to smallest
  [temp,vi] = sort(abs(vheights),'descend') ;
  vhtsplot = abs(vheights(vi)) ;
  LabelsPlot = Labels(vi) ;
else ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from LabeledBarPlotSM:     !!!') ;
  disp('!!!   Input isort invalid                !!!') ;
  disp('!!!   Plotting unsorted bars             !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vhtsplot = vheights ;
  LabelsPlot = Labels ;
end ;

if isempty(vaxlim) ;
  vvax = axisSM(vheights) ;
elseif vaxlim == 1 ;
  vvax = [-1 1] ;
elseif vaxlim == 2 ;
  vvax = [0 1] ;
elseif (size(vaxlim,1) == 1) & (size(vaxlim,2) == 2) ;
  vvax = vaxlim ;
else ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from LabeledBarPlotSM:      !!!') ;
  disp('!!!   Input vaxlim invalid                !!!') ;
  disp('!!!   reverting to default: auto choice   !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  vvax = axisSM(vheights) ;
end ;



%    Make main bar plot
%
vti = 1:nb ;
colormap(vcolor) ;
bar(vti,vhtsplot(1:nb)) ;
axis([0 (nb + 1) vvax]) ;

if isempty(titlefontsize) ;
  title(titlestr) ;
else ;
  title(titlestr,'FontSize',titlefontsize) ;
end ;

for i = 1:nb ;
  if i <= length(LabelsPlot) ;
    labelht = vvax(1) + labelhtfrac * (vvax(2) - vvax(1)) ;
    if ~isempty(fontsize) ;
      text(i,labelht,LabelsPlot{i},'Rotation',90,'FontSize',fontsize) ;
    else ;
      text(i,labelht,LabelsPlot{i},'Rotation',90) ;
    end ;
  else ;
    disp('!!!  Warning from LabeledBarPlotSM: not enough labels    !!!') ;
  end ;
end;

if ~isempty(xlabelstr) ;
  if isempty(labelfontsize) ;
    xlabel(xlabelstr) ;
  else ;
    xlabel(xlabelstr,'FontSize',labelfontsize) ;
  end ;
end ;
if ~isempty(ylabelstr) ;
  if isempty(labelfontsize) ;
    ylabel(ylabelstr) ;
  else ;
    ylabel(ylabelstr,'FontSize',labelfontsize) ;
  end ;
end ;



%  Save output (if needed)
%
if ~isempty(savestr) ;   %  then create postscript file

  orient landscape ;

  if icolorprint ~= 0 ;     %  then make color postscript
    print('-dpsc',savestr) ;
  else ;                %  then make black and white
    print('-dps',savestr) ;
  end ;

end ;





