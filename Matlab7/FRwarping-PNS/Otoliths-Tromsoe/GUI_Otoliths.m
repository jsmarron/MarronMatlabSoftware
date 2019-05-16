function GUI_Otoliths(arg)
% GUI for looking at the otoliths data.
%
% Upper left: Image of otolith with segmentation border in purple and center
% point given as a red cross. Circular artifacts in the image are air
% bubbles. Clicking on the top left image produce a range profile through 
% the centre point and the clicked point.
%
% Upper middle: Image shows 1440 range profiles, making each range profile
% being separated by 0.25 degrees. Zero degress corresponds to directly
% left in the image, and then clockwise around the cirle.
% Clicking on the top middle image produce a range profile through the 
% corresponding range profile. The slider below this image is another way
% of selecting range profiles to plot.
%
% For normalized range profiles, Alf has also produces circular profiles,
% shown in the upper right plot. A similar image for raw data is not made. 
%
% The different available images can be loaded in the pulldown menu above
% the middle top image.
%
% All lines can be reset by the button below the slider.
%
% The big button to the middle left of the GUI changes the setting between
% looking at the raw, unscaled data, and the data that has been
% range-normalized by Alf earlier.
%
% The segmentation/border of the otolith is produced by a fairly crude 
% gray-scale thresholding algorithm.
%
% In the lower plot, we see the range profiles. The small, purple bar
% indicates where the segmentation/border point (for raw data).
%
% The range profiles are bicubic interpolations, and the number of pixles
% is equal to the number of pixels the range profile crosses. That is, a
% range profile that moves two points in the x direction and four points in
% the y direction, will for this section get sqrt(2^2+4^2) interpolated
% pixels in the range profile.
%
% Kristian Hindberg @ NST/UiT, February 2014

if nargin==0
    arg = 0;
end

