import cv2
import numpy as np
import math
from alphabet_detector import alphabet_detector
from PIL import Image
import torch
import torch.nn as nn
import torch.nn.functional as F


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
            alphabets = find_items(img, contours_im)
            if len(alphabets) > 0:
                draw_contour(img, alphabets)
            # draw_contour(img, contours_im)
            cv2.imshow('test', img)
            k = cv2.waitKey(1) & 0xFF
            if k == 27:
                break
    cv2.destroyAllWindows()


def draw_contour(img, target):
    points = []
    for contour, label in target:
        color1 = (list(np.random.choice(range(256), size=3)))  
        color =[int(color1[0]), int(color1[1]), int(color1[2])]  
        cv2.drawContours(img, [contour], -1, color, 1)
        try :
            x, y, s = calc_points(contour)
        except Exception as e:
            print(e)
            x, y = 0, 0
        org=(x,y)
        font=cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(img,str(label),org,font,1,color,1)


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
    threshold1 = 0
    threshold2 = 360
    target = cv2.medianBlur(img, 3)
    img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
    img_canny = cv2.Canny(img_gray, threshold1, threshold2)

    kernel = np.ones((3, 3))
    img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
    img_erode = cv2.erode(img_dilate, kernel, iterations=1)
    return img_erode

def find_items(img, contours_im):
    alphabets = []
    for contour in contours_im:
        x,y,w,h = cv2.boundingRect(contour)
        
        pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))
        crop_img = pil_img.crop((x,y,x+w,y+h))
        try:
            crop_img.show()
        except Exception as e:
            print(e)
        # data = np.array(crop_img.resize((32,32)))
        # data = np.expand_dims(data, 0)
        # data = torch.from_numpy(data)
        # data = data.type(torch.FloatTensor)
        # data = data / 255
        # result = alphabet_detector(data)
        # alphabets.append((contour, result))
    return alphabets


if __name__ == "__main__":
    main()
