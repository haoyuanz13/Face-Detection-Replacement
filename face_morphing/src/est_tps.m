function [a1,ax,ay,w] = est_tps(ctr_pts, target_value)
%% compute TPS parameters 
nr = size(ctr_pts,1);
%% compute matrix K (nr*nr)
K=zeros(nr,nr);
for i=1:nr,
    for j=1:nr,
        if i==j,
            K(i,j) = 0;         % consider the special case log(0)
        else
            x = abs(ctr_pts(i,1) - ctr_pts(j,1));
            y = abs(ctr_pts(i,2) - ctr_pts(j,2));
            distance_square = x.^2 + y.^2;
            K(i,j) = -(distance_square).*log(distance_square); % use corresponding points from source image
        end
    end
end
P = [ctr_pts ones(nr,1)];       % matrix P (nr*3)
Source_M = [K,P;P',zeros(3,3)]; % marix [K,P;P',0] ((nr+3)*(nr+3))
I = eye(nr+3);
lambda = 0;                  % parameter lambda, usually close to 0
matrixK = pinv(Source_M + lambda.*I);
Parameter = matrixK * [target_value;zeros(3,1)];

% compute the TPS parameters
% target_value is corresponding points from target image
% substitute x/y from intermedia image to compute x/y coordinate in source image  
w = Parameter(1:nr);
ax = Parameter(nr+1);
ay = Parameter(nr+2);
a1 = Parameter(nr+3);
end
