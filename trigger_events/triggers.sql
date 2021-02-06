use concesionario;

drop trigger if exists clientes_ai;
create trigger clientes_ai
    after insert
    on clientes
    for each row
begin
    insert into log(who, what, dateTime) value (current_user(), concat('Insert new value with DNI:', new.DNI, ' into clients'), now());
end;

insert into clientes(dni,NOMBRE,APELLIDO, CIUDAD) value (7, 'Santi', 'Hazana', 'Buenos Aires');
select * from clientes;

select * from log;

drop trigger if exists clientes_au;
create trigger clientes_au
    after update
    on clientes
    for each row
begin
    declare res varchar(200) default '';
    if !(NEW.DNI <=> OLD.DNI) then
        set res = concat(res, 'DNI: ', ifnull(old.DNI, 'null'), ' -> ', new.DNI, ' ');
    end if;
    if !(NEW.NOMBRE <=> OLD.NOMBRE) then
        set res = concat(res, 'Nombre: ', ifnull(old.NOMBRE, 'null'), ' -> ', new.NOMBRE, ' ');
    end if;
    if !(NEW.APELLIDO <=> OLD.APELLIDO) then
        set res = concat(res, 'Apellido: ', ifnull(old.APELLIDO, 'null'), ' -> ', new.APELLIDO, ' ');
    end if;
    if !(NEW.CIUDAD <=> OLD.CIUDAD) then
        set res = concat(res, 'Ciudad: ', ifnull(old.CIUDAD, 'null'), ' -> ', new.CIUDAD, ' ');
    end if;
    if !(NEW.fechanaci <=> OLD.fechanaci) then
        set res = concat(res, 'Fecha nacimiento: ', ifnull(old.fechanaci, 'null'), ' -> ', new.fechanaci, ' ');
    end if;
    if res != '' then
        insert into log(who, what, dateTime) VALUE (current_user, concat('Record updated in clientes: ', res), now());
    end if;
end;

update clientes set DNI=39069364, NOMBRE='Santiago', APELLIDO='Hazaña', CIUDAD='Jose C Paz', fechanaci='1995-08-06' where DNI=7;
update clientes set fechanaci='1973-04-23' where DNI=6;
select * from log;

drop trigger if exists clientes_ad;
create trigger clientes_ad
    after delete
    on clientes
    for each row
begin
    insert into log(who, what, dateTime) VALUE (current_user, concat('Deleted entry DNI:', OLD.DNI, ' from clientes'), now());
end;

delete from clientes where DNI=39069364;
select * from log;


drop trigger if exists coches_ai;
create trigger coches_ai
    after insert
    on coches
    for each row
begin
    declare total int;
    insert into log(who, what, dateTime) value (current_user(), concat('Insert new value with CODCOCHE:', new.CODCOCHE, ' into coches'), now());
    set total = (select sum(precio) from coches);
    insert into log(who, what, dateTime) VALUE (current_user, concat('Inserted into coches, new total price of cars is: ', total), now());
end;


drop trigger if exists coches_au;
create trigger coches_au
    after update
    on coches
    for each row
begin
    declare res varchar(200) default '';
    declare total int;
    if !(NEW.CODCOCHE <=> OLD.CODCOCHE) then
        set res = concat(res, 'CODCOCHE: ', ifnull(old.CODCOCHE, 'null'), ' -> ', new.CODCOCHE, ' ');
    end if;
    if !(NEW.NOMBRE <=> OLD.NOMBRE) then
        set res = concat(res, 'Nombre: ', ifnull(old.NOMBRE, 'null'), ' -> ', new.NOMBRE, ' ');
    end if;
    if !(NEW.MODELO <=> OLD.MODELO) then
        set res = concat(res, 'Modelo: ', ifnull(old.MODELO, 'null'), ' -> ', new.MODELO, ' ');
    end if;
    if !(NEW.precio <=> OLD.precio) then
        set res = concat(res, 'Precio: ', ifnull(old.precio, 'null'), ' -> ', new.precio, ' ');
    end if;
    if res != '' then
        insert into log(who, what, dateTime) VALUE (current_user, concat('Record updated in coches: ', res), now());
        if !(NEW.precio <=> OLD.precio) then
            set total = (select sum(precio) from coches);
            insert into log(who, what, dateTime) VALUE (current_user, concat('Update in coches, new total price of cars is: ', total), now());
            end if;
        end if;
end;

drop trigger if exists coches_ad;
create trigger coches_ad
    after delete
    on coches
    for each row
begin
    declare total int;
    set total = (select sum(precio) from coches);
    insert into log(who, what, dateTime) VALUE (current_user, concat('Deleted entry DNI:', OLD.CODCOCHE, ' from coches'), now());
    insert into log(who, what, dateTime) VALUE (current_user, concat('Deleted from coches, new total price of cars is: ', total), now());

end;

update coches set precio = 12000;

select * from log;
insert into coches value (20, 'FOCUS', 'RS', 5000);
update coches set precio=7000 where CODCOCHE=10;
delete from coches where CODCOCHE=20;


