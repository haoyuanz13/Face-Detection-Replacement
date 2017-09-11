'''
  File name: findDerivatives.py
  Author: Haoyuan(Steve) Zhang
  Date created: 9/9/2017
'''

'''
  File clarification:
    Compute gradient information of the input grayscale image
    - Input I_gray: M x N matrix as image
    - Output Mag: M x N matrix represents the magnitude of derivatives
    - Output Magx: M x N matrix represents the magnitude of derivatives along x-axis
    - Output Magy: M x N matrix represents the magnitude of derivatives along y-axis
    - Output Ori: M x N matrix represents the orientation of derivatives
'''

import numpy as np
from scipy import signal
import utils

def findDerivatives(I_gray):
  # create a random Gaussian distribution along x and y axis respectfully
  gx = utils.GaussianPDF_1D(0, 1, 11)
  gy = gx.transpose()

  # compute derivatives along x and y axis
  dx = np.array([1, -1]).reshape([-1, 2])
  dy = np.array([[1], [-1]])
  
  Gx = signal.convolve2d(gx, dx, 'same')
  Gy = signal.convolve2d(gy, dy, 'same')

  # compute the gradient of image along x and y axis
  I_gray.astype(float)
  Gx.astype(float)
  Gy.astype(float)

  # Gaussian smoothing and gradient computation
  Magx = signal.convolve2d(I_gray, Gx, 'same')
  Magy = signal.convolve2d(I_gray, Gy, 'same')

  Mag = np.sqrt( np.square(Magx) + np.square(Magy) )
  Ori = np.arctan2(Magy, Magx)

  return Mag, Magx, Magy, Ori


