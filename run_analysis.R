###########################################################
# Data cleaning Week 4 Project
# ----------------------------
#
# This R script should 
# 1. merge training and test data sets into 1
# 2. extract only mean and standard mediation measurements
# 3. Use descriptive names to name activities
# 4. label (name) the columns int he data set
# 5. create a dataset with the average of each activity  and each subject
#
##########################################################

##########################################################
# Data sets have no column headings (see step 4), and each
# data set is space " " seperated 
#
# Assume the data is in the current working directory and
# test data is in the test directory while training data is in
# the train directory.
#
# Will download the file and extract in the current directory if not there .
#
# Each directory contains the folowing files :
#   (with @@@@ = either test or train)
#
#   subject_@@@@.txt  = subject number who carried the device
#   y_@@@@.txt        = the test (1 --> 6) performed
#   X_@@@@.txt        = data with the same amount fo rows as the previous
#                       files (for matching up)
#
#
# The "main" direcotry contains a file that "describes" the
# data that we will need as well.
#  
# features.txt (column lables)
#########################################################

#########################################################
#  FUNCTIONS used by the main function
#########################################################


########################################################
# Function to download and extract the data into the 
# current working directory. Just to make sure anyone
# getting this from git can use it
########################################################
download_data <- function() {
  
  filename <- "project_dataset.zip"
  
  ## Download and unzip the dataset:
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="wininet")
  }  
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
  }
  
  message("Reading data from the internet ....","\r",appendLF=TRUE)
  flush.console()
}


########################################################
# This will read the 2 data sets, clean them up, put the
# subjects and activities in and give the columns names
#
# This does all the cleaning work
########################################################
read_merge_data <- function() {
  
  
  # read the column names
  #column_names <- read_column_names()
  setwd("UCI HAR Dataset")
  
  # Read the train dataset
  train_data <- read.table("train/X_train.txt")
  
  # read the test data
  test_data <- read.table("test/X_test.txt")
  
  # as we have the same columns we can just bind the rows
  full_data <- rbind(train_data,test_data)
  
  # to name the columns, we need to read the file "features.txt"
  # the second column
  features <- read.table("features.txt")[,2]
  
  # and now use this as the column names for the full merged data
  names(full_data) <- features
  
  # and now we need to add the activities
  activ_test <- read.table("test/y_test.txt")
  activ_train <- read.table("train/y_train.txt")
  activ_merged <- rbind(activ_train,activ_test)[,1]
  names(activ_merged) <- c("Activity")
  
  # and add the activity text
  activ_names <- c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
  
  # and now merge the data and names 
  activities <- activ_names[activ_merged]
  
  # and the subjects (we only have numbers)
  subjects_test <- read.table("test/subject_test.txt")
  subjects_train <- read.table("train/subject_train.txt")
  subjects_merged <- rbind(subjects_train,subjects_test)[,1]
  names(subjects_merged) <- c("Subject")
  
  # and now we can add the 2 columns to our full data set
  tidy <- cbind(full_data,subjects_merged,activities)
  
  # rename the columns just to keep it neat
 
  setnames(tidy, c('subjects_merged','activities'), c('Subjects','Activities'))
  
  
  message("Data merged and Activities text added .....","\r",appendLF=TRUE)
  flush.console()
  
  # and return this to be processed further
  return(tidy)
}


#########################################################
# Start of main function .. code will start running here:
#########################################################
run_analysis <- function() {
  
  # make sure we have the data.table loaded as well as dplyr for analysis
  message("Loading some libraries for this project ....","\r",appendLF=TRUE)
  flush.console()
  message("Might see some warning messages while this happens ....only worry if you see errors","\r",appendLF=TRUE)
  flush.console()
  library(data.table)
  library(dplyr)
  
  message("....real work starting here ......","\r",appendLF=TRUE)
  flush.console()
  
  # download the data
  download_data()
  
  # read the 2 data sets and merge into 1 big  dataset
  big_data_set <- read_merge_data()
  #setnames(big_data_set, c('subjects_merged','activities'), c('Subjects','Activities'))
  
  # the brief is to have tidy data ... so we need to clean up the
  # duplicate columns. (for example fBodyAccJerk-bandsEnergy()-1,8  - column 382 and 396 and 410)
  big_clean <- subset(big_data_set, select=which(!duplicated(names(big_data_set))) )
  
  # this is the end of part 1 of the project ... we can write this out to a file to keep
  # columns names have already been tidied up and activities "named" (part 3)
  write.table(big_clean,"combined_data_tidy.txt",row.names = FALSE)
  
  
  # end of part 1 .. and 3
  
  message("End of part 1 and part 3 of this project ....","\r",appendLF=TRUE)
  flush.console()
  
  
  # part 2 of the project...
  
  # extract only mean and standard deviation measurements
  # find the mean and std column names
  matches <- grep("(Activities|Subject|mean|std\\(\\))",names(big_data_set))
  mean_sd_data_set <- big_data_set[,matches] 
  
  # tidy up the names of the columns .. call it "Mean" and not "-mean"
  # and "StdDev" and not "-std" 
  # and remove all "-"   (part 4)
  names(mean_sd_data_set) <- gsub("-mean\\(\\)", "Mean", names(mean_sd_data_set))
  names(mean_sd_data_set) <- gsub("-std\\(\\)", "StdDev", names(mean_sd_data_set))
  names(mean_sd_data_set) <- gsub("-", "", names(mean_sd_data_set))
  
  # write this out to a file for later use (we are tidying data for a reason ???)
  write.table(mean_sd_data_set,"tidymeans.txt",row.names = FALSE)
  
  message("All mean and std columns extracted and column names tidied... end of part 2 and 4","\r",appendLF=TRUE)
  flush.console()
  
  # end of part 2 .. and 4
  
  
  # part 5 is creating a new dataset
  
  # create data set with average for each subject and activity
  
  
  # group the data as per the instructions
  tidy_data <- group_by(mean_sd_data_set,Subjects,Activities)
  
 
  # calculate the means over the grouped data
  tidy_means <- summarize_all(tidy_data,funs(mean))
  
  # and write this out to anohter file
  write.table(tidy_means,"tidy_means_and_std.txt",row.names = FALSE)

  message("All done ....","\r",appendLF=TRUE)
  flush.console()
  
  message("Please check the output files for the following  :","\r",appendLF=TRUE)
  flush.console()
  
  message("   File = combined_data_tidy.txt for the combined tidy data set","\r",appendLF=TRUE)
  flush.console()
  
  message("   File = tidymeans.txt for the means and std deviationcolumns only  tidy data set","\r",appendLF=TRUE)
  flush.console()
  
  message("   File = tidy_means_and_.txt for the means and std deviation  data set (part 5)","\r",appendLF=TRUE)
  flush.console()
  

}
