/* Lab 14 Group by */

#1 In the table actor, what last names are not repeated? For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
#check table for last_names to get an overview (200 rows) 
select last_name from sakila.actor;

#output = unique last_names (66 rows) 
select last_name, count(*) from sakila.actor 
group by last_name 
having count(*) = 1; 

#2 Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
#output = duplicate last_names (55 rows) without unique last_names
		#e.g. Akroyd, Allen, Bailey, Bening, Zellweger are not supposed to appear above 
select last_name, count(*) from sakila.actor 
group by last_name 
having count(*) > 1; 

#3 Using the rental table, find out how many rentals were processed by each employee.
select staff_id, count(rental_id) as processed_rentals from rental
group by staff_id
order by processed_rentals;

#4 Using the film table, find out how many films were released.
select release_year, count(film_id) as num_films_released from film
group by release_year;

#5 Using the film table, find out how many films there are of each rating.
select distinct(rating) from film;

select rating, count(film_id) as total_num_films from film
group by rating
order by total_num_films desc;

#6 What is the mean length of the films for each rating type. Round off the average lengths to two decimal places.
select rating, round(avg(length),2) as mean_length from film
group by rating
order by mean_length desc;

#7 Which kind of movies (rating) have a mean duration of more than two hours?
select rating, round(avg(length),2) as mean_length from film
group by rating 
having avg(length) > 120