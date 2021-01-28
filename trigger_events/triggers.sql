use concesionario;

create trigger clientes_ai
    after insert
    on clientes
    for each row
begin
    insert into log(who, what, dateTime) value (current_user(), 'Insert new value into clients', now());
end;

insert into clientes(dni,NOMBRE,APELLIDO, CIUDAD, fechanaci) value (7, 'Santi', 'Hazana', 'Buenos Aires', '1996-08-06');
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

