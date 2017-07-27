function [im1_pts, im2_pts] = click_correspondences(im1,im2)
im_move = im1;
im_fix = im2;
[im1_pts, im2_pts] = cpselect(im_move,im_fix,'Wait',true);
end