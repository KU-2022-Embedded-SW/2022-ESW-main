import glob
import torch
from torchvision import transforms
from PIL import Image
import numpy as np
from torch.utils.data import Dataset, DataLoader


class AlphabetDataset(Dataset):
    path = '/content/drive/MyDrive/AlphabetDetection/character_font.npz'
    def __init__(self, path = path, train=True, transform=None):
        np_data = np.load('/content/drive/MyDrive/AlphabetDetection/character_font.npz')
        self.path = path
        
        self.images = np_data['images']
        self.lables = np_data['labels']
        
        self.transform = transform

        
    def __len__(self):
        return len(self.images)
    
    def __getitem__(self, idx):
        pixels = self.images[idx]
        label = self.lables[idx]

        pixel_data = self.images[idx]
        # pixel_data = np.ravel(pixel_data, order='C').tolist()

        pixel_data = np.expand_dims(pixel_data, 0)
        torch_pixel = torch.from_numpy(pixel_data)
        torch_float_pixel_data = torch_pixel.type(torch.FloatTensor)
        torch_float_pixel_data = torch_float_pixel_data / 255

        label = np.expand_dims(label, 0)
        torch_label = torch.from_numpy(label)
        torch_float_label_data = torch_label.type(torch.LongTensor)

        return torch_float_pixel_data, torch_float_label_data