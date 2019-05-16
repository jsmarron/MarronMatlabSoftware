function NearlyNullSpacePlotSM(G,vx,nullnum,iplotorder,icolor) 
% NearlyNullSpacePlotSM
%     This creates the Nearly Null Space Plot,
%     given an input G matrix
%         Smoothness is currently based only on 1st differences
%     To compute basis elements, calls:
%         NearlyNullSpaceBasisSM
%     Which is based on functions:    threshold & SimpVsVarPlotPres,
%         by Travis Gaydos
%   Steve Marron's matlab function
%
% Inputs:
%      G          - d x d Covariance matrix 
%                      (Summarizes Genetic Variation in Evolutionary 
%                           Biology Applications)
%
%      vx         - d vector of xgrid points, 
%                       where covariances are evaluated
%                       Set to empty to get [1 2 ... d]'
%
%      nullnum    - number of null space basis elements
%                       Set to 0 to get PCA basis for G
%                       Set to d to get full null space basis
%
%      iplotorder - Index for ordering of basis function subplots
%                       1 - Classical Two Columns Top to Bottom,
%                              Starting with model PCA 
%                                  (decreasing eigenvalues down 1st column),
%                              Ending at Simplest Null
%                                  (increasing smoothness down 2nd column),
%                                      (in original 2008 version of paper)
%                       2 - U-Shaped Sequence, 
%                              Starting with model PCA 
%                                  (decreasing eigenvalues down 1st column,
%                                       then counter-clockwise up 2nd),
%                              Ending at Simplest Null
%                                  (increasing smoothness up 2nd column,
%                                       then clockwise up 1st),
%                              (default when not specified, 
%                                       in AoAS submission))
%
%      icolor     - Index of color scheme
%                       0 - Black and White
%                       1 - Full Color (Blue for Model:PCA, Red for Null:Simple)
%                               (default when not specified)
%
% Outputs:
%
%      Graphics only in the current figure window
%
%      Makes Subplots:
%        Variance-Simplicity Display, upper right
%        Power Bar Plot, lower right
%        Individual Probe Plots, left side
%            for d <= 6, use 3 x 2 array
%                 otherwise 4 x 2 array
%            for d > 8, when:
%                 nullnum < 8, plot 1st (8 - nullnum) model probes, 
%                                         and nullnum null probes
%                 nullnum > (d - 8), plot 1st (d - nullnum) model probes,
%                                         and (8 - d - nullnum) null probes
%                 otherwise, plot 1st 4 model probes, and 4 null probes
%
%
% Assumes path can find personal functions:
%    NearlyNullSpaceBasisSM
%    vec2matSM.m

%    Copyright (c) T. Gaydos, J. S. Marron, 2008-2012



%  Check Inputs
%
d = size(G,1) ;
inpcplot = d - nullnum ;
insmoothplot = nullnum ;

