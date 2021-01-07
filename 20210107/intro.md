> 前天的推文里模仿论文中的散点图以原点为中心花了一个坐标轴，R语言的ggplot2画图通常坐标轴是在左下角，如果想把坐标轴改成以原点（0,0）为中心应该如何实现呢？经过搜索找到了一些办法，记录在这篇推文里。


参考的链接是https://stackoverflow.com/questions/17753101/center-x-and-y-axis-with-ggplot2

###### 第一步需要确定数据的范围，比如用鸢尾花的数据集花瓣长宽分别做x和y

用```summary()```函数看一下数据的范围
```

```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-57b56595456f2a32.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
最大值是6.9，那我们将坐标轴的范围设置为-7~7.

```
axis_begin<- -7
axis_end<-7
```
刻度设置为15个
```
total_ticks<-15
```

> 最终是通过```geom_segment()```函数来画坐标轴，所以需要先构造画图的数据

```
library(magrittr)#这个包里有管道符
tick_frame<-data.frame(ticks=seq(axis_begin,
                                 axis_end,
                                 length.out = total_ticks),
                       zero=0)%>%
  subset(ticks != 0)
tick_frame
label_frame<-data.frame(lab=seq(axis_begin,axis_end),
                        zero=0)%>%
  subset(lab!=0&abs(lab)!=7)
label_frame
```
###### 首先是基本的散点图
```
ggplot(iris,aes(x=Petal.Length,y=Petal.Width))+
  geom_point(color="red",size=3)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-015bf2d85aabc016.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 接下来简单修饰
包括
- 去灰色背景
- 更改坐标轴范围
- 添加最外圈的方框
- 去掉最外圈的文字和小短线
```
ggplot(iris,aes(x=Petal.Length,y=Petal.Width))+
  geom_point(color="red",size=3)+
  theme_bw()+
  scale_x_continuous(limits = c(-7,7))+
  scale_y_continuous(limits = c(-7,7))+
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-f3ea197649b86fdc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 添加坐标轴的线和刻度以及文字标签
```
ggplot(iris,aes(x=Petal.Length,y=Petal.Width))+
  geom_point(color="red",size=3)+
  theme_bw()+
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())+
  
  geom_segment(x=0,xend=0,y=-7,yend=7)+
  geom_segment(x=-7,xend=7,y=0,yend=0)+
  scale_x_continuous(expand = c(0,0),limits = c(-7,7))+
  scale_y_continuous(expand = c(0,0),limits = c(-7,7))+
  geom_segment(data=tick_frame,aes(x=zero,xend=zero+0.1,
                                   y=ticks,yend=ticks))+
  geom_segment(data=tick_frame,aes(x=ticks,xend=ticks,
                                   y=zero,yend=zero+0.1))+
  geom_text(data=label_frame,aes(x=zero-0.2,y=lab,label=lab))+
  geom_text(data=label_frame,aes(x=lab,y=zero-0.2,label=lab))
```
最终的效果如下
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9e960985bf69ef01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在前天的推文下有人留言直接把以上代码打包成了函数
```
draw_axis_line <- function(length_x,length_y,tick_step=NULL,lab_step=NULL){       
  axis_x_begin <- -1 * length_x    
  axis_x_end <- length_x    
  axis_y_begin  <- -1 * length_y    
  axis_y_end    <- length_y        
  if (missing(tick_step))        
    tick_step <- 1    
  if (is.null(lab_step))        
    lab_step <- 2        #axis ticks data    
  tick_x_frame <- data.frame(ticks=seq(axis_x_begin,axis_x_end,by=tick_step))    
  tick_y_frame <- data.frame(ticks=seq(axis_y_begin,axis_y_end,by=tick_step))    #axis labels data    
  lab_x_frame <- subset(data.frame(lab=seq(axis_x_begin,axis_x_end,by=lab_step),zero=0),lab!=0)    
  lab_y_frame <- subset(data.frame(lab=seq(axis_y_begin,axis_y_end,by=lab_step),zero=0),lab!=0)        #set tick length    
  tick_x_length <- 15/length(tick_x_frame$ticks)/2    
  tick_y_length <- 8/length(tick_y_frame$ticks)/2        #set zero point    
  data <- data.frame(x=0,y=0)
  library(ggplot2)
  p <- ggplot(data=data) +    #draw axis line    
    geom_segment(y=0,yend=0,x=axis_x_begin,xend=axis_x_end,size=0.5) +     
    geom_segment(x=0,xend=0,y=axis_y_begin,yend=axis_y_end,size=0.5) +    #draw x ticks    
    geom_segment(data=tick_x_frame,aes(x=ticks,xend=ticks,y=0,yend=0 + tick_x_length)) +    #draw y ticks    
    geom_segment(data=tick_y_frame,aes(x=0,xend=0 + tick_y_length,y=ticks,yend=ticks)) +     #labels    
    geom_text(data=lab_x_frame,aes(x=lab,y=zero,label=lab),vjust=1.5) +    
    geom_text(data=lab_y_frame,aes(x=zero,y=lab,label=lab),hjust=1.5) +    
    theme_void()        
  return(p)}
```
画图的时候直接用如下代码
```
draw_axis_line(20, 4)
```
20是x轴的范围，4是y轴的范围

