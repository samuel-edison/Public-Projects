#Ready library in R
library(survival)
library(ranger)
library(ggplot2)
library(dplyr)
library(haven)
library(ggfortify)
#Set working directory
getwd()
setwd("D://School//Business Analytics - Dr. C//BAN 5753//Module 8 - Survival Modeling II//EXercise 7")
#read sas data
df = read_sas('mortgage.sas7bdat')
#Explore the data
names(df)
head(df,5)
str(df)
sum(is.na(df))
#Data manipulation
df$event = as_factor(df$event)
df$ID = as.factor(df$ID)
df$start_date = as.Date(df$start_date, format="%Y-%m-%d")
df$end_date = as.Date(df$end_date, format="%Y-%m-%d")

#replace end_date missing values with todays date
df$end_date[is.na(df$end_date)] <- "2020-10-10"
df$end_date
#check date variables for missing
sum(is.na(df$start_date))
sum(is.na(df$end_date))

#remove default and prepayment
#df = subset(df,select=-c(default,Prepayment))

#check survival model with intercept
#km = with(df,Surv(start_date, event))
km_fit = survfit(Surv(as.numeric(end_date - start_date),event)~1,data=df)

summary(km_fit)

#plot
autoplot(km_fit)
