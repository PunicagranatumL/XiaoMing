# R语言ggtree按照指定的节点旋转树

> R语言里的ggtree这个包可视化进化树有一个默认的顺序，如果想要改变枝的相对位置应该如何实现呢？通过查找ggtree作者写的帮助文档找到了对应的办法，可以使用```rotate()```函数

ggtree的帮助文档链接

http://yulab-smu.top/treedata-book/index.html

###### 首先我们使用R语言内置的数据集mtcars做一个层次聚类
```
mtcars
df<-mtcars[,c(1,3:6)]
df
df.hclust<-hclust(dist(df))
```
###### 接下来使用ggtree对层次聚类的结果进行展示
```
library(ggtree)
ggtree(df.hclust)+
  geom_tiplab(offset = 2)+
  xlim(NA,280)+
  geom_highlight(node = 34,fill="blue")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9568eb957df78868.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 我们看到图上标记蓝色的一个分支默认是在最底下的，如果想要把这个分支放到顶上应该如何修改呢？可以直接用ggtree中的```rotate()```函数。```rotate()```接受两个参数，一个是需要旋转的节点。另外一个就是树

###### 先通过geom_text()函数给每个节点添加上文字标签
```
ggtree(df.hclust)+
  geom_tiplab(offset = 2)+
  xlim(NA,280)+
  geom_text(aes(label=node))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9d96e50e4e85dcc2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 通过上图我们看到需要旋转的是33节点

```
p1<-ggtree(df.hclust)+
  geom_tiplab(offset = 2)+
  xlim(NA,280)
  #geom_highlight(node = 34,fill="blue")
p2<-ggtree::rotate(p1,33)
p2+
  geom_hilight(node=34,fill="blue")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9d4e37571d321da6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样就把这一大块放到上面去了。

> 细心的读者可能发现了，这里在使用rotate（）这个函数的时候写法是```ggtree::rotate(p1,33)```,这样是为了使用指定包里的某个函数，因为R语言里的函数很多，有可能会重名，有时候你用到的函数可能并不是想实现功能的那个函数，所以比较保险的做法还是加上包的命名然后用两个冒号链接函数


###### 还有一个知识点是如果想要这个树的开口朝下（现在是开口朝又），可以加
```
ggtree(df.hclust)+
  geom_tiplab(angle=90,offset = -70)+
  layout_dendrogram()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-76de1c2c064698a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

欢迎大家关注我的公众号
**小明的数据分析笔记本**

