#set working directory
#setwd("~/Desktop/lizzyandshelley/Dataset") #LIZZY
setwd("~/GitHub/lizzyandshelley/Dataset")  #SHELLEY

#open packages
library(here)
library(foreign)
library(labelled)
library(dplyr)

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


#select variables
dfs <- df %>%
  select("GENDER", "AGE", "RACELG", "HOMELESS", "HOMELESS1", "HOMELESS2", "MOSHOME", "MOSHOME1", "MOSHOM2", "NVHOUSED", 
         "ALWYSHL", "HOUSED", "HLP6M", "HLP6M1", "HLP6M2", "NHLP6M", "NHLP6M1", "NHLP6M2", "NDLSRCF", "NDLSRCF1", 
         "NDLSRCF2", "PUBINJ", "PUBINJ1", "PUBINJ2", "IJWOTH", "IJWOTH1", "IJWOTH2", "IJNON", "IJNON1", "IJNON2", 
         "ODP6M", "ODP6M1", "ODP6M2", "ODTIMES1", "ODTIMES2", "WOD6M", "WOD6M1", "WOD6M2", "ODTRAIN1", "NALOWN1", 
         "NALAVAIL1", "POLICE1", "POLICE2", "POLTIME1", "ARREST1", "ARREST2", "JAIL1", "JAIL2", "TX6MOS1", "TX6MOS2")
