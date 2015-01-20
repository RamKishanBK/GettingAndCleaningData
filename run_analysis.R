#The function run_analysis accepts a parameter baseDir. 
#baseDir should point to folder which contains features.txt file
#The program first combines the two data sets training and test along with subject and activity details
#The program uses dplyr library, converts the data frame to a dplyr table
# The program uses the dplyr library functions to select, group and summarize the data, implemented using chains feature
#Finally the program writes the tidy out put to a file tidyoutput.txt in the baseDir
run_analysis<-function(baseDir){
  
  #read column names from features.txt and prefix it with two more columns Subject, Activity
  featuresFile<-paste(baseDir,"features.txt",sep="/")
  colNams<-read.table(featuresFile,header=FALSE)
  colNams$V2<-as.character(colNams$V2)
  cols<-c("Subject","Activity",colNams$V2)
  
  #read subject file for train data
  subjectFile<-paste(baseDir,"train/subject_train.txt",sep="/")
  subjectTbl<-read.table(subjectFile, header=FALSE)
  #read activity file for train data
  activityFile<-paste(baseDir,"train/y_train.txt",sep="/")
  activityTbl<-read.table(activityFile, header=FALSE)
  #read train file from trian dir into traintbl
  trainFile<-paste(baseDir,"train/X_train.txt",sep="/")
  trainTbl<-read.table(trainFile, header=FALSE)
  # merge subject, activity, train data
  mtrainTbl<-cbind(subjectTbl,activityTbl)
  mtrainTbl<-cbind(mtrainTbl,trainTbl)
  
  #read subject file for test data
  subjectFile<-paste(baseDir,"test/subject_test.txt",sep="/")
  subjectTbl<-read.table(subjectFile, header=FALSE)
  #read activity file for test data
  activityFile<-paste(baseDir,"test/y_test.txt",sep="/")
  activityTbl<-read.table(activityFile, header=FALSE)
  #read test file from test dir into testtbl
  testFile<-paste(baseDir,"test/X_test.txt",sep="/")
  testTbl<-read.table(testFile, header=FALSE)
  #merge subject, activity, testdata using cbind
  
  mtestTbl<-cbind(subjectTbl,activityTbl)
  mtestTbl<-cbind(mtestTbl,testTbl)
  #merge the two tables using rbind into mergetbl
  mergeTbl<-rbind(mtrainTbl,mtestTbl)
  

  
  #remove traintbl and testtbl
  rm("trainTbl")
  rm("testTbl")
  #make columns unique as there are duplicates
  cols<-make.names(cols,unique=TRUE)
  #Assign column names to mergetbl. Column names are the ones in variable colnames[,2] extracted from features.txt
  names(mergeTbl)<-cols
  
  
  #give meaningful names for activty
  mergeTbl$Subject<-as.numeric(mergeTbl$Subject)
  mergeTbl$Activity<-as.character(mergeTbl$Activity)
  mergeTbl$Activity[mergeTbl$Activity == "1"]<-"WALKING"
  mergeTbl$Activity[mergeTbl$Activity == "2"]<-"WALKING_UPSTAIRS"
  mergeTbl$Activity[mergeTbl$Activity == "3"]<-"WALKING_DOWNSTAIRS"
  mergeTbl$Activity[mergeTbl$Activity == "4"]<-"SITTING"
  mergeTbl$Activity[mergeTbl$Activity == "5"]<-"STANDING"
  mergeTbl$Activity[mergeTbl$Activity == "6"]<-"LAYING"
  
  #load libraries dplyr, tidyr
  
  library(dplyr)
  library(tidyr)
  
  #create dplyr compatible table from mergetbl data frame and reassign it to mergetbl
  mergeTbl<-tbl_df(mergeTbl)
  
  #select only those columns which contains mean or std in the name of the column. 
  #Using chains perform group by and summarise_each using mean function.
  #Assign it to a variable tidydata
  tidyData<-mergeTbl %>% select(contains("Subject"),contains("Activity"),contains(".mean."),contains(".std.")) %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
  
  #Loads the data into a file tidyoutput.txt in the basedir specified using write.table function
  tidyFile<-paste(baseDir,"tidyoutput.txt",sep="/")
  write.table(tidyData,tidyFile,row.names=FALSE,quote=FALSE)
  rm("tidyData")
 
}