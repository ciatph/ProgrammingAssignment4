# ProgrammingAssignment4

### Module 3: Getting and Cleaning Data, Week No. 4
Project demo for Coursera JHU Data Science's sub-setting a clean data set from a collection of data sets.


## Usage
1. Install the R `dataMaid` package if it is not yet installed. This will be used for generating the codebook at the end of the script.
2. Set RStudio's working directory to "./ProgrammingAssignment4"
3. Extract the original [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) into the "./ProgrammingAssignment4/data/"
4. In the command line, type: `source("run_analysis.R")`
5. Wait for the extracted tidy data and R code book for the dataset to be generated (new_data.csv).

## Files
1. ### run_analysis.R
	R script for merging, extracting from, cleaning and processing the original dataset

2. ### codebook_.Rmd
	Contains a dynamic, R-generated extracted features descriptions and information

3. ### codebook.md (extra)
	Contains a static hard-coded codebook with other textual descriptions and information

3. ### new_data.csv
	The new course tidy clean dataset extracted and processed from the original in CSV format

4. ### new_data.txt
	The new course tidy clean dataset extracted and processed from the original in TXT file format

4. ### /data
	Should contain the "UCI HAR Dataset" directory, from the original course test data set. Link [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).


## Notes
Please view _codebook.md_ for more information about the generated data and other relevant dataset information.