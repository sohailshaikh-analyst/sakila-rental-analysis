-- Sakila Rental Analysis (MySQL)
-- Sample database: DVD rental store with 16 tables
USE sakila;

-- Q1: List each film with its category. (INNER JOIN, 2 joins)
SELECT f.title, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
LIMIT 10;

-- Q2: Which film categories earn the most revenue? (5 joins)
SELECT c.name AS category, ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY revenue DESC;

-- Q3: Who are the top 10 customers by total spending?
SELECT c.customer_id, c.first_name, c.last_name, ROUND(SUM(p.amount), 2) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q4: What is the revenue of each store, and in which city is it?
SELECT st.store_id, ci.city, ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
JOIN store st ON s.store_id = st.store_id
JOIN address a ON st.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY st.store_id, ci.city;

-- Q5: Which 10 countries bring the most revenue? (customer -> address -> city -> country)
SELECT co.country, ROUND(SUM(p.amount), 2) AS revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country
ORDER BY revenue DESC
LIMIT 10;

-- Q6: What are the 10 most rented films?
SELECT f.title, COUNT(*) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY times_rented DESC
LIMIT 10;

-- Q7: Which films were never rented? (LEFT JOIN + IS NULL)
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;

-- Q8: What is the monthly revenue?
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month, ROUND(SUM(amount), 2) AS revenue
FROM payment
GROUP BY month
ORDER BY month;

-- Q9: Which 10 actors appear in the most rented films?
SELECT a.first_name, a.last_name, COUNT(*) AS rentals
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY rentals DESC
LIMIT 10;

-- Q10: Which customers spent more than the average customer? (CTE)
WITH customer_spend AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, ROUND(cs.total_spent, 2) AS total_spent
FROM customer_spend cs
JOIN customer c ON cs.customer_id = c.customer_id
WHERE cs.total_spent > (SELECT AVG(total_spent) FROM customer_spend)
ORDER BY cs.total_spent DESC
LIMIT 10;

-- Q11: What are the top 3 films by revenue in each category? (CTE + window function)
WITH film_revenue AS (
    SELECT c.name AS category, f.title, SUM(p.amount) AS revenue
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
)
SELECT category, title, ROUND(revenue, 2) AS revenue, rnk
FROM (
    SELECT category, title, revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM film_revenue
) ranked
WHERE rnk <= 3
ORDER BY category, rnk;

-- Q12: What is the average rental duration (in days) for each category?
SELECT c.name AS category,
       ROUND(AVG(DATEDIFF(r.return_date, r.rental_date)), 1) AS avg_rental_days
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE r.return_date IS NOT NULL
GROUP BY c.name
ORDER BY avg_rental_days DESC;