if ~(d == size(G,2)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from NearlyNullSpacePlotSM    !!!') ;
  disp('!!!   Input G must be square              !!!') ;
  disp('!!!   Terminating Execution               !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  return ;
end ;

if isempty(vx) ;
  ivx = (1:d)' ;
else ;
  ivx = vx ;
end ;


%  Turn ivx into a column vector
%
if size(ivx,1) > 1 ;
  if size(ivx,2) == 1 ;
    ivx = ivx' ;
  else
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from NearlyNullSpacePlotSM    !!!') ;
    disp('!!!   vx must be a vector                   !!!') ;
    disp('!!!   Resetting to vx = [1 2 ... d]''        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ivx = (1:d)' ;
  end ;
end;    


if ~(d == length(ivx)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from NearlyNullSpacePlotSM    !!!') ;
  disp('!!!   vx has wrong length                   !!!') ;
  disp('!!!   Resetting to vx = [1 2 ... d]''        !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  ivx = (1:d)' ;
end ;



%  Set last 4 parameters according to number of input arguments
%
if nargin < 4 ;       %  less than 4 argument inputs, use default iplotorder
  iiplotorder = 2 ;
else ;                 %  then use input value
  iiplotorder = iplotorder ;
end ;

if nargin < 5 ;       %  less than 5 argument inputs, use default icolor
  mcolor = [[1 0 0]; ...
            [0 0 1]] ;
      %  Default of red for simplicity, blue for model PCA
else ;                 %  then use input value
  if icolor == 1 ;
    mcolor = [[1 0 0]; ...
              [0 0 1]] ;
        %  Default of red for simplicity, blue for model PCA
  elseif icolor == 0 ;
    mcolor = [[0 0 0]; ...
              [0.7 0.7 0.7]] ;
        %  Black for simplicity, gray for model PCA
  else ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from NearlyNullSpacePlotSM    !!!') ;
    disp('!!!   invalid icolor                        !!!') ;
    disp('!!!   Resetting to default icolor = 1       !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    mcolor = [[1 0 0]; ...
              [0 0 1]] ;
        %  Default of red for simplicity, blue for model PCA
  end ;
end ;



%  Get basis Probes and Eigenvalues from NearlyNullSpaceBasisSM
%
[mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,ivx,nullnum,inpcplot,insmoothplot) ;

  vpceigval = getfield(indexstruct,'vpceigval') ;
  vsmootheigval = getfield(indexstruct,'vsmootheigval') ;
  vpcsmooth = getfield(indexstruct,'vpcsmooth') ;
  vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth') ;
  vallsmosmooth = getfield(indexstruct,'vallsmosmooth') ;


%  Calculate Scores
%
vpcrelvar = vpceigval / sum(vpceigval) ;
    %  fraction of total variation in each pc probe
vsmoothrelvar = vsmootheigval / sum(vpceigval) ;
    %  fraction of total variation in each smooth probe
vpcsimp = 4 - vpcsmooth ;
    %  subtract from max possible smoothness index (4) 
    %  simplicity index of pc probes
vsmoothsimp = 4 - vsmoothsmooth ;
    %  simplicity index of null space smooth probes
vallsmosimp = 4 - vallsmosmooth ;
    %  simplicity index of all possible smooth probes



%  Create Graphical output
clf ;

%  Make Upper Right Variance-Simplicity plot
%
if d <= 6 ;
  subplot(3,4,[3 4 7 8])
else ;
  subplot(4,4,[3 4 11 12])
end ;
paxis = axisSM([0 max(vpcrelvar)],[0 4]) ;
textgap = 0.025 * (paxis(2) - paxis(1)) ;
hold on ;
for i = 1:nullnum ;    %  plot null probe indices
  plot(vsmoothrelvar(i),vsmoothsimp(i),'o','Color',mcolor(1,:)) ;
  text(vsmoothrelvar(i) + textgap,vsmoothsimp(i),num2str(i),'color',mcolor(1,:))
end ;
for i = 1:(d - nullnum) ;    %  plot pc probe indices
  plot(vpcrelvar(i),vpcsimp(i),'*','Color',mcolor(2,:)) ;
  text(vpcrelvar(i) + textgap,vpcsimp(i),num2str(i),'color',mcolor(2,:))
end ;
xlabel('Proportion of Var Explained');
ylabel('Simplicity Score(complex to simple)');
title('Variance-Simplicity View')
axis(paxis);
plot([paxis(1) paxis(2)],[vallsmosimp vallsmosimp],'k--')
hold off ;


%  Make Power Graph in lower right corner
%
if d <= 6 ;
  subplot(3,4,[11 12])
else ;
  subplot(4,4,[15 16])
end ;
smoothtotfrac = sum(vsmoothrelvar) ;
plot([0 smoothtotfrac],[1 1],'-','linewidth',10,'Color',mcolor(1,:))
hold on;
plot([smoothtotfrac 1],[1 1],'-','linewidth',10,'Color',mcolor(2,:))
plot([smoothtotfrac smoothtotfrac], [.5 1.5],'k','linewidth',3)
text(.05,.25,['Null% = ' num2str(round(100 * smoothtotfrac))],'color',mcolor(1,:));
text(.05,1.75,['Model% = ' num2str(100-round(100 * smoothtotfrac))],'color',mcolor(2,:));      
axis(axisSM([0 1],[0 2]))
hold off;


%  Make 2 columns of individual probe plots on left side
%
if d <= 6 ;

  if iiplotorder == 1 ;
    visubplot = [1 5 9 2 6 10] ;
        %  Gives classical 2 column ordering
  elseif iiplotorder == 2 ;
    visubplot = [1 5 9 10 6 2] ;
        %  Gives U shaped ordering
  else ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from NearlyNullSpacePlotSM    !!!') ;
    disp('!!!   Invalid iplotorder                  !!!') ;
    disp('!!!   Terminating Execution               !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    clf ;
    return ;
  end ;

  nmodplots = min([(d - nullnum) inpcplot]) ;
  nnullplots = min([nullnum insmoothplot]) ;

else ;

  if iiplotorder == 1 ;
    visubplot = [1 5 9 13 2 6 10 14] ;
        %  Gives classical 2 column ordering
  elseif iiplotorder == 2 ;
    visubplot = [1 5 9 13 14 10 6 2] ;
        %  Gives U shaped ordering
  else ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from NearlyNullSpacePlotSM    !!!') ;
    disp('!!!   Invalid iplotorder                  !!!') ;
    disp('!!!   Terminating Execution               !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    clf ;
    return ;
  end ;

  if d <= 8 ;
    nmodplots = min([(d - nullnum) inpcplot]) ;
    nnullplots = min([nullnum insmoothplot]) ;
  else ;
    if nullnum < 4 ;
      nnullplots = nullnum ;
      nmodplots = 8 - nnullplots ;
    elseif nullnum > (d - 4) ;
      nmodplots = (d - nullnum) ;
      nnullplots = 8 - nmodplots ;
    else ;
      nmodplots = 4 ;
      nnullplots = 4 ;
    end ;
  end ;
  
end ;


%  Add PCA (model) probe panels
%
for iplot = 1:nmodplots ;

  if d <= 6 ;
    subplot(3,4,visubplot(iplot)) ;
  else ;
    subplot(4,4,visubplot(iplot)) ;
  end ;

  plot(ivx,mpcprobes(:,iplot),'-','linewidth',3,'color',mcolor(2,:))
  hold on;
  vax = axisSM(ivx,[mpcprobes(:,iplot); 0]) ;
  axis(vax) ;
  text(ivx(1),vax(3) + 0.92 * (vax(4) - vax(3)),num2str(iplot),'color',mcolor(2,:))
  plot([vax(1); vax(2)],[0; 0],'k:') ;
  if iplot == 1 ;
    title('Model PCA Probes','Color',mcolor(2,:)) ;
  end ;
  hold off;

end ;


%  Add null probe panels
%
for iplot = 1:nnullplots ;
  if d <= 6 ;
    subplot(3,4,visubplot(7 - iplot)) ;
  else ;
    subplot(4,4,visubplot(9 - iplot)) ;
  end ;

  plot(ivx,msmoothprobes(:,iplot),'r--','linewidth',3,'color',mcolor(1,:)) ;
  hold on ;
  vax = axisSM(ivx,[msmoothprobes(:,iplot); 0]) ;
  axis(vax) ;
  text(ivx(1),vax(3) + 0.92 * (vax(4) - vax(3)),num2str(iplot),'color',mcolor(1,:)) ;
  plot([vax(1); vax(2)],[0; 0],'k:') ;
  if iplot == 1 ;
    title('Null Smooth Probes','Color',mcolor(1,:)) ;
  end ;
  hold off;

end ;



