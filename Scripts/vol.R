# Lucas Cusimano and Ruby Zhang
# Calculates rolling volatility for hedge fund returns

require(zoo)

names <- unique(restricted$name)

#initialize at zero
restricted$rollingvol <- 0

# loop over the list of hedge fund names
for(i in c(1:length(names))){
    # 24 month rolling window (lookback)
    #fills missing values with .
  restricted[restricted$name == names[i],]$rollingvol <- rollapplyr(restricted[restricted$name == names[i],]$rateofreturn , 24, sd, fill = .)
  #print(i)
}

t <- restricted

# replace R NAs with "." for STATA analysis
t[is.na(t$rollingvol),]$rollingvol <- "."

#output files
write.csv(restricted[,c("date","name","rollingvol")],"rollingvol.csv")

write.csv(t[,c("date","name","rollingvol")],"rollingvol2.csv")
