# R语言的ggtree展示进化树的一些常用操作

> ```ggtree```是R语言里对进化树进行可视化展示的一个功能非常强大的R包，ggtree的作者还专门写了一本书对```ggtree```的用法进行了详细的介绍，相关链接是 https://yulab-smu.top/treedata-book/。最新版的```ggtree```还可以接受R语言里层次聚类分析的结果，画聚类树展示结果，非常方便。我之前也录制过视频进行介绍。

> 今天的内容是介绍一下```ggtree```可视化进化树的一下常用操作

现在假设你已经拿到了nwk格式的进化树文件，如下
```
(Synergus:0.1976902387,(((((Periclistus:0.1403183720,Synophromorpha:0.0325185390)93:0.0313182375,(Xestophanes:0.0275715134,(Diastrophus:0.0456139475,Gonaspis:0.1146402107)97:0.0603746476)86:0.0275523221)91:0.0396704245,Ibalia:0.1295291852)93:0.0678466304,(((Liposthenes_ker:0.0568838340,Rhodus:0.4243267334)73:0.0825510697,Plagiotrochus:0.0778290252)71:0.0457931797,Phanacis_2:0.1416544135)42:0.0142517743)48:0.0209026386,(((Liposthenes_gle:0.1641119081,((((Antistrophus:0.1098867540,Hedickiana:0.2313789580)73:0.0566918206,Neaylax:0.1747090949)53:0.0027850349,(Isocolus:0.0980216531,Aulacidea:0.1315344980)40:0.0147148853)54:0.0123010924,((Andricus:0.0479556214,Neuroterus:0.0392025403)95:0.0395094917,Biorhiza:0.0640188941)87:0.0159496082)20:0.0000025961)50:0.0194234721,((((Panteliella:0.0792235900,Diplolepis:0.3184402599)84:0.0461941800,Phanacis_1:0.1153410113)66:0.0099961323,(Eschatocerus:0.2548694740,Parnips:0.0000022831)64:0.0802390069)34:0.0241704495,((Barbotinia:0.0731026287,Aylax:0.0957869567)87:0.0269932737,Iraella:0.0390833327)95:0.0797807340)18:0.0000021284)23:0.0095262346,Timaspis:0.0585073936)19:0.0170106400)57:0.0526944283,(Ceroptres:0.1057541047,(Pediaspis:0.1932340906,Paramblynotus:0.1711455809)28:0.0000021043)48:0.0416999011);
```
###### 首先是读取nwk格式的进化树文件
> 读取nwk格式的进化树文件需要用到```treeio```这个包中的```read.newick()```函数
```
library(treeio)
tree<-read.newick("ggtree_practice_aligned.fasta.treefile",
                  node.label = "support")
```
现在进化树的所有信息都存储在了```tree```这个变量里
### 接下来是对进化树进行可视化展示
###### 最基本就是ggtree()函数，直接加读进来的树文件
```
library(ggtree)
ggtree(tree)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-c7b038e23513faa0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 添加文字标签
用到的的```geom_tiplab()```
```
ggtree(tree)+
  geom_tiplab()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-61315d673f2f3224.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###### 从上图可以看到有的文字标签超出了绘图边界
可以首先加上```theme_tree2()```函数显示出坐标轴范围，然后用```xlim()```函数更改坐标轴范围
```
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-7b26ca61f71f363a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-6dc5cb5ae10dc765.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 添加标尺
```
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)+
  geom_treescale(x=0.7,y=30,color="red")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-e412d788f9746c60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 这里遇到一个问题：geom_treescale()函数如果设置width参数，标尺就显示不出来，不知道是什么原因

###### 更改树的布局

这里布局的参数就不一一介绍了，可以参考 https://yulab-smu.top/treedata-book/chapter4.html

![image.png](https://upload-images.jianshu.io/upload_images/6857799-b751484baab5d12e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/6857799-703584df922cc05e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 给指定的分组添加背景颜色
```
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)+
  geom_treescale(x=0.7,y=30,color="red")+
  #geom_text(aes(label=node))+
  geom_highlight(node=35,fill="red")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-f5b408428dc187c0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
ggtree(tree)+
  geom_tiplab()+
  theme_tree2()+
  xlim(NA,0.8)+
  geom_treescale(x=0.7,y=30,color="red")+
  #geom_text(aes(label=node))+
  geom_highlight(node=35,fill="red")+
  geom_strip(6,11,label = "AAA",offset = 0.1,offset.text = 0.02,
             color = "green",barsize = 3,fontsize = 5,angle = 90,
             hjust = 0.5)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-f9fb3b920a874019.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###### 添加支持率的信息
```
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
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-2c5713dfe9b8d01c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 支持率可能会有部分重叠，我暂时想不到如何用代码把这些重叠分开，目前只能出图后手动编辑

###### 论文中通常只展示支持率大于某些值的，比如只显示支持率大于75
```
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
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-9cd6e300baf83e1f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 今天的内容就到这里了
欢迎大家关注我的公众号
**小明的数据分析笔记本**
