# Load libraries
library(haven)
library(dplyr)
library(My.stepwise)
library(rpart)
library(e1071)
library(randomForest)
library(caret)
library(gbm)

#change working directory to where the file is stored
setwd("D:/School/Business Analytics - Dr. C/Ban 5753/Module 6 - SVM & Gradient Boosting/Exercise 6")

#Read the sas file
df = read_sas('enrollment_data.sas7bdat')
#remove attributes not usable for analysis
df = subset(df, select=-c(ID,IRSCHOOL,LEVEL_YEAR))

#run statistics on the data
names(df)
dim(df)
str(df)
summary(df)
sum(is.na(df))

#convert categorical data into factors
df$CONTACT_CODE1 <- factor(df$CONTACT_CODE1)
df$Contact_Date <- factor(df$Contact_Date)
df$Contact_Month <- factor(df$Contact_Month)
df$Contact_Year <- factor(df$Contact_Year)
df$Target_Enroll <- factor(df$Target_Enroll)
df$ETHNICITY <- factor(df$ETHNICITY)
df$Instate <- factor(df$Instate)
df$sex <- factor(df$sex)
df$TERRITORY <- factor(df$TERRITORY)

#retrieve numeric data columns names with NA values
numeric.columns = df[,sapply(df,is.numeric)]
list_na <- colnames(numeric.columns)[ apply(numeric.columns, 2, anyNA)]
list_na

#Find the average missing for all numerical variables with missing values
average_missing = apply(df[,colnames(df) %in% list_na],2,mean,na.rm=TRUE)
print(average_missing)

#Create flag for records with missing values
df_imp <- df %>%
  mutate(replace_mean_avg_income = ifelse(is.na(avg_income),
                                          average_missing[1],avg_income),
         replace_mean_distance = ifelse(is.na(distance),
                                        average_missing[2], distance),
         replace_mean_satscore = ifelse(is.na(satscore),
                                        average_missing[3], satscore),
         replace_mean_telecq = ifelse(is.na(telecq),
                                      average_missing[4],telecq),
         flag_null_avg_income = factor(ifelse(is.na(avg_income), 1, 0)),
         flag_null_distance = factor(ifelse(is.na(distance),1,0)),
         flag_null_satscore = factor(ifelse(is.na(satscore),1,0)),
         flag_null_telecq = factor(ifelse(is.na(telecq),1,0)))
df_imp = subset(df_imp,select = -c(avg_income, distance, satscore, telecq))

#Confirm changes after imputation
list_na_confirm = colnames(df_imp)[apply(df_imp, 2, anyNA)]
print(list_na_confirm)
#remove NA's from any categorical variables remaining
df_imp = na.omit(df_imp)
#convert binary variables to numeric
df_imp$CAMPUS_VISIT = as.numeric(df_imp$CAMPUS_VISIT)
df_imp$hscrat = as.numeric(df_imp$hscrat)
df_imp$init_span = as.numeric(df_imp$init_span)
df_imp$int1rat = as.numeric(df_imp$int1rat)
df_imp$int2rat = as.numeric(df_imp$int2rat)
df_imp$interest = as.numeric(df_imp$interest)
df_imp$mailq = as.numeric(df_imp$mailq)
df_imp$premiere = as.numeric(df_imp$premiere)
df_imp$REFERRAL_CNTCTS = as.numeric(df_imp$REFERRAL_CNTCTS)
df_imp$SELF_INIT_CNTCTS = as.numeric(df_imp$SELF_INIT_CNTCTS)
df_imp$sex = as.numeric(df_imp$sex)
df_imp$SOLICITED_CNTCTS = as.numeric(df_imp$SOLICITED_CNTCTS)
df_imp$TOTAL_CONTACTS = as.numeric(df_imp$TOTAL_CONTACTS)
df_imp$TRAVEL_INIT_CNTCTS = as.numeric(df_imp$TRAVEL_INIT_CNTCTS)
df_imp$Target_Enroll = as.numeric(df_imp$Target_Enroll)
df_imp$Target_Enroll[df_imp$Target_Enroll == 2] <- 0


