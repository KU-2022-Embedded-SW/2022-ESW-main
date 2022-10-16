from slave_arrow import *
import slave_alphabet
import time

import cv2
import numpy as np
import matplotlib.pyplot as plt
import time
import math
import serial

# @Todo
# opencv로 카메라로부터 이미지 가져오기
# 이미지 전처리
# Contour 리스트 생성 후 ArrowDetection 모듈과 AlphabetDetection 모듈로 리스트 넘겨줌
# from ArrowDetection, only receive arrow (isArrow, direction)
# from AlphabetDetection, only receive (isAlphabet, what charecter is)
# if this process can be dealt with MPMD(1 core for Alphabet detection, 1 core for Arrow detection), that would be best

cam = cv2.VideoCapture(1)
cam.set(3, 640)
cam.set(4, 360)

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
# python -m serial.tools.miniterm /dev/ttyACM0

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

def getTargetImage():
    print("pi : get target image")
    while True:
        ret_val, img = cam.read()
        if ret_val == True:
            print("pi : get image successfully")
            target = img_process(img)
            contours_im, hierachy = cv2.findContours(target, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
            return contours_im
    

def doWork():
    print("pi : do work")
    contours = getTargetImage()
    print("pi : get arrow info")
    ret_val = arrow_process(contours)

    if ret_val == 'l':
        ser.write('l'.encode())
        print("pi : left")
    elif ret_val == 'r':
        ser.write('r'.encode())
        print("pi : right")
    else:
        ser.write('f'.encode())
        print("pi : front")

if __name__ == "__main__":
    # ser.open()
    while True:
        print("pi : wait for request")
        input = ser.read()
        print (input.decode("utf-8"))
        doWork()
        time.sleep(1)
    ser.close()
        
