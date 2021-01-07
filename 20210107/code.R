summary(iris)
axis_begin<- -7
axis_end<-7
total_ticks<-15

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
colnames(iris)
library(ggplot2)
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

