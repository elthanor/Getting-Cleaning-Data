require(plyr)
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE)
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE)
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE)
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
names(subtest)<-"Subject"
names(subtrain)<-"Subject"
names(ytrain)<-"ActivityID"
names(ytest)<-"ActivityID"
names(activities)<-c("ActivityID","Activity")
names(xtest)<-features$V2
names(xtrain)<-features$V2

dttrain <- cbind(subtrain, ytrain ,xtrain)
dttest <- cbind(subtest, ytest ,xtest)
dt<-rbind(dttrain,dttest)

dt<-dt[,grep("mean|std|Subject|ActivityID",names(dt))]

dt<-join(dt,activities,by="ActivityID")
dt<-cbind(dt$Subject,dt$Activity,dt[,3:81])
names(dt)[1:2]<-c("Subject","Activity")

names(dt)<-gsub("Acc","Acceleration",names(dt))
names(dt)<-gsub("Gyro","AngularSpeed",names(dt))
names(dt)<-gsub("Mag","Magnitude",names(dt))
names(dt)<-gsub("^t","TimeDomain",names(dt))
names(dt)<-gsub("std","StandardDeviation",names(dt))
names(dt)<-gsub("mean","Mean",names(dt))
names(dt)<-gsub("Freq","Frequency",names(dt))
names(dt)<-gsub("^f","FrequencyDomain",names(dt))

avgdt<-ddply(dt,c("Subject","Activity"),numcolwise(mean))
write.table(avgdt, file = "Averages by Activities & Subjects.txt")
rm(xtest,xtrain,ytest,ytrain,subtrain,subtest,dttrain,dttest,activities,dt,features)