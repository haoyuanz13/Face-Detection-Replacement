%%*****************************************
%% Mikel Rodriguez {mikel at cs dot ucf dot edu}          *
%% Lucas and Kanade's Optical flow                              *
%%*****************************************

%% the basic idea is to solve Ax = b
clear;
gaus_sigma = 1; 
%%Image Variables:
 
%%I precompute the priramyds using my code from the previous assignment
ORIGINAL_IMAGE_1 = imread('tt0.png');
ORIGINAL_IMAGE_2 = imread('tt1.png');
 
ORIGINAL_IMAGE_1 = rgb2gray(ORIGINAL_IMAGE_1);
ORIGINAL_IMAGE_2 = rgb2gray(ORIGINAL_IMAGE_2);

[height, width] = size(ORIGINAL_IMAGE_1);
ORIGINAL_IMAGE_1 = im2double(ORIGINAL_IMAGE_1);      
ORIGINAL_IMAGE_2 = im2double(ORIGINAL_IMAGE_2);           
IMAGE_1_SMOOTHED = zeros(height, width);             
IMAGE_2_SMOOTHED = zeros(height, width);
 
%%Derivate Variables:
 
Dx_1 = zeros(height, width);             
Dy_1 = zeros(height, width);             
Dx_2 = zeros(height, width);             
Dy_2 = zeros(height, width);             
Ix = zeros(height, width);              
Iy = zeros(height, width);     
It = zeros(height, width);
 
 
%% Optical flow variables
neighborhood_size = 5;                     
A = zeros(2, 2);             
B = zeros(2, 1);  
output1 = zeros(height, width);         
output2 = zeros(height, width);
 
%% Kernel Variables:
Kernel_Size = 6 * gaus_sigma + 1;         
k = (Kernel_Size - 1) / 2;          
gaus_kernel_x = zeros(Kernel_Size, Kernel_Size);
gaus_kernel_y = zeros(Kernel_Size, Kernel_Size);
kernel = zeros(Kernel_Size, Kernel_Size);
 
% Make a kernel for partial derivatve of gaussian with respect to x (for computing Dx)
for i = 1 : Kernel_Size
    for j = 1 : Kernel_Size
        gaus_kernel_x(i, j) = -( (j - k - 1) / ( 2 * pi * gaus_sigma^3 ) ) * exp ( - ( (i - k - 1)^2 + (j - k - 1)^2 ) / ( 2 * gaus_sigma^2 ) );
    end
end
 
%Make a kernel for partial derivatve of gaussian with respect to y (for computing Dy)
for i = 1 : Kernel_Size
    for j = 1 : Kernel_Size
        gaus_kernel_y(i, j) = -( (i - k - 1) / ( 2 * pi * gaus_sigma^3 ) ) * exp ( - ( (i - k - 1)^2 + (j - k - 1)^2 ) / ( 2 * gaus_sigma^2 ) );
    end
end
 
%%Compute x and y derivates for both images:
Dx_1 = filter2(gaus_kernel_x, ORIGINAL_IMAGE_1);
Dy_1 = filter2(gaus_kernel_y, ORIGINAL_IMAGE_1);
Dx_2 = filter2(gaus_kernel_x, ORIGINAL_IMAGE_2);
Dy_2 = filter2(gaus_kernel_y, ORIGINAL_IMAGE_2);
 
Ix = (Dx_1 + Dx_2) / 2;
Iy = (Dy_1 + Dy_2) / 2;
 
%%Build a gaussian kernel to smooth images for computing It
for i = 1 : Kernel_Size
    for j = 1 : Kernel_Size
        kernel(i, j) = ( 1 / (2 * pi * (gaus_sigma^2)) ) * exp ( -((i - k - 1)^2 + (j - k - 1)^2) / (2 * gaus_sigma^2) );
    end
end
 
 
IMAGE_1_SMOOTHED = filter2(kernel, ORIGINAL_IMAGE_1);
IMAGE_2_SMOOTHED = filter2(kernel, ORIGINAL_IMAGE_2);
 
It = IMAGE_2_SMOOTHED - IMAGE_1_SMOOTHED;
 
  
for i = (1 + floor(neighborhood_size / 2)) : (height - floor(neighborhood_size / 2))
    for j = (1 + floor(neighborhood_size / 2)) : (width - floor(neighborhood_size / 2))

        A = zeros(2, 2);
        B = zeros(2, 1);
        
        %% count all pixels in the window
        for m = i - floor(neighborhood_size / 2) : i + floor(neighborhood_size / 2)
            for n = j - floor(neighborhood_size / 2) : j + floor(neighborhood_size / 2)
                
                A(1, 1) = A(1, 1) + Ix(m, n) * Ix(m, n);
                A(1, 2) = A(1, 2) + Ix(m, n) * Iy(m, n);
                A(2, 1) = A(2, 1) + Ix(m, n) * Iy(m, n);
                A(2, 2) = A(2, 2) + Iy(m, n) * Iy(m, n);
  
                B(1, 1) = B(1, 1) + Ix(m, n) * It(m, n);
                B(2, 1) = B(2, 1) + Iy(m, n) * It(m, n);
               
            end
        end
       
        Ainv = pinv(A); %%Pseudo inverse
        result = Ainv * (-B);
        output1(i, j) = result(1, 1);
        output2(i, j) = result(2, 1);
       
    end
end
 
output1 = flipud(output1); % Flip matrix in up/down direction
output2 = flipud(output2); % Same
quiver(output1, output2); %plot optical flow vectors as arrows