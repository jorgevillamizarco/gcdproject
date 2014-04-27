##############################################
## Getting and Cleaning Data Course Project ##
##############################################
## jorgevillamizarco ##
#######################


## Function to read all necessary files and build the tidy data set with all the information requested.
## All .txt source files must be located on the working directory within their original folder "UCI HAR Dataset"
## and with their original organization. This function creates a file called "result.ds.csv".
create.data.set <- function(){
  
  ## read all the files
  activity <- read.table("UCI HAR Dataset/activity_labels.txt")
  xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
  xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
  features <- read.table("UCI HAR Dataset/features.txt")
  ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
  ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")
  strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
  stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
  actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
  
  ## create a data frame with activity names
  ytest2 <- ytest
  
  ytest2[ytest2$V1 == 1,] <- as.character(actlabels[1,2]) ##WALKING
  ytest2[ytest2$V1 == 2,] <- as.character(actlabels[2,2]) ##WALKING_UPSTAIRS
  ytest2[ytest2$V1 == 3,] <- as.character(actlabels[3,2]) ##WALKING_DOWNSTAIRS
  ytest2[ytest2$V1 == 4,] <- as.character(actlabels[4,2]) ##SITTING
  ytest2[ytest2$V1 == 5,] <- as.character(actlabels[5,2]) ##STANDING
  ytest2[ytest2$V1 == 6,] <- as.character(actlabels[6,2]) ##LAYING
  
  ytest <- cbind(ytest,ytest2)
  
  ## create a data frame with activity names
  ytrain2 <- ytrain
  
  ytrain2[ytrain2$V1 == 1,] <- as.character(actlabels[1,2]) ##WALKING
  ytrain2[ytrain2$V1 == 2,] <- as.character(actlabels[2,2]) ##WALKING_UPSTAIRS
  ytrain2[ytrain2$V1 == 3,] <- as.character(actlabels[3,2]) ##WALKING_DOWNSTAIRS
  ytrain2[ytrain2$V1 == 4,] <- as.character(actlabels[4,2]) ##SITTING
  ytrain2[ytrain2$V1 == 5,] <- as.character(actlabels[5,2]) ##STANDING
  ytrain2[ytrain2$V1 == 6,] <- as.character(actlabels[6,2]) ##LAYING
  
  ytrain <- cbind(ytrain,ytrain2)
  
  colnames(xtest) <- features[,2]
  colnames(xtrain) <- features[,2]
  
  colnames(ytest)[1] <- "activity.code"
  colnames(ytest)[2] <- "activity.name"
  colnames(ytrain)[1] <- "activity.code"
  colnames(ytrain)[2] <- "activity.name"
  colnames(stest)[1] <- "subject"
  colnames(strain)[1] <- "subject"
  
  ## cbinding previous data frames
  xrestest <- cbind(ytest,stest,xtest)
  xrestrain <- cbind(ytrain,strain,xtrain)
  
  ##buil and return the resulting tidy data set
  final <- rbind(xrestest,xrestrain)
  write.csv(final, file = "result.ds.csv")  ##create csv file
  final 
}

## Function to extract the values that are between -1 standard deviation and +1 standard deviation
## from the mean for each measurement(each column). The function receives a data frame and returns a list containing
## all values that meet the restriction for each measurement. Eeach element of the list contain processed values for each column
## of the original received data frame.
values.in.mean.stdev <- function(x){
  
  finalmean <- colMeans(x[4:564])     ##calculate the mean for each column variable
  finalsd <- apply(x[4:564], 2, sd)   ##calculate the standart deviation for each variable
  condmenor <- finalmean-finalsd      ##calculate the upper limit of condition (mean + 1sd)
  condmayor <- finalmean+finalsd      ##calculate the lower limit of conditios (mean - 1sd)
  ref <- x[4:564]                     ##temp variable for computations  
  lengthx <- length(ref[1,])          ##extract the length of temp variable 
  lista <- vector("list", lengthx)    ##create a list to save measurements that meet the restructions
  for(i in 1:lengthx){                ##loop to walk through temp data frame
    menor <- condmenor[i]             ##conditios for evaluation 
    mayor <- condmayor[i]             
    lista[[i]] <- subset(ref[,i],(ref[,i] >= menor & ref[,i] <= mayor))  ##building of the final list based on restrictions
  }
  lista  ##returns the list
}

## This Function receive a data frame result from the previous function (create.data.set) and returns a tidy data set
## with calculated means for each variable, activity and subject. Returns a total of 100980 rows (561*6*30) and spends
## aprox 2 mins and 50 sec to finish the process.(I hope to improve this time in the future)
## This function creates a file called "avg.var.act.subj.csv" with the resulting data set.
subset.means <- function(x){
  df <- data.frame(variable= numeric(0), activity= numeric(0), subject= numeric(0), mean= numeric(0))
  df2 <- df
  for(i in 4:564){                              ##loop to walk through x columns 
    for(j in 1:6){                              ##loop to extract activities from x
      for(k in 1:30){                           ##loop to extract subjects from x 
        df[k,1] <- as.character(colnames(x[i]))   ##assign variable name to row
        df[k,2] <- as.numeric(j)                  ##assign activity name to row  
        df[k,3] <- as.numeric(k)                  ##assign subject name to row  
        df[k,4] <- mean(subset(final[,i],(x[,1] == j & x[,3] == k)))  ##calculate the mean for each subset in x data frame based on conditions
      }
      df2 <- rbind(df2, df)   ## build the final data frame to be returned
    } 
  }
  write.csv(df2, file = "avg.var.act.subj.csv")   ##create csv file
  df2 ##returning the resulting the dataframe
}
