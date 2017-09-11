'''
  File name: cannyEdge.py
  Author: Haoyuan(Steve) Zhang
  Date created: 9/10/2017
'''

'''
  File clarification:
    Canny edge detector 
    - Input: A color image I = uint8(X, Y, 3), where X, Y are two dimensions of the image
    - Output: An edge map E = logical(X, Y)

    - TO DO: Complete three main functions findDerivatives, nonMaxSup and edgeLink 
             to make your own canny edge detector work
'''

import numpy as np
import matplotlib.pyplot as plt
import os, cv2
from scipy import signal
from PIL import Image

# import functions
from findDerivatives import findDerivatives
from nonMaxSup import nonMaxSup
from edgeLink import edgeLink
import utils, helpers

# cannyEdge detector
def cannyEdge(I):
  # convert RGB image to gray color space
  im_gray = utils.rgb2gray(I)
  # im_gray = cv2.cvtColor(I, cv2.COLOR_RGB2GRAY)

  Mag, Magx, Magy, Ori = findDerivatives(im_gray)
  M = nonMaxSup(Mag, Ori)
  E = edgeLink(M, Mag, Ori)

  # only when test passed that can show all results
  if utils.outputTest(im_gray, E):
    # visualization results
    # utils.visDerivatives(im_gray, Mag, Magx, Magy)
    utils.visCannyEdge(I, M, E)

    # Compare your result with built in function
    GroundT = cv2.Canny(I, 50, 250)
    utils.visForComparison(I, GroundT, E)

    plt.show()

  return E


if __name__ == "__main__":
  # the folder name that stores all images
  folder = 'easy'

  # read images one by one
  for filename in os.listdir(folder):
    # read in image and convert color space for better visualization
    im_path = os.path.join(folder, filename)
    im_cur = np.array(Image.open(im_path).convert('RGB'))
    
    # im_cur = cv2.imread(os.path.join(folder, filename))
    # im_cur = cv2.cvtColor(im_cur, cv2.COLOR_BGR2RGB)
    
    ## TO DO: Complete 'cannyEdge' function
    E = cannyEdge(im_cur)




