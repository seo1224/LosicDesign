* 작동원리

9ms의 1과 4ms의 0, 즉 leader code를 선두로 custom code, data code를 읽어 그 버튼에 해당하는 value를 LED에 표시하게 된다.  

이때  9ms의 1과 4ms의 0의 신호는 어떻게 읽는거냐면
clock이 1Mhz로 움직이면서, 계속 1일 때 cnt_h에 1을 저장하고 계속 0일 때 cnt_l에 1을 저장하게 된다. 단, 0에서 1로 변할 때는 cnt_h와 cnt_l가 0이 된다. 
예를 들어 9ms 동안 1이면 cnt_h에 9000이 되고 4ms동안 0이면  cnt_l에 4000이 되는것이다. 이런식으로 두 변수에 저장된 값을 비교하여 leader code, custom code, data code를 읽을 수 있다.

![](https://github.com/seo1224/LosicDesign/blob/master/practice09/wave.png?raw=true)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2NjAzNTMyMjddfQ==
-->