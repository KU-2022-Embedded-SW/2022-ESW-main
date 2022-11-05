import data_loader
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import torch.optim as optim
import random
import time
import math
import networks
from networks import ConvNetwork
from trainer import batch_size, device
from consts import *

from AlphabetDataset import AlphabetDataset
from torch.utils.data import Dataset, DataLoader

dataset = AlphabetDataset()
dataloader = DataLoader(dataset = dataset, batch_size = batch_size, shuffle=True, drop_last=False)

def visualize(line_idx):
    raw_0 = raw_data[line_idx]
    for idx in range(TIDE):
        linestr = ''
        for idx2 in range(TIDE):
            pixelstr = str(raw_0[idx*TIDE+idx2])
            linestr += ' '*(4-len(pixelstr)) + pixelstr
        print(linestr)


raw_data = data_loader.load_train_data()


def train_mnist(n):
    net = networks.ConvNetwork().to(device)
    criterion = nn.CrossEntropyLoss().to(device)
    optimizer = optim.Adam(net.parameters(), lr=0.0001)

    net.train()
    for epoch in range(1, 15):
        # random_idxs = []
        # for ridx in range(batch_size):
        #     random_idxs.append(random.randint(0, 389764))
        for batch_idx, samples in enumerate(dataloader):
          x_train, y_train = samples
          x_train = x_train.to(device)
          y_train = y_train.to(device)
          prob = net(x_train).to(device)
          loss = criterion(prob, y_train.squeeze(dim=-1))
          optimizer.zero_grad()
          loss.backward()
          optimizer.step()
          print(f'train {n}, epoch {epoch}, batch {batch_idx}/{len(dataloader)}, loss: {loss}')
        # current_time = time.time() - start_time
        # x, y = so_compli.get_train_image_tensor(raw_data, idx)
        # x = x.to(device)
        # y = y.to(device)
        # prob = net(x).to(device)
        # loss = criterion(prob, y)
        # optimizer.zero_grad()
        # loss.backward()
        # optimizer.step()
        # study_rate = idx*batch_size/(current_time+0.00000001)
        # print(f'train {n}, {idx * batch_size},  time:{float(current_time):.5f},  loss: {loss}, rate: {float(study_rate):.5f}')
    return net



# visualize(2)
# x, y = get_image_tensor(2)
# print(net(x))
# #print(raw_data[2][0])
# v, i = torch.max(net(x), 1)
# print(v, i)
# print(i.data.numpy()[0])