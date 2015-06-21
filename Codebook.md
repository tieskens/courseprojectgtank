---
title: "Codebook.md"
author: "Frank Tieskens"
date: "Sunday, June 21, 2015"
output: html_document
---

## Summary Human Activity Recognition Using Smartphones Data Set 

This file describes how the dataset Samsung_Data.txt was created from the original dataset "Human Activity Recognition Using Smartphones Data Set" 
[Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.]
Furthermore, it describes the different variables in the dataset.

The dataset contains a summary of both the Test and Training data from the original dataset. For each of the 30 test subjects, and each of the six activities, it contains the average of both the mean and standard deviation of all the measurements. 


### Code used to create dataset

First, we import all data into R
```
library(dplyr)
testresults<- read.table("./test/X_test.txt")
testsubjects <- read.table("./test/subject_test.txt")
testlabels <- read.table("./test/Y_test.txt")
trainresults<- read.table("./train/X_train.txt")
trainsubjects <- read.table("./train/subject_train.txt")
trainlabels <- read.table("./train/Y_train.txt")
```
Next, we look at the variable names in features.txt and the activty labels
```
namesforcolumns <- read.table("features.txt")
namesforactivity <- read.table("activity_labels.txt")
```
this way, we can assign names to the columns and testresults, trainresults
```
colnames(testresults)<- namesforcolumns[,2]
colnames(trainresults) <- namesforcolumns[,2]
```
Furthermore, we can change the names for the activities
```
neatnamestrain <- factor(as.factor(trainlabels[,1]),
                    levels = namesforactivity[,1],
                    labels = namesforactivity[,2])

neatnamestest<-factor(as.factor(testlabels[,1]),
                      levels = namesforactivity[,1],
                      labels = namesforactivity[,2])
```
Then we merge the subjectfiles with the resultfiles
```
frametest = data.frame(testsubjects,neatnamestest,testresults) 
frametrain = data.frame(trainsubjects,neatnamestrain,trainresults)
```

