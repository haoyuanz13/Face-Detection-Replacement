'''
  File name: edgeLink.py
  Author: Haoyuan(Steve) Zhang
  Date created: 9/10/2017
'''

'''
  File clarification:
    Use hysteresis to link edges based on high and low magnitude thresholds
    - Input M: logical map after non-max suppression
    - Input Mag: the matrix represents the magnitude of gradient
    - Input Ori: the matrix represents the orientation of gradient
    - Output E: the binary matrix represents the final canny edge detection map
'''

import numpy as np
from scipy import signal
import utils, helpers

def edgeLink(M, Mag, Ori):
  # get matrix represents gradient magnitude at edge position
  Edge = M * Mag

  # separate cells and compute region magnitude
  numR, numC = 3, 2
  regionEdgeSum, sumEdge, deltaMag_r, deltaMag_c = helpers.regionSumComputation(Edge, numR, numC)

  # compute the sum of local gradient magnitude
  nr, nc = Mag.shape[0], Mag.shape[1]

  # set local low and high threshold
  # matrix to store local high threshold
  regionThresholdHigh = np.zeros((numR, numC))
  # matrix to store local high threshold
  regionThresholdLow = np.zeros((numR, numC))

  maxEdgeMag = np.amax(Edge)
  for i in range(numR):
    for j in range(numC):
      regionThresholdHigh[i, j] = ( regionEdgeSum[i, j] / float(sumEdge) ) * 0.8 * maxEdgeMag
      regionThresholdLow[i, j] = ( regionEdgeSum[i, j] / float(sumEdge) ) * 0.32 * maxEdgeMag
    # end inner for
  # end outer for

  # set matrix for start edge and link edge
  M_start = np.zeros((nr, nc))
  M_link = np.zeros((nr, nc))

  for i in range(nr):
    ind_cell_r = min(i / deltaMag_r, numR - 1)
    for j in range(nc):
      ind_cell_c = min(j / deltaMag_c, numC - 1)

      Edge_cur = Edge[i, j]
      thrHigh_cur, thrLow_cur = regionThresholdHigh[ind_cell_r, ind_cell_c], regionThresholdLow[ind_cell_r, ind_cell_c]

      if Edge_cur >= thrHigh_cur:
        M_start[i, j] = 1

      elif Edge_cur < thrHigh_cur and Edge_cur >= thrLow_cur:
        M_link[i, j] = 1
      # end if
    # end inner for
  # end outer for

  # start from strong edge point and find possible edge points to link together
  Ori[Ori < 0] += np.pi  # make all orientation value as positive
  Ori_pad = np.lib.pad(Ori, ((1, 1), (1, 1)), 'constant', constant_values=(10))
  M_start_pad = np.lib.pad(M_start, ((1, 1), (1, 1)), 'constant', constant_values=(0))

  # locate each link candidate position and test its neighbors in M_start_pad matrix
  indCandidates = np.where(M_link == 1)
  total = len(indCandidates[0])

  for i in range(total):
    ind_r_link, ind_c_link = indCandidates[0][i], indCandidates[1][i]
    ind_r_start, ind_c_start = ind_r_link + 1, ind_c_link + 1

    Ori_cur = Ori_pad[ind_r_start, ind_c_start]

    # multiple cases based on current gradient orientation
    # Gradient orientation is between [0, pi / 8]
    if Ori_cur >= 0 and Ori_cur < (np.pi / 8):
      ind_nei_r_u, ind_nei_c_u = ind_r_start - 1, ind_c_start
      ind_nei_r_d, ind_nei_c_d = ind_r_start + 1, ind_c_start

      # test whether either of neighbors is start edge point
      if M_start_pad[ind_nei_r_u, ind_nei_c_u] == 1 or M_start_pad[ind_nei_r_d, ind_nei_c_d] == 1:
        # test whether gradient direction is consist
        Ori_nei_u = Ori_pad[ind_nei_r_u, ind_nei_c_u]
        Ori_nei_d = Ori_pad[ind_nei_r_d, ind_nei_c_d]

        if Ori_nei_u >= 0 and Ori_nei_u < (np.pi / 8) and Ori_nei_d >= 0 and Ori_nei_d < (np.pi / 8):
          M_start_pad[ind_r_start, ind_c_start] = 1  

    # Gradient orientation is between [7 * pi / 8, pi]
    elif Ori_cur >= (7 * np.pi / 8) and Ori_cur < (np.pi):
      ind_nei_r_u, ind_nei_c_u = ind_r_start - 1, ind_c_start
      ind_nei_r_d, ind_nei_c_d = ind_r_start + 1, ind_c_start

      # test whether either of neighbors is start edge point
      if M_start_pad[ind_nei_r_u, ind_nei_c_u] == 1 or M_start_pad[ind_nei_r_d, ind_nei_c_d] == 1:
        # test whether gradient direction is consist
        Ori_nei_u = Ori_pad[ind_nei_r_u, ind_nei_c_u]
        Ori_nei_d = Ori_pad[ind_nei_r_d, ind_nei_c_d]

        if Ori_nei_u >= (7 * np.pi / 8) and Ori_nei_u < np.pi and Ori_nei_d >= (7 * np.pi / 8) and Ori_nei_d < np.pi:
          M_start_pad[ind_r_start, ind_c_start] = 1  

    # Gradient orientation is between [pi / 8, 3 * pi / 8]
    elif Ori_cur >= (np.pi / 8) and Ori_cur < (3 * np.pi / 8):
      ind_nei_r_u, ind_nei_c_u = ind_r_start - 1, ind_c_start + 1
      ind_nei_r_d, ind_nei_c_d = ind_r_start + 1, ind_c_start - 1

      # test whether either of neighbors is start edge point
      if M_start_pad[ind_nei_r_u, ind_nei_c_u] == 1 or M_start_pad[ind_nei_r_d, ind_nei_c_d] == 1:
        # test whether gradient direction is consist
        Ori_nei_u = Ori_pad[ind_nei_r_u, ind_nei_c_u]
        Ori_nei_d = Ori_pad[ind_nei_r_d, ind_nei_c_d]

        if Ori_nei_u >= (np.pi / 8) and Ori_nei_u < (3 * np.pi / 8) and Ori_nei_d >= (np.pi / 8) and Ori_nei_d < (3 * np.pi / 8):
          M_start_pad[ind_r_start, ind_c_start] = 1  

    # Gradient orientation is between [3 * pi / 8, 5 * pi / 8]
    elif Ori_cur >= (3 * np.pi / 8) and Ori_cur < (5 * np.pi / 8):
      ind_nei_r_u, ind_nei_c_u = ind_r_start, ind_c_start + 1
      ind_nei_r_d, ind_nei_c_d = ind_r_start, ind_c_start - 1

      # test whether either of neighbors is start edge point
      if M_start_pad[ind_nei_r_u, ind_nei_c_u] == 1 or M_start_pad[ind_nei_r_d, ind_nei_c_d] == 1:
        # test whether gradient direction is consist
        Ori_nei_u = Ori_pad[ind_nei_r_u, ind_nei_c_u]
        Ori_nei_d = Ori_pad[ind_nei_r_d, ind_nei_c_d]

        if Ori_nei_u >= (3 * np.pi / 8) and Ori_nei_u < (5 * np.pi / 8) and Ori_nei_d >= (3 * np.pi / 8) and Ori_nei_d < (5 * np.pi / 8):
          M_start_pad[ind_r_start, ind_c_start] = 1  

    # Gradient orientation is between [5 * pi / 8, 7 * pi / 8]
    elif Ori_cur >= (5 * np.pi / 8) and Ori_cur < (7 * np.pi / 8):
      ind_nei_r_u, ind_nei_c_u = ind_r_start - 1, ind_c_start - 1
      ind_nei_r_d, ind_nei_c_d = ind_r_start + 1, ind_c_start + 1

      # test whether either of neighbors is start edge point
      if M_start_pad[ind_nei_r_u, ind_nei_c_u] == 1 or M_start_pad[ind_nei_r_d, ind_nei_c_d] == 1:
        # test whether gradient direction is consist
        Ori_nei_u = Ori_pad[ind_nei_r_u, ind_nei_c_u]
        Ori_nei_d = Ori_pad[ind_nei_r_d, ind_nei_c_d]

        if Ori_nei_u >= (5 * np.pi / 8) and Ori_nei_u < (7 * np.pi / 8) and Ori_nei_d >= (5 * np.pi / 8) and Ori_nei_d < (7 * np.pi / 8):
          M_start_pad[ind_r_start, ind_c_start] = 1  
    # end if
  # end for

  E = M_start_pad[1 : nr + 1, 1 : nc + 1]
  return E