library(stargazer)

setwd('~/Downloads')

tassc <- read.csv('cleaned_data.csv',header= TRUE, sep = ',')

mkt <- read.csv('market-contols.csv',header=TRUE, sep=',')

mkt$y  <- as.numeric(substr(mkt$date,1,4))
mkt$m  <- as.numeric(substr(mkt$date,6,8))

means_mkt <- aggregate(x = mkt[,c("vwretd","tmytm", "vix")],by = list(mkt$y), FUN = mean)
meds_mkt <- aggregate(x = mkt[,c("vwretd","tmytm", "vix")],by = list(mkt$y), FUN = median)
sds_mkt <-aggregate(x = mkt[,c("vwretd","tmytm", "vix")],by = list(mkt$y), FUN = sd)

restricted <- tassc[c(
  "date" ,   "rateofreturn" ,                  
  "nav"  ,   "estimatedassets" ,                        
  "name" , "minimuminvestment"     ,         
  "managementfee" ,  "incentivefee" , "highwatermark"  , "leveraged",   "personalcapital" ,
  "opentopublic",  "lockupperiod", "live_graveyard", "vwretd" ,                
  "tb3ms" , "vix", "age", "size_NAV", "size_ass"  , "onshore" ,                    
  "survived" , "flow_NAV", "flow_ass")]

restricted$ad <- 0
restricted[restricted$live_graveyard == "Graveyard",]$ad <- 1

dates = c('1994m12','1995m12','1996m12','1997m12','1998m12','1999m12','2000m12','2001m12',
          '2002m12','2003m12','2004m12','2005m12','2006m12',
          '2007m12','2008m12','2009m12','2010m12','2011m12',
          '2012m12','2013m12','2014m12','2015m12','2016m12','2017m12')

k = length(restricted) #grab number of columns

time <- length(dates)
means <-matrix(0,time,k-2)  #exclude graveyard and name
meds <-matrix(0,time,k-2)
sds <-matrix(0,time,k-2)

subcols <- c(
  "rateofreturn" ,                  
  "nav"  ,   "estimatedassets" ,                        
  "minimuminvestment"     ,         
  "managementfee" ,  "incentivefee" , "highwatermark"  , "leveraged",   "personalcapital" ,
  "opentopublic",  "lockupperiod", "vwretd" ,                
  "tb3ms" , "vix", "age", "size_NAV", "size_ass"  , "onshore" ,                    
  "survived" , "flow_NAV", "flow_ass","ad")



for(i in 1:time){
  subset <- restricted[restricted$date == dates[i] & restricted$age >= 2,]
  subset <- subset[subcols]
  means[i,] <- cbind(as.numeric(substr(dates[i],1,4)), t(sapply(subset, mean, na.rm=TRUE)))
  meds[i,] <- cbind(as.numeric(substr(dates[i],1,4)), t(sapply(subset, median, na.rm=TRUE)))
  sds[i,] <- cbind(as.numeric(substr(dates[i],1,4)), t(sqrt(sapply(subset, var, na.rm=TRUE))))
}

names<- cbind('year', t(subcols))
colnames(means) <- names

means[,13] <- means_mkt[3:26,]$vwretd
means[,14] <- means_mkt[3:26,]$tmytm
means[,15] <- means_mkt[3:26,]$vix

colnames(meds) <- names

meds[,13] <- meds_mkt[3:26,]$vwretd
meds[,14] <- meds_mkt[3:26,]$tmytm
meds[,15] <- meds_mkt[3:26,]$vix

colnames(sds) <- names

sds[,13] <- sds_mkt[3:26,]$vwretd
sds[,14] <- sds_mkt[3:26,]$tmytm
sds[,15] <- sds_mkt[3:26,]$vix

final_summary <- matrix(0,time,1+3+3+1)
final_summary[,1] <- means[,1]
final_summary[,2] <- means[,c("flow_NAV")]
final_summary[,3] <- meds[,c("flow_NAV")]
final_summary[,4] <- sds[,c("flow_NAV")]
final_summary[,5] <- means[,2] # return
final_summary[,6] <- meds[,2] # return
final_summary[,7] <- sds[,2]  # return
final_summary[,8] <- means_mkt[3:26,2] # s and p

colnames(final_summary) <- c("Year", "Mean Flow", "Med Flow", "Sdv Flow", "Mean Return", "Med Return", "Sdv Return", "Mean Market Return")


write.csv(final_summary, "table1.csv")
write.csv(means, "mean_summary.csv")
write.csv(meds, "median_summary.csv")
write.csv(sds, "stddev_summary.csv")


stargazer(final_summary[1:13,c(1,2,4,8)])
stargazer(final_summary[14:24,c(1,2,4,8)])


t <- restricted[,c("date","name","ad")]
t$y <- as.numeric(substr(t$date,1,4))
t <- t[t$y >= 1994,]
firms <- aggregate(x = t$ad, by=list(t$name,t$y), FUN = mean)


g1 <- firms[firms$Group.2 >= 1994 & firms$Group.2 <= 2007,]
g2 <- firms[firms$Group.2 >= 2008 & firms$Group.2 <= 2009,]
g3 <- firms[firms$Group.2 >= 2010 & firms$Group.2 <= 2017,]

f1 <- aggregate(x = g1$x, by = list(g1$Group.1), FUN = mean )
f2 <- aggregate(x = g2$x, by = list(g2$Group.1), FUN = mean )
f3 <- aggregate(x = g3$x, by = list(g3$Group.1), FUN = mean )

# c( dead, alive)
c(sum(f1$x),sum(1-f1$x)) # before
c(sum(f2$x),sum(1-f2$x)) # during
c(sum(f3$x),sum(1-f3$x)) # after

cool <- function(a){
  return(as.character(signif(a,3)))
}
final_summary <- apply(final_summary,FUN="cool", MARGIN = c(1,2))

stargazer(final_summary[,c(1,2,4,5,7,8)])

