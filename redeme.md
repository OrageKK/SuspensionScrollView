## SuspensionScrollView

> 底部ScrollView 中部切换view可悬停 底部两个列表分别是tableview
>



### 此例子只是探索悬停，同时解决了嵌套Scrollview的手势冲突问题，将下tableview滑动到悬停位置后，不需要松开手指可继续向上滑动。



### 原理 ：向上滑动滑动的是底部mainScrollView，然后到达悬停位置后，设置下边tableview的contentoffset。

[![0q5Vc.md.png](https://storage1.cuntuku.com/2018/09/14/0q5Vc.md.png)](https://cuntuku.com/image/0q5Vc)

[![0qes7.md.png](https://storage7.cuntuku.com/2018/09/14/0qes7.md.png)](https://cuntuku.com/image/0qes7)