##The repository contains three files
1. Readme.md
2. Codebook.md
3. run_analysis.R

##Steps to run run_analysis.R

###Step 1: 
Download the zip file from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. Unzip the file. This should create a folder <UCI HAR DATASET> in the directory you Unzipped. For Example, if you have Unzipped in "/home/", then you should see a folder "/home/UCI HAR DATASET"

###Step 2:
Download the run_analysis.R file to your R programming environment.

###Step 3:
Load the R file into R console using the 'source' command

###Step 4:
If you have Unzipped the zip file in the folder as suggested in Step 1 then enter the command run_analysis("/home/UCI HAR DATASET") in the console

###Step 5:
When the program exits, you will see a file tidyoutput.txt in the folder "/home/UCI HAR DATASET". This will contain the Tidy out put expected. The first two columns would be Subject and Activity. The remaining 66 columns will be the variables whose structure is defined in the Codebook.txt file. The file will contain one header row and 180 Observations.


##Code Documentation

####Step 1:
The first step is to read the column names from features.txt available in the zip folder. The step also includes prefixing the variable which contains the column names with two additional columns "Subject" and "Activity". The code below does that.
#
	featuresFile<-paste(baseDir,"features.txt",sep="/")
	colNams<-read.table(featuresFile,header=FALSE)
	colNams$V2<-as.character(colNams$V2)
	cols<-c("Subject","Activity",colNams$V2)


####Step 2:
The next step is to read the subject, activity and the data from the directory train. They are stored in corresponding variables subjectTbl, activityTbl, trainTbl. Once the reading is completed, we have to merge the three data sets in the following order Subject,Activity, data. We use the cbind command to achieve this. The code below does that.
#
	subjectFile<-paste(baseDir,"train/subject_train.txt",sep="/")
	subjectTbl<-read.table(subjectFile, header=FALSE)
	activityFile<-paste(baseDir,"train/y_train.txt",sep="/")
	activityTbl<-read.table(activityFile, header=FALSE)
	trainFile<-paste(baseDir,"train/X_train.txt",sep="/")
	trainTbl<-read.table(trainFile, header=FALSE)
	mtrainTbl<-cbind(subjectTbl,activityTbl)
	mtrainTbl<-cbind(mtrainTbl,trainTbl)

####Step 3:
Perform Step 2 for the folder test. The code below does that.
#
	subjectFile<-paste(baseDir,"test/subject_test.txt",sep="/")
	subjectTbl<-read.table(subjectFile, header=FALSE)
	activityFile<-paste(baseDir,"test/y_test.txt",sep="/")
	activityTbl<-read.table(activityFile, header=FALSE)
	testFile<-paste(baseDir,"test/X_test.txt",sep="/")
	testTbl<-read.table(testFile, header=FALSE)
	mtestTbl<-cbind(subjectTbl,activityTbl)
	mtestTbl<-cbind(mtestTbl,testTbl)

####Step 4:
From Step 2 and Step 3 the data from train and test is available in two variables and have the same format Subject, Activity and the remaining 561 variables. Now we have to merge these two datasets. We use the rbind function to do this. 
#
	mergeTbl<-rbind(mtrainTbl,mtestTbl)

####Step 5:
In Step 1 we had read the column names from fwatures.txt. We use the function make.names to ensure they are unique and then assign these as column names to the data obtained from Step 4. The code below does that.
#
	cols<-make.names(cols,unique=TRUE)
	names(mergeTbl)<-cols

####Step 6:
The Activity Names are numeric values ( 1 through 6 ) at this point. We need to give meaningful names. The code below does that
#
	mergeTbl$Subject<-as.numeric(mergeTbl$Subject)
	mergeTbl$Activity<-as.character(mergeTbl$Activity)
	mergeTbl$Activity[mergeTbl$Activity == "1"]<-"WALKING"
	mergeTbl$Activity[mergeTbl$Activity == "2"]<-"WALKING_UPSTAIRS"
	mergeTbl$Activity[mergeTbl$Activity == "3"]<-"WALKING_DOWNSTAIRS"
	mergeTbl$Activity[mergeTbl$Activity == "4"]<-"SITTING"
	mergeTbl$Activity[mergeTbl$Activity == "5"]<-"STANDING"
	mergeTbl$Activity[mergeTbl$Activity == "6"]<-"LAYING"

####Step 7:
We will use dplyr and tidyr functions to tidy the data. First thing is to load those libraries. The code below does that.
#
	library(dplyr)
	library(tidyr)

####Step 8:
We need to take the dataframe available post Step 6 and convert it to a dplyr data table. This code below does that.
#
	mergeTbl<-tbl_df(mergeTbl)

####Step 9:
This is implemented using chains. It involves first selecting column names which contains mean and std. When we used the function make.names, the special characters got converted to dots. so the best possible match would be to use ".mean." and ".std.". Along with this two more strings are used "Subject" , "Activity" as tidying needs to be done around these two variables. The next step is to use the group_by clause which ensures that all operations post that will happen on the columns specified in group_by clause. We use Subject and Activity as the group_by clause columns.The last activity is to summarise all the columns using mean function. This is done using summarise_each. The code below does that.
#
	tidyData<-mergeTbl %>% select(contains("Subject"),contains("Activity"),contains(".mean."),contains(".std.")) %>% 
	group_by(Subject,Activity) %>% 
	summarise_each(funs(mean))

####Step 10:
From Step 9 we have achieved tidying of data. Now we need to write the data to a file. The code below does that.
#
	tidyFile<-paste(baseDir,"tidyoutput.txt",sep="/")
	write.table(tidyData,tidyFile,row.names=FALSE,quote=FALSE)
