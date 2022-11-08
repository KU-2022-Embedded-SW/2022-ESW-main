from ArrowDetection.ArrowDetector import ArrowDetector
from AlphabetDetection.AlphabetDetector import AlphabetDetector
from PathDetection.PathDetector import PathDetector
import cv2
import time
import serial

class Master:
    def __init__(self):
        print("Initialize Master")
        self.cam = cv2.VideoCapture(1)
        self.cam.set(3, 640)
        self.cam.set(4, 360)

        print('Initialize Alphabet Detector')
        self.alphabet_detector = AlphabetDetector()

        print('Initialize Arrow Detector')
        self.arrow_detector = ArrowDetector()

        print('Initialize Path Detector')
        self.path_detector = PathDetector()

        # self.ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
        # python -m serial.tools.miniterm /dev/ttyACM0
        self.ser = serial.Serial('COM2', 9600, timeout=1)
        cv2.namedWindow("name")
        self.last_command = ''
        self.ser.write('D'.encode())

    def get_image(self):
        print("pi : get target image")
        while True:
            ret_val, img = self.cam.read()
            if ret_val == True:
                print("pi : get image successfully")
                return img
    
    def find_arrow(self):
        img = self.get_image()
        print("pi : get arrow info")
        ret_val = self.arrow_detector.get_arrow_direction(img)
        self.ser.write(ret_val.encode())

    def find_alphabet(self):
        img = self.get_image()
        print("pi : get alphabet info")
        alphabet, value, alphabet2, value2, img = self.alphabet_detector.get_alphabet_info(img)
        
        print(f'alpha 1 : {alphabet}')
        print(f'alpha 1 : {value}')
        print("")
        print(f'alpha 2 : {alphabet2}')
        print(f'alpha 2 : {value2}')
        print("")
        cv2.imshow("name", img)
        k = cv2.waitKey(1) & 0xFF

    def find_path(self):
        img = self.get_image()
        print("pi : get path info")
        ret_val = self.path_detector.get_path_info(img)
    
    def master_protocol(self):
        print("pi : wait for request")
        input = (self.ser.read()).decode("utf-8")
        print (f'input : {input}')
        if input != 'p' and input != 'a' and input !='l':
            input = self.last_command

        if input == "p" :
            # road
            self.find_path()
            self.last_command = 'p'
        elif input == "a" :
            # arrow
            self.find_arrow()
            self.last_command = 'a'
        elif input == "l" :
            # alphabet
            self.find_alphabet()
            self.last_command = 'l'
        
    def destroy(self):
        self.ser.close()



if __name__ == "__main__":
    master = Master()
    while True:
        master.master_protocol()
        # time.sleep(0.1)
    master.destroy()
        
