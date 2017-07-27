% img is an image
% cimg is a corner matrix

function [cimg] = corner_detector(img)
cimg = cornermetric(img);
cimg = imadjust(cimg);
end