#Partition the code in to a 70/30 training and validation split
set.seed(12345)
trainIndex <- createDataPartition(df_imp$Target_Enroll, p = .7,
                                  list = FALSE,
                                  times = 1)
Train <- df_imp[ trainIndex,]
Valid <- df_imp[-trainIndex,]

#Model Question 1: Logistic Regression Stepwise
#variable selection using stepwise

variable_list = c("CAMPUS_VISIT","CONTACT_CODE1", "Contact_Date", "Contact_Month","Contact_Year","ETHNICITY", "hscrat","init_span","Instate","int1rat","int2rat","interest","mailq",
                  "premiere","REFERRAL_CNTCTS","SELF_INIT_CNTCTS","sex","SOLICITED_CNTCTS","TERRITORY", "TOTAL_CONTACTS", "TRAVEL_INIT_CNTCTS","replace_mean_avg_income","replace_mean_distance","replace_mean_satscore",
                  "replace_mean_telecq","flag_null_avg_income","flag_null_distance","flag_null_satscore","flag_null_telecq")
Logistic_model_variable_selection = My.stepwise.glm(Y = "Target_Enroll", variable.list = variable_list, 
                                                    in.variable = "NULL", data = Train, sle = .05, sls = .05, myfamily = binomial(link='logit'))

#Build Classification matrix function
Logistic_accuracy_rate = function(model, data) {
  target = c(data$Target_Enroll)
  glm.probs = predict(model,newdata = data, type="response")
  pred_target = ifelse(glm.probs>=.5, 1, 0)
  df_class = cbind(target, pred_target)
  class_tbl = xtabs(~target + pred_target, data=df_class)
  class_pct = class_tbl/length(target)
  classification_rate = (class_pct[1,1]+class_pct[2,2])*100
  print(classification_rate)
}

#Perform a Logistic Regression Model on Target Enrolls using variables from Stepwise Selection
Logistic_Model1 = glm(Target_Enroll ~ SELF_INIT_CNTCTS+hscrat+ETHNICITY+replace_mean_telecq+flag_null_distance+interest+init_span+replace_mean_satscore+Instate+CAMPUS_VISIT+premiere+REFERRAL_CNTCTS+replace_mean_avg_income,
                      family = binomial(link='logit'), data=Train)

#Print Training accuracy score
Logistic_accuracy_rate(Logistic_Model1, Train)
#Print Validation accuracy score
Logistic_accuracy_rate(Logistic_Model1, Valid)


#Function to return accuracy rate for Decision Tree
decision_accuracy_rate = function(model, data){
  target = c(data$Target_Enroll)
  glm.probs = predict(model,data, type="class")
  pred_target = glm.probs
  df_class = cbind(target, pred_target)
  class_tbl = xtabs(~target + pred_target, data=df_class)
  class_pct = class_tbl/length(target)
  classification_rate = (class_pct[1,1]+class_pct[2,2])*100
  print(classification_rate)
}

#Decision Tree Model Build on Training Data
Decision_Tree_model = rpart(Target_Enroll ~ .,
                            data = Train,
                            method = 'class',
                            parms = list(split = "information"))

#Function to return Training and Validation accuracy scores
decision_accuracy_rate(Decision_Tree_model, Train)
decision_accuracy_rate(Decision_Tree_model, Valid)

#Plot the tree
plot(Decision_Tree_model,
     uniform=TRUE,
     main="Classification for Target_Enroll")
text(Decision_Tree_model,
     use.n = TRUE,
     all=TRUE,
     cex=.8)

#SVM Model
#Create a new function to return the accuracy of the data
svm_accuracy_rate = function(model, data) {
  target = c(data$Target_Enroll)
  x = subset(data, select=-c(Target_Enroll))
  glm.probs = predict(model,x)
  pred_target = glm.probs
  df_class = cbind(target, pred_target)
  class_tbl = xtabs(~target + pred_target, data=df_class)
  class_pct = class_tbl/length(target)
  classification_rate = (class_pct[1,1]+class_pct[2,2])*100
  print(classification_rate)
}


