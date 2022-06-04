from ast import NotIn
import cv2
import numpy as np
import matplotlib.pyplot as plt
import time
import math

cam = cv2.VideoCapture(0, cv2.CAP_DSHOW)
cam.set(3, 640)
cam.set(4, 360)

def on_change(x):
    return int(x)

def main():
    cv2.namedWindow('test')
    cv2.resizeWindow(winname='test', width=500, height=500)
    cv2.createTrackbar('index', 'test', 0, 30, on_change)

    while True:
        ret_val, img = cam.read()
        
        if ret_val == True:
            target = img_process(img)
            contours_im, hierachy = cv2.findContours(target, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
            arrows = find_items(contours_im)  
            if len(arrows) > 0:
                draw_contour(img, arrows)
            cv2.imshow('test', img)
            # time.sleep(0.1)
            k = cv2.waitKey(1) & 0xFF
            if k == 27:
                break
    cv2.destroyAllWindows()

def draw_contour(img, arrows):
    points = []
    for contour in arrows :
        cx, cy, points = calc_points(contour[0])
        cv2.drawContours(img, [contour[0]], -1, (0,255,255), 2)
        cv2.circle(img, contour[1], 3, (0, 0, 255), cv2.FILLED)
        cv2.circle(img, (cx, cy), 3, (0, 0, 255), cv2.FILLED)
        angle = calc_dir((cx, cy), contour[1])
        cv2.putText(img, str(angle), contour[1], cv2.FONT_HERSHEY_COMPLEX,0.3,(255,255,0),1)
    
    cx, cy, points = calc_points(arrows[0][0])
    cv2.drawContours(img, [arrows[0][0]], -1, (128,255,128) ,3)
    cv2.circle(img, arrows[0][1], 3, (0, 0, 255), cv2.FILLED)
    cv2.circle(img, (cx, cy), 3, (0, 0, 255), cv2.FILLED)
    angle = calc_dir((cx, cy), arrows[0][1])
    cv2.putText(img,str(angle),arrows[0][1],cv2.FONT_HERSHEY_COMPLEX,0.3,(255,0,0),1)
                
def calc_dir(p1, p2):
    delta_x = p2[0] - p1[0]
    delta_y = p2[1] - p1[1]
    angle =  math.degrees(math.atan(delta_y/delta_x))
    return angle

def calc_mid(p1, p2):
    return ((p1[0]+p2[0])/2, (p1[1]+p2[1])/2)

def calc_points(contour):
    M = cv2.moments(contour)

    center_x = int(M['m10']/M['m00'])
    center_Y = int(M['m01']/M['m00'])

    left_most = tuple(contour[contour[:,:,0].argmin()][0])
    right_most = tuple(contour[contour[:,:,0].argmax()][0])
    top_most = tuple(contour[contour[:,:,1].argmin()][0])
    bottom_most = tuple(contour[contour[:,:,1].argmax()][0])
    return center_x, center_Y, (left_most, right_most, top_most, bottom_most)

def img_process(img):
    threshold1 = 0
    threshold2 = 360
    target = cv2.medianBlur(img, 3)
    img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
    img_canny = cv2.Canny(img_gray, threshold1, threshold2)

    kernel = np.ones((3, 3))
    img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
    img_erode = cv2.erode(img_dilate, kernel, iterations=1)
    return img_erode

# def find_items(contours_im, contours_target):
#     matches = []
#     for contour in contours_im:
#         if cv2.contourArea(contour) < 500 :
#             continue
#         match = cv2.matchShapes(contours_target[0], contour, cv2.CONTOURS_MATCH_I2, 0.0)
#         matches.append((match, contour))
#     matches.sort(key=lambda x: x[0])
#     return matches

def find_items(contours_im):
    arrows = []
    for contour in contours_im:
        peri = cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, 0.025 * peri, True)
        hull = cv2.convexHull(approx, returnPoints=False)
        sides = len(hull)

        if 6 > sides > 3 and sides + 2 == len(approx):
            arrow_tip = find_tip(approx[:,0,:], hull.squeeze())
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

if __name__ == "__main__":
    main()
