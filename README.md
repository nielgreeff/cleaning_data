# cleaning_data
This repository is for the Getting and Cleaning Data project for week 4 of the Coursera course with the same name.

The data is here : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The idea is to 

1. Combine data from a training and test sets - Data must be tidy
2. Clean up the data by extracting only columns containg mean and standard deviation
3. Put descriptive names on the activities (only numbers used in the data set)
4. Add desciptive names on columns
5. Create an independant tidy data set with average of each activity and each subject.

## Data Description
Original data contains 2 sets of data; Training and Test.
Each has and X dataset of measurements taken by mobile phone GPS during 6 different activities, by 30 subjects


## New Data Sets
### big_clean 
is a dataset combining test and training and adding the activities (names - not numbers) and dupclicate columns removed. (for example fBodyAccJerk-bandsEnergy()-1,8  - column 382 and 396 and 410)
### mean_sd_data_set 
is a dataset containing just those columns with "mean" and "std" and more readable column names
### tidy_means 
is a dataset with the mean values per Subject per activity


## Code Explanation
The code assumes that the git repository will be used to download the code.
The data it big and is downloaded by the code. Function download_data() is used for this. Data will be put into the current working directory 
and unzipped. It will land in a directory called "UCI HAR Dataset"

The first step is to combine training data and test data (raw)
We read the features (column names) and add as column names to the combined dataset

Next we read the activities and combine them into 1 big data set again (same order as we did with the raw data)
We also read the text explanation of hte activities.

Last, we read the subjects numbers from train and test (again same order)

All of hte above done in a function called read_merge_data()

We then make sure or combined column names (for subjects and activities) are clear and then remove duplicate columns, to leave us with a tidy set
combining test and training

Next we take out all the columns  that contain "mean" or "std" names, and get a subset of data from those columns.
We then tidy up the names of columns a bit ... 

We also write a new dataset "mean_sd_data_set" to a file

Lastly we group the data by subjects and activities

and calculate the mean (average) over the data and store in in a variable "tidy_means"
and write this out to a file as well

Please note that most systems are Windows, so this will download the code asif this platform is Windows.
If you're using Linux / Mac OS , please change the line downloading the data (line 56) to
  download.file(fileURL, filename, method="curl") 



