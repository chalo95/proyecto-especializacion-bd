select 
c.cliente,
c.nombre, 
c.alias,
CASE
	WHEN LTRIM(RTRIM(n.nit)) = '' THEN 'No definido' -- si esta vacio
	WHEN n.nit = 'ND' THEN 'No definido' -- si ya posee ND
	ELSE n.nit 
END as nit,
c.direccion,
CASE
	WHEN LTRIM(RTRIM(c.contacto)) = '' THEN 'No definido' -- si esta vacio
	WHEN c.contacto = 'ND' THEN 'No definido' -- si ya posee ND
	ELSE c.contacto 
END as contacto,
CASE
	WHEN LTRIM(RTRIM(c.cargo)) = '' THEN 'No definido' -- si esta vacio
	WHEN c.cargo = 'ND' THEN 'No definido' -- si ya posee ND
	ELSE c.cargo 
END as cargo,
CASE
	WHEN LTRIM(RTRIM(c.TELEFONO1)) = '' THEN 'No definido' -- si esta vacio
	WHEN c.TELEFONO1 = 'ND' THEN 'No definido' -- si ya posee ND
	ELSE c.TELEFONO1 
END as telefono1,
CASE
	WHEN LTRIM(RTRIM(c.TELEFONO2)) = '' THEN 'No definido' -- si esta vacio
	WHEN c.TELEFONO2 = 'ND' THEN 'No definido' -- si ya posee ND
	ELSE c.TELEFONO2 
END as telefono2,
CASE
	WHEN LTRIM(RTRIM(c.E_MAIL)) = '' THEN 'No definido' -- si esta vacio
	WHEN ISNULL(c.E_MAIL, 'ND') = 'ND' THEN 'No definido' -- si es nulo se agrega ND y se evalua ND para mostrar "no definido"
	ELSE c.E_MAIL 
END as email,
p.NOMBRE as pais,
CASE
	WHEN cc.DESCRIPCION = 'CLTE COMERCAL' THEN 'Cliente Comercial'
	WHEN cc.DESCRIPCION = 'CLTE AFILIADA' THEN 'Cliente Afiliada'
	WHEN cc.DESCRIPCION = 'CLTE MAYORISTA' THEN 'Cliente Mayorista'
	WHEN cc.DESCRIPCION = 'CLTE ADMON' THEN 'Cliente Administracion'
	WHEN cc.DESCRIPCION = 'CLTE COBRO ADMINISTRATIVO' THEN 'Cliente Cobro Administrativo'
	WHEN cc.DESCRIPCION = 'CLTE SIMAN' THEN 'Cliente SIMAN'
	ELSE cc.DESCRIPCION
END as categoria_cliente
from 
disprobe.CLIENTE c 
join disprobe.PAIS p on c.PAIS = p.PAIS
join disprobe.NIT n on c.contribuyente = n.NIT
join disprobe.categoria_cliente cc on c.CATEGORIA_CLIENTE = cc.CATEGORIA_CLIENTE;

