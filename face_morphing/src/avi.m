im1 = (imread('imzhy.png'));
im2 = (imread('imsd.png'));
do_trig =0;
if do_trig
    fname = 'Project2_trig.avi';
else
    fname = 'Project2_tps.avi';
end

try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 10;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',10);
end
%%
% Morph iteration
 for w=0:0.016:1
    if (do_trig == 0)
      img_morphed = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, w, w);
    else
      img_morphed = morph(im1, im2, im1_pts, im2_pts, w, w);
    end
    % if image type is double, modify the following line accordingly if necessary
    imagesc(img_morphed);
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
 end
try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end