getwd()
list.files()
list.files()

install.packages("tidyverse")
install.packages("reshape2")
library(tidyverse)
library(reshape2)
# Change the directory to test folder to read the test data
setwd("/Users/mansimodi/Desktop/ds_coursera_cert/get_and_clean_data/Getcleandata/UCI HAR Dataset/test/")

x_test <- read.table("X_test.txt")
head(x_test)
y_test <- read.table("Y_test.txt")
subject_test <- read.table("subject_test.txt")

# Change the directory to train folder to read the train data
setwd("../") # brings you up one level, similar to cd..
setwd("./train") # sets the working directory to train
x_train <- read.table("X_train.txt")
head(x_train)
y_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")

setwd("../") 

activity_labels <- read.table("activity_labels.txt")
# features_info <- read.table("features_info.txt")
features <- read.table("features.txt")

# question 1
# merge the training and testing data
merged_x <- rbind(x_train, x_test)
head(merged_data)

# question 2
# extract only the measurements on the mean and std for each measurement
names(x_train)
names(y_train)
names(subject_train)
names(x_test)
names(y_test)
names(subject_test)
names(activity_labels)
names(features)

# get the rows that have mean and std 
meanstdrow <- grep("mean[^F]|std", features[,2])
head(meanstdrow, 10)
rows_merged_x <- merged_x[,meanstdrow]
merged_y <- rbind(y_train, y_test)
merged_subject <- rbind(subject_train, subject_test)

# check the data for activity labels
head(activity_labels)

# Extract the names of the features where the nean and std exist
meanstdnames <- features[meanstdrow, 2] # this selects the row numbers corresponding to meanstsrow data from the features dataset, and column 2.
meanstdnames <- tolower(meanstdnames)
meanstdnames <- gsub("[()]", "", meanstdnames)
meanstdnames <- gsub("[-]", " ", meanstdnames)
names(rows_merged_x) <- meanstdnames

names(merged_subject) <- "subject"
names(merged_y) <- "activ"

names(activity_labels) <- c("number", "activity")
activity_labels$activity <- tolower(activity_labels$activity)
activity_labels$activity <- gsub("_", " ", activity_labels$activity)

# final cleaned data

cleaned_data <- cbind(rows_merged_x, merged_subject, merged_y)
cleaned_data <- merge(cleaned_data, activity_labels, by.x = "activ", by.y = "number", sort= FALSE)
cleaned_data$activ <- NULL

cleaned_data_melt <- melt(cleaned_data, id = c("subject", "activity"))
cleaned_data_melt_cast <- dcast(cleaned_data_melt, subject +  activity~ variable, mean)
write.table(cleaned_data_melt_cast, file = "cleanedtxt.txt", row.names= FALSE)
getwd()
