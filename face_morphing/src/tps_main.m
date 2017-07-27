%% Image Morphing by TPS
%% get cooresponding points through two input image
im1 = imread('imzhy.png');
im2 = imread('imsd.png');
%[im1_pts, im2_pts] = click_correspondences(im1,im2);
%% create triangle out of corresponding points
%%
warp_frac = [.1,.2,.3,.4,.5];
dissolve_frac = warp_frac;
morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
for k =1:length(warp_frac)
    figure; 
    imagesc(morphed_im{k});
end
%%