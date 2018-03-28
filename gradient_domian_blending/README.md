# Gradient Domain Blending
This package implement the gradient domain blending algorithm. The goal is seamlessly blend two images together automatically given the blending region.      

The algorithm was described in the paper: [Poisson Image Editing, Patrick, Michel and Andrew](https://www.cs.virginia.edu/~connelly/class/2014/comp_photo/proj2/poisson.pdf).


Algorithms
----------
Deﬁne the image we’re changing as the **target image**, the image we’re cutting out and pasting as the **source image**, the pixels in target image that will be blended with source image as the **replacement pixels**.        

The key idea of the gradient domain blending is to apply the gradient of the source image to the target image’s replacement pixels, but keep other pixels. Below is a brief pipeline and feel free to look at a more detailed explanations in the directory **_reference/review.pdf_**.

1. **_Align Images and Create Mask_**       
    1. Use the image editor to adjust the source image size and position, make sure that the region of the target image you want to replace is well aligned with the source image. 
    2. Save the resized source image and its top left corner in the target image coordinate as the oﬀset. For the following steps, the source image refers to the resized source image.      

2. **_Index Pixel_**        
The replacement pixels’ intensity are solved by the linear system **_Ax = b_**. But, not all the pixels in target image need to be computed. Only the pixels mask as **1** in the mask image will be used to blend. In order to reduce the number of calculations, you need to index the replacement pixels so that each element in the **_unknown variable x_** represents one replacement pixel.      

3. **_Compute Coefficient Matrix A and Solution Vector b_**      
Generate the coefficient matrix **_A_** in the linear system **_Ax = b_**. Notices that the coefficient matrix size is **_N by N_**, where N is the number of replacement pixels. To reduce the memory of this matrix, a **_sparse matrix_** is recommended. Also generate the solution vector **_b_** in order to solve **_x_**.    

4. **_Reconstruct Image_**        
After solving the linear system **_Ax = b_** and compute the vector **_x_**, then change the solution to the replacement pixels’ intensity and reconstruct the blending image.


Execution
---------
All source codes are stored in the folder **_src_**.
* **_blendingMain.m_**: the main demo file.
* **maskImage.m_**: create a mask and determine the replacement region.
* **_getIndexes.m_**: obtain the repalcement region indexs.
* **_getCoefMatrix.m_**: generate the coefficient matrix A.
* **_getSolutionVec.m_**: generate the solution vector b.
* **_reconstructImg.m_**: reconstruct images after obtaining the vector x.
* **_seamlessCloningPoisson.m_**: the wrapper function and the demo script.


Results
-------
All resuluts are stored in the folder **_result_**. Below show two simple results.

**_Result 1_**

<p >
  <img src = "./result/im_source_1.png?raw=true" width="283" height="283">
  <img src = "./result/im_target_1.jpg?raw=true" width="500" height="320">
</p>


<div align=center>
  <img width="600" height="300" src="./result/panorama.png", alt="panorama"/>
</div>

