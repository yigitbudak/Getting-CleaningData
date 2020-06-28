#Setting Working Directory

setwd("~/Desktop/Coursera/Getting and Cleaning Data/Project Assignment")

#Reading Info Data

feature_name <- read.table("features.txt")
activity_label <- read.table("activity_labels.txt", header = FALSE)

#Reading Data from Train Folder
subject_train <- read.table("train/subject_train.txt", header = FALSE)
y_train <- read.table("train/y_train.txt", header = FALSE)
x_train <- read.table("train/X_train.txt", header = FALSE)

#Reading Data from Test Folder
subject_test <- read.table("test/subject_test.txt", header = FALSE)
y_test <- read.table("test/y_test.txt", header = FALSE)
x_test <- read.table("test/X_test.txt", header = FALSE)

#Merging Each Category (Test + Train Data)

subject_merged<- rbind(subject_test, subject_train)
features_merged<- rbind(x_test, x_train)
labels_merged<- rbind(y_test, y_train)

#Naming the columns
colnames(subject_merged)<-"Subject"
colnames(labels_merged)<- "ActivityLabel"
colnames(features_merged)<-feature_name[,2]

#Merging entire dataset

full_data<- cbind(subject_merged, labels_merged, features_merged)

#Retrieving columns that have mean or standart deviation 

column_numbers<-grep(".*Mean.*|.*Std.*", names(full_data), ignore.case=TRUE)
column_numbers<- c(column_numbers,1,2)
filtered_data<-full_data[,column_numbers]

#Naming the activity names by using activity label dataset

for (i in 1:6) {
    filtered_data$ActivityLabel[filtered_data$ActivityLabel==i]<- as.character(activity_label[i,2])
}

#changing the acronyms
names(filtered_data)

names(filtered_data)<- gsub("Gyro", "Gyroscope", names(filtered_data))
names(filtered_data)<- gsub("^f", "Frequency", names(filtered_data))
names(filtered_data)<- gsub("^t", "Time", names(filtered_data))
names(filtered_data)<- gsub("-std()", "StandardDeviation", names(filtered_data), ignore.case = TRUE)
names(filtered_data)<- gsub("-mean()", "Mean", names(filtered_data), ignore.case = TRUE)

names(filtered_data)

filtered_data<- data.table(filtered_data)

#Creating a second, independent tidy data set with 
#the average of each variable for each activity and each subject
#and extracting it to txt file named "TidyData"

TidyData<- aggregate(.~Subject+ActivityLabel,data = filtered_data,mean)

write.table(TidyData, file="TidyData.txt", row.names = FALSE)

