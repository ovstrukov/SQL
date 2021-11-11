select * FROM information_schema.table_constraints where constraint_type = 'PRIMARY KEY'

select * from customer where active = '0'

select film_id, title, release_year  from film where release_year = '2006';

select customer_id, amount, payment_date from payment order by payment_date desc limit 10

select column_name, data_type from information_schema.columns where column_name = 'country_id' or column_name = 'city_id'
