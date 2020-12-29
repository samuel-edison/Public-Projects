import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import KFold

os.getcwd()
os.chdir(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\using-data-tha-samuel-edison\data')
#import csv
hospital_data = pd.read_csv('CaliforniaHospitalData.csv')
hospital_data.columns
#import txt
personnel_data = pd.read_table('CaliforniaHospitalData_Personnel.txt',sep ='\t')
personnel_data.columns
#merge files
all_hospital_data = pd.merge(hospital_data, personnel_data, how='inner', on='HospitalID')
all_hospital_data.columns
#remove duplicate columns
all_hospital_data = all_hospital_data.loc[:,~all_hospital_data.columns.duplicated()]
all_hospital_data.columns
#drop work_id, position_id, website
all_hospital_data.drop(['Website','Work_ID','PositionID'], axis=1, inplace=True)
all_hospital_data.columns
#select only hospitals that are small/rural w/ 15+ beds (exclude negative NOI)
hospital_data_new = all_hospital_data[(all_hospital_data.Teaching=='Small/Rural')&(all_hospital_data.AvlBeds>=15)&(all_hospital_data.OperInc >= 0)]
#write the dataframe to a text file
hospital_data_new.to_csv('hospital_data_new.txt', sep='\t')
#load the text file as a data frame
hospital_data_final = pd.read_table('hospital_data_new.txt',sep ='\t')
hospital_data_final.drop(['Unnamed: 0'], axis=1, inplace=True)

#np.savetxt(r'C:\Users\Sam Edison\source\repos\msis5193-pds1-2020fall-online\using-data-tha-samuel-edison\data\hospital_data_new.txt', hospital_data_new.values, delimiter='\t')

#Change the names of the columns
hospital_data_final.rename(columns={'NoFTE':'FullTimeCount'}, inplace=True)
hospital_data_final.rename(columns={'NetPatRev':'NetPatientRevenue'}, inplace=True)
hospital_data_final.rename(columns={'InOperExp':'InpatientOperExp'}, inplace=True)
hospital_data_final.rename(columns={'OutOperExp':'OutpatientOperExp'}, inplace=True)
hospital_data_final.rename(columns={'OperRev':'Operating_Revenue'}, inplace=True)
hospital_data_final.rename(columns={'OperInc':'Operating_Income'}, inplace=True)

#check names and types
hospital_data_final.columns
hospital_data_final.dtypes
#select two existing hospitals (46996,44817) and create a new position
##Insert your name as the employee at those two hospitals with today's date as start date
newrows = [{'HospitalID':46996, 'Name':'Ridgecrest Regional Hospital', 'Zip':'93555', 'TypeControl':'Non Profit','Teaching':'Small/Rural','DonorType':'Charity','FullTimeCount':100.0,'NetPatientRevenue':100000.0,
            'InpatientOperExp':230000.0,'OutpatientOperExp':214000.0,'Operating_Revenue':143000,'Operating_Income':120000,'AvlBeds':34,'LastName':'Edison','FirstName':'Samuel','Gender':'M','PositionTitle':'Acting Director',
            'Compensation':248904,'MaxTerm':8,'StartDate':'9/15/2020','Phone':'918-704-0095','Email':'samuel.edison@okstate.edu'},
           {'HospitalID':44817, 'Name':'Fairfield Medical Center', 'Zip':'96097-3450', 'TypeControl':'Non Profit','Teaching':'Small/Rural','DonorType':'Charity','FullTimeCount':100.0,'NetPatientRevenue':100000.0,
            'InpatientOperExp':230000.0,'OutpatientOperExp':214000.0,'Operating_Revenue':143000.0,'Operating_Income':120000.0,'AvlBeds':60,'LastName':'Edison','FirstName':'Samuel','Gender':'M','PositionTitle':'Acting Director',
            'Compensation':248904,'MaxTerm':8,'StartDate':'9/15/2020','Phone':'918-704-0095','Email':'samuel.edison@okstate.edu'}]

#append the newrows to a new data frame new merge
new_merge = hospital_data_final.append(newrows, ignore_index=True)
#convert any date/time columns to date/time
new_merge.dtypes
new_merge['StartDate'] = pd.to_datetime(new_merge['StartDate'])
#Using the new_merge data, select all hospitals that are non-profit with more than 250 employees, unless the net patient revenue is smaller than $109,000. 
new_merge = new_merge[((new_merge.TypeControl=='Non Profit')&(new_merge.FullTimeCount>250))|(new_merge.NetPatientRevenue<109000)]
print(new_merge.columns)
#Remove the columns containing employee information and save it as a new dataframe. 
new_merge.drop(['LastName','FirstName','PositionTitle','Gender','Compensation','MaxTerm','StartDate','Phone','Email'], axis=1, inplace=True)
new_merge
new_merge_final = new_merge
new_merge_final
#Export the data as a new tab-delimited file.
new_merge_final.to_csv('new_merge_final.txt', sep='\t')
#Using the new_merge data, select all the Regional Representatives who work at a hospital with operating income greater than $100,000. 
new_merge_final[(new_merge_final.Operating_Income>100000)]
#Save this as a new dataframe and then export it as a new file.
new_merge_final_OperIncFilter = new_merge_final[(new_merge_final.Operating_Income>100000)]
new_merge_final_OperIncFilter.to_csv('new_merge_final_OperIncFilter.txt', sep='\t')

