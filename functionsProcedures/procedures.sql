use functions;

drop procedure if exists fibonacci;
create procedure fibonacci(in num int, out sum int)
begin
    declare prevPrevNum int default 0;
    declare prevNum int default 0;
    declare currentNum int default 1;
    declare i int default 1;

    bucle : while i < num do
        set prevPrevNum = prevNum;
        set prevNum = currentNum;
        set currentNum = prevPrevNum + prevNum;

        set i = i+1;
        end while;
    set sum = currentNum;
end;

call fibonacci(10, @sum);

select @sum;

drop procedure if exists hoy;
create procedure hoy(out phrase text)
begin
    set lc_time_names = 'es_es';
    set phrase = concat('Hoy es ', dayname(curdate()), ' de ', monthname(curdate()), ' de ', year(curdate()));

end;

call hoy(@fecha);
select @fecha;