#Create training and validation table splits using stepwise selection variables
svm_train = subset(Train, select = c(Target_Enroll,
                                     SELF_INIT_CNTCTS,
                                     hscrat,
                                     ETHNICITY,
                                     replace_mean_telecq,
                                     flag_null_distance,
                                     interest,
                                     init_span,
                                     replace_mean_satscore,
                                     Instate,
                                     CAMPUS_VISIT,
                                     premiere,
                                     REFERRAL_CNTCTS,
                                     replace_mean_avg_income))
svm_valid = subset(Valid, select = c(Target_Enroll,
                                     SELF_INIT_CNTCTS,
                                     hscrat,
                                     ETHNICITY,
                                     replace_mean_telecq,
                                     flag_null_distance,
                                     interest,
                                     init_span,
                                     replace_mean_satscore,
                                     Instate,
                                     CAMPUS_VISIT,
                                     premiere,
                                     REFERRAL_CNTCTS,
                                     replace_mean_avg_income))

svm_train$Target_Enroll = as.factor(svm_train$Target_Enroll)
svm_valid$Target_Enroll = as.factor(svm_valid$Target_Enroll)

#Create SVM Model 1 using Linear Kernel
svm_model1 = svm(Target_Enroll ~ . ,
                 data=svm_train,
                 kernel="linear")
print(svm_model1)
summary(svm_model1)
svm_accuracy_rate(svm_model1, svm_train)
svm_accuracy_rate(svm_model1, svm_valid)

#SVM Model 2 using Polynomial Kernel
svm_model2 = svm(Target_Enroll ~ . ,
                 data=svm_train,
                 kernel="polynomial")
print(svm_model2)
summary(svm_model2)
svm_accuracy_rate(svm_model2, svm_train)
svm_accuracy_rate(svm_model2, svm_valid)

#SVM Model 3 using radial basis kernel
svm_model3 = svm(Target_Enroll ~ . ,
                 data=svm_train,
                 kernel="radial")
print(svm_model3)
summary(svm_model3)
svm_accuracy_rate(svm_model3, svm_train)
svm_accuracy_rate(svm_model3, svm_valid)

#SVM Model 4 using sigmoid basis kernel
svm_model4 = svm(Target_Enroll ~ . ,
                 data=svm_train,
                 kernel="sigmoid")
print(svm_model4)
summary(svm_model4)
svm_accuracy_rate(svm_model4, svm_train)
svm_accuracy_rate(svm_model4, svm_valid)

#Model 5 Random Forest
#remove variable with too many levels causing issue
Train_rf = subset(Train, select=-c(CONTACT_CODE1))
Valid_rf = subset(Valid, select=-c(CONTACT_CODE1))
Train_rf$Target_Enroll = as.factor(Train_rf$Target_Enroll)
Valid_rf$Target_Enroll = as.factor(Valid_rf$Target_Enroll)
rf <- randomForest(
  Target_Enroll ~ .,
  data=Train_rf
)
print(rf)

prediction = predict(rf, Valid_rf)
confusionMatrix(prediction, Valid_rf$Target_Enroll)


#Model 6 Gradient Boosting
#define the control
Train$Target_Enroll = as.factor(Train$Target_Enroll)
Valid$Target_Enroll = as.factor(Valid$Target_Enroll)

trControl = trainControl(method="cv",
                         number = 10,
                         search = "grid")
set.seed(12345)
#Run Gradient Boosting model
Gradient_Boosting_model = train(Target_Enroll ~ . ,
                                data = Train,
                                method = "gbm",
                                metric="Accuracy",
                                trControl = trControl)
print(Gradient_Boosting_model)
prediction = predict(Gradient_Boosting_model, Valid)
confusionMatrix(prediction, Valid$Target_Enroll)


