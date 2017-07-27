function [mosaic] = StitchingTwo(im_source, im_dest)
%% detect corner
im1 = rgb2gray(im_source);
im2 = rgb2gray(im_dest);

cimg1 = corner_detector(im1);
cimg2 = corner_detector(im2);
%% Adaptive NMS
max_pts = 200;
[x1, y1, rmax1] = anms(cimg1, max_pts);
[x2, y2, rmax2] = anms(cimg2, max_pts);

visual_feat(im1, cimg1, y1, x1);
visual_feat(im2, cimg2, y2, x2);
%% feature descriptor
descs1 = feat_desc(im1, x1, y1);
descs2 = feat_desc(im2, x2, y2);

%% feature match
match = feat_match(descs1, descs2);

%% ransac
x1 = x1(match ~= -1);
y1 = y1(match ~= -1);
match = match(match ~= -1);
x2 = x2(match);
y2 = y2(match);

thresh = 15;
[H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh);
visual_match( im1, im2, x1, y1, x2, y2, inlier_ind);
%% mosaic
%%construct reference image
[nr_s, nc_s] = size(im1);
[nr_d, nc_d] = size(im2);
corner = [1,1; 1,nr_d; nc_d,1; nc_d,nr_d];
[warp_x, warp_y] = apply_homography(pinv(H), corner(:,1), corner(:,2));

% x and y coordinate of four corners for combined image
new_cor1 = [min(1, min(warp_x)), min(1, min(warp_y))];
new_cor2 = [min(1, min(warp_x)), max(size(im1, 1), max(warp_y))];
new_cor3 = [max(size(im1, 2), max(warp_x)), min(1, min(warp_y))];
new_cor4 = [max(size(im1, 2), max(warp_x)), max(size(im1, 1), max(warp_y))];

% construct refernece image
len = new_cor3(1) - new_cor1(1) + 1;
height = new_cor2(2) - new_cor1(2) + 1;
mosaic = uint8(zeros(ceil(height), ceil(len), 3));
%% locate pixel position in reference image
% manage im1
[cor_x1, cor_y1] = meshgrid((1:size(im1, 2)), (1:size(im1, 1)));
x1_ref = ceil(bsxfun(@minus, cor_x1(:), new_cor1(1) - 1));
y1_ref = ceil(bsxfun(@minus, cor_y1(:), new_cor1(2) - 1));

% manage im2
[cor_x2, cor_y2] = meshgrid((1:size(im2, 2)), (1:size(im2, 1)));
[warp_imx, warp_imy] = apply_homography(pinv(H), cor_x2(:), cor_y2(:));
x2_ref = ceil(bsxfun(@minus, warp_imx, new_cor1(1) - 1));
y2_ref = ceil(bsxfun(@minus, warp_imy, new_cor1(2) - 1));

%% stitching 
% compute offset value between origin image and reference image
delta_x = ceil(1 - new_cor1(1));
delta_y = ceil(1 - new_cor1(2));

% compute edge of two overlapping images
edgel_x1 = min(x1_ref);
edger_x1 = max(x1_ref);
edgeu_y1 = min(y1_ref);
edged_y1 = max(y1_ref);

edgel_x2 = min(x2_ref);
edger_x2 = max(x2_ref);
edgeu_y2 = min(y2_ref);
edged_y2 = max(y2_ref);

% mosaic part
% in overlapping part apply blending method
% set blend parameter based on the distance between pixels and edge
nr_ref = size(mosaic, 1);
nc_ref = size(mosaic, 2);
for i = 1: nr_ref
    for j = 1: nc_ref
        flag_in_ims = 0;        
        
        if (edgel_x1 <= j) && (j <= edger_x1) && (edgeu_y1 <= i) && (i <= edged_y1)
            source_x1 = j - delta_x;
            source_y1 = i - delta_y;
            if (source_x1 > 0) && (source_x1 <= nc_s) && (source_y1 > 0) && (source_y1 <= nr_s)
                mosaic(i, j, :) = im_source(source_y1, source_x1, :);
                flag_in_ims = 1;
            end
        end
        
        if (edgel_x2 <= j) && (j <= edger_x2) && (edgeu_y2 <= i) && (i <= edged_y2)
            [ori_x2, ori_y2] = apply_homography(H, j - delta_x, i - delta_y);
            source_x2 = round(ori_x2);
            source_y2 = round(ori_y2);
            if (source_x2 > 0) && (source_x2 <= nc_d) && (source_y2 > 0) && (source_y2 <= nr_d)
                if flag_in_ims == 1   % overlap field, apply blending 
                    if j >= edgel_x2 && j <= edger_x1  
                        whole_len = edger_x1 - edgel_x2;
                        alfa_ims = (edger_x1 - j)./whole_len;    % set blending parameter based on the distance the pixel to edge
                        alfa_imd = (j - edgel_x2)./whole_len;
                        
                    elseif j >= edgel_x1 && j <= edger_x2
                        whole_len = edger_x2 - edgel_x1;
                        alfa_ims = (j - edgel_x1)./whole_len;    % blending parameter
                        alfa_imd = (edger_x2 - j)./whole_len;
                    end
                    mosaic(i, j, :) = alfa_ims .* im_source(source_y1, source_x1, :) + alfa_imd .* im_dest(source_y2, source_x2, :);                        
                else
                    mosaic(i, j, :) = im_dest(source_y2, source_x2, :);
                end                
            end
        end
        
    end
end
end
