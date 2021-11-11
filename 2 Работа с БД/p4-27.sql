create database ��������_����_������

create schema lecture_4_�������

set search_path to lecture_4

======================== �������� ������ ========================
1. �������� ������� "�����" � ������:
- id 
- ���
- ��������� (����� �� ����)
- ���� ��������
* ����������� 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* ��� id �������� serial, ����������� primary key
* ��� � ���� �������� - not null
* ��������� - ����������� ���

create table author (
	id serial primary key, --author_id 
	author_name varchar(50) not null,
	nick_name varchar(50),
	born_date date not null,
	create_date timestamp default now(),
	deleted int2 default 0
)

primary key = not null + unique + index

select * from author a

1*  �������� ������� "������������" � ������: id ������������, ���, ��������, id ������
* ��� id ������������ �������� serial, ����������� primary key
* �������� - not null
* ��� > 0 CHECK (��� > 0)
* id ������ ���� �������� ��� �����������

create table books (
	id serial primary key,
	book_name varchar(150) not null,
	book_year int2 not null check(book_year >= 1800 and book_year <= 2100),
	author_id int2 references author(id),
	create_date timestamp default now(),
	deleted int2 default 0
	--book_cost decimal(10,2) decimal = numeric
	-- add constraint books_author_fkey foreign key (author_id) references author(id)
	-- primary key(col_1, col_2, ...)
)

inn varchar(12) not null check(length(inn) = 12)
inn int not null check(length(inn::text) = 12)

select * from books b

======================== ���������� ������� ========================

2. �������� ������ �� 3-� ����� ��������� � ������� �������:
���� �������� ����, 08.02.1828
������ ������� ���������, ��. ���������, 03.10.1814
������ ��������, 12.01.1949
* ����� ��������� ��������� ����� ������������:
    INSERT INTO table (column1, column2, �)
    VALUES
     (value1, value2, �),
     (value1, value2, �) ,...;

insert into author (author_name, nick_name, born_date)
values ('���� �������� ����', null, '08.02.1828'),
	('������ ������� ���������', '��. ���������', '03.10.1814'),
	('������ ��������', null, '12.01.1949')
	
select * from author a
	
2. �������� ������ �� 5-� ����� �������������, id ������ - ��������� NULL:
�������� ����� ��� ��� �����, 1916
��������, 1837
����� ������ �������, 1840
���������� ���, 1980
������� �������� �����, 1994

insert into books (book_name, book_year)
select unnest(array['�������� ����� ��� ��� �����', '��������', '����� ������ �������', '���������� ���', '������� �������� �����']),
	unnest(array[1916, 1837, 1840, 1980, 1994])

select * from books b

insert into books (book_name, book_year)
select f.title, f.release_year::int2 from "dvd-rental".film f

delete from books

insert into books (book_name, book_year)
values ('�����-�� ����� 2', 1982)

insert into books (id, book_name, book_year)
values ( 1, '�����-�� ����� 2', 1982)

smallserial 1 .. 32767
serial - 1 .. 2 147 483 647
bigserial 1 .. 9 223 372 036 854 775 807

books_id_seq

alter sequence books_id_seq restart with 5000;

======================== ����������� ������� ========================

3. �������� ���� "����� ��������" � ������� � ��������
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;
 
select * from author a

-- alter table author add column born_place varchar(50) default '' not null

alter table author add column born_place varchar(50)

alter table author drop column born_place 

alter table author alter column author_name drop not null

alter table author alter column author_name set not null

alter table author add constraint author_name_unique unique (author_name)

alter table author drop constraint author_name_unique 

alter table author alter column author_name type text using author_name::text

select null = null 

select pg_typeof(author_name) from author a
 
 3* � ������� ������������ �������� ������� id ������ - ������� ���� - ������ �� �������
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table books add constraint books_author_fkey foreign key (author_id) references author(id)

alter table books drop constraint books_author_fkey 

select * from author a

select * from books b

select null = null -- x = y

select (1 > 2)::text;
select (1 = 1)::text;
select (null = null)::text;

 ======================== ����������� ������ ========================

4. �������� ������, ��������� ���������� ����� ��������
��������:
���� �������� ���� - �������
������ ������� ��������� - ���������� �������
������ �������� - ������
* UPDATE table
  SET column1 = value1,
   column2 = value2 ,...
  WHERE
   condition;
  
select * from author a
  
update author
set born_place = '�������'
where id = 1

update author
set born_place = '���������� �������'
where id = 2

update author
set born_place = '������'
where id = 3

update author
set born_place = '������'

update author
set born_place = '������'
where id = 3 or id = 1

4*. � ������� ������������ ���������� id �������:

���� �������� ����: 
    �������� ����� ��� ��� �����
������ ������� ���������: 
    ��������
    ����� ������ �������
������ ��������:
    ���������� ���
    ������� �������� �����

select * from author a

select * from books
    
update books
set author_id = 1
where id = 5000

update books
set author_id = 2
where id in (5001, 5002)

update books
set author_id = (select id from author where author_name = '������ ��������')
where id in (5003, 5004)


 ======================== �������� ������ ========================
 
5. ������� ������������ " �������� ����� ��� ��� �����"

update books
set deleted = 1 
where id = 5000

select * 
from books

where deleted = 0

delete from books 
where id = 5000

