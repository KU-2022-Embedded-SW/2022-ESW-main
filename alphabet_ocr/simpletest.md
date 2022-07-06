from PIL import Image

import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract'
text = pytesseract.image_to_string(Image.open("test_image.jpg"))
print(text)
print(text.replace("",""))

![test_image](https://user-images.githubusercontent.com/91280867/177550386-7537a011-df6f-4d01-b02a-c0ded028e0b9.jpg)



C:\Users\박현준\AppData\Local\Programs\Python\Python39\python.exe C:/Users/박현준/Desktop/alphabet_ocr/main.py
ABCDEFG
HIJKULMN
OPQRSTU

ABCDEFG
HIJKULMN
OPQRSTU


