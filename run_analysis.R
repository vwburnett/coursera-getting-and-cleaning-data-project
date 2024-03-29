#Getting and Cleaning Data Project

#Download files
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "Coursera_GettingandCleaningdata_project_dataset.zip"

if(!file.exists(filename)){
  download.file(fileUrl,filename)
}

#unzip files
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

# Reading trainings tables:
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table("UCI HAR Dataset/features.txt" )

# Reading activity labels:
activityLabels = read.table("UCI HAR Dataset/activity_labels.txt")

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merging all data in one set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

#Reading column names
colNames <- colnames(setAllInOne)

#Create vector for defining ID, mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#MAking nessesary subset from setAllInOne
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

#Using descriptive activity names to name the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#Making second tidy data set
TidyDataSet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectId, TidyDataSet$activityId),]

#Write second tidy data set in txt file
write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)

