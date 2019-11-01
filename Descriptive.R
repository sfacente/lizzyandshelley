#set working directory
setwd("~/Desktop/lizzyandshelley/Dataset") #LIZZY
setwd("~/GitHub/lizzyandshelley/Dataset")  #SHELLEY

#open packages
library(here)
library(foreign)
library(labelled)

#load the data
df <- read.spss("Ricky.SAV", use.value.labels = TRUE, to.data.frame=TRUE)

#get variable labels
attr(df, "variable.labels")
df.labels <- as.data.frame(attr(df, "variable.labels"))
QDSlabels <- data.frame(rownames(df.labels))
df.labels <- cbind(QDSlabels, df.labels)
names(df.labels) <- c("VAR_ID", "description")
rm(QDSlabels)

#USE THIS CODE TO LOOK UP A VARIABLE DESCRIPTION
#df.labels$description[df.labels$VAR_ID=="GENDER"]


#inspect the data
names(df)
dim(df)
length(unique(df$SUBJECT))

table(df$GENDER, useNA = "ifany")
table(df$FU1, useNA = "ifany")
table(df$FU2, useNA = "ifany")

#look at homeless variables
table(df$HOMELESS, useNA = "ifany")
table(df$HOMELESS1, useNA = "ifany")
table(df$HOMELESS2, useNA = "ifany")

#look at homeless variables ricky created
table(df$NVHOUSED, useNA = "ifany")
table(df$ALWYSHL, useNA = "ifany")
table(df$HOUSED, useNA = "ifany")

#look at initiation variables

hlp6m
