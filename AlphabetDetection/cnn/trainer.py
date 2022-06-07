import train
import torch
from consts import *


def train_many():
    for idx in range(0, 5):
        filename = "/content/drive/MyDrive/AlphabetDetection/result_"+str(idx)+".pt"
        net = train.train_mnist(idx)
        torch.save(net, filename)
        print("Model "+filename+" saved")


def train_only():
    filename = "result_only.pt"
    net = train.train_mnist(1)
    torch.save(net, filename)
    print("Model " + filename + " saved")


if __name__ == "__main__":
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print(device + " is available")
    train_many()