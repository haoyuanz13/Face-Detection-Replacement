'''
  File name: helpers.py
  Author: Haoyuan(Steve) Zhang
  Date created: 9/10/2017
'''

'''
  File clarification:
    Helpers file that contributes the project  
'''

import numpy as np
from scipy import signal
import matplotlib.pyplot as plt
import utils

'''
  Compute the sum of elements in local cells
  - Input M: the matrix that computed region sum
  - Input numR: the number of cells in row direction
  - Input numC: the number of cells in column direction
  - Output regionSum: the matrix that represents sum of region elements
  - Output totalRegionSum: the total sum of all cells 
  - Output deltaR: length of each cell in row direction
  - Output deltaC: length of each cell in column direction
'''
def regionSumComputation(M, numR, numC):
  nr, nc = M.shape[0], M.shape[1]
  deltaR = nr / numR
  deltaC = nc / numC

  regionSum = np.zeros((numR, numC))
  totalRegionSum = 0

  for i in range(numR):
    for j in range(numC):
      cur_sum = M[i * deltaR : (i + 1) * deltaR, j * deltaC : (j + 1) * deltaC].sum()
      
      # assignment 
      regionSum[i, j] = cur_sum
      totalRegionSum += cur_sum

    # end inner for
  # end outer for

  return regionSum, totalRegionSum, deltaR, deltaC

