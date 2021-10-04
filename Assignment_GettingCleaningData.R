install.packages("plyr")
install.packages("dplyr")
install.packages("reshape2")

library(plyr)
library(dplyr)
library(reshape2)

setwd("C:/Users/Val/Documents/R/Assignments/Getting and Cleaning Data")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "", dec = ".")
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "", dec = ".")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", dec = ".")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE, sep = "", dec = ".")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "", dec = ".")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", dec = ".")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE, sep = "", dec = ".")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "", dec = ".")

for (i in 1:dim(X_train)[2])
{
        colnames(X_train)[i] <- features$V2[i]
        colnames(X_test)[i] <- features$V2[i]
}

Y_train <- rename(Y_train, activity_tr = "V1")
subject_train <- rename(subject_train, subject = "V1")

Y_test <- rename(Y_test, activity_te = "V1")
subject_test <- rename(subject_test, subject = "V1")

Train <- subject_train %>% cbind(Y_train)%>%cbind(X_train)
Test <- subject_test %>%cbind(Y_test)%>%cbind(X_test)

Unique_set <- merge(Train, Test, by.x = "subject", by.y = "subject", all = TRUE)

Train_Test <- as.vector(dim(Unique_set)[1], mode = "any")
Activity <- as.vector(dim(Unique_set)[1], mode = "any")

for (i in 1:dim(Unique_set)[1])
{
        if (is.na(Unique_set$activity_te[i]))
        {
                Train_Test[i] <- "Train"
                Activity[i] <- Unique_set$activity_tr[i]
        }
        else
        {
                Train_Test[i] <- "Test"
                Activity[i] <- Unique_set$activity_te[i]
        }
}

Train_Test <- as.data.frame(Train_Test)
Activity <- as.data.frame(Activity)

Train_int <- Train[,3:dim(Train)[2]]
Test_int <- Test[,3:dim(Test)[2]]

Subject <- rbind(subject_train, subject_test)

Clean_set <- rbind(Train_int, Test_int)

Unique_set <- Train_Test %>% cbind(Subject)%>%cbind(Activity)%>%cbind(Clean_set)

ind <- c(grep("Train_Test", colnames(Unique_set)), grep("subject", colnames(Unique_set)), grep("Activity", colnames(Unique_set)), grep("mean", colnames(Unique_set)), grep("std", colnames(Unique_set)))
Mean_Std <- rename(Unique_set[,ind], activity_code = "Activity")

activity_labels <- rename(activity_labels, activity_code = "V1", activity_name = "V2")
Mean_Std_Act <- merge(activity_labels, Mean_Std,by.x = "activity_code", by.y = "activity_code", all = TRUE)

Unique_Id <- cbind(select(Mean_Std_Act,(activity_name)),select(Mean_Std_Act,(subject)))
Unique_Id_Fin <- as.vector(dim(Unique_Id)[1], mode = "any")

for (i in 1:dim(Unique_Id)[1])
{
        Unique_Id_Fin[i] <- paste(Unique_Id$activity_name[i],Unique_Id$subject[i])
}

Unique_Id_Fin <- as.data.frame(Unique_Id_Fin)

Mean_Std_Act_2 <- cbind(Unique_Id_Fin, Mean_Std_Act[,5:dim(Mean_Std_Act)[2]])

Activity_Subject <- group_by(Mean_Std_Act_2, Unique_Id_Fin)

Activity_Subject_Mean <- summarise_all(Activity_Subject,funs(mean))

write.csv(Activity_Subject_Mean, file = "Activity_Subject_Mean.csv")