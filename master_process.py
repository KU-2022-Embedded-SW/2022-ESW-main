from ArrowDetection.ArrowDetector import ArrowDetector
import time
from AlphabetDetection.AlphabetDetector import AlphabetDetector
from PathDetection.PathDetector import PathDetector
import cv2
import numpy as np
import matplotlib.pyplot as plt
import time
import serial

from threading import Thread

cam = cv2.VideoCapture(1)
cam.set(3, 640)
cam.set(4, 360)
alphabet_detector = AlphabetDetector()
arrow_detector = ArrowDetector()
path_detector = PathDetector()

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
# python -m serial.tools.miniterm /dev/ttyACM0



def get_image():
    print("pi : get target image")
    while True:
        ret_val, img = cam.read()
        if ret_val == True:
            print("pi : get image successfully")
            return img
    
def find_arrow():
    img = get_image()
    print("pi : get arrow info")
    ret_val = arrow_detector.get_arrow_direction(img)

def find_alphabet():
    img = get_image()
    print("pi : get alphabet info")
    ret_val = alphabet_detector.get_alphabet_info(img)

def find_path():
    img = get_image()
    print("pi : get path info")
    ret_val = path_detector.get_path_info(img)


if __name__ == "__main__":
    while True:
        print("pi : wait for request")
        input = (ser.read()).decode("utf-8")
        print (f'input : {input}')
        if input == "p" :
            # road
            find_path()
        elif input == "a" :
            # arrow
            find_arrow()
        elif input == "l" :
            # alphabet
            find_alphabet()
        time.sleep(1)
    ser.close()
        
