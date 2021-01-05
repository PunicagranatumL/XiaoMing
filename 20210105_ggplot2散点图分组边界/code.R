df<-read.csv('irispca.csv',row.names = 1,header=T)
head(df)

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
