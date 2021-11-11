-- �������� ������

-- 1) � ����� ������� ������ ������ ���������?

-- ������� ������ ������� �� ������� "���������", ��� "�����" ����������� � ���������� ���������� �� ��� �� ������� "���������".
-- ��������� ���������� �� �������� ������ � ������� ������� ��� ���������� ����� � ������ ����������, � ������� ������ �� ������, ��� ����������  ������ 1
select distinct a.city
from airports a
where a.city IN (select aa.city
 					from airports aa
 					group by aa.city
 					having COUNT(aa.city) > 1
 					) 

 -- 2) � ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?
 
-- � ���������� ������� ������� � ������������ ���������� ��������, ��� Boeing 777-300
-- ������ ��� �����������, ����� ������� ��������, ������ � ���������
-- ������� ���������, ���� ������ Boeing 777-300

select distinct ap.airport_code , ap.airport_name, a.model 
from airports ap
	join flights f on f.departure_airport = ap.airport_code 
	join aircrafts a on a.aircraft_code = f.aircraft_code 
where a."range" = (select max(a."range")
					from aircrafts a)
					
-- 3) ������� 10 ������ � ������������ �������� �������� ������

-- ������� ������ ������ � ��������� ����� �������� ����� � ������������, ��� ��� �������� �� ������, ���������� �� ������� ����� �� ��������� � ������� 10

select f.flight_no , (f.actual_departure - f.scheduled_departure) delay
from flights f
where (f.actual_departure - f.scheduled_departure) is not null
order by delay desc
limit 10

-- 4) ���� �� �����, �� ������� �� ���� �������� ���������� ������?

-- ������ ��� inner join bookings + tickets + ticket_flights � full join � boarding_passes, ����� ����� ���������� ��������, ������� 
-- ���� � (bookings + tickets + ticket_flights) � ��� � boarding_passes. ��� �������� ��������� ��� ������ ������� where bp.ticket_no is null

select b.book_ref , b.book_date --'����� ����, �� ������� �� �������� ���������� ������' "���������"
from bookings b
	join tickets t on t.book_ref = b.book_ref 
--	join ticket_flights tf on tf.ticket_no = t.ticket_no -- ������ �� �������������: 
--������ ��� ����� � ���������� ������, �������� � ��������� ������� ���������� ������.
--������������ ������� ticket_flights � ������ ������� �� �����.
	full join boarding_passes bp on bp.ticket_no = t.ticket_no
where bp.ticket_no is null

-- 5) ������� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
--�������� ������� � ������������� ������ - ��������� ���������� ���������� ���������� ���������� �� ������� ��������� �� ������ ����. 
--�.�. � ���� ������� ������ ���������� ������������� ����� - ������� ������� ��� �������� �� ������� ��������� �� ���� ��� ����� ������ ������ �� ����.

-- ������� ����������� ���������� �� ���� join, ����� ������� ������� ������� ���������� ���������� �� ���� 

select f.actual_departure "�����������", f.flight_id "ID �����", f.flight_no "����� �����", (total.total_seat - reserved.res_seat) "��������� ����", 
		round((total.total_seat - reserved.res_seat) / total.total_seat ::float *100) as "% ��������� ����",
		reserved.res_seat "������� ����",
		sum(reserved.res_seat) over (partition by f.departure_airport , date_trunc('day', f.actual_departure) order by f.actual_departure)	"���-�� ������������ ����������"	
from flights f
--������ join � ����������� reserved, ������� ������� ���������� ������� ���� �� ������
join (select  f.flight_id, f.flight_no , count(bp.seat_no) res_seat, f.actual_departure , f.departure_airport 
			from boarding_passes bp
				left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
				left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
			group by f.flight_id 
			order by f.flight_id
			) as reserved on f.flight_id = reserved.flight_id
--������ join � ����������� total, ������� ������� ����� ���������� ���� �� ������
join (select  f.flight_id, f.flight_no , count(s2.seat_no) total_seat, f.actual_departure , f.departure_airport 
			from seats s2 
				join aircrafts a on s2.aircraft_code = a.aircraft_code
				join flights f on a.aircraft_code = f.aircraft_code 
			group by f.flight_id 
			order by f.flight_id
			) as total on f.flight_id = total.flight_id
 
-- 6) ������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������.


--������  join aircrafts � flights � ������������ �� ������, ��� ����� �������� �������� ���-�� ������ �� ������� ���������, 
--����� ���-�� ��������� �������� ����� ���������;   :: �������� � float, ����� �� ����������� �� ����
		
			select a.model "������ ��", 
					round(count(f.flight_id)/(select count(f.flight_id) from flights f )::float *100) "������� ��������� �� ���� ��"	
			from aircrafts a
				join flights f on f.aircraft_code = a.aircraft_code
			group by a.model
			
