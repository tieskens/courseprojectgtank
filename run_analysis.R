## First, we import all data into R

library(dplyr)
testresults<- read.table("./test/X_test.txt")
testsubjects <- read.table("./test/subject_test.txt")
testlabels <- read.table("./test/Y_test.txt")
trainresults<- read.table("./train/X_train.txt")
trainsubjects <- read.table("./train/subject_train.txt")
trainlabels <- read.table("./train/Y_train.txt")

## Next, we look at the variable names in features.txt and the activty labels
namesforcolumns <- read.table("features.txt")
namesforactivity <- read.table("activity_labels.txt")

## this way, we can assign names to the columns and testresults, trainresults
colnames(testresults)<- namesforcolumns[,2]
colnames(trainresults) <- namesforcolumns[,2]

## furthermore, we can change the names for the activities
neatnamestrain <- factor(as.factor(trainlabels[,1]),
                    levels = namesforactivity[,1],
                    labels = namesforactivity[,2])

neatnamestest<-factor(as.factor(testlabels[,1]),
                      levels = namesforactivity[,1],
                      labels = namesforactivity[,2])

## Then we merge the subjectfiles with the resultfiles
frametest = data.frame(testsubjects,neatnamestest,testresults) 
frametrain = data.frame(trainsubjects,neatnamestrain,trainresults)

#Now, we change the name to the label column in both data frames into 'activity'

colnames(frametest)[2]<- "activity"
colnames(frametrain)[2]<- "activity"

#Then, we add the training observations to the test observations

alldata <- rbind (frametest,frametrain)

#For tidiness, we change the name of the first column into subject number

colnames(alldata)[1]<- "Subject_number"

#Now we only select the variables that contain means or standard deviations + the subject nr and activity

goalframe1 <- select(alldata,Subject_number:activity,contains("mean"),contains("std"),-contains("freq"),-contains("angle"))


## This is our final data frame for now. For the mean of each suject and eacht activity
## we group goalframe1, and then calculate the average for each variable.

forsummary <- group_by(goalframe1,Subject_number,activity)

goalframe2<- summarise_each(forsummary,funs(mean))

write.table(goalframe2,"SamsungData.txt",row.name=FALSE)