# Project for Coursera's Getting and Cleaning Data
# Jorge Chong

## Description
The purpose of this project is to provide with an R script to get a tidy data set. The original
data can be obtained from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
The zip contains the following files:
```
UCI HAR Dataset
	activity_labels.txt		: Labels of the activities performed
	features.txt			: 561 Features
	test
		+----- subject_train.txt	: Subject Identifiers of the 2947 test records
		+----- X_train.txt			: Test data (2947) records. Each record is a 561 features vector
		+----- y_train.txt			: Result labels (2947)
	train
		+----- subject_train.txt	: Subject Identifiers of the 7352 train records
		+----- X_train.txt			: Train data (7352) records. Each record is a 561 features vector
		+----- y_train.txt			: Result labels (7352)
```

## Files provided
The following files are provided:



## The process
The process consists of reading the text files into intermediate data.frame objects `(activity_labels, features, X_test_matrix, subject_test, Y_test,
 X_train_matrix, subject_train, Y_train)`
 
One key point to select the data corresponding to the features on the mean and standard deviation (according to the point 2)
is to transform the names of the features replacing the charactes "," and "-" by "." and
characters "(" and ")" by "_". This is necessary to make things easier with column names referencing.

Once the 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!
