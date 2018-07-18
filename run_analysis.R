projDir <- './data/UCI HAR Dataset/'

## Load text file data 
## Return as a data.frame
loadData <- function(filename, path=NULL){
  file_path = projDir
  
  if(!is.null(path))
    file_path = path
  
  read.table(paste0(file_path, filename))
}


## Returns the descriptive activity label given an index
## @param label_list: activity_list.txt data.frame
## @param index: numerical activity index
getActivityLabel <- function(label_list, index){
  return (as.character(label_list[index,][2]$V2))
}


## Returns the descriptive column variable label given an index
## @param variable_list: features.txt data.frame
## @param index: numerical variable name index
getColumnVariable <- function(variable_list, index){
  return (as.character(variable_list$V2[index]))
}


## Replace the column variable names with matching descriptive text
## @param variable_list: features.txt data.frame
## @param namelist: a list of column variable names from a data.frame
replaceColumnNames <- function(variable_list, namelist){
  v <- c();
  j = 1;
  
  for(i in 1:length(namelist)){
    # Check if the string contains a number (as in "V123")
    if(length(grep("[0-9]", namelist[i])) > 0){
      
      # Extract the numerical index of the default variable name
      index <- as.integer(gsub("V", "", namelist[i]))  
      
      # Store the descriptive variable text matched by index
      v[j] <- as.character(variable_list$V2[index])      
    }
    else{
      # Store as "activity name" for the 1st column variable
      v[j] <- "activity_name"
    }
    j = j + 1 
  }
  return (v)
}


## Get the column (x) indices of variables 
## that contains a grep search string 
## @param x: factor list
## @param grepStr: grep search string "mean[()]" or "std[()]"
getColumnIndex <- function(x, grepStr){
  i = 1;
  j = 1;
  list_index <- c();
  for(i in 1:length(x)){
    if(length(grep(grepStr, as.character(x[i])))){
      list_index[j] <- i
      j <- j + 1
    }
  }
  return(list_index)
}


# Get only the column with means() or std(), specified in indices
getColumnData <- function(indices, searchlist, activity_labels, type){
  f <- data.frame();
  
  # Append the activity_id column
  f <- cbind(1, searchlist$activity_id)
  
  # Append the subject_id column
  f <- cbind(f, searchlist$subject_id) 
  
  # remove the initial 1st column
  f <- f[,-1]
  
  # Change headers
  colnames(f) <- c(paste0("activity_id_", type), paste0("subject_id_", type))
  
  # Append associated row data indexed at specified column indices
  for(i in 1:length(indices)){
    f <- cbind(f, searchlist[indices[i]])
  }

  # Append the descriptive column headers per column/variable
  v <- c()
  j = 1
  
  for(i in 1:nrow(f)){
    v[j] = getActivityLabel(activity_labels, f$activity_id[i])
    j = j + 1
  }
  
  f <- cbind(f, v)
  colnames(f)[ncol(f)] <- paste0("activity_label_", type)
  
  return (f)
}


## Creates a new data set from combined training and test datatest
## With average of variables per per subject and activity
createNewDataSet <- function(data, activity_labels){
	# get unique subject id's
	subject_ids <- unique(data$subject_id_mean)

	# get unique activity id's
	activity_ids <- unique(data$activity_id_mean)
	
	# output result set
	f <- data.frame()

	# Init default data
	f <- rbind(0, 1:ncol(data))
	
	# Process row's columns
	cols <- names(data)	
	
	# Append column headers
	colnames(f) <- cols	

	# non-computational unique id's
	ids <- c("activity_id_mean","activity_label_mean","subject_id_mean",
		"activity_id_std","activity_label_std","subject_id_std")
	
	print(paste("subjects: ", length(subject_ids)))
	print(paste("activities: ", length(activity_ids)))
	
	for(i in 1:length(subject_ids)){
		# Get all rows associated with subject_id
		subj_data <- data[data$subject_id_mean == subject_ids[i],]	
		
		print(paste("Processing user:", subject_ids[i], "rows:", nrow(subj_data)))

		for(j in 1:length(activity_ids)){
			# Get all rows associated with activity_ids
			act_data <- subj_data[subj_data$activity_id_mean == activity_ids[j],]
			
			 v <- c()
			 row <- 1

			 # Compute the average of associated rows (subject, activity) for each column 
			 for(k in 1:length(cols)){
				if(!is.element(cols[k], ids)){
					v[row] <- sum(act_data[cols[k]]) / nrow(act_data)					
				}
				else{
					if(length(grep("^(activity_id)", cols[k])) > 0){
						v[row] <- as.numeric(activity_ids[j])
					}
					else if((length(grep("^(subject_id)", cols[k])) > 0)){
						v[row] <- as.numeric(subject_ids[i])
					}
					else if(length(grep("^(activity_label)", cols[k])) > 0){
						v[row] <- getActivityLabel(activity_labels, activity_ids[j])
					}
				}
				row <- row + 1
			 }
			 
			f <- rbind(f, v)
		}
	}
	
	# Remove extra rows
	f <- f[c(-1, -2),]
	f <- as.data.frame(f)
	return (f[order(f$subject_id_mean, f$activity_id_mean),])
}


