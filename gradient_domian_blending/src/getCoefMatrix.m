function coefM = getCoefMatrix(indexes)
%% compute coordinates of replacement pixels in target image
replace = find(indexes' > 0);
n = length(replace);
coefM = 4 .* eye(n, n);

row = size(indexes', 1);
coor = zeros(n, 2);
coor(:, 1) = floor(replace ./ row);
coor(:, 2) = replace - coor(:, 1) .* row;
coor(:, 1) = coor(:, 1) + 1;

%% find its neighbors that locate in replacement region
% set the coefficient of neighbors that within replacement region to -1.
% represents neighbors are unknown variables.
for i = 1: n
    indr_i = coor(i, 1);
    indc_i = coor(i, 2);
    
    % four neighbors Np
    nei = zeros(4, 2);
    nei(1, :) = [indr_i - 1, indc_i];
    nei(2, :) = [indr_i + 1, indc_i];
    nei(3, :) = [indr_i, indc_i - 1];
    nei(4, :) = [indr_i, indc_i + 1];
    
    for k = 1: 4
        if (nei(k, 1) == 0 || nei(k, 1) > size(indexes, 1))
            continue;
        elseif (nei(k, 2) == 0 || nei(k, 2) > size(indexes, 2))
            continue;
        elseif (indexes(nei(k, 1), nei(k, 2)) == 0)
            continue;
        else
            coefM(i, indexes(nei(k, 1), nei(k, 2))) = -1; % if neighbor locates in replacement region then set its coefficient to -1.
        end
    end    
end

coefM = sparse(coefM);
end
