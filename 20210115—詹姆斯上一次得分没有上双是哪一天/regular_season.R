library(dplyr)
library(stringr)
library(ggplot2)
#library(readr)
regular_season_all<-list.files(path = "LeBron_James/regular_season/",
                               pattern = "*.csv",full.names = T)
df<-data.frame(Date=character(),
               Age=character(),
               Tm=character(),
               Opp=character(),
               W_or_L=character(),
               MP=character(),
               PTS=character())
for (i in 1:17){
  df1<-read.csv(regular_season_all[i])
  df1%>%
    select(Date,Age,Tm,Opp,X.1,MP,PTS) -> df1.1
  colnames(df1.1)<-c("Date","Age","Tm","Opp","W_or_L","MP","PTS")
  df1.1[nchar(df1.1$PTS) <=2,] -> df1.2
  df<-rbind(df,df1.2)
}
dim(df)
tail(df)
head(df)
write.csv(df,file = "LeBron_James/LeBron_James_regular_season_pts.csv",
          quote = F,row.names = F)

df<-read.csv(file = "LeBron_James/LeBron_James_regular_season_pts.csv",
             header=T)
summary(df)
df<-df[!is.na(df$PTS),]

df$wl<-str_sub(df$W_or_L,1,1)
df1<-data.frame(table(df$wl))
df1

#library(extrafont)
#fonts()
df1$Var1<-factor(df1$Var1,
                 levels = c("W","L"),
                 labels = c("胜","负"))
ggplot(df1,aes(x=Var1,y=Freq))+
  geom_col(aes(fill=Var1))+
  geom_label(aes(label=Freq))+
  theme_void()+
  theme(legend.title = element_blank(),
        legend.position = "top")

df$x<-1:dim(df)[1]  
head(df)
df$group<-ifelse(df$PTS<10,"A","B")
pdf(file = "pts.pdf",width = 20)
ggplot(df,aes(x=x,y=PTS))+
  geom_line(color="#CAB2D6")+
  geom_point(aes(color=group),show.legend = F)+
  theme_bw()+
  geom_hline(yintercept = 10,lty="dashed")+
  geom_hline(yintercept = 60,lty="dashed")+
  theme(axis.ticks.x = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_blank())+
  scale_y_continuous(breaks = c(10,20,30,40,50,60))+
  scale_color_manual(values = c("#C40003","#00C19B"))
dev.off()
df[df$group=="A",]