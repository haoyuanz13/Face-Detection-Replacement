function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
%% compute coordinates of replacement pixels in target image
replace = find(indexes' > 0);
n = length(replace);

row = size(indexes', 1);
coor = zeros(n, 2);
coor(:, 1) = floor(replace ./ row);
coor(:, 2) = replace - coor(:, 1) .* row;
coor(:, 1) = coor(:, 1) + 1;
%% interpolate RGB values in reconstruct image
resultImg = targetImg;
for i = 1: n
    indr_i = coor(i, 1);
    indc_i = coor(i, 2);    
    resultImg(indr_i, indc_i, 1) = red(i);
    resultImg(indr_i, indc_i, 2) = green(i);
    resultImg(indr_i, indc_i, 3) = blue(i);
end
resultImg = uint8(resultImg); % transfer image from double type to uint8
end