% Adaptive Non-Maximal Suppression
% cimg = corner strength map
% max_pts = number of corners desired
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners
function [x, y, rmax] = anms(cimg, max_pts)
%% find the distance to the closest pointer with a greater score
%% filter corner points 
% non-max suppression
[nr, nc] = size(cimg);
pad_corner = padarray(cimg, [1,1], 'both');
corner = zeros(nr*nc, 3);
threshold = 0.015;
k = 0;
for i = 2: nr + 1
    for j = 2: nc + 1
        k = k + 1;
        local_max = pad_corner(i, j);
        if local_max > threshold
            window = pad_corner(i - 1: i + 1, j - 1: j + 1);
        
            window(2, 2) = -1;        
            if max(max(window)) < local_max
                corner(k, 1) = local_max;
                corner(k, 2) = i - 1;
                corner(k, 3) = j - 1;
            else
                corner(k,:) = -1;
            end
        else
            corner(k, :) = -1;
        end
    end
end
%% find rmax of each corner point
% true_corner matrix stores 4 info of each corner pixel
% 1st column: intensity; 2nd column: row index; 
% 3rd column: column index; 4th column: rmax
corner = corner(corner > 0);
true_corner = zeros(length(corner)/3, 4);
true_corner(:,1:3) = reshape(corner, length(corner)/3, 3);  

for k = 1: length(corner)/3
    local = true_corner(k,:);
    dis_r = bsxfun(@minus, true_corner(:,2), local(2));
    dis_c = bsxfun(@minus, true_corner(:,3), local(3));
    dis = sqrt(dis_r.^2 + dis_c.^2);
    %dis = (true_corner(:,2) - local(2)).^2 + (true_corner(:,3) - local(3)).^2 ;
    valid = dis(true_corner(:,1) > local(1));
    if isempty(valid)
        true_corner(k, 4) = nr.^2 + nc.^2;
    else
        true_corner(k ,4) = min(valid);
    end
end

%% based on the max_pts to select rmax 
r = sort(true_corner(:, 4));
search = unique(r);
number = zeros(length(search), 2);
for ind = 1:length(search)
    rmax = search(ind);
    maxn = length(r(r >= rmax));
    number(ind,:) = [maxn, rmax];
end

flag = any(max_pts == number(:,1));
if flag == 0
    below = number(number(:,1) < max_pts);
    max_num = below(1);
else
    max_num = max_pts;
end
result = number(number(:,1) == max_num,:);
rmax = result(1,2);
fit = true_corner(true_corner(:, 4) >= rmax,:);
% x is column coordinates
% y is row coordinates
y = fit(:,2);
x = fit(:,3);
end