## project/UCI HAR Dataset/test/X_test.txt

library(data.table)

## Cleaning up test file 
## Reading in X_test.txt and attaching the column names to it, the column names are from 'features.txt' file
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
XtestNames <- read.table("./UCI HAR Dataset/features.txt")
XtestNames <- as.data.table(XtestNames) ##make it a data.table, then can use dcast and melt to transpose it below. Otherwise there's some warning message if try to transpose a data.frame
XtestNamesTranspose <- dcast(melt(XtestNames, id.vars = "V1"), variable ~ V1) ##transpose XtestNames data.table
XtestNamesTranspose$variable <- NULL ## remove first column, it's non relevant data 
XtestWithName <- rbind(XtestNamesTranspose, Xtest, use.names = FALSE) ## combine by row the name and the test data
names(XtestWithName) <- as.matrix(XtestWithName[1, ]) ##set the column names to the proper names, which is from row 1
XtestWithName <- XtestWithName[-1, ] ##remove the first row, that's now been added to column names, so no longer needed 

## Add the activity labels from y_test.txt file, this will need to be combined by column
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
testdata <- cbind(ytest, XtestWithName)
names(testdata)[1] <- "activity" ##rename the first column after we added it, its now called 'activity'

## Add the subjects, this is from subject_test.txt file, this will need to be combined by column
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testdatacomplete <- cbind(subjecttest, testdata)
names(testdatacomplete)[1] <- "subject" ##rename the first column to 'subject' now

## Train data 
## Now clean up the train file, add the variable names from features.txt file
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
XtrainWithName <- rbind(XtestNamesTranspose, Xtrain, use.names = FALSE) ##same column labels as the Xtest, so add it
names(XtrainWithName) <- as.matrix(XtrainWithName[1, ]) ##set the column names to the proper names like before
XtrainWithName <- XtrainWithName[-1, ]

## add the activity labels from y_train.txt file
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
traindata <- cbind(ytrain, XtrainWithName)
names(traindata)[1] <- "activity"

## ADd the subject_train.txt, this will be column bind
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
traindatacomplete <- cbind(subjecttrain, traindata)
names(traindatacomplete)[1] <- "subject"

## Combine train and test data
fulldataset <- rbind(testdatacomplete, traindatacomplete) ##the fully combined test and train data set

## Add descriptive activity names to the fulldataset
## 1 WALKING
## 2 WALKING_UPSTAIRS
## 3 WALKING_DOWNSTAIRS
## 4 SITTING
## 5 STANDING
## 6 LAYING

## Use ifelse() to create a vector with the proper descriptive activity
activitydescriptions <- ifelse(fulldataset$activity == 1, "WALKING", ifelse(
        fulldataset$activity == 2, "WALKING_UPSTAIRS", ifelse(
                fulldataset$activity == 3, "WALKING_DOWNSTAIRS", ifelse(
                        fulldataset$activity == 4, "SITTING", ifelse(
                                fulldataset$activity == 5, "STANDING", "LAYING"
                        )
                )
        )
))

##Add the activity description to the data set <- now data is fully cleaned up!!
fulldatasetcomplete <- cbind(activitydescriptions, fulldataset)

## Part 1: Extract mean and standard deviation for each measurement
##themean <- grep("mean", names(fulldatasetcomplete), value = TRUE)
##meandata <- fulldatasetcomplete[ , themean] ## this is the mean data
##thestd <- grep("std", names(fulldatasetcomplete), value = TRUE)
##stddata <- fulldatasetcomplete[ , thestd] ## this is the std data

## Part 2: Create a second independity tidy data with
##      the average of each variable for each activity and each subject

## Average of each activity and Average for each subject
convertfulldatasetcomplete <- lapply(fulldatasetcomplete, function(x) as.numeric(as.character(x))) ##make the columns numeric while retaining header
t <- as.data.table(convertfulldatasetcomplete) ##convert it into a data.table, the lapply returned a list
activitysubjectdata <- aggregate(.~ activity + subject, t, mean, na.action = na.pass) ##there are NA's, then it will throw no rows error...

if(!file.exists("./myresult")) {
        dir.create("./myresult")
}
write.table(activitysubjectdata, file = "./myresult/resultTable.txt", row.names = FALSE)
