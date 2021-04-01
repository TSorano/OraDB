select * from(
select user_name, count(*)cnt from(
select * from users_list u 
where user_seq_id in (select from_user_seq_id from comments where grade=1))
group by user_name)
where cnt>5


select emp_name,salary,
first_value(salary) over (
partition by shop_id
order by salary desc
rows between unbounded preceding and unbounded following
) max_salary
from shop_emps
order by emp_name


select * from ( select product_name,count(*)cnt from 
(select * from product_fav join products on products.product_id in(select product_id from product_fav))
 group by product_name)



select decode(grouping(product_id),1,'ALL PRODUCTS',product_id) product_id,
decode(grouping(shop_id),1,'ALL SHOPS', shop_id) shop_id,
sum(price*product_num) sum_price
from products inner join shops using(shop_id)
inner join order_items using(product_id)
group by rollup(shop_id, product_id);


select user_name, count(*)cnt from(
select * from comments c , users_list u 
where c.from_user_seq_id=u.user_seq_id and grade=1)
group by user_name
having count(*)>5


with g as(select t.oi order_id,sum(t.zs) order_total from(
select o.order_id oi,p.price*o.product_num zs from products p,order_items o
where p.product_id=o.product_id)t
group by t.oi
)
select customer_id,trunc(submit_date) submit_date,g.order_total,
max(order_total) over(
partition by customer_id
order by submit_date
rows between unbounded preceding and unbounded following
) max_order
from orders join g using(order_id)
order by customer_id,submit_date



select decode(grouping(product_id),1,'ALL PRODUCTS',product_id) product_id,
decode(grouping(shop_id),1,'ALL SHOPS', shop_id) shop_id,
sum(price*product_num) sum_price
from products inner join shops using(shop_id)
inner join order_items using(product_id)
group by rollup(shop_id, product_id);


select emp_name,salary
from shop_emps e,(
select shop_id,avg(salary) avg_salary
from shop_emps
group by shop_id
)s
where e.shop_id=s.shop_id
and e.salary>s.avg_salary




with avg_salary
as (
select shop_id,avg(salary) avg_salary
from shop_emps
group by shop_id
)
select emp_name,salary
from shop_emps e,avg_salary s
where e.shop_id=s.shop_id
and e.salary>s.avg_salary



with g as(select t.oi order_id,sum(t.zs) order_total from(
select o.order_id oi,p.price*o.product_num zs from products p,order_items o
where p.product_id=o.product_id)t
group by t.oi
)
select orders.customer_id,max(g.order_total) from orders,g
group by customer_id



select * from(
select user_name, count(*)cnt from(
select * from comments c join users_list u 
on c.from_user_seq_id=u.user_seq_id where grade=1)
group by user_name)
where cnt>5
