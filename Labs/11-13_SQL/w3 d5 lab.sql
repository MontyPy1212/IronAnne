# Short name for data table
ALTER TABLE `lab_db_python_sql`.`data_marketing_customer_analysis_round2` 
RENAME TO  `lab_db_python_sql`.`customer` ;
# Standardizing header names
use lab_db_python_sql;
ALTER TABLE customer 
CHANGE State state VARCHAR(30),
CHANGE `Customer Lifetime Value` customer_lifetime_value DOUBLE,
CHANGE `Effective To Date` effective_to_date TEXT,
CHANGE `Marital Status` marital_status TEXT,
CHANGE `Monthly Premium Auto` monthly_premium_auto INT,
CHANGE `Months Since Last Claim` months_since_last_claim TEXT,
CHANGE `Months Since Policy Inception` months_since_policy_inception INT,
CHANGE `Number Of Open Complaints` number_of_open_complaints TEXT,
CHANGE `Number of Policies` number_of_policies INT,
CHANGE `Policy Type` policy_type TEXT,
CHANGE `Renew Offer Type` renew_offer_type TEXT,
CHANGE `Sales Channel` sales_channel TEXT,
CHANGE `Total Claim Amount` total_claim_amount DOUBLE,
CHANGE `Vehicle Class` vehicle_class TEXT,
CHANGE `Vehicle Size` vehicle_size TEXT,
CHANGE `Vehicle Type` vehicle_type TEXT;
select * from customer;

ALTER TABLE `lab_db_python_sql`.`customer` 
CHANGE COLUMN `Response` `response` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Coverage` `coverage` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Education` `education` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `EmploymentStatus` `employment_status` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Gender` `gender` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Income` `income` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Location Code` `location_code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Policy` `policy` TEXT NULL DEFAULT NULL ;

# Deleting and rearranging columns – delete the column customer as it is only a unique 
# identifier for each row of data
alter table `lab_db_python_sql`.`customer`
drop MyUnknownColumn;
alter table lab_db_python_sql.customer
drop Customer;
ALTER TABLE `lab_db_python_sql`.`customer` 
CHANGE COLUMN `Customer Lifetime Value` `Customer Lifetime Value` DOUBLE NULL DEFAULT NULL FIRST;

# Working with data types – Check the data types of all the columns and fix the incorrect ones 
# (for ex. customer lifetime value and number of complaints )

#SET SQL_SAFE_UPDATES = 0; => to enable deletion 
desc `customer`;
SELECT distinct(number_of_open_complaints) from lab_db_python_sql.customer;
SELECT number_of_open_complaints FROM customer
WHERE number_of_open_complaints < 1;

UPDATE customer
SET number_of_open_complaints = 0
WHERE number_of_open_complaints < 1;

ALTER TABLE customer
MODIFY COLUMN number_of_open_complaints INT;

select distinct(months_since_last_claim) from customer;
select months_since_last_claim from customer 
where months_since_last_claim = "";
select IFNULL(months_since_last_claim, 0) from customer;

# This result is 14
SELECT ROUND(AVG(months_since_last_claim)) as avg_month_claim FROM customer; 

UPDATE customer
SET months_since_last_claim = 14
WHERE months_since_last_claim="";

# removing duplicates
# Bitas solution with grouping, problem is that the original ones will be dropped as well
SELECT *, COUNT(*) AS count
FROM customer
GROUP BY state, customer_lifetime_value, response, coverage,education, effective_to_date, 
employment_status, gender,income,location_code,marital_status, monthly_premium_auto, 
number_of_policies,policy_type, policy, renew_offer_type,sales_channel,vehicle_class, 
vehicle_size, vehicle_type
HAVING COUNT(*) > 1;

# duplicates can be found with partition
WITH customer AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY total_claim_amount,
response,
coverage,
effective_to_date,
employment_status,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
			
            ORDER BY
            total_claim_amount,
response,
coverage,
effective_to_date,
employment_status,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
income
            ) row_num
		FROM customer
        ) 
        SELECT * from customer
        where row_num > 1;
        
WITH cte AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY 
state,
customer_lifetime_value,
response,
coverage,
education,
effective_to_date,
gender,
income,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
vehicle_type

			
            ORDER BY
           state,
customer_lifetime_value,
response,
coverage,
education,
effective_to_date,
gender,
income,
location_code,
marital_status,
monthly_premium_auto,
months_since_last_claim,
months_since_policy_inception, 
number_of_open_complaints,
number_of_policies,
policy_type,
policy,
renew_offer_type,
sales_channel,
total_claim_amount,
vehicle_class,
vehicle_size,
vehicle_type
            ) row_num
		FROM customer_analysis
        ) 
        DELETE from cte
        where row_num > 1;