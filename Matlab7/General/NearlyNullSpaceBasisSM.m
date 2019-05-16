function [mpcprobes,msmoothprobes,indexstruct] = NearlyNullSpaceBasisSM(G,vx,nullnum,npcout,nsmoothout) 
% NearlyNullSpaceBasisSM
%     This finds the Nearly Null Space Bases,
%     given an input G matrix
%         Smoothness is currently based only on 1st differences
%     Based on function:    threshold
%         by Travis Gaydos
%   Steve Marron's matlab function
% Inputs:
%      G          - d x d Covariance matrix 
%                      (Summarizes Genetic Variation in Evolutionary 
%                           Biology Applications)
%                       Use zeros(d) to generate only smooth basis
%
%      vx         - d vector of xgrid points, 
%                       where covariances are evaluated
%                       Set to empty to get [1 2 ... d]'
%
%      nullnum    - number of null space basis elements
%                       Set to 0 to get PCA basis for G
%                       Set to d to get full null space basis
%                    
%      npcout     - number of pc basis elements to output
%                       when not specified, it is 
%                           taken as the max:    d - nullnum
%                       Set to 0 to generate only smooth basis
%                    
%      nsmoothout - number of smooth basis elements to output
%                       when not specified, it is 
%                           taken as the max:    nullnum
%
% Outputs:
%
%      mpcprobes     - d x npcout matrix of pc basis elements
%                          ordered according to decreasing variation explained
%                            (i.e. largest to smallest eigenvalues)
%
%      msmoothprobes - d x nsmoothout matrix of smooth basis elements
%                          ordered by decreasing smoothness
%                            (i.e. smoothest to roughest)
%
%      indexstruct   - structure containing indices for probes:
%                          (only computed when this
%                           output is requested)
%
%          vpceigval     - d vector of PCA probe eigenvalues (variation)
%                              in decreasing eigenvalue order
%                                  (may want only 1st (d - nullnum))
%
%          vsmootheigval - nullnum vector of smooth space probe eigenvalues (variation)
%                              in smoothness order
%
%          vpcsmooth     - d vector of PCA probe smoothness indices
%                              in decreasing eigenvalue order
%                                  (may want only 1st (d - nullnum))
%
%          vsmoothsmooth - nullnum vector of smooth space probe smoothness indices
%                              in smoothness order
%
%          vallsmosmooth - d vector of full smooth space probe smoothness indices
%                              in smoothness order
%
%      Unpack these using commands:
%          vpceigval = getfield(indexstruct,'vpceigval') ;
%          vsmootheigval = getfield(indexstruct,'vsmootheigval') ;
%          vpcsmooth = getfield(indexstruct,'vpcsmooth') ;
%          vsmoothsmooth = getfield(indexstruct,'vsmoothsmooth') ;
%
%
% Assumes path can find personal function:
%    vec2matSM.m

%    Copyright (c) T. Gaydos, J. S. Marron, 2008-2012



%  Check Inputs
%
d = size(G,1) ;

