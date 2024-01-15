-- Problem 5: Retrieve the products with the highest average rating
-- Write an SQL query to retrieve the products with the highest average rating.
-- The result should include the product ID, product name, and the average rating.
-- Hint: You may need to use subqueries or common table expressions (CTEs) to solve this problem.

-- Use CTE to create AVG_RATING_TABLE, a table that contains the product_id and average rating scores
with AVG_RATING_TABLE as (
    (select product_id, avg(rating) as average_rating
    from Reviews
    group by product_id)
)
select p.product_id, product_name, average_rating
from Products p join
(select r.product_id, avg(rating) as average_rating
from Reviews r
group by r.product_id
having avg(rating) = (select max(average_rating) from AVG_RATING_TABLE) -- find the highest average rating score from AVG_RATING_TABLE
) temp
on p.product_id = temp.product_id                    
                    
-- Problem 6: Retrieve the users who have made at least one order in each category
-- Write an SQL query to retrieve the users who have made at least one order in each category.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or joins to solve this problem.
select u.user_id, u.username
from Users u -- select username from Users and join with temp table to make sure each username returned matches its user_id
join
(select o.user_id
from Orders o join Order_Items oi on oi.order_id = o.order_id
join Products p on p.product_id = oi.product_id
group by o.user_id
-- if the number of product categories a user orders = the total number of product categories, 
-- this user has made at least one order in each category
having count(distinct p.category_id) = (select count(*) from Categories) -- number of categories
) temp -- temp table contains the IDs of users that have made at least one order in each category
on u.user_id = temp.user_id

-- Problem 7: Retrieve the products that have not received any reviews
-- Write an SQL query to retrieve the products that have not received any reviews.
-- The result should include the product ID and product name.
-- Hint: You may need to use subqueries or left joins to solve this problem.
select product_id, product_name
from Products
-- if a product has not received any reviews, it means that the ID of this product does not appear in the Reviews table
where product_id not in (select distinct product_id from Reviews)

-- Problem 8: Retrieve the users who have made consecutive orders on consecutive days
-- Write an SQL query to retrieve the users who have made consecutive orders on consecutive days.
-- The result should include the user ID and username.
-- Hint: You may need to use subqueries or window functions to solve this problem.
select user_id, username
from Users
where user_id in
-- use self-join to find users that have the same ID and order on at least 2 days in a row
(select distinct o1.user_id
from Orders o1 join Orders o2 on o1.user_id = o2.user_id
and abs(datediff(o1.order_date, o2.order_date)) = 1) -- date difference = 1: consecutive days