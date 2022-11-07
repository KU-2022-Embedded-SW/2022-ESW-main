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

cam = cv2.VideoCapture(0)
cam.set(3, 640)
cam.set(4, 360)
alphabet_detector = AlphabetDetector()
arrow_detector = ArrowDetector()
path_detector = PathDetector()

# ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
# python -m serial.tools.miniterm /dev/ttyACM0
ser = serial.Serial('COM2', 9600, timeout=1)
cv2.namedWindow("name")

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
    ser.write(ret_val.encode())

def find_alphabet():
    img = get_image()
    print("pi : get alphabet info")
    alphabet, value, ret_val2, img = alphabet_detector.get_alphabet_info(img)
    
    print(f'alpha 1 : {alphabet}')
    print(f'alpha 1 : {value}')
    print("")
    print(f'alpha 2 : {ret_val2[0]}')
    print(f'alpha 2 : {ret_val2[1]}')
    print("")
    cv2.imshow("name", img)
    k = cv2.waitKey(1) & 0xFF

def find_path():
    img = get_image()
    print("pi : get path info")
    ret_val = path_detector.get_path_info(img)


if __name__ == "__main__":
    last_command = ''
    while True:
        print("pi : wait for request")
        input = (ser.read()).decode("utf-8")
        print (f'input : {input}')
        if input != 'p' and input != 'a' and input !='l':
            input = last_command

        if input == "p" :
            # road
            find_path()
            last_command = 'p'
        elif input == "a" :
            # arrow
            find_arrow()
            last_command = 'a'
        elif input == "l" :
            # alphabet
            find_alphabet()
            last_command = 'l'

        # time.sleep(0.1)
    ser.close()
        
