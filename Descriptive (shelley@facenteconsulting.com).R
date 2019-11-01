#set working directory
#setwd("~/Box Sync/242FinalProject/Dataset") #LIZZY
setwd("C:/Users/shell/Box Sync/242FinalProject/Dataset")  #SHELLEY


#open packages
library(here)
library(foreign)

#load the data
df <- read.spss("Ricky.SAV", to.data.frame=TRUE)

#inspect the data
names(df)
dim(df)
length(unique(df$SUBJECT))

table(df$GENDER, useNA = "ifany")
table(df$HOMELESS, useNA = "ifany")
table(df$FU1, useNA = "ifany")
table(df$FU2, useNA = "ifany")
