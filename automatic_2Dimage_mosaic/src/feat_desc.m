% img = double (height)x(width) array (grayscale image) with values in the
% range 0-255
% x = nx1 vector representing the column coordinates of corners
% y = nx1 vector representing the row coordinates of corners
% descs = 64xn matrix of double values with column i being the 64 dimensional
% descriptor computed at location (xi, yi) in im
% in order to construct 40*40 window, there are two methods:
% 1. padding zeors around the image;
% 2. remove corners within 20 pixels of the edge
function [descs] = feat_desc(img, x, y)
%% padding zeros around the image
pad_img = padarray(img, [20, 20], 'both');
%% downsample and construct descriptors
n = length(x);
descs = zeros(64,n);
x = x + 20;
y = y + 20;
for i = 1:n
    window = pad_img(y(i) - 20: y(i) + 19, x(i) - 20: x(i) + 19);
    patch = downsample(window, 5);
    patch = downsample(patch', 5);
    patch = patch';
    descriptor = reshape(patch, 64, 1);
    %% bias normalize
    des = double(descriptor);
    mu = mean(des);
    sigma = std(des);
    normal_des = bsxfun(@minus, des, mu);
    descs(:,i) = bsxfun(@rdivide, normal_des, sigma);
end
