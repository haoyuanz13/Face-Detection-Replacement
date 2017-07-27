function mask = maskImage(Img)
resize_im = imshow(Img);
h = imfreehand;
mask = createMask(h, resize_im);
end

