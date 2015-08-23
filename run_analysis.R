run_analysis <- function(path = "") {
        ## download libraries
        if("plyr" %in% rownames(installed.packages()) == FALSE) {
                install.packages("plyr")
        }
        if("dplyr" %in% rownames(installed.packages()) == FALSE) {
                install.packages("dplyr")
        }
        library(plyr)
        library(dplyr)
        ## read data 
        # general labels data
        features <- read.table(paste(path, "./UCI HAR Dataset/features.txt", sep = ""))
        activity_labels <- read.table(paste(path, "./UCI HAR Dataset/activity_labels.txt", sep = ""))
        # train data
        X_train <- read.table(paste(path, "./UCI HAR Dataset/train/X_train.txt", sep = ""))
        y_train <- read.table(paste(path, "./UCI HAR Dataset/train/y_train.txt", sep = ""))
        subject_train <- read.table(paste(path, "./UCI HAR Dataset/train/subject_train.txt", sep = ""))
        # test data
        X_test <- read.table(paste(path, "./UCI HAR Dataset/test/X_test.txt", sep = ""))
        y_test <- read.table(paste(path, "./UCI HAR Dataset/test/y_test.txt", sep = ""))
                subject_test <- read.table(paste(path, "./UCI HAR Dataset/test/subject_test.txt", sep = ""))
        ## merging the training and the test data
        Total_X <- rbind(X_train, X_test)
        Total_y <- c(y_train$V1, y_test$V1)
        Total_subject <- c(subject_train$V1, subject_test$V1)
        ## Extracting the measurements on the mean and standard deviation for each measurement.
        Total_X_mean_std <- select(Total_X, grep("mean|std", features$V2, value = F))
        ## naming the data set: add activity name, names of column and subject id
        activity_labels <- as.character(activity_labels$V2)
        activity_labels <- activity_labels[Total_y]
        Total_X_mean_std <- cbind(activity_labels, Total_X_mean_std)
        Total_X_mean_std <- cbind(Total_subject, Total_X_mean_std)
        colnames(Total_X_mean_std) <- c("subject", "activity", grep("mean|std", features$V2, value = T))
        ##tidy data set with the average of each variable for each activity and each subject.
        Tidy_data <- Total_X_mean_std %>% group_by(activity, subject) %>% summarise_each(funs(mean))
        ## writing result in the .txt file
        write.table(Tidy_data, file = "Tidy_data.txt", row.name = FALSE)
        ### write the variables to codebook
        #codebook <- c("subject", "activity", grep("mean|std", features$V2, value = T))
        #codebook <- as.data.frame(codebook)
        #write.table(codebook, file = "codebook.md", row.names = F, col.names = F)
}

