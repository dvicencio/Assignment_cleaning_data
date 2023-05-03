library(dplyr)
library(tidyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "myfile.zip"


download.file(url, destfile)

unzip(destfile, exdir = tempdir)

# Test sets

   test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "ID", sep = "\t")

   test_set <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = "Values", sep = "\t") %>% mutate(Values = gsub("^\\s+", "", Values))
   
   featuresx <- read.table("UCI HAR Dataset/features.txt", header = FALSE, col.names = "Feat", sep = "\t") %>% mutate(Feat = gsub("^\\s+", "", Feat))
   
   test_activity <-  read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "Activity", sep = "\t")
   
  test <- cbind(test_sub, test_activity, test_set)

  separated <- test %>% separate(Values, into = as.vector(featuresx$Feat), sep = "\\s+")
  
  test_selected <- separated %>% select(ID, Activity, `1 tBodyAcc-mean()-X`, `2 tBodyAcc-mean()-Y`, `3 tBodyAcc-mean()-Z`, `4 tBodyAcc-std()-X`, `5 tBodyAcc-std()-Y`, `6 tBodyAcc-std()-Z`)
  
rm(test_sub, test_set, featuresx, test_activity, test, separated)
  
# Training sets
  
  
  train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "ID", sep = "\t")
  
  train_set <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = "Values", sep = "\t") %>% mutate(Values = gsub("^\\s+", "", Values))
  
  featuresy <- read.table("UCI HAR Dataset/features.txt", header = FALSE, col.names = "Feat", sep = "\t") %>% mutate(Feat = gsub("^\\s+", "", Feat))
  
  train_activity <-  read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "Activity", sep = "\t")
  
  train <- cbind(train_sub, train_activity, train_set)
  
  separated <- train %>% separate(Values, into = as.vector(featuresy$Feat), sep = "\\s+")
  
  train_selected <- separated %>% select(ID, Activity, `1 tBodyAcc-mean()-X`, `2 tBodyAcc-mean()-Y`, `3 tBodyAcc-mean()-Z`, `4 tBodyAcc-std()-X`, `5 tBodyAcc-std()-Y`, `6 tBodyAcc-std()-Z`)
  
  rm(train_sub, train_set, featuresy, train_activity, train, separated)
  
  merged <- rbind(train_selected, test_selected)
  
  merged$Activity <- as.factor(merged$Activity)
  
  merged$ID <- sort(merged$ID, decreasing = F) 
  
  merged <- merged %>% mutate(Activity = case_when(Activity == 1 ~ "Walking",
                                        
                                                  Activity == 2 ~ "Walking Upstairs",
                                                  
                                                  Activity == 3 ~ "Walking Downstairs",
                                                  
                                                  Activity == 4 ~  "Sitting",
                                                  
                                                  Activity == 5 ~  "Standing",
                                                  
                                                  Activity == 6 ~ "Laying"
                                                  ))
  
  merged[3:8] <- sapply(merged[3:8], as.numeric)
  
  # avgs <- merged %>% rowwise() %>% transmute(ID = ID,
  #                                             Activity = Activity,
  #                                            avg_mean = mean(c(`1 tBodyAcc-mean()-X`, `2 tBodyAcc-mean()-Y`, `3 tBodyAcc-mean()-Z`)),
  #                                              avg_std = mean(c(`4 tBodyAcc-std()-X`, `5 tBodyAcc-std()-Y`, `6 tBodyAcc-std()-Z`)))
  # 
  # 
  # by_group <- group_by(avgs, ID, Activity)
  
  by_group <- group_by(merged, ID, Activity)
  
  group_avgs <- summarise(by_group,
                          avg_mean = round(mean(c(`1 tBodyAcc-mean()-X`, `2 tBodyAcc-mean()-Y`, `3 tBodyAcc-mean()-Z`),  na.rm = TRUE), 4),
                          avg_std = round(mean(c(`4 tBodyAcc-std()-X`, `5 tBodyAcc-std()-Y`, `6 tBodyAcc-std()-Z`),  na.rm = TRUE), 4)
                       ) 
  
  # group_avgs <- summarise(by_group,
  #                         avg_mean = round(mean(`avg_mean`), 4),
  #                         avg_std = round(mean(`avg_std`), 4)
  # ) 
  