validDepths<-c("3.0","3.5","4.0","5.0","6.0","7.0","8.0","9.0")

masterDf<-setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("Filename","Depth"))

files<-list.files(path="D:/Dump2/")

folder<-"D:/Dump2"
#files[i]
#numbytes<-file.size(file.path(folder,files[i]))

library(stringr)
library(svMisc)
library(tidyverse)

system.time(for (i in (1:length(files))){
  fname<-files[i]
  dat<-data.frame(suppressWarnings(readBin(file.path(folder,fname),
                                           what="character",10e6)))
  dat<-dat[which(dat!=""),]
  ########### info extraction ###################

  Depths<-str_extract_all(dat,"D\\d\\.\\d")
  nums<-unlist(str_extract_all(Depths,"\\d\\.\\d"))
  Depth<-nums[nums %in% validDepths]
  
  
  ############ output to df #############
  df<-data.frame(cbind(fname,Depth))
  masterDf[i,]<-df
  progress(i,max.value=length(files))
})

masterDfbackup<-masterDf

#masterDf<-masterDf %>% mutate(blindName=paste(Muscle,row_number(masterDf)+fnum,sep=""))

library(writexl)
write_csv(masterDf,file="D:/all Depths v2.txt")
write_xlsx(masterDf,path="D:/allDepthsFaster v2.xlsx",col_names = TRUE,format_headers = TRUE)


