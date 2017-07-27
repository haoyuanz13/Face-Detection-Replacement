function [morphed_im] = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%% make two images into same size
[nr_1,nc_1,x_1] = size(im1);
[nr_2,nc_2,x_2] = size(im2);
im1_pts = flip(im1_pts,2);
im2_pts = flip(im2_pts,2);

rate = 1;
if (nr_1<=nr_2) && (nc_1<=nc_2)
    im1 = padarray(im1,[nr_2-nr_1, nc_2-nc_1],'post');
else
    rate = min((nr_2/nr_1),(nc_2/nc_1));
    im1 = imresize(im1,rate);
    [nr_1,nc_1,x_1] = size(im1);
    im1 = padarray(im1,[nr_2-nr_1,nc_2-nc_1],'post');
end
im1_pts = floor(im1_pts.* rate);
%%
M = length(warp_frac);
morphed_im = cell(M,1);
for k =1:M,
    morphed_ims = 0.*im1 + 0.*im2;
    im_inter = (1-warp_frac(k)).*im1_pts + warp_frac(k).*im2_pts;
    sz = size(morphed_ims);
%% compute TPS parameters of im1
% ctr_pts are feature points in source image(N*2)
% target_value represents corresponding points position x or y

    [a1_x,ax_x,ay_x,aw_x] = est_tps(im_inter,im1_pts(:,1)); 
    [a1_y,ax_y,ay_y,aw_y] = est_tps(im_inter,im1_pts(:,2));
%% compute morphed image according to source image 1
    morphed_ims1 = morph_tps(im1, a1_x, ax_x, ay_x, aw_x, a1_y, ax_y, ay_y, aw_y, im_inter, sz);

%% compute TPS parameters of im2
    [b1_x,bx_x,by_x,bw_x] = est_tps(im_inter,im2_pts(:,1)); 
    [b1_y,bx_y,by_y,bw_y] = est_tps(im_inter,im2_pts(:,2));
%% compute morphed image according to source image 2
    morphed_ims2 = morph_tps(im2, b1_x, bx_x, by_x, bw_x, b1_y, bx_y, by_y, bw_y, im_inter, sz);

%% combine two morphed images above with the dissolve_frac
    morphed_ims = (1-dissolve_frac(k)).*morphed_ims1 + dissolve_frac(k).*morphed_ims2;
    morphed_im{k} = morphed_ims;
end
end
