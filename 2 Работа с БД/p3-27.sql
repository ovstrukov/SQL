create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five')

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight')

select * from table_one

select * from table_two

--left, right, inner, full outer, cross

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select count(customer_id)
from customer

select count(customer_id)
from customer c
left join address a on a.address_id = c.address_id

select count(customer_id)
from customer c
join address a on a.address_id = c.address_id

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select ...
from table_1
right join (
	select ...
	from table_2
	right join (
		select ...
		from table_3
		where ...
	)
	where ...
) on ....

select 
from (
	select 
	from 
)
right join 

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null 

select t1.name_one, t2.name_two
from table_one t1
cross join table_two t2 

select t1.name_one, t2.name_two
from table_one t1, table_two t2

select t1.name_one, t2.name_two
from table_one t1, table_two t2, table_3 t3
where t1.name_one = t2.name_two

delete from table_one;
delete from table_two;

insert into table_one (name_one)
select unnest(array[1,1,2])

insert into table_two (name_two)
select unnest(array[1,1,3])

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two

1�	1�
1�	1�
2	3

1�-1�, 1�-1�, 1�-1�, 1�-1�

cross join -> inner join -> left/right join

-- ��������� ��� 5 ���������� �����.

1� - 1�
1� - 1�

����� 1 - ����� 1

����� 1 - ����� 1
����� 1 - ����� 2

����� 1 - ������� 1
����� 1 - ������� 2

����� 1 - ������� 1
����� 2 - ������� 2

select 1::text as x, 1 as y
union 
select 1::text as a, 1 as b

select 1 as x, 1 as y
union all
select 1 as a, 1 as b

select 1 as x, 1 as y
except 
select 1 as a, 1 as b

select 1 as x, 1 as y
union all
select 2 as a, 3 as b
union all
select 1 as a, 1 as b
union all
select 1 as a, 1 as b
union all
select 1 as a, 1 as b
union all
select 1 as a, 1 as b
except 
select 1 as a, 1 as b

select t1.a, t1.b
from (select 1 as a, 1 as b) t1
inner join (select 1 as a, 1 as b) t2 on t1.a = t2.a and t1.b = t2.b

