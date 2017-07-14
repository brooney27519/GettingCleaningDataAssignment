## This script, run_analysis.R, will create a subset, called analysis, of the full dataset generated from the "UCI Human Activity
## Recognition (HAR) Using Smartphones" experiment here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## The analysis subset generated from this sript will contain only the mean and standard deviation values for each measurement
## of both the training and test data sets.
## 
## The script also creates a second, independent data set, called analysisFeatureAvg, that contains the average
## of each variable per Subject per Activity.
##
## This script assumes you set your working directory to the location of the folder containing all the 'UCI HAR Dataset' files.

## import the "features.txt" file into a dataframe in R:
features <- read.delim("features.txt",header=FALSE,sep=" ")

## extract the vector of features in the 2nd column to use as column headings for the data in X_test and X_train dataframes below 
X_col_headings <- as.character(features[,2])

## import the X_test.txt file and X_train.txt file into separate dataframes in R:
X_test <- read.delim("./train/X_test.txt",header=FALSE,sep="")
X_train <- read.delim("./train/X_train.txt",header=FALSE,sep="")

## apply X_col_headings to X_test and X_train to add col names to each dataframe. Note X_test and X_train have the exact same cols.
colnames(X_test) <- X_col_headings
colnames(X_train) <- X_col_headings

## we are only interested in the measurements or features that contain "mean()" and "std()" in the col name.
## create indexes of which columns contain "mean()" and "std()":
mean_features <- grep("mean\\(\\)",names(X_test))
std_features <- grep("std\\(\\)",names(X_test))

## Combine the mean_features and std_features vectors into a single index
mean_std_features <- c(mean_features,std_features)

## Use a sorted mean_std_features vector to subset X_test and X_train into final X_test and X_train datasets
## that have only have "mean()" and "std()" features:
MeanStdTest <- X_test[,sort(mean_std_features)]
MeanStdTrain <- X_train[,sort(mean_std_features)]

## Next, import the y_test and y_train files into dataframes in R. The y_* files contain the activity performed for each measurement.
y_test <- read.delim("./test/y_test.txt",header=FALSE,sep="")
y_train <- read.delim("./train/y_train.txt",header=FALSE,sep="")

## Next, import the subject_test and subject_train files into dataframes in R. 
## subject_* files contain the subject number that was used in each measurement.
subject_test <- read.delim("./test/subject_test.txt",header=FALSE,sep="")
subject_train <- read.delim("./train/subject_train.txt",header=FALSE,sep="")

## Merge subject_test, y_test and MeanStdTest into one data set:
testTemp <- subject_test
testTemp2 <- cbind(testTemp,y_test$V1)

#### temp2 is now a dataframe where col1 = Subject and col2 = Activity.  Add these col names to testTemp2:
colnames(testTemp2) <- c("Subject","Activity")

#### MeanStdTest dataframe has 66 columns, so bind these cols to testTemp2 to generate the complete "test" dataset:
test <- cbind(testTemp2,MeanStdTest[,1:66])

## Merge subject_train, y_train and MeanStdTrain into one data set:
trainTemp <- subject_train
trainTemp2 <- cbind(trainTemp,y_train$V1)

#### trainTemp2 is now a dataframe where col1 = Subject and col2 = Activity.  Add these col names to trainTemp2:
colnames(trainTemp2) <- c("Subject","Activity")

#### MeanStdTrain dataframe has 66 columns, so bind these cols to trainTemp2 to generate the complete "train" dataset:
train <- cbind(trainTemp2,MeanStdTrain[,1:66])

## Merge the test and train dataframes to generate a single dataset containing all the mean() and std() features
## from the test and train files and store the result in the analysis dataframe

analysis <- rbind(test, train)

## View the analysis in a table
View(analysis)

#############################################
## create the second, independent tidy data set with the average of each variable for each activity and each subject
#############################################

## Sort and group analysis by Subject, and then by Activity and store result in analysisGrouped.  Need dplyr package for this.
library(dplyr)
analysisGrouped <- analysis %>% arrange(Subject,Activity) %>% group_by(Subject,Activity)

## rename the feature columns so that each one begins with "Avg-"
featureNames <- names(analysisGrouped[3:68])
newFeatureNames <- paste0("Avg-",featureNames)
agColName <- c("Subject","Activity",newFeatureNames)
colnames(analysisGrouped) <- agColName

## Apply the mean (average) to each of the feature variables and store in analysisFeatureAvg dataframe
analysisFeatureAvg <- summarize_at(analysisGrouped,newFeatureNames,mean)

## View the analysisFeatureAvg in a table
View(analysisFeatureAvg)

####### END OF SCRIPT #######
