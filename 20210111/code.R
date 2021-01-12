#install.packages("adegenet")
library(adegenet)
dna<-fasta2DNAbin(file = "usflu.fasta")
dna
library(ape)
dd<-dist.dna(dna)
tree<-nj(dd)
library(ggtree)

ggtree(tree)+
  geom_tiplab(size=2)
bs.tree<-boot.phylo(tree,dna,
                    function(x)nj(dist.dna(x)),1000,
                    trees = TRUE)
ggtree(bs.tree$trees)
ggtree(bs.tree)

bs.tree$BP
tree$Nnode
tree$node.label<-bs.tree$BP
ggtree(tree)+
  geom_tiplab(size=2)+
  geom_nodelab(hjust=-0.2,size=2)