## Creates an R object for data analysis
## Loads data sets and associated methods
load_analysis <- function(){
	# Check if data directory exists
	if(!dir.exists(projDir)){
		print("Please download and place the 'UCI HAR Dataset' inside './data'")
		return (0)
	}
		
  # Load column variables
  features <- loadData('features.txt')
  activity_labels <- loadData('activity_labels.txt')
  
  # Load data for train
  directory <- paste0(projDir, 'train/')
  train_x <- loadData('X_train.txt', directory)
  train_y <- loadData('Y_train.txt', directory)
  train_subject <- loadData('subject_train.txt', directory)
  
  # Load data for test
  directory <- paste0(projDir, 'test/')
  test_x <- loadData('X_test.txt', directory)
  test_y <- loadData('Y_test.txt', directory)
  test_subject <- loadData('subject_test.txt', directory)
  
  # Replace the default column names with correct variable names
  names(train_x) = as.character(features$V2)
  names(test_x) = as.character(features$V2)
  
  # Append the subject_id column 
  train_x <- cbind(train_x, train_subject)
  test_x <- cbind(test_x, test_subject)
  colnames(train_x)[length(train_x)] <- "subject_id_train"
  colnames(test_x)[length(test_x)] <- "subject_id_train"
  
  # Append the activity_id column at the last
  train_x <- cbind(train_x, train_y)
  test_x <- cbind(test_x, test_y)
  colnames(train_x)[length(train_x)] <- "activity_id_test"
  colnames(test_x)[length(test_x)] <- "activity_id_test"  
  
  ## Set the new training or test data
  ## @param type: "train" or "test" to indicate which internal dataset to modify
  ## @param data: new data.frame
  set <- function(type, data){
    if(type == "train"){
      train_x <<- data
    }
    else if(type == "test"){
      test_x <<- data
    }
  }
  
  ## Gets the specified internal data set
  ## @param type: "train" or "test" to indicate which internal dataset to modify
  get <- function(type){
    if(type == "train")
      return (train_x)
    else if(type == "test")
      return (test_x)
  }
  
  ## Merges similar row-count data.frames to the training or test data sets
  mergedata <- function(type, data){
    if(type == "train"){
      train_x <<- cbind(train_x, data)
    }
    else if(type == "test"){
      test_x <<- cbind(test_x, data)
    }
  }
  
  ## Merge/combine the training and test data sets
  ## Using rbind (appends to rows)
  mergeDataSet <- function(){
    return (rbind(train_x, test_x))
  }

  ## Return all columns whose header variables contains "means()" 
  ## @param dataset: Data set to search for
  ## @param type: unique string identifier for column headers w/ch may have similar value
  ##   from another data set (during merging)
  getAllMeans <- function(dataset, type){
    # Get all columns with "mean()", append descriptive activity text
    getColumnData(getColumnIndex(features$V2, "mean[()]"), dataset, activity_labels, type) 
  } 
  
  ## Return all columns whose header variables contains "std()" 
  ## @param dataset: Data set to search for
  ## @param type: unique string identifier for column headers w/ch may have similar value
  ##   from another data set (during merging)
  getAllStd <- function(dataset, type){
    # Get all columns with "std()", append descriptive activity text
    getColumnData(getColumnIndex(features$V2, "std[()]"), dataset, activity_labels, type)
  }    
  
  ## Return a list of object variables
  return (list(
    features = features,
    activity_labels = activity_labels,
    train_x = train_x,
    train_y = train_y,
    train_subject = train_subject,
    test_x = test_x,
    test_y = test_y,
    test_subject = test_subject,
    mergeDataSet = mergeDataSet,
    getAllMeans = getAllMeans,
    getAllStd = getAllStd,
    mergedata = mergedata,
    set = set,
    get = get
  ))
}


