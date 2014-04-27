This file explains the structure of "result.ds.csv", "avg.var.act.subj.csv" 
and the structure of functions in order to get these files with tidy data sets.


result.ds.csv

This file contains a tidy data set with all the information from the measurements from all variables with their 
respective activities and subjects.

From left to right columns have the following structure:
1.	activity.code: numerical code for each activity.  1 WALKING, 2 WALKING_UPSTAIRS ,3 WALKING_DOWNSTAIRS, 
    4 SITTING, 5 STANDING, and 6 LAYING.
2.	activity.name: the name of the activity.
3.	Subject: the subject that performs the activity.
4.	Column 4 to 564: each one the variables, from “tBodyAcc-mean()-X” to “angle(Z,gravityMean)”.
This data set contains a total of 10299 rows and 564 columns.
This data set is created by the “create.data.set()” function.


avg.var.act.subj.csv

This file contains a tidy data set with the average of each variable for each activity and each subject.
From left to right columns have the following structure:
1.	Variable: this column contains the name of the variable.
2.	Activity: this column contains the activity number, from 1 to 6.
3.	Subject: this column contains the number code for each one of the 30 activities, from 1 to 30.
4.	Mean: this column contains the mean for each one of the possible combinations (a total of 100980).
This data set contains a total of 100980 rows and 4 columns.
This data set is created by the “subset.means()” function.


Functions to perform the lecture of source information, analysis and creation of tidy data sets are located in “run_analysis.R”. 
This R script contains 3 functions in the following order:
•	create.data.set(): This function was made to read all the necessary files and build the tidy data set with all the information 
requested in the project. All .txt source files must be located in the working directory within their original folder 
"UCI HAR Dataset"and with their original organization. This function returns the tidy data set to a data frame and creates a 
file called "result.ds.csv".  For a better explanation on how this function works please see the respective comments on “run_analysis.R” file.
•	values.in.mean.stdev(): This Function extracts the values that are between -1 standard deviation and +1 standard deviation from the mean 
for each measurement(each column) for a given data frame. The function receives a data frame and returns a list containing all the values that 
meet the restriction for each measurement. Each element of the list contain processed values for each column of the original received data frame.
•	subset.means():This Function receive a data frame result from the previous function (create.data.set) and returns a tidy data set with 
calculated means for each variable, activity and subject. It, returns a total of 100980 rows (561*6*30) and spends aprox 2 mins and 50 sec to
finish the process.(I hope to improve this time in the future). This function creates a file called "avg.var.act.subj.csv" with the resulting data set.
