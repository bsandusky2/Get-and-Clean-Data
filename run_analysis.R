#10299 Obs, 561 variables

install.packages("readtext")
library(readtext)
install.packages("readr")
library(readr)
library(plyr)
install.packages("dplyr")
library(dplyr)
install.packages("tidyverse")
library(tidyverse)
install.packages("magrittr")
library(magrittr)

features<- read.table("features.txt",col.names = c("n","functions"))
activities<- read.table("activity_labels.txt",col.names = c("code","activity"))

#Take x training and x test data and merge them
xTrain<- read.table("X_train.txt", col.names = features$functions )
xTest<- read.table("X_test.txt", col.names = features$functions )
dataX<- rbind(xTrain,xTest)

# Take y training and y test data and merge them
yTrain<- read.table("y_train.txt", col.names = "code" )
yTest<- read.table("y_test.txt", col.names = "code" )
dataY<- rbind(yTrain,yTest)

#Read training subject and test subject data and merge them
subjectTrain<- read.table("subject_train.txt", col.names = "Subject")
subjectTest<- read.table("subject_test.txt", col.names = "Subject")
subject<- rbind(subjectTrain,subjectTest)

#merge all data
mergedata<- cbind(subject,dataX,dataY)

#Extract columns with mean and standard deviation
TidyData<- mergedata %>% select(code,Subject,contains("mean"),contains("std"))

#Add activity descriptions instead of activity IDs
TidyData$code<- activities[TidyData$code,2]

#label variables in dataset
names(TidyData)[1] = "Activity"
names(TidyData) <- gsub("Acc", "Accelerometer",names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope",names(TidyData))
names(TidyData)<- gsub("BodyBody","Body",names(TidyData))
names(TidyData) <- gsub("Mag","Magnitude",names(TidyData))
names(TidyData) <- gsub("^t","Time",names(TidyData))
names(TidyData) <-gsub("^f","Frequency",names(TidyData))
names(TidyData) <- gsub("tBody","TimeBody",names(TidyData))
names(TidyData) <- gsub("-mean()","Mean",names(TidyData),ignore.case = TRUE)
names(TidyData) <- gsub("-std()","STD",names(TidyData),ignore.case = TRUE)
names(TidyData) <- gsub("-freq()","Frequency",names(TidyData),ignore.case = TRUE)
names(TidyData) <- gsub("angle","Angle",names(TidyData),ignore.case = TRUE)
names(TidyData) <- gsub("gravity","Gravity",names(TidyData),ignore.case = TRUE)

#Group data by activity and subject and take mean and then write it to a text file
SummaryData<- TidyData %>%
    group_by(Subject,Activity) %>% 
    summarise_all(mean)
write.table(SummaryData,"SummaryData.txt",row.names = FALSE)






