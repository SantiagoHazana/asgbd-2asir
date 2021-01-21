use functions;

drop function if exists hackear;
create function hackear(frase text) returns text
begin
    return replace(replace(replace(replace(frase, 'a', '4'), 'e', '3'), 'i', '1'), 'o', '0');
end;

drop function if exists deshackear;
create function deshackear(frase text) returns text
begin
    return replace(replace(replace(replace(frase, '4', 'a'), '3', 'e'), '1', 'i'), '0', 'o');
end;

-- funcion que le pasamos un numero y un texto y concatena ese numero de veces el texto
-- ej repetir('Hola como estas', 3) --> 'Hola como estas Hola como estas Hola como estas'

create function repetir(frase text, n int) returns text
begin
    declare res text default '';
    declare contador int default 0;
    bucle : while contador < n do
        set res = concat(res, ' ',frase);
        set contador = contador + 1;
        end while;
    return res;
end;

select hackear('Hola como estas');
select deshackear('h0l4 c0m0 3st4s');

select repetir('Saraaaaaaaaaaaaaaaaa', 3) as Frase;

drop function if exists fibonnacci;
create function fibonnacci(n int) returns int
begin
    declare prevPrevNum int default 0;
    declare prevNum int default 0;
    declare currentNum int default 1;
    declare i int default 1;

    bucle : while i < n do
        set prevPrevNum = prevNum;
        set prevNum = currentNum;
        set currentNum = prevPrevNum + prevNum;

        set i = i+1;
        end while;
    return currentNum;
end;

select fibonnacci(10);