import cv2
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision.transforms as transforms
from torchvision.transforms import ToTensor
from consts import *


class AlphabetDetector:

    def __init__(self):
        self.to_tensor = ToTensor()
        self.models = []

        for i in range(0, 5):
            self.models.append(torch.load('model/result_{}.pt'.format(i), map_location=torch.device('cpu')))
            self.models[i].eval()
            print('model loaded!')
        
        self.target_contours = []
        alphabet_A = cv2.imread('A.png', cv2.IMREAD_GRAYSCALE)
        cont_A, _ = cv2.findContours(alphabet_A, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_B = cv2.imread('B.png', cv2.IMREAD_GRAYSCALE)
        cont_B, _ = cv2.findContours(alphabet_B, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_C = cv2.imread('C.png', cv2.IMREAD_GRAYSCALE)
        cont_C, _ = cv2.findContours(alphabet_C, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_D = cv2.imread('D.png', cv2.IMREAD_GRAYSCALE)
        cont_D, _ = cv2.findContours(alphabet_D, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)

        alphabet_N = cv2.imread('N.png', cv2.IMREAD_GRAYSCALE)
        cont_N, _ = cv2.findContours(alphabet_N, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_S = cv2.imread('S.png', cv2.IMREAD_GRAYSCALE)
        cont_S, _ = cv2.findContours(alphabet_S, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_E = cv2.imread('E.png', cv2.IMREAD_GRAYSCALE)
        cont_E, _ = cv2.findContours(alphabet_E, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        alphabet_W = cv2.imread('W.png', cv2.IMREAD_GRAYSCALE)
        cont_W, _ = cv2.findContours(alphabet_W, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)

        self.target_contours.append(cont_A)
        self.target_contours.append(cont_B)
        self.target_contours.append(cont_C)
        self.target_contours.append(cont_D)
        self.target_contours.append(cont_N)
        self.target_contours.append(cont_S)
        self.target_contours.append(cont_E)
        self.target_contours.append(cont_W)


    # def main():
    #     target = img_process(img)
    #     contours_im, hierachy = cv2.findContours(target, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    #     alphabets = find_items(target, contours_im)

    def get_alphabet_info(self, img):
        target_img = self.img_process(img)
        contours_im, hierachy = cv2.findContours(target_img, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
        retval = self.get_best_alphabet(img, contours_im)
        retval2 = self.get_most_similar_alphabet(contours_im)
        return retval

    def get_most_similar_alphabet(self, contours):
        matches = []
        for contour in contours:
            for target in self.target_contours:
                match = cv2.matchShapes(target, contour, cv2.CONTOURS_MATCH_I3, 0.0)
                matches.append((match, contour))
        matches.sort(key=lambda x : x[0])
        return matches[0][1]

    def img_process(self, img):
        target = cv2.medianBlur(img, 5)
        med_val = np.median(target) 
        lower = int(max(0 ,0.7*med_val))
        upper = int(min(255,1.3*med_val))

        img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
        img_canny = cv2.Canny(img_gray, lower, upper)

        kernel = np.ones((3, 3))
        img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
        img_erode = cv2.erode(img_dilate, kernel, iterations=2)
        return img_erode

    def detect_alphabet(self, raw_data):
        data = raw_data.view(-1, 1, 32, 32)
        result = torch.zeros([1, 26], dtype=torch.float64)

        for i in range(0, 5):
            output = self.models[i](data)
            result += output.squeeze()
        
        
        overall = result.argmax(dim=1, keepdim=True).numpy().squeeze()
        ans_weight = result.squeeze().detach().numpy()[overall]
        # print('Overall result : {}'.format(overall))
        return overall, ans_weight

    def get_best_alphabet(self, img, contours_im):
        # alphabets = []
        max_weight = 0
        alphabet = ''
        for contour in contours_im:
            x,y,w,h = cv2.boundingRect(contour)

            if w < 30 or h < 30 :
                continue
            if h/w >= tolerance or w/h >= tolerance:
                continue

            # pil_img = Image.fromarray(img)
            # cropped_img = pil_img.crop((x,y,x+w,y+h))

            cropped_img = img[y:y+h, x:x+w]
            target_img = self.img_process(cropped_img)
            data = self.to_tensor(cv2.resize(target_img, (32, 32)))
            result, weight = self.detect_alphabet(data)

            if weight < answer_threshold :
                continue
            if max_weight < weight:
                max_weight = weight
                alphabet = result
            # alphabets.append((contour, result, int(weight)))

        return alphabet