最终的出图效果

![image.png](https://upload-images.jianshu.io/upload_images/6857799-848fe557b0ea5e1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 在文章开头提到的参考链接里，有人还提供了一个主题函数
```
theme_geometry <- function(xvals, yvals, xgeo = 0, ygeo = 0, 
                           color = "black", size = 1, 
                           xlab = "x", ylab = "y",
                           ticks = 10,
                           textsize = 3,
                           xlimit = max(abs(xvals),abs(yvals)),
                           ylimit = max(abs(yvals),abs(xvals)),
                           epsilon = max(xlimit,ylimit)/50){

  #INPUT:
  #xvals .- Values of x that will be plotted
  #yvals .- Values of y that will be plotted
  #xgeo  .- x intercept value for y axis
  #ygeo  .- y intercept value for x axis
  #color .- Default color for axis
  #size  .- Line size for axis
  #xlab  .- Label for x axis
  #ylab  .- Label for y axis
  #ticks .- Number of ticks to add to plot in each axis
  #textsize .- Size of text for ticks
  #xlimit .- Limit value for x axis 
  #ylimit .- Limit value for y axis
  #epsilon .- Parameter for small space


  #Create axis 
  xaxis <- data.frame(x_ax = c(-xlimit, xlimit), y_ax = rep(ygeo,2))
  yaxis <- data.frame(x_ax = rep(xgeo, 2), y_ax = c(-ylimit, ylimit))

  #Add axis
  theme.list <- 
  list(
    theme_void(), #Empty the current theme
    geom_line(aes(x = x_ax, y = y_ax), color = color, size = size, data = xaxis),
    geom_line(aes(x = x_ax, y = y_ax), color = color, size = size, data = yaxis),
    annotate("text", x = xlimit + 2*epsilon, y = ygeo, label = xlab, size = 2*textsize),
    annotate("text", x = xgeo, y = ylimit + 4*epsilon, label = ylab, size = 2*textsize),
    xlim(-xlimit - 7*epsilon, xlimit + 7*epsilon), #Add limits to make it square
    ylim(-ylimit - 7*epsilon, ylimit + 7*epsilon)  #Add limits to make it square
  )

  #Add ticks programatically
  ticks_x <- round(seq(-xlimit, xlimit, length.out = ticks),2)
  ticks_y <- round(seq(-ylimit, ylimit, length.out = ticks),2)

  #Add ticks of x axis
  nlist <- length(theme.list)
  for (k in 1:ticks){

    #Create data frame for ticks in x axis
    xtick <- data.frame(xt = rep(ticks_x[k], 2), 
                        yt = c(xgeo + epsilon, xgeo - epsilon))

    #Create data frame for ticks in y axis
    ytick <- data.frame(xt = c(ygeo + epsilon, ygeo - epsilon), 
                        yt = rep(ticks_y[k], 2))

    #Add ticks to geom line for x axis
    theme.list[[nlist + 4*k-3]] <- geom_line(aes(x = xt, y = yt), 
                                         data = xtick, size = size, 
                                         color = color)

    #Add labels to the x-ticks
    theme.list[[nlist + 4*k-2]] <- annotate("text", 
                                            x = ticks_x[k], 
                                            y = ygeo - 2.5*epsilon,
                                            size = textsize,
                                            label = paste(ticks_x[k]))


    #Add ticks to geom line for y axis
    theme.list[[nlist + 4*k-1]] <- geom_line(aes(x = xt, y = yt), 
                                             data = ytick, size = size, 
                                             color = color)

    #Add labels to the y-ticks
    theme.list[[nlist + 4*k]] <- annotate("text", 
                                            x = xgeo - 2.5*epsilon, 
                                            y = ticks_y[k],
                                            size = textsize,
                                            label = paste(ticks_y[k]))
  }

  #Add theme
  #theme.list[[3]] <- 
  return(theme.list)
}
```
画图代码
```
simdata <- data.frame(x = rnorm(50), y = rnorm(50))

ggplot(simdata) +
  theme_geometry(simdata$x, simdata$y) +
  geom_point(aes(x = x, y = y), size = 3, color = "red") + 
  ggtitle("More geometric example")
```

最终效果如下
![image.png](https://upload-images.jianshu.io/upload_images/6857799-e97f2a5ddbbf5f87.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

欢迎大家关注我的公众号
**小明的数据分析笔记本留言讨论**

![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-a9908bae33fcff58.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
