#Merges the training and the test sets to create one data set.
Subject_test<-read.table("subject_test.txt")
Subject_train<-read.table("subject_train.txt")
Subject<-rbind(Subject_test,Subject_train)

X_test<-read.table("X_test.txt")
X_train<-read.table("X_train.txt")
X<-rbind(X_test,X_train)

Y_test<-read.table("y_test.txt")
Y_train<-read.table("y_train.txt")
Y<-rbind(Y_test,Y_train)

data<-cbind(Y,Subject,X)

#Extracts only the measurements on the mean and standard deviation for each measurement.
X<-X[,c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,
        294:296,345:349,373:375,424:429,452:454,503:504,513,516:517,526,529:530
        ,539,542:543,552,555:561)]
data1<-cbind(Y,Subject,X)
names(data1)[1]<-"Y"
names(data1)[2]<-"Subject"

#Uses descriptive activity names to name the activities in the data set
activity_labels<-read.table("activity_labels.txt")
activity_labels$V2<-as.character(activity_labels$V2)
names(activity_labels)[1]<-"Y"
names(activity_labels)[2]<-"activities"
data2<-merge(activity_labels,data1,by="Y")

#Appropriately labels the data set with descriptive variable names
feature<-read.table("features.txt")
feature$V2<-as.character(feature$V2)
feature<-feature[c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,240:241,253:254,266:271,
                    294:296,345:349,373:375,424:429,452:454,503:504,513,516:517,526,529:530
                    ,539,542:543,552,555:561),]
data3<-data2
for(i in 1:85)
{
  names(data3)[i+3]<-feature$V2[i]
}

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sumarrize<-split(data3[,4:88],data3$activities)
data4<-matrix(rep(0,510),6,85)
for (i in 1:6)
{
  data4[i,]<-apply(sumarrize[[i]],2,mean)
}
activity<-c("LAYING","SITTING ","STANDING","WALKING","WALKING_DOWNSTAIRS","WALKING_UPSTAIRS")
data4<-cbind(activity,data4)
data5<-data.frame(data4)
for(i in 2:86)
{
  names(data5)[i]<-feature$V2[i]
}
