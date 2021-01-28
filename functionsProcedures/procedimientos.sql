use concesionario;

drop procedure if exists coste;
create procedure coste()
begin
    declare p int(5);
    declare n varchar(20);
    declare fin boolean default true;
    declare gama varchar(10);
    declare countBaja int default 0;
    declare countMedia int default 0;
    declare countAlta int default 0;

    declare c cursor for select nombre, precio from coches;
    declare continue handler for not found
        begin
            set fin = false;
            select countBaja as 'Cantidad baja gama', countMedia as 'Cantidad media gama', countAlta as 'Cantidad alta gama';
        end;

    open c;
    fetch c into n, p;

    while fin do
        if p<10000 then
            set gama = 'Baja';
            set countBaja = countBaja + 1;
        elseif p between 10000 and 20000 then
            set gama = 'Media';
            set countMedia = countMedia + 1;
        elseif p>20000 then
            set gama = 'Alta';
            set countAlta = countAlta + 1;
        end if;
        select n as nombre, gama as Gama;
        fetch c into n, p;
    end while;
    close c;
    -- select countBaja as 'Cantidad baja gama', countMedia as 'Cantidad media gama', countAlta as 'Cantidad alta gama';
end;

call coste();

-- Crea un cursor denominado NACIONAL_EXTRANJERO que muestre el nombre,
-- apellidos, nombre del coche, modelo del coche y la nacionalidad de cada uno de los
-- coches comprados por los clientes en nuestra base de datos.
drop procedure if exists nacional_extranjero;
create procedure nacional_extranjero()
begin
    declare nomb varchar(20);
    declare apell varchar(20);
    declare nomCoche varchar(20);
    declare modCoche varchar(20);
    declare marca varchar(20);
    declare fin boolean default true;

    declare punt cursor for select c.nombre, c.apellido, coches.nombre, coches.modelo, m2.NOMBRE from coches
            inner join ventas using(codcoche)
            inner join clientes c on ventas.DNI = c.DNI
            inner join marco m on coches.CODCOCHE = m.CODCOCHE
            inner join marcas m2 on m.CIFM = m2.CIFM;

    declare continue handler for not found set fin = false;
    open punt;
    fetch punt into nomb, apell, nomCoche, modCoche, marca;

    while fin do
        if marca = 'Seat' or marca = 'Renault' then
            select nomb, apell, nomCoche, modCoche, 'Español' as Nacionalidad;
        else
            select nomb, apell, nomCoche, modCoche, 'Extranjero' as Nacionalidad;
        end if;
        fetch punt into nomb, apell, nomCoche, modCoche, marca;
    end while;
    close punt;
end;

call nacional_extranjero();

-- Crea un cursor denominado DIESEL_GASOLINA que muestre el nombre y el modelo de
-- los coches junto con el tipo de combustible para todos los coches de la base de datos.
-- Consideramos DIESEL todos los coches de modelo GTD o TD y GASOLINA a todos los demás.
drop procedure if exists diesel_gasolina;
create procedure diesel_gasolina()
begin
    declare nomCoche varchar(20);
    declare modCoche varchar(20);
    declare tipo varchar(10);
    declare fin boolean default true;

    declare curs cursor for select nombre, modelo from coches;
    declare continue handler for not found set fin = false;
    open curs;
    fetch curs into nomCoche, modCoche;

    while fin do
        if modCoche = 'GTD' or modCoche = 'TD' then
            set tipo = 'Diesel';
        else
            set tipo = 'Gasolina';
        end if;
        select nomCoche as Nombre, modCoche as Modelo, tipo as 'Tipo combustible';
        fetch curs into nomCoche, modCoche;
    end while;
end;

call diesel_gasolina();

-- Crea un cursor denominado DIESEL_GASOLINA(MARCA) que muestre el nombre y el
-- modelo de los coches junto con el tipo de combustible para todos los coches de la
-- base de datos cuyo nombre de MARCA sea el que se introduce como argumento
drop procedure if exists diesel_gasolina2;
create procedure diesel_gasolina2(marca varchar(20))
begin
    declare nomCoche varchar(20);
    declare modCoche varchar(20);
    declare nomMarca varchar(20);
    declare tipo varchar(10);
    declare fin boolean default true;

    declare curs cursor for select coches.nombre, modelo, m2.NOMBRE from coches
        inner join marco m on coches.CODCOCHE = m.CODCOCHE
        inner join marcas m2 on m.CIFM = m2.CIFM;

    declare continue handler for not found set fin = false;
    open curs;
    fetch curs into nomCoche, modCoche, nomMarca;

    while fin do
        if nomMarca = marca then
            if modCoche = 'GTD' or modCoche = 'TD' then
                set tipo = 'Diesel';
            else
                set tipo = 'Gasolina';
            end if;
        select nomCoche as Nombre, modCoche as Modelo, tipo as 'Tipo combustible';
        end if;
        fetch curs into nomCoche, modCoche, nomMarca;
    end while;
end;

call diesel_gasolina2('SEAT');