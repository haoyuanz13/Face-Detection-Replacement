# Face Detection and Replacement
The goal of this package is **automatic detection and replacement of faces in videos**. Given a test video, the package can automatically replace a target face. Ideally, it can try to achieve this task in the most stable way possible.       


Introduction
------------
In general, the seamlessly face replacement is a non-trivial process. Here we define some terminologies for a better representation:      
* face(s) in the video **=** target face(s);
* face(s) used for replacement **=** replacement face(s). 

The whole package is extending previously explored concepts such as simple affine, warp, blending, or additional deformity using TPS. You are of course not limited to these and are encouraged to experiment with any other suitable approaches you may ﬁnd.      

**_Note_**: If you are using multiple faces for training, you should match against all of them and use the one that requires the least morphing.


Algorithms
----------
The pipeline of the whole algorithm is straightforward. Below shows the pipeline which I use, and feel free to add any step that makes sense to you.

1. **_Replacement Face(s) Selection_**             
    First, it's necessary to build a model of the replacement face. You can use a single, well aligned photo, or a sequence under diﬀerent poses. 

2. **_Image Feature Extraction_**             
    In order to obtain a better face detection performance in each frame, extracting local features is pretty important. You can refer to some popular used features like HoG, Shape Context features, Haar-like features and Harris Corners. Also, feel free to use some 3rd party libraries for more features.
    
3. **_Target Face Detection and Keypoints Localization_**          
    Attempt to locate instance(s) of faces in the test video using an automated detector. Based on the features extracted in the previous step, combine with some advanced approaches like the Eigen face correlation computation. Here we refer to the 3rd party library [Face ++](https://www.faceplusplus.com.cn/) to help the face detection task.

4. **_Face Warping_**        
    For each instance of the target faces, ﬁnd a deformable image transform that warps the reference face to the detected instance. Apply this transform to the replacement face. An affine warp (use Triangulation mesh and barycentric coordinates) or a TPS warp with low number of keypoints may be appropriate. 

5. **_Face Replacement_**       
     Compute the convex hull of the detected face and the warped replacement face. Replace the convex hull of the detected face with the convex hull of the warped replacement face in the test image. 

6. **_Refinement_**       
    In addition, here are some directions to make the replacement more natrual and smooth.
    * Use Laplacian image blending/Gradient domain **blending** to get a seamless integration of the new face.
    * Find the appearance difference of the detected face to the warped version of the detected face. This colud be a per-pixel additive offset to **compensate for shadowing and lighting** of the target face. Apply this brightnes/color offset to the warped replacement face to achieve a better appearance match.
    * When dealing with videos, you might expect the faces in the video to **move**. Therefore, exploring methods for motion compensation is highly recommended.



Usage
-----
Add the package to your catkin workspace as well as its dependencies, execute 'demo.m' directly.

Package Clarification
---------------------
The package is aimed to detect face region in a image or video, then replace that with our own face automatically.
All srouce and helper codes store in the src folder, for package test, you can use images in the ssource image folder, or you can 
choose your own images with a somehow distinguish face part for better result. 

Result
------
Please feel free to take a look at result folder where stores all generated videos, also the report will show you more algorithm details and analysis.
