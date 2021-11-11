
--При помощи CTE выведите таблицу со следующим содержанием Фвмилия и Имя сотрудника (staff) и количество прокатов двд(retal), которые он продал

with staff_retail as (
select s.staff_id , s.first_name , s.last_name, count(p.staff_id)
from staff s
join rental p on p.staff_id = s.staff_id 
group by s.staff_id 
)
select * from staff_retail

--Создайте view с колонками клиент (ФИО, email) и title фильма, который он брал в прокат последним

create view customer_rental as
select c.first_name , c.last_name, f.title 
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id 

create or replace view customer_rental as 
select c.first_name , c.last_name , f.title, r.rental_date, row_number() over (partition by c.customer_id order by r.rental_date desc )
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
order by r.rental_date  desc 


drop view customer_rental

select * from customer_rental 

--ДЗ
--Домашнее задание по теме “Работа с PostgreSQL”

--База данных: dvd-rental

--Основная часть:

--Сделайте запрос к таблице rental. Используя оконую функцию добавьте колонку с порядковым номером аренды для каждого пользователя (сортировать по rental_date)
--Для каждого пользователя подсчитайте сколько он брал в аренду фильмов со специальным атрибутом Behind the Scenes
-- -напишите этот запрос
-- -создайте материализованное представление с этим запросом
-- -обновите материализованное представление
-- -напишите три варианта условия для поиска Behind the Scenes
--Дополнительная часть:
-- -открыть по ссылке sql запрос [https://letsdocode.ru/sql-hw5.sql], сделать explain analyze запроса
-- -основываясь на описании запроса, найдите узкие места и опишите их
-- -сравните с Вашим запросом из основной части (если Ваш запрос изначально укладывается в 15мс - отлично!)
-- -оптимизируйте запрос, сократив время обработки до максимум 15мс
-- -сделайте построчное описание explain analyze на русском языке оптимизированного запроса. Описание строк в explain можно посмотреть тут - [https://use-the-index-luke.com/sql/explain-plan/postgresql/operations]

select *, row_number() over (partition by customer_id order by rental_date desc )
from rental r 

explain analyze --37ms
select distinct c.first_name || ' ' || c.last_name "Пользователь", count(f.film_id) over (partition by c.customer_id order by c.customer_id desc ) "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
where  'Behind the Scenes' = any(f.special_features)

create materialized view customer_behind as
select distinct c.first_name || ' ' || c.last_name "Пользователь", count(f.film_id) over (partition by c.customer_id order by c.customer_id desc ) "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
where  'Behind the Scenes' = any(f.special_features)
with no data

refresh materialized view customer_behind


select * from customer_behind

explain analyze --36ms
select distinct c.first_name || ' ' || c.last_name "Пользователь", count(f.film_id) over (partition by c.customer_id order by c.customer_id desc ) "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
where  f.special_features @> array['Behind the Scenes']

explain analyze --35ms
select distinct c.first_name || ' ' || c.last_name "Пользователь", count(f.film_id) over (partition by c.customer_id order by c.customer_id desc ) "Количество фильмов"
from customer c 
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
where  array_position(f.special_features, 'Behind the Scenes') is not null

explain analyze --71ms
select distinct cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) over (partition by cu.customer_id)
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
order by count desc
-- больше всего времени тратится на сортировку и join
-- мой запрос быстрее отрабатывает за 35- 37 мс

