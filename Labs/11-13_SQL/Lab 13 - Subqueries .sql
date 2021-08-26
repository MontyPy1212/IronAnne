
/*
LAB 13 SQL - SUBQUERIES 

RULES 
- COMPARE an expression to the result of the query.
- Determine if an expression IS INCLUDED (=EXISTS) in the results of the query.
- CHECK CONDITION .

SYNTAX (ONLY CHILD)

(SELECT [DISTINCT] subquery_select_argument
FROM {table_name | view_name}
{table_name | view_name} ...
[WHERE search_conditions]
[GROUP BY aggregate_expression [, aggregate_expression] ...]
[HAVING search_conditions

EXAMPLE
Identify all students who get better marks than that of the student who's StudentID is 'V002', but we do not know the marks of 'V002'.

1) One query returns the marks (stored in Total_marks field) of 'V002' 
SELECT *  
FROM `marks`  
WHERE studentid = 'V002';

2) A second query identifies the students who get better marks than the result of the first query.
SELECT a.studentid, a.name, b.total_marks
FROM student a, marks b
WHERE a.studentid = b.studentid
AND b.total_marks >80;

------->
SELECT a.studentid, a.name, b.total_marks
FROM student a, marks b
WHERE a.studentid = b.studentid AND b.total_marks >
(SELECT total_marks
FROM marks
WHERE studentid =  'V002');

In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.
*/
#1. How many copies of the film Hunchback Impossible exist in the inventory system?
 
SELECT 
    COUNT(inventory_id) AS num_copies
FROM
    inventory i
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');

#Official solution            
SELECT 
    COUNT(film_id) AS counts
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            sakila.film
        WHERE
            title = 'Hunchback Impossible');
            
# OR INNER JOIN 
SELECT 
    title, COUNT(inventory_id)
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    title = 'Hunchback Impossible';
    
#2. List all films whose length is longer than the average of all the films.

SELECT 
    f.title, f.length
FROM
    film f
WHERE
    f.length > (SELECT 
            AVG(f.length)
        FROM
            film f);


#3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            film_actor
        WHERE
            film_id IN (SELECT 
                    film_id
                FROM
                    film
                WHERE
                    title = 'Alone Trip'));

#Official solution
SELECT 
    CONCAT(first_name, ' ', last_name) AS Actor
FROM
    sakila.actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            sakila.film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title = 'ALONE TRIP'));

#INNER JOIN ALTERNATIVE 

SELECT 
    a.first_name, a.last_name
FROM
    actor a
        INNER JOIN
    film_actor b ON a.actor_id = b.actor_id
        INNER JOIN
    film c ON b.film_id = c.film_id
WHERE
    c.title = 'Alone Trip'; 

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT 
    f.title
FROM
    film f
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            film_category
        WHERE
            category_id IN (SELECT 
                    category_id
                FROM
                    category
                WHERE
                    name = 'Family'));

# OR SIMPLY CONFER TO VIEWS 
SELECT 
    title, category
FROM
    film_list
WHERE
    category = 'Family';

#5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT 
    cu.last_name, cu.first_name, cu.email
FROM
    customer cu
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));

#Official solution
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Customer Name', email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            sakila.address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));

#JOIN
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
#Get most profilic actress/actor
SELECT 
    actor.actor_id,
    actor.first_name,
    actor.last_name,
    COUNT(film_actor.film_id) AS num_of_films
FROM
    actor
        INNER JOIN
    film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY COUNT(film_actor.film_id) DESC
LIMIT 1;

#Now consume the view table 
SELECT 
    *
FROM
    actor_info
WHERE
    actor_id = 107;

#Official solution 
-- get most prolific author (107 movies)
SELECT 
    actor_id
FROM
    sakila.actor
        INNER JOIN
    sakila.film_actor USING (actor_id)
        INNER JOIN
    sakila.film USING (film_id)
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;

-- now get the films starred by the most prolific actor
SELECT 
    CONCAT(first_name, ' ', last_name) AS actor_name,
    film.title,
    film.release_year
FROM
    sakila.actor
        INNER JOIN
    sakila.film_actor USING (actor_id)
        INNER JOIN
    film USING (film_id)
WHERE
    actor_id = (SELECT 
            actor_id
        FROM
            sakila.actor
                INNER JOIN
            sakila.film_actor USING (actor_id)
                INNER JOIN
            sakila.film USING (film_id)
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1)
ORDER BY release_year DESC;

#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT 
    customer_id
FROM
    sakila.customer
        INNER JOIN
    payment USING (customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

-- films rented by most profitable customer
SELECT 
    film_id, title, rental_date, amount
FROM
    sakila.film
        INNER JOIN
    inventory USING (film_id)
        INNER JOIN
    rental USING (inventory_id)
        INNER JOIN
    payment USING (rental_id)
WHERE
    rental.customer_id = (SELECT 
            customer_id
        FROM
            customer
                INNER JOIN
            payment USING (customer_id)
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1)
ORDER BY rental_date DESC;

#8. Customers who spent more than the average payments.

SELECT 
    customer_id, SUM(amount) AS payment
FROM
    sakila.customer
        INNER JOIN
    payment USING (customer_id)
GROUP BY customer_id
HAVING SUM(amount) > (SELECT 
        AVG(total_payment)
    FROM
        (SELECT 
            customer_id, SUM(amount) total_payment
        FROM
            payment
        GROUP BY customer_id) t)
/*
IH_RH_DA_FT_AUG_2021_Labs_Activities_Solutions
  
-- 1
select count(film_id) as counts from inventory
where film_id = (
select film_id from sakila.film
where title = 'Hunchback Impossible'
);

-- 2
select title, length from sakila.film
where length > (
select avg(length) from sakila.film
);

-- 3
select concat(first_name , ' ' , last_name) as Actor
from sakila.actor
where actor_id in (
-- Grab the actor_ids for actors in Alone Trip
select actor_id
from sakila.film_actor
where film_id = (
-- Grab the film_id for Alone Trip
select film_id
from sakila.film
where title = 'ALONE TRIP'
)
);

-- 4
select title as Title
from sakila.film
where film_id in (
select film_id
from sakila.film_category
where category_id in (
select category_id
from sakila.category
where name = 'Family'
)
);

-- 5
select concat(first_name , ' ' , last_name) as Customer Name, email
from sakila.customer
where address_id in (
select address_id
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id in (
select country_id
from sakila.country
where country = 'Canada'
)
)
);

select concat(first_name , ' ' , last_name) as Customer Name, email
from sakila.customer
join (
sakila.address join (
sakila.city join sakila.country
using (country_id)
)
using (city_id)
)
using (address_id)
where country = 'Canada';

-- 6
-- get most prolific author
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1;

-- now get the films starred by the most prolific actor
select concat(first_name, ' ', last_name) as actor_name, film.title, film.release_year
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join film
using (film_id)
where actor_id = (
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1
)
order by release_year desc;

-- 7
-- most profitable customer

select customer_id
from sakila.customer
inner join payment using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1;

-- films rented by most profitable customer
select film_id, title, rental_date, amount
from sakila.film
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
where rental.customer_id = (
select customer_id
from customer
inner join payment
using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1
)
order by rental_date desc;

-- 8
select customer_id, sum(amount) as payment
from sakila.customer
inner join payment using (customer_id)
group by customer_id
having sum(amount) > (
select avg(total_payment)
from (
select customer_id, sum(amount) total_payment
from payment
group by customer_id
) t
)

*/