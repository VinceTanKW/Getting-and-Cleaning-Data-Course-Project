

## downloading zip file from website and unzip

url <- "https://d396qusza40orc.cloudfront.net/
    getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile= "./run_analysis_raw.zip")
unzip("./run_analysis_raw.zip")

## read in feature names ie. variable names 
featurenames <- read.table("./UCI HAR Dataset/features.txt", 
                           stringsAsFactors = FALSE)[ ,2]

## read in test data 

testset <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                      stringsAsFactors = FALSE, col.names = featurenames, 
                      check.names=FALSE)
testactivities <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                            stringsAsFactors = FALSE, col.names= "activities")
testsubjectid <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                          stringsAsFactors = FALSE, col.names= "subjectid")


## read in train data

trainset <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                       stringsAsFactors = FALSE, col.names = featurenames,
                       check.names=FALSE)
trainactivities <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                         stringsAsFactors = FALSE, col.names="activities")
trainsubjectid <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           stringsAsFactors = FALSE, col.names= "subjectid")

## combine test data and remove input from workspace

testfull <- cbind(testsubjectid, testactivities, testset)
rm(testsubjectid, testactivities, testset)

## combine train data

trainfull <- cbind(trainsubjectid, trainactivities, trainset)
rm(trainsubjectid, trainactivities, trainset)

## combine test and train data and remove input from workspace

alldatafull <- rbind(testfull, trainfull)
rm(testfull, trainfull)

## load dplyr and alldatafull table

library(dplyr)
tbl_df(alldatafull)

## get required column names

requiredcol <- c("subjectid", "activities", featurenames[grepl("mean()", featurenames, fixed=TRUE)],
                featurenames[grepl("std()", featurenames, fixed=TRUE)])   

## subsetting to get mean and std columns

subsetmeanstd <- alldatafull[,requiredcol]


## read in activities map file

activitiesmap <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                stringsAsFactors = FALSE, col.names= c("activitiescode","activitiesdesc"))

## look up activities description

subsetmeanstd <- merge(subsetmeanstd, activitiesmap, by.x="activities", 
                       by.y= "activitiescode")

## group and summarize the value

tidydata <- subsetmeanstd %>% group_by(subjectid, activitiesdesc) %>% summarise_each(funs(mean))

## write the data to output file

write.table(tidydata, file='./tidydata.txt', row.names=FALSE)





