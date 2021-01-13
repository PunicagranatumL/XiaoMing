mtcars
df<-mtcars[,c(1,3:6)]
df
df.hclust<-hclust(dist(df))

library(ggtree)
ggtree(df.hclust)+
  geom_tiplab(angle=90,offset = -70)+
  layout_dendrogram()
  #geom_highlight(node = 34,fill="blue")
p2<-ggtree::rotate(p1,33)
p2+
  #geom_hilight(node=34,fill="blue")+
  layout_dendrogram()

rotate(p1,33)
