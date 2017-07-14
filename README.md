Coursera Peer-graded Assignment: Getting and Cleaning Data Course Project

Author: Brian Rooney
email: brooney27519@gmail.com

BACKGROUND:
The work described below is for the creation of a subset of "Human Activity Recognition (HAR) Using Smartphones Data Set" collected during an experiment through the Univerysity of California in Irvine (UCI).

A full description of the experiment and the data collected is available at this site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The full dataset was extracted from the text files from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1) The HAR Experiment was performed on a group of 30 subjects.

2) Each subject performed six activities (obtained from the full data set in the file = activity_labels.txt)
WALKING
WALKING_UPSTAIRS
WALKING_DOWNSTAIRS
SITTING
STANDING
LAYING

3) Various readings were taken from a smartphone attached to each subject.  70% of the subjects were selected for generating training data and 30% of the subjects were selected for generating test data.  Thus, there are 2 datasets: train and test.

4) The readings were used to create 561 features which are the variables that contain various calculations or measurements of the data.

ANALYSIS:

An R script called run_analysis.R was used to create a subset of the full dataset and the script does the following:
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Applies a descriptive name to each activity in the data set.
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


1) In order to merge the training and test sets into one data set, we must pull the data from several files as described below:

a) features.txt : provides a list of all 561 features calculated during the experiment and these features apply to both the training and test data sets.

b) y_train.txt : provides a single-column list of 7352 numbers. The numbers are 1,2,3,4,5 or 6, repeated many times, where each number is associated with an activity performed to generate training data:
1: WALKING
2: WALKING_UPSTAIRS
3: WALKING_DOWNSTAIRS
4: SITTING
5: STANDING
6: LAYING

c) subject_train.txt: provides a single-column list of 7352 numbers where each number corresponds to the subject that produced training data.

d) X_train.txt: contains a table (7352 rows by 561 cols) of the training data associated with each of the 561 features.  We only need those features that contain "mean()" and "std()" in the feature name.

e) y_test.txt : provides a single-column list of 2947 numbers. The numbers are 1,2,3,4,5 or 6, repeated many times, where each number is associated with an activity performed to generate test data:
1: WALKING
2: WALKING_UPSTAIRS
3: WALKING_DOWNSTAIRS
4: SITTING
5: STANDING
6: LAYING

f) subject_test.txt: provides a a single-column list of 2947 numbers where each number corresponds to the subject that produced test data.

g) X_test.txt: contains a table of (2947 rows by 561 cols) of the test data associated with each of the 561 features. We only need those features that contain "mean()" and "std()" in the feature name.

The data in features.txt, y_train.txt, subject_train.txt, and X_train.txt will be combined into a single "train" dataset.  In turn, the data in the features.txt, y_test.txt, subject_test.txt, and X_test.txt will be combined into a single "test" dataset.  Lastly, the "train" dataset and the "test" dataset will be combined into one dataset called "analysis".


WALK_THROUGH OF "run_analysis.R SCRIPT:

*** NOTE: The working directory was set to the folder location of the downloaded files from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

1) The first step is to import the "features.txt" file into a dataframe in R:

> features <- read.delim("features.txt",header=FALSE,sep=" ")

The features dataframe contains all 561 features:
> head(features)
  V1                V2
1  1 tBodyAcc-mean()-X
2  2 tBodyAcc-mean()-Y
3  3 tBodyAcc-mean()-Z
4  4  tBodyAcc-std()-X
5  5  tBodyAcc-std()-Y
6  6  tBodyAcc-std()-Z
.... 555 records not listed.

2) We will use the vector of features in the 2nd column (V2) as the column headings for the data in X_test and X_train, so we need to extract the 2nd column into a character vector.

> X_col_headings <- as.character(features[,2])

3) Import the X_test.txt file and X_train.txt file into separate dataframes in R:

> X_test <- read.delim("./test/X_test.txt",header=FALSE,sep="")

> dim(X_test)
[1] 2947  561
> class(X_test)
[1] "data.frame"

> X_train <- read.delim("./train/X_train.txt",header=FALSE,sep="")

> dim(X_train)
[1] 7352  561
> class(X_train)
[1] "data.frame"

4) Set the Column Names of X_test and X_train to the values stored in X_col_headings:

> colnames(X_test) <- X_col_headings
> colnames(X_train) <- X_col_headings

5) We can see that X_test and X_train have the exact same column names, in the exact same order from Col1 to Col561.

> str(X_test)
'data.frame':	2947 obs. of  561 variables:
 $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
 $ tBodyAcc-mean()-Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
 $ tBodyAcc-mean()-Z                   : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
 $ tBodyAcc-std()-X                    : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
 $ tBodyAcc-std()-Y                    : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
 $ tBodyAcc-std()-Z                    : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
 $ tBodyAcc-mad()-X                    : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
 $ tBodyAcc-mad()-Y                    : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
 $ tBodyAcc-mad()-Z                    : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
 $ tBodyAcc-max()-X                    : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
