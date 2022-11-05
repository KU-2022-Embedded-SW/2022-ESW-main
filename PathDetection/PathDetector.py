import cv2
import numpy as np

class PathDetector():
    def __init__(self):
        self.zero = 0

    def img_process(self, img):
        threshold1 = 0
        threshold2 = 360
        target = cv2.medianBlur(img, 3)
        img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
        img_canny = cv2.Canny(img_gray, threshold1, threshold2)

        kernel = np.ones((3, 3))
        img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
        img_erode = cv2.erode(img_dilate, kernel, iterations=1)
        return img_erode
    
    def get_path_info(self, img):
        target_img = self.img_process(img)
        contours_im, hierachy = cv2.findContours(target_img, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        path = self.find_path(contours_im)

    def find_path(self, contours):
        # 경로 정보를 반환
        # 반환값 : f(직진), c(코너), t(교차로), o(장애물)?
        # 큰 직사각형 덩어리마다 긴쪽 중앙선 검출
        # 중앙선을 무한히 확장?
        # 가장 가운데 중앙선 제외한 다른 
        ret_val = 0
        return ret_val