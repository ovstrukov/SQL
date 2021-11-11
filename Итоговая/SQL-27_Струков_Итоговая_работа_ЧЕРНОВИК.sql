
--Это занятые места
select  f.flight_id, f.flight_no , bp.seat_no, f.scheduled_departure
from boarding_passes bp
	left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
	left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
group by f.flight_no , bp.seat_no, f.scheduled_departure,  f.flight_id, f.flight_no 
order by f.flight_id

--это количество занятых мест для каждого рейса
select  f.flight_id, f.flight_no , count(bp.seat_no), f.actual_departure , f.departure_airport 
from boarding_passes bp
	left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
	left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
group by f.flight_id 
order by f.flight_id

-- это общее количество мест в самолете для каждого перелета
select  f.flight_id, f.flight_no , count(s2.seat_no), f.actual_departure , f.departure_airport 
from seats s2 
	join aircrafts a on s2.aircraft_code = a.aircraft_code
	join flights f on a.aircraft_code = f.aircraft_code 
group by f.flight_id 
order by f.flight_id




--left join aircrafts a on a.aircraft_code = f.aircraft_code
--left join seats s on s.aircraft_code = a.aircraft_code
--------------------------------------------


--получение свободных мест
select *
from  seats s2 
full join (select  f.flight_id, f.flight_no , bp.seat_no, f.scheduled_departure
from boarding_passes bp
left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
group by f.flight_no , bp.seat_no, f.scheduled_departure,  f.flight_id, f.flight_no 
order by f.flight_id) reserved on reserved.seat_no = s2.seat_no
where reserved.seat_no is null


--получение свободных мест 2
select f.flight_id , f.flight_no , s.seat_no 
from  (select  f.flight_id, f.flight_no , bp.seat_no, f.scheduled_departure, f.aircraft_code 
		from boarding_passes bp
		left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
		left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
		group by f.flight_no , bp.seat_no, f.scheduled_departure,  f.flight_id, f.flight_no 
		order by f.flight_id) reserved
full join flights f on reserved.aircraft_code = f.aircraft_code 
--full join aircrafts a on reserved.aircraft_code = a.aircraft_code
full join seats s on s.aircraft_code = reserved.aircraft_code
where reserved.seat_no is null



select f.flight_no , s.seat_no --, count (s.seat_no) over (partition by f.flight_no)
from seats s 
join aircrafts a on a.aircraft_code = s.aircraft_code 
join flights f on f.aircraft_code = a.aircraft_code 
join ticket_flights tf on tf.flight_id = f.flight_id 
full join boarding_passes bp on bp.flight_id = tf.flight_id
where bp.seat_no is null
group by f.flight_no, s.seat_no



select f.flight_no , f.scheduled_departure , s.seat_no --, count (s.seat_no) over (partition by f.flight_no)
from seats s 
join aircrafts a on a.aircraft_code = s.aircraft_code 
join flights f on f.aircraft_code = a.aircraft_code 
join ticket_flights tf on tf.flight_id = f.flight_id 
where  tf.flight_id in (select distinct tf.flight_id 
from boarding_passes bp
full join ticket_flights tf on bp.flight_id = tf.flight_id
where bp.seat_no is null)



-- 6) Найдите процентное соотношение перелетов по типам самолетов от общего количества.



 --arccos {sin(a.latitude_a)·sin(a.latitude_b) + cos(latitude_a)·cos(latitude_b)·cos(longitude_a - longitude_b)}
-- select a.airport_name 
--from airports a

--select a.latitude, a.longitude, a.airport_name 
--from airports a
--join flights f on f.departure_airport = a.airport_code or f.arrival_airport = a.airport_code


---------------------------------------------7-----

	select *
		from ticket_flights tf 
			
		--это наброски
			select ap.city 
		from airports ap
		join flights f on f.arrival_airport = ap.airport_code
		join ticket_flights tf on tf.flight_id = f.flight_id 
		where tf.fare_conditions = "Business" tf.amount < tf.amount 
		
		select tf.flight_id , tf.amount
				from ticket_flights tf
				where tf.fare_conditions = 'Economy'
				
				
				--это сколько перелетов бизнесом в рамках одного билета
		select tf.ticket_no , count(tf.flight_id)
				from ticket_flights tf
				where tf.fare_conditions = 'Business'
				group by tf.ticket_no
				order by count(tf.flight_id) desc

				--это сколько стоит перелет бизнесом в рамках одного билета
				select tf.ticket_no , sum(tf.amount) 
				from ticket_flights tf
				where tf.fare_conditions = 'Business'
				group by tf.ticket_no
				
				
				-- это бизнес дешевле эконома в разрезе билета
				select * 
		from tickets t 
		join (	select tf.ticket_no , sum(tf.amount) 
				from ticket_flights tf
				where tf.fare_conditions = 'Business'
				group by tf.ticket_no ) b on t.ticket_no = b.ticket_no
		join (	select tf.ticket_no , sum(tf.amount) 
				from ticket_flights tf
				where tf.fare_conditions = 'Economy'
				group by tf.ticket_no) e on t.ticket_no = e.ticket_no
		where b.sum < e.sum
		order by t.ticket_no 

-----------------------------------------------8-------------------------


select *
		from routes r 
		
		--в подзапросе выборка, где в одном билете больше одного перелета
		--далее формируем cte на основе этого подзапроса
		--далее делаем декартово произведение с представлением routes и исключаем прямые перелеты
		
		with cte as (
		select f.departure_airport 
		from flights f 
		join ticket_flights tf on f.flight_id = tf.flight_id 
		join (
		select tf.ticket_no , count(tf.flight_id)
				from ticket_flights tf
				group by tf.ticket_no
				having count(tf.flight_id) > 1
				order by count(tf.flight_id) desc) tn on tf.ticket_no = tn.ticket_no 
		)
		select cte.departure_airport, cte.arrival_airport
		from cte, (select r.departure_airport , r.arrival_airport from routes r) ro
		except select r.departure_airport, r.arrival_airport
		from routes r 
		
		
		-------
		select fo.departure_airport , fo.arrival_airport
		from (select f.departure_airport , f.arrival_airport 
		from flights f) fo, (select r.departure_airport , r.arrival_airport 
		from routes r) ro
		except select r.departure_airport, r.arrival_airport
		from routes r 
		
		create view  as
		
		create view  a1 as (
		select a2.airport_code  departure_airport
		from airports a2)
		
		select * 
		from a1
		
		drop view a1
		
		create or replace view  a2 as (
		select a2.airport_code arrival_airport
		from airports a2)
		
		
		-----------------------9------------------
				with cte as (	
		select *
		from (select f.flight_no ,f.departure_airport, a.latitude as latitude_a, a.longitude as longitude_a
				from flights f
				join airports a on f.departure_airport = a.airport_code) r1
		join (
				select f.flight_no , f.arrival_airport , a.latitude as latitude_b, a.longitude as longitude_b
		from flights f
		join airports a on f.arrival_airport = a.airport_code ) r2 on r2.flight_no = r1.flight_no
		)
		select 6371 * acosd(sind(latitude_a)*sind(latitude_b) + cosd(latitude_a)*cosd(latitude_b)*cosd(longitude_a - longitude_b)), cte.latitude_a
		from cte