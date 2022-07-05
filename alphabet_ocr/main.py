import pytesseract
import cv2
import numpy as np

cam = cv2.VideoCapture(0, cv2.CAP_DSHOW)
cam.set(3,640)
cam.set(4,360)

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
        result = pytesseract.image_to_string(target, lang='eng')
        print(result)

        k = cv2.waitKey(1) & 0xFF
        if k == 27:
            break




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

