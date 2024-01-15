-- Problem 1: Retrieve all products in the Sports category
-- Write an SQL query to retrieve all products in a specific category.

select product_name
from Products p join Categories c on p.category_id = c.category_id
where c.category_name = "Sports & Outdoors"

-- Problem 2: Retrieve the total number of orders for each user
-- Write an SQL query to retrieve the total number of orders for each user.
-- The result should include the user ID, username, and the total number of orders.
select u.user_id, u.username, orders_num
from Users u
-- select username from Users and join with temp table to make sure each username returned matches its user_id and aggregation result
join
(select user_id, count(distinct order_id) as orders_num
from Orders
group by user_id) temp -- temp table contains the aggregation result: number of orders per user
on u.user_id = temp.user_id

-- Problem 3: Retrieve the average rating for each product
-- Write an SQL query to retrieve the average rating for each product.
-- The result should include the product ID, product name, and the average rating.
select p.product_id, product_name, average_rating
from Products p
-- select product_name from Products and join with temp table to make sure each product_name returned matches its product_id and aggregation result
join
(select product_id, avg(rating) as average_rating
from Reviews
group by product_id) temp -- temp table contains the aggregation result: average rating for each product
on p.product_id = temp.product_id

-- Problem 4: Retrieve the top 5 users with the highest total amount spent on orders
-- Write an SQL query to retrieve the top 5 users with the highest total amount spent on orders.
-- The result should include the user ID, username, and the total amount spent.

select u.user_id, u.username, user_total_amount_spent
from Users u
-- select username from Users and join with temp table to make sure each username returned matches its user_id and aggregation result
(select user_id, sum(total_amount) as user_total_amount_spent
from Orders
group by user_id -- aggregation: get the total amount each user spent ordering
order by sum(total_amount) desc -- return the users in descending order of their total amount spent ordering
limit 5 -- take the top 5 rows, which are the top 5 users with the highest total amount spent ordering
) temp -- temp table contains the aggregation result: total amount each user spent ordering
on u.user_id = temp.user_id
