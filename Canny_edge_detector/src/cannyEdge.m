 function E = cannyEdge(I)
%% Canny edge detector
%  Input: A color image I = uint8(X, Y, 3), where X, Y are two dimensions of the image
%  Output: An edge map E = logical(X, Y)
%%  To DO: Write three functions findDerivatives, nonMaxSup, and edgeLink to fulfill the Canny edge detector.

%% Convert the color image to gray scale image
%  Output I = uint8(X, Y)
try
    I = rgb2gray(I);
catch
end

%% Construct 2D Gaussian filter
Gx = normpdf([-5:1:5], 0, 1);
Gy = normpdf([-5:1:5], 0, 1)';

%% Compute magnitutde and orientation of derivatives
%  J = double(X, Y), the magnitude of derivatives
%  theta = double(X, Y), the orientation of derivatives
%  Jx = double(X, Y), the magnitude of derivatives along x-axis
%  Jy = double(X, Y), the magnitude of derivatives along y-axis
[J, theta, Jx, Jy] = findDerivatives(I, Gx, Gy);

visDerivatives(I, J, Jx, Jy);


%% Detect local maximum
%  M = logical(X, Y), the edge map after non-maximal suppression
M = nonMaxSup(J, theta);
figure; imagesc(M); colormap(gray);

%% Link edges
%  E = logical(X, Y), the final edge map
E = edgeLink(M, J, theta);
figure; imagesc(E); colormap(gray);
E = logical(E);

end
