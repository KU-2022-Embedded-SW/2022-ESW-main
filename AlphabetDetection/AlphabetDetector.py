import cv2
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision.transforms as transforms
from torchvision.transforms import ToTensor
from AlphabetDetection.consts import *
import networks
import random
from PIL import Image

class AlphabetDetector:

    def __init__(self):
        self.to_tensor = ToTensor()
        self.models = []
        print('Loading models')
        for i in range(0, 5):
            self.models.append(torch.load('AlphabetDetection/model/result_{}.pt'.format(i), map_location=torch.device('cpu')))
            self.models[i].eval()
            print('model loaded!')
        
        self.target_contours = []
        alphabet_A = cv2.imread('AlphabetDetection/references/A.jpg', cv2.IMREAD_COLOR)
        alphabet_B = cv2.imread('AlphabetDetection/references/B.jpg', cv2.IMREAD_COLOR)
        alphabet_C = cv2.imread('AlphabetDetection/references/C.jpg', cv2.IMREAD_COLOR)
        alphabet_D = cv2.imread('AlphabetDetection/references/D.jpg', cv2.IMREAD_COLOR)
        alphabet_N = cv2.imread('AlphabetDetection/references/N.jpg', cv2.IMREAD_COLOR)
        alphabet_S = cv2.imread('AlphabetDetection/references/S.jpg', cv2.IMREAD_COLOR)
        alphabet_E = cv2.imread('AlphabetDetection/references/E.jpg', cv2.IMREAD_COLOR)
        alphabet_W = cv2.imread('AlphabetDetection/references/W.jpg', cv2.IMREAD_COLOR)

        cont_A, _ = cv2.findContours(self.img_process(alphabet_A), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_B, _ = cv2.findContours(self.img_process(alphabet_B), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_C, _ = cv2.findContours(self.img_process(alphabet_C), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_D, _ = cv2.findContours(self.img_process(alphabet_D), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_N, _ = cv2.findContours(self.img_process(alphabet_N), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_S, _ = cv2.findContours(self.img_process(alphabet_S), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_E, _ = cv2.findContours(self.img_process(alphabet_E), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
        cont_W, _ = cv2.findContours(self.img_process(alphabet_W), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

        # cv2.drawContours(alphabet_A, cont_A, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_B, cont_B, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_C, cont_C, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_D, cont_D, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_N, cont_N, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_S, cont_S, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_E, cont_E, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        # cv2.drawContours(alphabet_W, cont_W, 0, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)

        # cv2.imshow('A', alphabet_A)
        # cv2.imshow('B', alphabet_B)
        # cv2.imshow('C', alphabet_C)
        # cv2.imshow('D', alphabet_D)
        # cv2.imshow('N', alphabet_N)
        # cv2.imshow('S', alphabet_S)
        # cv2.imshow('E', alphabet_E)
        # cv2.imshow('W', alphabet_W)
        # k = cv2.waitKey(1) & 0xFF

        self.target_contours.append(('A',cont_A))
        self.target_contours.append(('B',cont_B))
        self.target_contours.append(('C',cont_C))
        self.target_contours.append(('D',cont_D))
        self.target_contours.append(('N',cont_N))
        self.target_contours.append(('S',cont_S))
        self.target_contours.append(('E',cont_E))
        self.target_contours.append(('W',cont_W))


    # def main():
    #     target = img_process(img)
    #     contours_im, hierachy = cv2.findContours(target, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    #     alphabets = find_items(target, contours_im)

    def get_alphabet_info(self, img):
        target_img = self.img_process(img)
        target_contours, contour_img = self.get_contour(target_img)
        alphabet, value = self.get_best_alphabet(target_img, target_contours)
        alphabet2, value2 = self.get_most_similar_alphabet(target_contours)
        # cv2.drawContours(img, contour, -1, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        return alphabet, value, alphabet2, value2, contour_img

    def get_most_similar_alphabet(self, contours):
        matches = []
        if len(contours) <= 0:
            return 0, 0
        for contour in contours:
            for alphabet, target in self.target_contours:
                match = cv2.matchShapes(contour[0], target[0], cv2.CONTOURS_MATCH_I3, 0.0)
                matches.append((alphabet, match))
                # print(alphabet, match)
            # print()
        matches.sort(key=lambda x : x[1])
        # 클 수록 다름?
        if len(matches) <= 0 :
            return 0, 0
        elif len(matches[0]) < 2 :
            return 0, 0
        return matches[0][0], matches[0][1]

    # def img_process(self, img):
        # target = cv2.medianBlur(img, 5)
        # med_val = np.median(target)
        # lower = int(max(0 ,0.7*med_val))
        # upper = int(min(255,1.3*med_val))

        # img_gray = cv2.cvtColor(target, cv2.COLOR_BGR2GRAY)
        # img_canny = cv2.Canny(img_gray, lower, upper)

        # kernel = np.ones((3, 3))
        # img_dilate = cv2.dilate(img_canny, kernel, iterations=2)
        # img_erode = cv2.erode(img_dilate, kernel, iterations=2)
        # return img_erode
    def get_contour(self, img):
        contours_im, _ = cv2.findContours(img, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        target_contours = []
        img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
        for contour in contours_im:
            x,y,w,h = cv2.boundingRect(contour)

            if w < 30 or h < 30 :
                continue
            if h/w >= tolerance or w/h >= tolerance:
                continue
            target_contours.append((contour, x, y, w, h))
            cv2.drawContours(img, contour, -1, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        print(len(target_contours))
        return target_contours, img

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

    def get_best_alphabet(self, target_img, target_contours):
        # alphabets = []
        max_weight = 0
        alphabet = ''
        cont = []
        for contour in target_contours:
            
            x,y,w,h = contour[1], contour[2], contour[3], contour[4]

            pil_img = Image.fromarray(target_img)
            cropped_img = pil_img.crop((x,y,x+w,y+h))

            # print(f'crop target : {x}, {w}, {y}, {h}')
            # cropped_img = target_img[y:y+h, x:x+w]
            # target_img = self.img_process(cropped_img)
            # data = self.to_tensor(cv2.resize(cropped_img, (32, 32)))
            data = self.to_tensor(cropped_img.resize((32,32)))
            result, weight = self.detect_alphabet(data)
            print(result, weight)
            

            if weight < answer_threshold :
                continue
            if max_weight < abs(weight):
                max_weight = abs(weight)
                alphabet = chr(result+ord('A'))
                # cont = contour
            # alphabets.append((contour, result, int(weight)))
        # cv2.drawContours(img, cont, -1, (random.randrange(0, 255), random.randrange(0, 255), random.randrange(0, 255)), 2)
        return alphabet, max_weight
