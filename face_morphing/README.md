# Image Warping and Face Morphing
The package focuses on **_image morphing_** techniques. We produced a “morph” animation of one face into another person’s face. Finally, we generate around 60 frames of animation.


Introduction
------------
A morph is a simultaneous warp of the image shape and a cross-dissolve of the image colors. The cross-dissolve is the easy part; controlling and doing the warp is the hard part. The warp is controlled by deﬁning a correspondence between the two pictures, either by automatical detection or hand-labeled by human. The correspondence should map eyes to eyes, mouth to mouth, chin to chin, ears to ears, etc., to get the smoothest transformations possible.


Algorithms
----------
In terms of warping, two methods are well-popular used, _Forward Warping_ and _Inverse Warping_. Actually, the latter one is more recommended since the the inverse warping can eliminate black holes in the generated image.      

Theoretically, the warping process can be decomposed into two sub-sections: 1) shape warping; 2) color cross-dissolve. For the shape warping, there are two typical approaches:
* **_Triangulation Warping_**    
  Base on correspondences to build a _delaunay triangular mesh_, and use the _barycentric coordinates consistent_ property to obtain the original positions for each pixel in the intermediate image.
  
* **_Thin-Plate Spline (TPS)_**   
  Base on the correspondences in two images (source and target), compute corresponding _TPS parameters_ to obtain x and y coordinate for each pixel in the intermediate image.

The color cross-dissolve is more straightforward, just set a weight factor between source and target image which plays a role as the color proportion of one image to another. Feel free to check the folder **_reference_** for more detailed algorithm explanantions.


Execution
---------
All source codes are stored in the folder **_src_**.
* **_Tria_main.m_**: the main code to implement the Triangulation warping algorithm for face morphing.
* **_tps_main.m_**: the main code to implement the TPS algorithm for face morphing. 
* **_avi.m_**: generated a video to show the morphing process.


Results
-------
All result videos are stored in the folder **_results_**. Each video shows a face morphing process, starts from the initail face image to the terminal face. Alternatively, you can try different objects for more funny results.       

Below shows a test morphing resuts using a triangular mesh. All intermediate images are obtained via either TPS or Triangulation method.
<div align=center>
  <img width="400" height="400" src="./results/eval_test.gif", alt="demo1"/>
</div>
