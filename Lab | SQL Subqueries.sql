Use sakila;
#1 How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.film_id) as "Number of copies" from inventory i
join film as f
on i.film_id = f.film_id
where title = "Hunchback Impossible"
group by f.title;

#2 List all films longer than the average.
select title, length

    Select * from (select account_id, count(*) as number_of_trans from bank.trans
    group by account_id) as t
    where number_of_trans > (select avg(number_of_trans) as avg_trans
    from(select account_id, count(*) as number_of_trans from bank.trans
    group by account_id) as t1)
    order by number_of_trans desc;

#3 Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name, ' ', last_name) as `Actor`
from sakila.actor
where actor_id in (
  -- Grab the actor_ids for actors in Alone Trip
  select actor_id
  from sakila.film_actor
  where film_id = (
    -- Grab the film_id for Alone Trip
    select film_id
    from sakila.film
    where title = 'ALONE TRIP'));
    
#4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title as `Title`
from sakila.film
where film_id in (
  select film_id
    from sakila.film_category
    where category_id in (
      select category_id
      from sakila.category
      where name = 'Family'));
      
#5 Get name and email from customers from Canada using subqueries. Do the same with joins.
	#Subqueries
    
    #Joins
select concat(first_name, ' ', last_name) as "full name", email
from customer as c
join address as a
on c.address_id = a.address_id
join city as city
on city.city_id = a.city_id
join country as country
on country.country_id = c ity.country_id
where country = 'Canada';

#6 Which are films starred by the most prolific actor?
	#first we find out who is the most prolific actor
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1;
	#now we see in which filsm he starred in
select concat(first_name, ' ', last_name) as actor_name, film.title, film.release_year
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join film
using (film_id)
where actor_id = (
  select actor_id
  from sakila.actor
  inner join sakila.film_actor
  using (actor_id)
  inner join sakila.film
  using (film_id)
  group by actor_id
  order by count(film_id) desc
  limit 1)
  order by release_year desc;
  
#7 Films rented by most profitable customer.
-- most profitable customer

select customer_id
from sakila.ustomer
inner join payment using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1;

-- films rented by most profitable customer
select film_id, title, rental_date, amount
from sakila.film
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
where rental.customer_id = (
  select customer_id
  from customer
  inner join payment
  using (customer_id)
  group by customer_id
  order by sum(amount) desc
  limit 1)
order by rental_date desc;

#8 Customers who spent more than the average.
select * from customer;
select avg(amount) as average from payment;
## checking the sum
select customer_id, sum(amount) as abc from payment group by 1;
##checking the avg
select avg(abc) from (select customer_id, sum(amount) as abc from payment group by 1) as xxx;

## final query
select customer_id, sum(amount) as total_spent from payment
group by customer_id 
having sum(amount) > (select avg(abc) from (select customer_id, sum(amount) as abc
from payment group by 1) as xxx);