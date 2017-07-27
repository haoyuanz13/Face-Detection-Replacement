# Face_Detection_Replacement
The package includes several fundamental image processing tools such as Edge detection, image morphing. 
Based on those computer vision tools, completed a package that can detect and replace face automatically in image or videos.

Feature detection tools
-----
The package *canny_edge_detector* and *automatic_2Dimage_mosaic* play roles as feature detection, construction and matching tools that will be 
used in the face detection part, and combine with Eigen face and GMM model of human skin color, improves the detection accuracy.

Face replacement tools
----------------------
The package *face_morphing* and *gradient_domian_blending* provide the basic structure of face replacement algorithm that make the 
face replacement more smoothly and well-look.
