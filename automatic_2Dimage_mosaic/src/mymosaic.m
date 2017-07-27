% img_input is a cell array of color images (HxWx3 uint8 values in the
% range [0,255])
% img_mosaic is the output mosaic

function [img_mosaic] = mymosaic(img_input)
total = length(img_input);
img_mosaic = img_input{1};
for k = 2: total
    im_source = img_mosaic;
    im_dest = img_input{k};
    img_mosaic = StitchingTwo(im_source, im_dest);
end