function  morphed_im = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz)
morphed_im = uint8(zeros(sz(1),sz(2),3));
nr = size(ctr_pts,1);
%% compute locations of corresponding points in source image
%%according to the TPS equation
position = zeros(sz(1).*sz(2),2); % all pixels in target image
i = 1;
for x =1:sz(1)
    for y = 1:sz(2)
        Position_inter = repmat([x,y],nr,1);
        distance_matrix = (abs(ctr_pts - Position_inter)).^2;
        dis_square = distance_matrix(:,1) + distance_matrix(:,2);
        U = -(dis_square).*log(dis_square);
        U(isnan(U))=0;
            % use different parameters to compute x or y coordinate
        position_x = a1_x + ax_x.*x + ay_x.*y + w_x'* U;
        position_y = a1_y + ax_y.*x + ay_y.*y + w_y'* U;
        position(i,:) = [position_x, position_y];
        i = i+1;
            % store corresponding points in source image
    end
end
%% round value for corresponding points
position = round(position);
[nr_source, nc_source, x] = size(im_source);

position(position<=0)=1;
x_source = position(:,1);
y_source = position(:,2);

x_source(x_source>nr_source) = nr_source;
y_source(y_source>nc_source) = nc_source;
%% get values from source image
i = 1;
for x = 1:sz(1)
    for y = 1:sz(2)
        morphed_im(x,y,:) = im_source(x_source(i), y_source(i),:);
        i = i+1;
    end
end
end