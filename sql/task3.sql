-- Problem 9: Retrieve the top 3 categories with the highest total sales amount
-- Write an SQL query to retrieve the top 3 categories with the highest total sales amount.
-- The result should include the category ID, category name, and the total sales amount.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select c.category_id, category_name, cat_total_sales_amount
from Categories c -- select category_name from Categories and join with temp table to make sure each category_name returned matches its ID and total sales amount
join
(select p.category_id, sum(quantity * unit_price) as cat_total_sales_amount -- total sales amount of a product = unit price * quantity sold
from Products p join Order_Items oi on oi.product_id = p.product_id
group by p.category_id
order by sum(quantity * unit_price) desc -- return the categories in descending order of their total sales amount
limit 3 -- take the top 3 rows, which are the top 3 categories with the highest total sales amount
) temp -- temp table top 3 categories (ID only) with the highest total sales amount
on c.category_id = temp.category_id

-- Problem 10: Retrieve the users who have placed orders for all products in the Toys & Games
-- Write an SQL query to retrieve the users who have placed orders for all products in the Toys & Games
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and aggregate functions to solve this problem.
select u.user_id, username
from Users u -- select username from Users and join with temp table to make sure each username returned matches its user_id
join
(select o.user_id
from Orders o join Order_Items o_i on o_i.order_id = o.order_id
join Products p on p.product_id = o_i.product_id
join Categories c on p.category_id = c.category_id
where c.category_name = "Toys & Games" -- filter rows by the product category "Toys & Games"
group by o.user_id
-- if the number of Toys & Games products a user orders = the total number of Toys & Games products, 
-- this user has made at least one order in each category
having count(distinct o_i.product_id) =
    (select count(distinct product_id)
    from Products p join Categories c on p.category_id = c.category_id
    where c.category_name = "Toys & Games") -- find the total number of Toys & Games products
) temp -- temp table contains the users that have placed orders for all products in the Toys & Games
on u.user_id = temp.user_id

-- Problem 11: Retrieve the products that have the highest price within each category
-- Write an SQL query to retrieve the products that have the highest price within each category.
-- The result should include the product ID, product name, category ID, and price.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.

-- change the type of price from DOUBLE to FLOAT to make sure that SQL performs the comparison correctly for this column
select product_id, product_name, category_id, cast(price as FLOAT) as price
from Products
where (category_id, cast(price as FLOAT)) in
(select category_id, max(cast(price as FLOAT))
from Products
group by category_id) -- aggregation: find the highest price within each category

-- Problem 12: Retrieve the users who have placed orders on consecutive days for at least 3 days
-- Write an SQL query to retrieve the users who have placed orders on consecutive days for at least 3 days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries, joins, and window functions to solve this problem.
select user_id, username
from Users
where user_id in
-- use self-join twice to find users that have the same ID and order on at least 3 days in a row
(select distinct o1.user_id
from Orders o1 join Orders o2 on o1.user_id = o2.user_id and abs(datediff(o1.order_date, o2.order_date)) = 1
join Orders o3 on o3.user_id = o2.user_id and abs(datediff(o2.order_date, o3.order_date)) = 1) -- date difference = 1: consecutive days