# 看篮球学R语言数据可视化~詹姆斯上一次得分没有上双是什么时候？


> 公众号 **小明的数据分析笔记本** 分享R语言做数据分析和数据可视化的简单小例子，欢迎大家关注

![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-e34032b26deddff7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 在知乎看到的这个问题，作为一个喜欢篮球的R语言学习者，这个问题好像也不难，找到詹姆斯职业生涯的数据，画个折线图就看出来了！下面就开始！

###### 数据来源

https://www.basketball-reference.com/

在这个链接能够找到所有球员的数据

> 最初是想写爬虫直接爬数据的，奈何学艺不精，想不起来如何爬了！算了，手动来吧，反正也不多。

将常规赛数据和季后赛数据分别存储到csv文件里

![image.png](https://upload-images.jianshu.io/upload_images/6857799-7256669f781419c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 首先来探索常规赛的数据
###### 第一步整合数据
```
library(dplyr)
#library(readr)
regular_season_all<-list.files(path = "LeBron_James/regular_season/",
                               pattern = "*.csv",full.names = T)
df<-data.frame(Date=character(),
               Age=character(),
               Tm=character(),
               Opp=character(),
               W_or_L=character(),
               MP=character(),
               PTS=character())
for (i in 1:17){
  df1<-read.csv(regular_season_all[i])
  df1%>%
    select(Date,Age,Tm,Opp,X.1,MP,PTS) -> df1.1
  colnames(df1.1)<-c("Date","Age","Tm","Opp","W_or_L","MP","PTS")
  df1.1[nchar(df1.1$PTS) <=2,] -> df1.2
  df<-rbind(df,df1.2)
}
dim(df)
tail(df)
write.csv(df,file = "LeBron_James/LeBron_James_regular_season_pts.csv",
          quote = F,row.names = F)
```
这样数据集就存储到了```df```这个里，新的数据集里包括

![image.png](https://upload-images.jianshu.io/upload_images/6857799-5624b7498a29b736.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

新的数据集里包括
- 比赛时间 Date
- 年龄 Age
- 球队 Tm
- 对手 Opp
- 胜负 W_or_L
- 上场时间 MP
- 得分 PTS

数据集总共包括1266场比赛的信息（不包括20-21赛季）
![image.png](https://upload-images.jianshu.io/upload_images/6857799-83c9005cc804c057.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 首先用柱形图来展示一下詹姆斯的常规赛的胜负场次
这一步检查数据的时候发现得分里还有一个缺失值，把这个缺失值去掉。新的数据集包括1265场常规赛
```
df<-read.csv(file = "LeBron_James/LeBron_James_regular_season_pts.csv",
             header=T)
summary(df)
df<-df[!is.na(df$PTS),]
library(stringr)
df$wl<-str_sub(df$W_or_L,1,1)
df1<-data.frame(table(df$wl))
df1
library(ggplot2)
#library(extrafont)
#fonts()
df1$Var1<-factor(df1$Var1,
                 levels = c("W","L"),
                 labels = c("胜","负"))
ggplot(df1,aes(x=Var1,y=Freq))+
  geom_col(aes(fill=Var1))+
  geom_label(aes(label=Freq))+
  theme_void()+
  theme(legend.title = element_blank(),
        legend.position = "top")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-0fe434483e4258bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 接下来就是折线图看得分
```
df$x<-1:dim(df)[1]  
head(df)
df$group<-ifelse(df$PTS<10,"A","B")
pdf(file = "pts.pdf",width = 20)
ggplot(df,aes(x=x,y=PTS))+
  geom_line(color="#CAB2D6")+
  geom_point(aes(color=group),show.legend = F)+
  theme_bw()+
  geom_hline(yintercept = 10,lty="dashed")+
  geom_hline(yintercept = 60,lty="dashed")+
  theme(axis.ticks.x = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_blank())+
  scale_y_continuous(breaks = c(10,20,30,40,50,60))+
  scale_color_manual(values = c("#C40003","#00C19B"))
dev.off()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-e07d74564eb1c3ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 从上图我们可以看到詹姆斯在常规赛只有8场比赛得分没有上双，**最近的一次是2007年1月5号对阵雄鹿队**

### 下面来探索季后赛的数据
###### 第一步还是整合数据
```
###playoffs
playoffs_all<-list.files(path = "LeBron_James/playoffs/",
                         pattern = "*.csv",full.names = T)
playoffs_all
df<-data.frame(Date=character(),
               Age=character(),
               Tm=character(),
               Opp=character(),
               W_or_L=character(),
               MP=character(),
               PTS=character())
for (i in 1:14){
  df1<-read.csv(playoffs_all[i])
  df1%>%
    select(Date,Age,Tm,Opp,X.1,MP,PTS) -> df1.1
  colnames(df1.1)<-c("Date","Age","Tm","Opp","W_or_L","MP","PTS")
  df1.1[nchar(df1.1$PTS) <=2,] -> df1.2
  df<-rbind(df,df1.2)
}
dim(df)
tail(df)
head(df)
summary(df)
write.csv(df,file = "LeBron_James/LeBron_James_playoffs_pts.csv",
          quote = F,row.names = F)
```
###### 还是首先来看季后赛的胜率
```
df<-read.csv("LeBron_James/LeBron_James_playoffs_pts.csv",
             header=T)

df$wl<-str_sub(df$W_or_L,1,1)
df1<-data.frame(table(df$wl))
df1

df1$Var1<-factor(df1$Var1,
                 levels = c("W","L"),
                 labels = c("胜","负"))
ggplot(df1,aes(x=Var1,y=Freq))+
  geom_col(aes(fill=Var1))+
  geom_label(aes(label=Freq))+
  theme_void()+
  theme(legend.title = element_blank(),
        legend.position = "top")+
  ggtitle("Playoffs")+
  labs(caption = "Data Source:https://www.basketball-reference.com/")

```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-3dce1fab596d42ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 季后赛得分没有能够上双的比赛
```
df$x<-1:dim(df)[1]  
head(df)
df$group<-ifelse(df$PTS<10,"A","B")
#pdf(file = "pts.pdf",width = 20)
ggplot(df,aes(x=x,y=PTS))+
  geom_line(color="#CAB2D6")+
  geom_point(aes(color=group),show.legend = F)+
  theme_bw()+
  geom_hline(yintercept = 10,lty="dashed")+
  geom_hline(yintercept = 50,lty="dashed")+
  theme(axis.ticks.x = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_blank())+
  scale_y_continuous(breaks = c(10,20,30,40,50))+
  scale_color_manual(values = c("#C40003","#00C19B"))
#dev.off()
df[df$group=="A",]
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-903304e8507686c1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 从上图可以看出詹姆斯260场季后赛只有2场比赛得分没有上双，**分别是2011年6月七号对阵达拉斯小牛对和2014年5月8号对阵印第安纳步行者队**

> 最后就回答文章标题提到的问题：**詹姆斯上一次得分没有上双是2014年5月8号**

欢迎大家关注我的公众号
**小明的数据分析笔记本**

![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-f777667e602e8745.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 如果需要文章中的数据和代码，可以**先点赞**，然后**点击在看** 接着留言就好了！