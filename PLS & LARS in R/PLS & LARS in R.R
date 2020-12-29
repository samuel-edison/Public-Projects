#install.packages('plsdepot')
#install.packages("pls")
#install.packages("lars")
#install.packages("glmnet")

library(haven)
library(ggplot2)
library(ggpubr)
library(dplyr)
library(psych)
library(plsdepot)
library(caret)
library(pls)
library(lars)
library(glmnet)

#Load the Data from active directory
data = read_sas('D://School//Business Analytics - Dr. C//BAN 5753//Module 5 - PLS & LARS//Exercise 5//enrollment_data.sas7bdat')
data
#remove NAs
data = na.omit(data)

#Drop variables not needed or causing error
model_data = subset(data, select=-c(ID,IRSCHOOL,LEVEL_YEAR))
#Convert Character classes to factors
model_data$CONTACT_CODE1 = as.factor(model_data$CONTACT_CODE1)
model_data$Contact_Date = as.factor(model_data$Contact_Date)
model_data$Contact_Month = as.factor(model_data$Contact_Month)
model_data$Contact_Year = as.factor(model_data$Contact_Year)
model_data$Target_Enroll = as.factor(model_data$Target_Enroll)
model_data$ETHNICITY = as.factor(model_data$ETHNICITY)
model_data$Instate = as.factor(model_data$Instate)
model_data$TERRITORY = as.factor(model_data$TERRITORY)
head(model_data, 5)
#remove non-numeric data
num_model_data = subset(model_data, select=-c(CONTACT_CODE1, Contact_Date, Contact_Month, Contact_Year, ETHNICITY, TERRITORY, Instate))
#convert binary to numeric
names(num_model_data)
head(num_model_data, 5)
num_model_data$avg_income = as.numeric(num_model_data$avg_income)
num_model_data$CAMPUS_VISIT = as.numeric(num_model_data$CAMPUS_VISIT)
num_model_data$distance = as.numeric(num_model_data$distance)
num_model_data$hscrat = as.numeric(num_model_data$hscrat)
num_model_data$init_span = as.numeric(num_model_data$init_span)
num_model_data$int1rat = as.numeric(num_model_data$int1rat)
num_model_data$int2rat = as.numeric(num_model_data$int2rat)
num_model_data$interest = as.numeric(num_model_data$interest)
num_model_data$mailq = as.numeric(num_model_data$mailq)
num_model_data$premiere = as.numeric(num_model_data$premiere)
num_model_data$REFERRAL_CNTCTS = as.numeric(num_model_data$REFERRAL_CNTCTS)
num_model_data$satscore = as.numeric(num_model_data$satscore)
num_model_data$SELF_INIT_CNTCTS = as.numeric(num_model_data$SELF_INIT_CNTCTS)
num_model_data$sex = as.numeric(num_model_data$sex)
num_model_data$SOLICITED_CNTCTS = as.numeric(num_model_data$SOLICITED_CNTCTS)
num_model_data$telecq = as.numeric(num_model_data$telecq)
num_model_data$TOTAL_CONTACTS = as.numeric(num_model_data$TOTAL_CONTACTS)
num_model_data$TRAVEL_INIT_CNTCTS = as.numeric(num_model_data$TRAVEL_INIT_CNTCTS)
num_model_data$Target_Enroll = as.numeric(num_model_data$Target_Enroll)
num_model_data$Target_Enroll[num_model_data$Target_Enroll == 2] <- 0
#PLS Model
pls.model = plsr(Target_Enroll ~ ., data = num_model_data)
plot(pls.model)
#Plot all coefficient of the variable
coefficients = coef(pls.model)
sum.coef = sum(sapply(coefficients, abs))
coefficients = coefficients * 100 / sum.coef
coefficients = sort(coefficients[, 1 , 1])
barplot(sort(abs(coefficients)))
print(sort(abs(coefficients)))
#run a LR model for PLS
model2 = glm(Target_Enroll ~ avg_income+init_span+interest+telecq+hscrat+CONTACT_CODE1+Contact_Date+Contact_Month+Contact_Year+ETHNICITY+TERRITORY+Instate, family = binomial(link='logit'), data=model_data)
target_v2 = c(model_data$Target_Enroll)
glm.probs2 = predict(model2, type = "response")
pred_target2 = ifelse(glm.probs2>=.5, 1, 0)
df_class2 = cbind(target_v2, pred_target2)
class_tbl2 = xtabs(~target_v2 + pred_target2, data=df_class2)
class_pct2 = class_tbl2/length(target_v2)
classification_rate2 = (class_pct2[1,1]+class_pct2[2,2])*100
print(classification_rate2)

#LARS
x = model.matrix(Target_Enroll ~.,data=num_model_data)[,-1]
y = num_model_data$Target_Enroll
model_lars = lars(x,y, type = "lar")
summary(model_lars)
names(model_lars)
print(model_lars$actions)

#LR model for LARS
model3 = glm(Target_Enroll ~ SELF_INIT_CNTCTS+telecq+hscrat+CAMPUS_VISIT+TOTAL_CONTACTS+CONTACT_CODE1+Contact_Date+Contact_Month+Contact_Year+ETHNICITY+TERRITORY+Instate, family = binomial(link='logit'), data=model_data)
target_v3 = c(model_data$Target_Enroll)
glm.probs3 = predict(model3, type = "response")
pred_target3 = ifelse(glm.probs3>=.5, 1, 0)
df_class3 = cbind(target_v3, pred_target3)
class_tbl3 = xtabs(~target_v3 + pred_target3, data=df_class3)
class_pct3 = class_tbl3/length(target_v3)
classification_rate3 = (class_pct3[1,1]+class_pct3[2,2])*100
print(classification_rate3)