5.1 ������� ������ 

delete from author 
where id = 1

delete from author 
where id = 2

delete from books 

delete from author 

select * from author

drop table author cascade

drop table books cascade

drop schema lecture_4

drop database ��������_����

 ======================================================= ������� ���� ������ =======================================================
 
 ======================== json ========================
 �������� ������� orders
 
CREATE TABLE orders (
     ID serial PRIMARY KEY,
     info json NOT NULL
);

INSERT INTO orders (info)
VALUES
 (
'{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}'
 ),
 (
'{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}'
 ),
 (
'{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}'
 ),
 (
'{ "customer": "Mary /"ttt Clark", "items": {"product": "Toy Train","qty": 2}}'
 );
 
select * from orders

INSERT INTO orders (info)
VALUES
 (
'{ "a": { "a": { "a": { "a": { "a": { "c": "b"}}}}}}'
 )
 
|{��������_������: quantity, product_id: quantity, product_id: quantity}|����� ����� ������|


6. �������� ����� ���������� �������:
* CAST ( data AS type) �������������� �����
* SUM - ���������� ������� �����
* -> ���������� JSON
*->> ���������� �����

select *
from orders o

select pg_typeof(info)
from orders o

select info->'customer'
from orders o

select pg_typeof(info->'customer')
from orders o

select info->>'customer'
from orders o

select pg_typeof(info->>'customer')
from orders o

select count(info->'items')
from orders o

select sum((info->'items'->>'qty')::int)
from orders o

6*  �������� ������� ���������� �������, ��������� ������������ �� "Toy"

select avg((info->'items'->>'qty')::int)
from orders o
where info->'items'->>'product' ilike 'toy%'

--�������� ��� ����� �� json
select json_object_keys(info) 
from orders

======================== array ========================
7. �������� ������� ��� ����������� ����������� ������� (special_features) �
������ -- ������� ��������� �������� ������� special_features
* array_length(anyarray, int) - ���������� ����� ��������� ����������� �������

--wish_list 1, 14, 55, 60

select array_length(array[1, 14, 55, 60], 1)

select pg_typeof(f.special_features)
from film f

text[] --������ �������� ������
int[] --������ �������� �����

select f.title, array_length(f.special_features, 1)
from film f

select array_length('{{1,2,3,4,5},{1,2,3,4,5},{1,2,3,4,5}}'::text[], 2)

7* �������� ��� ������ ���������� ����������� ��������: 'Trailers','Commentaries'
* ����������� ���������:
@> - ��������
<@ - ���������� �
*  ARRAY[��������] - ��� �������� �������

https://postgrespro.ru/docs/postgresql/12/functions-subquery
https://postgrespro.ru/docs/postgrespro/12/functions-array

-- ������ �������� --
explain analyze --79
select f.title, f.special_features
from film f
where f.special_features::text ilike '%Trailers%' or f.special_features::text ilike '%Commentaries%'

explain analyze --84
select f.title, f.special_features
from film f
where f.special_features[1] = 'Trailers' or f.special_features[1] = 'Commentaries' or
	f.special_features[2] = 'Trailers' or f.special_features[2] = 'Commentaries' or
	f.special_features[3] = 'Trailers' or f.special_features[3] = 'Commentaries' or
	f.special_features[4] = 'Trailers' or f.special_features[4] = 'Commentaries'

-- ���-�� ������� �������� --
explain analyze --2143
select title, string_agg(special_features, ', ')
from (select film_id, title, unnest(special_features) as special_features from film) t
where special_features = 'Trailers' or special_features = 'Commentaries'
group by film_id, title

-- ������� �������� --
explain analyze --69
select f.title, f.special_features
from film f
where array_position(f.special_features, 'Trailers') is not null or
	array_position(f.special_features, 'Commentaries') is not null

array_position - ������ ������ ������� ���������
array_positions - ������ ������ � ��������� ���� ���������

explain analyze --89
select f.title, f.special_features
from film f
where 'Trailers' = any(f.special_features) or 'Commentaries' = any(f.special_features)

select f.title, f.special_features
from film f
where 'Trailers' = all(f.special_features) or 'Commentaries' = all(f.special_features)

any = some

explain analyze --71.50
select f.title, f.special_features
from film f
where special_features @> array['Trailers'] or f.special_features @> array['Commentaries'] or 
	special_features @> array['Trailers', 'Commentaries']

explain analyze --89
select f.title, f.special_features
from film f
where special_features <@ array['Trailers'] or f.special_features <@ array['Commentaries'] or 
	special_features <@ array['Trailers', 'Commentaries']
	
explain analyze --71.50
select f.title, f.special_features
from film f
where special_features && array['Trailers'] or f.special_features && array['Commentaries'] or 
	special_features && array['Trailers', 'Commentaries']
	
explain analyze --89
select f.title, f.special_features
from film f
where special_features <@ array['Trailers'] or f.special_features <@ array['Commentaries'] or 
	special_features <@ array['Trailers', 'Commentaries']
	
-- �� ��������
select f.title, f.special_features
from film f
where not ('Trailers' = any(f.special_features)) and not ('Commentaries' = any(f.special_features))

select f.title, f.special_features
from film f
where array_position(f.special_features, 'Trailers') is null and
	array_position(f.special_features, 'Commentaries') is null