import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
from consts import *

def printshape(title, x):
  print(title, x.shape)

class MNISTNetwork(nn.Module):
    def __init__(self, D_in, H, D_out):
        super(MNISTNetwork, self).__init__()
        self.input_linear = nn.Linear(D_in, H)
        self.middle_layer = nn.Linear(H, H)
        self.output_linear = nn.Linear(H, D_out)

    def forward(self, x):
        h_relu = self.input_linear(x).clamp(min=0)
        h2_relu = self.middle_layer(h_relu).clamp(min=0)
        y_pred = self.output_linear(h2_relu)
        return y_pred


class ConvNetwork(nn.Module):
    def __init__(self):
        super(ConvNetwork, self).__init__()
        self.conv1 = nn.Conv2d(1, 50, (3, 3))
        nn.init.kaiming_uniform_(self.conv1.weight)
        self.bn1 = nn.BatchNorm2d(50)

        self.conv2 = nn.Conv2d(50, 100, (3, 3))
        nn.init.kaiming_uniform_(self.conv2.weight)
        self.maxpool2 = nn.MaxPool2d(2, stride=2)
        self.bn2 = nn.BatchNorm2d(100)

        self.conv3 = nn.Conv2d(100, 200, (3, 3))
        nn.init.kaiming_uniform_(self.conv3.weight)
        self.maxpool3 = nn.MaxPool2d(2, stride=2)
        self.bn3 = nn.BatchNorm2d(200)

        self.input_linear = nn.Linear(200*6*6, 500)
        self.middle_layer = nn.Linear(500, 800)
        self.drop_out1 = nn.Dropout(p=0.5)
        self.middle_layer2 = nn.Linear(800, 600)
        self.middle_layer3 = nn.Linear(600, 300)
        self.drop_out2 = nn.Dropout(p=0.5)
        self.middle_layer4 = nn.Linear(300, 100)
        self.output_linear = nn.Linear(100, 26)

        self.conv_module = nn.Sequential(
            self.conv1,
            nn.ReLU(),
            self.bn1,
            self.conv2,
            nn.ReLU(),
            self.maxpool2,
            self.bn2,
            self.conv3,
            nn.ReLU(),
            self.maxpool3,
            self.bn3
        )

        self.fc_module = nn.Sequential(
            self.input_linear,
            nn.ReLU(),
            self.middle_layer,
            nn.ReLU(),
            self.drop_out1,
            self.middle_layer2,
            nn.ReLU(),
            self.middle_layer3,
            nn.ReLU(),
            self.drop_out2,
            self.middle_layer4,
            nn.ReLU(),
            self.output_linear
        )

        if device == 'cuda':
          # gpu로 할당
          print('use cuda')
          self.conv_module = self.conv_module.cuda()
          self.fc_module = self.fc_module.cuda()

        nn.init.kaiming_uniform_(self.input_linear.weight)
        nn.init.kaiming_uniform_(self.middle_layer.weight)
        nn.init.kaiming_uniform_(self.middle_layer2.weight)
        nn.init.kaiming_uniform_(self.middle_layer3.weight)
        nn.init.kaiming_uniform_(self.middle_layer4.weight)
        nn.init.kaiming_uniform_(self.output_linear.weight)

    def forward(self, x):
        # x shape = batch(1) * 1024
        # conv required = batch(1)*32*32

        # 1*28*28 -> 200*3*3
        #printshape('x', x)

        # reshaped = x.view(-1, batch_size, 32, 32)
        # printshape('reshaped', reshaped)
        
        c1 = F.relu(self.bn1(self.conv1(x)))
        #printshape('c1', c1)

        c2 = F.relu(self.bn2(self.conv2(c1)))
        # printshape('c2', c2)

        mp2 = self.maxpool2(c2)
        # printshape('mp2', mp2)

        c3 = F.relu(self.bn3(self.conv3(mp2)))
        # printshape('c3', c3)

        mp3 = self.maxpool3(c3)
        # printshape('mp3', mp3)

        # 800*5*5 -> flat
        mp4_flat = mp3.view(-1, 6*6*200)
        # printshape('mp4_flat', mp4_flat)

        h_relu = F.relu(self.input_linear(mp4_flat))
        # printshape('h_relu', h_relu)

        h2_relu = F.relu(self.middle_layer(h_relu))
        # printshape('h2_relu', h2_relu)

        h2_drop = self.drop_out1(h2_relu)
        # printshape('h2_drop', h2_drop)

        h3_relu = F.relu(self.middle_layer2(h2_drop))
        # printshape('h3_relu', h3_relu)

        h4_relu = F.relu(self.middle_layer3(h3_relu))
        # printshape('h4_relu', h4_relu)

        h4_drop = self.drop_out2(h4_relu)
        # printshape('h4_drop', h4_drop)

        h5_relu = F.relu(self.middle_layer4(h4_drop))   # h5_drop = F.dropout(h5_relu, training=self.training)
        # printshape('h5_relu', h5_relu)

        y_pred = self.output_linear(h5_relu)
        # printshape('y_pred', y_pred)

        return F.log_softmax(y_pred, dim=1)