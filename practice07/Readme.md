# Lab 07

## [](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/Readme.md#%EC%8B%A4%EC%8A%B5-%EB%82%B4%EC%9A%A9)실습 내용

### [](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/Readme.md#%EB%94%94%EC%A7%80%ED%84%B8-%EC%8B%9C%EA%B3%84-%EB%B6%84%EC%B4%88-%EB%B6%80%EB%B6%84-%EC%84%A4%EA%B3%84---debounce-%EC%A0%81%EC%9A%A9-%EC%A0%84)**디지털 시계 (분:초) 부분 설계 - Debounce 적용 전**

[![](https://github.com/woongchoi-sookmyung/LogicDesign/raw/master/practice07/figs/block_diagram.png)](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/figs/block_diagram.png)

: GitHub에 제공된 소스코드 사용 - 다른 모듈 건드리지 말 것

: top module (top_hms_clock) 만 채워서 설계

: 이번 실습은 Test Bench 생략가능 (ModelSim 검증하고 FPGA 하는게 더 빠른 경우가 많음)

### [](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/Readme.md#fpga)**FPGA**

: 스위치의 Bounce 현상에대해관찰

: 코드를 수정하여 Debounce적용후 스위치 테스트 (Controller 부분 수정)

### [](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/Readme.md#quiz)**Quiz**

-   코드에서  `i_sw2`를 누르는 순간이 아닌  `때는 순간 숫자가 증가`하게 하려면? (모드 변경할 때 다른 숫자들 올라가는 건 무시) 



### [](https://github.com/woongchoi-sookmyung/LogicDesign/blob/master/practice07/Readme.md#project-guide--%EC%A7%88%EC%9D%98%EC%9D%91%EB%8B%B5%EB%B6%88%EA%B0%80)**Project Guide : 질의응답불가**

: 시:분:초에 대한 디지털 시계 완성

: 설정모드에서 7-segment의 dp를 활용한 설계

-   예)초 설정 시 - 초 부분의 dp led를 점등

: Blink 모드개발

-   설정모드에서 설정부분을 깜빡이게 Display


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbOTAyMzE2ODE3LC0xNTY4MDcyODkxXX0=
-->