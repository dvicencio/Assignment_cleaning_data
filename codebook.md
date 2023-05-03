# Code book for UCI HAR assigmnment calculations
## Source of data
The source data are from the Human Activity Recognition Using Smartphones Data Set. 
A full description is available at the site where the data was obtained:
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


# Scrip information
File with R code "run_analysis.R" performs the following steps (in accordance assigned task of course work):   
1. Read the test and train files and merge their subject or identification number
2. Merge the activity codes
3. Retrieves the values requires such as mean and standard deviation; first 6 columns according to info from dataset
4. Merges both test and train datasets into a unique dataframe
5. Groups datasets by subject and activity and summarizes values by their average measures
