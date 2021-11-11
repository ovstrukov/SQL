--вывести список названий всех фильмов и их языков
select
	f.title, 
	l.name
from 
	film f
inner join language l on f.language_id = l.language_id 
limit 100

--вывести список всех актеров, снимавшихся в фильме Lambs Cincinatti film_id=508
select 
	actor.first_name || ' ' || actor.last_name "Фамилия Имя актера в фильме Lambs Cincinatti"
from
	actor
inner join (select
	film_actor.actor_id 
from 
	film_actor
inner join film on film.film_id = film_actor.film_id
where film.film_id = 508) set_actor_id 
on set_actor_id.actor_id = actor.actor_id 

--подсчитайте количество актеров в фильме Grosse Wonderful (id -384)
select 
	count(actor_id) "Количество акторов в фильме Grosse Wonderful"
from 
	film_actor
where film_actor.film_id = 384


--вывести список фильмов, в которых снималось больше 10 актеров
select 
	film.title, count(film_actor.actor_id) "Количество актеров в фильме"
from
	film
inner join film_actor on film.film_id = film_actor.film_id
group by film.title
having count(film_actor.actor_id) > 10

--выведете таблицу с 3-мя полями: название фильма, имя актера и количество фильмов, в которых он снимался
select
	film.title, actor.first_name || ' ' || actor.last_name Actor, count(film.title) over (partition by actor.actor_id) Count_of_films
from film
inner join film_actor on film_actor.film_id = film.film_id
inner join actor on actor.actor_id = film_actor.actor_id
order by film.title 

--ДЗ

-- выведите магазины, имеющие больше 300-от покупателей
select 
	store.store_id, count(customer.customer_id) "Количество покупателей"
from
	store
inner join customer on customer.store_id = store.store_id
group by store.store_id
having count(customer.customer_id) > 300

--выведите у каждого покупателя город, в котором он живет

select
	customer.last_name || ' ' || customer.first_name "Покупатель", city.city "Город"
from customer
inner join address on address.address_id = customer.address_id 
inner join city on address.city_id = city.city_id 

--выведите ФИО сотрудников и города магазинов, имеющих больше 300-от покупателей
select 
	staff.first_name || ' ' || staff.last_name "Сотрудник", set_store_id.store_id "Магазин №", city.city "Город" 
from
	staff
inner join (select 
			store.store_id, store.address_id 
			from
			store
			inner join customer on customer.store_id = store.store_id
			group by store.store_id
			having count(customer.customer_id) > 300) set_store_id
on set_store_id.store_id = staff.store_id 
inner join address on set_store_id.address_id =  address.address_id
inner join city on address.city_id = city.city_id 

select 
	store.address_id 
from 
	store
where store.store_id = set_store_id.store_id

---выведите количество актеров, снимавшихся в фильмах, которые сдаются в аренду за 2,99
select 
	count(film_actor.actor_id) "Количество актёров"
from
	film_actor
inner join film on film.film_id = film_actor.film_id 
where film.rental_rate = 2.99

