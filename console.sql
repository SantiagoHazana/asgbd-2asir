use dealership;

create function nombre(parametro int) returns text
begin 
    declare algo text default 'lo que a vos se te de la gana';
    -- codigo que hace algo
    set algo = 'otra cosa';
    return algo;
end;

create procedure nombre(in arg1 int)
begin
    set @var1 = arg1;
end;

call nombre(5);
select @var1;


create procedure procedimiento(out arg1 int)
begin 
    set arg1 = 10;
end;

call procedimiento(@var1);

select @var1;


create procedure ecSegGrado(in a int, in b int, in c int, out x1 double, out x2 double)
begin
    set x1 = (-b + sqrt(pow(b, 2)-(4*a*c)))/2*a;
    set x2 = (-b - sqrt(pow(b, 2)-(4*a*c)))/2*a;
end;

call ecSegGrado(1, 2, -3, @x1, @x2);

select @x1 as Raiz1, @x2 as Raiz2;

-- crear una funcion y procedimiento que reciba un nombre y un apellido y devuelva el nombre completo, con las iniciales mayusculas
-- (saRA, agUIlera) --> "Aguilera, Sara"

use nation;

select * from countries
        inner join regions on countries.region_id = regions.region_id;

select * from languages union select * from continents;




select concat(floor(rand()*24), ':', floor(rand()*60), ':',floor(rand()*60));

-- fechas aleatorias entre el año 1200 y 2000
select concat(floor(rand()*800+1200), '-', floor(rand()*24+1), '-', floor(rand()*28+1));

select str_to_date('1950-12-31', '%Y-%m-%d');

select str_to_date(concat(floor(rand()*800+1200), '-', floor(rand()*12+1), '-', floor(rand()*31+1)), '%Y-%m-%d');


select str_to_date(concat(floor(rand()*(2019-1970)+1970), '-', floor(rand()*12+1), '-', floor(rand()*31+1)), '%Y-%m-%d');

use vueltaciclista;

select equipo.nomeq, avg(edad) from equipo inner join ciclista c on equipo.nomeq = c.nomeq
    where c.edad > 25 and c.nomeq in (select equipo.nomeq from equipo inner join ciclista c2 on equipo.nomeq = c2.nomeq
                                                where c2.edad>25
                                                having count(c2.nomeq)>3);