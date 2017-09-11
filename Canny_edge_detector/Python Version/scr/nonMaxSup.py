'''
  File name: nonMaxSup.py
  Author: Haoyuan(Steve) Zhang
  Date created: 9/10/2017
'''

'''
  File clarification:
    Find local maximum edge pixel using NMS along the line of the gradient
    - Input Mag: the matrix represents the magnitude of derivatives
    - Input Ori: the matrix represents the orientation of derivatives
    - Output M: the binary matrix represents the edge map after non-maximum suppression
'''

import numpy as np
from scipy import signal
import utils, helpers

def nonMaxSup(Mag, Ori):
  # set local threshold
  nr, nc = Mag.shape[0], Mag.shape[1]
  # separate cells and compute region magnitude
  numR, numC = 2, 2
  regionMagSum, sumMag, deltaMag_r, deltaMag_c = helpers.regionSumComputation(Mag, numR, numC)

  maxMag = np.amax(Mag)
  regionThreshold = (regionMagSum / float(sumMag * 15)) * maxMag 

  # modify the origin Mag and Ori matrix for convenient
  Ori[Ori < 0] += np.pi  # make all orientation value as positive
  Ori_pad = np.lib.pad(Ori, ((1, 1), (1, 1)), 'constant', constant_values=(1))
  Mag_pad = np.lib.pad(Mag, ((1, 1), (1, 1)), 'constant', constant_values=(0))  # pad a layer of zeros around the Magnitiude matrix

  ## non-max supression
  M = np.zeros((nr, nc))  # initialize a binary logical matrix

  # traverse all pixles and compare its value with neighbors along the gradient direction
  for i in range(1, nr + 1):
    for j in range(1, nc + 1):
      # interpolation operation based on the distance ratio
      Ori_cur, pivot_Ori = Ori_pad[i, j], 0
      factor_pos1, factor_pos2 = 0, 0
      factor_neg1, factor_neg2 = 0, 0
      
      # the first region [0, pi / 4]
      if Ori_cur >= 0 and Ori_cur < (np.pi / 4):
        pivot_Ori = Ori_cur
        factor_pos1, factor_pos2 = Mag_pad[i, j + 1], Mag_pad[i + 1, j + 1]
        factor_neg1, factor_neg2 = Mag_pad[i, j - 1], Mag_pad[i - 1, j - 1]
      
      # the first region [pi / 4, pi / 2]
      elif Ori_cur >= (np.pi / 4) and Ori_cur < (np.pi / 2):
        pivot_Ori = (np.pi / 2) - Ori_cur
        factor_pos1, factor_pos2 = Mag_pad[i + 1, j], Mag_pad[i + 1, j + 1]
        factor_neg1, factor_neg2 = Mag_pad[i - 1, j], Mag_pad[i - 1, j - 1]

      # the first region [pi / 2, 3pi / 4]
      elif Ori_cur >= (np.pi / 2) and Ori_cur < (3 * np.pi / 4):
        pivot_Ori = Ori_cur - (np.pi / 2)
        factor_pos1, factor_pos2 = Mag_pad[i + 1, j], Mag_pad[i + 1, j - 1]
        factor_neg1, factor_neg2 = Mag_pad[i - 1, j], Mag_pad[i - 1, j + 1]

      # the first region [3pi / 4 , pi]
      elif Ori_cur >= (3 * np.pi / 4) and Ori_cur < np.pi:
        pivot_Ori = np.pi - Ori_cur
        factor_pos1, factor_pos2 = Mag_pad[i, j - 1], Mag_pad[i + 1, j - 1]
        factor_neg1, factor_neg2 = Mag_pad[i, j + 1], Mag_pad[i - 1, j + 1]
      
      # interpolate virtual values
      pad_pos = factor_pos1 * np.tan(pivot_Ori) + factor_pos2 * (1 - np.tan(pivot_Ori))
      pad_neg = factor_neg1 * np.tan(pivot_Ori) + factor_neg2 * (1 - np.tan(pivot_Ori))

      # non-max supression
      center = Mag_pad[i, j]
      # find the threshold in current cell
      threshold_cur = regionThreshold[ min((i - 1) / deltaMag_r, numR - 1), min((j - 1) / deltaMag_c, numC - 1) ]
      if center > pad_pos + threshold_cur and center > pad_neg + threshold_cur:
        # label current center can be treat as local max
        M[i - 1, j - 1] = 1 
      # end if
    # end inner for
  # end outer for

  return M 