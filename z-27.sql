https://postgrespro.ru/docs/postgresql/13/ddl-inherit

https://postgrespro.ru/docs/postgresql/13/ddl-partitioning

create table products(
	product_id serial primary key,
	product_name varchar(50) not null unique,
	product_amount decimal(10, 2) not null,
	product_color varchar(30) not null,
	product_count integer not null
)

insert into products_temp (product_name, product_amount, product_color, product_count)
values 
	('������', 500, '���������', 100),
	('����', 1000, '�������', 250),
	('������', 320, '���������', 37),
	('���������', 705, '�������������', 80),
	('�����', 80, '��������', 90),
	('����', 50, '��������', 588),
	('�������', 70, '�����������', 255)
	
	select * from products -- ������� ��� ���� � �� ��������, � �� �����
	SELECT * FROM products_temp  -- ������� ���� ������ �� �������� ������� products_temp
	SELECT * FROM ONLY products -- ������� ���� ������ �� ��������
	
create index on products(product_name)

-- ������������ ������������
table_1
a | b | c | d |

table_2
a_1 | e | f | n	

-- �������������� ������������
table_1 -- a-g
a | b | c | d | n

table_2 -- h-m
a | b | c | d | n

table_3 -- m-z
a | b | c | d | n
	
alter table table_1 add check (a[1] in ['a-g']);
alter table table_2 add check (a[1] in ['h-m']);
alter table table_3 add check (a[1] in ['m-z']);
	
create or replace function table_insert_foo(i_product_id int, product_name varchar, 
	product_amount decimal, product_color varchar, product_count int) returns integer as $$
	if new.a[1] in ['a-g'] then insert into table_1
	if new.a[1] in ['h-m'] then insert into table_2
	insert into flowers.products (product_id, product_name, product_amount, product_color, product_count) values ($1,$2,$3,$4,$5);
    select 1;
$$ language 'sql';	
alter function flowers.insert_products(int, varchar, decimal, varchar, int) owner to postgres;

create trigger table_insert
before insert on table_1
for each row execute function table_insert_foo();


	-- ������� ������ ������� ��� products, ����������� ��� �����������, ����� ������� ������
create table products_temp (like products including all);

alter table products_temp inherit products
----------------------------------------------------------------------------------------------------


create function p (x int, y int, out z numeric) as $$
	begin
		select power(x, y) into z;
	end;
$$ language plpgsql

select p(2, 3)

create function f (date_start date, date_end date) returns numeric as $$
	declare z numeric;
	begin
		if date_start is null or date_end is null
			then raise exception '����������� ���� ������ ��� ���������';
		elseif date_end < date_start
			then raise exception '���� ��������� �� ����� ���� ������ ���� ������';
		else
			select sum(amount)
			from payment 
			where date(payment_date) between date_start and date_end
			into z;
		end if;
	return z;
	end;
$$ language plpgsql

select p(2, 3)

select f('2007-02-16', '2007-02-19')

select * from payment p

--������� ��� ������
������������� | �������� | ����_�������� | ������������ | ������ | ������� � ������� ��������� ��������.

create function process_table_audit() returns trigger as $$
    begin 
   		if (TG_OP = 'DELETE') then 
       		insert into emp_audit select 'D', now(), user, old.*, TG_TABLE_NAME;
       	elsif (TG_OP = 'UPDATE') then 
           	insert into emp_audit select 'U', now(), user, new.*, TG_TABLE_NAME;
       	elsif (TG_OP = 'INSERT') then 
           	insert into emp_audit select 'I', now(), user, new.*, TG_TABLE_NAME;
       	end if;
       	return null; -- ������������ �������� ��� �������� AFTER ������������
    end;
$$ language plpgsql;

create trigger table_audit
after insert or update or delete on some_table
for each row execute function process_table_audit();

-- ��� 10 ������ � ���� execute procedure
-- ��� 11 ������ � ���� execute procedure ��� execute function

