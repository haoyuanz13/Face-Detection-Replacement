% y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
% that (y1i, x1i) matches (y2i, x2i) after a preliminary matching

% thresh is the threshold on distance used to determine if transformed
% points agree

% H is the 3x3 matrix computed in the final step of RANSAC

% inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
% x2, y2 that were found to be inliers

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)
iteration = 100;
count = 0;

for rep = 1:iteration
    ind = randperm(length(x1), 4);
    
    source_x = x1(ind');
    source_y = y1(ind');
    dest_x = x2(ind');
    dest_y = y2(ind');
    
    H_local = est_homography(dest_x, dest_y, source_x, source_y);
    [pred_X, pred_Y] = apply_homography(H_local, x1, y1);
    
    ssd = bsxfun(@minus, pred_X, x2).^2 + bsxfun(@minus, pred_Y, y2).^2;
    if count < length(ssd(sqrt(ssd) < thresh))
        count = length(ssd(sqrt(ssd) < thresh));
        inlier_ind = (sqrt(ssd) < thresh);
    end
end

%% use all inliers to re-compute final H
H = est_homography(x2(inlier_ind), y2(inlier_ind), x1(inlier_ind), y1(inlier_ind));

end