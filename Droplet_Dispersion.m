
close all
clear all

i = 'Troy 2019-07-04 12h10m30s(Fluorescein).jpg'
 
% load the first file
rgb = imread(i);

img = imshow(rgb);
title('Select ROI');
d = imdistline(gca,[100 100],[100 200]);

% Drow circle to define ROI circle
e = drawcircle('Color','k','Label','My Circle');
e.Deletable = false;

BW = createMask(e,rgb);
BW(:,:,2) = BW;
BW(:,:,3) = BW(:,:,1);
ROI = rgb;
ROI(BW == 0) = 0;
figure, imshow(ROI);

% Change the circle diameter depends on the droplet size
[centers,radii] = imfindcircles(ROI,[4 9],'ObjectPolarity','bright', ...
    'Sensitivity',0.93);

a = length(centers)
r = radii

imshow(ROI)
h = viscircles(centers,radii)

histogram(r)

% Write to cvs file

T = table([r])

writetable(T,'FF.csv')
