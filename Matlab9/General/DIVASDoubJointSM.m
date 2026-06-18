function outstruct = DIVASDoubJointSM(mX,mY,paramstruct) 
% DIVAS Doubly Joint version
%     For matrices with both rows (scores) and columns (loadings) 
%     that correspond, does doubly joint (then other) decompositions
%     in an iterative fashion, stopping when there seems to be no 
%     remaining signal (or at a pre-specified number of steps)
%
%
% Inputs:
%   mX          - d x n matrix of X data
%                     Recommend both row and column recentering first
%
%   mY          - d x n matrix of Y data
%                     with corresponding rows and columns
%                     Recommend both row and column recentering first
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
%                          these are optional, misspecified values
%                          revert to defaults
%
%                    Version for easy copying and modification:
%     paramstruct = struct('',, ...
%                          '',, ...
%                          '',) ;
%
%    fields            values
%
%    imptype          implementation type:
%                          1 - original greedy angle based implementation
%                                  from DoublyJointToy8.m  (current default)
%                          2 - subspace partition based implementation and QZ
%                                  from DoublyJointToy9.m
%                          3 - subspace partition based implementation and 
%                                  Tensor Decomposition from DoublyJointToy10.m
%    
%    iScaleStand      indicator for Scale Standardization 
%                          0 - Do not Scale Standardize
%                                  In this case, each data block should have
%                                  overall noise standard deviation 1
%                          1 - (default) Estimate overall standard 
%                                  deviation for each block using 
%                                  TriME, and rescale each
%
%    nThreshSim       number of simulations to find thresholds
%                          0 - No simulation, use crude Marcenko-Pastur bounds
%                                  (these tend to be too permissive)
%                          n - Number of simulations to compute thresholds,
%                                  (default 1000)
%
%    vthresh          vector of thresholds for singular values, 
%                          assuming N(0,1) scaling  (empty default):
%                                  vthresh(1) = threshXnY
%                                  vthresh(2) = threshU
%                                  vthresh(3) = threshV
%                     Suggest getting these as 
%                                  outstruct.vthresh
%                          from previous run of DIVASDoubJointSM
%                     Only has effect for nThreshSim = 0 
%
%    prob             cutoff probability,  for thresholds whose quantile
%                          is desired
%                     default is 0.99
%
%    simseed          seed for simulation computation (used as "rng(simseed)")
%                     should be <= 8 digit integer,
%                     default is Matlab default of 0
%
%    nmaxstep         maximum number of steps (default of 10)
%
%    iDiagPlot        0  Make no diagnostic plots
%                     1  (default) Make diagnostic plots
%
%    iHeatMap         0  Make no Heat Maps of modes (just compute output)
%                     1  (default) Make Heat Maps of discovered modes
%
%    alpha            Heatmap parameter:   
%                     Proportion of data in larger of first and last bin
%                              (default = 0.05)
%                     For manually set range (not based on quantiles 
%                            as above), make this a 2 x 1 vector:
%                                  [lovalue; hivalue]
%
%    OutPlotStr      String for saving output plots
%                         (leave empty for default of no plot save)
%
%    savetype         indicator of output file type:
%                          1 - (default)  Matlab figure file (.fig)
%                          2 - (.png)  raster graphics
%                          3 - (.pdf)  vector graphics
%                          4 - (.eps)  Color vector 
%                                      (use when icolor is not 0)
%                          5 - (.eps)  Black and White vector 
%                                      (use when icolor = 0)
%                          6 - (.jpg)  raster
%                          7 - (.svg)  vector    
%
%    iscreenwrite     0  (default)  no screen writes
%                     1  write to screen to show progress
%
%
% Outputs:
%
%   outstruct   - a Matlab structure of results, with fields:
%                      outstruct.vthresh:    3 x 1 vector of thresholds
%                          1.  threshold for normalized X and Y matrices
%                          2.  threshold for U (horizontally concatenated) matrix
%                          3.  threshold for V (vertically concatenated) matrix 
%                      outstruct.caXmodes:  Cell Array of X modes of variation
%                      outstruct.caYmodes:  Cell Array of Y modes of variation
%                          Rows are corresponding modes
%                          Columns are:
%                              1.  Symbol for mode type,  
%                                       'D' - Doubly Joint
%                                       'SU' - U Singly Joint
%                                       'SV' - V Singly Joint
%                                       'I' - Individual
%                                       'N' = Other block individual, 
%                                                     so leave blank
%                              2.  Coefficient for node  (empty for 'N')
%                              3.  d x 1 u vector of mode  (empty for 'N')
%                              4.  n x 1 v vector of mode  (empty for 'N')
%
%   Graphics in new figures when iDiagPlot = 1
%   When OutPlotStr exists, generate output files, 
%       as indicated by savetype
%
% 
% Assumes path can find functions:
%    modeDfitSM
%    modeSUfitSM
%    modeSVfitSM
%    modeIfitSM
%    TriME 
%    fit_dj_cp
%

%    Copyright (c) J. S. Marron 2026


%  First set all parameters to defaults
%
imptype = 1 ;
iScaleStand = 1 ;
nThreshSim = 1000 ;
vthresh = [] ;
prob = 0.99 ;
simseed = 0 ;
nmaxstep = 10 ;
iDiagPlot = 1 ;
iHeatMap = 1 ;
alpha = 0.05 ;
OutPlotStr = [] ;
savetype = 1 ;
iscreenwrite = 0 ;

%  Now update parameters as specified,
%  by parameter structure (if it is used)
%
if nargin > 2   %  then paramstruct is an argument

  if isfield(paramstruct,'imptype')    %  then change to input value
    imptype = paramstruct.imptype ;
  end

  if isfield(paramstruct,'iScaleStand')    %  then change to input value
    iScaleStand = paramstruct.iScaleStand ;
  end

  if isfield(paramstruct,'nThreshSim')    %  then change to input value
    nThreshSim = paramstruct.nThreshSim ;
  end

  if isfield(paramstruct,'vthresh')    %  then change to input value
    vthresh = paramstruct.vthresh ;
  end

  if isfield(paramstruct,'prob')    %  then change to input value
    prob = paramstruct.prob ;
  end

  if isfield(paramstruct,'simseed')    %  then change to input value
    simseed = paramstruct.simseed ;
  end

  if isfield(paramstruct,'nmaxstep')    %  then change to input value
    nmaxstep = paramstruct.nmaxstep ;
  end

  if isfield(paramstruct,'iHeatMap')    %  then change to input value
    iHeatMap = paramstruct.iHeatMap ;
  end

  if isfield(paramstruct,'alpha')    %  then change to input value
   alpha = paramstruct.alpha ; 
  end

  if isfield(paramstruct,'OutPlotStr')    %  then change to input value
    OutPlotStr = paramstruct.OutPlotStr ;
  end

  if isfield(paramstruct,'savetype')    %  then change to input value
    savetype = paramstruct.savetype ;
  end

%{
  if isfield(paramstruct,'')    %  then change to input value
     = paramstruct. ;
  end
%}

  if isfield(paramstruct,'iscreenwrite')    %  then change to input value
    iscreenwrite = paramstruct.iscreenwrite ;
  end

end    %  of resetting of input parameters


if iscreenwrite == 1 
  disp('Running function DIVASDoubJointSM.m') ;
  disp(' ') ;
end


%  Check input data
%
d = size(mX,1) ;
         %  number of rows of input mX
n = size(mX,2) ;
         %  number of columns of input mX
