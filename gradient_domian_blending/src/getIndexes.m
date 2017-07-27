function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
indexes = zeros(targetH, targetW);
nr_mask = size(mask', 1);  % make index ascend in row direction
index_source = find(mask' == 1);

%% compute pixels' coordinates within replacement region
% mask is transposed so computed column index is the row index in original
% image, same for computed row index.
indr_source = floor(index_source ./ nr_mask);
indc_source = index_source - indr_source .* nr_mask;
indr_source = indr_source + 1;

%new_ori_r = min(indr_source) - 1;
%new_ori_c = min(indc_source) - 1;


%% add offset and get coordiantes in target image
ind_target = [indr_source + offsetY, indc_source + offsetX]; 

for ind = 1: length(index_source)    
    indexes(ind_target(ind, 1), ind_target(ind, 2)) = ind;
end

end
