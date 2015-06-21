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
is to transform the names of the features replacing the charactes `","` and `"-"` by `"."` and
characters `"("` and `")"` by `"_"`. This is necessary to make things easier with column names referencing. 

Once the requested columns have been selected, we used two data.frame objects containing the merged data, one for the test data `(Dataset_test)`
and one for the training data `(Dataset_train)`.

The format for the test data `(Dataset_test)` is:

![Dataset Matrix representation](https://github.com/fortachong/Getting_and_Cleaning/blob/master/Dataset_test.gif)

Where every row represents an observation (2947 test observations), being the first column the subject id from that observation, 
the next 66 columns correspond to the selected features (those that have the functions mean() and std() in their names). 
The last column correspond to the labels representing the 6 activities. This column has been transformed to a factor with the labels specified in the `activity_labels.txt`

Similarly for the training data `(Dataset_train)` we have:

![Dataset Matrix representation](https://github.com/fortachong/Getting_and_Cleaning/blob/master/Dataset_train.gif)

The structure is similar, but now we have 7352 observations.

The two data frames are merged in `Dataset` with the first 2947 rows corresponding to the test data and the next 7352 rows corresponding to the training data. The dimension of this object is 10299 rows by 68 columns. 

The final data set `FinalDataset` consists of the 180 (30 subjects x 6 activities) means of the 66 measurements selected. It is obtained by applying an aggregation over `Dataset` in order to get the `mean()` of the 66 selected features grouping by activity and subject. The dimension is 180 rows by 68 columns. The first two columns are the activity labels and the subject id. The next 66 columns are labeled according to the features selected.