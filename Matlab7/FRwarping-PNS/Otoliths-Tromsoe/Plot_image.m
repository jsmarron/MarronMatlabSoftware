function Plot_image(im_num,plotnum)
% Code to only plot one image
%
% Kristian Hindberg @ UiT March 2014

if nargin < 2
    plotnum = 10;
end

if nargin < 1
    im_num = 1;
end

% Load data
load(['Data', filesep, sprintf('img_AH_%2.2d.mat',im_num)])

figure(plotnum);clf
subplot(1,3,1)
imagesc(img.im)
colormap(gray)
hold on
plot(img.cp(1),img.cp(2),'rx','linew',2);
% Plot segmentation mask
x_c = img.cp(1) - cos(img.angle_directions/180*pi).*img.cut_offs';
y_c = img.cp(2) - sin(img.angle_directions/180*pi).*img.cut_offs';

h_seg_mask = plot(x_c,y_c,'-m');
set(h_seg_mask,'tag','segMask_dont_delete');

subplot(1,3,2)
imagesc(img.imr)
subplot(1,3,3)
imagesc(img.imc)
set(gcf,'unit','normal','pos',[0.1 0.4 0.8 0.4])
set(gcf,'paperpos',[1 1 18 6])

print(gcf,'-djpeg100',sprintf('Image_%2.2d.jpeg',im_num))
