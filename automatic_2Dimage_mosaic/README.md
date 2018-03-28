# Automatic 2D Image Mosaic
This package focuses on the image feature detection, feature matching and image mosaic techniques. The goal is to create an image mosaic or stitching, which is a collection of small images which are aligned properly to create one larger image.        

The main algorithm follows the below two papers:         
[1) Multi-image Matching using Multi-scale image patches; ](http://ieeexplore.ieee.org/xpls/icp.jsp?arnumber=1467310)      
[2) Shape Matching and Object Recognition Using Shape Contexts.](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.441.6897&rep=rep1&type=pdf)


Data
----
A image pool which contains at least two images, all images should have some common region with at least one other image in the dataset such that can be detected enough correspondences. In addition, when you captrue images by yourself, it's better to limit the camera motion to purely translational, or purely rotational (around the camera center).        

A demo dataset is stored in the folder **_source_imgs_**.


Algorithms
----------
The brief algorithm pipeline shows below, or feel free to check the folder **_reference_** for detailed explanations.       
1. **_Automatic Correspondences Detection_**        
    1. _Detect corner features_: use Harris corner detector as feature.     
    2. _Adaptive NMS_: the adaptive Non-Maximal Suppression to make uniform feature distribution.
    3. _Descriptor Construction_: build a feature descriptor for each feature point (e.g. oriented window box)
    4. _Feature Matching_: use _k_d tree_ and _SSD_ computation to match the best correspondences.

2. **_RANSAC_**         
Apply RANSAC to estimate an optimal homography between two images. Typically, use the min number _4_ pairs to estimate an initial homography and then use all correspondences to vote. Finally, use all inliers to estimate a new optimal homography.

3. **_Image Mosaic_**        
Produce a mosaic by overlaying the pairwise aligned images to create the ﬁnal mosaic image. Also, check Matlab functions, e.g imtransform and imwarp. If you want to implement imwarp (or similar function) by yourself, you should apply bilinear interpolation when you copy pixel values. Also, the implementation of _smooth image blending_ is recommended.


Execution
---------
All source code are stored in the folder **_src_**. The **_mosaic_main.m_** is the main demo file, also welcome to select your own images to build a panorama.


Results
-------
All results are stored in the folder **_result_**, below shows a simple demo:
**_Source Images_**
<p >
  <img src = "./source_imgs/imm1.jpg?raw=true" width="300" height="400">
  <img src = "./source_imgs/imm2.jpg?raw=true" width="300" height="400">
  <img src = "./source_imgs/imm3.jpg?raw=true" width="300" height="400">
</p>
