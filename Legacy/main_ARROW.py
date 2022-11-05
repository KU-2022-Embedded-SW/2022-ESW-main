from ast import NotIn
import cv2
import numpy as np
#import matplotlib.pyplot as plt
import time
import math

#cam = cv2.VideoCapture(0, cv2.CAP_DSHOW)

cam = cv2.VideoCapture(0)

cam.set(3, 640)
cam.set(4, 480)


Triangle_min = 90  # 90 집기준
Triangle_max = 180 # 180 집기준 
Triangle_windows_name = 'Triangle'

count = 0

Result = "non"
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#-----------------------------------------------

def Triangle_min_change(x):
    global Triangle_min, Triangle_max
    Triangle_min = cv2.getTrackbarPos('min', Triangle_windows_name)
    
def Triangle_max_change(x):
    global Triangle_min, Triangle_max
    
    Triangle_max = cv2.getTrackbarPos('max', Triangle_windows_name)    


def main():
    global Result
    
    View_select = 0
    
    cv2.namedWindow(Triangle_windows_name)
    cv2.resizeWindow(winname=Triangle_windows_name, width=500, height=500)
    cv2.createTrackbar('min', Triangle_windows_name, Triangle_min, 500, Triangle_min_change)
    cv2.createTrackbar('max', Triangle_windows_name, Triangle_max, 500, Triangle_max_change)

    old_time = clock()
    while True:
        ret_val, img = cam.read()

        if ret_val == True:
            target = img_process(img)
            contours_im, hierachy = cv2.findContours(target, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
            arrows = find_items(contours_im)
            if len(arrows) > 0:
                draw_contour(img, arrows)
            else:
                Result = "non"
                
            if View_select == 0:
                cv2.imshow(Triangle_windows_name, img)
            
            
            Frame_time = (clock() - old_time) * 1000.
            old_time = clock()
            print("Frame_time =  %.1f ms " % (Frame_time ) + str(Result))
            
            k = cv2.waitKey(1) & 0xFF
            if k == 27:
                break
            elif k == ord(' '):  # spacebar Key
                if View_select == 0:
                    View_select = 1
                
                else:
                    View_select = 0
    cv2.destroyAllWindows()


def draw_contour(img, arrows):
    global Result
    
    points = []
    for contour in arrows:
        cx, cy, points = calc_points(contour[0])
        cv2.drawContours(img, [contour[0]], -1, (0, 255, 255), 2)
        cv2.circle(img, contour[1], 3, (0, 0, 255), cv2.FILLED)
        cv2.circle(img, (cx, cy), 3, (0, 0, 255), cv2.FILLED)
        angle = calc_dir((cx, cy), contour[1])
        #cv2.putText(img, str(angle), contour[1], cv2.FONT_HERSHEY_COMPLEX, 0.3, (255, 255, 0), 1)

    cx, cy, points = calc_points(arrows[0][0])
    cv2.drawContours(img, [arrows[0][0]], -1, (128, 255, 128), 3)
    cv2.circle(img, arrows[0][1], 3, (0, 0, 255), cv2.FILLED)
    cv2.circle(img, (cx, cy), 3, (0, 0, 255), cv2.FILLED)
    angle = calc_dir((cx, cy), arrows[0][1])
    #cv2.putText(img, str(angle), arrows[0][1], cv2.FONT_HERSHEY_COMPLEX, 0.3, (255, 0, 0), 1)
    #cv2.putText(img, str("{:.2f}".format(angle)), arrows[0][1], cv2.FONT_HERSHEY_COMPLEX, 0.3, (255, 0, 0), 1)


    
    if (angle > 0 and angle < 90) or (angle < 0 and angle > -90):
        cv2.putText(img, "RIGHT", arrows[0][1], cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        Result = "RIGHT"
        #print("count = " + str(count) + "  %.1f ms " % (Frame_time ))
    else:
        cv2.putText(img, "LEFT", arrows[0][1], cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        Result = "LEFT"
        #print("count = " + str(count) + "  %.1f ms " % (Frame_time ))

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


def img_process(img):
    global Triangle_min,Triangle_max
    #threshold1 = 0
    #threshold2 = 360
    threshold1 = Triangle_min
    threshold2 = Triangle_max
    
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


if __name__ == "__main__":
    main()
