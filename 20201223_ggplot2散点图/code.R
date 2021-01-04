df1<-read.csv("scatterplot.csv",header=T)
library(ggplot2)
ggplot(df1,aes(x=Species.Rank,y=Cumultative.relative.abundance))+
  geom_point()+
  scale_y_log10(breaks=c(100,10000),
                labels=c(100,10000))+
  geom_text_repel(aes(label=text_label))+
  theme(panel.background = element_blank(),
        axis.line = element_line())