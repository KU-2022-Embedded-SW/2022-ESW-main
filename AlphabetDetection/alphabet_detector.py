import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import torch.optim as optim
from networks import ConvNetwork
from consts import *
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

models = []

for i in range(0, 5):
    models.append(torch.load('AlphabetDetection/model/result_{}.pt'.format(i), map_location=torch.device('cpu')))
    models[i].eval()
    print('model loaded!')

def alphabet_detector(raw_data):
    data = raw_data.view(-1, 1, 32, 32)
    result = torch.zeros([1, 26], dtype=torch.float64)

    for i in range(0, 5):
        output = models[i](data)
        # selected = output.argmax(dim=1, keepdim=True).numpy()
        # selected = selected.squeeze()
        # print('model {} : {}'.format(i, selected))
        result += output.squeeze()
    
    
    overall = result.argmax(dim=1, keepdim=True).numpy().squeeze()
    ans_weight = result.squeeze().detach().numpy()[overall]
    # print('Overall result : {}'.format(overall))
    return overall, ans_weight
    



