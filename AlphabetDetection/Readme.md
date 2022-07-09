## Alphabet detection
1. 이미지 전처리
2. Contour 찾기
3. 노이즈 제거 후 후보 contour 정리
4. 알파벳 인식 모델 통과, Th=0.7보다 높으면 알파벳으로 처리
* 학습 결과

![result_image_train](https://github.com/KU-2022-Embedded-SW/2022-ESW-main/blob/main/ReportImages/alphabet_detection_train_result.jpg)
* 모델 링크 : [링크](https://drive.google.com/drive/folders/1ic6IRprpYnCIdwzm6b53zqGvKN6z0605?usp=sharing)
* 모델 적용 결과

![result_image_cnn](https://github.com/KU-2022-Embedded-SW/2022-ESW-main/blob/main/ReportImages/alphabet_detection_result_cnn_model.jpg)

* 코드 개선 방안
[네이버 D2 블로그 링크](https://d2.naver.com/helloworld/8344782)

* 실행 가이드
1. 필요 라이브러리 설치
```
pip install pytorch
pip install opencv-python
pip install pillow
```
2. [링크](https://drive.google.com/drive/folders/1ic6IRprpYnCIdwzm6b53zqGvKN6z0605?usp=sharing)에서 ```.pt``` 확장자 파일 5개를 받아 ./model 폴더에 위치시킨다.
3. ```alphabet_detector.py```의 14번째 줄은 전 단계에서 받은 모델을 불러오는 코드이다. 모델이 위치한 경로가 정확한지 확인하여야 한다.
```
models.append(torch.load('AlphabetDetection/model/result_{}.pt'.format(i), map_location=torch.device('cpu')))
```
4. main.py를 실행
