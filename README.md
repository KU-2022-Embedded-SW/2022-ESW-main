# 2022-ESW-main
2022 임베디드 소프트웨어 경진대회

### Arrow Detection
1. Canny 알고리즘으로 edge 정보 생성
2. Contour 찾기
3. Contour 근사화
4. Contour 다각화


### Alphabet Detection
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
