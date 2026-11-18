# Sakila Rental Analysis

SQL joins analysis of the MySQL Sakila sample database (a DVD rental store with 16 tables), with a Power BI dashboard.

![Dashboard](Dashboard.png)

## Goal
Find which film categories, customers and films bring the most revenue, and how revenue changes over time.

## Tools
- MySQL (INNER JOIN, LEFT JOIN, multi-table joins, GROUP BY, CTEs, window functions)
- Power BI (dashboard)

## Files
- `sakila_analysis.sql`: 12 SQL queries, each with its question
- `sakila_dashboard.pbix`: Power BI dashboard
- `Dashboard.png`: dashboard screenshot
- `category_revenue.csv`, `monthly_revenue.csv`, `top_customers.csv`, `top_films.csv`: query results used in the dashboard

## SQL skills shown
- Joining up to 5 tables (payment, rental, inventory, film_category, category)
- LEFT JOIN with IS NULL to find films that were never rented
- CTEs and RANK() window function (top 3 films in each category)

## Key insights
1. Total revenue is $67,406.56 across 16 film categories.
2. Sports is the top-earning category ($5,314.21, about 7.9% of revenue), followed by Sci-Fi ($4,756.98) and Animation ($4,656.30). Music is the lowest ($3,417.72). Revenue is spread fairly evenly across categories.
3. The top customer (Karl Seal) spent $221.55, about 27% more than the 10th customer ($174.66). The top 10 customers bring only about 2.8% of revenue, so revenue is not concentrated in a few customers.
4. The most rented film (Bucket Brotherhood) was rented 34 times, only slightly above the 10th film (31 rentals), so no single film dominates.
5. July 2005 was the peak month ($28,368.91, about 42% of revenue). July and August together bring about 78% of the revenue.

## Data note
Sakila is a sample database provided by MySQL, not real business data. Payments exist only for May to August 2005 and a small amount in February 2006, so monthly trends cover a short period.
