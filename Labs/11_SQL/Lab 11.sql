#1
#select client_id from bank.client where district_id = 1 limit 5; 

#2 
#select max(client_id) from bank.client where district_id = 72 limit 5;

#3
#select amount from bank.loan order by amount asc limit 3;

#4
#select distinct status from bank.loan order by status asc;

#5
#select status from bank.loan order by status;

#6
#select account_id, amount from bank.loan order by account_id asc limit 5

#7
#SELECT account_id FROM loan WHERE duration = 60 ORDER BY amount ASC LIMIT 5;

#8
#SELECT distinct k_symbol FROM `order` ORDER BY k_symbol;

#9
#select order_id from bank.order where account_id = 34

#10 
#select distinct account_id from bank.order where order_id between 29540 and 29560;

#11
#select amount from bank.order where account_to = 30067122

#12 (open) 
#select trans_id, date, type, amount from bank.trans where account_id = 793 order by date desc limit 10
#try having customer_id > 10

#13 
#select district_id, count(*) from bank.client where district_id < 10 group by district_id order by district_id asc
			## filter / get the customer first_name whose id = 148 
				###select * from customer where customer_id = 148
			##when you use group by function you can apply two values with "select", if not computer aggregates all the values 

#14 In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
#select type, count(card_id) as num_card from bank.card group by type order by num_card desc; 

#### 15 Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
#select account_id, max(amount) as max_amount from bank.loan group by account_id order by max_amount desc limit 10;
		#select max(amount) as max_amount, account_id from bank.loan group by account_id order by max_amount desc limit 10;

#16 In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
#select date, count(loan_id) as num_loans from bank.loan where date < 930907 group by date order by date desc; 

#17 In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
	#select date, count(loan_id) as num_loans from bank.loan where date between 971201 and 971231 group by date order by date asc; 
#select date, duration, count(loan_id) from bank.loan where date LIKE "9712%" group by date, duration order by date asc; 

#18 In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
#select account_id, type, sum(amount) as total_amount from bank.trans where account_id = 396 group by type order by type asc; 

#19 From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
#select account_id, type, sum(amount) as total_amount from bank.trans where account_id = 396 group by type order by type asc; 
SELECT 
    account_id,
    IF(type = 'PRIJEM',
        'INCOMING',
        'OUTGOING'),
    FLOOR(SUM(amount)) AS total_amount
FROM
    trans
WHERE
    account_id = 396
GROUP BY type
ORDER BY type;
			## if clause is introducing a new column so no need for "type"
            
#20 From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.

SELECT 
    account_id,
    SUM(CASE
        WHEN transaction_type = 'INCOMING' THEN total_amount
    END) AS incoming,
    SUM(CASE
        WHEN transaction_type = 'OUTGOING' THEN total_amount
    END) AS outgoing,
    (SUM(CASE
        WHEN transaction_type = 'INCOMING' THEN total_amount
    END) - SUM(CASE
        WHEN transaction_type = 'OUTGOING' THEN total_amount
    END)) AS balance
FROM
    (SELECT 
        account_id,
            IF(type = 'PRIJEM', 'INCOMING', 'OUTGOING') AS transaction_type,
            FLOOR(SUM(amount)) AS total_amount
    FROM
        trans
    WHERE
        account_id = 396
    GROUP BY type
    ORDER BY type) AS table_b
GROUP BY account_id;


#21 Continuing with the previous example, rank the top 10 account_ids based on their difference.


#Lecture
	#select *, amount - payments as balance from bank.loan;
	#select loan_id, account_id, duration, status, (amount - payments) / 100 as "balance in thoursands" from bank.loan;
	#select duration%2, duration from bank.loan; 
	#select * from bank.loan where status not in ("B", "b") and amount > 100000; 

	#select distinct A2 from bank.district;
	#select distinct A2, A4 from bank.district where A2 in ("Benesov", "Beroun") or A4 < 75000;
    
	#select * from bank.loan where A2 in ("Benesov", "Beroun") and amount <> 100000;
	#select max(amount) as max, min(amount) as min from bank.order; 