#select * from account, loan;
#both tables were merged to +3m lines / rows based on cartesian product= multiplication of two sets (set theory) 
#for instance, it has 2 account_id tables, which is creating wrong 

select Acc.district_id, frequency, loan.* from Account as acc
WHERE acc.account_id = loan.account_id;
	#above is the a conventional way 
    
select Acc.district_id, frequency, loan.* from Account as acc
INNER JOIN loan ON acc.account_id = loan.account_id;
	#above the official query for INNER JOINS (Set theory) 
    
select Acc.district_id, frequency, loan.* from Account as acc
LEFT JOIN loan ON acc.account_id = loan.account_id
	#LEFT JOINS: there are a lot of empty cells bc it is avoiding to provide you with wrong information 
    #4500 rows of the account (left) table vs. (table loan = 602) 
    