if  (size(mY,1) ~= d)  |  (size(mY,2) ~= n)
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DIVASDoubJointSM.m:   !!!') ;
  disp('!!!   Inputs mX and mY must have       !!!') ;
  disp('!!!   the same dimensions              !!!') ;
  disp('!!!   Terminating execution            !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  outstruct = 'Not defined yet' ;
  return ;
end


%  Estimate noise levels for each input and normalize
%
beta = min(d,n) / max(d,n) ;
    %  Marcenko Pasturn parameter
[mU_X,dmlam_X,mV_X] = svd(mX,'econ') ;
[mU_Y,dmlam_Y,mV_Y] = svd(mY,'econ') ;
    %  minimal rank versions of svd
    %  Organized as o. n. Basis matrices, and 
    %  diagonal matrix of singular values
vlam_X = diag(dmlam_X) ;
vlam_Y = diag(dmlam_Y) ;
    %  vectors of singular values
if iScaleStand == 1     %  Use TriME standardization 

  %  Calculate Emma Mitchell's estimate of noise standard deviation
  %  Described in her PhD dissertation:
  %      "STATISTICAL METHODS FOR GENOMIC DATA ANALYSIS"
  %
  c = min(d,n) / max(d,n) ;
  SigEstX = TriME(c,vlam_X/sqrt(max(d,n)),1,'/temp',0.01,0,0.25,false) ;
  SigEstY = TriME(c,vlam_Y/sqrt(max(d,n)),1,'/temp',0.01,0,0.25,false) ;
      %  1 and '/temp' not relevant, since don't make graphics
      %  Other parameters are defaults suggested in dissertation:
      %      alpha1 = 0.01 
      %      alpha2 = 0
      %      omega = 0.25
      %  sve = false turns off graphics

  if iscreenwrite == 1 
    disp(['    Estimated mX standard deviation = ' num2str(SigEstX)]) ;
    disp(['    Estimated mY standard deviation = ' num2str(SigEstY)]) ;
  end

  if SigEstX == 0
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from DIVASDoubJointSM.m                !!!') ;
    disp('!!!   Unable to estimate X background noise level  !!!') ;
    disp('!!!   Basic assumption seems violated              !!!') ;
    disp('!!!   Terminating with empty return                !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    outstruct = [] ;
    return 
  elseif SigEstY == 0
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from DIVASDoubJointSM.m                !!!') ;
    disp('!!!   Unable to estimate Y background noise level  !!!') ;
    disp('!!!   Basic assumption seems violated              !!!') ;
    disp('!!!   Terminating with empty return                !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    outstruct = [] ;
    return 
  else
    mXs = mX / SigEstX ;
    mYs = mY / SigEstY ;
        %  Normalize so noise part of each block has overall SD 1
  end


else     %  Proceed with original data

  mXs = mX ;
  mYs = mY ;

end 


%  Get thresholds
%
if nThreshSim == 0     %  Use crude Marcenko-Pastur bounds
                       %      from DoublyJointToy7

  if isempty(vthresh) 

    if iscreenwrite == 1 
      disp('Using naive thresholds') ;
      disp(' ') ;
    end

    threshXnY = sqrt(min(d,n)) * (1 + sqrt(max(d,n) / min(d,n))) ;
    threshU = sqrt(2 * n) * (1 + sqrt(d / (2 * n))) ;
    threshV = sqrt(2 * d) * (1 + sqrt(n / (2 * d))) ;

    vthresh = [] ;

  else

    if iscreenwrite == 1 
      disp('Using input thresholds') ;
      disp(' ') ;
    end

    threshXnY = vthresh(1) ;
    threshU = vthresh(2) ;
    threshV = vthresh(3) ;

  end


else    %  Compute simulated thresholds, from DoublyJointSim1.m

  if iscreenwrite == 1 
    disp('Computing N(0,1) simulated thresholds') ;
    disp(' ') ;
  end

  rng(simseed) ;

  %  Main Simulation Loop
  %
  vSingLam1 = [] ;
  vHorizLam1 = [] ;
  vVertLam1 = [] ;
  for isim = 1:nThreshSim

    if  (isim / 100) == floor(isim / 100)  &  iscreenwrite == 1 
      disp(['    Working on sim ' num2str(isim) ' of ' num2str(nThreshSim)]) ;
    end

    %  Generate Pure Noise N(0,1) data sets
    %
    mSing = randn(d,n) ;
    mHoriz = randn(d,2 * n) ;
    mVert = randn(2 * d,n) ;

    %  Compute and save first singular values
    %
    SingLam1 = svds(mSing,1) ;
    HorizLam1 = svds(mHoriz,1) ;
    VertLam1 = svds(mVert,1) ;
    vSingLam1 = [vSingLam1; SingLam1] ;
    vHorizLam1 = [vHorizLam1; HorizLam1] ;
    vVertLam1 = [vVertLam1; VertLam1] ;

  end    %  of main simulation Loop

  threshXnY = cquantSM(vSingLam1,prob) ;
  threshU = cquantSM(vHorizLam1,prob) ;
  threshV = cquantSM(vVertLam1,prob) ;

end     %  of threshold if-block

vthreshout = [threshXnY; threshU; threshV] ;
outstruct.vthresh = vthreshout ;



if  imptype == 1  ;     %  1 - Original greedy implementation
                        %          from DoublyJointToy8.m

  %  Initialize running matrices and cell arrays
  %
  mE_X = mXs ;
  mE_Y = mYs ;
      %  Matrices of remaining variation 
      %      (starting with everything as "noise"
      %       and iteratively extracting signal modes)
      %  Using A + E (signal + noise) notation from DIVAS
  mA_X = zeros(d,n) ;
  mA_Y = zeros(d,n) ;
      %  Cumulative Signal Matrices
      %  Will update, with X = A_X + E_X and Y = A_Y + E_Y at each step
  nmodes = 0 ;
      %  number of modes of variation found so far
  caXmodes = {} ;
  caYmodes = {} ;
      %  cell arrays of significant modes of variation
  iDJmodefig = 0 ;
  iSUJmodefig = 0 ;
  iSVJmodefig = 0 ;
  iImodefig = 0 ;
      %  indices of figures already made for each mode type

  %  Compute X and Y SVDs
  %
  [mU_X,dmlam_X,mV_X] = svd(mE_X,'econ') ;
  [mU_Y,dmlam_Y,mV_Y] = svd(mE_Y,'econ') ;
      %  minimal rank versions of svd
      %  Organized as o. n. Basis matrices 
      %  diagonal matrix of singular values
  vlam_X = diag(dmlam_X) ;
  vlam_Y = diag(dmlam_Y) ;
      %  vectors of singular values

  %  Find Separate Blocks Initial Ranks
  %
  vflag_X = (vlam_X > threshXnY) ;
  [~,r_X] = min(vflag_X) ;    %  index of first 0
  r_X = r_X - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of X signal A
  vflag_Y = (vlam_Y > threshXnY) ;
  [~,r_Y] = min(vflag_Y) ;    %  index of first 0
  r_Y = r_Y - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Y signal A
  if iscreenwrite == 1
    disp(' ') ;
    disp(['Initial estimated rank of X signal (= A_X) is ' num2str(r_X)]) ;
    disp(['Initial estimated rank of Y signal (= A_Y) is ' num2str(r_Y)]) ;
  end

  %  Define number of decomposition steps to consider
  %
  nstep = r_X + r_Y ;
  if iscreenwrite == 1
    disp(' ') ;
    disp(['Number of steps to consider (max filtered rank) = ' ...
               num2str(nstep)]) ;
    if nstep > nmaxstep
      disp(['But will only calculate input maxnstep = ' ...
               num2str(nmaxstep) ' steps']) ;
      nstep = nmaxstep ;
    end
  else
    if nstep > nmaxstep
      nstep = nmaxstep ;
    end
  end

  if iDiagPlot == 1 
    %  Start rank diagnostic plot
    %
    fh1 = figure('WindowStyle','normal') ;
    clf ;
    set(fh1,'Position',[100 100 1000 600]) ;
    lam_max = max([vlam_X; vlam_Y; threshV]) ;
    vax = [0 (n + 1) 0 (1.05 * lam_max)] ;
        %  biggest of singular values

    subplot(2,3,1) ;    %  X only
      plot((1:length(vlam_X))',vlam_X,'ko-') ;
      xlabel('k') ;
      ylabel('lambda X') ;
      title(['X Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_X = ' num2str(r_X)]) ;
      hold off ;

    subplot(2,3,4) ;    %  Y only
      plot((1:length(vlam_Y))',vlam_Y,'ko-') ;
      xlabel('k') ;
      ylabel('lambda Y') ;
      title(['Y Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_Y = ' num2str(r_Y)]) ;
      hold off ;
  end     %  of iDiagPlot if-block


  %  Main loop stepping through components
  %
  for istep = 1:nstep

    if iscreenwrite == 1
      disp(' ') ;
      disp(' ') ;
      disp(['working on step ' num2str(istep) ' of ' num2str(nstep)]) ;
    end 

    if istep > 1    %  recompute separate block ranks

      [mU_X,dmlam_X,mV_X] = svd(mE_X,'econ') ;
      [mU_Y,dmlam_Y,mV_Y] = svd(mE_Y,'econ') ;
      vlam_X = diag(dmlam_X) ;
      vlam_Y = diag(dmlam_Y) ;
          %  vectors of singular values
      vflag_X = (vlam_X > threshXnY) ;
      [~,r_X] = min(vflag_X) ;    %  index of first 0
      r_X = r_X - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of X signal at this step
      vflag_Y = (vlam_Y > threshXnY) ;
      [~,r_Y] = min(vflag_Y) ;    %  index of first 0
      r_Y = r_Y - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of Y signal at this step

    end     %  of istep > 1 if-block

    %  Compute stacked SVDs
    %
    [mU_U,dmlam_U,mV_U] = svd([mE_X mE_Y],'econ') ;
    [mU_V,dmlam_V,mV_V] = svd([mE_X; mE_Y],'econ') ;
        %  minimal rank versions of svd
    vlam_U = diag(dmlam_U) ;
    vlam_V = diag(dmlam_V) ;

    %  Find Stacked Initial Ranks
    %
    vflag_U = (vlam_U > threshU) ;
%vlam_U'
%threshU
    [~,r_U] = min(vflag_U) ;    %  index of first 0
    r_U = r_U - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of Uunion,col at this step
    vflag_V = (vlam_V > threshV) ;
    [~,r_V] = min(vflag_V) ;    %  index of first 0
    r_V = r_V - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of Vunion,col at this step
    if iscreenwrite == 1
      disp(' ') ;
      disp(['  Horizontally Stacked rank of Uunion,col is ' num2str(r_U)]) ;
      disp(['  Vertically Stacked rank of Vunion,row is ' num2str(r_V)]) ;
    end

    if istep == 1     %  Update SVD diagnostic plot

      if iDiagPlot == 1 

        lam_max = max([lam_max; vlam_U; vlam_V; threshU; threshV]) ;
        vax = [0 (n + 1) 0 (1.05 * lam_max)] ;

        subplot(2,3,2) ;    %  Horizontal Stack
          plot((1:length(vlam_U))',vlam_U,'ko-') ;
          xlabel('k') ;
          ylabel('lambda U') ;
          title('Horizontal Stack Singular Values') ;
          axis(vax) ;
          hold on ;
            plot([0; (n+1)],[threshU; threshU],'r-') ;
            text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
                 vax(3) + 0.9 * (vax(4) - vax(3)), ...
                 ['r_U = ' num2str(r_U)]) ;
          hold off ;

        subplot(2,3,5) ;    %  Vertical Stack
          plot((1:length(vlam_V))',vlam_V,'ko-') ;
          xlabel('k') ;
          ylabel('lambda V') ;
          title('Vertical Stack Singular Values') ;
          axis(vax) ;
          hold on ;
            plot([0; (n+1)],[threshV; threshV],'r-') ;
            text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
                 vax(3) + 0.9 * (vax(4) - vax(3)), ...
                 ['r_V = ' num2str(r_V)]) ;
          hold off ;

      end    %  of iDiagPlot if-block

    end    %  of istep 1 if-block


    if r_U > 0     %  Then have U Union directions to work with

      %  Project each of X and Y onto U_union space
      %
      S_UX = mU_U(:,1:r_U)' * mE_X ;
      S_UY = mU_U(:,1:r_U)' * mE_Y ;
          %  r_U x n Inner products (hence scores)
          %  of X & Y with basis matrix of Uunion,col space
      Xcup_UX = mU_U(:,1:r_U) * S_UX ;
      Ycup_UY = mU_U(:,1:r_U) * S_UY ;
          %  d x n representations of generated subspaces`

      [B_UX,dmlam_UX,~] = svd(Xcup_UX,'econ') ;
      vlam_UX = diag(dmlam_UX) ;
      vflag_BUX = (vlam_UX > threshXnY) ;
      [~,r_BUX] = min(vflag_BUX) ;    %  index of first 0
      r_BUX = r_BUX - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of projection of X 
          %      on Uunion,col at this step
      if r_BUX > 0
        B_UX = B_UX(:,1:r_BUX) ;
            %  Basis matrix of subspace generated by 
            %      projection of X on Uunion,col space
      else
        B_UX = [] ;
      end

      [B_UY,dmlam_UY,~] = svd(Ycup_UY,'econ') ;
      vlam_UY = diag(dmlam_UY) ;
      vflag_BUY = (vlam_UY > threshXnY) ;
      [~,r_BUY] = min(vflag_BUY) ;    %  index of first 0
      r_BUY = r_BUY - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of projection of X 
          %      on Uunion,col at this step
      if r_BUY > 0
        B_UY = B_UY(:,1:r_BUY) ;
            %  Basis matrix of subspace generated by 
            %      projection of Y on Uunion,col space
      else
        B_UY = [] ;
      end

      if  r_BUX > 0  &  r_BUY > 0     %  may have U joint directions
                                      %  Look further by SVD of sum
                                      %  of projection matrices

        P_UX = B_UX * B_UX' ; 
        P_UY = B_UY * B_UY' ; 
            %  Projection matrices onto the 
            %      X-Uunion,col and Y-Uunion,col subspaces
            %  Simpler form since B_UX and B_UY are orthonormal basis matrices
        [mU_UJ,dmlam_UJ,mV_UJ] = svd(P_UX + P_UY,'econ') ;
        vlam_UJ = diag(dmlam_UJ) ;

        %  Find basis matrix for Union U Joint subspace
        %
        vflag_UJ = (vlam_UJ > 1.5) ;

        [~,r_UJ] = min(vflag_UJ) ;    %  index of first 0
        r_UJ = r_UJ - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of Ujoint space of doubly joint candidates

        if r_UJ > 0     %  Have a Ujoint subspace (could be doubly or singly joint)

          B_UJoint = mU_UJ(:,1:r_UJ) ;
              %  Basis matrix of U subspace (Doubly or Singly)

          %  Project X and Y on U joint space
          %
          S_UJX = B_UJoint' * mE_X ;
          S_UJY = B_UJoint' * mE_Y ;
          Xcup_UJX = B_UJoint * S_UJX ;
          Ycup_UJY = B_UJoint * S_UJY ;
              %  d x n representations of generated subspaces`

          %  Find Corresponding V space for X
          %
          [~,dmUJXlam,V_UJX] = svd(Xcup_UJX,'econ') ;
          vUJXlam = diag(dmUJXlam) ;
          vflag_UJX = (vUJXlam > threshXnY) ;
              %  May be able to improve this threshold
          [~,r_UJX] = min(vflag_UJX) ;    %  index of first 0
          r_UJX = r_UJX - 1 ;    %  index of last 1 (0 if none)
          if r_UJX > 0
            V_UJX = V_UJX(:,1:r_UJX) ;
                %  Basis natrix of R^n (i.e. v) subspace generated by 
                %      projection of X on Joint U space
          else
            V_UJX = [] ;
          end

          %  Find Corresponding V space for Y
          %
          [~,dmUJYlam,V_UJY] = svd(Ycup_UJY,'econ') ;
          vUJYlam = diag(dmUJYlam) ;
          vflag_UJY = (vUJYlam > threshXnY) ;
              %  May be able to improve this threshold
          [~,r_UJY] = min(vflag_UJY) ;    %  index of first 0
          r_UJY = r_UJY - 1 ;    %  index of last 1 (0 if none)
          if r_UJY > 0
            V_UJY = V_UJY(:,1:r_UJY) ;
                %  Basis matrix of R^n (i.e. v) subspace generated by 
                %      projection of Y on Joint U space
          else
            V_UJY = [] ;
          end

          if  r_UJX > 0  &  r_UJY
            %  Find U driven candidate for Doubly Joint mode
            %      using Principal Angle Analysis
            [mc_UPAX,dmlam_UPA,mc_UPAY] = svd(V_UJX' * V_UJY,'econ') ;
            vlam_UPA = diag(dmlam_UPA) ;
            vc_UPAX = mc_UPAX(:,1) ;
            vc_UPAY = mc_UPAY(:,1) ;
            if iscreenwrite == 1
              disp(['    U driven Principal Angles = ' num2str(acosd(vlam_UPA'))]) ;
            end 
            angU = acosd(vlam_UPA(1)) ;
          else
            r_UJ = 0 ;
          end


        end     %  of have UJ subspace if-block
                %      (if r_UJ > 0)

      else

        r_UJ = 0 ;    %  No U Joint modes
        vlam_UJ = zeros(d,1) ;
            %  put all zeros, to show no Horizontal concatenated mode

      end     %  of have both projections on U space
              %      (if  r_BUX > 0  &  r_BUY > 0)

      if istep == 1     %  Add to SVD diagnostic plots

%{
        if iscreenwrite == 1
          disp(['  Rank of Projection of X on U space, r_UX = ' num2str(r_BUX)]) ;
          disp(['  Rank of Projection of Y on U space, r_UY = ' num2str(r_BUY)]) ;
          disp(['  U space Joint rank = ' num2str(r_UJ)]) ;
        end
%}

        if iDiagPlot == 1 
          %  Add to diagnostic graphic
          %
          vaxU = [0 (n + 1) 0 2.1] ;
          subplot(2,3,3) ;    %  U Concatenation
            plot((1:length(vlam_UJ))',vlam_UJ,'ko-') ;
            xlabel('k') ;
            ylabel('lambda UJ') ;
            title('U Joint Concatenated Singular Values') ;
            axis(vaxU) ;
            hold on ;
              plot([0; (n+1)],[1.5; 1.5],'r-') ;
              text(vaxU(1) + 0.6 * (vaxU(2) - vax(1)), ...
                   vaxU(3) + 0.9 * (vaxU(4) - vax(3)), ...
                   ['r_{UJ} = ' num2str(r_UJ)]) ;
            hold off ;
        end     %  of iDiagPlot if-block

      end    %  of istep 1 if-block


    else

        r_UJ = 0 ;    %  No U Joint modes

    end     %  if-block for having U Union directions to work with
            %       (if r_U > 0)


    if r_V > 0     %  Then have V Union directions to work with

      %  Project each of X and Y onto V_union space
      %
      L_VX = mE_X * mV_V(:,1:r_V) ;
      L_VY = mE_Y * mV_V(:,1:r_V) ;
          %  r_V x n Inner products (hence loadings)
          %  of X & Y with basis matrix of V space
      Xcup_VX = L_VX * mV_V(:,1:r_V)' ;
      Ycup_VY = L_VY * mV_V(:,1:r_V)' ;
          %  d x n representations of generated subspaces`

      [~,dmlam_VX,B_VX] = svd(Xcup_VX,'econ') ;
      vlam_VX = diag(dmlam_VX) ;
      vflag_BVX = (vlam_VX > threshXnY) ;
      [~,r_BVX] = min(vflag_BVX) ;    %  index of first 0
      r_BVX = r_BVX - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of projection of X 
          %      on Vunion,row at this step
      if r_BVX > 0
        B_VX = B_VX(:,1:r_BVX) ;
            %  Basis matrix of subspace generated by 
            %      projection of X on Vunion,row space
      else
        B_VX = [] ;
      end



      [~,dmlam_VY,B_VY] = svd(Ycup_VY,'econ') ;
      vlam_VY = diag(dmlam_VY) ;
      vflag_BVY = (vlam_VY > threshXnY) ;
      [~,r_BVY] = min(vflag_BVY) ;    %  index of first 0
      r_BVY = r_BVY - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of projection of Y 
          %      on Vunion,row at this step
      if r_BVY > 0
        B_VY = B_VY(:,1:r_BVY) ;
            %  Basis matrix of subspace generated by 
            %      projection of Y on Vunion,row space
      else
        B_VY = [] ;
      end

      if  r_BVX > 0  &  r_BVY > 0     %  may have V joint directions
                                      %  Look further by SVD of sum
                                      %  of projection matrices
   
        P_VX = B_VX * B_VX' ; 
        P_VY = B_VY * B_VY' ; 
            %  Projection matrices onto the 
            %      X-Vunion,row and Y-Vunion,row subspaces
            %  Simpler form since B_UX and B_UY are orthonormal basis matrices
        [mU_VJ,dmlam_VJ,mV_VJ] = svd(P_VX + P_VY,'econ') ;
        vlam_VJ = diag(dmlam_VJ) ;

        %  Find basis matrix for Union U Joint subspace
        %
        vflag_VJ = (vlam_VJ > 1.5) ;
        [~,r_VJ] = min(vflag_VJ) ;    %  index of first 0
        r_VJ = r_VJ - 1 ;    %  index of last 1 (0 if none)

        if r_VJ > 0     %  Have a VJ subspace

%r_VJ

          B_VJoint = mV_VJ(:,1:r_VJ) ;
              %  Basis matrix of subspace (Doubly or Singly)

          %  Project X and Y on V joint space
          %
          L_VJX = mE_X * B_VJoint ;
          L_VJY = mE_Y * B_VJoint ;
          Xcup_VJX = L_VJX * B_VJoint' ;
          Ycup_VJY = L_VJY * B_VJoint' ;
              %  d x n representations of generated subspaces`

          %  Find Corresponding U space for X
          %
          [U_VJX,dmVJXlam,~] = svd(Xcup_VJX,'econ') ;
          vVJXlam = diag(dmVJXlam) ;
          vflag_VJX = (vVJXlam > threshXnY) ;
              %  May be able to improve this threshold
          [~,r_VJX] = min(vflag_VJX) ;    %  index of first 0
          r_VJX = r_VJX - 1 ;    %  index of last 1 (0 if none)
          if r_VJX > 0
            U_VJX = U_VJX(:,1:r_VJX) ;
                %  Basis natrix of R^d (i.e. u) subspace generated by 
                %      projection of X on Joint V space
          else
            U_VJX = [] ;
          end

%r_VJX

          %  Find Corresponding U space for Y
          %
          [U_VJY,dmVJYlam,~] = svd(Ycup_VJY,'econ') ;
          vVJYlam = diag(dmVJYlam) ;
          vflag_VJY = (vVJYlam > threshXnY) ;
              %  May be able to improve this threshold
          [~,r_VJY] = min(vflag_VJY) ;    %  index of first 0
          r_VJY = r_VJY - 1 ;    %  index of last 1 (0 if none)
          if r_VJY > 0
            U_VJY = U_VJY(:,1:r_VJY) ;
                %  Basis matrix of R^d (i.e. u) subspace generated by 
                %      projection of Y on Joint V space
          else
            U_VJY = [] ;
          end

%r_VJY

          if  r_VJX > 0  &  r_VJY
            %  Find V driven candidate for Doubly Joint mode
            %      using Principal Angle Analysis
            [mc_VPAX,dmlam_VPA,mc_VPAY] = svd(U_VJX' * U_VJY,'econ') ;
            vlam_VPA = diag(dmlam_VPA) ;
            vc_VPAX = mc_VPAX(:,1) ;
            vc_VPAY = mc_VPAY(:,1) ;
            if iscreenwrite == 1
              disp(['    V driven Principal Angles = ' num2str(acosd(vlam_VPA'))]) ;
            end
            angV = acosd(vlam_VPA(1)) ;
          else
            r_VJ = 0 ;
          end

        end     %  of have UJ subspace if-block
                %      (if r_VJ > 0)


      else ;

        r_VJ = 0 ;    %  No V Joint modes
        vlam_VJ = zeros(d,1) ;
            %  put all zeros, to show no significant vertical concatenated mode

      end     %  of have both projections on U space
              %      (if  r_BVX > 0  &  r_BVY > 0)

      if istep == 1     %  Add to SVD diagnostic plots

%{
        if iscreenwrite == 1
          disp(['  Rank of Projection of X on V space, r_VX = ' num2str(r_BVX)]) ;
          disp(['  Rank of Projection of Y on V space, r_VY = ' num2str(r_BVY)]) ;
          disp(['  V space Joint rank = ' num2str(r_VJ)]) ;
        end
%}

        if iDiagPlot == 1 
          %  Add to diagnostic graphic
          %
          vaxV = [0 (n + 1) 0 2.1] ;
          subplot(2,3,6) ;    %  V  Concatenation
            plot((1:length(vlam_VJ))',vlam_VJ,'ko-') ;
            xlabel('k') ;
            ylabel('lambda VJ') ;
            title('V Joint Concatenated Singular Values') ;
            axis(vaxV) ;
            hold on ;
              plot([0; (n+1)],[1.5; 1.5],'r-') ;
              text(vaxV(1) + 0.6 * (vaxV(2) - vax(1)), ...
                   vaxV(3) + 0.9 * (vaxV(4) - vax(3)), ...
                   ['r_{VJ} = ' num2str(r_VJ)]) ;
            hold off ;
        end     %  of iDiagPlot if-block

      end    %  of istep 1 if-block


    else ;

      r_VJ = 0 ;    %  No V Joint modes

    end     %  if-block for having V Union directions to work with
            %       (if r_V > 0)

    flagbothjoint =  (r_UJ > 0)  &  (r_VJ > 0) ;
            %  Have both U and V Joint modes
            %  so there may be a doubly joint mode
    if  flagbothjoint
      if iscreenwrite == 1
        disp('  Have both U and V Joint modes') ;
      end

      minang = min(angU,angV) ;
      flagsmallang = (minang < 45) ;
      if flagsmallang     %  have a candidate for doubly joint mode

        if iscreenwrite == 1
          disp('    Have a small angle between U and V Joint modes') ;
        end

        if angU <= angV     %  Base doubly joint mode candidate on U-space

          vv_PAX = V_UJX * vc_UPAX ;
          vv_PAY = V_UJY * vc_UPAY ;
              %  Smallest angle linear combos
          vv_PAX = vv_PAX / norm(vv_PAX) ;
          vv_PAY = vv_PAY / norm(vv_PAY) ;
              %  make into direction (unit) vectors

          vu_PAX = mE_X * vv_PAX ;
          vu_PAY = mE_Y * vv_PAY ;
              %  Projections on X and Y
          vu_PAX = vu_PAX / norm(vu_PAX) ;
          vu_PAY = vu_PAY / norm(vu_PAY) ;
              %  make into direction (unit) vectors

        else     %  Base doubly joint mode candidate on V-space

          vu_PAX = U_VJX * vc_VPAX ;
          vu_PAY = U_VJY * vc_VPAY ;
              %  Smallest angle linear combos
          vu_PAX = vu_PAX / norm(vu_PAX) ;
          vu_PAY = vu_PAY / norm(vu_PAY) ;
              %  make into direction (unit) vectors

          vv_PAX = mE_X' * vu_PAX ;
          vv_PAY = mE_Y' * vu_PAY ;
              %  Projections on X and Y
          vv_PAX = vv_PAX / norm(vv_PAX) ;
          vv_PAY = vv_PAY / norm(vv_PAY) ;
              %  make into direction (unit) vectors

        end    %  of if-block for which base of doubly joint mode

        vu_DJ = vu_PAX + vu_PAY ;
        vv_DJ = vv_PAX + vv_PAY ;
            %  average directions
        vu_DJ = vu_DJ / norm(vu_DJ) ;
        vv_DJ = vv_DJ / norm(vv_DJ) ;
              %  make into direction (unit) vectors

        c_X = modeDfitSM(mE_X,vu_DJ,vv_DJ) ;
        c_Y = modeDfitSM(mE_Y,vu_DJ,vv_DJ) ;
            %  Coefficients of modes of variation

        flagDJsig = (abs(c_X) >= threshXnY) & (abs(c_Y) >= threshXnY) ;
            %  Have significant signal in both X and Y DJ components.
        if flagDJsig 
          imodetype = 1 ;    %  Make Doubly Joint Output plot
          if iscreenwrite == 1
            disp('  Found Doubly Joint Mode') ;
          end
        else
          if iscreenwrite == 1
            disp('  No Doubly Joint mode, since signal insignificant') ;
          end
        end ;

      end     %  of flagsmallang if-block


      if  (flagsmallang  &  ~flagDJsig)  |  ~flagsmallang
                 %  Either no small angle, or an insignificant signal
                 %  Compare spaces to choose a singly joint mode

        if iscreenwrite == 1
          disp('  Finding best Singly Joint mode') ;
        end

        if vlam_UJ(1) >= vlam_VJ(1)    %  Then use U driven Singly joint mode

          vu_SUJ = mU_UJ(:,1) ;
          imodetype = 2 ;    %  Make U Singly Joint Output plot

        else    %  Then use V driven Singly joint mode

          vv_SVJ = mV_VJ(:,1) ;
          imodetype = 3 ;    %  Make V Singly Joint Output plot

        end     %  of if-block choosing which singly joint mode to pursue

      end      %  of  either no small angle, or an insignificant signal  if-block


    else     %  Don't have both U and V spaces  (flagbothjoint = 0)

      if iscreenwrite == 1
        disp('  Did not have both U and V singly joint modes') ;
      end

      if  r_UJ > 0     %  Have only U Joint Space

        vu_SUJ = mU_UJ(:,1) ;
        imodetype = 2 ;    %  Make U Singly Joint Output plot

      elseif  r_VJ > 0     %  Have only V Joint Space

        vv_SVJ = mV_VJ(:,1) ;
        imodetype = 3 ;    %  Make V Singly Joint Output plot

      else     %  Have no joint space, try for individual modes

        if iscreenwrite == 1
          disp('  Did not find any Singly Joint mode of variation') ;
        end

        if max(r_X,r_Y) > 0     %  have an individual mode


          if vlam_X(1) >= vlam_Y(1)    %  Then use X individal mode

            mImode_X = vlam_X(1) * mU_X(:,1) * mV_X(:,1)' ;
                %  Individual X mode of variation
            imodetype = 4 ;    %  Make X Individual Output plot

          else    %  Then use y individal mode

            mImode_Y = vlam_Y(1) * mU_Y(:,1) * mV_Y(:,1)' ;
                %  Individual Y mode of variation
            imodetype = 5 ;    %  Make Y Individual Output plot

          end


        else     %  Have no individual mode

          if iscreenwrite == 1
            disp('  Did not find any Individual mode of variation') ;
          end
          imodetype = 0 ;

        end 


      end     %  of have only one or no Joint spaces if block


    end      %  of flagbothjoint if-block, for both U and V Joint modes
             %       (if  r_UJ > 0  &  r_VJ > 0)


    %  Construct this mode, save in outstruct, and update data matrices
    %
    if imodetype == 1     %  Found Doubly Joint Mode

      if iscreenwrite == 1
        disp('Found Doubly Joint Mode of Variation') ;
      end

      mDJmode_X = c_X * vu_DJ * vv_DJ' ;
      mDJmode_Y = c_Y * vu_DJ * vv_DJ' ;
          %  Doubly Joint modes of variation

      %  Update running quantities
      %
      mE_X = mE_X - mDJmode_X ;
      mE_Y = mE_Y - mDJmode_Y ;
      mA_X = mA_X + mDJmode_X ;
      mA_Y = mA_Y + mDJmode_Y ;
          %  Running matrices
      nmodes = nmodes + 1 ;
          %  number of modes of variation found so far
      caXmodes(nmodes,1) = {'D'} ;
      caXmodes(nmodes,2) = {c_X} ;
      caXmodes(nmodes,3) = {vu_DJ} ;
      caXmodes(nmodes,4) = {vv_DJ} ;
      caYmodes(nmodes,1) = {'D'} ;
      caYmodes(nmodes,2) = {c_Y} ;
      caYmodes(nmodes,3) = {vu_DJ} ;
      caYmodes(nmodes,4) = {vv_DJ} ;
          %  cell arrays of significant modes of variation


      if iHeatMap == 1     %  Plot Doubly Joint Mode of variation
        
        iDJmodefig = iDJmodefig + 1 ;
        fh2 = figure('WindowStyle','normal') ;
        clf ;
        set(fh2,'Position',[100 100 1000 550]) ;

        subplot(1,2,1) ;
          titlestr = ['Block X, Doubly Joint Mode of Variation ' ...
                          num2str(iDJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mDJmode_X,paramstruct) ;

        subplot(1,2,2) ;
          titlestr = ['Block Y, Doubly Joint Mode of Variation ' ...
                          num2str(iDJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mDJmode_Y,paramstruct) ;

        if ~isempty(OutPlotStr)
          savestr = [OutPlotStr 'DJmode' num2str(iDJmodefig)] ;
          printSM(savestr,savetype) ;
        end 

      end     %  of iHeatMap == 1  if-block


    elseif imodetype == 2     %  Found U Singly Joint Mode

      if iscreenwrite == 1
        disp('Found U Singly Mode of Variation') ;
      end ;

      [c_X,vv_SUJX] = modeSUfitSM(mE_X,vu_SUJ) ;
      [c_Y,vv_SUJY] = modeSUfitSM(mE_Y,vu_SUJ) ;
          %  Coefficients of modes of variation

      mSUJmode_X = c_X * vu_SUJ * vv_SUJX' ;
      mSUJmode_Y = c_Y * vu_SUJ * vv_SUJY' ;
          %  U Singly Joint modes of variation

      %  Update running quantities
      %
      mE_X = mE_X - mSUJmode_X ;
      mE_Y = mE_Y - mSUJmode_Y ;
      mA_X = mA_X + mSUJmode_X ;
      mA_Y = mA_Y + mSUJmode_Y ;
          %  Running matrices
      nmodes = nmodes + 1 ;
          %  number of modes of variation found so far
      caXmodes(nmodes,1) = {'SU'} ;
      caXmodes(nmodes,2) = {c_X} ;
      caXmodes(nmodes,3) = {vu_SUJ} ;
      caXmodes(nmodes,4) = {vv_SUJX} ;
      caYmodes(nmodes,1) = {'SU'} ;
      caYmodes(nmodes,2) = {c_Y} ;
      caYmodes(nmodes,3) = {vu_SUJ} ;
      caYmodes(nmodes,4) = {vv_SUJY} ;
          %  cell arrays of significant modes of variation

      if iHeatMap == 1     %  Plot U Singly Joint Mode of  variation

        iSUJmodefig = iSUJmodefig + 1 ;
        fh3 = figure('WindowStyle','normal') ;
        clf ;
        set(fh3,'Position',[100 100 1000 550]) ;

        subplot(1,2,1) ;
          titlestr = ['Block X, U Singly Joint Mode of Variation ' ...
                           num2str(iSUJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mSUJmode_X,paramstruct) ;

        subplot(1,2,2) ;
          titlestr = ['Block Y, U Singly Joint Mode of Variation ' ...
                           num2str(iSUJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mSUJmode_Y,paramstruct) ;

        if ~isempty(OutPlotStr)
          savestr = [OutPlotStr 'SUJmode' num2str(iSUJmodefig)] ;
          printSM(savestr,savetype) ;
        end

      end     %  of iHeatMap == 1  if-block


    elseif imodetype == 3     %  Found V Singly Joint Mode

      if iscreenwrite == 1
        disp('Found V Singly Mode of Variation') ;
      end

      [c_X,vu_SVJX] = modeSVfitSM(mE_X,vv_SVJ) ;
      [c_Y,vu_SVJY] = modeSVfitSM(mE_Y,vv_SVJ) ;
          %  Coefficients of modes of variation

      mSVJmode_X = c_X * vu_SVJX * vv_SVJ' ;
      mSVJmode_Y = c_Y * vu_SVJY * vv_SVJ' ;
          %  V Singly Joint modes of variation

      %  Update running quantities
      %
      mE_X = mE_X - mSVJmode_X ;
      mE_Y = mE_Y - mSVJmode_Y ;
      mA_X = mA_X + mSVJmode_X ;
      mA_Y = mA_Y + mSVJmode_Y ;
          %  Running matrices
      nmodes = nmodes + 1 ;
          %  number of modes of variation found so far
      caXmodes(nmodes,1) = {'SV'} ;
      caXmodes(nmodes,2) = {c_X} ;
      caXmodes(nmodes,3) = {vu_SVJX} ;
      caXmodes(nmodes,4) = {vv_SVJ} ;
      caYmodes(nmodes,1) = {'SV'} ;
      caYmodes(nmodes,2) = {c_Y} ;
      caYmodes(nmodes,3) = {vu_SVJY} ;
      caYmodes(nmodes,4) = {vv_SVJ} ;
          %  cell arrays of significant modes of variation


      if iHeatMap == 1     %  Plot V Singly Joint Mode of variation

        iSVJmodefig = iSVJmodefig + 1 ;
        fh4 = figure('WindowStyle','normal') ;
        clf ;
        set(fh4,'Position',[100 100 1000 550]) ;

        subplot(1,2,1) ;
          titlestr = ['Block X, V Singly Joint Mode of Variation ' ...
                           num2str(iSVJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mSVJmode_X,paramstruct) ;

        subplot(1,2,2) ;
          titlestr = ['Block Y, V Singly Joint Mode of Variation ' ...
                           num2str(iSVJmodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mSVJmode_Y,paramstruct) ;

        if ~isempty(OutPlotStr) 
          savestr = [OutPlotStr 'SVJmode' num2str(iSVJmodefig)] ;
          printSM(savestr,savetype) ;
        end

      end     %  of iHeatMap == 1  if-block


    elseif imodetype == 4     %  Found X Individual Mode

      if iscreenwrite == 1
        disp('Found X Individual Mode of Variation') ;
      end

      %  Update running quantities
      %
      mE_X = mE_X - mImode_X ;
      mA_X = mA_X + mImode_X ;
          %  Running matrices
      nmodes = nmodes + 1 ;
          %  number of modes of variation found so far
      caXmodes(nmodes,1) = {'I'} ;
      caXmodes(nmodes,2) = {vlam_X(1)} ;
      caXmodes(nmodes,3) = {mU_X(:,1)} ;
      caXmodes(nmodes,4) = {mV_X(:,1)} ;
      caYmodes(nmodes,1) = {'N'} ;
      caYmodes(nmodes,2) = {{}} ;
      caYmodes(nmodes,3) = {{}} ;
      caYmodes(nmodes,4) = {{}} ;
          %  cell arrays of significant modes of variation


      if iHeatMap == 1     %  Plot X Individual Mode of variation

        iImodefig = iImodefig + 1 ;
        fh5 = figure('WindowStyle','normal') ;
        clf ;
        set(fh5,'Position',[100 100 1000 550]) ;

        subplot(1,2,1) ;
          titlestr = ['Block X, Individual Mode of Variation ' ...
                           num2str(iImodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mImode_X,paramstruct) ;

        subplot(1,2,2) ;
          title(['Block Y, Individual Mode of Variation ' ...
                           num2str(iImodefig)]) ;

        if ~isempty(OutPlotStr)
          savestr = [OutPlotStr 'Imode' num2str(iImodefig)] ;
          printSM(savestr,savetype) ;
        end

      end     %  of iHeatMap == 1  if-block


    elseif imodetype == 5     %  Found Y Individual Mode

      if iscreenwrite == 1
        disp('Found Y Individual Mode of Variation') ;
      end

      %  Update running quantities
      %
      mE_Y = mE_Y - mImode_Y ;
      mA_Y = mA_Y + mImode_Y ;
          %  Running matrices
      nmodes = nmodes + 1 ;
          %  number of modes of variation found so far
      caXmodes(nmodes,1) = {'N'} ;
      caXmodes(nmodes,2) = {{}} ;
      caXmodes(nmodes,3) = {{}} ;
      caXmodes(nmodes,4) = {{}} ;
      caYmodes(nmodes,1) = {'I'} ;
      caYmodes(nmodes,2) = {vlam_Y(1)} ;
      caYmodes(nmodes,3) = {mU_Y(:,1)} ;
      caYmodes(nmodes,4) = {mV_Y(:,1)} ;
          %  cell arrays of significant modes of variation


      if iHeatMap == 1     %  Plot Y Individual Mode of variation

        iImodefig = iImodefig + 1 ;
        fh6 = figure('WindowStyle','normal') ;
        clf ;
        set(fh6,'Position',[100 100 1000 550]) ;

        subplot(1,2,1) ;
          title(['Block X, Individual Mode of Variation ' ...
                           num2str(iImodefig)]) ;

        subplot(1,2,2) ;
          titlestr = ['Block Y, Individual Mode of Variation ' ...
                           num2str(iImodefig)] ;
          paramstruct = struct('icolor',2, ...
                               'alpha',alpha, ...
                               'icolordist',0, ...
                               'titlestr',titlestr) ;
          HeatMapSM(mImode_Y,paramstruct) ;

        if ~isempty(OutPlotStr)
          savestr = [OutPlotStr 'Imode' num2str(iImodefig)] ;
          printSM(savestr,savetype) ;
        end

      end     %  of iHeatMap == 1  if-block


    end     %  of imodetype if-block


  end     %  of main loop, stepping through components


  outstruct.caXmodes = caXmodes ;
  outstruct.caYmodes = caYmodes ;

  if iDiagPlot == 1
    if ~isempty(OutPlotStr)
      %  Print diagnostic plots
      %
      figure(fh1) ;
      disp('Somehow need this pause to print proper diagnostic plot') ;
      pauseSM
      savestr = [OutPlotStr 'SVdiagnostic'] ;
      printSM(savestr,savetype) ;
    end
  end      %  of iDiagPlot if-block

  if iscreenwrite == 1
    disp(' ') ;
    disp(' ') ;
  end 


elseif imptype == 2     %  subspace partition based implementation, with QZ
                        %          from DoublyJointToy9.m  (current default)

  %  Compute X and Y SVDs
  %
  [mU_X,dmlam_X,mV_X] = svd(mXs,'econ') ;
  [mU_Y,dmlam_Y,mV_Y] = svd(mYs,'econ') ;
      %  minimal rank versions of svd
      %  Organized as o. n. Basis matrices 
      %  diagonal matrix of singular values
  vlam_X = diag(dmlam_X) ;
  vlam_Y = diag(dmlam_Y) ;
      %  vectors of singular values

  %  Find Separate Blocks Initial Ranks
  %
  vflag_X = (vlam_X > threshXnY) ;
  [~,r_X] = min(vflag_X) ;    %  index of first 0
  r_X = r_X - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of X signal A
  vflag_Y = (vlam_Y > threshXnY) ;
  [~,r_Y] = min(vflag_Y) ;    %  index of first 0
  r_Y = r_Y - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Y signal A
  if iscreenwrite == 1
    disp(' ') ;
    disp(['Initial estimated rank of X signal (= A_X) is ' num2str(r_X)]) ;
    disp(['Initial estimated rank of Y signal (= A_Y) is ' num2str(r_Y)]) ;
  end

  if iDiagPlot == 1 
    %  Start rank diagnostic plot
    %
    fh1 = figure('WindowStyle','normal') ;
    clf ;
    set(fh1,'Position',[100 100 1000 600]) ;
    lam_max = max([vlam_X; vlam_Y; threshV]) ;
    vax = [0 (n + 1) 0 (1.05 * lam_max)] ;
        %  biggest of singular values

    subplot(2,3,1) ;    %  X only
      plot((1:length(vlam_X))',vlam_X,'ko-') ;
      xlabel('k') ;
      ylabel('lambda X') ;
      title(['X Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_X = ' num2str(r_X)]) ;
      hold off ;

    subplot(2,3,4) ;    %  Y only
      plot((1:length(vlam_Y))',vlam_Y,'ko-') ;
      xlabel('k') ;
      ylabel('lambda Y') ;
      title(['Y Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_Y = ' num2str(r_Y)]) ;
      hold off ;
  end     %  of iDiagPlot if-block


  %  Compute stacked SVDs
  %
  [mU_U,dmlam_U,mV_U] = svd([mXs mYs],'econ') ;
  [mU_V,dmlam_V,mV_V] = svd([mXs; mYs],'econ') ;
      %  minimal rank versions of svd
  vlam_U = diag(dmlam_U) ;
  vlam_V = diag(dmlam_V) ;

  %  Find Stacked Initial Ranks
  %
  vflag_U = (vlam_U > threshU) ;
  [~,r_U] = min(vflag_U) ;    %  index of first 0
  r_U = r_U - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Uunion,col at this step
  vflag_V = (vlam_V > threshV) ;
  [~,r_V] = min(vflag_V) ;    %  index of first 0
  r_V = r_V - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Vunion,col at this step
  if iscreenwrite == 1
    disp(' ') ;
    disp(['  Horizontally Stacked rank of Uunion,col is ' num2str(r_U)]) ;
    disp(['  Vertically Stacked rank of Vunion,row is ' num2str(r_V)]) ;
  end


  if iDiagPlot == 1      %  then add to diagnostic plot

    lam_max = max([lam_max; vlam_U; vlam_V; threshU; threshV]) ;
    vax = [0 (n + 1) 0 (1.05 * lam_max)] ;

    subplot(2,3,2) ;    %  Horizontal Stack
      plot((1:length(vlam_U))',vlam_U,'ko-') ;
      xlabel('k') ;
      ylabel('lambda U') ;
      title('Horizontal Stack Singular Values') ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshU; threshU],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_U = ' num2str(r_U)]) ;
      hold off ;

    subplot(2,3,5) ;    %  Vertical Stack
      plot((1:length(vlam_V))',vlam_V,'ko-') ;
      xlabel('k') ;
      ylabel('lambda V') ;
      title('Vertical Stack Singular Values') ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshV; threshV],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_V = ' num2str(r_V)]) ;
      hold off ;

  end    %  of iDiagPlot if-block


  if r_U > 0     %  Then have U Union directions to work with

    %  Project each of X and Y onto U_union space
    %
    S_UX = mU_U(:,1:r_U)' * mXs ;
    S_UY = mU_U(:,1:r_U)' * mYs ;
        %  r_U x n Inner products (hence scores)
        %  of X & Y with basis matrix of Uunion,col space
    Xcup_UX = mU_U(:,1:r_U) * S_UX ;
    Ycup_UY = mU_U(:,1:r_U) * S_UY ;
        %  d x n representations of generated subspaces`

    [B_UX,dmlam_UX,~] = svd(Xcup_UX,'econ') ;
    vlam_UX = diag(dmlam_UX) ;
    vflag_BUX = (vlam_UX > threshXnY) ;
    [~,r_BUX] = min(vflag_BUX) ;    %  index of first 0
    r_BUX = r_BUX - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Uunion,col at this step
    if r_BUX > 0
      B_UX = B_UX(:,1:r_BUX) ;
          %  Basis matrix of subspace generated by 
          %      projection of X on Uunion,col space
    else
      B_UX = [] ;
    end

    [B_UY,dmlam_UY,~] = svd(Ycup_UY,'econ') ;
    vlam_UY = diag(dmlam_UY) ;
    vflag_BUY = (vlam_UY > threshXnY) ;
    [~,r_BUY] = min(vflag_BUY) ;    %  index of first 0
    r_BUY = r_BUY - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Uunion,col at this step
    if r_BUY > 0
      B_UY = B_UY(:,1:r_BUY) ;
          %  Basis matrix of subspace generated by 
          %      projection of Y on Uunion,col space
    else
      B_UY = [] ;
    end

    if  r_BUX > 0  &  r_BUY > 0     %  may have U joint directions
                                    %  Look further by SVD of sum
                                    %  of projection matrices

      P_UX = B_UX * B_UX' ; 
      P_UY = B_UY * B_UY' ; 
          %  Projection matrices onto the 
          %      X-Uunion,col and Y-Uunion,col subspaces
          %  Simpler form since B_UX and B_UY are orthonormal basis matrices
      [mU_UJ,dmlam_UJ,mV_UJ] = svd(P_UX + P_UY,'econ') ;
      vlam_UJ = diag(dmlam_UJ) ;

      %  Find basis matrix for U Joint subspace
      %
      vflag_UJ = (vlam_UJ > 1.5) ;

      [~,r_UJ] = min(vflag_UJ) ;    %  index of first 0
      r_UJ = r_UJ - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Ujoint space of doubly joint candidates

      if r_UJ > 0     %  Have a Ujoint subspace (could be doubly or singly joint)

        B_UJoint = mU_UJ(:,1:r_UJ) ;
            %  Basis matrix of U subspace (Doubly or Singly)
        P_UJoint = B_UJoint * B_UJoint' ;
            %  d x d Projection Matrix onto U Joint subspace

      end     %  of have UJ subspace if-block
              %      (if r_UJ > 0)

    else

      r_UJ = 0 ;    %  No U Joint modes
      vlam_UJ = zeros(d,1) ;
          %  put all zeros, to show no Horizontal concatenated mode

    end     %  of have both projections on U space
            %      (if  r_BUX > 0  &  r_BUY > 0)


    if iDiagPlot == 1 
      %  Add to diagnostic graphic
      %
      vaxU = [0 (n + 1) 0 2.1] ;
      subplot(2,3,3) ;    %  U Concatenation
        plot((1:length(vlam_UJ))',vlam_UJ,'ko-') ;
        xlabel('k') ;
        ylabel('lambda UJ') ;
        title('U Joint Concatenated Singular Values') ;
        axis(vaxU) ;
        hold on ;
          plot([0; (n+1)],[1.5; 1.5],'r-') ;
          text(vaxU(1) + 0.6 * (vaxU(2) - vax(1)), ...
               vaxU(3) + 0.9 * (vaxU(4) - vax(3)), ...
               ['r_{UJ} = ' num2str(r_UJ)]) ;
        hold off ;
    end     %  of iDiagPlot if-block


  else

      r_UJ = 0 ;    %  No U Joint modes

  end     %  if-block for having U Union directions to work with
          %       (if r_U > 0)

  disp(' ') ;
  disp(['r_UJ = ' num2str(r_UJ)]) ;


  if r_V > 0     %  Then have V Union directions to work with

    %  Project each of X and Y onto V_union space
    %
    L_VX = mXs * mV_V(:,1:r_V) ;
    L_VY = mYs * mV_V(:,1:r_V) ;
        %  r_V x n Inner products (hence loadings)
        %  of X & Y with basis matrix of V space
    Xcup_VX = L_VX * mV_V(:,1:r_V)' ;
    Ycup_VY = L_VY * mV_V(:,1:r_V)' ;
        %  d x n representations of generated subspaces`

    [~,dmlam_VX,B_VX] = svd(Xcup_VX,'econ') ;
    vlam_VX = diag(dmlam_VX) ;
    vflag_BVX = (vlam_VX > threshXnY) ;
    [~,r_BVX] = min(vflag_BVX) ;    %  index of first 0
    r_BVX = r_BVX - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Vunion,row at this step
    if r_BVX > 0
      B_VX = B_VX(:,1:r_BVX) ;
          %  Basis matrix of subspace generated by 
          %      projection of X on Vunion,row space
    else
      B_VX = [] ;
    end


    [~,dmlam_VY,B_VY] = svd(Ycup_VY,'econ') ;
    vlam_VY = diag(dmlam_VY) ;
    vflag_BVY = (vlam_VY > threshXnY) ;
    [~,r_BVY] = min(vflag_BVY) ;    %  index of first 0
    r_BVY = r_BVY - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of Y 
        %      on Vunion,row at this step
    if r_BVY > 0
      B_VY = B_VY(:,1:r_BVY) ;
          %  Basis matrix of subspace generated by 
          %      projection of Y on Vunion,row space
    else
      B_VY = [] ;
    end

    if  r_BVX > 0  &  r_BVY > 0     %  may have V joint directions
                                    %  Look further by SVD of sum
                                    %  of projection matrices
 
      P_VX = B_VX * B_VX' ; 
      P_VY = B_VY * B_VY' ; 
          %  Projection matrices onto the 
          %      X-Vunion,row and Y-Vunion,row subspaces
          %  Simpler form since B_UX and B_UY are orthonormal basis matrices
      [mU_VJ,dmlam_VJ,mV_VJ] = svd(P_VX + P_VY,'econ') ;
      vlam_VJ = diag(dmlam_VJ) ;

      %  Find basis matrix for V Joint subspace
      %
      vflag_VJ = (vlam_VJ > 1.5) ;
      [~,r_VJ] = min(vflag_VJ) ;    %  index of first 0
      r_VJ = r_VJ - 1 ;    %  index of last 1 (0 if none)

      if r_VJ > 0     %  Have a VJ subspace

        B_VJoint = mV_VJ(:,1:r_VJ) ;
            %  Basis matrix of subspace (Doubly or Singly)
        P_VJoint = B_VJoint * B_VJoint' ;
            %  n x n Projection Matrix onto U Joint subspace

      end     %  of have UJ subspace if-block
              %      (if r_VJ > 0)


      if iDiagPlot == 1 
        %  Add to diagnostic graphic
        %
        vaxV = [0 (n + 1) 0 2.1] ;
        subplot(2,3,6) ;    %  V  Concatenation
          plot((1:length(vlam_VJ))',vlam_VJ,'ko-') ;
          xlabel('k') ;
          ylabel('lambda VJ') ;
          title('V Joint Concatenated Singular Values') ;
          axis(vaxV) ;
          hold on ;
            plot([0; (n+1)],[1.5; 1.5],'r-') ;
            text(vaxV(1) + 0.6 * (vaxV(2) - vax(1)), ...
                 vaxV(3) + 0.9 * (vaxV(4) - vax(3)), ...
                 ['r_{VJ} = ' num2str(r_VJ)]) ;
          hold off ;
      end     %  of iDiagPlot if-block


    else ;

      r_VJ = 0 ;    %  No V Joint modes
      vlam_VJ = zeros(d,1) ;
          %  put all zeros, to show no significant vertical concatenated mode

    end     %  of have both projections on U space
            %      (if  r_BVX > 0  &  r_BVY > 0)


  else

      r_VJ = 0 ;    %  No V Joint modes

  end     %  if-block for having V Union directions to work with
          %       (if r_V > 0)

  disp(['r_VJ = ' num2str(r_VJ)]) ;


  nmodes2date = 0 ;
  if  r_UJ > 0  &  r_VJ > 0 

    %  Work with 4 potential partitioned spaces
    %

    %  First Explore potential Doubly Joint Modes
    %
    mX_JJ = P_UJoint * mXs * P_VJoint' ;
    mY_JJ = P_UJoint * mYs * P_VJoint' ;
    r_JJ = rank(mX_JJ) ;

    mX_IJ = (eye(d) - P_UJoint) * mXs * P_VJoint ;
    mY_IJ = (eye(d) - P_UJoint) * mYs * P_VJoint ;
    r_IJ = rank(mX_IJ) ;

    mX_JI = P_UJoint * mXs * (eye(n) - P_VJoint) ;
    mYs_JI = P_UJoint * mYs * (eye(n) - P_VJoint) ;
    r_JI = rank(mX_JI) ;

    mX_II = (eye(d) - P_UJoint) * mXs * (eye(n) - P_VJoint) ;
    mY_II = (eye(d) - P_UJoint) * mYs * (eye(n) - P_VJoint) ;
    r_II = rank(mX_II) ;

    disp(' ') ;
    disp('Check Quadratic Form Ranks') ;
    disp(['rank X_JJ = ' num2str(r_JJ)]) ;
    disp(['rank Y_JJ = ' num2str(rank(mY_JJ))]) ;
disp(['rank([X_JJ Y_JJ]) = ' num2str(rank([mY_JJ mY_JJ]))]) ;
disp(['rank([X_JJ; Y_JJ]) = ' num2str(rank([mY_JJ; mY_JJ]))]) ;
    if r_JJ == rank(mY_JJ)

      %  Calculate Doubly Joint modes
      %
      if r_JJ > 0     %  Then have actual doubly joint modes, so do QZ

        [UX_JJ,SX_JJ,VX_JJ] = svd(mX_JJ,'econ') ;
        [UY_JJ,SY_JJ,VY_JJ] = svd(mY_JJ,'econ') ;
        if SY_JJ(1) > SY_JJ(1) ;
          mU = UX_JJ(:,1:r_JJ) ;          
          mV = VX_JJ(:,1:r_JJ) ;
        else
          mU = UY_JJ(:,1:r_JJ) ;          
          mV = VY_JJ(:,1:r_JJ) ;
        end
        Ahat = mU' * mX_JJ * mV ;
        Bhat = mU' * mY_JJ * mV ;
        [mS,mT,mP,mQ] = qz(Ahat,Bhat,'real') ;

disp(' ') ;
disp('  QZ matrices are') ;
mS
mT


        nmodes2date = nmodes2date + r_JJ ;

      end ;

      %  Now V Singly Joint Modes
      %
      if  (nmodes2date < nmaxstep)  &  (r_IJ > 0)  ;

        disp('V Singly Joint Analysis not yet implemented') ;

      end


%  Working here


      %  Now U Singly Joint Modes
      %
      if  (nmodes2date < nmaxstep)  &  (r_JI > 0)  ;

        disp('U Singly Joint Analysis not yet implemented') ;

      end



      %  Now Individual Modes
      %
      if  (nmodes2date < nmaxstep)  &  (r_II > 0)  ;

        disp('Individual Analysis not yet implemented') ;

      end



    else
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Error from DIVASDoubJointSM.m              !!!') ;
      disp('!!!   Doubly Joint Quadratic Form ranks unequal  !!!') ;
      disp('!!!   Terminating Execution                      !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      outstruct = [] ;
      return ;
    end 




  elseif  r_UJ == 0  &  r_VJ > 0

    disp(' ') ;
    disp('Case of only V joint space not yet implemented') ;



  elseif  r_UJ > 0  &  r_VJ == 0

    disp(' ') ;
    disp('Case of only U joint space not yet implemented') ;



  elseif  r_UJ == 0  &  r_VJ == 0

    disp(' ') ;
    disp('Case of neither VJ nor UJ space not yet implemented') ;



  end      %  of both r_UJ > 0 & r_VJ > 0 if-block


elseif imptype == 3     %  Subspace partition based implementation and 
                        %      Tensor Decomposition from DoublyJointToy10.m

  nmodes = 0 ;
      %  number of modes of variation found so far
  caXmodes = {} ;
  caYmodes = {} ;
      %  cell arrays of significant modes of variation

  %  Compute X and Y SVDs
  %
  [mU_X,dmlam_X,mV_X] = svd(mXs,'econ') ;
  [mU_Y,dmlam_Y,mV_Y] = svd(mYs,'econ') ;
      %  minimal rank versions of svd
      %  Organized as o. n. Basis matrices 
      %  diagonal matrix of singular values
  vlam_X = diag(dmlam_X) ;
  vlam_Y = diag(dmlam_Y) ;
      %  vectors of singular values

  %  Find Separate Blocks Initial Ranks
  %
  vflag_X = (vlam_X > threshXnY) ;
  [~,r_X] = min(vflag_X) ;    %  index of first 0
  r_X = r_X - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of X signal A
  vflag_Y = (vlam_Y > threshXnY) ;
  [~,r_Y] = min(vflag_Y) ;    %  index of first 0
  r_Y = r_Y - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Y signal A
  if iscreenwrite == 1
    disp(' ') ;
    disp(['Initial estimated rank of X signal (= A_X) is ' num2str(r_X)]) ;
    disp(['Initial estimated rank of Y signal (= A_Y) is ' num2str(r_Y)]) ;
  end

  if iDiagPlot == 1 
    %  Start first rank diagnostic plot
    %
    fh1 = figure('WindowStyle','normal') ;
    clf ;
    set(fh1,'Position',[100 100 1000 600]) ;
    lam_max = max([vlam_X; vlam_Y; threshV]) ;
    vax = [0 (n + 1) 0 (1.05 * lam_max)] ;
        %  biggest of singular values

    subplot(2,3,1) ;    %  X only
      plot((1:length(vlam_X))',vlam_X,'ko-') ;
      xlabel('k') ;
      ylabel('lambda X') ;
      title(['X Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_X = ' num2str(r_X)]) ;
      hold off ;

    subplot(2,3,4) ;    %  Y only
      plot((1:length(vlam_Y))',vlam_Y,'ko-') ;
      xlabel('k') ;
      ylabel('lambda Y') ;
      title(['Y Singular Values']) ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_Y = ' num2str(r_Y)]) ;
      hold off ;
  end     %  of iDiagPlot if-block


  %  Compute stacked SVDs
  %
  [mU_U,dmlam_U,mV_U] = svd([mXs mYs],'econ') ;
  [mU_V,dmlam_V,mV_V] = svd([mXs; mYs],'econ') ;
      %  minimal rank versions of svd
  vlam_U = diag(dmlam_U) ;
  vlam_V = diag(dmlam_V) ;

  %  Find Stacked Initial Ranks
  %
  vflag_U = (vlam_U > threshU) ;
  [~,r_U] = min(vflag_U) ;    %  index of first 0
  r_U = r_U - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Uunion,col at this step
  vflag_V = (vlam_V > threshV) ;
  [~,r_V] = min(vflag_V) ;    %  index of first 0
  r_V = r_V - 1 ;    %  index of last 1 (0 if none)
      %  Estimated rank of Vunion,col at this step
  if iscreenwrite == 1
    disp(' ') ;
    disp(['  Horizontally Stacked rank of Uunion,col is ' num2str(r_U)]) ;
    disp(['  Vertically Stacked rank of Vunion,row is ' num2str(r_V)]) ;
  end


  if iDiagPlot == 1      %  then add to diagnostic plot

    lam_max = max([lam_max; vlam_U; vlam_V; threshU; threshV]) ;
    vax = [0 (n + 1) 0 (1.05 * lam_max)] ;

    subplot(2,3,2) ;    %  Horizontal Stack
      plot((1:length(vlam_U))',vlam_U,'ko-') ;
      xlabel('k') ;
      ylabel('lambda U') ;
      title('Horizontal Stack Singular Values') ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshU; threshU],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_U = ' num2str(r_U)]) ;
      hold off ;

    subplot(2,3,5) ;    %  Vertical Stack
      plot((1:length(vlam_V))',vlam_V,'ko-') ;
      xlabel('k') ;
      ylabel('lambda V') ;
      title('Vertical Stack Singular Values') ;
      axis(vax) ;
      hold on ;
        plot([0; (n+1)],[threshV; threshV],'r-') ;
        text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
             vax(3) + 0.9 * (vax(4) - vax(3)), ...
             ['r_V = ' num2str(r_V)]) ;
      hold off ;

    if ~isempty(OutPlotStr)
      %  Print first diagnostic plots
      %
      figure(fh1) ;
      savestr = [OutPlotStr 'SVdiagnostic1'] ;
      printSM(savestr,savetype) ;
    end

  end    %  of iDiagPlot if-block


  if  r_U > 0  &  r_V > 0     %  Then have both U Union and V Union
                              %  directions to work with

    if iscreenwrite == 1
      disp(' ') ;
      disp(['r_U = ' num2str(r_U)]) ;
      disp(['r_V = ' num2str(r_V)]) ;
      disp('Have both U union and V Union, so moving ahead') ;
    end ;

    %  Project each of X and Y onto U_union space
    %
    S_UX = mU_U(:,1:r_U)' * mXs ;
    S_UY = mU_U(:,1:r_U)' * mYs ;
        %  r_U x n Inner products (hence scores)
        %  of X & Y with basis matrix of Uunion,col space
    Xcup_UX = mU_U(:,1:r_U) * S_UX ;
    Ycup_UY = mU_U(:,1:r_U) * S_UY ;
        %  d x n representations of generated subspaces`

    %  Project each of X and Y onto V_union space
    %
    L_VX = mXs * mV_V(:,1:r_V) ;
    L_VY = mYs * mV_V(:,1:r_V) ;
        %  r_V x n Inner products (hence loadings)
        %  of X & Y with basis matrix of V space
    Xcup_VX = L_VX * mV_V(:,1:r_V)' ;
    Ycup_VY = L_VY * mV_V(:,1:r_V)' ;
        %  d x n representations of generated subspaces`

    %  SVD Xcup_UX and threshold to get basis matrix B_UX
    %
    [B_UX,dmlam_UX,~] = svd(Xcup_UX,'econ') ;
    vlam_UX = diag(dmlam_UX) ;
    vflag_BUX = (vlam_UX > threshXnY) ;
    [~,r_BUX] = min(vflag_BUX) ;    %  index of first 0
    r_BUX = r_BUX - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Uunion,col at this step
    if r_BUX > 0
      B_UX = B_UX(:,1:r_BUX) ;
          %  Basis matrix of subspace generated by 
          %      projection of X on Uunion,col space
    else
      B_UX = [] ;
    end

    %  SVD Ycup_UY and threshold to get basis matrix B_UY
    %
    [B_UY,dmlam_UY,~] = svd(Ycup_UY,'econ') ;
    vlam_UY = diag(dmlam_UY) ;
    vflag_BUY = (vlam_UY > threshXnY) ;
    [~,r_BUY] = min(vflag_BUY) ;    %  index of first 0
    r_BUY = r_BUY - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Uunion,col at this step
    if r_BUY > 0
      B_UY = B_UY(:,1:r_BUY) ;
          %  Basis matrix of subspace generated by 
          %      projection of Y on Uunion,col space
    else
      B_UY = [] ;
    end

    %  SVD Xcup_VX and threshold to get basis matrix B_VX
    %
    [~,dmlam_VX,B_VX] = svd(Xcup_VX,'econ') ;
    vlam_VX = diag(dmlam_VX) ;
    vflag_BVX = (vlam_VX > threshXnY) ;
    [~,r_BVX] = min(vflag_BVX) ;    %  index of first 0
    r_BVX = r_BVX - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of X 
        %      on Vunion,row at this step
    if r_BVX > 0
      B_VX = B_VX(:,1:r_BVX) ;
          %  Basis matrix of subspace generated by 
          %      projection of X on Vunion,row space
    else
      B_VX = [] ;
    end

    %  SVD Ycup_VY and threshold to get basis matrix B_VY
    %
    [~,dmlam_VY,B_VY] = svd(Ycup_VY,'econ') ;
    vlam_VY = diag(dmlam_VY) ;
    vflag_BVY = (vlam_VY > threshXnY) ;
    [~,r_BVY] = min(vflag_BVY) ;    %  index of first 0
    r_BVY = r_BVY - 1 ;    %  index of last 1 (0 if none)
        %  Estimated rank of projection of Y 
        %      on Vunion,row at this step
    if r_BVY > 0
      B_VY = B_VY(:,1:r_BVY) ;
          %  Basis matrix of subspace generated by 
          %      projection of Y on Vunion,row space
    else
      B_VY = [] ;
    end

    if iDiagPlot == 1 
      %  Start second rank diagnostic plot
      %
      fh2 = figure('WindowStyle','normal') ;
      clf ;
      set(fh2,'Position',[100 100 1000 600]) ;
      lam_max = max([vlam_UX; vlam_UY; vlam_VX; vlam_VY; threshXnY]) ;
      vax = [0 (n + 1) 0 (1.05 * lam_max)] ;
          %  biggest of singular values

      subplot(2,3,1) ;    %  Xcup_UX only
        plot((1:length(vlam_UX))',vlam_UX,'ko-') ;
        xlabel('k') ;
        ylabel('lambda XcupUX') ;
        title(['XcupUX Singular Values']) ;
        axis(vax) ;
        hold on ;
          plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
          text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
               vax(3) + 0.9 * (vax(4) - vax(3)), ...
               ['r_{BUX} = ' num2str(r_BUX)]) ;
        hold off ;

      subplot(2,3,2) ;    %  YcupUY only
        plot((1:length(vlam_UY))',vlam_UY,'ko-') ;
        xlabel('k') ;
        ylabel('lambda YcupUY') ;
        title(['YcupUY Singular Values']) ;
        axis(vax) ;
        hold on ;
          plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
          text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
               vax(3) + 0.9 * (vax(4) - vax(3)), ...
               ['r_{BUY} = ' num2str(r_BUY)]) ;
        hold off ;

      subplot(2,3,4) ;    %  Xcup_VX only
        plot((1:length(vlam_VX))',vlam_VX,'ko-') ;
        xlabel('k') ;
        ylabel('lambda XcupVX') ;
        title(['XcupVX Singular Values']) ;
        axis(vax) ;
        hold on ;
          plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
          text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
               vax(3) + 0.9 * (vax(4) - vax(3)), ...
               ['r_{BVX} = ' num2str(r_BVX)]) ;
        hold off ;

      subplot(2,3,5) ;    %  YcupVY only
        plot((1:length(vlam_VY))',vlam_VY,'ko-') ;
        xlabel('k') ;
        ylabel('lambda YcupVY') ;
        title(['YcupVY Singular Values']) ;
        axis(vax) ;
        hold on ;
          plot([0; (n+1)],[threshXnY; threshXnY],'r-') ;
          text(vax(1) + 0.6 * (vax(2) - vax(1)), ...
               vax(3) + 0.9 * (vax(4) - vax(3)), ...
               ['r_{BVY} = ' num2str(r_BVY)]) ;
        hold off ;
    end     %  of iDiagPlot if-block


    if  r_BUX > 0  &  r_BUY > 0  &    r_BUX > 0  &  r_BUY > 0
        %  then can proceed with trying to find doubly joint modes

      if iscreenwrite == 1
        disp(' ') ;
        disp(['r_{BUX} = ' num2str(r_BUX)]) ;
        disp(['r_{BUY} = ' num2str(r_BUY)]) ;
        disp(['r_{BVX} = ' num2str(r_BVX)]) ;
        disp(['r_{BVY} = ' num2str(r_BVY)]) ;
        disp('Have UX, UY, VX, VY subspaces, so moving ahead') ;
      end ;

      %  Compute projection matrices
      %
      P_UX = B_UX * B_UX' ; 
      P_UY = B_UY * B_UY' ; 
      P_VX = B_VX * B_VX' ; 
      P_VY = B_VY * B_VY' ; 

      %  SVD sum and threshold to get B_UJoint 
      %     (basis matrix for U joint space)
      %
      [mU_UJ,dmlam_UJ,mV_UJ] = svd(P_UX + P_UY,'econ') ;
      vlam_UJ = diag(dmlam_UJ) ;
      vflag_UJ = (vlam_UJ > 1.5) ;
      [~,r_UJ] = min(vflag_UJ) ;    %  index of first 0
      r_UJ = r_UJ - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of Ujoint space of doubly joint candidates

      %  SVD sum and threshold to get B_VJoint
      %     (basis matrix for V joint space)
      %
      [mV_VJ,dmlam_VJ,mV_VJ] = svd(P_VX + P_VY,'econ') ;
      vlam_VJ = diag(dmlam_VJ) ;
      vflag_VJ = (vlam_VJ > 1.5) ;
      [~,r_VJ] = min(vflag_VJ) ;    %  index of first 0
      r_VJ = r_VJ - 1 ;    %  index of last 1 (0 if none)
          %  Estimated rank of Ujoint space of doubly joint candidates

      if iDiagPlot == 1 
        %  Add to diagnostic graphic
        %
        vaxU = [0 (n + 1) 0 2.1] ;
        subplot(2,3,3) ;    %  U Concatenation
          plot((1:length(vlam_UJ))',vlam_UJ,'ko-') ;
          xlabel('k') ;
          ylabel('lambda UJ') ;
          title('U Joint Concatenated Singular Values') ;
          axis(vaxU) ;
          hold on ;
            plot([0; (n+1)],[1.5; 1.5],'r-') ;
            text(vaxU(1) + 0.6 * (vaxU(2) - vax(1)), ...
                 vaxU(3) + 0.9 * (vaxU(4) - vax(3)), ...
                 ['r_{UJ} = ' num2str(r_UJ)]) ;
          hold off ;

        vaxV = [0 (n + 1) 0 2.1] ;
        subplot(2,3,6) ;    %  V  Concatenation
          plot((1:length(vlam_VJ))',vlam_VJ,'ko-') ;
          xlabel('k') ;
          ylabel('lambda VJ') ;
          title('V Joint Concatenated Singular Values') ;
          axis(vaxV) ;
          hold on ;
            plot([0; (n+1)],[1.5; 1.5],'r-') ;
            text(vaxV(1) + 0.6 * (vaxV(2) - vax(1)), ...
                 vaxV(3) + 0.9 * (vaxV(4) - vax(3)), ...
                 ['r_{VJ} = ' num2str(r_VJ)]) ;
          hold off ;

        %  Print second diagnostic plots
        %
        figure(fh2) ;
        if ~isempty(OutPlotStr)
          savestr = [OutPlotStr 'SVdiagnostic2'] ;
          printSM(savestr,savetype) ;
        end
      end     %  of iDiagPlot if-block


      if  r_UJ > 0  &  r_VJ > 0
          %  then can proceed with trying to find doubly joint modes

        nmodes = 0 ;

        if iscreenwrite == 1
          disp(' ') ;
          disp(['r_{UJ} = ' num2str(r_UJ)]) ;
          disp(['r_{VJ} = ' num2str(r_VJ)]) ;
          disp('Have Joint U and V subspaces, so moving ahead') ;
        end ;

        %  Construct Joint Space Projection Matrices
        %
        B_UJoint = mU_UJ(:,1:r_UJ) ;
            %  Basis matrix of U subspace (Doubly or Singly)
        P_UJoint = B_UJoint * B_UJoint' ;
            %  d x d Projection Matrix onto U Joint subspace

        B_VJoint = mV_VJ(:,1:r_VJ) ;
            %  Basis matrix of subspace (Doubly or Singly)
        P_VJoint = B_VJoint * B_VJoint' ;
            %  n x n Projection Matrix onto U Joint subspace

        %  Partition into Share Types
        %
        mX_JJ = P_UJoint * mXs * P_VJoint' ;
        mY_JJ = P_UJoint * mYs * P_VJoint' ;
        r_XJJ = rank(mX_JJ) ;
        r_YJJ = rank(mY_JJ) ;

        mX_IJ = (eye(d) - P_UJoint) * mXs * P_VJoint ;
        mY_IJ = (eye(d) - P_UJoint) * mYs * P_VJoint ;
        r_XIJ = rank(mX_IJ) ;
        r_YIJ = rank(mY_IJ) ;

        mX_JI = P_UJoint * mXs * (eye(n) - P_VJoint) ;
        mY_JI = P_UJoint * mYs * (eye(n) - P_VJoint) ;
        r_XJI = rank(mX_JI) ;
        r_YJI = rank(mY_JI) ;

        mX_II = (eye(d) - P_UJoint) * mX * (eye(n) - P_VJoint) ;
        mY_II = (eye(d) - P_UJoint) * mYs * (eye(n) - P_VJoint) ;
        r_XII = rank(mX_II) ;
        r_YII = rank(mY_II) ;


        if  r_XJJ > 0  &  r_YJJ > 0
            %  then go ahead with Doubly Joint tensor analysis

          %  Do Tensor Analysis
          %
          %  First Reduce to Cores
          %
          [UJ,~,~] = svd(P_UJoint);
          rU = round(trace(P_UJoint));
          UJ = UJ(:,1:rU);

          [VJ,~,~] = svd(P_VJoint);
          rV = round(trace(P_VJoint));
          VJ = VJ(:,1:rV);

          C1 = UJ' * mX_JJ * VJ;
          C2 = UJ' * mY_JJ * VJ;
          [rU,rV] = size(C1);

          %  Build Tensor
          %
          Xraw = zeros(rU,rV,2);
          Xraw(:,:,1) = C1;
          Xraw(:,:,2) = C2;
          T = tensor(Xraw);
T

%  First attempt, had coefficients too large,
%      and non=orthogonal modes
%{
          %  Call  function
          %
%          L = 1:min([rU,rV,6]);
%Seemed to generate errors
          L = min([rU,rV,6]) ;
          nstarts = 5 ;
          result = fit_dj_cp(T, L, nstarts) ;

          %  Unpack results
          %
          M = result.model ;
          A = M.U{1};    % rU x L
          B = M.U{2};    % rV x L
          C = M.U{3};    % 2 x L
          lambda = M.lambda(:);    % L x 1
          Gamma = C * diag(lambda);    % 2 x L
          Umodes = UJ * A;    % d x L
          Vmodes = VJ * B;    % n x L
%}

          %  Orthogonal modes version
          %
          L = min([rU,rV,10]) ;
          nstarts = 25 ;
          opts.maxiters = 1000;
          opts.tol = 1e-10;
          opts.seed = 1;
          opts.verbose = false;

          result = fit_dj_orthosvd(C1, C2, L, nstarts, opts);
              %  Main function call

          %  Write diagnostics to screen
          %
          disp(' ')
          disp(['RawSS                 = ' num2str(result.RawSS,16)])
          disp(['sum ComponentSS       = ' num2str(sum(result.ComponentSS),16)])
          disp(['ResidSS direct        = ' num2str(result.ResidSS_direct,16)])
          disp(['RawSS - components    = ' num2str(result.ResidSS,16)])
          disp(['additive check        = ' num2str(result.additive_check,16)])
          disp(['relative residual     = ' num2str(result.RelErr,16)])

          disp(' ')
          disp('Gamma:')
          disp(result.Gamma)

          disp('eta:')
          disp(result.eta)

          disp('Component SS = eta.^2:')
          disp(result.ComponentSS)

          disp('Explained fractions:')
          disp(result.ExplainedFraction)


          %  Unpack results
          %
          A = result.A ;    % rU x L
          B = result.B ;    % rV x L
          Gamma = result.Gamma ;    % 2 x L
          mComponentSS = Gamma.^2 ;    % 2 x L matrix of per comp SS
          vModelSS = sum(mComponentSS,2) ;    %  2 x 1  vector of per block SS
          xSS = sum(sum(C1.^2)) ;    %  scalar of X DJ SS
          ySS = sum(sum(C2.^2)) ;    %  scalar of Y DJ SS
          vXpropModelSS = mComponentSS(1,:) / vModelSS(1) ;
              %  Vector of proportions of each comp in DJ X Model
          vYpropModelSS = mComponentSS(2,:) / vModelSS(2) ;
              %  Vector of proportions of each comp in DJ Y Model
          propXModel = vModelSS(1) / xSS ;
              %  proportion of Model SS in X DJ component
          propYModel = vModelSS(2) / ySS ;
              %  proportion of Model SS in Y DJ component

          %  Construct loadings and scores of full modes of variation
          %
          Umodes = UJ * A;    % d x L
          Vmodes = VJ * B;    % n x L

          if iscreenwrite == 1
            disp(' ') ;
            disp('Results of Tensor analysis:') ;
            disp(['X block gamma = ' num2str(Gamma(1,:))]) ;
            disp(['Y block gamma = ' num2str(Gamma(2,:))]) ;
          end ;

          %  Make Output graphics
          %  Loop through Doubly Joint nodes
          %
          iDJmodefig = 0 ;
          disp(' ') ;
          for imode = 1:L ;

            if  abs(Gamma(1,imode)) > threshXnY  |  ...
                            abs(Gamma(2,imode)) > threshXnY
                %  Either X or Y mode is significant,
                %      so make graphic

              if iscreenwrite == 1 ;
                disp(['Working on Doubly Joint mode ' num2str(imode)]) ;
              end ;

              nmodes = nmodes + 1 ;
                  %  number of modes of variation found so far
              c_X = Gamma(1,imode) ;
              c_Y = Gamma(2,imode) ;
              vu_DJ = Umodes(:,imode) ;
              vv_DJ = Vmodes(:,imode) ;
%disp('Check unit vectors') ;
%norm(vu_DJ)
%norm(vv_DJ)
              caXmodes(nmodes,1) = {'D'} ;
              caXmodes(nmodes,2) = {c_X} ;
              caXmodes(nmodes,3) = {vu_DJ} ;
              caXmodes(nmodes,4) = {vv_DJ} ;
              caYmodes(nmodes,1) = {'D'} ;
              caYmodes(nmodes,2) = {c_Y} ;
              caYmodes(nmodes,3) = {vu_DJ} ;
              caYmodes(nmodes,4) = {vv_DJ} ;
                  %  cell arrays of significant modes of variation

              if iHeatMap == 1     %  Plot Doubly Joint Mode of variation

                iDJmodefig = iDJmodefig + 1 ;

                fh3 = figure('WindowStyle','normal') ;
                clf ;
                set(fh3,'Position',[100 100 1000 550]) ;

                mDJmode_X = c_X * vu_DJ * vv_DJ' ;
                subplot(1,2,1) ;
                  titlestr = ['Block X, Doubly Joint Mode of Variation ' ...
                                  num2str(iDJmodefig)] ;
                  paramstruct = struct('icolor',2, ...
                                       'alpha',alpha, ...
                                       'icolordist',0, ...
                                       'titlestr',titlestr) ;
                  HeatMapSM(mDJmode_X,paramstruct) ;
                  hold on ;
                    vax = axis ;
                    text(vax(1) + 0.01 * (vax(2) - vax(1)), ...
                         vax(3) + 0.5 * (vax(4) - vax(3)), ...
                         ['Prop of Model SS = ' ...
                          num2str(vXpropModelSS(imode)) ...
                          ',  Model prop of DJ SS = ' num2str(propXModel)]) ;
                  hold off ;

                mDJmode_Y = c_Y * vu_DJ * vv_DJ' ;
                subplot(1,2,2) ;
                  titlestr = ['Block Y, Doubly Joint Mode of Variation ' ...
                                  num2str(iDJmodefig)] ;
                  paramstruct = struct('icolor',2, ...
                                       'alpha',alpha, ...
                                       'icolordist',0, ...
                                       'titlestr',titlestr) ;
                  HeatMapSM(mDJmode_Y,paramstruct) ;
                  hold on ;
                    vax = axis ;
                    text(vax(1) + 0.01 * (vax(2) - vax(1)), ...
                         vax(3) + 0.5 * (vax(4) - vax(3)), ...
                         ['Prop of Model SS = ' ...
                          num2str(vYpropModelSS(imode)) ...
                          ',  Model prop of DJ SS = ' num2str(propYModel) ]) ;
                  hold off ;

                if ~isempty(OutPlotStr)
                  savestr = [OutPlotStr 'DJmode' num2str(iDJmodefig)] ;
                  printSM(savestr,savetype) ;
                end 

              end     %  of iHeatMap == 1  if-block

            else

              disp(' ') ;
              disp(['Neither Gamma large enough, so DJ mode ' ...
                         num2str(imode) ' thresholded out']) ;

            end     %  of imode significance if-block

          end    %  of imode for-loop

        else

          disp(' ') ;
          disp(['   r_{XJJ} = ' num2str(r_XJJ)]) ;
          disp(['   r_{YJJ} = ' num2str(r_YJJ)]) ;
          disp('   So found No Doubly Joint modes') ;

        end    %  of if  r_XJJ > 0  &  r_YJJ > 0


        if  r_XIJ > 0  &  r_YIJ > 0
            %  then go ahead with V Singly Joint analysis

          %  Loop through V Singly Joint modes
          %
          [mU_XVS,dmlam_XVS,mV_XVS] = svd(mX_IJ,'econ') ;
          vlam_XVS = diag(dmlam_XVS) ;
              %  vectors of singular values
          vflag_XVS = (vlam_XVS > threshXnY) ;
          [~,r_XVS] = min(vflag_XVS) ;    %  index of first 0
          r_XVS = r_XVS - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of X signal at this step

          [mU_YVS,dmlam_YVS,mV_YVS] = svd(mY_IJ,'econ') ;
          vlam_YVS = diag(dmlam_YVS) ;
              %  vectors of singular values
          vflag_YVS = (vlam_YVS > threshXnY) ;
          [~,r_YVS] = min(vflag_YVS) ;    %  index of first 0
          r_YVS = r_YVS - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of Y signal at this step
          r_VS = min(r_XVS, r_YVS) ;

          %  Do AJIVE type analysis
          %
          mVcat = [mV_XVS(:,1:r_XVS)'; mV_YVS(:,1:r_YVS)'] ;
          [mU_Vcat,dmLam_Vcat,mV_Vcat] = svd(mVcat) ;
          vLam_Vcat = diag(dmLam_Vcat) ;

          iVSmodefig = 0 ;
          for imode = 1:r_VS ;

            if iscreenwrite == 1 ;
              disp(['Working on V Singly Joint mode ' num2str(imode)]) ;
            end ;

            vVscores = mV_Vcat(:,imode) ;
                %  Joint scores
            vXloads = mXs * vVscores ;
            vYloads = mYs * vVscores ;
                %  Projections to get loadings
            c_X = norm(vXloads) ;
            c_Y = norm(vYloads) ;
            VXloadsu = vXloads / c_X ;
            VYloadsu = vYloads / c_Y ;
                %  Unit free version of loadings

            nmodes = nmodes + 1 ;

            caXmodes(nmodes,1) = {'SV'} ;
            caXmodes(nmodes,2) = {c_X} ;
            caXmodes(nmodes,3) = {VXloadsu} ;
            caXmodes(nmodes,4) = {vVscores} ;
            caYmodes(nmodes,1) = {'SV'} ;
            caYmodes(nmodes,2) = {c_Y} ;
            caYmodes(nmodes,3) = {VYloadsu} ;
            caYmodes(nmodes,4) = {vVscores} ;
                %  cell arrays of significant modes of variation

            if iHeatMap == 1     %  Plot V Singly Joint Mode of variation

              iVSmodefig = iVSmodefig + 1 ;

              fh4 = figure('WindowStyle','normal') ;
              clf ;
              set(fh4,'Position',[100 100 1000 550]) ;

              mVSmode_X = c_X * VXloadsu * vVscores' ;
              subplot(1,2,1) ;
                titlestr = ['Block X, V Singly Joint Mode of Variation ' ...
                                num2str(iVSmodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mVSmode_X,paramstruct) ;

              mVSmode_Y = c_Y * VYloadsu * vVscores' ;
              subplot(1,2,2) ;
                titlestr = ['Block Y, V Singly Joint Mode of Variation ' ...
                                num2str(iVSmodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mVSmode_Y,paramstruct) ;

              if ~isempty(OutPlotStr)
                savestr = [OutPlotStr 'VSmode' num2str(iVSmodefig)] ;
                printSM(savestr,savetype) ;
              end 

            end     %  of iHeatMap == 1  if-block

          end    %  of imode for-loop

        else

          disp(' ') ;
          disp(['   r_{XIJ} = ' num2str(r_XIJ)]) ;
          disp(['   r_{YIJ} = ' num2str(r_YIJ)]) ;
          disp('   So found No V Singly Joint modes') ;

        end    %  of if  r_XIJ > 0  &  r_YIJ > 0


        if  r_XJI > 0  &  r_YJI > 0
            %  then go ahead with U Singly Joint analysis

          %  Loop through U Singly Joint modes
          %
          [mU_XUS,dmlam_XUS,mV_XUS] = svd(mX_JI,'econ') ;
          vlam_XUS = diag(dmlam_XUS) ;
              %  vectors of singular values
          vflag_XUS = (vlam_XUS > threshXnY) ;
          [~,r_XUS] = min(vflag_XUS) ;    %  index of first 0
          r_XUS = r_XUS - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of X signal at this step

          [mU_YUS,dmlam_YUS,mV_YUS] = svd(mY_JI,'econ') ;
          vlam_YUS = diag(dmlam_YUS) ;
              %  vectors of singular values
          vflag_YUS = (vlam_YUS > threshXnY) ;
          [~,r_YUS] = min(vflag_YUS) ;    %  index of first 0
          r_YUS = r_YUS - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of Y signal at this step
          r_US = min(r_XUS, r_YUS) ;

          %  Do transpose AJIVE type analysis
          %
          mUcat = [mU_XUS(:,1:r_XUS) mU_YUS(:,1:r_YUS)] ;
          [mU_Hcat,dmLam_Hcat,mV_Hcat] = svd(mUcat) ;
          vLam_Hcat = diag(dmLam_Hcat) ;

          iUSmodefig = 0 ;
          for imode = 1:r_US ;

            if iscreenwrite == 1 ;
              disp(['Working on U Singly Joint mode ' num2str(imode)]) ;
            end ;

            vHloads = mU_Hcat(:,imode) ;
                %  Joint loadings
            vXscores = (vHloads' * mXs)' ;
            vYscores = (vHloads' * mYs)' ;
                %  Projections to get scores
            c_X = norm(vXscores) ;
            c_Y = norm(vYscores) ;
            VXscoresu = vXscores / c_X ;
            VYscoresu = vYscores / c_Y ;
                %  Unit free version of scores

            nmodes = nmodes + 1 ;

            caXmodes(nmodes,1) = {'SU'} ;
            caXmodes(nmodes,2) = {c_X} ;
            caXmodes(nmodes,3) = {vHloads} ;
            caXmodes(nmodes,4) = {VXscoresu} ;
            caYmodes(nmodes,1) = {'SU'} ;
            caYmodes(nmodes,2) = {c_Y} ;
            caYmodes(nmodes,3) = {vHloads} ;
            caYmodes(nmodes,4) = {VYscoresu} ;
                %  cell arrays of significant modes of variation

            if iHeatMap == 1     %  Plot U Singly Joint Mode of variation

              iUSmodefig = iUSmodefig + 1 ;

              fh5 = figure('WindowStyle','normal') ;
              clf ;
              set(fh5,'Position',[100 100 1000 550]) ;

              mUSmode_X = c_X * vHloads * VXscoresu' ;
              subplot(1,2,1) ;
                titlestr = ['Block X, U Singly Joint Mode of Variation ' ...
                                num2str(iUSmodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mUSmode_X,paramstruct) ;

              mUSmode_Y = c_Y * vHloads * VYscoresu' ;
              subplot(1,2,2) ;
                titlestr = ['Block Y, U Singly Joint Mode of Variation ' ...
                                num2str(iUSmodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mUSmode_Y,paramstruct) ;

              if ~isempty(OutPlotStr)
                savestr = [OutPlotStr 'USmode' num2str(iUSmodefig)] ;
                printSM(savestr,savetype) ;
              end 

            end     %  of iHeatMap == 1  if-block

          end    %  of imode for-loop

        else

          disp(' ') ;
          disp(['   r_{XJI} = ' num2str(r_XJI)]) ;
          disp(['   r_{YJI} = ' num2str(r_YJI)]) ;
          disp('   So found No U Singly Joint modes') ;

        end    %  of if  r_XJI > 0  &  r_YJI > 0


        if r_XII > 0
            %  then go ahead with X Individual analysis

          %  Loop through X Individual modes
          %
          [mU_XI,dmlam_XI,mV_XI] = svd(mX_II,'econ') ;
          vlam_XI = diag(dmlam_XI) ;
              %  vectors of singular values
          vflag_XI = (vlam_XI > threshXnY) ;
          [~,r_XI] = min(vflag_XI) ;    %  index of first 0
          r_XI = r_XI - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of X signal at this step

          iXImodefig = 0 ;
          for imode = 1:r_XI

            if iscreenwrite == 1 ;
              disp(['Working on X Indiv mode ' num2str(imode)]) ;
            end ;

            nmodes = nmodes + 1 ;

            caXmodes(nmodes,1) = {'I'} ;
            caXmodes(nmodes,2) = {vlam_XI(imode)} ;
            caXmodes(nmodes,3) = {mU_XI(:,imode)} ;
            caXmodes(nmodes,4) = {mV_XI(:,imode)} ;
            caYmodes(nmodes,1) = {'N'} ;
            caYmodes(nmodes,2) = {{}} ;
            caYmodes(nmodes,3) = {{}} ;
            caYmodes(nmodes,4) = {{}} ;
                %  cell arrays of significant modes of variation

            if iHeatMap == 1     %  Plot X Individual Mode of variation

              iXImodefig = iXImodefig + 1 ;

              fh6 = figure('WindowStyle','normal') ;
              clf ;
              set(fh6,'Position',[100 100 1000 550]) ;

              mXImode = vlam_XI(imode) * mU_XI(:,imode) * mV_XI(:,imode)' ;
              subplot(1,2,1) ;
                titlestr = ['Block X, Individual Mode of Variation ' ...
                                num2str(iXImodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mXImode,paramstruct) ;

              if ~isempty(OutPlotStr)
                savestr = [OutPlotStr 'XImode' num2str(iXImodefig)] ;
                printSM(savestr,savetype) ;
              end 

            end     %  of iHeatMap == 1  if-block

          end    %  of imode for-loop

        else

          disp(' ') ;
          disp(['   r_{XII} = ' num2str(r_XII)]) ;
          disp('   So found No X Individual modes') ;

        end    %  of if  r_XII > 0


        if r_YII > 0
            %  then go ahead with Y Individual analysis

          %  Loop through Y Individual modes
          %
          [mU_YI,dmlam_YI,mV_YI] = svd(mY_II,'econ') ;
          vlam_YI = diag(dmlam_YI) ;
              %  vectors of singular values
          vflag_YI = (vlam_YI > threshXnY) ;
          [~,r_YI] = min(vflag_YI) ;    %  index of first 0
          r_YI = r_YI - 1 ;    %  index of last 1 (0 if none)
              %  Estimated rank of Y signal at this step

          iYImodefig = 0 ;
          for imode = 1:r_YI

            if iscreenwrite == 1 ;
              disp(['Working on Y Indiv mode ' num2str(imode)]) ;
            end ;

            nmodes = nmodes + 1 ;

            caXmodes(nmodes,1) = {'N'} ;
            caXmodes(nmodes,2) = {{}} ;
            caXmodes(nmodes,3) = {{}} ;
            caXmodes(nmodes,4) = {{}} ;
            caYmodes(nmodes,1) = {'I'} ;
            caYmodes(nmodes,2) = {vlam_YI(imode)} ;
            caYmodes(nmodes,3) = {mU_YI(:,imode)} ;
            caYmodes(nmodes,4) = {mV_YI(:,imode)} ;
                %  cell arrays of significant modes of variation

            if iHeatMap == 1     %  Plot Y Individual Mode of variation

              iYImodefig = iYImodefig + 1 ;

              fh7 = figure('WindowStyle','normal') ;
              clf ;
              set(fh7,'Position',[100 100 1000 550]) ;

              mYImode = vlam_YI(imode) * mU_YI(:,imode) * mV_YI(:,imode)' ;
              subplot(1,2,2) ;
                titlestr = ['Block Y, Individual Mode of Variation ' ...
                                num2str(iYImodefig)] ;
                paramstruct = struct('icolor',2, ...
                                     'alpha',alpha, ...
                                     'icolordist',0, ...
                                     'titlestr',titlestr) ;
                HeatMapSM(mYImode,paramstruct) ;

              if ~isempty(OutPlotStr)
                savestr = [OutPlotStr 'YImode' num2str(iYImodefig)] ;
                printSM(savestr,savetype) ;
              end 

            end     %  of iHeatMap == 1  if-block

          end    %  of imode for-loop

        else

          disp(' ') ;
          disp(['   r_{YII} = ' num2str(r_YII)]) ;
          disp('   So found No Y Individual modes') ;

        end    %  of if  r_YII > 0

        outstruct.caXmodes = caXmodes ;
        outstruct.caYmodes = caYmodes ;


      else

        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        disp('!!!   Error from DIVASDoubJointSM.m:   !!!') ;
        disp('!!!   Found No Doubly Joint modes      !!!') ;
        disp('!!!   Terminating execution            !!!') ;
        disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
        outstruct = 'Not defined yet' ;
        return ;

      end    %  of r_UJ > 0  &  r_VJ > 0 if-block


    else

      %  Print second diagnostic plots
      %
      figure(fh2) ;
      if ~isempty(OutPlotStr)
        savestr = [OutPlotStr 'SVdiagnostic2'] ;
        printSM(savestr,savetype) ;
      end

      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      disp('!!!   Error from DIVASDoubJointSM.m:   !!!') ;
      disp('!!!   Found No Doubly Joint modes      !!!') ;
      disp('!!!   Terminating execution            !!!') ;
      disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
      outstruct = 'Not defined yet' ;
      return ;

    end    %  of four subspace check


  else

    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Error from DIVASDoubJointSM.m:   !!!') ;
    disp('!!!   Found No Doubly Joint modes      !!!') ;
    disp('!!!   Terminating execution            !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    outstruct = 'Not defined yet' ;
    return ;

  end    %  of r_U > 0  &  r_V > 0 if-block


else ;

  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from DIVASDoubJointSM   !!!') ;
  disp('!!!   Invalid value of imptype      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  outstruct = 'Not defined yet' ;

end     %  of imptype if-block


