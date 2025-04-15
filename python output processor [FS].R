library(tidyverse)
library(writexl)
library(stringr)
library(tools)
library(dplyr)
library(gWidgets2)
library(gWidgets2tcltk)

################ start numbers dialog boxes ###############

options(guiToolkit="tcltk") 
TricepStart <- as.numeric(ginput("Enter numer of last blinded tricep:"))
BicepStart <- as.numeric(ginput("Enter numer of last blinded bicep:"))

############# ask for workingDir ############
workingDir<-tk_choose.dir(default="C:/Users/",caption="Select folder")
textFileName <- paste(basename(workingDir)," output.txt",sep="")


######################## opening output file from python #################################

filedf <- data.frame(read.csv(paste(workingDir,textFileName,sep="/"),header=TRUE))

colnames(filedf)=c("filename","patientID","tag")

############# reformmating tag information into seperate cols ############
filedf <- filedf %>% mutate(time=str_extract(tag, regex("pre|post", ignore_case = TRUE)))
filedf <- filedf %>% mutate(set=str_extract(tag, regex("set\\d+|set \\d+|se \\d+", ignore_case = TRUE)))
filedf<- filedf %>% mutate(setNum=str_extract(set, regex("\\d+", ignore_case = TRUE)))
filedf <- filedf %>% mutate(Subject = str_extract(patientID,regex("(M|F|MO|FO)\\d\\d",ignore_case = TRUE)))
filedf<-filedf %>% mutate(muscleTemp = str_extract(tag,regex("\\s((L|R)(T|B|L))|((left|right)(TRICEP|BICEP))",ignore_case = TRUE)))

filedf<-filedf %>% mutate(side = str_extract(muscleTemp,regex("L|R",ignore_case = TRUE)))
filedf<-filedf %>% mutate(newMusc = NA)
filedf<-filedf %>% mutate(visit = NA)


lookup<-rbind(c("T","Tricep","TRICEP","Push"),c("B","Bicep","BICEP","Pull"))
################## finding & renaming muscles & timepoints ################
for (i in 1:dim(filedf)[1]){
  a<-filedf$muscleTemp[i]
  if (any(str_detect(a,lookup[,2])|str_detect(a,lookup[,3]))){
    finds<-(str_detect(a,lookup[,2])|str_detect(a,lookup[,3]))
    a<-lookup[finds,2]
    filedf$newMusc[i]<-a
  }
  if (any(str_detect(a,lookup[,1]))){
    str_detect(a,lookup[,1])
    finds<-(str_detect(a,lookup[,1]))
    a<-lookup[finds,2]
    filedf$newMusc[i]<-a
  }
  filedf$visit[i]<-lookup[which(lookup[,2]==filedf$newMusc[i]),][4]
  
}

filedf <- subset(filedf, select = -c(muscleTemp, patientID))
filedf <- filedf %>% mutate(Time=NA)
for (i in 1:dim(filedf)[1]){
  if (filedf$time[i]=="PRE"){
    filedf$Time[i]<-str_to_sentence(filedf$time[i])
  }
  else
    filedf$Time[i]<-paste(str_to_sentence(filedf$time[i])," Set ",filedf$setNum[i],sep="")
}
for (i in 1:dim(filedf)[1]){
  if (filedf$side[i]=="L"){
    filedf$side[i]<-"Left"
  }
  if (filedf$side[i]=="R"){
    filedf$side[i]<-"Right"
  }
}
############## cleaning up dataframe ################
filedf <- subset(filedf, select = -c(time, setNum, set, tag))

filedf<-filedf %>% relocate(filename,Subject,visit,Time,side,newMusc)


TRIs<-which(filedf$newMusc=="Tricep")
TRIs<-filedf[TRIs,]

BIs<-which(filedf$newMusc=="Bicep")
BIs<-filedf[BIs,]

BIs<-BIs %>% mutate(blindedName=paste(newMusc,row_number(BIs)+BicepStart,sep=" "))
TRIs<-TRIs %>% mutate(blindedName=paste(newMusc,row_number(TRIs)+TricepStart,sep=" "))
TRIs<-TRIs %>% relocate(blindedName,before=filename)
BIs<-BIs %>% relocate(blindedName,before=filename)
BIs <- subset(BIs, select = -c(newMusc))
TRIs <- subset(TRIs, select = -c(newMusc))

fullDf<-rbind(BIs,TRIs)



############## Run batch crop on imageJ before proceeding ###################3











####################### renaming:Run batch crop on imageJ before proceeding ##########################


dir<-workingDir

files<-list.files(path=dir,full.names=FALSE,pattern="*.tif")
filesVerbose<-list.files(path=dir,full.names=TRUE,pattern="*.tif")

for (i in 1:length(files)){
  fname<-files[i]
  file.rename(from=filesVerbose[i],
              to=paste(dir2,fullDf[which(fullDf==file_path_sans_ext(fname),arr.ind=TRUE)[1],]$blindedName,".tif",sep=""))
}

####################### writing to excel ########################
basename(dir)
write_xlsx(BIs,path=paste(dir,"/","Bis.xlsx",sep=""))
write_xlsx(TRIs,path=paste(dir,"/","Tris.xlsx",sep=""))

write_xlsx(x=list(Biceps=BIs,Triceps=TRIs),path=paste(dir,"/",basename(dir)," output.xlsx",sep=""))


