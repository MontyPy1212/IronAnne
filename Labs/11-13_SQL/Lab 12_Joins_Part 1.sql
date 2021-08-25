## Part 1 
#1.1 How many films are there for each of the categories in the category table. Use appropriate join to write this query
#INNER JOIN
SELECT 
	category.category_id as id,
    category.name as category,
    count(film_category.film_id) as num_films
FROM 
	film_category
		INNER JOIN 
	category ON category.category_id = film_category.category_id
group by category.category_id;
    
##see below if you want to join multiple tables 

SELECT 
    film.film_id,
    film.title,
    film_category.category_id,
    category.name
FROM
    film
        INNER JOIN
    film_category ON film.film_id = film_category.film_id
        INNER JOIN
    category ON film_category.category_id = category.category_id
ORDER BY film_id ASC;


#1.2 Which actor has appeared in the most films?
#INNER JOIN
	#Q How can I display only the max value? 
    #Q Why are all actors' name mixed up? 
SELECT 
	actor.actor_id,
    actor.first_name,
    actor.last_name,
    count(film_actor.film_id) as num_of_films
FROM 
	actor
		INNER JOIN 
	film_actor ON actor.actor_id = film_actor.actor_id
group by actor.actor_id
order by count(film_actor.film_id) desc
limit 1;

#1.3 Most active customer (the customer that has rented the most number of films)
#INNER JOIN
SELECT 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS num_film_rentals
FROM
    customer
        INNER JOIN
    rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(rental.rental_id) DESC
LIMIT 1;

#1.4 List number of films per category.
	#confer 1.1

#1.5 Display the first and last names, as well as the address, of each staff member.alter
#RIGHT JOIN

SELECT 
    staff.staff_id, staff.first_name, staff.last_name, address.*
FROM
    staff
        LEFT JOIN
    address ON staff.address_id = address.address_id;

#1.6 Display the total amount rung up by each staff member in August of 2005.
SELECT 
    staff.staff_id,
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS total_amount_USD
FROM
    staff
        LEFT JOIN
    payment ON staff.staff_id = payment.staff_id
WHERE
    payment_date LIKE '2005-08-%'
GROUP BY staff.staff_id;

#1.7 List each film and the number of actors who are listed for that film.
SELECT 
    film.film_id,
    film.title,
    COUNT(film_actor.actor_id) AS num_actors
FROM
    film_actor
        LEFT JOIN
    film ON film.film_id = film_actor.film_id
GROUP BY film.film_id
ORDER BY num_actors DESC;

#1.8 Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name. 

SELECT 
    customer.customer_id,
	customer.first_name,
    customer.last_name, 
    SUM(payment.amount) AS total_payment
FROM
    payment
        LEFT JOIN
    customer ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name ASC;

#Bonus: Which is the most rented film? The answer is Bucket Brotherhood. This query might require using more than one join statement. Give it a try.

SELECT 
    f.title,
    COUNT(r.rental_id) AS 'Times Rented'
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
        INNER JOIN
    rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) desc
LIMIT 1;

## Part 2 
#2.1 Write a query to display for each store its store ID, city, and country.
SELECT 
    s.store_id,
    i.city, 
    c.country
FROM
    country c
        INNER JOIN
    city i ON c.country_id = i.country_id
        INNER JOIN
    address a ON i.city_id = a.city_id
		INNER JOIN 
	store s ON a.address_id = s.address_id
GROUP BY s.store_id; 

#2.2 Write a query to display how much business, in dollars, each store brought in.
SELECT 
    s.store_id,
    sum(p.amount) as revenue_in_USD
FROM
    store s
        INNER JOIN
    staff a ON s.store_id = a.store_id
        INNER JOIN
    payment p ON a.staff_id = p.staff_id
GROUP BY s.store_id; 

#2.3 What is the average running time of films by category?
SELECT 
    category.name AS category,
    AVG(f.length) AS 'avg running time (in min)'
FROM
    category
        INNER JOIN
    film_category ON category.category_id = film_category.category_id
        INNER JOIN
    film f ON film_category.film_id = f.film_id
GROUP BY category.category_id
ORDER BY AVG(f.length);

#2.4 Which film categories are longest?
SELECT 
    category.name AS category,
    AVG(f.length) AS 'Top 3 - longest film categories'
FROM
    category
        INNER JOIN
    film_category ON category.category_id = film_category.category_id
        INNER JOIN
    film f ON film_category.film_id = f.film_id
GROUP BY category.category_id
ORDER BY AVG(f.length) DESC
LIMIT 3;

#2.5 Display the most frequently rented movies in descending order.
#repetititive question 

SELECT 
    f.title, COUNT(r.rental_id) AS rental_freq
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
        INNER JOIN
    rental r ON i.inventory_id = r.inventory_id
        INNER JOIN
    customer c ON r.customer_id = c.customer_id
GROUP BY f.title
ORDER BY rental_freq DESC;

#2.6 List the top five genres in gross revenue in descending order.
select * from sales_by_film_category
limit 5; 

#2.7 Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    film.title,
    store.store_id,
    count(inventory.inventory_id)
FROM
    inventory
        JOIN
    store USING (store_id)
        JOIN
    film USING (film_id)
WHERE
    film.title = 'Academy Dinosaur'
        AND store.store_id = 1
group by film.title;

/* SOLUTIONS

```sql
-- 1 number of films per category
select name as category_name, count(*) as num_films
from sakila.category
inner join sakila.film_category
using (category_id)
group by name
order by num_films desc;

-- 2 display the first and last names, as well as the address, of each staff member
select staff.first_name, staff.last_name, address.address
from sakila.address
inner join sakila.staff
on staff.address_id = address.address_id;

-- 3 display the total amount rung up by each staff member in August of 2005
select s.staff_id, concat(s.first_name,' ',s.last_name) as employee, sum(p.amount) as `total amount`
from sakila.staff as s
inner join sakila.payment as p
on s.staff_id = p.staff_id
where month(p.payment_date) = 8 and year(p.payment_date) = 2005
group by s.staff_id;

-- 4 List each film and the number of actors who are listed for that film
select title as `film title`, count(actor_id) as `number of actors`
from sakila.film
inner join sakila.film_actor
on film.film_id = film_actor.film_id
group by film.film_id;

-- 5 list the total paid by each customer
select first_name, last_name, sum(amount) as "total amount paid"
from sakila.customer
inner join sakila.payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name;

*/