clear all;
close all;
disp('start')

% define your image
[files,dir,~] = uigetfile('*.JPG','Select multiple images',...
                                        'MultiSelect', 'on');
repeating=1;
a = length(files)

% load the first file
fabric = imread(fullfile(dir,files{1}));

h_im = imshow(fabric);
title('Select ROI');
d = imdistline(gca,[100 100],[100 200]);

% Drow circle to define ROI circle
 e = drawcircle('Color','k','Label','My Circle');
 e.Deletable = false;

 for i = 1: a
     file = imread(fullfile(dir,files{i}));
     
 BW = createMask(e,file);
 BW(:,:,2) = BW;
 BW(:,:,3) = BW(:,:,1);
 ROI = file;
 ROI(BW == 0) = 0;
 figure, imshow(ROI);

% Change the circle diameter depends on the droplet size
[centers,radii] = imfindcircles(ROI,[8 13],'ObjectPolarity','bright', ...
    'Sensitivity',0.96);

y = length(centers)
yC = num2str(y)

imshow(ROI)
h = viscircles(centers,radii);

prompt = {'Droplet number:'};
title = 'Input';
dims = [1 36];
definput = {yC};
answer(i) = inputdlg(prompt,title,dims,definput)

end

prompt1 = {'Time(sec):','Max # of the droplets:'};
title1 = 'Time intervals';
dims1 = [1 36];
definput1 = {'10','30'};
sec = inputdlg(prompt1,title1,dims1,definput1)
s = cell2mat(sec)
s2 = str2num(s)
s3 = s2(1,1)

dmax = s2(2,1)

y2 = str2double(answer)
y3 = y2./dmax

x1 = 1:a
x2 = 1/60*s3
x = x1.*x2

% Make sctter plot
scatter(x,y3)

xlabel('Time (min)');
ylabel('Frozen fraction');
ylim([0 1])

% Write to cvs file
Time = x.';
FF = y3.';
T = table([Time],[FF])

writetable(T,'FF.csv')


