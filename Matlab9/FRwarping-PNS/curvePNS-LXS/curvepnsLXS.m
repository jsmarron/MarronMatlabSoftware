function curvepnsLXS(inputstruct)

% horizontal analysis via PNS of horizontal SRVFs
%
% inputstruct:
%
% gam -- warping functions (d by n)
%
% meanf -- (Karcher) mean of original functions (d by n)
%
% npns -- number of PNS
%
% colmap -- matrix for specifying color (n by 3);
%           if not specified, the default color map is used
%
% pnsType -- PNS option:
%            0  'seq.test' : ordinary Principal Nested Sphere
%                               with sequential tests.
%            1  'small'    : (default) Principal Nested SMALL Sphere
%            2  'great'    : Principal Nested GREAT Sphere (radius pi/2)
%
% plotType -- 1. (default) plot matrix of PNS scores
%             2. plot matrix of raw functions and the PNS projections.
%                One can specify the dimension of the plot
%                matrix using nrow and ncol.
%
% nrow, ncol -- See plotType option 2; by defult ncol = 2
%
% linesize -- width of the line
%
% sameProjectionRange - whether use the same scale in the subplots
%
% t -- time on x axis (valid when plotType = 2);
%      t = 1:d by default
%
% Copyright (c) Xiaosun Lu 2013


gam = getfield(inputstruct,'gam') ;
meanf = getfield(inputstruct,'meanf') ;

if isfield(inputstruct,'colmap') ;
    colmap = getfield(inputstruct,'colmap') ;
    userCol = 1;
else userCol=0;
end;

if isfield(inputstruct,'pnsType') ;
    pnsType = getfield(inputstruct,'pnsType') ;
else pnsType = 1;
end;

if isfield(inputstruct,'plotType') ;
    plotType = getfield(inputstruct,'plotType') ;
else plotType = 1;
end;

if isfield(inputstruct,'npns') ;
    npns = getfield(inputstruct,'npns') ;
else npns = 1;
end;

if isfield(inputstruct,'linesize') ;
    linesize = getfield(inputstruct,'linesize') ;
else linesize = 1;
end;

if isfield(inputstruct,'sameProjectionRange') ;
    sameProjectionRange = getfield(inputstruct,'sameProjectionRange') ;
else sameProjectionRange = 1;
end;


n = size(gam,2);
d = size(meanf,1);

if isfield(inputstruct,'t') ;
    t = getfield(inputstruct,'t') ;
else t = 1:d;
end;




%%  do main PNS
psi = fun2srvf(gam,t);
radius = mean(sqrt(sum(psi.^2)));
pnsdat = psi./repmat(sqrt(sum(psi.^2)),d-1,1)*1;

[resmat PNS]=PNSmainHDLSS(pnsdat,pnsType);


%%  make output plot

clf;

%%
if plotType == 1;
    
    tmpdirs = diag(ones(npns,1),0);
    inputstruct = struct('dat',resmat((1:npns),:)*radius,...
        'dirs',tmpdirs,'plotType',1,...
        'label','PNS',...
        'colmap',colmap,...
        'sameProjectionRange',sameProjectionRange);
    plotMatrix(inputstruct);
end;

%%
if plotType == 2;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    EuclidData = resmat;
    % vector of st.dev
    stdevPNS = sqrt(sum(abs(EuclidData).^2, 2) / n);
    % matrix of direction vectors
    udir = eye(size(EuclidData,1));
    
    
    projPsi = zeros(d-1,n,npns);
    for PCnum = 1:npns;
        ptEval =  udir(:,PCnum)*resmat(PCnum,:) ;
        % evaluation points on pre-shape space
        PCvec= PNSe2s(ptEval,PNS);
        projPsi(:,:,PCnum) = PCvec*radius;
    end;
    
    % Psi->gam
    projGam = zeros(d,n,npns);
    for i = 1:npns;
        projGam(:,:,i) = srvf2fun(projPsi(:,:,i),t,0);
    end;
    
    % Gam->F
    proj = zeros(d,n,npns);
    for i = 1:npns;
        for j = 1:n;
            psiF = projGam(:,j,i);
            psiGam = (psiF-psiF(1))/max(psiF-psiF(1));
            gamI = invertGamma(psiGam);
            proj(:,j,i) = interp1(t, meanf, (t(end)-t(1)).*gamI+ t(1));
        end
    end;
    
    
    hf = zeros(d,n);
    for i = 1:n;
        gamI = invertGamma(gam(:,i));
        hf(:,i) = interp1(t, meanf, (t(end)-t(1)).*gamI+ t(1));
    end;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isfield(inputstruct,'nrow') ;
        nrow = getfield(inputstruct,'nrow') ;
    else nrow = ceil((npns+1)/2);
    end;
    if isfield(inputstruct,'ncol') ;
        ncol = getfield(inputstruct,'ncol') ;
    else ncol=2;
    end;
    npx = ncol; npy=nrow;
    xgrid = t;
    
    ifigure = 1;
    subplot(nrow,ncol,ifigure) ;
    if userCol;
        hold on ;
        for idat = 1:n ;
            plot(xgrid,hf(:,idat),'-','Color',colmap(idat,:),'LineWidth',linesize);
        end;
        hold off ;
    else plot(xgrid,hf(:,:),'-','LineWidth',linesize);
    end ;
    vaxf =[min(xgrid),max(xgrid),min(min(hf)),max(max(hf))];
    vaxf(3) = vaxf(3) - range(vaxf(3:4))/10;
    vaxf(4) = vaxf(4) + range(vaxf(3:4))/10;
    title('Horizontal variation') ;
    box(gca,'on');
    axis(vaxf);
    
    vax1 = vaxf;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ipns = 1:npns ;
        
        ifigure = ifigure+1;
        
        % PC projection
        subplot(nrow,ncol,ifigure) ;
        if userCol;
            hold on ;
            for idat = 1:n ;
                plot(xgrid,proj(:,idat,ipns),'-','Color',colmap(idat,:),'LineWidth',linesize);
            end;
            hold off ;
        else plot(xgrid,proj(:,:,ipns),'-','LineWidth',linesize);
        end ;
        vax = [min(xgrid),max(xgrid),...
            min(min(proj(:,:,ipns))),...
            max(max(proj(:,:,ipns)))];
        vax(3) = vax(3) - range(vax(3:4))/10;
        vax(4) = vax(4) + range(vax(3:4))/10;
        if sameProjectionRange;
            axis(vax1)
        else axis(vax);
        end;
        title(['PNS' num2str(ipns)]) ;
        box(gca,'on');
        
    end;
    
end;

