validDepths<-c("3.0","3.5","4.0","5.0","6.0","7.0","8.0","9.0")

masterDf<-setNames(data.frame(matrix(ncol = 7, nrow = 0)), c("Filename","SubID","Visit","Muscle","Time","Depth","DR"))

files<-list.files(path="C:/Users/HKSLAB07/Downloads/unblinded VM's")
fnum<-281
folder<-"C:/Users/HKSLAB07/Downloads/unblinded VM's"
library(stringr)
library(svMisc)
library(tidyverse)
for (i in (1:length(files))){
  fname<-files[i]
  dat<-data.frame(suppressWarnings(readBin(file.path(folder,fname),
                                           what="character",10e6)))
  ########### info extraction ###################

  Depths<-str_extract_all(dat,"D\\d\\.\\d")
  nums<-unlist(str_extract_all(Depths,"\\d\\.\\d"))
  Depth<-nums[nums %in% validDepths]
  
  DR <- str_extract_all(dat,"DR\\d\\d")
  DR<-unlist(str_extract(DR,"\\d\\d"))
  
  ############ output to df #############
  df<-data.frame(cbind(fname,SubID,Visit,Muscle,Time,Depth,DR))
  masterDf[i,]<-df
  rm(df,dat,SubID,Visit,Muscle,Time,Depth,Depths,DR,tag,TagLoc)
  progress(i,max.value=length(files))
}

masterDfbackup<-masterDf

masterDf<-masterDf %>% mutate(blindName=paste(Muscle,row_number(masterDf)+fnum,sep=""))

df<-read.csv("text file.txt", sep="\t")
df<-df %>% map_df(rev)
df[3,1]
gr