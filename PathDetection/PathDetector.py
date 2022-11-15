import cv2
import numpy as np
import math
import random

class LineInfo():
    def __init__(self, grad, sx, sy, ex, ey):
        self.grad = grad
        self.sx = sx
        self.sy = sy
        self.ex = ex
        self.ey = ey
        self.cnt = 1
        self.avg_grad = np.int0(self.grad/self.cnt)
    
    def add(self, grad, sx, sy, ex, ey):
        self.grad += grad
        self.sx += sx
        self.sy += sy
        self.ex += ex
        self.ey += ey
        self.cnt += 1
    
    def add_by_instance(self, l_info):
        self.grad += l_info.grad
        self.sx += l_info.sx
        self.sy += l_info.sy
        self.ex += l_info.ex
        self.ey += l_info.ey
        self.cnt += 1
        self.avg_grad = np.int0(self.grad/self.cnt)

    
    def get_average(self):
        self.grad = np.int0(self.grad/self.cnt)
        self.sx = np.int0(self.sx/self.cnt)
        self.sy = np.int0(self.sy/self.cnt)
        self.ex = np.int0(self.ex/self.cnt)
        self.ey = np.int0(self.ey/self.cnt)
        return LineInfo(self.grad, self.sx, self.sy, self.ex, self.ey)

class PathDetector():
    def __init__(self):
        self.zero = 0
        self.lower_yellow = (20, 20, 100)
        self.upper_yellow = (32, 255, 255)

    # def img_process(self, img):
    #     threshold1 = 0
    #     threshold2 = 360
    #     target = cv2.medianBlur(img, 3)
    #     img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
    #     img_canny = cv2.Canny(img_gray, threshold1, threshold2)

    #     kernel = np.ones((3, 3))
    #     img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
    #     img_erode = cv2.erode(img_dilate, kernel, iterations=1)
    #     return img_erode

    def img_process(self, img):
        hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        y_mask = cv2.inRange(hsv_img, self.lower_yellow, self.upper_yellow)
        y_img = cv2.bitwise_and(img, img, mask=y_mask)

        threshold1 = 0
        threshold2 = 360
        target = cv2.medianBlur(y_img, 3)
        img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
        img_canny = cv2.Canny(img_gray, threshold1, threshold2)

        kernel = np.ones((3, 3))
        img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
        img_erode = cv2.erode(img_dilate, kernel, iterations=1)
        return img_erode

    def calc_dist(self, coordA, coordB):
        x1, y1 = coordA
        x2, y2 = coordB
        return np.int0(math.sqrt(math.pow(x1-x2, 2) + math.pow(y1-y2, 2)))
    
    def calc_grad(self, coordA, coordB):
        x1, y1 = coordA
        x2, y2 = coordB
        delta_x = x1-x2
        delta_y = y1-y2
        angle = math.degrees(math.atan2(delta_y, delta_x))
        return np.int0((angle))

    def is_similar(self, grad1, grad2):
        if abs(grad1-grad2) < 2.5:
            return True
        else:
            return False

    def detect_line(self, target_img):
        line_set = [] # grad, stx, sty, edx, edy, cnt
        lines = cv2.HoughLinesP(target_img, 0.8, np.pi / 180, 90, minLineLength = 10, maxLineGap = 100)
        
        if lines is None:
            return -1
        print(f'len(lines):{len(lines)}')
        for line in lines:
            print()
            is_stored = False
            line_grad = self.calc_grad((line[0][0],line[0][1]), (line[0][2],line[0][3]))
            print(f'line_grad : {line_grad}')
            l_info = LineInfo(line_grad, line[0][0], line[0][1], line[0][2], line[0][3])
            for rep_line in line_set:
                isSimilar = self.is_similar(rep_line.avg_grad, line_grad)
                print(rep_line.grad, line_grad, isSimilar)
                if isSimilar is True:
                    rep_line.add_by_instance(l_info)
                    is_stored = True
                    break
            if is_stored is False:
                line_set.append(l_info)
                print(f'append : {l_info.grad}')

            # line_set.append((line_length, line, line_grad))
        # line_set.sort(key=lambda x : x[0], reverse=True)
        print(f'len(line_set) : {len(line_set)}')
        for rep_line in line_set:
            rep_line = rep_line.get_average()
            print(rep_line.grad, rep_line.cnt)

        return line_set

    def get_path_info(self, img):
        target_img = self.img_process(img)
        path_img = self.find_path(target_img, img)
        return path_img

    def find_path(self, target_img, img):
        line_set = self.detect_line(target_img)
        if line_set != -1:
            for line_data in line_set:
                line_grad = line_data.grad
                sx = line_data.sx
                sy = line_data.sy
                ex = line_data.ex
                ey = line_data.ey
                cv2.line(img, (sx, sy), (ex, ey), (random.randint(0, 255),random.randint(0, 255),random.randint(0, 255)), 2)
                cv2.putText(img,str(line_grad),(np.int0((sx+ex)/2), np.int0((sy+ey)/2)),cv2.FONT_HERSHEY_SIMPLEX,1,(0,0,255),1)
        ret_val = 0
        return img