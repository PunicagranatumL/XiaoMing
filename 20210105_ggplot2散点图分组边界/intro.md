# 跟着Nature microbiology学画图~ggplot2散点图添加分组边界


> 今天要模仿的图片来自于论文 **Core gut microbial communities are maintained by beneficial interactions and strain variability in fish**。期刊是 **Nature microbiology** 

![image.png](https://upload-images.jianshu.io/upload_images/6857799-83a5905172e28101.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

今天重复论文中Figure4中的小b这幅图

![image.png](https://upload-images.jianshu.io/upload_images/6857799-8b6ab2f99bff0fab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 论文中他实际做的分析是主坐标分析(Principal coordinates analysis of samples)，今天的推文内容不涉及分析过程，只讨论作图。用到的示例数据是鸢尾花的数据集做完主成分分析的结果。**需要示例数据的可以在文末留言**

###### 数据格式
![image.png](https://upload-images.jianshu.io/upload_images/6857799-80f70069a4a36fa1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 第一步读入数据
```
df<-read.csv('irispca.csv',row.names = 1,header=T)
head(df)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-cb74e92988377a38.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 基本的散点图，根据group分组来映射颜色和形状
```
library(ggplot2)
ggplot()+
  geom_point(data=df,aes(x=PC1,y=PC2,
                         color=group,shape=group),
             size=2)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-2809afd130d4407c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 接下来是一些简单的美化
```
ggplot()+
  geom_point(data=df,aes(x=PC1,y=PC2,
                         color=group,shape=group),
             size=3)+
  theme_bw()+
  theme(panel.background = element_blank(),
        panel.grid = element_blank(),
        legend.title = element_text(hjust=0.5))+
  labs(x="Coordinate 1 (15%)",y="Coordinate 2 (8%)")+
  scale_color_manual(values = c("#008080","#ffa500","#8b008b"))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-65d1516a607a350c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 接下来是添加分组边界
添加分组边界主要参考了文章
https://chrischizinski.github.io/rstats/vegan-ggplot2/

> 添加分组边界用到的是```geom_polygon()```函数，这里需要借助```chull()```函数重新构造一份数据。```chull()```函数是我第一次接触，具体作用我还得在学习一下，用如下代码可以解决问题，**但是代码具体的作用我还得再研究一下**

###### 比如给setosa这一组数据添加分组边界
构造一份新的数据 集
```
df1<-df[df$group=="setosa",][chull(
  df[df$group=="setosa",c("PC1","PC2")]
),]
```
画图
```
ggplot()+
  geom_point(data=df,aes(x=PC1,y=PC2,
                         color=group,shape=group),
             size=3)+
  theme_bw()+
  theme(panel.background = element_blank(),
        panel.grid = element_blank(),
        legend.title = element_text(hjust=0.5))+
  labs(x="Coordinate 1 (15%)",y="Coordinate 2 (8%)")+
  scale_color_manual(values = c("#008080","#ffa500","#8b008b"))+
  geom_polygon(data=df1,aes(x=PC1,y=PC2,group=group),
               color="#008080",fill="#008080",alpha=0.2,size=1)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-c736de5c550b222c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 按照这个思路再给另外两个品种添加分类边界就好了

```
library(ggplot2)
table(df$group)
df1<-df[df$group=="setosa",][chull(
  df[df$group=="setosa",c("PC1","PC2")]
),]
df2<-df[df$group=="versicolor",][chull(
  df[df$group=="versicolor",c("PC1","PC2")]
),]
df3<-df[df$group=="virginica",][chull(
  df[df$group=="virginica",c("PC1","PC2")]
),]
ggplot()+
  geom_point(data=df,aes(x=PC1,y=PC2,
                         color=group,shape=group),
             size=3)+
  theme_bw()+
  theme(panel.background = element_blank(),
        panel.grid = element_blank(),
        legend.title = element_text(hjust=0.5))+
  labs(x="Coordinate 1 (15%)",y="Coordinate 2 (8%)")+
  scale_color_manual(values = c("#008080","#ffa500","#8b008b"))+
  geom_polygon(data=df1,aes(x=PC1,y=PC2,group=group),
               color="#008080",fill="#008080",alpha=0.2,size=1)+
  geom_polygon(data=df2,aes(x=PC1,y=PC2,group=group),
               color="#ffa500",fill="#ffa500",alpha=0.2,size=1)+
  geom_polygon(data=df3,aes(x=PC1,y=PC2,group=group),
               color="#8b008b",fill="#8b008b",alpha=0.2,size=1)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-4c15cd38af911ef2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 这个图相比于论文中的图还有一个不一样的地方是：**他画坐标轴是以（0,0）原点为中心的**，那么在ggplot2里应该如何实现呢？欢迎大家留言讨论呀！

欢迎大家关注我的公众号
**小明的数据分析笔记本**
![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-be0839fb18e31f15.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 示例数据可以直接留言获取

