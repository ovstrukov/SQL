-- Итоговая работа

-- 1) В каких городах больше одного аэропорта?

-- выводим список городов из таблицы "Аэропорты", где "город" присутстует в результате подзапроса из той же таблицы "Аэропорты".
-- подзапрос группирует по названию города и считает сколько раз повторялся город в списке аэропортов, и выводит только те города, где повторений  больше 1
select distinct a.city
from airports a
where a.city IN (select aa.city
 					from airports aa
 					group by aa.city
 					having COUNT(aa.city) > 1
 					) 

 -- 2) В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
 
-- в подзапросе находим самолет с максимальной дальностью перелета, это Boeing 777-300
-- делаем два объединения, чтобы связать самолеты, полеты и аэропорты
-- выводим аэропорты, куда летает Boeing 777-300

select distinct ap.airport_code , ap.airport_name, a.model 
from airports ap
	join flights f on f.departure_airport = ap.airport_code 
	join aircrafts a on a.aircraft_code = f.aircraft_code 
where a."range" = (select max(a."range")
					from aircrafts a)
					
-- 3) Вывести 10 рейсов с максимальным временем задержки вылета

-- выводим номера рейсов и расчетное время задержки рейса с ограничением, что это значение не пустое, сортировка по задерке рейса по убываению с лимитом 10

select f.flight_no , (f.actual_departure - f.scheduled_departure) delay
from flights f
where (f.actual_departure - f.scheduled_departure) is not null
order by delay desc
limit 10

-- 4) Были ли брони, по которым не были получены посадочные талоны?

-- делаем два inner join bookings + tickets + ticket_flights и full join с boarding_passes, чтобы найти уникальные значения, которые 
-- есть в (bookings + tickets + ticket_flights) и нет в boarding_passes. Эти значения вычленяем при помощи условия where bp.ticket_no is null

select b.book_ref , b.book_date --'Брони были, по которым не получены посадочные талоны' "Результат"
from bookings b
	join tickets t on t.book_ref = b.book_ref 
--	join ticket_flights tf on tf.ticket_no = t.ticket_no -- правка от преподавателя: 
--Вопрос про брони и посадочные талоны, привязка к перелетам рождает избыточные данные.
--Использовать таблицу ticket_flights в данном задании не нужно.
	full join boarding_passes bp on bp.ticket_no = t.ticket_no
where bp.ticket_no is null

-- 5) Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
--Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта на каждый день. 
--Т.е. в этом столбце должна отражаться накопительная сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за день.

-- выводим необходимую информацию из двух join, через оконную функцию считаем вывезенных пассажиров за день 

select f.actual_departure "Отправление", f.flight_id "ID рейса", f.flight_no "Номер рейса", (total.total_seat - reserved.res_seat) "Свободных мест", 
		round((total.total_seat - reserved.res_seat) / total.total_seat ::float *100) as "% свободных мест",
		reserved.res_seat "Занятых мест",
		sum(reserved.res_seat) over (partition by f.departure_airport , date_trunc('day', f.actual_departure) order by f.actual_departure)	"Кол-во перевезенных пассажиров"	
from flights f
--делаем join с подзапросом reserved, который выводит количество занятых мест на рейсах
join (select  f.flight_id, f.flight_no , count(bp.seat_no) res_seat, f.actual_departure , f.departure_airport 
			from boarding_passes bp
				left join ticket_flights tf on bp.flight_id = tf.flight_id and bp.ticket_no = tf.ticket_no 
				left join flights f on tf.flight_id = f.flight_id and tf.ticket_no = tf.ticket_no
			group by f.flight_id 
			order by f.flight_id
			) as reserved on f.flight_id = reserved.flight_id
