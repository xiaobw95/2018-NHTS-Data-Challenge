#data
library(summarizeNHTS)
nhts_data <- read_data("2017", "./data")
df_trip <- as.data.frame(nhts_data$data$trip)
df_person <- as.data.frame(nhts_data$data$person)

#tnc data
df_tnc_person <- df_person[df_person$USES_TNC==1,]
df_tnc_trip <- merge(df_trip,df_tnc_person,by=c("HOUSEID","PERSONID"))
df_tnc_trip <- merge(df_tnc_trip,as.data.frame(nhts_data$weights$person),by=c("HOUSEID","PERSONID"))
df <- data.frame(hid=df_tnc_trip$HOUSEID,
                 pid=df_tnc_trip$PERSONID,
                 w=df_tnc_trip$WTPERFIN*365,
                 t=df_tnc_trip$STRTTIME,
                 edu=df_tnc_trip$EDUC,
                 mode=df_tnc_trip$TRPTRANS)

#cleaning
lambda <- function(x) as.numeric(as.character(x)) > 0
df <- df[complete.cases(df)&lambda(df$edu)&lambda(df$mode),]
df$mode <- factor(as.character(df$mode))
df$edu <- factor(as.character(df$edu))

#conditional probability calculation (ai and bi)
df <- df[order(df$hid,df$pid,df$t),]

library(dplyr)
mode <- df %>% group_by(edu,mode) %>% summarise(total=sum(w))

df_pairs <- data.frame()
for(i in 1:nrow(df)){
  if(i==nrow(df)){
    df_pairs <- rbind(df_pairs,data.frame(hid=df[i,]$hid,pid=df[i,]$pid,w=df[i,]$w,edu=df[i,]$edu,m1=as.character(df[i,]$mode),m2='0'))
  }
  else{
    if(df[i,]$hid==df[i+1,]$hid&df[i,]$pid==df[i+1,]$pid){
      df_pairs <- rbind(df_pairs,data.frame(hid=df[i,]$hid,pid=df[i,]$pid,w=df[i,]$w,edu=df[i,]$edu,m1=as.character(df[i,]$mode),m2=as.character(df[i+1,]$mode)))
    }
    else{
      df_pairs <- rbind(df_pairs,data.frame(hid=df[i,]$hid,pid=df[i,]$pid,w=df[i,]$w,edu=df[i,]$edu,m1=as.character(df[i,]$mode),m2='0'))
    }
  }
}
pairs <- df_pairs %>% group_by(edu,m1,m2) %>% summarise(total=sum(w))

#examples
#01->02
sum(pairs[pairs$m1=='01'&pairs$m2=='02',]$total)/sum(mode[mode$mode=='01',]$total)
#edu==01, 01->02
pairs[pairs$m1=='01'&pairs$m2=='02'&pairs$edu=='01',]$total/mode[mode$mode=='01'&mode$edu=='01',]$total