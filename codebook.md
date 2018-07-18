## CodeBook for the extracted tidy data set

## Data Source
The dataset used for this project represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

Experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, a 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the _training_ data and 30% the _test_ data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

The original dataset was from the Coursera's **Getting and Cleaning Data Course Project** source: [Human Activity Recognition Using Smartphones](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The filtered dataset for the course project is in this [link](https://github.com/ciatph/ProgrammingAssignment4/new_data.csv).


## Feature Selection

Data in the new tidy data set are as specified from the course project:

1. Innertial data merged with the training and test data sets, which are then merged into (1) master data set, and then,
2. Extracted with only columns that are _means_ and _standard deviations_ for each measurement
3. Appended with descriptive activity names.
4. Appended with appropriate column headers (labels)

The new tidy data set now contains the average of only the features that are _means_ "means()" and _standard deviations_ "std()", sub-setted from the original features list, grouped for each user's activities.

Please refer to the original dataset's README for the original data set for the complete list and descriptions of features. 

### All variables that are "means()"

- activity\_id\_mean
- subject\_id\_mean
- activity\_label\_mean
- tBodyAcc-mean()-X
- tBodyAcc-mean()-Y
- tBodyAcc-mean()-Z
- tGravityAcc-mean()-X
- tGravityAcc-mean()-Y
- tGravityAcc-mean()-Z
- tBodyAccJerk-mean()-X
- tBodyAccJerk-mean()-Y
- tBodyAccJerk-mean()-Z
- tBodyGyro-mean()-X
- tBodyGyro-mean()-Y
- tBodyGyro-mean()-Z
- tBodyGyroJerk-mean()-X
- tBodyGyroJerk-mean()-Y
- tBodyGyroJerk-mean()-Z
- tBodyAccMag-mean()
- tGravityAccMag-mean()
- tBodyAccJerkMag-mean()
- tBodyGyroMag-mean()
- tBodyGyroJerkMag-mean()
- fBodyAcc-mean()-X
- fBodyAcc-mean()-Y
- fBodyAcc-mean()-Z
- fBodyAccJerk-mean()-X
- fBodyAccJerk-mean()-Y
- fBodyAccJerk-mean()-Z
- fBodyGyro-mean()-X
- fBodyGyro-mean()-Y
- fBodyGyro-mean()-Z
- fBodyAccMag-mean()
- fBodyBodyAccJerkMag-mean()
- fBodyBodyGyroMag-mean()
- fBodyBodyGyroJerkMag-mean()


### All variables that are standard deviations "std()"

- activity\_id\_std
- subject\_id\_std
- activity\_label\_std
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tGravityAcc-std()-X
- tGravityAcc-std()-Y
- tGravityAcc-std()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyGyroJerk-std()-X
- tBodyGyroJerk-std()-Y
- tBodyGyroJerk-std()-Z
- tBodyAccMag-std()
- tGravityAccMag-std()
- tBodyAccJerkMag-std()
- tBodyGyroMag-std()
- tBodyGyroJerkMag-std()
- tBodyAcc-std()-X
- tBodyAcc-std()-Y
- tBodyAcc-std()-Z
- tBodyAccJerk-std()-X
- tBodyAccJerk-std()-Y
- tBodyAccJerk-std()-Z
- tBodyGyro-std()-X
- tBodyGyro-std()-Y
- tBodyGyro-std()-Z
- tBodyAccMag-std()
- tBodyBodyAccJerkMag-std()
- tBodyBodyGyroMag-std()
- tBodyBodyGyroJerkMag-std()

## Running the script
1. Set RStudio's working directory to "./ProgrammingAssignment4"
2. Extract the original [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into the "./ProgrammingAssignment4/data/"
2. In the command line, type: `source("run_analysis.R")`
3. Wait for the extracted tidy data to be generated (new_data.csv).
