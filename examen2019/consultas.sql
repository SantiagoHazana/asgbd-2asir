use world;
alter table city add foundation Date;
update city set city.foundation = str_to_date(concat(floor(rand()*1019+1000), '-' ,floor(rand()*11+1), '-' ,floor(rand()*27+1)), '%Y-%m-%d');

select (select city.Name from city inner join country c on city.CountryCode = c.Code where Continent = 'Europe' order by foundation limit 1) as MasAntiguo, (select city.Name from city inner join country c on city.CountryCode = c.Code where Continent = 'Europe' order by foundation desc limit 1) as MasJoven;

select city.name from city inner join country c on city.CountryCode = c.Code where c.Continent = 'Europe'
    and foundation = (select min(foundation) from city inner join country c2 on city.CountryCode = c2.Code);

-- 3.
-- a) Muestra todos los idiomas que se hablan en España.
select Language from country inner join countrylanguage c on country.Code = c.CountryCode
    where Name='Spain';

-- b) Dime todas los datos de las ciudades de Bolivia que hay en la tabla CITY
select * from city inner join country c on city.CountryCode = c.Code
    where c.Name = 'Bolivia';

-- c) Dime el total de población de las ciudades de RUSSIAN FEDERATION.
select sum(city.Population) from city inner join country c on city.CountryCode = c.Code
    where c.Name = 'Russian Federation';

-- d) Muestra el nombre y los habitantes de todos los países del mundo que tienen la misma forma de
-- gobierno que España.
select Name, Population from country
    where GovernmentForm = (select GovernmentForm from country where Name='Spain');

-- e) Muestra todas las parejas de países de ‘South America’ en los que se hable ‘Spanish’ sin repeticiones
-- y ordenados alfabéticamente de menor a mayorsegún el primer nombre del país si hay repeticiones
-- de menor a mayor según el segundo nombre del país.
select distinct c1.name, c2.name from country c1, country c2, countrylanguage
    where Language='Spanish' and c1.Continent = 'South America' and c2.Continent = 'South America' and c1.Code<c2.Code
    order by c1.Name;

-- k)¿Qué idioma se habla mayoritariamente en el país con menor productivo interior bruto (GNP) de
-- Europa? Muestra el nombre del país y el idioma.
select Name, Language from countrylanguage inner join country  on countrylanguage.CountryCode = Code
    where Code = (select Code from country
                        where GNP= (select min(GNP) from country
                                        where Continent='Europe'))
    and Code = (select Code from country);


select name, count(Language) as count from country
    inner join countrylanguage c on country.Code = c.CountryCode
    where IsOfficial = 'T'
    group by name
    order by count desc;

select name, Language from country inner join countrylanguage c on country.Code = c.CountryCode
    where code = (select code from country where Continent = 'Europe' and GNP != 0 order by GNP limit 1)
    order by Percentage desc
    limit 1;