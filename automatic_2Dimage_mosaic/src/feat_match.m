% descs1 is a 64x(n1) matrix of double values
% descs2 is a 64x(n2) matrix of double values
% match is n1x1 vector of integers where m(i) points to the index of the
% descriptor in p2 that matches with the descriptor p1(:,i).
% If no match is found, m(i) = -1
function [match] = feat_match(descs1, descs2)
n1 = size(descs1, 2);
match = zeros(n1, 1);

for i = 1:n1;
    SSD = (bsxfun(@minus, descs2, descs1(:, i))).^2;
    SSD = sum(SSD);
    [nn_1,index1] = min(SSD);
    nn_2 = min(SSD([1:(index1 - 1), (index1 + 1):end]));
    
    if nn_1/nn_2 <= 0.6
        if any(match == index1)
            match(i) = -1;
        else
            match(i) = index1;
        end
    else
        match(i) = -1;
    end        
end