...

> str(X_train)
'data.frame':	7352 obs. of  561 variables:
 $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 $ tBodyAcc-std()-Y                    : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 $ tBodyAcc-std()-Z                    : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
 $ tBodyAcc-mad()-X                    : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
 $ tBodyAcc-mad()-Y                    : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
 $ tBodyAcc-mad()-Z                    : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
 $ tBodyAcc-max()-X                    : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
...

6) So, we can use X_test or X_train to create indexes of the columns that contain "mean()" or "std()", which are the only measurements we are interested in for this analysis:

> mean_features <- grep("mean\\(\\)",names(X_test))
> std_features <- grep("std\\(\\)",names(X_test))

7) Combine the mean_features and std_features vectors into a single index of the columns that contain "mean()" or "std()":
> mean_std_features <- c(mean_features,std_features)

8) The mean_std_features vector will be sorted to maintain the original order of the cols in X_test and X_train.  We can use the sorted mean_std_features vector to subset X_test and X_train so that our final X_test and X_train datasets only have "mean()" or "std()" features:

MeanStdTest <- X_test[,sort(mean_std_features)]
MeanStdTrain <- X_train[,sort(mean_std_features)]

We now have 2 tidy dataframes containing col names and only the measurements for mean() and std(), one for test data and one for train data.

9) Next, the y_test, subject_text files and the y_train, subject_train files will be imported into a dataframe in R:

## y_* : contains activities and subject_* : contains subject number

> y_test <- read.delim("./test/y_test.txt",header=FALSE,sep="")
> y_train <- read.delim("./train/y_train.txt",header=FALSE,sep="")

> subject_test <- read.delim("./test/subject_test.txt",header=FALSE,sep="")
> subject_train <- read.delim("./train/subject_train.txt",header=FALSE,sep="")

10) Merge subject_test, y_test and MeanStdTest into one data set:

> testTemp <- subject_test
> testTemp2 <- cbind(testTemp,y_test$V1)

testTemp2 is now a dataframe where col1 = Subject and col2 = Activity.  These col names are added to testTemp2:
> colnames(testTemp2) <- c("Subject","Activity")
> head(testTemp2)
  Subject Activity
1       2        5
2       2        5
3       2        5
4       2        5
5       2        5
6       2        5

The MeanStdTest dataframe has 66 columns, so we can bind these cols to testTemp2 to have a complete "test" dataset:
> test <- cbind(testTemp2,MeanStdTest[,1:66])

11) Merge subject_train, y_train and MeanStdTrain into one data set:

> trainTemp <- subject_train
> trainTemp2 <- cbind(trainTemp,y_train$V1)

trainTemp2 is now a dataframe where col1 = Subject and col2 = Activity.  These col names are added to trainTemp2:
> colnames(trainTemp2) <- c("Subject","Activity")
> head(trainTemp2)
  Subject Activity
1       1        5
2       1        5
3       1        5
4       1        5
5       1        5
6       1        5

We know that MeanStdTrain dataframe has 66 columns, so we can bind these cols to trainTemp2 to have our complete "train" dataset:
> train <- cbind(trainTemp2,MeanStdTrain[,1:66])

12) Now we can join the test and train datasets to generate our final data set containing only the mean() and std() measurements from the test and train files.

> analysis <- rbind(test, train)

View the analysis in a table
> View(analysis)

13) To create the second, independent tidy data set with the average of each variable for each activity and each subject, we need to do the following:
a) create a new data set called analysisGrouped which groups the analysis dataframe created above by subject and then by activity.
b) rename the feature columns in analysisGrouped so that each column name of the feature variables begins with "Avg-".
c) apply the mean function to the feature columns.

a) Using the dplyr library, sort analysis data set by Subject and then by Activity.  Next, group the dataset by Subject, then Activity.
> library(dplyr)
> analysisGrouped <- analysis %>% arrange(Subject,Activity) %>% group_by(Subject,Activity)

b) create a char vector of the col names and then rename the columns in analysisGrouped so that 
> featureNames <- names(analysisGrouped[3:68])
> newFeatureNames <- paste0("Avg-",featureNames)
> agColName <- c("Subject","Activity",newFeatureNames)
> colnames(analysisGrouped) <- agColName

c) use it to apply the mean (average) to the feature variable and store in analysisFeatureAvg dataframe (we do not want to apply the mean to the Subject and Activity colums)

> analysisFeatureAvg <- summarize_at(analysisGrouped,newFeatureNames,mean)

## View the analysisFeatureAvg in a table
> View(analysisFeatureAvg)

### END OF README ###