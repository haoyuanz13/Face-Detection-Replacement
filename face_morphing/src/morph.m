function [morphed_im] =morph(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
%%
% for each pixel, use 'tsearchn' to known which triangular it falls in
% then compute the barycentric coordinate[alfa, beita, gama] for each pixel in that triangular
% compute corresponding pixel in the source image by its [alfa, beita, gama].
% using barycentric coordiante equation.1
% then interpolate value for (x,y) or just round it.
% interpolation parameters principle when doing the reverse.
%% keep two source images into the same size if necessary
[nr_1,nc_1,x_1] = size(im1);
[nr_2,nc_2,x_2] = size(im2);
im1_pts = flip(im1_pts,2);
im2_pts = flip(im2_pts,2);
rate = 1;
if (nr_1<=nr_2) && (nc_1<=nc_2)
    im1 = padarray(im1,[nr_2-nr_1, nc_2-nc_1],'post');
else
    rate = min((nr_2/nr_1),(nc_2/nc_1));
    im1 = imresize(im1,rate);
    [nr_1,nc_1,x_1] = size(im1);
    im1 = padarray(im1,[nr_2-nr_1,nc_2-nc_1],'post');
end
im1_pts = floor(im1_pts.* rate);
%%
M = length(warp_frac);
morphed_im = cell(M,1);
for k =1:M,
    morphed_ims = 0.0*im1+0.0*im2;
    [nr,nc,x] = size(morphed_ims); 
    %% create an intermediate shape
    im_inter = (1-warp_frac(k)).*im1_pts + warp_frac(k).*im2_pts;  %warp_frac bigger, morphed image looks more similar with im2. 
    [x,y] = meshgrid(1:nr,1:nc);
    xi = [x(:) y(:)];                           %store pixels' position
    pixel_total = size(xi,1);

    tri=delaunay(im2_pts(:,1),im2_pts(:,2));   % construct triangular 
    index_Tri = tsearchn(im_inter,tri,xi);     % find the triangle every pixel locates in.
    index_Tri(isnan(index_Tri)) = -1;   
    %% get barycentric coordinate
    % using reverse warp to find corresponding pixels in source images
    xi_source = zeros(pixel_total,4);  %store pixel location in source images
    for i = 1:pixel_total,
        if index_Tri(i)>0,
            vertex = tri(index_Tri(i),:);   % get three vertexs of the triangle the pixel in
            a = im_inter(vertex(1),:);
            b = im_inter(vertex(2),:);
            c = im_inter(vertex(3),:);
    
            matrix_co = [a(1),b(1),c(1);a(2),b(2),c(2);1,1,1];  %construct barycentric equation
            matrix_pixel = [xi(i,1);xi(i,2);1];   
            barycen_co = pinv(matrix_co)*(matrix_pixel);    % barycentric equation to get barycentric coordinate of the i pixel
    
            a1 = im1_pts(vertex(1),:);   % get three vertexs in img1
            b1 = im1_pts(vertex(2),:);
            c1 = im1_pts(vertex(3),:);    
            matrix_co1 = [a1(1),b1(1),c1(1);a1(2),b1(2),c1(2);1,1,1];
            location_1 = matrix_co1*barycen_co;  %ultilize barycentric equation to get corresponding pixel in img1
            xi_source(i,1:2) = [location_1(1)/location_1(3),location_1(2)/location_1(3)];
    
            a2 = im2_pts(vertex(1),:);  % get three vertexs in img2
            b2 = im2_pts(vertex(2),:);
            c2 = im2_pts(vertex(3),:);    
            matrix_co2 = [a2(1),b2(1),c2(1);a2(2),b2(2),c2(2);1,1,1];
            location_2 = matrix_co2*barycen_co;
            xi_source(i,3:4) = [location_2(1)/location_2(3),location_2(2)/location_2(3)];
        else
            xi_source(i,:) = [-1,-1,-1,-1];
        end
    end
    %% interpolate values and color dissolve
    % round pixels to make sure all points have own value rather than holes
    xi_source = round(xi_source);
    xi_source(xi_source==0)=1;
    x_1 = xi_source(:,1);
    x_1(x_1>nr_1) = nr_1;

    y_1 = xi_source(:,2);
    y_1(y_1>nc_1) = nc_1;

    x_2 = xi_source(:,3);
    x_2(x_2>nr_2) = nr_2;

    y_2 = xi_source(:,4);
    y_2(y_2>nc_2) = nc_2;
    
    for i =1:pixel_total,
        if xi_source(i,1)>0,
            morphed_ims(xi(i,1),xi(i,2),:) = (1-dissolve_frac(k)).*im1(x_1(i),y_1(i),:)...
                +dissolve_frac(k).*im2(x_2(i),y_2(i),:);
        end
    end
    morphed_im{k} = morphed_ims;
end
end
