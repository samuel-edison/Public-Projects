import pandas as pd
import os
import regex
os.getcwd()
os.chdir(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\regular-expressions-tha-samuel-edison\data')
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
#import csv
hospital_data = pd.read_csv('CaliforniaHospitalData.csv')
hospital_data.columns
#import txt
personnel_data = pd.read_table('CaliforniaHospitalData_Personnel.txt',sep ='\t')
personnel_data.columns
#merge the files together
merged_hospital_data = pd.merge(left=hospital_data, right=personnel_data, how='left',on="HospitalID")
merged_hospital_data
#convert data to string to allow regex functions to be used on the data
merged_hospital_data_string = merged_hospital_data.to_string()
merged_hospital_data_string

#1: Obtain a list of all employees who are regional representatives. Using the title itself.
#this will pull all data for only the Regional Representatives
reg_ptags1 = "(.*?)(Regional Representative.*)"
matches1 = regex.findall(reg_ptags1, merged_hospital_data_string)
matches1

#2: Obtain a list of all employees with first name Emily OR last name starts with an "A" or ends with an "n"
reg_ptags2 = "(.*?)(Emily.*)|(.*?)(\.a.*)|(.*?)(\w*n\b)"
matches2 = regex.findall(reg_ptags2, merged_hospital_data_string)
matches2

#3: Name capturing group for last name, first name, gender, position title, compensation, and phone number
reg_ptags3 = "Non Profit.*[\s]+(?P<LastName>\w+)[\s]+(?P<FirstName>[A-z]\w+)+[\s]+(?P<Gender>[FM])[\s]+[0-9][\s]+(?P<PositionTitle>.*[^ ])[\s]+(?P<Compensation>[0-9]+)[\s]+[0-9][\s].*[\s]+(?P<Phone>[0-9]+-[0-9]+-[0-9]+)"
for i in regex.finditer(reg_ptags3,merged_hospital_data_string):
    print(i.group('LastName'),i.group('FirstName'),i.group('Gender'),i.group('PositionTitle'),i.group('Compensation'),i.group('Phone'))

#4: Repeat #3 with exclusion of safety inspection members
reg_ptags4 = "Non Profit.*[\s]+(?P<LastName>\w+)[\s]+(?P<FirstName>[A-z]\w+)+[\s]+(?P<Gender>[FM])[\s]+[0-9]+[\s][?!Safety Inspection Member]+[\s]+(?P<PositionTitle>.*[^ ])[\s]+(?P<Compensation>[0-9]+)[\s]+[0-9][\s].*[\s]+(?P<Phone>[0-9]+-[0-9]+-[0-9]+)"
for i in regex.finditer(reg_ptags4,merged_hospital_data_string):
    print(i.group('LastName'),i.group('FirstName'),i.group('Gender'),i.group('PositionTitle'),i.group('Compensation'),i.group('Phone'))

#5 Extract all personnel who work for an academic institution
#This will pull all data for only those with a .edu email indicating an academic institution
reg_ptags5 = "(.*?)(\.edu.*)"
matches5 = regex.findall(reg_ptags5, merged_hospital_data_string)
matches5