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

# 3. Get the labels of the activities, file: activity_labels.txt
activity_labels <- read.table(unzip("dataset.zip", "UCI HAR Dataset/activity_labels.txt"), 
                              sep = " ", col.names = c("code", "label"),
                              colClasses = c("numeric","character"))

# 4. The list of Feature names (561), file: features.txt
features <- read.table(unzip("dataset.zip", "UCI HAR Dataset/features.txt"), 
                              sep = " ", col.names = c("num", "name"),
                              colClasses = c("numeric","character"))

# 5. Features col_names: Transform the feature names to a valid colname
#    replacing characters "()" to __
#    then replacing "-" y "," characters to simple dots "."
feature_col_names <- str_replace_all(features$name, "[()]", "_")
feature_col_names <- str_replace_all(feature_col_names, "[-,]", ".")
# 6. A boolean vector with TRUE values corresponding to those features names 
#    that have mean__ or std__ corresponding to feactures having mean() and std() 
#    in their names.
#    This vector is going to be useful when selecting the data from X_test and X_train
features_selected <- grepl("mean__|std__", feature_col_names)

# 7. Extract Test Data from the file X_test.txt
X_test_matrix <- read.table(unzip("dataset.zip", "UCI HAR Dataset/test/X_test.txt"),
                            na.strings = "",
                            col.names = feature_col_names
                           )

# 8. Read the subjects ids for test data
subject_test <- read.table(unzip("dataset.zip", 
                                 "UCI HAR Dataset/test/subject_test.txt"), 
                           col.names = c("subject"))

# 9. Read the results for test data
Y_test <- read.table(unzip("dataset.zip", "UCI HAR Dataset/test/y_test.txt"), 
                     col.names = c("activity"))


# 10. Extract Training Data from the file X_train.txt
X_train_matrix <- read.table(unzip("dataset.zip", "UCI HAR Dataset/train/X_train.txt"),
                             na.strings = "",
                             col.names = feature_col_names
                            )

# 11. Read the subjects ids for training data
subject_train <- read.table(unzip("dataset.zip", 
                                  "UCI HAR Dataset/train/subject_train.txt"), 
                            col.names = c("subject"))

# 12. Read the results for training data
Y_train <- read.table(unzip("dataset.zip", "UCI HAR Dataset/train/y_train.txt"), 
                      col.names = c("activity"))


# 13. Use an intermediate dataset for the test data with:
#     The first column is the subject id
#     The next 66 columns correspond to the features having mean() and std() in their names
#     And the last column are the activity labels, this columns is transformed to a factor
#     being the labels the names specified in the activity_labels.txt
Dataset_test <- cbind(subject_test, subset(X_test_matrix, select=features_selected), Y_test)
Dataset_test$activity <- as.factor(Dataset_test$activity)
levels(Dataset_test$activity) <- activity_labels$label

# 14. Do the same with the training data:
#     The first column is the subject id
#     The next 66 columns correspond to the features having mean() and std() in their names
#     And the last column are the activity labels, this columns is transformed to a factor
#     being the labels the names specified in the activity_labels.txt
Dataset_train <- cbind(subject_train, subset(X_train_matrix, select=features_selected), Y_train)
Dataset_train$activity <- as.factor(Dataset_train$activity)
levels(Dataset_train$activity) <- activity_labels$label

# 15. We combine the two Datasets. This is the merged data set
Dataset <- rbind(Dataset_test, Dataset_train)

# 16. Finally we aggregate the data of the 66 features selected by activity and subject
#     according to the fifth point of the course project, and order by activity and subject
FinalDataset <- aggregate(Dataset[, colnames(Dataset) %in% feature_col_names[features_selected]], data=Dataset, 
                          by=c(Dataset["activity"], Dataset["subject"]), FUN=mean)
FinalDataset <- FinalDataset[order(FinalDataset$activity,FinalDataset$subject),]

# 17. Write the files:
# Dataset
# and FinalDataset
write.table(Dataset, file="Dataset.txt", row.name=FALSE)
write.table(FinalDataset, file="FinalDataset.txt", row.name=FALSE)