# 跟着Nature microbiology学画图~R语言ggplot2画气泡图


> 今天要模仿的图片来自于论文 **Core gut microbial communities are maintained by beneficial interactions and strain variability in fish**。期刊是 **Nature microbiology** 

![image.png](https://upload-images.jianshu.io/upload_images/6857799-83a5905172e28101.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

今天重复的图片是Figure2中的气泡图

![image.png](https://upload-images.jianshu.io/upload_images/6857799-37376085bdd67938.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 首先是准备数据
![image.png](https://upload-images.jianshu.io/upload_images/6857799-210e9082a2911df0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> **需要练习数据可以直接在文末留言**

###### 读入数据
```
df<-read.csv("example_data/bubble_plot_example.csv",
             header=T)
df
```
###### 读入的数据是宽格式，ggplot2作图需要用长格式数据，对宽格式数据进行转化
```
df1<-reshape2::melt(df)
df1
```
###### 最基本的散点图
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-1fe867ba90dc1fa3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 用数值来映射颜色和大小
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-6d32eca7cadb51f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 接下来是进行美化
###### 去掉灰色背景
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank())
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-04f978881ad2f150.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###### 添加网格线
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-5166b4efeb9cd0e6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###### 去掉坐标轴的标题和更改x轴字体的方向和字体的颜色
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x=element_text(angle = 45,hjust = 1,
                                 colour = c("red","red","red","red",
                                            "green","red","yellow")))

```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-ab31fb0ea40540df.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 接下来是更改图例的一些操作
###### 首先是去掉颜色的图例
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x=element_text(angle = 45,hjust = 1,
                                 colour = c("red","red","red","red",
                                            "green","red","yellow")))+
  guides(color=FALSE)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-07ae8f92c7b733d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###### 更改图例的位置
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        axis.text.x=element_text(angle = 45,hjust = 1,
                                 colour = c("red","red","red","red",
                                            "green","red","yellow")))+
  guides(color=FALSE)
```
###### 更改图例的标题和标题的位置
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        axis.text.x=element_text(angle = 45,hjust = 1,
                                 colour = c("red","red","red","red",
                                            "green","red","yellow")))+
  guides(color=FALSE,
         size=guide_legend(title.position = "top",
                           title.hjust = 0.5))+
  labs(size="Relative abundance (%)")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9197b89ad2383108.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 最后更改一下填充颜色和点的大小
```
ggplot(df1,aes(x=x,y=variable))+
  geom_point(aes(color=value,size=value))+
  theme(panel.background = element_blank(),
        panel.grid = element_line(color="grey"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        axis.text.x=element_text(angle = 45,hjust = 1,
                                 colour = c("red","red","red","red",
                                            "green","red","yellow")))+
  guides(color=FALSE,
         size=guide_legend(title.position = "top",
                           title.hjust = 0.5,
                           override.aes = 
                             list(size=c(1,2,3,4))))+
  labs(size="Relative abundance (%)")+
  scale_color_viridis_c()+
  scale_size_continuous(range = c(1,20))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-7cc0e0e98c6d4525.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


欢迎大家关注我的公众号
**小明的数据分析笔记本**

