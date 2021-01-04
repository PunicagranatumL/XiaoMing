df<-read.csv("bubble_plot_example.csv",
             header=T)
df1<-reshape2::melt(df)

library(ggplot2)

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