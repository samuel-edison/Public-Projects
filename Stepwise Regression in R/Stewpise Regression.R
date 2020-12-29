#install.packages("psych")
#install.packages("dplyr")
#install.packages("car")
#install.packages("mgcv")
#install.packages("tidyverse")
#install.packages("broom")
#install.packages("MASS")
#install.packages("ISLR")
#install.packages("caret")
#install.packages("olsrr")

require(haven)
require(dplyr)
require(car)
require(mgcv)
require(tidyverse)
require(broom)
require(MASS)
require(olsrr)
require(PerformanceAnalytics)
require(ppcor)
require(ISLR)
require(modelr)
require(caret)

#Load the Data from active directory
data = read_sas('D://School//Business Analytics - Dr. C//BAN 5753//Module 3 - MR Assumptions & Influentials//Exercise 3//bfp.sas7bdat')

#Check the dimensions of the data
#dim(data) 

#Print the top 5 rows
data
head(data, 5)

#Print all the variable names in the data 
names(data)

#Review basic summary statistics for variable: Rate
summary(data$rate)

#Histogram plot for Rate
h = hist(data$rate,
         main="Histogram Plot for Rate",
         xlab="Rate",
         ylab="Rate Frequency",
         xlim=c(0,10),
         col="darkmagenta",
         freq=TRUE
         )
text(h$mids,h$counts,labels=h$counts, adj=c(0.5, -0.5))

#Print output from running a stepwise regression with Rate as dependent variable 
#Reliab2 & Warrant2 as independent variables 
#Use p-value selection with 0.05 for both entry and removal

model_data = subset(data, select = c(rate, reliab2, time2, av_br2, av_spec2, price2, credit2, return2, warrant2))
linear_model = lm(rate~ ., data = model_data)
stepwise_model = ols_step_both_p(linear_model, penter =.05, prem=.05, details=TRUE)

