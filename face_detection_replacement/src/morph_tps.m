function morphed_im = morph_tps(im_source,im_target, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y,w_y, ctr_pts, sz)
morphed_im = zeros(sz(1), sz(2), 3);
result1 = zeros(sz(1), sz(2));
result2 = zeros(sz(1), sz(2));
source_sz(1) = size(im_source, 1);
source_sz(2) = size(im_source, 2);
for i=1 : sz(1)
    for j=1 : sz(2)
%         temp = im_target(i,j,:);
%         temp = reshape(temp,[3,1]);
%         if any(temp~=0)
            for k = 1 : size(ctr_pts,1)
                r = (ctr_pts(k, 1) - j) ^ 2 + (ctr_pts(k, 2) - i) ^ 2 + eps;
                result1(i, j) = result1(i, j) - w_x(k) * r * log(r);
                result2(i, j) = result2(i, j) - w_y(k) * r * log(r);
            end
            result1(i, j) = round(result1(i, j) + a1_x + ax_x * j + ay_x * i);
            result2(i, j) = round(result2(i, j) + a1_y + ax_y * j + ay_y * i); 
            if result1(i, j) > source_sz(2)
                result1(i, j) = source_sz(2);
            end
            if result2(i, j) > source_sz(1)
                result2(i, j) = source_sz(1);
            end
            if result1(i, j) < 1
                result1(i, j) = 1;
            end
            if result2(i, j) < 1
                result2(i, j) = 1;
            end
            morphed_im(i, j, :) = im_source(result2(i, j), result1(i, j), :);
%         end
    end
end
% for i=1:sz(1)
%     for j=1:sz(2)
%             end
% end
end