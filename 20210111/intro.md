###### 今天的推文内容主要参考
> - https://www.rpubs.com/michelleprem/683962
> - https://fuzzyatelin.github.io/bioanth-stats/module-24/module-24.html

###### 首先是读入数据

> 今天推文用到的示例数据是参考链接2中提供的```usflu.fasta```，fasta文件已经比对好，R语言里读入fasta格式的数据可以使用```adegenet```包中的```fasta2DNAbin```函数

```
#install.packages("adegenet")
library(adegenet)
dna<-fasta2DNAbin(file = "usflu.fasta")
dna
```
###### 计算距离矩阵
```
library(ape)
dd<-dist.dna(dna)
```
> 用到的是```ape```包中的```dist.dna()```函数

###### 构建NJ树
```
tree<-nj(dd)
```
> 用到的是```ape```包中的```nj()```函数

###### ggtree进行可视化
```
library(ggtree)

ggtree(tree)+
  geom_tiplab(size=2)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-0644e46811f95419.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 做bootstrap检验
```
bs.tree<-boot.phylo(tree,dna,
                    function(x)nj(dist.dna(x)),1000,
                    trees = TRUE)
```
###### 将得到的bootstrap值合并到tree中
```
tree$node.label<-bs.tree$BP
```
> 这一步不知道对不对，好像是有问题，暂时还不知道如何验证

###### 结果里展示bootstrap值
```
ggtree(tree)+
  geom_tiplab(size=2)+
  geom_nodelab(hjust=-0.2,size=2)
```

![image.png](https://upload-images.jianshu.io/upload_images/6857799-798363d25b3134fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


欢迎大家关注我的公众号
**小明的数据分析笔记本**


![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-d5702f9c566bd3c4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
