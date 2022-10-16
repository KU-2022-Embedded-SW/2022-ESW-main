import cv2
import numpy as np
import matplotlib.pyplot as plt
import time
import math


def arrow_process(contours_im):

    arrows = find_items(contours_im)
    if len(arrows)>0 :
        ret_val = getDirection(arrows)
        return ret_val
    else:
        return 'n'


def getDirection(arrows):
    points=[]
    cx, cy, points = calc_points(arrows[0][0])
    angle = calc_dir((cx, cy), arrows[0][1])
    if (angle > 0 and angle < 90) or (angle < 0 and angle > -90):
        return 'r'
    else:
        return 'l'


def calc_dir(p1, p2):
    delta_x = p2[0] - p1[0]
    delta_y = p2[1] - p1[1]
    angle = math.degrees(math.atan2(delta_y , delta_x))
    return angle


def calc_mid(p1, p2):
    return ((p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2)


def calc_points(contour):
    M = cv2.moments(contour)

    center_x = int(M['m10'] / M['m00'])
    center_Y = int(M['m01'] / M['m00'])

    left_most = tuple(contour[contour[:, :, 0].argmin()][0])
    right_most = tuple(contour[contour[:, :, 0].argmax()][0])
    top_most = tuple(contour[contour[:, :, 1].argmin()][0])
    bottom_most = tuple(contour[contour[:, :, 1].argmax()][0])
    return center_x, center_Y, (left_most, right_most, top_most, bottom_most)

def find_items(contours_im):
    arrows = []
    for contour in contours_im:
        peri = cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, 0.025 * peri, True)
        hull = cv2.convexHull(approx, returnPoints=False)
        sides = len(hull)

        if 8 > sides > 3 and sides + 2 == len(approx):
            arrow_tip = find_tip(approx[:, 0, :], hull.squeeze())
            if arrow_tip:
                arrows.append((contour, arrow_tip))
    return arrows


def find_tip(points, convex_hull):
    length = len(points)
    indices = np.setdiff1d(range(length), convex_hull)
    
    for i in range(2):
        j = indices[i] + 2
        if j > length - 1:
            j = length - j
        if np.all(points[j] == points[indices[i - 1] - 2]):
            return tuple(points[j])

