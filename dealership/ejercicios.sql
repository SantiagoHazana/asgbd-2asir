use dealership;

select * from marcas where CIUDAD='Barcelona';

select * from clientes where apellido='Garcia' and ciudad='Madrid';

select apellido from clientes;

select m1.nombre, m2.nombre from marcas as m1, marcas as m2 where m1.CIUDAD=m2.CIUDAD and not m1.CIFM=m2.CIFM;