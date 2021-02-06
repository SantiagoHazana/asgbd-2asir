use concesionario;

set global event_scheduler = ON;

create table backUpLog like log;


create event backUpLogEvent on schedule
at '2021-02-4 09:05:00' enable
do
begin
    insert into backUpLog select * from log where dateTime < date_sub(dateTime, interval 1 day);
    delete from log where dateTime < date_sub(dateTime, interval 1 day);
end;

drop event backUpLogEvent;
create event backUpLogEvent on schedule
    every 1 day
    starts now()
    ends adddate(current_date, interval 20 day)
do
begin
    insert into backUpLog select * from log where dateTime < date_sub(dateTime, interval 1 day);
    delete from log where dateTime < date_sub(dateTime, interval 1 day);
end;

show events;

drop event eventoCursor;
create event eventoCursor on schedule
    every 1 day
    starts adddate(now(), interval 10 second)
    do
    begin
        declare tempNombreCoche varchar(20);
        declare tempModelo varchar(20);
        declare tempCantidad int(11);
        declare tempConceNombre varchar(20);
        declare tempCiudad varchar(20);
        declare str varchar(200) default '';
        declare cur cursor for select coches.nombre, modelo, cantidad, c.NOMBRE, ciudad from coches
                                        inner join distribucion d on coches.CODCOCHE = d.CODCOCHE
                                        inner join concesionario c on d.CIFC = c.CIFC
                                        where CANTIDAD < 7;
        open cur;

        loop
            fetch cur into tempNombreCoche, tempModelo, tempCantidad, tempConceNombre, tempCiudad;
            set str = concat('Del coche ', tempNombreCoche, ' modelo ', tempModelo, ', hay ', tempCantidad, ' unidades en el concesionario ', tempConceNombre, ' de la ciudad ', tempCiudad);
            insert into log(who, what, dateTime) VALUE (current_user, str, now());
        end loop;
        close cur;
    end;


# relacion ejercicios

# 1) Crea un evento programado en mysql para que borre todos los registros del archivo
# log que tengan más de un mes de antigüedad. Dicho evento se debe disparar una vez
# al día a las 10:00 de la mañana.

drop event deleteOldLogs;
create event deleteOldLogs on schedule
    every 1 day
    starts '2021-02-05 10:00:00'
    do
    begin
        delete from log where dateTime <= date_sub(dateTime, interval 30 day);
    end;

# 2) Crea un evento programado en mysql que inserte el número de clientes que hay en la
# tabla clientes en el archivo log. Dicho evento se disparará cada 5 minutos.

drop event logClients;
create event logClients on schedule
    every 5 minute
    starts adddate(now(), interval 1 minute )
    do
    begin
        insert into log(who, what, dateTime) VALUE (current_user, concat('Hay ', (select sum(dni) from clientes), ' clientes'), now());
    end;

# 3) Crea un evento programado en mysql que inserte en la tabla log cada día un resumen
# del número de coches que tiene cada concesionario

drop event logCarsPerDealership;
create event logCarsPerDealership on schedule
    every 1 day
    starts adddate(now(), interval 2 minute)
    do
    begin
            declare tempCantidad int(11);
        declare tempCIFCon int(11);
        declare str varchar(200);
        declare cur cursor for select c.cifc, sum(cantidad) from distribucion
                                        inner join concesionario c on distribucion.CIFC = c.CIFC group by c.cifc;
        open cur;

        loop
            fetch cur into tempCIFCon, tempCantidad;
            set str = concat('El concesionario ', tempCIFCon, ' tiene ', tempCantidad, ' coches');
            insert into log(who, what, dateTime) VALUE (current_user, str, now());
        end loop;
        close cur;
    end;

