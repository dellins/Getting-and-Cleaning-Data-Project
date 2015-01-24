library(data.table)

#Read the raw files into memory

testData = read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_activity = read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_subject = read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)

trainData = read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_activity = read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_subject = read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")

testData_activity$V1 <- factor(testData_activity$V1,levels=activities$V1,labels=activities$V2)
trainData_activity$V1 <- factor(trainData_activity$V1,levels=activities$V1,labels=activities$V2)

# 4. Appropriately labels the data set with descriptive activity names
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")

colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_activity)<-c("Activity")
colnames(trainData_activity)<-c("Activity")
colnames(testData_subject)<-c("Subject")
colnames(trainData_subject)<-c("Subject")

# 1. merge test and training sets into one data set, including the activities
testData<-cbind(testData,testData_activity)
testData<-cbind(testData,testData_subject)
trainData<-cbind(trainData,trainData_activity)
trainData<-cbind(trainData,trainData_subject)
allData<-rbind(testData,trainData)

# 2. extract only the measurements on the mean and standard deviation for each measurement
meanSdData <- allData[,grepl("mean|std|Subject|Activity", names(allData))]

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(meanSdData)
tidyData<-DT[,lapply(.SD,mean),by="Activity,Subject"]

#Clean up feature names
setnames(tidyData, gsub('-mean', 'Mean', names(tidyData)))
setnames(tidyData, gsub('-std', 'Std', names(tidyData)))
setnames(tidyData, gsub('[-()]', '', names(tidyData)))
setnames(tidyData, gsub('BodyBody', 'Body', names(tidyData)))

write.table(tidyData,file="tidyData.txt",row.names = FALSE)

