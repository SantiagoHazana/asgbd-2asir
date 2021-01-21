-- Santiago Hazaña - Examen ASGBD 2020

use nation;

-- a)
alter table countries add time_update time;
update countries set countries.time_update=concat(floor(rand()*24), ':', floor(rand()*60), ':', floor(rand()*60));
create view time_modification as select name, time_update from countries where time_update>'12:00:00' and time_update<'15:00:00';

-- b)
create view country_details as select countries.name as Country, r.name as Region, c.name as Continent, area from countries
    inner join regions r on countries.region_id = r.region_id
    inner join continents c on r.continent_id = c.continent_id;

-- c)
create view languagesOfCountries as select c.name as Country, cl.official as Official, l.language from countries c
    inner join country_languages cl on c.country_id = cl.country_id
    inner join languages l on cl.language_id = l.language_id;

-- d)
create view population_density as select name, area, population, round((population/area),2) as densidad from countries
    inner join country_stats cs on countries.country_id = cs.country_id
    where year='2018';