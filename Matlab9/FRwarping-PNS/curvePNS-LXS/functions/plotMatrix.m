function plotMatrix(inputstruct)

% LXS Tools
%
% plot matrix of decomposition of functional data
%
%
% dat -- Functional data with d*n dimension (supposed to be centered or
%        will be centered in this function)
%
% dirs -- directions d*dn
%
% plotType -- 1. dn*dn plot matrix of scores
%             2. m*2 plot matrix of raw functions and the functions. In
%                this case, one can also specify the dimension of the plot
%                matrix using nrow and ncol
%
% colmap -- color map with dimension n*d
%
% label, labels -- names of directions
%                  labels = paste(label, 1:dn)
%
% savestr -- save the plot; if not specified, the plot will not be saved
%
% nrow, ncol -- See plotType option 2
%
% linesize -- control the LineWidth
%
% sameProjectionRange - if the Projections are shown on the same vertical scale
%                       0/1


dat = getfield(inputstruct,'dat') ;
dirs = getfield(inputstruct,'dirs') ;

if isfield(inputstruct,'colmap') ;
    colmap = getfield(inputstruct,'colmap') ;
    if length(size(colmap))==2 | size(colmap,2)==3;
        userCol = 1;
    else userCol=0;
    end;
else userCol=0;
end;
if isfield(inputstruct,'savestr') ;
    savestr = getfield(inputstruct,'savestr') ;
else savestr ='';
end;
if isfield(inputstruct,'linesize') ;
    linesize = getfield(inputstruct,'linesize') ;
else linesize = 1;
end;
if isfield(inputstruct,'label') ;
    label = getfield(inputstruct,'label') ;
else label = 'Component';
end;

dn = size(dirs,2);

labels = cell(1,dn);
for i=1:dn;
   if isfield(inputstruct,['label',num2str(i)]) ;
       labels{i} = getfield(inputstruct,['label',num2str(i)]) ;
   else
       labels{i} = [label,' ',num2str(i)];
    end;
end;
if isfield(inputstruct,'plotType') ;
    plotType = getfield(inputstruct,'plotType') ;
else plotType = 1;
end;
if isfield(inputstruct,'sameProjectionRange') ;
    sameProjectionRange = getfield(inputstruct,'sameProjectionRange') ;
else sameProjectionRange = 0;
end;


[d,n] = size(dat);
resid = dat - vec2matSM(mean(dat,2),n);


if plotType == 1;
    if userCol;
        paramstruct1 = struct('icolor',colmap, ...
            'markerstr','o','linesize',linesize) ;
    else
        paramstruct1 = struct('markerstr','o','linesize',linesize) ;
    end;
    
    
    ifigure = 1;
    for irow = 1:dn;
        for icol = 1:dn;
            subplot(dn,dn,ifigure) ;
            % diagonal plot
            if irow == icol;
                vdir = dirs(:,irow) ;
                projplot1(resid,vdir,paramstruct1) ;
                xlabel([labels{irow},' scores'],'FontSize',12) ;
            else
                vdirs = dirs(:,[icol,irow]) ;
                projplot2(resid,vdirs,paramstruct1) ;
                xlabel([labels{icol},' scores'],'FontSize',12) ;
                ylabel([labels{irow},' scores'],'FontSize',12) ;
            end;
            ifigure = ifigure+1;
        end;
    end;
end;



if plotType == 2;
    
    
    if isfield(inputstruct,'nrow') ;
        nrow = getfield(inputstruct,'nrow') ;
    else nrow = ceil((dn+1)/2);
    end;
    if isfield(inputstruct,'ncol') ;
        ncol = getfield(inputstruct,'ncol') ;
    else ncol=2;
    end;
    xgrid = 1:d;
    
    ifigure = 1;
    subplot(nrow,ncol,ifigure) ;
    if userCol;
        hold on ;
        for idat = 1:n ;
            plot(xgrid,dat(:,idat),'-','Color',colmap(idat,:),'LineWidth',linesize);
        end;
        hold off ;
    else plot(xgrid,dat(:,:),'-','LineWidth',linesize);
    end ;
    vax = axis;
    vax(1:2) = [1,d];
    axis(vax);
    title(['Raw Data']) ;
    box(gca,'on');
    
    scores = dirs' * resid;
    proj = dirs(:,1) * scores(1,:);
    for iev = 2:dn ;
        proj = cat(3,proj,dirs(:,iev) * scores(iev,:)) ;
    end ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for id = 1:dn ;
        
        ifigure = ifigure+1;
        
        % PC projection
        subplot(nrow,ncol,ifigure) ;
        if userCol;
            hold on ;
            for idat = 1:n ;
                plot(xgrid,proj(:,idat,id),'-','Color',colmap(idat,:),'LineWidth',linesize);
            end;
            hold off ;
        else plot(xgrid,proj(:,:,id),'-','LineWidth',linesize);
        end ;
        if id==1;
             vax = [min(xgrid),max(xgrid),...
                min(min(min(proj(:,:,:)))),...
                max(max(max(proj(:,:,:))))];
        end;
        if sameProjectionRange;
            axis(vax);
        end;
        title(labels{id}) ;
        box(gca,'on');
        
    end;
end;