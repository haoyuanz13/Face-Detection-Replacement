clear;
close all;
%% read in images from vedio
source_path = 'source_1.jpg';
im1 = imread(source_path);
source = zeros(83, 2);
[~, source(:, 1), source(:, 2)] = facepp_demo(source_path); % extract face and feature points from source image
v = VideoReader('easy2.mp4');
I = read(v, [1, Inf]);
%% implement face detection, morphing and blending for each frame image
for frame = 1 : size(I, 4)
    tic;
    im2 = I(:, :, :, frame);
    path = sprintf('gen/easy2_%d.jpg', frame);   % the folder that used to store new generated frame
    imwrite(im2, path);
    [logical_map, target_x, target_y] = facepp_demo(path);  % exrtact face and feature points from target image 
                                                            % logical_map is a logical mask that face region is 1 and others are 0
    if ~isempty(target_x)
        face_num = size(target_x, 2);  % record the number of detected faces in target image 
        
        % cancel commemnts when you want to do replacement on the video except easy3.mp4
        % if face_num > 1
        %    for i = 1 : face_num
        %        [kk, vv(:, i)] = convhull(target_x(:, i), target_y(:, i)); 
        %    end
        %    [vv, tag] = sort(vv, 'ascend');
        %    target_x(:, 1) = target_x(:, tag(1));
        %    target_y(:, 1) = target_y(:, tag(1));
        %    logical_map(:, :, 1) = logical_map(:, :, tag(1));
        %    face_num = 1;
        % end
        
        for i = 1 : face_num
            target(:, 1, i) = target_x(:, i);
            target(:, 2, i) = target_y(:, i);
        end
        background = zeros(size(im2, 1), size(im2, 2), 3);
        result = cell(face_num, 1);
        for i = 1 : face_num
            morphed_im = morph_tps_wrapper(im1, im2, source, target(:,:,i)); % face morphing 
            morphed_im = uint8(morphed_im);
            sourceImg = double(morphed_im);
            targetImg = double(im2);
            resultImg = seamlessCloningPoisson(sourceImg, targetImg, logical_map(:,:,i), 0, 0); % face blending 
            resultImg = uint8(resultImg);
            result{i} = resultImg;
        end
        %%extract blended face out of target image
        for i = 1 : face_num
            img = result{i};
            img(:, :, 1) = img(:, :, 1) .* uint8(logical_map(:, :, i));
            img(:, :, 2) = img(:, :, 2) .* uint8(logical_map(:, :, i));
            img(:, :, 3) = img(:, :, 3) .* uint8(logical_map(:, :, i));
            res{i} = img;
        end
        %%reverse image mask and set non - face region as logical 1
        overall_map = logical_map(:, :, 1);
        for i = 2 : face_num
            overall_map = overall_map + logical_map(:, :, i);
        end
        overall_map = logical(overall_map);
        overall_map = 1 - overall_map;
        
        %%extract non - face region from target image
        temp_img = result{1};
        for i = 1 : 3
            img(:, :, i) = uint8(overall_map) .* temp_img(:, :, i);
        end
        %%pad blended image in background
        for i = 1 : face_num
            img = img + res{i};
        end
        path = sprintf('gen/easy2_%d.jpg',frame);   % store generated frames in target folder 
        imwrite(img, path);
    end
    toc;
end
%% create video based on all blended images
vidObj = VideoWriter('easy2_out.mp4');
vidObj.FrameRate = 30;
open(vidObj);
for i = 1 : size(I, 4)
    path = sprintf('gen/easy2_%d.jpg', i);
    img = imread(path);
    writeVideo(vidObj, img);
end
close(vidObj);