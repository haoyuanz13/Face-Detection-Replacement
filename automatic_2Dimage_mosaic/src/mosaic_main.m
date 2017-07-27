%% input images and store them into array
img_input = cell(3, 1);
img_input{1} = imread('nim2.png');
img_input{2} = imread('nim1.png');
img_input{3} = imread('nim3.png');

%% image mosaic
im_mosaic = mymosaic(img_input);
figure;
imagesc(im_mosaic);