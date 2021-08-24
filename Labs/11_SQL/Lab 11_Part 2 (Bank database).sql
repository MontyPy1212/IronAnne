#1 Get the id values of the first 5 clients from district_id with a value equals to 1.

SELECT 
    client_id
FROM
    bank.client
WHERE
    district_id = 1
LIMIT 5; 

#2 In the client table, get an id value of the last client where the district_id equals to 72.

SELECT 
    MAX(client_id)
FROM
    bank.client
WHERE
    district_id = 72
LIMIT 5;

#3 Get the 3 lowest amounts in the loan table.

SELECT 
    amount
FROM
    bank.loan
ORDER BY amount ASC
LIMIT 3;

#4 What are the possible values for status, ordered alphabetically in ascending order in the loan table?

SELECT DISTINCT
    status
FROM
    bank.loan
ORDER BY status ASC;

#5 What is the loan_id of the highest payment received in the loan table?

SELECT 
    status
FROM
    bank.loan
ORDER BY status;

#6 What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
SELECT 
    account_id, amount
FROM
    bank.loan
ORDER BY account_id ASC
LIMIT 5;

#7 What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
SELECT 
    account_id
FROM
    loan
WHERE
    duration = 60
ORDER BY amount ASC
LIMIT 5;

#8 What are the unique values of k_symbol in the order table? Note: There shouldn't be a table name order, since order is reserved from the ORDER BY clause. You have to use backticks to escape the order table name.
SELECT DISTINCT
    k_symbol
FROM
    bank.order
ORDER BY k_symbol;

#9 In the order table, what are the order_ids of the client with the account_id 34?

SELECT 
    order_id
FROM
    bank.order
WHERE
    account_id = 34;

#10 In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT DISTINCT
    account_id
FROM
    bank.order
WHERE
    order_id BETWEEN 29540 AND 29560;

#11 In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
SELECT 
    amount
FROM
    bank.order
WHERE
    account_to = 30067122;

#12 In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
SELECT 
    trans_id, date, type, amount
FROM
    bank.trans
WHERE
    account_id = 793
ORDER BY date DESC
LIMIT 10;
		#try having customer_id > 10

#13 In the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
SELECT 
    district_id, COUNT(*)
FROM
    bank.client
WHERE
    district_id < 10
GROUP BY district_id
ORDER BY district_id ASC;
			## filter / get the customer first_name whose id = 148 
				###select * from customer where customer_id = 148
			##when you use group by function you can apply two values with "select", if not computer aggregates all the values 

#14 In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
SELECT 
    type, COUNT(card_id) AS num_card
FROM
    bank.card
GROUP BY type
ORDER BY num_card DESC; 

#15 Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
SELECT 
    account_id, MAX(amount) AS max_amount
FROM
    bank.loan
GROUP BY account_id
ORDER BY max_amount DESC
LIMIT 10;
		#select max(amount) as max_amount, account_id from bank.loan group by account_id order by max_amount desc limit 10;

#16 In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
SELECT 
    date, COUNT(loan_id) AS num_loans
FROM
    bank.loan
WHERE
    date < 930907
GROUP BY date
ORDER BY date DESC; 

#17 In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
	#select date, count(loan_id) as num_loans from bank.loan where date between 971201 and 971231 group by date order by date asc; 
SELECT 
    date, duration, COUNT(loan_id)
FROM
    bank.loan
WHERE
    date LIKE '9712%'
GROUP BY date , duration
ORDER BY date ASC; 

#18 In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
SELECT 
    account_id, type, SUM(amount) AS total_amount
FROM
    bank.trans
WHERE
    account_id = 396
GROUP BY type
ORDER BY type ASC; 

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
#OR 
SELECT 
    account_id,
    IF(type = 'PRIJEM',
        'INCOMING',
        'OUTGOING') AS transaction_type,
    FLOOR(SUM(amount)) AS total_amount
FROM
    trans
WHERE
    account_id = 396
GROUP BY 1 , 2
ORDER BY 2; 
            
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
        bank.trans) AS table_b
   # WHERE
    #    account_id = 396
   # GROUP BY type
   # ORDER BY type) AS table_b
#GROUP BY account_id;
#-------------------------------------------------
#Lecture
	#select *, amount - payments as balance from bank.loan;
	#select loan_id, account_id, duration, status, (amount - payments) / 100 as "balance in thoursands" from bank.loan;
	#select duration%2, duration from bank.loan; 
	#select * from bank.loan where status not in ("B", "b") and amount > 100000; 

	#select distinct A2 from bank.district;
	#select distinct A2, A4 from bank.district where A2 in ("Benesov", "Beroun") or A4 < 75000;
    
	#select * from bank.loan where A2 in ("Benesov", "Beroun") and amount <> 100000;
	#select max(amount) as max, min(amount) as min from bank.order; 
    
	#SELECT * FROM bank.district
	#WHERE A3 LIKE "north%";

	#SELECT * FROM bank.district
	#WHERE A3 LIKE "north_M%";