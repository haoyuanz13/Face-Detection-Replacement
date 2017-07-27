function solVector = getSolutionVect(indexes, source, target, offsetX, offsetY)
%% compute coordinates of replacement pixels in target image
replace = find(indexes' > 0);
n = length(replace);

row = size(indexes', 1);
coor = zeros(n, 2);
coor(:, 1) = floor(replace ./ row);
coor(:, 2) = replace - coor(:, 1) .* row;
coor(:, 1) = coor(:, 1) + 1;

%% compute neighbors in target image that locate outside replacement region
% those neighbors are treated as known parameters 
target_b = zeros(n, 1);
for i = 1: n
    indr_i = coor(i, 1);
    indc_i = coor(i, 2);
    
    nei = zeros(4, 2);
    nei(1, :) = [indr_i - 1, indc_i];
    nei(2, :) = [indr_i + 1, indc_i];
    nei(3, :) = [indr_i, indc_i - 1];
    nei(4, :) = [indr_i, indc_i + 1];
    
    sum = 0;
    for k = 1: 4
        if (nei(k, 1) == 0 || nei(k, 1) > size(indexes, 1))  % pad neighbors that out of range value 0 
            continue;
        elseif (nei(k, 2) == 0 || nei(k, 2) > size(indexes, 2))
            continue;
        elseif (indexes(nei(k, 1), nei(k, 2)) == 0)
            sum = sum + target(nei(k, 1), nei(k, 2)); % move known neighbors to the right side of equation 
        end
    end
    target_b(i) = sum;    
end  

%% compute vector value in source image
% all pixels in source image are known parameters 
coor_source = [coor(:, 1) - offsetY, coor(:, 2) - offsetX];
source_b = zeros(n, 1);

for i = 1: n
    indr_i = coor_source(i, 1);
    indc_i = coor_source(i, 2);
    
    nei = zeros(4, 2);
    nei(1, :) = [indr_i - 1, indc_i];
    nei(2, :) = [indr_i + 1, indc_i];
    nei(3, :) = [indr_i, indc_i - 1];
    nei(4, :) = [indr_i, indc_i + 1];
    
    sum = 0;
    for k = 1: 4
        if (nei(k, 1) == 0 || nei(k, 1) > size(indexes, 1))
            continue;
        elseif (nei(k, 2) == 0 || nei(k, 2) > size(indexes, 2))
            continue;
        else
            sum = sum + source(nei(k, 1), nei(k, 2));
        end        
    end
    source_b(i) = 4 * source(indr_i, indc_i) - sum;
end

%% solution vector
solVector = target_b + source_b;

end