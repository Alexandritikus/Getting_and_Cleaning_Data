#Description for run_analysis script working

### Function call
run_analysis is a function which have only one variable - path to Samsung data sets.  By default, we considering that data is in your working directory.
But if you want you may specify you own path.

### Requirements
The function uses 'plyr' and 'dplyr' packages, so if they were not previously installed, they will be set at the start.

### Reading the data
At first using the read.table function we read all the files that we needed to create a tidy data set.

 * X_train.txt - set with data for train research
 * X_test.txt - set with data for train research
 * features.txt - describes the variable names in X_train and X_test data sets
 * y_train.txt - identifies activity type for each observations (rows) in train data set
 * y_test.txt - identifies activity type for each observations (rows) in train data set
 * activity_labels.txt - describes a type of activity depending on the id from 'y' files 
 * subject_train - identifies # of subject for each observations (rows) in train data set
 * subject_test - identifies # of subject for each observations (rows) in test data set

### Merging the training and the test data
At this stage, we merge the same type of files so that they continue to each other.

    Total_X <- rbind(X_train, X_test)
    Total_y <- c(y_train$V1, y_test$V1)
    Total_subject <- c(subject_train$V1, subject_test$V1)

Since we have not had a task analyze the data, we can not worry about the name of the column.

### Cut the data set by extracting only  the measurements on the mean and standard deviation

By using 'select' function, we create a new data set with only the mean and standard deviation.

    Total_X_mean_std <- select(Total_X, grep("mean|std", features$V2, value = F))

### Make useful data set with descriptive column names
Add the columns with type of activity and subject to our data set

    activity_labels <- as.character(activity_labels$V2)
    activity_labels <- activity_labels[Total_y]
    Total_X_mean_std <- cbind(activity_labels, Total_X_mean_std)
    Total_X_mean_std <- cbind(Total_subject, Total_X_mean_std)

Assign names for all columns

    colnames(Total_X_mean_std) <- c("subject", "activity", grep("mean|std", features$V2, value = T))

### Make a new tidy data set  with the average of each variable for each activity and each subject

    Tidy_data <- Total_X_mean_std %>% group_by(activity, subject) %>% summarise_each(funs(mean))

### Writing .txt file with tidy data in working directory
   write.table(Tidy_data, file = "Tidy_data.txt", row.name = FALSE)
