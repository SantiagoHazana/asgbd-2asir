use concesionario;

-- 1.
use test;
drop function if exists fibonacci;
create function fibonacci(n int) returns long
begin
    declare fib int default 1;
    declare prevFib int default 1;
    declare temp int;
    declare i int default 2;

    while i<n do
        set temp = fib;
        set fib = fib + prevFib;
        set prevFib = temp;
        set i = i+1;
    end while;
    return fib;
end;

select fibonacci(5);
select fibonacci(8);

-- 2.
drop procedure if exists fibonacciRec;
SET max_sp_recursion_depth=255;
create procedure fibonacciRec(in n int, out fib long)
begin
    declare n_1 int;
    declare n_2 int;
    if (n=0) then
        set fib=0;
    elseif (n=1) then
        set fib=1;
    else
        call fibonacciRec(n-1,n_1);
        call fibonacciRec(n-2,n_2);
        set fib=(n_1 + n_2);
    end if;
end;

call fibonacciRec(5, @fib1);
call fibonacciRec(8, @fib2);

select @fib1, @fib2;

select @fib1;

-- 3.
drop procedure if exists hoy;
create procedure hoy(out dia text)
begin
    declare weekDay int default dayofweek(current_date);
    declare day int default day(current_date);
    declare month text default month(current_date);
    declare yearN int default year(current_date);

    declare diaSemana text;
    case weekDay
        when 1 then set diaSemana = 'Domingo';
        when 2 then set diaSemana = 'Lunes';
        when 3 then set diaSemana = 'Martes';
        when 4 then set diaSemana = 'Miercoles';
        when 5 then set diaSemana = 'Jueves';
        when 6 then set diaSemana = 'Viernes';
        when 7 then set diaSemana = 'Sabado';
    end case;

    set dia = concat();

end;

