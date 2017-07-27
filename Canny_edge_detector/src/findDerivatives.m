function [J, theta, Jx, Jy] = findDerivatives(I, Gx, Gy)
%% Compute derivative along X and Y side
dx=[1,0,-1];
dy=[1,0,-1]';
Gx=conv2(Gx,dx,'same');
Gy=conv2(Gy,dy,'same');
%% Compute the gradient of image 
double(I);
double(Gx);
double(Gy);
Jx=conv2(I,Gx,'same');
Jy=conv2(I,Gy,'same');
[theta,J]=cart2pol(Jx,Jy);
end
