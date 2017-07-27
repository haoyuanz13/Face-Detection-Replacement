function [a1,ax,ay,w] = est_tps(ctr_pts, target_value)
num_pts=size(ctr_pts,1);
w=zeros(1,num_pts);
lambda=eps;
for i=1:num_pts
    for j=1:num_pts
        if i==j
            K(i,j)=0;
        else
            r=(ctr_pts(i,1)-ctr_pts(j,1))^2+(ctr_pts(i,2)-ctr_pts(j,2))^2;
            K(i,j)=-r*log(r);
        end
    end
end
P=[ctr_pts,ones(num_pts,1)];
param=([K,P;P',zeros(3)]+lambda*eye(num_pts+3))\[target_value;zeros(3,1)];
w=param(1:num_pts);
ax=param(num_pts+1);
ay=param(num_pts+2);
a1=param(num_pts+3);
end