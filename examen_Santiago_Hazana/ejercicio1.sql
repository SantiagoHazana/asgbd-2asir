-- Santiago Hazaña - Examen ASGBD 2020

use nation;

-- a)
create user 'Investigado'@'%' identified by 'Researcher';
grant select on nation.countries to 'Investigado'@'%' with max_queries_per_hour 100 max_connections_per_hour 10;
grant select on nation.country_stats to 'Investigado'@'%' with max_queries_per_hour 100 max_connections_per_hour 10;

-- b)
create user 'Administrador'@'172.26.0.0/16' identified by '123456noesunabuenapassword';
grant select, update on nation.* to 'Administrador'@'172.26.0.0/16' with max_queries_per_hour 50;