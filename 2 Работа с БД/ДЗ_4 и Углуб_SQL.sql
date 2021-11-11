--Практика 1. Создайте таблицу "автор" с полями:
--id
--full name
--псевдоним (может не быть)
--дата рождения

create table "Автор"( 
id serial primary key,
"full name" varchar(50) unique not null,
"Псевдоним" varchar(50) unique,
"Дата рождения" timestamp not null
)

--Практика 2. Вставьте данные по 3-м любым писателям в указанную таблицу
--Добавьте поле "место рождения" в таблицу
--Обновите данные, проставив корректное место рождения писателю

insert into "Автор" ("full name", "Псевдоним", "Дата рождения")
values
('Пушкин Александр Сергеевич', 'Арз.', '1799.06.06'),
('Пешков Алексей Максимович', 'Горький', '1868.03.28'),
('Маяковский Владимир Владимирович', null, '1893.07.19')

alter table "Автор" add column "Место рождения" varchar(50)

update "Автор" 
set "Место рождения" = 'г. Москва'
where id = 1

update "Автор" 
set "Место рождения" = 'г. Нижний Новгород'
where id = 2

update "Автор" 
set "Место рождения" = 'г. Багдати'
where id = 3

select * from "Автор"

--Практика 3. Создайте таблицу "Произведения" с полями: год, название, ссылка на автора. 
--Установите foreign key contsraint
--Вставьте в таблицу пару значений
--Попробуйте удалить автора

create table "Произведения"( 
"Год" year unique not null,
"Название" varchar(50) unique,
"Ссылка на автора" integer references "Автор" (id),
primary key ("Ссылка на автора")
)

insert into "Произведения" ("Год", "Название", "Ссылка на автора")
values
('2155', 'Капитанская дочка', 1),
('1932', 'Когда закалялась сталь', 3)

select * from "Произведения"

delete from "Автор"
where id = 1

select * from "Произведения"

delete from "Произведения"
where "Название" = 'Когда закалялась сталь'

delete from "Автор"
where id = 3

select * from "Автор"

--Практика 4. Создайте таблицу orders (скрипт выше в лекции). Выведите общее количество заказов

CREATE TABLE orders (ID serial NOT NULL PRIMARY KEY, info json NOT NULL);

INSERT INTO orders (info)VALUES ( '{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}' ), ( '{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}' ), ( '{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}' ), ( '{ "customer": "Mary Clark", "items": {"product": "Toy Train","qty": 2}}' );


select sum(cast(info ->'items' ->> 'qty' as integer)) total
from orders 

--Практика 5.Выведите сколько раз встречается специальный атрибут (special_feature) у фильма


select t.title, count(t.count_sf)
from
(select title, unnest(special_features) count_sf
from film) t
group by t.title

--ДЗ

--Спроектируйте базу данных для следующих сущностей:
--Язык (в смысле английский, французский и тп)
--Народность (в смысле славяне, англосаксы и тп)
--Страны (в смысле Россия, Германия и тп)
--Правила следующие:
--На одном языке может говорить несколько народностей
--Одна народность может входить в несколько стран
--Каждая страна может состоять из нескольких народностей
--Суть задания - научиться проектировать архитектуру и работать с ограничениями. 
--Таким образом должно получиться 5 таблиц. 
--Три таблицы-справочника и две таблицы со связями. 
--(Пример таблицы со связями - film_actor)
--Пришлите скрипты создания таблиц и скрипты по добавлению в каждую таблицу по 5 строк с данными




create table "language" (
lang_id serial primary key,
language_name varchar(50) unique not null
);

create table nationality (
nat_id serial primary key,
nationality_name varchar(50) unique not null
);

create table country (
count_id serial primary key,
country_name varchar(50) unique not null
);

create table language_nationality (
lang_id integer references "language" (lang_id),
nat_id integer references nationality (nat_id),
primary key (lang_id, nat_id)
);

create table nationality_country (
nat_id integer references nationality (nat_id),
count_id integer references country (count_id), 
primary key (nat_id, count_id)
);

insert into "language" (language_name)
values
('русский'),
('английский'),
('немецкий'),
('французский'),
('финский')

insert into nationality_country (nationality_name)
values
('славяне'),
('англосаксы'),
('финоугры'),
('французы'),
('казахи')

insert into country (country_name)
values
('Россия'),
('Германия'),
('Финляндия'),
('Франция'),
('Англия')

select * from language_nationality

insert into language_nationality (lang_id, nat_id)
values
(1, 1),
(2, 2),
(3, 2),
(4, 4),
(5, 3)

insert into nationality_country (nat_id, count_id)
values
(1, 1),
(2, 2),
(2, 5),
(5, 1),
(4, 4)
