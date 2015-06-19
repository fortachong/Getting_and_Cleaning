# Author: Jorge Chong
# Date: 2015-06-11
# Coursera Getting and Cleaning Data
#
require(stringr)
# 1. Download and unzip necesary files
# Source of the datasets: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
src_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(src_url, 
              method="auto", 
              destfile = "dataset.zip")

# 2. Read files from the zip file dataset.zip
# UCI HAR Dataset
#               activity_labels.txt            : Labels of the activities performed
#               features.txt                   : 561 Features
#               test
#                  +----- subject_train.txt    : Subject Identifiers of the 2947 test records
#                  +----- X_train.txt          : Test data (2947) records. Each record is a 561 features vector
#                  +----- y_train.txt          : Result labels (2947)
#               train
#                  +----- subject_train.txt    : Subject Identifiers of the 7352 train records
#                  +----- X_train.txt          : Train data (7352) records. Each record is a 561 features vector
#                  +----- y_train.txt          : Result labels (7352)
activity_labels <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/activity_labels.txt"), 
                              sep = " ", col.names = c("code", "label"),
                              colClasses = c("numeric","character"))

# Feature names (561)
features <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/features.txt"), 
                              sep = " ", col.names = c("num", "name"),
                              colClasses = c("numeric","character"))

# Features col_names: Transform the feature names to a valid colname
feature_col_names <- str_replace_all(features$name, "[()]", "_")
feature_col_names <- str_replace_all(feature_col_names, "[-,]", ".")

features_selected <- grepl("mean__|std__", feature_col_names)


# Test Data
# X_test.txt
X_test_matrix <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/test/X_test.txt"),
                            na.strings = "",
                            col.names = feature_col_names
                           )

# Subjects ids for test data
subject_test <- read.table(unzip("dataset.zip", 
                                 "./UCI HAR Dataset/test/subject_test.txt"), 
                           col.names = c("subject"))

# Labels results for test data
Y_test <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/test/y_test.txt"), 
                     col.names = c("activity"))


# Training Data
# X_train.txt
X_train_matrix <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/train/X_train.txt"),
                             na.strings = "",
                             col.names = feature_col_names
)

# Subjects ids for train data
subject_train <- read.table(unzip("dataset.zip", 
                                  "./UCI HAR Dataset/train/subject_train.txt"), 
                            col.names = c("subject"))

# Labels results for train data
Y_train <- read.table(unzip("dataset.zip", "./UCI HAR Dataset/train/y_train.txt"), 
                      col.names = c("activity"))


Dataset_test <- cbind(subject_test, subset(X_test_matrix, select=features_selected), Y_test)
Dataset_test$activity <- as.factor(Dataset_test$activity)
levels(Dataset_test$activity) <- activity_labels$label

Dataset_train <- cbind(subject_train, subset(X_train_matrix, select=features_selected), Y_train)
Dataset_train$activity <- as.factor(Dataset_train$activity)
levels(Dataset_train$activity) <- activity_labels$label


Dataset <- rbind(Dataset_test, Dataset_train)

FinalDataset <- aggregate(Dataset[, colnames(Dataset) %in% feature_col_names[features_selected]], 
                          data=Dataset, by=c("activity", "subject"), FUN=mean)

FinalDataset <- FinalDataset[order(FinalDataset$activity,FinalDataset$subject),]
