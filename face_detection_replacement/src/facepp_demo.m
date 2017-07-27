function [logical_map, x, y] = facepp_demo(filepath)
%
% Face++ Matlab SDK demo
%
% close all;
% clc;clear;
% Load an image, input your API_KEY & API_SECRET
img = filepath;
API_KEY = 'd45344602f6ffd77baeab05b99fb7730';
API_SECRET = 'jKb9XJ_GQ5cKs0QOk6Cj1HordHFBWrgL';

% If you have chosen Amazon as your API sever and 
% changed API_KEY&API_SECRET into yours, 
% pls reform the FACEPP call as following :
% api = facepp(API_KEY, API_SECRET, 'US')
api = facepp(API_KEY, API_SECRET);

% Detect faces in the image, obtain related information (faces, img_id, img_height, 
% img_width, session_id, url, attributes)
rst = detect_file(api, img, 'all');
img_width = rst{1}.img_width;
img_height = rst{1}.img_height;
face = rst{1}.face;
fprintf('Totally %d faces detected!\n', length(face));

im = imread(img);

logical_map = ones(img_height, img_width, length(face));
in = cell(length(face), 1);
for i = 1 : length(face)
    in_cell{i} = zeros(img_width * img_height, 1);
end
res_in = zeros(img_width * img_height, 1);
x = zeros(83, length(face));
y = zeros(83, length(face));
[yy,xx] = meshgrid(1 : img_height, 1 : img_width);
yy = reshape(yy, [size(yy,1) * size(yy,2), 1]);
xx = reshape(xx, [size(xx,1) * size(xx,2), 1]);

for i = 1 : length(face)
    % Draw face rectangle on the image
    face_i = face{i};
%     center = face_i.position.center;
%     w = face_i.position.width / 100 * img_width;
%     h = face_i.position.height / 100 * img_height;
%     rectangle('Position', ...
%         [center.x * img_width / 100 -  w/2, center.y * img_height / 100 - h/2, w, h], ...
%         'Curvature', 0.4, 'LineWidth',2, 'EdgeColor', color(i));
    
    % Detect facial key points
    rst2 = api.landmark(face_i.face_id, '83p');
    landmark_points = rst2{1}.result{1}.landmark;
    landmark_names = fieldnames(landmark_points);
    for k = 1:83
        temp = landmark_points.(landmark_names{k});
        x(k,i) = temp.x;
        y(k,i) = temp.y;
    end
    k = convhull(x(:,i), y(:,i));
%     h = plot(x(k)*img_width/100,y(k)*img_height/100,'r-');
%     set(h,{'LineWidth'},{3});
    in = inpolygon(xx, yy, x(k,i) * img_width / 100, y(k,i) * img_height / 100);
    in_cell{i} = in;
%     plot(xx(~in),yy(~in),'k.') % points outside
%     min_x = min(x);min_y = min(y);
%     max_x = max(x);max_y = max(y);
%     width = max_x-min_x;height = max_y - min_y;
%     rectangle('Position', ...
%     [min_x*img_width/100,min_y*img_height/100,width*img_width/100,height*img_height/100], ...
%     'LineWidth',2, 'EdgeColor', 'blue');
    x(:, i) = x(:, i) * img_width / 100;
    y(:, i) = y(:, i) * img_height / 100;
    % Draw facial key points
%     for j = 1 : length(landmark_names)
%         pt = getfield(landmark_points, landmark_names{j});
%         scatter(pt.x * img_width / 100, pt.y * img_height / 100, 'g.');
%     end
end
for i = 1 : length(face)
    temp_map = in_cell{i};
    for j = 1 : length(temp_map)
        if temp_map(j) == 0
            logical_map(yy(j), xx(j), i) = 0;
        end
    end
end
% for i = 1:length(face)
%     res_in = res_in + in_cell{i};
% end
% res_in = logical(res_in);
% for i = 1:length(res_in)
%     if res_in(i) == 0
%         im(yy(i),xx(i),1) = 0;
%         im(yy(i),xx(i),2) = 0;
%         im(yy(i),xx(i),3) = 0;
%     end
% end
% im = uint8(im);
% logical_map = logical(rgb2gray(im));
% hold off;
% imshow(uint8(im))
end
% imwrite(im,'mod_source.jpg')




