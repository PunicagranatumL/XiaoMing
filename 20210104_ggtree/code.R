library(treeio)
tree<-read.newick("ggtree_practice_aligned.fasta.treefile",
                  node.label = "support")
library(ggtree)
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)+
  geom_treescale(x=0.7,y=30,color="red")+
  #geom_text(aes(label=node))+
  geom_highlight(node=35,fill="red")+
  geom_strip(6,11,label = "AAA",offset = 0.1,offset.text = 0.02,
             color = "green",barsize = 3,fontsize = 5,angle = 90,
             hjust = 0.5)+
  geom_text(aes(label=support),hjust=0.5,vjust=0.5)

tree@data$support1<-ifelse(tree@data$support<75,NA,tree@data$support)
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)+
  geom_treescale(x=0.7,y=30,color="red")+
  #geom_text(aes(label=node))+
  geom_highlight(node=35,fill="red")+
  geom_strip(6,11,label = "AAA",offset = 0.1,offset.text = 0.02,
             color = "green",barsize = 3,fontsize = 5,angle = 90,
             hjust = 0.5)+
  geom_text(aes(label=support1),hjust=-0.5)