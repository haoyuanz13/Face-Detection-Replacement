function morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts)
% morphed_im=zeros(size(im1,1),size(im1,2),3);
% [a1_x_1,ax_x_1,ay_x_1,w_x_1] = est_tps(im1_pts,intermediate(:,1));
% [a1_y_1,ax_y_1,ay_y_1,w_y_1] = est_tps(im1_pts,intermediate(:,2));
% [a1_x_2,ax_x_2,ay_x_2,w_x_2] = est_tps(im2_pts,intermediate(:,1));
% [a1_y_2,ax_y_2,ay_y_2,w_y_2] = est_tps(im2_pts,intermediate(:,2));
% [a1_x_1,ax_x_1,ay_x_1,w_x_1] = est_tps(intermediate,im1_pts(:,1));
% [a1_y_1,ax_y_1,ay_y_1,w_y_1] = est_tps(intermediate,im1_pts(:,2));
[a1_x_2,ax_x_2,ay_x_2,w_x_2] = est_tps(im2_pts,im1_pts(:,1));
[a1_y_2,ax_y_2,ay_y_2,w_y_2] = est_tps(im2_pts,im1_pts(:,2));
% sz1(1)=size(im1,1);
% sz1(2)=size(im1,2);
sz2(1)=size(im2,1);
sz2(2)=size(im2,2);
% morphed_im1 = morph_tps(im1, a1_x_1, ax_x_1, ay_x_1, w_x_1, a1_y_1, ax_y_1, ay_y_1, w_y_1, intermediate, sz1);
morphed_im = morph_tps(im1,im2, a1_x_2, ax_x_2, ay_x_2, w_x_2, a1_y_2, ax_y_2, ay_y_2, w_y_2, im2_pts, sz2);
end