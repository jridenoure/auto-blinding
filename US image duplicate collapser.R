library(stringr)
library(svMisc)
library(tidyverse)
library(readxl)
RF<-read_xlsx(path="C:/Users/rcolq/Downloads/Jake Thesis US Analysis.xlsx",sheet="RF clean",col_names=TRUE)
VL<-read_xlsx(path="C:/Users/rcolq/Downloads/Jake Thesis US Analysis.xlsx",sheet="VL clean",col_names=TRUE)
#RF<-RF %>% mutate(delete=FALSE)

length(colnames(RF))
RFunique<-setNames(data.frame(matrix(ncol = length(colnames(RF)), nrow = 0)), colnames(RF))
dim(RFunique)[1]

for (i in 1:dim(RF)[1]) {
  matches <- RF[which(RF$imgTag == RF$imgTag[i]), ]
  while (dim(matches[which(matches$delete==FALSE),])[1]>1){
    for (j in 1:dim(matches)[1] > 1) {
      if ((abs(matches$musArea[j] - matches$musArea[2]) / (matches$musArea[j +
                                                                           1])) < .15) {
        matches$musArea[j] <- mean(matches$musArea[j], matches$musArea[j + 1])
        RF <- RF %>% filter(RF$blindName != matches[j + 1, ]$blindName)
      }
      else
        matches$musArea[j] <- min(matches$musArea[j], matches$musArea[j +
                                                                        1])
    }
  }
}


for (i in 1:dim(RF)[1]){
  if (RF$imgTag[i]==RF$imgTag[i+1]){
    if abs(((RF$musArea[i]-RF$musArea[1+i])/((RF$musArea[i])<.15){
      RF$musArea[i]<-mean(RF$musArea[i],RF$musArea[1+i])
      
      RFunique[(dim(RFUnique)[1])+1,]<-RF[i,]
    }
    else
      ind<-which.min(c(RF$musArea[i],RF$musArea[i+1]))
      RFUnique<-rbind(RF[i,],RF[i+1,])[ind,]
  }
  else
    i<-i+1
}


ind<-which.min(c(RF$musArea[i],RF$musArea[i+1]))
ind
rbind(RF[i,],RF[i+1,])[ind,]



RF[i,]
RF[i+1,]



(matches$musArea[1]-matches$musArea[2])/(matches$musArea[1])
avgMusArea<-mean(matches$musArea)
avgMeanEI<-mean(matches$meanEI)

dim(RF)[1]
1:dim(RF)[1]
matches
j<-1
matches[j,]
RF<-RF %>% filter(RF$blindName!=matches[j+1,]$blindName)
dim(matches[which(matches$delete==FALSE),])[1]



