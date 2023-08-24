function [ROCcurve,AUC] = ROCcurveSM(dataplus,dataminus,paramstruct) 
% ROCcurveSM, Receiver Operating Characteristic Curve
%     Gives a curve lying in [0,1]x[0,1], which quantifies the
%     amount of "overlap" of two univariate data sets, where 
%     dataplus is considered to the "to the right" of dataminus.
%     A sequence of "Test Cutoff Points", x, ranging over the real line,
%     generates the curve as:
%         horizontal coordinate = P{dataplus <= x}
%           vertical coordinate = P{dataminus <= x}
%     Probabilities are calculated using the Continuous Probability function:
%         cprobSM
%     Either data set can also be a (discretized version of a)
%     theoretical probability distribution, 
%     by inputting appropriate quantiles
%     AUC is the simple numerical summary (useful for simple
%     comparison of several ROC curves) of Area Under the Curve
%   Requires first 2 arguments.
%   Steve Marron's matlab function
% Inputs:
%
%     dataplus - np x 1 (column) vector of univariate data,
%                    usually thought of as "larger than" dataminus
%                can also be a 1 x nc cell array of such vectors
%                    e.g. can create this using 'dataplus = {v1 v2}", 
%                             for vectors v1 and v2
%
%    dataminus - nm x 1 (column) vector of univariate data
%                can also be a 1 x nc cell array of such vectors
%                    (when nc > 1, this must be the same as for dataplus)
%
%   paramstruct - an optional Matlab structure of input parameters
%                    Note: this can be set to number 0, to avoid plotting
%
%                    Use: "help struct" and "help datatypes" to
%                         learn about these.
%                    Create one, using commands of the form:
%
%       paramstruct = struct('field1',values1, ...
%                            'field2',values2, ...
%                            'field3',values3) ;
%
%                          where any of the following can be used,
%                          these are optional, misspecified values
%                          revert to defaults
%
%    fields            values
%
%    iplot            index for whether or not to generate graphic of 
%                     the ROC curve, in the current figure
%                     0  Don't make graphic, only output numerical values
%                            Recall can also achieve this by setting:
%                                               paramstruct = 0
%                     1  (default)  Make ROC graphic
%
%    icolor           0  fully black and white version (everywhere)
%                     string (any of 'r', 'g', 'b', etc.) that single color
%                     1  (default)  color version (Matlab 7 color default)
%                     2  time series version (ordered spectrum of colors)
%                     nc x 3 color matrix:  a color label for each curve
%                              (useful for comparing populations)
%
%    linewidth        line width of plotted ROC curve  (default = 2) 
%
%    legendcellstr    cell array of strings for legend (nc of them),
%                     useful for labelling (colored) curves, create this using
%                     cellstr, or {{string1 string2 ...}}
%                         Note:  These strange double brackets seems to be needed
%                                for correct pass to subroutine
%                                It may change in later versions of Matlab
%                     CAUTION:  If are updating this field, using a command like:
%                         paramstruct = setfield(paramstruct,'legendcellstr',...
%                     Then should only use single braces in the definition of
%                     legendecellstr, i. e. {string1 string2 ...}
%
%        titlestr     string with title for output graphic
%                     (default is 'ROC curve')
%
%    titlefontsize    font size for title
%                           (only has effect when plot is made here,
%                            and when the titlecellstr is nonempty)
%                     (default is empty, [], for Matlab default)
%
%        xlabelstr    string with label for horizontal (x) axis
%                     (default is 'P{dataplus <= testpoint}')
%
%        ylabelstr    string with label for vertical (y) axis
%                     (default is 'P{dataminus <= testpoint}')
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
%                             color postscript (icolor ~= 0)
%                         or
%                             black&white postscript (when icolor = 0)
%                         unspecified:  results only appear on screen
%
%
% Outputs:
%
%        ROCcurve - (np + nm + 2) x 2   matrix of values 
%                           (coordinates of series of points in [0,1] x [0,1]) 
%                       of Receiver Operating Characteristic curve 
%                           (linear interpolation of these generates the curve)
%                       1st column is P{dataplus <= x}
%                       2nd column is P{dataminus <= x}
%                           (this is an nc x 1 cell array if either of 
%                                   dataplus or dataminus is)
%
%             AUC - scalar value of Area Under the (ROC) Curve
%                       (in the unit square, [0,1] x [0,1])
%                           (this is an nc x 1 cell array if either of 
%                                   dataplus or dataminus is)
%
%     Graphics in current Figure
%     When savestr exists, generate output files, 
%        as indicated by savetype
%
%
% Output:
%
% Assumes path can find personal functions:
%    cprobSM.m
%    vec2matSM.m

%    Copyright (c) J. S. Marron 2010-2023



%  Unpack Data Cell Arrays (if needed)
%
if iscell(dataplus)
  pluscellflag = true ;
  ncp = length(dataplus) ;
else
  pluscellflag = false ;
  vdataplus = dataplus ; %#ok<NASGU>
end

if iscell(dataminus)
  minuscellflag = true ;
  ncm = length(dataminus) ;
else
  minuscellflag = false ;
  vdataminus = dataminus ; %#ok<NASGU>
end

if pluscellflag & minuscellflag %#ok<AND2>
  if ncp == ncm
    nc = ncp ;
  else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from ROCcurveSM.m:     !!!') ;
    disp('!!!   Input Cell Arrays,           !!!') ;
    disp('!!!       dataplus and dataminus   !!!') ;
    disp('!!!   must have the same number    !!!') ;
    disp('!!!   of entries                   !!!') ;
    disp('!!!   Giving empty returns         !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ROCcurve = [] ;
    AUC = [] ;
    return ;
  end
elseif minuscellflag
  nc = ncm ;
elseif pluscellflag
  nc = ncp ;
else
  nc = 1 ;
end



%  Set all parameters to defaults
%
iplot = 1 ;
icolor = 1 ;
linewidth = 2 ;
legendcellstr = {} ;
titlestr = 'ROC curve' ;
titlefontsize = [] ;
xlabelstr = 'P[dataplus <= testpoint]' ;
ylabelstr = 'P[dataminus <= testpoint]' ;
labelfontsize = [] ;
savestr = [] ;
savetype = 1 ;


%  Now update graphics parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2   %  then paramstruct is an argument

  if isstruct(paramstruct)

    if isfield(paramstruct,'iplot')    %  then change to input value
      iplot = paramstruct.iplot ;
    end

    if isfield(paramstruct,'icolor')    %  then change to input value
      icolor = paramstruct.icolor ;
    end

    if isfield(paramstruct,'linewidth')    %  then change to input value
      linewidth = paramstruct.linewidth ;
    end

    if isfield(paramstruct,'legendcellstr')    %  then change to input value
      legendcellstr = paramstruct.legendcellstr ;
    end

    if isfield(paramstruct,'titlestr')    %  then change to input value
      titlestr = paramstruct.titlestr ;
    end

    if isfield(paramstruct,'titlefontsize')    %  then change to input value
      titlefontsize = paramstruct.titlefontsize ;
    end

    if isfield(paramstruct,'xlabelstr')    %  then change to input value
      xlabelstr = paramstruct.xlabelstr ;
    end

    if isfield(paramstruct,'ylabelstr')    %  then change to input value
      ylabelstr = paramstruct.ylabelstr ;
    end

    if isfield(paramstruct,'labelfontsize')    %  then change to input value
      labelfontsize = paramstruct.labelfontsize ;
    end

    if isfield(paramstruct,'savestr')    %  then use input value
      savestr = paramstruct.savestr ;
      if  ~ischar(savestr)  &&  ~isempty(savestr)
                            %  then invalid input, so give warning
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Warning from scatplotSM.m:   !!!') ;
        disp('!!!   Invalid savestr,             !!!') ;
        disp('!!!   using default of no save     !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        savestr = [] ;
      end
    end
  
    if isfield(paramstruct,'savetype')     %  then use input value
      savetype = paramstruct.savetype ; 
    end 

  else

    if paramstruct == 0
      iplot = 0 ;
    end

  end

end



%  Set up appropriate colors
%
if  size(icolor,1) == 1   &&  size(icolor,2) == 1    %  then have scalar input

  if icolor == 0    %  then do everything black and white

    pcolor = 'k' ; 
    multicolorflag = 0 ;

  elseif ischar(icolor)

    pcolor = icolor ;
        %  string for color of projection dots
    multicolorflag = 0 ;

  elseif icolor == 1    %  then do MATLAB 7 color default

    colmap1 = [     0         0    1.0000 ; ...
                    0    0.5000         0 ; ...
               1.0000         0         0 ; ...
                    0    0.7500    0.7500 ; ...
               0.7500         0    0.7500 ; ...
               0.7500    0.7500         0 ; ...
               0.2500    0.2500    0.2500 ] ;
        %  color of projection dots, matlab default
    colmap = colmap1 ;
    while size(colmap,1) < nc
      colmap = [colmap; colmap1] ; %#ok<AGROW>
    end
    colmap = colmap(1:nc,:) ;

    multicolorflag = 1 ;


  elseif icolor == 2    %  then do spectrum for ordered time series

    colmap = RainbowColorsQY(nc) ;

    multicolorflag = 1 ;

  end

elseif  size(icolor,2) == 3    %  then have valid color matrix

  if  size(icolor,1) == 1
    pcolor = icolor ;
    multicolorflag = 0 ;
  else
    colmap = icolor ;
    multicolorflag = 1 ;
  end

else    %   invalid color matrix input

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from projplot1SM.m:           !!!') ;
  disp('!!!   Invalid icolor input,               !!!') ;
  disp('!!!   must be a scalar, or color matrix   !!!') ;
  disp('!!!   Terminating execution               !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;

end



legendflag = ~isempty(legendcellstr) ;
    %  logica1 for when there are legends to write



%  Set up output graphics (if needed)
%
if iplot ~= 0    %  then make output plot

  axis([0 1 0 1]) ;
  axis square ;
  if ~isempty(titlestr)
    if ~isempty(titlefontsize)
      title(titlestr,'FontSize',titlefontsize) ;
    else
      title(titlestr) ;
    end
  end
  if ~isempty(xlabelstr)
    if ~isempty(labelfontsize)
      xlabel(xlabelstr,'FontSize',labelfontsize) ;
    else
      xlabel(xlabelstr) ;
    end
  end
  if ~isempty(ylabelstr)
    if ~isempty(labelfontsize)
      ylabel(ylabelstr,'FontSize',labelfontsize) ;
    else
      ylabel(ylabelstr) ;
    end
  end

end



%  Loop through number of curves
%
if nc > 1
  cellROC = {} ;
  cellAUC = {} ;
end
for ic = 1:nc

  if nc > 1    %  then need to unpack appropriate cell arrays
    if pluscellflag
      vdataplus = dataplus{ic} ;
    else
      vdataplus = dataplus ;
    end
    if minuscellflag
      vdataminus = dataminus{ic} ;
    else
      vdataminus = dataminus ;
    end
  else    %  both inputs are vectors
    vdataplus = dataplus ;
    vdataminus = dataminus ;
  end


  %  Check inputs are column vectors
  %
  if size(vdataplus,2) ~= 1
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from ROCcurveSM:   !!!') ;
    disp('!!!   Input vdataplus must     !!!') ;
    disp('!!!   be a column vector.      !!!') ;
    disp('!!!   Giving empty returns     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ROCcurve = [] ;
    AUC = [] ;
    return ;
  end
  if size(vdataminus,2) ~= 1
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from ROCcurveSM:   !!!') ;
    disp('!!!   Input vdataminus must    !!!') ;
    disp('!!!   be a column vector.      !!!') ;
    disp('!!!   Giving empty returns     !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ROCcurve = [] ;
    AUC = [] ;
    return ;
  end


  %  Calculate ROC curve
  %
  if min(vdataplus) <= max(vdataminus)    %  then there is overlap
     vpts = sort([vdataminus; vdataplus]) ;
       %  sorted vector of all input data points
  else    %  no overlap, so add one more point (to get "into corner")
     vpts = sort([vdataminus; mean([max(vdataminus) min(vdataplus)]); vdataplus]) ;
  end
  ROCcurve = [cprobSM(vdataplus,vpts) cprobSM(vdataminus,vpts)] ;
  ROCcurve = [[0 0]; ROCcurve; [1 1]] ; %#ok<AGROW>


  %  Calculate AUC 
  %
  ntrap = size(ROCcurve,1) - 1 ;
      %  number of trapezoids
  AUC = 0 ;
  for itrap = 1:ntrap
    AUC = AUC + (ROCcurve(itrap + 1,1) - ROCcurve(itrap,1)) * ...
                (ROCcurve(itrap + 1,2) + ROCcurve(itrap,2)) / 2 ;
  end


  %  Add to output graphics (if needed)
  %
  if iplot ~= 0    %  then add to output plot

    hold on ;
    if multicolorflag == 0    %  Then use common color everywhere
      plot(ROCcurve(:,1),ROCcurve(:,2),'linewidth',linewidth,'Color',pcolor) ;
      if legendflag    %  then write input legend
        text(0.2,(nc - ic + 1) / (nc + 1), ...
             [legendcellstr{ic} '   AUC = ' num2str(AUC)], ...
             'Color',pcolor) ;
      else    %  then write only AUC
        text(0.7,(nc - ic + 1) / (nc + 1), ...
             ['AUC = ' num2str(AUC)], ...
             'Color',pcolor) ;
      end
    else    %  get individual colors from colmap
      plot(ROCcurve(:,1),ROCcurve(:,2),'linewidth',linewidth,'Color',colmap(ic,:)) ;
      if legendflag    %  then write input legend
        text(0.2,(nc - ic + 1) / (nc + 1), ...
             [legendcellstr{ic} '   AUC = ' num2str(AUC)], ...
             'Color',colmap(ic,:)) ;
      else    %  then write only AUC
        text(0.7,(nc - ic + 1) / (nc + 1), ...
             ['AUC = ' num2str(AUC)], ...
             'Color',colmap(ic,:)) ;
      end
    end
    hold off ;

  end


  %  Store in output cell arrays (if needed)
  %
  if nc > 1
    cellROC{ic} = ROCcurve ; %#ok<AGROW>
    cellAUC{ic} = AUC ; %#ok<AGROW>
  end


end    %  of loop through output curves



%  Save output graphics (if needed)
%
if ~isempty(savestr)    %  then save graphics

  printSM(savestr,savetype) ;

end



%  Put cell arrays into output arguments (if needed)
%
if nc > 1
  ROCcurve = cellROC ;
  AUC = cellAUC ;
end


