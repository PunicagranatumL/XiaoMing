#install.packages("AER")
#library(AER)

data(Affairs,package = "AER")
df<-Affairs
df$ynaffairs<-ifelse(df$affairs>0,1,0)
table(df$ynaffairs)
df$ynaffairs<-factor(df$ynaffairs,
                     levels = c(0,1),
                     labels = c("No","Yes"))table
table(df$ynaffairs)
colnames(df)[2:9]
fit.full<-glm(ynaffairs~gender+age+yearsmarried+
                children+religiousness+education+occupation+rating,
              data=df,family = binomial())

summary(fit.full)
exp(confint(fit.full))
fit.reduced<-glm(ynaffairs~age+yearsmarried+
                religiousness+rating,
              data=df,family = binomial())
anova(fit.full,fit.reduced,test = "Chisq")
testdata<-data.frame(rating=c(1,2,3,4,5),
                     age=mean(df$age),
                     yearsmarried=mean(df$yearsmarried),
                     religiousness=mean(df$religiousness))

testdata$prob<-predict(fit.reduced,newdata = testdata,
                       type = "response")
library(ggplot2)
ggplot(testdata,aes(x=rating,y=prob))+
  geom_col(aes(fill=factor(rating)),show.legend = F)+
  geom_label(aes(label=round(prob,2)))+
  theme_bw()