#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 17 11:11:47 2021

@author: Annie
"""

#Activity 1
#Pandas official documentation: https://pandas.pydata.org/docs/index.html

#1. Aggregate data into one Data Frame using Pandas.
import pandas as pd
print(pd.__version__)


insurance_df = pd.read_csv('/Users/Annie/Documents/GitHub/IronAnne/Labs/Pandas/file1.csv')
print(insurance_df)

insurance_df_two = pd.read_csv('/Users/Annie/Documents/GitHub/IronAnne/Labs/Pandas/file2.csv')
print(insurance_df_two)

#Are they the same? If no, then move on 
print(pd.DataFrame.equals(insurance_df, insurance_df_two))

#Check if columns are the same?
    #sometimes you have to rearrange columns, but Pandas is recognizing them automatically
print(insurance_df.columns)
print(insurance_df_two.columns)


# Data blending

insurance_df_all = pd.concat([insurance_df, insurance_df_two], axis=0, ignore_index=True)
print(insurance_df_all)

"""
column_names = file1.columns
data = pd.DataFrame(columns=column_names)
data = pd.concat([data,file1, file2], axis=0)
data.shape
"""

#2. Deleting and rearranging columns (https://www.educative.io/edpresso/how-to-delete-a-column-in-pandas)


#2.1. Delete the column "customer" as it is only a unique identifier for each row of data
"""Why do we have to kill the unique identifier?"""
insurance_df_all.drop(columns="Customer", inplace=True)
print(insurance_df_all)
                   
#OR del df['customer']


#2.2. Standardizing header names
    # display the dataframe head
print(insurance_df_all.head(10))

# settings to display all columns
pd.get_option("display.max_columns")
pd.set_option("display.max_columns", None)


#2.2.1. Convert column header to string
#df.columns = df.columns.astype("str")

#2.2.2. Format column header with cases
    #Index.str method
    #df.columns = df.columns.str.upper()
insurance_df_all.columns = insurance_df_all.columns.str.lower()
print(insurance_df_all)

###2.2.3. Rename columns

insurance_df_all_new = insurance_df_all.rename(columns = {'st': 'state'}, inplace = False)
print(insurance_df_all_new)

#Index.map method
#df.columns = df.columns.map(str.upper)

#Python built-in map method
#df.columns = map(str.upper, df.columns)

#2.2.3. Replace characters in column header
#df.columns = df.columns.map(lambda x : x.replace("-", "_").replace(" ", "_"))

# Or
#df.columns = map(lambda x : x.replace("-", "_").replace(" ", "_"), df.columns)

#2.2.4. Add prefix or suffix to column header
#adding prefix with "Label_"
#df.columns = df.columns.map(lambda x : "Label_" + x)

#adding suffix with "_Col"
#df.columns = df.columns.map(lambda x : x + "_Col")

#2.3. Reorder columns
#provide within the brackets a list with the new column name order
#df[ list_of_columns ]

"""
#3. Explore
df.head()
    
    #range of values for numerical columns
    df.describe()
    
    #same object column use
    df[‘colname’].value_counts()

    #get unique values
    df[‘colnames’].unique()
"""

#3.1. Check Data Type

#Check the data types of all the columns and fix the incorrect ones (for ex. customer lifetime value and number of complaints)
check_column_type = insurance_df_all_new.dtypes
print(check_column_type)

    #Fix column CLV
        ##Convert type with astype conversion method --> works only if data is clean and has no symbols (e. g. $) and if you want to convert a number to string
#insurance_df_all_new["customer lifetime value"].astype('str')

        #insurance_df_all_new['customer lifetime value'] = pd.to_numeric(insurance_df_all_new['customer lifetime value'])

def convert_column_clv(i):
    if i != i:
        pass 
    i = str(i).replace("%", "")
    return float(i)/100

#remove_percent = [i.replace('%','') for i in insurance_df_all_new["customer lifetime value"]]
#print(remove_percent[0:10])

insurance_df_all_new["customer lifetime value"] = insurance_df_all_new["customer lifetime value"].apply(convert_column_clv)
print(insurance_df_all_new["customer lifetime value"].head(10))


#test = insurance_df_all_new['customer lifetime value'].apply(lambda x: x.replace('%', '')).astype('float') / 100

def convert_column_complaints(i):
    if i != i:
        return 0
    i = str(i)
    return int(i[2])

insurance_df_all_new["number of open complaints"] = insurance_df_all_new["number of open complaints"].apply(convert_column_complaints)
print(insurance_df_all_new["number of open complaints"].head(100))


#Removing duplicates 
print(insurance_df_all_new.drop_duplicates())

#4. Filtering data and Correcting typos
    #4.1. State column
print(insurance_df_all_new["state"].value_counts())

"""
def update_column_state(i):
    type1_replace = ["Cali", "California"]
    for n in type1_replace:
        i = str(i).replace(n , "California")
    return i
    """
    
def update_column_state(i):
    if i != i:
        pass
    if str(i).endswith("li") == True:
        i = str(i).replace("Cali", "California")
    i = str(i).replace("AZ", "Arizona").replace("WA", "Washington")
    return str(i)

insurance_df_all_new["state"] = insurance_df_all_new["state"].apply(update_column_state)
print(insurance_df_all_new["state"].head(20))

print(insurance_df_all_new["state"].value_counts())

    #4.2. Gender column
print(insurance_df_all_new["gender"].value_counts())


def group 
"""
def update_column_gender(i):
    if i != i:
        pass
    i = str(i).replace("Cali", "California").replace("AZ", "Arizona").replace("WA", "Washington")
    return str(i)

insurance_df_all_new["state"] = insurance_df_all_new["state"].apply(update_column_state)
print(insurance_df_all_new["state"].head(20))

print(insurance_df_all_new["state"].value_counts())




#4. Filtering data and Correcting typos 
df[condition]

#4.1. Filter the data in state and gender column to standardize the texts in those columns


#6. Replacing null values – Replace missing values with means of the column (for numerical columns)
    #Finding Null Values 
    isna() 
    isnull()

    #Filling NAs 
    fillna()
    
    #Categorial values - With categorical column types, you can get how many values you have of each applying the method: value_counts() to the corresponding column
"""