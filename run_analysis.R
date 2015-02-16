setwd("~/Desktop/Coursera/Getting and Cleaning Data/Course_Project")
library(plyr)
library(dplyr)

### Merge training and test datasets to create the master
### dataset

x_train <- read.table("X_train.txt", sep = "")
y_train <- read.table("Y_train.txt")
sub_train <- read.table("subject_train.txt")

x_test <- read.table("X_test.txt", sep = "")
y_test <- read.table("Y_test.txt")
sub_test <- read.table("subject_test.txt")

### Create datasets
x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

sub_data <- rbind(sub_train, sub_test)

### Extract only the measurements (columns) on the mean and  
### standard deviation for each data set. 

features <- read.table("features.txt")
mean_std_Col <- grep("(*mean|*std)\\()", features[,2])
x_data <- x_data[,mean_std_Col]

### Combine datasets into one dataset combined_data. Label 
### combined_data with appropriate descriptive variable names

combined_data <- cbind(sub_data, y_data, x_data)
names(combined_data) <- c("subject", "activity",
                     tolower(features[mean_std_Col, 2]))
                     
### Assign descriptive activity names to name the activities 
### in the data set

activity <- read.table("activity_labels.txt")
combined_data[,2] <- activity[combined_data[,2], 2]

### Calculate the mean fo each subject for each activity

avg_data <- ddply(combined_data, .(subject, activity), 
                  function(x) colMeans(x[,3:68]))

write.table(avg_data, "tidy.txt", row.names = FALSE)

 