-- 7) ���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-������� � ������ ��������?

	--� ����������� �������� ����� � ��������� �������� ��� ������� � �������������� ��� �������,
	--join  � flights  � ������� ���� �� ��������� , ��� b.amount < e.amount
	--�� ������� �� �������
	
		select f.flight_id 
		from flights f
		join (	select tf.flight_id , tf.amount
				from ticket_flights tf
				where tf.fare_conditions = 'Business') b on b.flight_id = f.flight_id
		join (	select tf.flight_id , tf.amount
				from ticket_flights tf
				where tf.fare_conditions = 'Economy') e on e.flight_id = f.flight_id
		where b.amount < e.amount
		
		
		
		
-- 8) ����� ������ �������� ��� ������ ������?

		-- ��������� ������������� a1 ��� ���� ��������� ���������� �����������
		create view  a1 as (
		select a2.airport_code  departure_airport
		from airports a2)
		
		-- ��������� ������������� a2 ��� ���� ��������� ���������� ����������
		create view  a2 as (
		select a2.airport_code arrival_airport
		from airports a2)
		
		--� �������� cte ����������� ��������� ������������ ������������� a1 � a2 (��� �� ��� ���������), 
		--�������� ���������� ����������� ������ �� ������������� routes
		--join � �������� airports, ��� ��������� �������� �������, ������� ����������� ���������� ���������� �������, ����� �������� ��� ������ ������
		
		with cte as (
		select * 
		from a1, a2
		except select r.departure_airport, r.arrival_airport
		from routes r
		order by 1)
		select cte. departure_airport, aaa.city , cte.arrival_airport, aa.city 
		from cte
		join airports aaa on aaa.airport_code = cte.departure_airport
		join airports aa on aa.airport_code = cte.arrival_airport
		
		--����� 20 ������.
--������ ��� ������, � �� ���������. ������ ����� �������� ����������. ��� �� �� ������ ��������, ��� ����� � ����� ������ �.
		
		
-- 9) ��������� ���������� ����� �����������, ���������� ������� �������, �������� � ���������� ������������ ���������� ���������  � ���������, 
-- ������������� ��� ����� *
-- � ��������� ���� ���������� ��������� � �������� airports.longitude � airports.latitude.
--���������� ���������� ����� ����� ������� A � B �� ������ ����������� (���� ������� �� �� �����) ������������ ������������:
--d = arccos {sin(latitude_a)�sin(latitude_b) + cos(latitude_a)�cos(latitude_b)�cos(longitude_a - longitude_b)}, ��� latitude_a � latitude_b � ������, longitude_a, longitude_b � ������� ������ �������, d � ���������� ����� �������� ���������� � �������� ������ ���� �������� ����� ������� ����.
--���������� ����� ��������, ���������� � ����������, ������������ �� �������:
--L = d�R, ��� R = 6371 �� � ������� ������ ������� ����.

--��������� cte, � ������� ������� � ������� �����, �������� ����������� � ���������� � ������������ ����� ���������� �� (������������� routes join airports)
--�� cte ����� ���������� ��� ������� ���������� � ������ join � flights � aircrafts ��� ��������� ������ �� ������� � ���������� �������� �� ������.
		
		with cte as (	
		select r1.flight_no, r1.departure_city, r1.latitude_a, r1.longitude_a, r2.arrival_city, r2.latitude_b, r2.longitude_b
		from (select f.flight_no ,f.departure_airport,f.departure_city ,a.latitude as latitude_a, a.longitude as longitude_a
				from routes f
				join airports a on f.departure_airport = a.airport_code) r1
		join (
				select f.flight_no , f.arrival_airport , f.arrival_city ,a.latitude as latitude_b, a.longitude as longitude_b
		from routes f
		join airports a on f.arrival_airport = a.airport_code ) r2 on r2.flight_no = r1.flight_no
		)
		select distinct cte.flight_no, ac.model , ac."range" "��������� �������", round(6371 * acos(sind(latitude_a)*sind(latitude_b) + cosd(latitude_a)*cosd(latitude_b)*cosd(longitude_a - longitude_b))) "���������� ����� ��������" 
		from cte
		join flights fl on fl.flight_no = cte.flight_no
		join aircrafts ac on ac.aircraft_code = fl.aircraft_code 
		order by cte.flight_no
		

		
	
	