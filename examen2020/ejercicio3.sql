-- Santiago Hazaña - Examen ASGBD 2020

use nation;

-- a)
select name, national_day from countries where national_day is not null order by national_day desc;

-- b)
select name, area, population from countries
    inner join country_stats cs on countries.country_id = cs.country_id
    where area>2000000 and year='2018'
    order by area;

-- c)
select concat(countries.name, ' tiene ', area, 'km2, ', population, ' habitantes, ', (gdp/population), '$ por persona de PBI, ', 'esta en ', c.name, ' y mas concretamente en ', r.name) as Information from countries
    inner join regions r on countries.region_id = r.region_id
    inner join country_stats cs on countries.country_id = cs.country_id
    inner join continents c on r.continent_id = c.continent_id
    where year='2018';

-- d)
select name, national_day from countries
    where national_day>'1944-12-31' and national_day<'1971-01-01'
    order by national_day desc;

-- e)
select name, gdp from countries inner join country_stats cs on countries.country_id = cs.country_id
    where gdp<(select max(gdp) from country_stats)
    and year='2018' order by gdp desc limit 1;

select name, gdp from countries inner join
    country_stats using (country_id) where year=2018 order by gdp desc limit 1 offset 1;

-- f)
select * from countries
    inner join regions r on countries.region_id = r.region_id
    inner join continents c on r.continent_id = c.continent_id
    where national_day is null and c.name='Europe'
    order by countries.name;

-- g)
select r.name, count(c.name) as cantidad from countries c
    inner join regions r on c.region_id = r.region_id
    group by r.name
    order by cantidad desc;

-- h)
select c2.name, sum(c.area) as areaTotal from countries c
    inner join regions r on c.region_id = r.region_id
    inner join continents c2 on r.continent_id = c2.continent_id
    group by c2.name
    order by areaTotal desc ;

-- i)
select r.name as region, min(c.area) as mas_pequeno, max(c.area) as mas_grande from countries c
    inner join regions r on c.region_id = r.region_id
    group by r.name
    order by r.name;

-- j)
select c.name, (avg(gdp)/1000000000) as pib_promedio from countries c
    inner join country_stats cs on c.country_id = cs.country_id
    inner join regions r on c.region_id = r.region_id
    inner join continents c2 on r.continent_id = c2.continent_id
    where c2.name='Europe'
    group by c.name
    order by pib_promedio desc;

-- k)
select c.name, l.language from countries c
    inner join country_languages cl on c.country_id = cl.country_id
    inner join languages l on cl.language_id = l.language_id
    where c.country_id=(select countries.country_id from countries
                            inner join country_stats s on countries.country_id = s.country_id
                            inner join regions r2 on countries.region_id = r2.region_id
                            inner join continents c3 on r2.continent_id = c3.continent_id
                            where c3.name='Europe' and s.year='2018' order by gdp limit 1)
    group by l.language;

-- l)
select r.name, count(c.name) as country_count from countries c
    inner join regions r on c.region_id = r.region_id
    group by r.name
    having country_count>10
    order by country_count desc;

-- m)
select c.name from countries c
    inner join country_stats cs on c.country_id = cs.country_id
    where cs.population > (select avg(country_stats.population) from country_stats where country_stats.year='2018')
    and cs.gdp > (select avg(country_stats.gdp) from country_stats where country_stats.year='2018')
    group by c.name;