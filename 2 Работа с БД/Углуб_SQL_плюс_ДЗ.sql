--�������� 1. �������� ������� "�����" � ������:
--id
--full name
--��������� (����� �� ����)
--���� ��������

create table "�����"( 
id serial primary key,
"full name" varchar(50) unique not null,
"���������" varchar(50) unique,
"���� ��������" timestamp not null
)

--�������� 2. �������� ������ �� 3-� ����� ��������� � ��������� �������
--�������� ���� "����� ��������" � �������
--�������� ������, ��������� ���������� ����� �������� ��������

insert into "�����" ("full name", "���������", "���� ��������")
values
('������ ��������� ���������', '���.', '1799.06.06'),
('������ ������� ����������', '�������', '1868.03.28'),
('���������� �������� ������������', null, '1893.07.19')

alter table "�����" add column "����� ��������" varchar(50)

update "�����" 
set "����� ��������" = '�. ������'
where id = 1

update "�����" 
set "����� ��������" = '�. ������ ��������'
where id = 2

update "�����" 
set "����� ��������" = '�. �������'
where id = 3

select * from "�����"

--�������� 3. �������� ������� "������������" � ������: ���, ��������, ������ �� ������. 
--���������� foreign key contsraint
--�������� � ������� ���� ��������
--���������� ������� ������

create table "������������"( 
"���" year unique not null,
"��������" varchar(50) unique,
"������ �� ������" integer references "�����" (id),
primary key ("������ �� ������")
)

insert into "������������" ("���", "��������", "������ �� ������")
values
('2155', '����������� �����', 1),
('1932', '����� ���������� �����', 3)

select * from "������������"

delete from "�����"
where id = 1

select * from "������������"

delete from "������������"
where "��������" = '����� ���������� �����'

delete from "�����"
where id = 3

select * from "�����"

--�������� 4. �������� ������� orders (������ ���� � ������). �������� ����� ���������� �������

CREATE TABLE orders (ID serial NOT NULL PRIMARY KEY, info json NOT NULL);

INSERT INTO orders (info)VALUES ( '{ "customer": "John Doe", "items": {"product": "Beer","qty": 6}}' ), ( '{ "customer": "Lily Bush", "items": {"product": "Diaper","qty": 24}}' ), ( '{ "customer": "Josh William", "items": {"product": "Toy Car","qty": 1}}' ), ( '{ "customer": "Mary Clark", "items": {"product": "Toy Train","qty": 2}}' );


select sum(cast(info ->'items' ->> 'qty' as integer)) total
from orders 

--�������� 5.�������� ������� ��� ����������� ����������� ������� (special_feature) � ������


select t.title, count(t.count_sf)
from
(select title, unnest(special_features) count_sf
from film) t
group by t.title

--��

--������������� ���� ������ ��� ��������� ���������:
--���� (� ������ ����������, ����������� � ��)
--���������� (� ������ �������, ���������� � ��)
--������ (� ������ ������, �������� � ��)
--������� ���������:
--�� ����� ����� ����� �������� ��������� �����������
--���� ���������� ����� ������� � ��������� �����
--������ ������ ����� �������� �� ���������� �����������
--���� ������� - ��������� ������������� ����������� � �������� � �������������. 
--����� ������� ������ ���������� 5 ������. 
--��� �������-����������� � ��� ������� �� �������. 
--(������ ������� �� ������� - film_actor)
--�������� ������� �������� ������ � ������� �� ���������� � ������ ������� �� 5 ����� � �������




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
('�������'),
('����������'),
('��������'),
('�����������'),
('�������')

insert into nationality_country (nationality_name)
values
('�������'),
('����������'),
('��������'),
('��������'),
('������')

insert into country (country_name)
values
('������'),
('��������'),
('���������'),
('�������'),
('������')

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
