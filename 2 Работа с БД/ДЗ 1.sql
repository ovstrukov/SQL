select film_id, title "FilmTitle", description as FilmDescription, release_year as FilmRelease_year, round(rental_rate/rental_duration, 2) as DailyCost from film order by DailyCost desc;

select distinct release_year as FilmRelease_year  from film;

select * from film where rating = 'PG-13';