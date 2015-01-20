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

