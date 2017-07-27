imsource = imread('source.jpg');
imtarget = imread('target.jpg');
%% set offset point and compute mask matrix of source image
offsetX = 355;
offsetY = 45;

imsource = imresize(imsource, 0.075);
mask_source = maskImage(imsource);
%% construct blending image
imsource = double(imsource);
imtarget = double(imtarget);

resultImg = seamlessCloningPoisson(imsource, imtarget, mask_source, offsetX, offsetY);
figure
imagesc(resultImg);