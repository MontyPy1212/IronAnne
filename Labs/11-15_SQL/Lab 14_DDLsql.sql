/* LAB 14 - Data Definition Language */

#1. Get release years.
SELECT 
    release_year
FROM
    sakila.film
GROUP BY release_year;

#2. Get all films with ARMAGEDDON in the title.
SELECT 
    title
FROM
    sakila.film
WHERE
    title LIKE '%ARMAGEDDON%';

#3. Get all films which title ends with APOLLO.
SELECT 
    title
FROM
    sakila.film
WHERE
    title LIKE '%APOLLO';

#4. Get 10 of the longest films.
SELECT 
    f.title, (f.length)
FROM
    film f
ORDER BY f.length DESC
LIMIT 10;

#5. How many films include Behind the Scenes content?

SELECT 
    COUNT(film_id)
FROM
    sakila.film
WHERE
    special_features LIKE ('%Behind the Scenes%');

#6. Drop column picture from staff.

ALTER TABLE sakila.staff
DROP COLUMN picture;

#7. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
#check details from tammy in customer table 
SELECT 
    *
FROM
    customer
WHERE
    first_name = 'TAMMY'
        AND last_name = 'SANDERS';

#check columns in staff
SELECT 
    *
FROM
    staff;

#insert all details in staff table manually 
insert into staff (first_name, last_name, address_id, email, store_id, active, username) values ("TAMMY", "SANDERS", 79, "TAMMY.SANDERS@sakilacustomer.org", 2, 1, "TaSanders");

#8. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. 
#Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

#get customer_id 
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

#get film_id to check inventory_id in store 1 
select * from sakila.inventory 
where film_id = 1 and store_id = 1

#check inventory_id in rental table to check if it's rented out
select * from sakila.rental
where inventory_id = 4 #and inventory_id = 2 and inventory_id = 3 and inventory_id = 4 

#get staff_id from Mike 
select * from staff;

#check what columns need to be filled 
select * from rental; 
# collected info: (rental_id (auto), rental_date(2021-08-26), inventory_id, customer_id (130), return_date(2021-08-29), staff_id(1))

insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id) values ("2021-08-26 12:00:00", 1, 130, "2021-08-29 01:01:59", 1);

#check if it worked

SELECT 
    *
FROM
    rental
WHERE
    customer_id = 130;

#9. Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:

	#Check if there are any non-active users --> there are 15 inactive customers and 584 active customers 
select count(active) as active from sakila.customer
where active = 1;

select count(active) from sakila.customer
where active = 0;
	
    #Create a table backup table as suggested

select * from sakila.customer; 

CREATE TABLE inactive_customers_backup (
    customer_id SMALLINT,
    store_id TINYINT,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(45),
    address_id SMALLINT,
    active TINYINT,
    create_date DATETIME,
    last_update TIMESTAMP);
	
    #Insert the non active users in the table backup table
    
    #Create Table Using Another Table
	CREATE TABLE inactive_customers_backup_short (
    SELECT *
    FROM customer
    where active = 0); 
    
		#check if it worked 
	SELECT * FROM sakila.inactive_customers_backup_short;
    
    #Delete the non active users from the table customer
    DELETE FROM customer WHERE active = 0;
    
		#check if it worked
	select count(active) from sakila.customer
	where active = 0;
    
    
    
    