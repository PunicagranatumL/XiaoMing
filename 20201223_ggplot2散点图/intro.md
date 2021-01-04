# 跟着Nature microbiology学画图~R语言ggplot2画散点图


> 今天要模仿的图片来自于论文 **Core gut microbial communities are maintained by beneficial interactions and strain variability in fish**。期刊是 **Nature microbiology** 

![image.png](https://upload-images.jianshu.io/upload_images/6857799-83a5905172e28101.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

重复的图片是Figure2中的散点图

![image.png](https://upload-images.jianshu.io/upload_images/6857799-be795433974855ed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 这个图看起来有些像折线图，是因为散点太密集了

###### 第一步是准备数据
数据总共三列，一列x，一列y，还有一列是文字标签，想给哪个点添加文字标签，对应就在这一行写上文字标签的内容，不想添加就是空白

> **需要示例数据的可以直接留言，觉得本期推文还有帮助的话可以转发支持呀！**

数据格式部分截图
![image.png](https://upload-images.jianshu.io/upload_images/6857799-aa7f7a2273c1aeaa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 读入数据
这里介绍一个相对方便一点的读入数据方式，数据按照以上格式准备好，然后全选，右击选择复制，接下来打开R语言运行如下命令
```
df1<-read.table("clipboard",header=T,sep="\t")
```
这样就把数据读进来存储到df1里了
###### 简单的散点图
```
ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-590006cdceea397d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 对y轴的值进行log10转化，有两种方式
- 第一种是直接对y进行log10，如下
```
ggplot(df1,aes(x=Species.Rank,
               y=log10(Cumultative.relative.abundance)))+
  geom_point()
```
- 第二种是叠加 ```scale_y_log10()```函数
```
ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9aa90bf7cd7cb20d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这两种方法大家可以观察一下结果图

###### 接下来就是添加文字标签
可以使用```geom_text()```或者```geom_label()```函数，```geom_label()```函数默认在文字外面有一个边框
```
p1<-ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10()+
  geom_text(aes(label=text_label))
p1
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-323715a996a2b7a9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果用```geom_label()```函数的话是如下效果
```
p2<-ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10()+
  geom_label(aes(label=text_label))
p2
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-469995a90d7a15eb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这是因为即使没有文字，```geom_label()```也会在对应的位置添加文字边框

###### 添加文字标签的时候与对应的点有些重叠，可以选择出图后手动调整，也可以选择另外一个R包```ggrepel```里的```geom_text_repel()```函数,它可以自动调整文字标签和点的位置
```
library(ggrepel)

ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10()+
  geom_text_repel(aes(label=text_label))
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-397272a49bacfac8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样效果好像也不是太好，还是出图后手动调整吧！

###### 接下来是简单的美化，包括
- 去掉灰色背景
- 更改y轴默认的刻度分隔点，现在是100,1000,10000，三个分隔，把它改成100,10000两个分隔
```
ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10(breaks=c(100,10000),
                labels=c(100,10000))+
  geom_text_repel(aes(label=text_label))+
  theme(panel.background = element_blank(),
        axis.line = element_line())
```

![image.png](https://upload-images.jianshu.io/upload_images/6857799-92b8e2990d56e6a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

欢迎大家关注我的公众号
**小明的数据分析笔记本**


