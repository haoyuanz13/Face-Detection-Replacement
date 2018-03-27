# Face Detection & Replacement
The package includes several fundamental and traditonal image processing tools **(without any deep learning method)**, including the Canny Edge detection, Image morphing and Image mosaicing. 
Based on those computer vision tools, completed a package that can detect and replace faces automatically in image or videos.

Feature detection tools
-----
Feature plays an important role in the object (e.g, face region) detection. Here, we implemented three base algorithms playing with several type of features (e.g. edge, corner) and achieved some contributions.    
* _**Canny edge detector**_    
  Detect and extract edge information for images, finally succeed to build corresponding Canny Edge Image.
  
* _**Automatic 2Dimage mosaic**_       
  Construct a panorama given several images that have some common regions along with detected SIFT features for the image stitching.

Those above sub-packages play roles as feature detection, construction and matching tools that will be 
used in the major face detection section, then combine with the built Eigen face and GMM model of human skin color, improves the detection performance.

Face replacement tools
----------------------

* _**Face Morphing**_      
  Achieved face warping given two different faces with detected correspondences, using _Delaunay Triangulation_ and _TPS(Thin-Plate Spline)_ algorithms.
The package *face_morphing* and *gradient_domian_blending* provide the basic structure of face replacement algorithm that make the 
face replacement more smoothly and well-look.
