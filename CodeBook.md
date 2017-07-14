CodeBook for run_analysis.R script

Author: Brian Rooney
Email:	brooney27519@gmail.com

==========================================================================

1) features
dataframe containing all 561 features read from "features.txt" file.
	> head(features)
	  V1                V2
	1  1 tBodyAcc-mean()-X
	2  2 tBodyAcc-mean()-Y
	3  3 tBodyAcc-mean()-Z
	4  4  tBodyAcc-std()-X
	5  5  tBodyAcc-std()-Y
	6  6  tBodyAcc-std()-Z
	.... 555 records not listed.

2) X_test
dataframe containing all data read from the "X_test.txt" file.

	> dim(X_test)
	[1] 2947  561
	
	> class(X_test)
	[1] "data.frame"


*** Special Note: X_test and X_train have the exact same variables in each column.

3) X_train
dataframe containing all data read from the "X_train.txt" file.

	> dim(X_train)
	[1] 7352  561
	
	> class(X_train)
	[1] "data.frame"

*** Special Note: X_test and X_train have the exact same variables in each column.

4) X_col_headings
* Character vector of features from the 2nd column of "features" dataframe.
* Used to name the columns in the X_test and X_train dataframes.
> colnames(X_test) <- X_col_headings
> colnames(X_train) <- X_col_headings

5) mean_features
* index of the column names that contain "mean()".
* utilized the grep() command to find column names containig the pattern "mean()".
> mean_features <- grep("mean\\(\\)",names(X_test))

*** Special Note: could have used X_train here since X_train and X_test have identical col names.

6) std_features
* index of the column names that contain "std()".
* utilized the grep() command to find column names containig the pattern "std()".
> std_features <- grep("std\\(\\)",names(X_test))

*** Special Note: could have used X_train here since X_train and X_test have identical col names.

7) mean_std_features
* Combination of mean_features and std_features vectors.
* Contains the full index of column names that contain "mean()" or "std()":
> mean_std_features <- c(mean_features,std_features)
* mean_std_features is sorted and then used to subset X_test.  See MeanStdTest.

8) MeanStdTest
* Subset of X_test dataframe.
* MeanStdTest dataframe contains all rows and cols from X_test where the column names contain "mean()" or "std()".

	> dim(MeanStdTest)
	[1] 2947   66

	> class(MeanStdTest)
	[1] "data.frame"

* The sorted mean_std_features vector is used to subset X_test so that the final X_test dataset only has "mean()" or "std()" features:
> MeanStdTest <- X_test[,sort(mean_std_features)]

9) MeanStdTrain
* Subset of X_train dataframe
* MeanStdTrain dataframe contains all rows and cols from X_train where the column names contain "mean()" or "std()".

	> dim(MeanStdTrain)
	[1] 7352   66

	> class(MeanStdTrain)
	[1] "data.frame"

* The sorted mean_std_features vector is used to subset X_train so that the final X_train dataset only has "mean()" or "std()" features:
> MeanStdTrain <- X_train[,sort(mean_std_features)]

10) y_test
* dataframe containing all data read from the "y_test.txt" file.
* contains all the activities performed to generate the test data.
* maps to all rows in the MeanStdTest dataframe.

	> dim(y_test)
	[1] 2947    1
		
	> class(y_test)
	[1] "data.frame"

11) subject_test
* dataframe containing all data read from the "subject_test.txt" file.
* contains all the subject numbers used to generate the test data.
* maps to all rows in the MeanStdTest dataframe.

	> dim(subject_test)
	[1] 2947    1
	
	> class(subject_test)
	[1] "data.frame"


12) y_train
* dataframe containing all data read from the "y_train.txt" file.
* contains all the activities performed to generate the train data.
* maps to all rows in the MeanStdTrain dataframe.

	> dim(y_train)
	[1] 7352    1

	> class(y_train)
	[1] "data.frame"

13) subject_train
* dataframe containing all data read from the "subject_train.txt" file.
* contains all the subject numbers used to generate the train data.
* maps to all rows in the MeanStdTrain dataframe.

	> dim(subject_train)
	[1] 7352    1

	> class(subject_train)
	[1] "data.frame"

14) testTemp
* temporary copy of subject_test
* Subject will be the first column in the final test data set.
* used in the overall merge of subject_test, y_test, and MeanStdTest dataframes.
 
15) testTemp2
* temporary dataframe to store the merge of testTemp (subject_test) and y_test (activities).
* used in the overall merge of subject_test, y_test, and MeanStdTest dataframes.
* testTemp2 <- cbind(testTemp,y_test$V1).  y_test only has 1 col which is V1.

*** Special Note: Col Names "Subject" and "Activity" were applied to testTemp2:
> colnames(testTemp2) <- c("Subject","Activity")

16) test
* completed or final dataframe storing all test data of interest: subject_test, y_test, and MeanStdTest.
* created by binding all columns of MeanStdTest to testTemp2:
> test <- cbind(testTemp2,MeanStdTest[,1:66])

17) trainTemp
* temporary copy of subject_train
* Subject will be the first column in the final train data set.
* used to merge subject_train, y_train, and MeanStdTrain dataframes.
 
18) trainTemp2
* temporary dataframe to store the merge of trainTemp (subject_train) and y_train (activities).
* used to merge subject_train, y_train, and MeanStdTrain dataframes.
* trainTemp2 <- cbind(trainTemp,y_train$V1).  y_train only has 1 col which is V1.

*** Special Note: Col Names "Subject" and "Activity" were applied to trainTemp2:
> colnames(trainTemp2) <- c("Subject","Activity")

19) train
* completed or final dataframe storing all train data of interest: subject_train, y_train, and MeanStdTrain.
* create by binding all columns of MeanStdTrain to trainTemp2:
> train <- cbind(trainTemp2,MeanStdTrain[,1:66])

20) analysis
* dataframe generated from the merge of "test" and "train" datasets to generate the required final data set containing only the mean() and std() measurements from the test and train files.

> analysis <- rbind(test, train)

21) analysisGrouped
* dataframe storing the analysis dataframe grouped by subject and then by activity. Used dplyr package.
* generated by sorting (arranging) analysis dataframe by Subject, Activity, and then grouping by the same:
analysisGrouped <- analysis %>% arrange(Subject,Activity) %>% group_by(Subject,Activity)

22) featureNames
* a temporary character vector of the col names of only the feature variables (excludes Subject and Activity)
* generated by subsetting the col names of analysisGrouped dataframe.
> featureNames <- names(analysisGrouped[3:68])

23) newFeatureNames <- paste0("Avg-",featureNames)
* a temporary character vector that adds "Avg-" to the col names in featureNames (analysisGrouped col names).
* generated by paste0 function:
> newFeatureNames <- paste0("Avg-",featureNames)

24) agColName
* a temporary character vector that stores all the col names to apply to analysisGrouped dataframe.
> agColName <- c("Subject","Activity",newFeatureNames)
> colnames(analysisGrouped) <- agColName

25) analysisFeatureAvg
* final dataframe storing the mean (average) of each feature variable.
* generated by applying the "summarize_at" function:
> analysisFeatureAvg <- summarize_at(analysisGrouped,newFeatureNames,mean)