if arg ==0 || arg<0
    close all
    if arg<0
        im_num = abs(arg);
    else
        im_num = 2; % possible values are 1-5
    end
    
    % Load struct with the data
    load(['Data', filesep, sprintf('img_AH_%2.2d.mat',im_num)]);
    im      = img.im;
    imr     = img.imr;
    imc     = img.imc;
    imcp    = img.cp;
    
    colbar = [' -b';' -r',;' -y';' -k';' -m';' -c';' -g';
        '--b';'--r',;'--y';'--k';'--m';'--c';'--g';
        '-.b';'-.r',;'-.y';'-.k';'-.m';'-.c';'-.g';
        ' :b';' :r',;' :y';' :k';' :m';' :c';' :g';];
    colbar = repmat(colbar,20,1);
    
    % Plot data
    HF = figure(1);
    set(gcf,'position',[70 58 1748 926])
    set(gcf, 'toolbar', 'figure' )
    set(gcf,'WindowButtonDownFcn','GUI_Otoliths(5)')
    
    % Define axis for the image and the border, with radial profiles
    ax1 = axes;
    imagesc(im)
    colormap(gray)
    hold on
    h_midpoint = plot(imcp(1),imcp(2),'rx','linew',2);
    set(h_midpoint,'tag','midpoint_dont_delete');
    set(ax1,'tag','ax1','pos',[0.025    0.5838    0.385    0.3412]);
    axis equal
    axis tight
    % Remove tics
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    pause(0.01);    % Force the update
    
    % Define button to save the chosen profiles
        % Push button to change between normalized and non-normalized data
    uicontrol(HF,'style','push','vis','on','units','norm','pos',[0.14    0.93    0.15    0.05], ...
        'callback','GUI_Otoliths(6)','String','Save range profiles', ...
        'fontsize',12,'fontwei','bold','tag','save_button','backgroundcol','green');
    
    % Plot segmentation mask
    angle_directions    = img.angle_directions;
    cut_offs            = img.cut_offs;
    x_c = imcp(1) - cos(angle_directions/180*pi).*cut_offs';
    y_c = imcp(2) - sin(angle_directions/180*pi).*cut_offs';
    hold on
    h_seg_mask = plot(x_c,y_c,'-m');
    set(h_seg_mask,'tag','segMask_dont_delete');
    
    % Define axis 2 all for the range profiles (rectangular plot)
    ax2 = axes;
    imagesc(imr)
    set(ax2,'tag','ax2','pos',[0.4108+0.05 0.5838 0.2134 0.3412])
    set(ax2,'xtick',[0:1/8:1]*numel(angle_directions))
    set(ax2,'xticklabel',num2str([0:45:360]'))
    
    % Define axis three for the circular plot
    ax3 = axes;
    imagesc(imc)
    set(ax3,'tag','ax3','pos',[0.6916+0.05 0.5838 0.2134 0.3412])
    
    % Define image selection pulldown meny
    uicontrol(gcf,'style','text','units','norm','pos', [0.48 0.95 0.10 0.03],...
        'string','File number','fontwei','bold','fontsize',14); %
    uicontrol(gcf,'style','pop','units','norm','pos',[0.58 0.95 0.06 0.03], ...
        'callback','GUI_Otoliths(4)','fontwei','bold','string',num2str([1:5]'), ...
        'fontsize',12,'tag','filenumpop','value',im_num); %#ok<*NBRAK>

    % Slider for selecting range profile to plot
    Hsl_01=uicontrol(HF,'style','slider','units','norm','pos',[0.39+0.05 0.53 0.255 0.02], ...
        'tag','slider_01','min',0.001,'max',0.9999,'value',0.5);
    set(Hsl_01,'callback','GUI_Otoliths(1)','sliderstep',[1/1440 1/12]);
    
    % Push button to change between normalized and non-normalized data
    uicontrol(HF,'style','push','vis','on','units','norm','pos',[0.075+0.05 0.51 0.20 0.055], ...
        'callback','GUI_Otoliths(3)','String','Use non-normalized profiles', ...
        'fontsize',12,'fontwei','bold','tag','norm_button');
    
    % Define axis to plot profiles
    ax5 = axes;
    hold on
    set(ax5,'vis','off','tag','ax5','units','norm','pos',[0.025 0.11 0.93 0.3412])
    
    % Define reset button
    uicontrol(HF,'style','push','vis','on','units','norm','pos',[0.495+0.05 0.49 0.05 0.025], ...
        'callback','GUI_Otoliths(2)','String','Reset lines','fontwei','bold');
    
    % For storing handles to all chilten of figure in the figure itself
    h=guihandles(HF);
    guidata(HF,h);
    
    UD.im_num               = im_num;
    UD.im                   = im;
    UD.imr                  = imr;
    UD.imc                  = imc;
    UD.colbar               = colbar;
    UD.imcp                 = imcp;
    UD.cut_offs             = cut_offs;
    UD.angle_directions     = angle_directions;
    set(HF,'userdata',UD);    
    
    % Switch to non-normalized values as start-up default
    GUI_Otoliths(3)
    
elseif arg ==1 % Plot lines
    
    UD  = get(gcf,'userdata');
    h   = guidata(gcf);
    
    set(h.ax5,'vis','on');
    ch = numel(get(h.ax5,'children'));
    if strcmp(get(h.norm_button,'string'),'Use normalized profiles')
        ch = round(ch/2);
    end
    
    % Find line to plot
    if strcmp(get(gco,'tag'),'slider_01')
        val = get(gco,'value'); 
    else
        val = UD.corr_slider_value;
    end
    % Plot line in rectangular image
       
    axes(h.ax2);hold on;
    n_cols = size(UD.imr,2);
    plot([val*n_cols val*n_cols],[0 size(UD.imr,1)],UD.colbar(ch+1,:));
        
    ang = 2*pi*val; % Angel in radian
    
    % Plot circle figure, if relevant
    if strcmp(get(h.ax3,'visib'),'on')
        axes(h.ax3);hold on;
        ang_pos = [-cos(ang)*200 -sin(ang)*200];
        plot([200 200+ang_pos(1)],[200 200+ang_pos(2)],UD.colbar(ch+1,:));
    end
    
    % This is the old way of finding the directions, but it is ok to leave
    % it like this here. This code is only used for plotting.
    axes(h.ax1)
    for dummy_plot_the_line = 1:1
        if ang < pi/2 || ang > 3*pi/2
            x = [0:UD.imcp(1)-1];
            y = -x.*tan(ang) + UD.imcp(2);
            if ang < pi/2
                bad_inds = y<0;
                y(bad_inds) = [];
                if numel(y)==1 % This is if the angle is _VERY_ close to 90 or 270
                    y = [y(1) 1];
                    x = [x(1) x(1)];
                else
                    x(bad_inds) = [];
                end
            else
                bad_inds = y > size(UD.im,1);
                y(bad_inds) = [];
                if numel(y)==1  % This is if the angle is _VERY_ close to 90 or 270
                    y = [y(1) size(UD.im,1)];
                    x = [x(1) x(1)];
                else
                    x(bad_inds) = [];
                end
            end
            hold on
            plot(UD.imcp(1)-x,y,UD.colbar(ch+1,:))
            
        elseif ang > pi/2 && ang < 3*pi/2
            x = [UD.imcp(1):size(UD.im,2)];
            y = (x-UD.imcp(1)).*tan(ang) + UD.imcp(2);
            if ang < pi
                bad_inds = y<0;
                y(bad_inds) = [];
                if numel(y)==1  % This is if the angle is _VERY_ close to 90 or 271
                    y = [y(1) 1];
                    x = [x(1) x(1)];
                else
                    x(bad_inds) = [];
                end
            else
                bad_inds = y > size(UD.im,1);
                y(bad_inds) = [];
                if numel(y)==1  % This is if the angle is _VERY_ close to 90 or 270
                    y = [y(1) size(UD.im,1)];
                    x = [x(1) x(1)];
                else
                    x(bad_inds) = [];
                end
            end
            hold on
            plot(x,y,UD.colbar(ch+1,:))
            
        elseif ang == pi/2                              % Exactly 90 degrees
            plot([UD.imcp(1) UD.imcp(1)],[1 UD.imcp(2)], UD.colbar(ch+1,:))
        elseif ang == 3*pi/2                            % Exactly 270 degrees
            plot([UD.imcp(1) UD.imcp(1)],[UD.imcp(2) size(UD.im,1)], UD.colbar(ch+1,:))
        elseif ang == 0                                 % Exactly 0 degrees
            plot([0 UD.imcp(1)],[UD.imcp(2) UD.imcp(2)], UD.colbar(ch+1,:))
        elseif ang == pi                                % Exactly 180 degrees
            plot([UD.imcp(1) size(UD.im,2)],[UD.imcp(2) UD.imcp(2)], UD.colbar(ch+1,:))
        end
    end
    
    % Plot the profile
    axes(h.ax5);
    range_profile_number = round(val*n_cols);
    Ltemp = plot(UD.imr(:,range_profile_number),UD.colbar(ch+1,:));
    % Store the range profile number in the userdata of the profile
    set(Ltemp,'userdata',range_profile_number)

    if strcmp(get(h.norm_button,'string'),'Use normalized profiles')
        plot([UD.cut_offs(range_profile_number) UD.cut_offs(range_profile_number)], ...
            [0 35],'m','linew',2);
    end

    set(gca,'xlim',[0 size(UD.imr,1)])
    
elseif arg ==2 % Reset lines
    
    h   = guidata(gcf);
    for dummy_reset_line_in_all_axes = 1:1
        lines = get(h.ax1,'children');
        for l = 1:numel(lines)
            if strcmp(get(lines(l),'type'),'line') && lines(l)~=h.midpoint_dont_delete && lines(l)~=h.segMask_dont_delete
                delete(lines(l))
            end
        end
        
        lines = get(h.ax2,'children');
        for l = 1:numel(lines)
            if strcmp(get(lines(l),'type'),'line')
                delete(lines(l))
            end
        end
        lines = get(h.ax3,'children');
        for l = 1:numel(lines)
            if strcmp(get(lines(l),'type'),'line')
                delete(lines(l))
            end
        end
        
        set(h.slider_01,'value',0.5)
        cla(h.ax5);
    end
    
elseif arg == 3 % Change to and from normalized data
    
    h       = guidata(gcf);
    UD      = get(gcf,'userdata');
    im_num  = UD.im_num;
    
    if strcmp(get(h.norm_button,'string'),'Use non-normalized profiles')
        set(h.norm_button,'string','Use normalized profiles')       
        
        % Load time series data
        load(['Data', filesep, sprintf('img_KH_%2.2d.mat',im_num)]);
        % Find max-length
        n_dirs = numel(im_ts); %#ok<USENS>
        max_length = 0;
        for d=1:n_dirs
            if length(im_ts{d}) > max_length
                max_length = length(im_ts{d});
            end
        end
        
        data_mat_ts = zeros(max_length,n_dirs);
        for d=1:n_dirs
            data_mat_ts(1:length(im_ts{d}),d) = im_ts{d};
        end
        
        axes(h.ax2)
        cla
        imagesc(data_mat_ts)
        axis([1 size(data_mat_ts,2) 1 size(data_mat_ts,1)])
        
        set(h.ax3,'visib','off')
        ch = get(h.ax3,'children');
        for c=1:numel(ch)
            set(ch,'visib','off');
        end

        UD.imr = data_mat_ts;
        
        % Change visibility of save button
        set(h.save_button,'visib','on')
        
    else
        set(h.norm_button,'string','Use non-normalized profiles')
        % Load struct with the data
        load(['Data', filesep, sprintf('img_AH_%2.2d.mat',im_num)]);
        axes(h.ax2)
        cla
        imagesc(img.imr)
        UD.imr = img.imr;
        axis([1 size(img.imr,2) 1 size(img.imr,1)])
        
        set(h.ax3,'visib','on')
        ch = get(h.ax3,'children');
        for c=1:numel(ch)
            set(ch,'visib','on');
        end
        
        % Change visibility of save button
        set(h.save_button,'visib','off')
       
    end
    set(h.ax2,'xtick',[0:1/8:1]*numel(UD.angle_directions))
    set(h.ax2,'xticklabel',num2str([0:45:360]'),'tag','ax2')

    set(gcf,'userdata',UD);
    GUI_Otoliths(2) % Reset lines etc
    
    axes(h.ax5) % Make sure the current axis is an axis without callback
    
elseif arg == 4 % Change file
    
    h       = guidata(gcf);

    filenum = get(h.filenumpop,'value');
    eval(sprintf('GUI_Otoliths(-%d)',filenum))
        
elseif arg == 5 % Pick up image position when clicking on image
    h  = guihandles(gcf);
    if strcmp(get(gca,'tag'),'ax1')
        pos_image       = get(h.ax1,'currentpoint');
        UD              = get(gcf,'userdata');
        UD.pos_image    = pos_image(1,1:2);
        
        % Find angle
        dx = (UD.imcp(1)-UD.pos_image(1));
        dy = (UD.imcp(2)-UD.pos_image(2));
        ang = atan(dy/dx);
        if dx<0 && dy<0
            ang = ang + pi;
        elseif dx>0 && dy<0
            ang = 2*pi+ang;
        elseif dx<0 && dy>0
            ang = pi + ang;
        end
        UD.corr_slider_value = ang/(2*pi);
        set(gcf,'userdata',UD);
        GUI_Otoliths(1)
        
    elseif strcmp(get(gca,'tag'),'ax2')
        pos_image       = get(h.ax2,'currentpoint');
        UD              = get(gcf,'userdata');
        if pos_image(1,1)>0 && pos_image(1,1)<=size(UD.imr,2) && pos_image(1,2)>0 && pos_image(1,2)<=size(UD.imr,1)
            
            % Find angle direction number
            UD.corr_slider_value = pos_image(1,1)/numel(UD.angle_directions);
            set(gcf,'userdata',UD);
            GUI_Otoliths(1)
        end
    end    
    
elseif arg == 6 % Save chosen range profiles

    h       = guidata(gcf);
    UD      = get(gcf,'userdata');
    
    % Find all children of figure 5 with the range profiles
    childs5 = get(h.ax5,'children');
    if isempty(childs5)==false
        
        % Determine the range profile numbers used
        % These are found in the 'userdata' of the lines
        range_num = [];
        for i = 1:numel(childs5)
            child = childs5(i);
            child_type = get(child,'type');
            if strcmp(child_type,'line')
                x = get(child,'xdata');
                if x(2)-x(1)>0 % Then we do not have a vertical line marking the border
                    range_num = [range_num get(child,'userdata')]; %#ok<AGROW>
                end
            end
        end
        % Sort the wanted profiles and use 'unique' to make sure you do not
        % get duplicates.
        range_num = sort(unique(range_num));
        % Extract the wanted profiles
        data_out = UD.imr(:,range_num); %#ok<*NASGU>
        
        % Make struct with some of the relevant data and also save it
        More_data = UD;
        More_data = rmfield(More_data,'corr_slider_value');
        More_data = rmfield(More_data,'pos_image');
        More_data = rmfield(More_data,'colbar');
        More_data = rmfield(More_data,'imc');
        
        % Define the save string, use current date and time
        cl = clock;
        if cl(4)<10
            hour_str = ['0' num2str(cl(4))];
        else
            hour_str = num2str(cl(4));
        end
        if cl(5)<10
            min_str = ['0' num2str(cl(5))];
        else
            min_str = num2str(cl(5));
        end
        
        save_string = ['Data_out_' date '_Time_' hour_str min_str '.mat'];
        
        % Save the data
        save(save_string,'data_out','range_num','More_data')
        
        msgbox(sprintf('Data saved to file ''%s''.',save_string));
    else

        msgbox(['No profiles are selected.']);
    end
end










%