## Appends a string prefix to a target string
appendPrefix <- function(x, prefix){
	return (paste(prefix, x))
}

## Appends all data found in /Innertial Signals into (1) data frame
## @param datasetdir: train|test
getInnertialData <- function(datasetdir){
  directory <- paste0(projDir, datasetdir, "/Inertial Signals/")
  f <- data.frame()
  
  filenames_acc <- c("body_acc_x_*.txt", "body_acc_y_*.txt", "body_acc_z_*.txt",
                     "body_gyro_x_*.txt", "body_gyro_y_*.txt", "body_gyro_z_*.txt",
                     "total_acc_x_*.txt", "total_acc_y_*.txt", "total_acc_z_*.txt")
  
  # Replace filenames with approrpiate name
  for(i in 1:length(filenames_acc)){
    filenames_acc[i] <- gsub("[*]", datasetdir, filenames_acc[i])
    print(filenames_acc[i])
  }
  
  # Load data and append to a master data.frame list
  for(i in 1:length(filenames_acc)){
    temp <- loadData(filenames_acc[i], directory)
	
	# Append descriptive column header/labels for innertial data based on file name
    names(temp) <- sapply(names(temp), appendPrefix, prefix=gsub(paste0(datasetdir, ".txt"), "", filenames_acc[i]))
    
    if(ncol(f) == 0){
      f <- cbind(0, temp)
    }
    else{
      f <- cbind(f, temp)
    }
  }
  
  f <- f[,-1]
  return (f)
}


## Main program proper
run_analysis <- function(){
  # Load data
  # Append descriptive activity labels, numeric activity id and subject id
  d <- load_analysis();
  
  # Check if the Samsung dataset is present before proceeding
  if(class(d) == "list"){
	  
	  #1. Merge data sets
	  #1a. Merge/Append column-wise Innertial Signals data to training and test data sets
	  d$mergedata("train", getInnertialData("train"))
	  d$mergedata("test", getInnertialData("test"))
	  
	  # 1b. Merge the training and test sets to create (1) data set
	  mdata <- d$mergeDataSet();
	  
	  #2. Extract only the measurements on the combined mean and standard deviation for each measurement.
	  means_list <- d$getAllMeans(mdata, "mean");
	  std_list <- d$getAllStd(mdata, "std");
	  
	  names(means_list)
	  names(std_list[1])  
	  
	  # Merge the "means()" and "std()" -only training and test sets to create (1) data set
	  # Bind all means and std data column-wise
	  ms_data <- cbind(means_list, std_list)  
	  
	  #3. Use descriptive activity names to name the activities in the data set:
	  # See getColumnData(): 
	  #   a. Append the training descriptive activity labels per row
	  
	  #4. Appropriately labels the data set with descriptive variable names.
	  # See getCOlumnData() parts:
	  #   a. Append the descriptive column headers per column/variable
	  
	  names(ms_data)

	  #5.From the data set in step 4, creates a second, independent tidy data set 
	  # with the average of each variable for each activity and each subject.
	  return (createNewDataSet(ms_data, d$activity_labels))
  }
}

extracted_data <- run_analysis()

# Write to text file
extracted_data <- extracted_data[,-1]
write.table(extracted_data, file="new_data.txt", row.name=TRUE)

# Extra: write to csv file
write.csv(extracted_data, file="new_data.csv")

# Make an R-generated code book
# Please make sure the "dataMaid" package has been installed
library(dataMaid)
makeCodebook(extracted_data)