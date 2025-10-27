select country,quantity,sale_date from stores st join sales s on st.store_id=s.store_id
select top 5 * from sales
select top 5 * from stores
select top 5 * from products
--Que 1 Identify the least selling product in each country for each year based on total units sold.
---country-product-year-quantity


--prod name-country-qty-year

with new_rankkking as (select p.product_name, country, year(sale_date) yearr,sum(quantity) qty_sold,
DENSE_RANK() over(partition by  country order by sum(quantity) asc) as rankking
from sales s join stores st on s.store_id=st.store_id join products p on s.product_id=p.product_id
group by p.product_name, country,year(sale_date))
select * from new_rankkking  where rankking=1


--Que 2 Calculate how many warranty claims were filed within 180 days of a product sale.
--product--warranty
select * from products
select  distinct repair_status from warranty
select *,dateadd(day,180,sale_date) from sales

select * from warranty w left join sales s on w.sale_id=s.sale_id 
where claim_date between sale_date and dateadd(day,180,sale_date) and repair_status='Free Replaced'


--Que 3 List the months in the last three years where sales exceeded 5,000 units in the USA. 
select  * from sales
select top 5 * from stores

select year(sale_date),month(sale_date),sum(quantity) from sales s join stores st on s.store_id=st.store_id
where year(sale_date) in (2023,2022,2021) 
group by year(sale_date),month(sale_date)
having sum(quantity)>5000


--Que 4 Determine how many warranty claims were filed for products launched in the last two years.

select top 5 * from stores

select top 5 * from warranty
select top 5 * from products 
select top 5 * from sales

select   repair_status , dateadd(year,2,launch_date) from warranty w join sales s on s.sale_id=w.sale_id join products p on p.product_id=s.product_id
where claim_date between launch_date and dateadd(year,2,launch_date)


---Complex (5 Questions)

--Que 1 Determine the percentage chance of receiving warranty claims after each purchase for each country.

select* from category

select top 5 * from sales
select top 5 * from warranty
select top 5* from stores

--join sales + stores on store_id
--join warranty +sales on sale_id
--select country,repair_status,
--group by country reapir status,count

select country,sum(quantity) total_sold,count(claim_id) total_claim,
cast(count(claim_id)*100.0/sum(quantity) as  decimal(10,2)) percentag
from sales s join stores st on s.store_id=st.store_id
join warranty  w on w.sale_id=s.sale_id
group by country,repair_status 
order by country


--Que 2 Analyze the year-by-year growth ratio for each store.
select* from category
select top 5 * from warranty

with cte as (select store_name, year(sale_date) yearr,sum(quantity) as current_yr_total_sale,
lag(sum(quantity),1) over(partition by store_name order by year(sale_date) ) last_year_sale 
from stores  st join sales s on s.store_id=st.store_id
group by   store_name,year(sale_date))

select *, (current_yr_total_sale-last_year_sale)*100.0/last_year_sale from cte 