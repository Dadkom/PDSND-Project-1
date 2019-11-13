/*# ALMEGDAD AL AL ALI
# PROGRAMMING FOR DATA SCIENCE "SQL_PROJECT"
# SEPTEMPER, 27 2019*/

/*Q1.1 - Create a query that lists each movie, the film category it is classified in,
and the number of times it has been rented out. With Category, Film_Category, Inventory, Rental and Film.
it should have three columns: Film title, Category name and Count of Rentals. */

SELECT film.title AS film_title,
       category.name AS category_name,
       COUNT(rental_id) AS rental_count
    FROM film_category
          JOIN category
              ON film_category.category_id = category.category_id
          JOIN film
              ON film_category.film_id = film.film_id
          JOIN inventory
              ON film.film_id = inventory.film_id
          JOIN rental
              ON inventory.inventory_id = rental.inventory_id
WHERE category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
  GROUP BY 1, 2
    ORDER BY 2, 1;

/*'Q1.2 - how the length of rental duration of these family-friendly movies compares
to the duration that all movies are rented for.
provide a table with the movie titles and divide them into 4 levels
(first_quarter, second_quarter, third_quarter, and final_quarter) */

SELECT film.title AS film_title,
       category.name AS category_name,
       film.rental_duration AS rental_duration,
       NTILE(4) OVER (ORDER BY film.rental_duration) AS standard_quartile
   FROM film_category
        JOIN category
            ON film_category.category_id = category.category_id
        JOIN film
            ON film_category.film_id = film.film_id
WHERE category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music');

/*Q2.1 - Find out how the two stores compare
in their count of rental orders during every month for all
the years that have data*/

SELECT DATE_PART('month', rental.rental_date) AS rental_month,
       DATE_PART('year', rental.rental_date)  AS rental_year,
       staff.store_id AS store_id,
	     Count(rental.rental_id) AS counts_rental
   FROM staff
        JOIN rental
            ON staff.staff_id = rental.staff_id
  GROUP BY 1, 2, 3
    ORDER BY counts_rental DESC;

/*Q2.2 who were our top 10 paying customers,
how many payments they made on a monthly basis during 2007,
and what was the amount of the monthly payments.*/

SELECT payment.customer_id,
       DATE_TRUNC('month', payment_date) AS pay_mon,
       customer.first_name || ' ' || customer.last_name AS fullname,
       COUNT(payment.amount) AS pay_countpermon,
       SUM(payment.amount) AS pay_amount
   FROM payment
        JOIN customer
            ON payment.customer_id = customer.customer_id
   WHERE DATE_PART('year', payment_date) = 2007
   GROUP BY 1, 2, 3
HAVING payment.customer_id IN (
SELECT customer_id
   FROM (
SELECT payment.customer_id AS customer_id,
       customer.first_name AS first,
       customer.last_name AS last,
       SUM(amount) AS total_amount
   FROM payment
        JOIN customer
            ON payment.customer_id = customer.customer_id
  GROUP BY 1, 2, 3
    ORDER BY 4 DESC
LIMIT 10 ) t1
                              )
    ORDER BY 3, 2;