Now, we change the name to the label column in both data frames into 'activity'
```
colnames(frametest)[2]<- "activity"
colnames(frametrain)[2]<- "activity"
```
Then, we add the training observations to the test observations
```
alldata <- rbind (frametest,frametrain)
```
For tidiness, we change the name of the first column into subject number
```
colnames(alldata)[1]<- "Subject_number"
```
Now we only select the variables that contain means or standard deviations + the subject nr and activity
```
goalframe1 <- select(alldata,Subject_number:activity,contains("mean"),contains("std"),-contains("freq"),-contains("angle"))
```
This is our final data frame for now. For the mean of each suject and eacht activity
we group goalframe1, and then calculate the average for each variable.
```
forsummary <- group_by(goalframe1,Subject_number,activity)

goalframe2<- summarise_each(forsummary,funs(mean))

write.table(goalframe2,"SamsungData.txt",row.name=FALSE)```
```


### Variables in the dataset
- "Subject_number": Number used to identity the subject
- "activity": One of the six activities in the test: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING and LAYING
- "tBodyAcc.mean...X": the average of the mean of the body acceleration in the X direction 
- "tBodyAcc.mean...Y": the average of the mean of the body acceleration in the Y direction 
- "tBodyAcc.mean...Z": the average of the mean of the body acceleration in the Z direction
- "tGravityAcc.mean...X": the average of the mean of the gravity acceleration in the X direction 
- "tGravityAcc.mean...Y": the average of the mean of the gravity acceleration in the Y direction 
- "tGravityAcc.mean...Z": the average of the mean of the gravity acceleration in the Z direction 
- "tBodyAccJerk.mean...X": the average of the mean of the Jerk signal for the body acceleration in the X direction 
- "tBodyAccJerk.mean...Y": the average of the mean of the Jerk signal for the body acceleration in the y direction 
- "tBodyAccJerk.mean...Z": the average of the mean of the Jerk signal for the body acceleration in the Z direction
- "tBodyGyro.mean...X": the average of the mean of the gyroscope signal in the X direction 
- "tBodyGyro.mean...Y": the average of the mean of the gyroscope signal in the Y direction 
- "tBodyGyro.mean...Z": the average of the mean of the gyroscope signal in the Z direction 
- "tBodyGyroJerk.mean...X": the average of the mean of the Jerk signal for the gyroscope in the X direction
- "tBodyGyroJerk.mean...Y": the average of the mean of the Jerk signal for the gyroscope in the Y direction 
- "tBodyGyroJerk.mean...Z": the average of the mean of the Jerk signal for the gyroscope in the Z direction 
- "tBodyAccMag.mean..": the average of the mean of the magnitude of body acceleration 
- "tGravityAccMag.mean..": the average of the mean of the magnitude of gravity acceleration  
- "tBodyAccJerkMag.mean..": the average of the mean of magnitude of the Jerk signal for the body acceleration
- "tBodyGyroMag.mean..": the average of the mean of the magnitude of the gyroscope signal
- "tBodyGyroJerkMag.mean..": the average of the mean of the magnitude of the Jerk signal for the gyroscope 
- "fBodyAcc.mean...X": average of the mean of the Fast Fourier Transformed body acceleration in the X direction
- "fBodyAcc.mean...Y": average of the mean of the Fast Fourier Transformed body acceleration in the Y direction 
- "fBodyAcc.mean...Z": average of the mean of the Fast Fourier Transformed body acceleration in the Z direction 
- "fBodyAccJerk.mean...X": average of the mean of the Fast Fourier Transformed Jerk signal for the body acceleration in the X direction 
- "fBodyAccJerk.mean...Y": average of the mean of the Fast Fourier Transformed Jerk signal for the body acceleration in the Y direction 
- "fBodyAccJerk.mean...Z": average of the mean of the Fast Fourier Transformed Jerk signal for the body acceleration in the Z direction 
- "fBodyGyro.mean...X": average of the mean of the Fast Fourier Transformed gyroscope signal in the X direction 
- "fBodyGyro.mean...Y": average of the mean of the Fast Fourier Transformed gyroscope signal in the Y direction 
- "fBodyGyro.mean...Z": average of the mean of the Fast Fourier Transformed gyroscope signal in the Z direction 
- "fBodyAccMag.mean..": average of the mean of the Fast Fourier Transformed magnitude of the body acceleration
- "fBodyBodyAccJerkMag.mean..": average of the mean of the Fast Fourier Transformed magnitude of the Jerk signal for the body acceleration  
- "fBodyBodyGyroMag.mean..": average of the mean of the Fast Fourier Transformed magnitude of the gyroscope signal 
- "fBodyBodyGyroJerkMag.mean..": average of the mean of the Fast Fourier Transformed magnitude of the Jerk signal for the gyroscope 
- "tBodyAcc.std...X": the average of the std of the body acceleration in the X direction 
- "tBodyAcc.std...Y": the average of the std of the body acceleration in the Y direction 
- "tBodyAcc.std...Z": the average of the std of the body acceleration in the Z direction
- "tGravityAcc.std...X": the average of the std of the gravity acceleration in the X direction 
- "tGravityAcc.std...Y": the average of the std of the gravity acceleration in the Y direction 
- "tGravityAcc.std...Z": the average of the std of the gravity acceleration in the Z direction 
- "tBodyAccJerk.std...X": the average of the std of the Jerk signal for the body acceleration in the X direction 
- "tBodyAccJerk.std...Y": the average of the std of the Jerk signal for the body acceleration in the y direction 
- "tBodyAccJerk.std...Z": the average of the std of the Jerk signal for the body acceleration in the Z direction
- "tBodyGyro.std...X": the average of the std of the gyroscope signal in the X direction 
- "tBodyGyro.std...Y": the average of the std of the gyroscope signal in the Y direction 
- "tBodyGyro.std...Z": the average of the std of the gyroscope signal in the Z direction 
- "tBodyGyroJerk.std...X": the average of the std of the Jerk signal for the gyroscope in the X direction
- "tBodyGyroJerk.std...Y": the average of the std of the Jerk signal for the gyroscope in the Y direction 
- "tBodyGyroJerk.std...Z": the average of the std of the Jerk signal for the gyroscope in the Z direction 
- "tBodyAccMag.std..": the average of the std of the magnitude of body acceleration 
- "tGravityAccMag.std..": the average of the std of the magnitude of gravity acceleration  
- "tBodyAccJerkMag.std..": the average of the std of magnitude of the Jerk signal for the body acceleration
- "tBodyGyroMag.std..": the average of the std of the magnitude of the gyroscope signal
- "tBodyGyroJerkMag.std..": the average of the std of the magnitude of the Jerk signal for the gyroscope 
- "fBodyAcc.std...X": average of the std of the Fast Fourier Transformed body acceleration in the X direction
- "fBodyAcc.std...Y": average of the std of the Fast Fourier Transformed body acceleration in the Y direction 
- "fBodyAcc.std...Z": average of the std of the Fast Fourier Transformed body acceleration in the Z direction 
- "fBodyAccJerk.std...X": average of the std of the Fast Fourier Transformed Jerk signal for the body acceleration in the X direction 
- "fBodyAccJerk.std...Y": average of the std of the Fast Fourier Transformed Jerk signal for the body acceleration in the Y direction 
- "fBodyAccJerk.std...Z": average of the std of the Fast Fourier Transformed Jerk signal for the body acceleration in the Z direction 
- "fBodyGyro.std...X": average of the std of the Fast Fourier Transformed gyroscope signal in the X direction 
- "fBodyGyro.std...Y": average of the std of the Fast Fourier Transformed gyroscope signal in the Y direction 
- "fBodyGyro.std...Z": average of the std of the Fast Fourier Transformed gyroscope signal in the Z direction 
- "fBodyAccMag.std..": average of the std of the Fast Fourier Transformed magnitude of the body acceleration
- "fBodyBodyAccJerkMag.std..": average of the std of the Fast Fourier Transformed magnitude of the Jerk signal for the body acceleration  
- "fBodyBodyGyroMag.std..": average of the std of the Fast Fourier Transformed magnitude of the gyroscope signal 
- "fBodyBodyGyroJerkMag.std..": average of the std of the Fast Fourier Transformed magnitude of the Jerk signal for the gyroscope 