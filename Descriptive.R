#set working directory
setwd("~/Box Sync/242FinalProject/Dataset") #LIZZY
#setwd("C:/Users/shell/Box Sync/242FinalProject")  #SHELLEY


#open packages
library(here)
library(foreign)
library(labelled)

#load the data
df <- read.spss("Ricky.SAV", use.value.labels = TRUE, to.data.frame=TRUE)

#get variable labels
attr(df, "variable.labels")
df.labels <- as.data.frame(attr(df, "variable.labels"))

#inspect the data
names(df)
dim(df)
length(unique(df$SUBJECT))

table(df$GENDER, useNA = "ifany")
table(df$HOMELESS, useNA = "ifany")
table(df$FU1, useNA = "ifany")
table(df$FU2, useNA = "ifany")
