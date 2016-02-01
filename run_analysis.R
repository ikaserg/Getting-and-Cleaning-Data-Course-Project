#fpath <- 'D:\\Learning\\R\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset'
x_test_file = 'x_test.txt'
y_test_file = 'y_test.txt'
x_train_file = 'x_train.txt'

# Load Test dataset
y_test <- read.table(file.path(fpath, 'test', y_test_file))
X_test <- read.table(file.path(fpath, 'test', x_test_file))
# merge labels and data 
X_test$Label_ind <- y_test$V1
l_test_ind <- ncol(X_test)
#write.table(X_test[c(1:30),], file=file.path(fpath, 'test', 'm_test.txt'))

# Load Train dataset
y_train <- read.table(file.path(fpath, 'train', y_train_file))
X_train <- read.table(file.path(fpath, 'train', x_train_file))
# merge labels and data
X_train$Label_ind <- y_train$V1
#write.table(X_train[c(1:30),], file=file.path(fpath, 'train', 'm_train.txt'))

# merge test and train datasets
X_merge <- rbind(X_train, X_test)

#load list of features
flst <- read.table(file.path(fpath, 'features.txt'))

#select mean() and std() features
tiny_ft <- ft[grep("-std\\(\\)|-mean\\(\\)", ft$V2),]
X_merge <- X_merge[,c(l_test_ind, tiny_ft$V1)]

# step 3, set descriptive activity names to name the activities in the data set
# read activity labels
al <- read.table(file.path(fpath, 'activity_labels.txt'))
colnames(al) <- c('Ind', 'Label')
X_merge <- merge(al, X_merge, by.x='Ind', by.y = 'Label_ind')
#delete label index column
X_merge$Ind <- NULL 

# step 4 set  descriptive variable names as labels
colnames(X_merge)<-c("Label", as.character(gsub("\\(\\)", "", tiny_ft$V2)))
write.table(X_merge, file=file.path(fpath, 'tidy.txt'), row.names = FALSE)

# step 5 
# read subjects for train data set
subj_train <- read.table(file.path(fpath, 'train','subject_train.txt'))

# read subjects for test data set
subj_test <- read.table(file.path(fpath, 'test','subject_test.txt'))

#merge subjects id
subj <- rbind(subj_train, subj_test)

X_ag <- aggregate(X_merge[,-1], list(c(as.character(X_merge$Label)), c(subj$V1)), FUN = "mean")
colnames(X_ag)[c(1,2)] <- c('Activity', 'Subject')
write.table(X_ag, file=file.path(fpath, 'tidy_agr.txt'), row.names = FALSE)