--делаем join с подзапросом total, который выводит общее количество мест на рейсах
join (select  f.flight_id, f.flight_no , count(s2.seat_no) total_seat, f.actual_departure , f.departure_airport 
			from seats s2 
				join aircrafts a on s2.aircraft_code = a.aircraft_code
				join flights f on a.aircraft_code = f.aircraft_code 
			group by f.flight_id 
			order by f.flight_id
			) as total on f.flight_id = total.flight_id
 
-- 6) Найдите процентное соотношение перелетов по типам самолетов от общего количества.


--делаем  join aircrafts и flights с группировкой по модели, тем самым получаем разбивку кол-ва рейсов по моделям самолетов, 
--общее кол-во перелетов получаем через подзапрос;   :: приводим к float, чтобы не округлялось до нуля
		
			select a.model "Модель ВС", 
					round(count(f.flight_id)/(select count(f.flight_id) from flights f )::float *100) "Процент перелетов на этом ВС"	
			from aircrafts a
				join flights f on f.aircraft_code = a.aircraft_code
			group by a.model
			
-- 7) Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?

	--в подзапросах выбираем рейсы и стоимости перелета для эконома и соответственно для бизнеса,
	--join  с flights  и выводим инфо по перелетам , где b.amount < e.amount
	--но таковых не нашлось
	
		select f.flight_id 
		from flights f
		join (	select tf.flight_id , tf.amount
				from ticket_flights tf
				where tf.fare_conditions = 'Business') b on b.flight_id = f.flight_id
		join (	select tf.flight_id , tf.amount
				from ticket_flights tf
				where tf.fare_conditions = 'Economy') e on e.flight_id = f.flight_id
		where b.amount < e.amount
		
		
		
		
-- 8) Между какими городами нет прямых рейсов?

		-- формуруем представление a1 для всех возможных аэропортов отправления
		create view  a1 as (
		select a2.airport_code  departure_airport
		from airports a2)
		
		-- формуруем представление a2 для всех возможных аэропортов назначения
		create view  a2 as (
		select a2.airport_code arrival_airport
		from airports a2)
		
		--в оболочку cte упаковываем декартово произведение представлений a1 и a2 (все на все аэропорты), 
		--исключая комбинации действующих рейсов из представления routes
		--join с таблицей airports, для получения названия городов, выводим необходимую информацию комбинаций городов, между которыми нет прямых рейсов
		
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
		
		--Минус 20 баллов.
--Вопрос про города, а не аэропорты. Города нужно получать изначально. Так же не убраны варианты, где город А равен городу А.
		
		
-- 9) Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, 
-- обслуживающих эти рейсы *
-- В локальной базе координаты находятся в столбцах airports.longitude и airports.latitude.
--Кратчайшее расстояние между двумя точками A и B на земной поверхности (если принять ее за сферу) определяется зависимостью:
--d = arccos {sin(latitude_a)·sin(latitude_b) + cos(latitude_a)·cos(latitude_b)·cos(longitude_a - longitude_b)}, где latitude_a и latitude_b — широты, longitude_a, longitude_b — долготы данных пунктов, d — расстояние между пунктами измеряется в радианах длиной дуги большого круга земного шара.
--Расстояние между пунктами, измеряемое в километрах, определяется по формуле:
--L = d·R, где R = 6371 км — средний радиус земного шара.

--формируем cte, в которой таблица с номером рейса, пунктами отправления и назначения с координатами через подзапросы из (представления routes join airports)
--из cte берем координаты для формулы расстояния и делаем join с flights и aircrafts для получения данных по моделям и дальностям самолётов на рейсах.
		
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
		select distinct cte.flight_no, ac.model , ac."range" "Дальность самолёта", round(6371 * acos(sind(latitude_a)*sind(latitude_b) + cosd(latitude_a)*cosd(latitude_b)*cosd(longitude_a - longitude_b))) "Расстояние между городами" 
		from cte
		join flights fl on fl.flight_no = cte.flight_no
		join aircrafts ac on ac.aircraft_code = fl.aircraft_code 
		order by cte.flight_no
		

		
	
	