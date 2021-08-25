
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

# OR SIMPLY CONFER TO Views 
SELECT title, category
FROM film_list
WHERE category = 'Family';

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

#JOIN
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';

#6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
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

select * from actor_info
where actor_id = 107

#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
#8. Customers who spent more than the average payments.
