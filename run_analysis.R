
#Setting directory and loading dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Listing the files
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)

#Organizing the data
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

#Merging the data
subject <- rbind(subjectTrain, subjectTest)
activity<- rbind(activityTrain, activityTest)
features<- rbind(featuresTrain, featuresTest)

#Setting the data
names(subject)<-c("subject")
names(activity)<- c("activity")
featuresNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(features)<- featuresNames$V2
allData <- cbind(subject, activity)
Data <- cbind(features, allData)

#Creating a dataResume with the course's calculations
SDFeaturesNames<-featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectedNames<-c(as.character(SDFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Describing activities
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
Data$activity <- factor(Data$activity, labels = activityLabels$V2)
head(Data$activity,30)

#Making better the variables names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Creating the task result
library(plyr)
newData<-aggregate(. ~subject + activity, Data, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "Tidy-Data.txt",row.name=FALSE)

#Producing Codebook
library(knitr)
knit2html("codebook.md")