if ~(d == size(G,2)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Error from NearlyNullSpaceBasisSM   !!!') ;
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
    disp('!!!   Warning from NearlyNullSpaceBasisSM   !!!') ;
    disp('!!!   vx must be a vector                   !!!') ;
    disp('!!!   Resetting to vx = [1 2 ... d]''        !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    ivx = (1:d)' ;
  end ;
end;    


if ~(d == length(ivx)) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from NearlyNullSpaceBasisSM   !!!') ;
  disp('!!!   vx has wrong length                   !!!') ;
  disp('!!!   Resetting to vx = [1 2 ... d]''        !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  ivx = (1:d)' ;
end ;


%  Set last 2 parameters according to number of input arguments
%
if nargin < 4 ;       %  less than 4 argument inputs, use default npcout
  inpcout = d - nullnum ;
else ;                 %  then use input value
  inpcout = npcout ;
end ;

if nargin < 5 ;       %  less than 5 argument inputs, use default nsmoothout
  insmoothout = nullnum ;
else ;                 %  then use input value
  insmoothout = nsmoothout ;
end ;

if (inpcout > d - nullnum) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from NearlyNullSpaceBasisSM   !!!') ;
  disp('!!!   npcout too large                      !!!') ;
  disp('!!!   Resetting to npcout = d - nullnum     !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  inpcout = d - nullnum ;
end ;

if (insmoothout > nullnum) ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  disp('!!!   Warning from NearlyNullSpaceBasisSM   !!!') ;
  disp('!!!   nsmoothout too large                  !!!') ;
  disp('!!!   Resetting to nsmoothot = nullnum      !!!') ;
  disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  insmoothout = nullnum ;
end ;

if nargout > 2 ;    %  Should calculate indices
  indexflag = logical(1) ;
else ;    %  No need for indices
  indexflag = logical(0) ;
end ;


%  Calculate Basis elements
%

%  If needed, Compute PCA & Output PC probes as needed
%
if  (inpcout > 0.5)  |  indexflag  ;

  [B,D] = eig(G) ;
        %  note eigenvalues are ordered smallest to largest
  veigval = diag(D) ;
  meigvec = B ;
  flagnev = (veigval < 0) ;
  nnev = sum(flagnev) ;
  if nnev > 0.5 ;
    vnevout = veigval(flagnev) ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!   Warning from NearlyNullSpaceBasisSM   !!!') ;
    disp('!!!   G has negative eigenvalues:           !!!') ;
    for i = 1:nnev ;
      disp(['!!!       ' num2str(vnevout(i))]) ;
    end
    disp('!!!   Resetting those to 0                  !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    veigval(flagnev) = zeros(nnev,1) ;
  end ;
  Gnnd = meigvec * diag(veigval) * meigvec' ;
      % non-negative definite version of G

  mpcprobes = meigvec(:,d:-1:(d-inpcout+1)) ;
  vpceigval = veigval(d:-1:1) ;
else ;
  meigvec = eye(d) ;
  mpcprobes = [] ;
  vpceigval = [] ;
end ;


%  Create Difference Matrix
%
mdiff = zeros(d-1,d) ;
for i=1:(d-1) ;
  mdiff(i,i)=-1;
  mdiff(i,i+1)=1;
end; 

%  Create general weight matrix (works even when vx not equally spaced)
%
w=ones(1,d-1);
for i=1:(d-1)
    w(i)=ivx(i+1)-ivx(i);
end;
minw=min(w);
W=zeros(d-1,d-1);
for i=1:d-1;
    W(i,i)=sqrt(minw/w(i));
end;

%  Calculate Smooth Basis in Model Space
%      (Not currently used)
%eigmodel=meigvec;
    %  Size was chosen correctly above
%E=(W*mdiff*eigmodel)'*(W*mdiff*eigmodel);
%[B,D] = eig(E) ;
%veigvalm = diag(D) ;
%meigvecm = B ;
%mprobes=eigmodel*meigvecm;

%  Calculate Smooth Basis in Null Space
%
eignull=meigvec(:,1:nullnum);
E=(W*mdiff*eignull)'*(W*mdiff*eignull);
[B,D] = eig(E) ;
vsmoothsmooth = diag(D) ;
meigvecn = B ;
msmoothprobes = eignull*meigvecn;
msmoothprobes = msmoothprobes(:,1:insmoothout) ;


%  Construct output structure of probe indices, if needed
%
if indexflag ;

  %  Add d vector of PCA probe eigenvalues (variation)
  %  Computed above
  %  In earlier test, have checked this is same as:
  %      max(abs(vpceigval - diag(meigvec1' * Gnnd * meigvec1)))
  %              (where meigvec1 was untruncated version of mpcprobes )
  indexstruct  = struct('vpceigval',vpceigval) ;

  %  Add nullnum vector of smooth space probe eigenvalues (variation)
  vsmootheigval = diag(msmoothprobes' * Gnnd * msmoothprobes) ;
  indexstruct  = setfield(indexstruct,'vsmootheigval',vsmootheigval) ;

  %  Add d vector of PCA probe smoothness indices
  SE =(W * mdiff * mpcprobes)' * (W * mdiff * mpcprobes);
  vpcsmooth = diag(SE);
  indexstruct  = setfield(indexstruct,'vpcsmooth',vpcsmooth) ;

  %  Add nullnum vector of smooth space probe smoothness indices
  %  Computed above
  %  In earlier test, have checked this is same as:
  %      SE =(W * mdiff * msptemp)' * (W * mdiff * msptemp);
  %              (where mstemp was untruncated version of msmoothprobes )
  %      vsmoothsmooth2 = diag(SE);
  indexstruct  = setfield(indexstruct,'vsmoothsmooth',vsmoothsmooth) ;

  %  Add d vector of full smooth space probe smoothness indices
  Eall = (W * mdiff)' * (W * mdiff);
  [B,D] = eig(Eall) ;
  mallsmoprobes = B ;
  SEall = (W * mdiff * mallsmoprobes)' * (W * mdiff * mallsmoprobes);
  vallsmosmooth = diag(SEall) ;
  indexstruct  = setfield(indexstruct,'vallsmosmooth',vallsmosmooth) ;

end ;