select coalesce(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null 

select coalesce(null, null, 0)

select concat(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null 

select 
	case
		when t.name_one is not null then t.name_one
		when t.name_two is not null then t.name_two
		else '���-�� ����� �� ���'
	end
from (
	select *
	from table_one t1
	full join table_two t2 on t1.name_one = t2.name_two
	where t1.name_one is null or t2.name_two is null 
	union all
	select null, null) t

============= ���������� =============

1. �������� ������ �������� ���� ������� � �� ������ (������� language)
* ����������� ������� film
* ��������� � language
* �������� ���������� � �������:
title, language."name"

select f.title, l."name"
from film f
join "language" l on l.language_id = f.language_id

1.1 �������� ��� ������ � �� ���������:
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* �������� ���������� � �������:
title, category."name"
--using

select f.title, c."name"
from film f
left join film_category fc using(film_id)
left join category c using(category_id)

select f.title, c."name"
from category c
join film_category fc using(category_id)
join film f using(film_id)

2. �������� ������ ���� �������, ����������� � ������ Lambs Cincinatti (film_id = 508). 
* ����������� ������� film
* ��������� � film_actor
* ��������� � actor
* ������������, ��������� where � "title like" (��� ��������) ��� "film_id =" (��� id)

select f.title, a.last_name
from actor a
left join film_actor fa on fa.actor_id = a.actor_id
left join film f on f.film_id = fa.film_id
where f.film_id = 508

2.1 �������� ��� �������� �� ������ Woodridge (city_id = 576)
* ����������� ������� store
* ��������� ������� � address 
* ��������� ������� � city 
* ��������� ������� � country 
* ������������ , ��������� where � "city like" (��� �������� ������) ��� "city_id ="  (��� id)
* �������� ������ ����� ������� ��������� � �� id:
store_id, postal_code, country, city, district, address, address2, phone

select store_id, postal_code, country, city, district, address, address2, phone, address_id, city_id
from store s
join address a using(address_id)
join city c using(city_id)
join country c2 using(country_id)
where c.city_id = 576

select store_id, postal_code, country, city, district, address, address2, phone, a.address_id, c.city_id
from store s
left join address a on s.address_id = a.address_id
left join city c on c.city_id = a.city_id and c.city_id = 576
left join country c2 on c2.country_id = c.country_id
where c.city_id is not null

select store_id, postal_code, country, city, district, address, address2, phone, a.address_id, c.city_id
from store s
join address a on s.address_id = a.address_id
right join city c on c.city_id = a.city_id and c.city_id = 576
left join country c2 on c2.country_id = c.country_id
where s.store_id is not null

============= ���������� ������� =============

3. ����������� ���������� ������� � ������ Grosse Wonderful (id - 384)
* ����������� ������� film
* ��������� � film_actor
* ������������, ��������� where � "title like" (��� ��������) ��� "film_id =" (��� id) 
* ��� �������� ����������� ������� count, ����������� actor_id � �������� ��������� ������ �������
--��, ������� ���������� 

select count(fa.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
where f.film_id = 384

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.film_id -- ������

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.title, f.description, f.release_year -- �����

select count(fa.actor_id), f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.release_year, f.rating -- ������, ��� ��� �����

select 1

FROM
ON
JOIN
WHERE
GROUP by --�����, �� �� � ������ ���� ��� �����������
WITH CUBE ��� WITH ROLLUP
HAVING
select --������ 
DISTINCT
ORDER by

select f.title as "�������� ������", count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by 1, 3, 4 
order by 2


3.1 ���������� ������� ��������� ������ �� ���� �� ���� �������
* ����������� ������� film
* ��������� ������ �� ���� rental_rate/rental_duration
* avg - �������, ����������� ������� ��������
--4 ���������

select avg(rental_rate/rental_duration),
	max(rental_rate/rental_duration),
	min(rental_rate/rental_duration),
	sum(rental_rate/rental_duration)
from film 

select customer_id, avg(amount)
from payment p
group by customer_id

============= ����������� =============

4. �������� ������ �������, � ������� ��������� ������ 10 �������

* ����������� ������� film
* ��������� � film_actor
* ������������ �������� ������� �� film_id
* ��� ������ ������ ���������� ����������� �������
* �������������� ����������� �����, ��� ������ ������� � ������������ > 10
--having, numeric, alias

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
where f.release_year = 2006
group by f.film_id 
having count(fa.actor_id) > 10

select f.title, count(fa.actor_id), f.description, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
group by f.film_id 
having count(fa.actor_id) > 10 and f.release_year = 2006


4.1 �������� ������ ��������� �������, ������� ����������������� ������ ������� ����� 5 ����
* ����������� ������� film
* ��������� � �������� film_category
* ��������� � �������� category
* ������������ ���������� ������� �� category.name
* ��� ������ ������ ���������� ������ ����������������� ������ �������
* �������������� ����������� �����, ��� ������ ��������� �� ������� ������������������ > 5 ����

select c."name"
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
group by c.category_id
having avg(rental_duration) > 5

select c.customer_id, p.staff_id, sum(amount)
from payment p
join customer c on p.customer_id = c.customer_id
where c.customer_id < 5
group by grouping sets (c.customer_id, p.staff_id)

select c.customer_id, p.staff_id, extract(month from p.payment_date), sum(amount)
from payment p
join customer c on p.customer_id = c.customer_id
where c.customer_id < 5
group by cube (c.customer_id, p.staff_id, extract(month from p.payment_date))
order by 1, 2, 3

select c.customer_id, p.staff_id, extract(month from p.payment_date), sum(amount)
from payment p
join customer c on p.customer_id = c.customer_id
where c.customer_id < 5
group by rollup (c.customer_id, p.staff_id, extract(month from p.payment_date))
order by 1, 2, 3

select * from payment p

============= ���������� =============

5. �������� ���������� �������, �� ���������� ������ �� ���� ������, ��� ������� �������� �� ���� �������
* �������� ���������, ������� ����� ��������� ������� �������� ��������� ������ �� ���� (������� 3.1)
* ����������� ������� film
* ������������ ������ � �������������� �������, ��������� �������� > (���������)
* count - ���������� ������� �������� ��������

select avg(rental_rate/rental_duration) from film 

select title, rental_rate/rental_duration
from film 
where rental_rate/rental_duration > (select avg(rental_rate/rental_duration) from film)

select title, rental_rate/rental_duration
from film 
where rental_rate/rental_duration = (select max(rental_rate/rental_duration) from film)

select title, rental_rate/rental_duration
from film 
where film_id in (select 1, 2, 3, 4, 5)

select title, rental_rate/rental_duration, (select count(customer_id) from customer)
from film 
where rental_rate/rental_duration > (select avg(rental_rate/rental_duration) from film)

6. �������� ������, � ���������� ������������ � ����� "C"
* �������� ���������:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ��������� � �������� film_category
* ��������� � �������� film
* �������� ���������� � �������:
title, category."name"
--position and time

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
join film_category fc on fc.category_id = t.category_id
join film f on f.film_id = fc.film_id --175 / 53.29 / 0.47

explain analyse
select f.title, t.name
from film f
join film_category fc on fc.film_id = f.film_id
join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.47

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id and 
	fc.category_id in (select category_id
	from category 
	where "name" like 'C%')
join category c on c.category_id = fc.category_id --175 / 47.11 / 0.45

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (
	select category_id
	from category 
	where "name" like 'C%') --175 / 46.96 / 0.43

explain analyze
select f.title, t.name
from film f
right join film_category fc on fc.film_id = f.film_id
right join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.29 / 0.43

explain analyze
select category_id, "name"
from category 
where "name" like 'C%'
	
6.1. �������� ������, � ���������� ������������ � ����� "C", �� ����������� ������ ���������� � ������� ����������
* ����������� ������� film
* ��������� � �������� film_category
* �������� ���������:
 - ����������� ������� category
 - ������������ ������ � ������� ��������� like 
* ����������� ��������� ������ ���������� � ���������� � ������� ��������� in

C:\Users\���_������������\AppData\Roaming\DBeaverData\workspace6\General\Scripts

-- ������ 2 ��� kcu

����� ��������� ������ �� ������� ��������������� �������, ������, ��� ������� ���������� ��������������:

select tc.table_name, kcu.column_name, tc.constraint_name, c.data_type
from information_schema.table_constraints tc
left join information_schema.key_column_usage kcu on kcu.constraint_name = tc.constraint_name 
	and tc.table_name = kcu.table_name 
	and tc.constraint_schema = kcu.constraint_schema
left join information_schema.columns c on c.column_name = kcu.column_name 
	and kcu.table_name = c.table_name 
	and kcu.constraint_schema = c.table_schema
where tc.constraint_schema = 'dvd-rental' and tc.constraint_type = 'PRIMARY KEY'
