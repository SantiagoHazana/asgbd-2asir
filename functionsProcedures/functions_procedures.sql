use test;

create function hack(phrase varchar(50)) returns varchar(50)
begin
    return replace(phrase, 'a', '4');
end;

create procedure hola_mundo ()
begin
    select 'Hola Mundo';
end;

create procedure session_vars(IN num int) set @x = num;
call session_vars(123);
select @x;


create procedure session_vars2(out num int) set num = -5;
call session_vars2(@y);
select @y;

create procedure session_vars3(inout num int) set num = num - 5;
set @z = 0;
call session_vars3(@z);

select @z;

drop procedure if exists ecu_2grad;
create procedure ecu_2grad(in a double, in b double, in c double, out x1 double, out x2 double)
begin
    if (b*b - 4 * a * c)<0 then
        set x1 = null;
        set x2 = null;
    else
        set x1 = (-b + sqrt(b*b - 4 * a * c))/4*a;
        set x2 = (-b - sqrt(b*b - 4 * a * c))/4*a;
    end if;
end;
call ecu_2grad(1, 2, -3, @x1, @x2);
select @x1, @x2;
call ecu_2grad(1, 2, 3, @x1, @x2);
select @x1, @x2;

-- crear una funcion que recibe nombre y apellido y devuelve el apellido y luego el nombre con la primera letra en mayusculas
-- crear un procedimiento que haga lo mismo

create function apelNom(nombre varchar(10), apellido varchar(10)) returns varchar(25)
begin
    return concat(concat(upper(substr(apellido, 1, 1)), lower(substr(apellido, 2))), ', ' , concat(upper(substr(nombre, 1, 1)), lower(substr(nombre, 2))));
end;

select apelNom('santiago', 'hazana');

create procedure apelNombre(in nombre varchar(10), in apellido varchar(10), out completo varchar(25))
begin
    set completo = concat(concat(upper(substr(apellido, 1, 1)), lower(substr(apellido, 2))), ', ' , concat(upper(substr(nombre, 1, 1)), lower(substr(nombre, 2))));
end;
call apelNombre('santiago', 'hazana', @completo);
select @completo;

-- lo probamos con los clientes de concesionario, hay que crear las funciones dentro de concesionario
use concesionario;
select apelNom(nombre, apellido) as NombreCompleto from clientes;


-- crear una funcion y procedimiento que verifique si un numero es primo
drop function if exists primo;
create function primo(num int) returns boolean
begin
    declare i int default 2;
    while i < num do
        if num % i = 0 then
            return false;
        end if;
        set i = i + 1;
        end while;
    return true;
end;

select primo(10);

drop procedure if exists primo;
create procedure primo(in num int, out res boolean)
begin
    declare i int default 2;
    set res = true;
    bucle : while i < num do
        if num % i = 0 then
            set res = false;
            leave bucle;
        end if;
        set i = i + 1;
    end while;
end;

call primo(7, @res);
select @res;

call primo(10, @res);
select @res;

-- realizar una funcion que dado un campo de tipo fecha me diga cuanto tiempo ha transcurrido

drop function if exists timePassed;
create function timePassed(aDate date) returns text
begin
    declare days int default datediff(current_date, aDate);
    declare years int default days/365;
    set days = days - (years*365);
    return concat(years, ' años y ', days, ' dias');
end;

select timePassed('1995-08-06') as Tiempo_transcurrido;
