# Canny Edge Detector
The package is aimed to compute the Canny Edges for any RGB images. Theoretically, edge can be a good feauture of object detection in the computer vision realm.

Data
----
All data are raw RGB images, stored in the folder **_train_images_**. 


Algorithms
----------
The main algorithm is pretty straightforward, below shows a brief pipeline, and you can check the folder **_reference_** for detailed explanation.

1. For each image, convert it into greyspace. 
2. Use designed Gaussain kernel to calculate its corresponding gradient map (including magnitude and orientation) and make features more robust.
3. Traverse interested pixels (larger than some threshold), find local maximum as candidates and suppress its neighbors (Non-Max-Suppression).
4. Edge Linking using high and low thresholds, also check whether its gradient orientation keeps consistent with possible neighbor candidates. Also using the _line segment_ algorithm to make edge more smooth.


Execution
---------
All source code store in the folder **_src_**, in addition, the folder **_edgeEval_** stores the ground truth edge detector codes to evaluate the performance of the designed Canny Edge detector. 
* _cannyEdge.m_: the demo file which can generate a canny edge detection image given any RGB image. 
* _TestScript_P1.m_: test the accuracy of algorithm.

**_Note:_** there is a Python version of the similar algorithm, stored in the folder **_Python Version_**.

Results
-------
All results are stored in the folder **_results_**, directory **_Python Version/resHard_** and **_Python Version/resEasy_**, please feel free to take a look at them. Below show some demo obatined results.

<div align=center>
  <img width="800" height="400" src="./Python Version/resHard/figure_5.png", alt="demo1"/>
</div>

<div align=center>
  <img width="800" height="400" src="./Python Version/resEasy/figure_15.png", alt="demo2"/>
</div>

<div align=center>
  <img width="800" height="400" src="./Python Version/resEasy/figure_13.png", alt="demo3"/>
</div>
