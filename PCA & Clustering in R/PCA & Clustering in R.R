library(ggplot2)
library(ggpubr)
library(dplyr)
library(psych)

#Load the Data from active directory
data = read_sas('D://School//Business Analytics - Dr. C//BAN 5753//Module 4 - PCA//Exercise 4//enrollment_data.sas7bdat')
#write.csv(data, 'D://School//Business Analytics - Dr. C//BAN 5753//Module 4 - PCA//cars.csv', row.names=T)
#Print the top 5 rows
head(data, 5)
#Print all the variable names in the data 
names(data)
#Remove null values from data
data = na.omit(data)
#Compute the frequency
bar_data = data %>%
  group_by(Target_Enroll) %>%
  summarise(counts = n())

#Print a bar chart to understand the distribution of the Target
ggplot(bar_data, aes(x = Target_Enroll, y = counts)) +
  geom_bar(fill = "0073C2FF", stat = "identity") + 
  geom_text(aes(label = counts), vjust = -.3)

#Compute percentage for pie chart
pie_data = bar_data %>%
  arrange(desc(Target_Enroll)) %>%
  mutate(prop = round(counts*100/sum(counts), 1),
         lab.ypos = cumsum(prop) - .5*prop)

#Print a pie chart to understand the distribution of the Target

pie <- pie_data + coord_polar("y", start=0)

ggplot(pie_data, aes(x = "", y = prop)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  coord_polar("y", start = 0) +
  geom_text(aes(y = lab.ypos, label = prop), color = "white") +
  scale_fill_manual(values = "0073C2FF") +
  theme_void()

# Logistic Regression
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

#Create model
logimod1 = glm(Target_Enroll ~.,family =binomial(link='logit'), data=model_data)

#Print output of model
summary(logimod1)

target_v = c(model_data$Target_Enroll)
glm.probs = predict(logimod1,type="response")
pred_target = ifelse(glm.probs>=.5,1,0)
model_data_class = cbind(target_v,pred_target)
class_tbl = xtabs(~target_v + pred_target, data=model_data_class)
class_pct = class_tbl/length(target_v)

print(class_tbl)
print(class_pct)

classification_rate = (class_pct[1,1]+class_pct[2,2])*100
print(classification_rate)

#Perform PCA with all the numeric variables (including binary, ordinal)
#Select numeric fields
str(model_data)
data_pca = subset(model_data, select = -c(CONTACT_CODE1, Contact_Date, Contact_Month, Contact_Year, ETHNICITY, TERRITORY, Instate, Target_Enroll))#including binary & ordinal
data_pca = na.omit(data_pca) # Remove nulls

#Run PCA Model - Scree Plots
pcamodel_reduc = princomp(data_pca,cor=TRUE, covmat=NULL, scores=TRUE)

screeplot(pcamodel_reduc, type="lines")
screeplot(pcamodel_reduc, type="bar")

