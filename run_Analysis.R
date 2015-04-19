setwd("C:\\Users\\Deepak\\Documents\\Coursera R cleaning data\\Week 4\\UCI HAR Dataset")

x_test<- read.table("test\\X_test.txt")         # Reading test data for x
x_train<- read.table("train\\X_train.txt")      # Reading traing data for x
x_data<- rbind(x_test, x_train)                 # Creating a combined test and train data of x

# reading features text, which will be heading for the combined data
heading<- read.table("features.txt")            

# column names for x_data
# these names come from "features.txt"
colnames(x_data) <- heading$V2

# each element in  "y_data" represents differnt activities
# read y_test , then read y_train and add them up in y_data
y_test<- read.table("test\\y_test.txt")
y_train<- read.table("train\\y_train.txt")
y_data <- rbind(y_test, y_train)

colnames(y_data)<- "Activity"

# change the labels of activities from numerals to real names
y_data$Activity <- factor(y_data$Activity, levels=c(1,2,3,4,5,6), 
                labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING",
                           "STANDING", "LAYING"))

# binding activities to the x_data
x_data <- cbind(y_data, x_data)


# read the subjects' idenity in test data and train data
subject_test<- read.table("test\\subject_test.txt")
subject_train<- read.table("train\\subject_train.txt")
# combine the subject data
subject <- rbind(subject_test, subject_train)
colnames(subject)<- "Subject"

# Binding subject to x data, to make a complete dataset on human activity.
# This is the dataset created by merging the training and the test sets.
# Here descriptive activity names are used to name the activities. 
# And the variable names are appropriately labeled  with descriptive names
x_data <- cbind(subject, x_data)

# These are steps to extracting only the mean and standard deviation for each measurement
# extract the approapriate headings 
selection1 <- grep("mean|std", heading$V2)
# since two more columns "Subject" and "Activity" are added, in the data, 
# these have to be taken care of as well
# each of the headings are shifted two spaces and the first two columns are selected as well
selection1 <- c(1,2, selection1+2)
# Extract_x is the final table where only mean and standard deviations for each
# measurements are added
Extract_x <- x_data[,c(selection1)]

attach(Extract_x)
#This is the final dataset where means for each participants
# and each of their activities are calculated
Final_x <-aggregate(Extract_x, by=list(Subject,Activity), FUN=mean, simplify = TRUE)
#taking down two unnecessary column

Final_x <- Final_x[,-c(3,4)]
library(plyr)
# renaming the column back to original names
# now Final_x is the final table, 
Final_x <- rename(Final_x, c("Group.1" = "Subject","Group.2" = "Activity" ))
head(Final_x)

# Saving Final_ x with write.table function
write.table(Final_x, "Final_x.txt", col.names=T, sep=" ", row.names = F) 
