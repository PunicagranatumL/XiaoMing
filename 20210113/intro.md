# R语言做Logistic回归的简单小例子


> 今天的内容主要来自参考书《R语言实战》第二版第十三章第二小节的内容

###### Logistic回归的应用场景
> 当因变量为二值型结果变量，自变量包括连续型和类别型的数据时，Logistic回归是一个非常常用的工具。比如今天的例子中用到的婚外情数据 “Fair's Affairs”。因变量是**时候有过婚外情**，自变量有8个，分别是

- 性别
- 年龄
- 婚龄
- 是否有小孩
- 宗教信仰程度 （5分制，1表示反对，5表示非常信仰）
- 学历
- 职业 （逆向编号的戈登7种分类）这个是啥意思？）
- 对婚姻的自我评分

> 因变量y是出轨次数，我们将其转换成二值型，出轨次数大于等于1赋值为1，相反复制为0

### 下面开始实际操作
这个数据集来自R语言包```AER```，如果要用这个数据集需要先安装这个包
```
install.packages("AER")
```
然后使用data()函数获取这个数据集
```
data(Affairs,package = "AER")
```
然后就可以在环境的窗口里看到如下
![image.png](https://upload-images.jianshu.io/upload_images/6857799-5f78986f02049945.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个数据集总共有601个观察值，总共9个变量

###### 接下来是将变量y出轨次数，转换成二值型
```
df<-Affairs
df$ynaffairs<-ifelse(df$affairs>0,1,0)
table(df$ynaffairs)
df$ynaffairs<-factor(df$ynaffairs,
                     levels = c(0,1),
                     labels = c("No","Yes"))table
table(df$ynaffairs)
```
###### 接下来是拟合模型
拟合模型用到的是```glm()```函数
```
fit.full<-glm(ynaffairs~gender+age+yearsmarried+
                children+religiousness+education+occupation+rating,
              data=df,family = binomial())
```
通过```summary()```函数查看拟合结果
```
summary(fit.full)
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-0eb93e9801a7af16.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 根据回归系数的P值可以看到 性别、是否有孩子、学历、职业对方程的贡献都不显著。去除这些变量重新拟合模型

```
fit.reduced<-glm(ynaffairs~age+yearsmarried+
                religiousness+rating,
              data=df,family = binomial())
```
###### 接下来是使用anova()函数对它们进行比较，对于广义线性回归，可用卡方检验
```
anova(fit.full,fit.reduced,test = "Chisq")
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-f6568ddc16649baa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到结果中p值等于0.2108大于0.05，表明四个变量和9个变量的模型你和程度没有差别

###### 接下来是评价变量对结果概率的影响
构造一个测试集
```
testdata<-data.frame(rating=c(1,2,3,4,5),
                     age=mean(df$age),
                     yearsmarried=mean(df$yearsmarried),
                     religiousness=mean(df$religiousness)
```
预测概率
```
testdata$prob<-predict(fit.reduced,newdata = testdata,
                       type = "response")
```

###### 简单的柱形图对结果进行展示
```
library(ggplot2)
ggplot(testdata,aes(x=rating,y=prob))+
  geom_col(aes(fill=factor(rating)),show.legend = F)+
  geom_label(aes(label=round(prob,2)))+
  theme_bw()
```
![image.png](https://upload-images.jianshu.io/upload_images/6857799-a1b8ff0104e8a6be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 从这些结果可以看到，当婚姻评分从1（很不幸福）变为5（非常幸福）时，婚外情概率从0.53降低到了0.15。模型的预测结果和我们的经验还挺符合的

好了今天的内容就介绍到这里
欢迎大家关注我的公众号
**小明的数据分析笔记本**

![公众号二维码.jpg](https://upload-images.jianshu.io/upload_images/6857799-97f505a3aeadd6aa.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
