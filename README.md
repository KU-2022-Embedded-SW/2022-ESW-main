# 2022-ESW-main
2022 임베디드 소프트웨어 경진대회

### Arrow Detection
1. Canny 알고리즘으로 edge 정보 생성
2. Contour 찾기
3. Contour 근사화
4. Contour 다각화

### raspberry pi camera test
```
libcamera-jpeg -o test.jpg
```

### raspberry pi serial comm test
```
python -m serial.tools.miniterm /dev/ttyACM0
```

### dependency
```
pip install opencv-python matplotlib torch pyserial
```