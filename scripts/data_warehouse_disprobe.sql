create schema warehouse;

DROP TABLE IF EXISTS warehouse.factVenta;
DROP TABLE IF EXISTS warehouse.factTraspaso;
DROP TABLE IF EXISTS warehouse.factIngresos;
DROP TABLE IF EXISTS warehouse.factConsumos;
DROP TABLE IF EXISTS warehouse.dimLote;
DROP TABLE IF EXISTS warehouse.dimBodega;
DROP TABLE IF EXISTS warehouse.dimArticulo;
DROP TABLE IF EXISTS warehouse.dimClientes;
DROP TABLE IF EXISTS warehouse.dimFecha;
DROP TABLE IF EXISTS warehouse.dimProveedor;

create table warehouse.dimLote(
    lote_key int primary key identity,
    lote_id varchar(15) not null,
    lote_del_proveedor varchar(15) not null,
    fecha_entrada datetime not null,
    fecha_vencimiento datetime not null,
    cantidad_ingresada decimal(28,13) not null,
    estado varchar(10) default('vigente') not null
);

create table warehouse.dimBodega(
 	bodega_key int primary key identity,
 	bodega_id varchar(50) not null,
 	bodega_nombre varchar(50) not null,
 	bodega_tipo varchar(50) not null,
 	bodega_telefono varchar(50) default('N/A'),
 	bodega_direccion text default('N/A'),
 	bodega_traslados text default('N/A'),
 	fecha_de_registro date not null,
 	fecha_de_creacion date not null,
 	producto_existencia varchar(120) default('N/A'),
 	zona_bodega varchar(120) not null,
 	codigo_cliente_consigna varchar(120) not null,
 	descripcion_articulo varchar(120) default('N/A'),
 	tipo_de_cambio varchar(120) default('N/A'),
 	local varchar(120) not null,
 	localizacion varchar(120) not null,
 	fecha_inicio_vigencia date not null,
	fecha_fin_vigencia date,
	registro_vigente varchar(2) default('SI')
);

CREATE TABLE warehouse.dimArticulo (
    Articulo_key INT PRIMARY KEY IDENTITY,
    articulo_id VARCHAR(20) NOT NULL,
    descripcion VARCHAR(254) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    origen VARCHAR(20) NOT NULL,
    activo VARCHAR(20) NOT NULL,
    clasificacion1 VARCHAR(40) NOT NULL,
    clasificacion2 VARCHAR(40) NOT NULL,
    clasificacion3 VARCHAR(40) NOT NULL,
    clasificacion4 VARCHAR(40) NOT NULL,
    clasificacion5 VARCHAR(40) NOT NULL,
    clasificacion6 VARCHAR(40) NOT NULL,
    unidad_medida VARCHAR(6) NOT NULL,
    peso_neto DECIMAL(28, 8) NOT NULL,
    peso_bruto DECIMAL(28, 8) NOT NULL,
    volumen DECIMAL(28, 8) NOT NULL,
    costo_local DECIMAL(28, 8) NOT NULL,
    tipo_costo_comparativo VARCHAR(20) NOT NULL,
    costo_comparativo DECIMAL(28, 8) NOT NULL,
    existencia_maxima DECIMAL(28, 8) NOT NULL,
    existencia_minima DECIMAL(28, 8) NOT NULL,
    punto_orden DECIMAL(28, 8) NOT NULL,
    ultima_salida DATE NOT NULL,
    ultima_ingreso DATE NOT NULL,
    ultimo_inventario DATE NOT NULL
);

create table warehouse.dimClientes(
	cliente_key int primary key identity,
	cliente_id varchar(20) not null,
	nit varchar(20) not null,
	nombre_cliente varchar(150) not null,
	alias varchar(150) default('N/A'),
	direccion text default('N/A'),
	email varchar(256) default('N/A'),
	telefono_1 varchar(50) default('N/A'),
	telefono_2 varchar(50) default('N/A'),
	contacto varchar(30) not null,
	cargo_contacto varchar(30) not null,
	pais varchar(40) not null,
	tipo_cliente varchar(40) not null,
);

create table warehouse.dimFecha (
	fecha_key int primary key identity,
	fecha_completa date,
	anio varchar(4),
	mes int,
	dia int,
	nombre_dia varchar(4),
	semana_anio int,
	es_fin_semana varchar(4),
	es_asueto varchar(4)
);

create table warehouse.dimProveedor(
	proveedor_key int primary key identity,
	proveedor_id varchar(20) not null,
	nit varchar(20) not null,
	nombre_proveedor varchar(150) not null,
	alias varchar(150) default('N/A'),
	fecha_ingreso date not null,
	direccion varchar(250) default('N/A'),
	contacto varchar(30) not null,
	cargo_contacto varchar(30) not null,
	pais varchar(40) not null,
	condicion_pago varchar(40) not null,
	estado_proveedor varchar(2) not null,
	moneda varchar(4) not null,
	telefono varchar(20) default('N/A'),
	local varchar(10) not null,
	email varchar(256) default('N/A'),
	tipo_proveedor varchar(40) not null,
	fecha_inicio_vigencia date not null,
	fecha_fin_vigencia date,
	registro_vigente varchar(2) default('SI')
);

create table warehouse.factIngresos(
	ingreso_key int primary key identity,
	ingreso_id int not null,
	linea_detalle_proveedor int not null,
	fecha_id int not null,
	articulo_id int not null,
	bodega_id int not null,
	proveedor_id int not null,
	fecha_hora_transaccion datetime not null,
	cantidad decimal(28,13) not null,
	precio_total decimal(28,13) not null,
	costo_unitario decimal(28,13) not null,
	
	-- llaves foraneas definidas
	foreign key (fecha_id) references warehouse.dimFecha(fecha_key),
	foreign key (articulo_id) references warehouse.dimArticulo(articulo_key),
	foreign key (bodega_id) references warehouse.dimBodega(bodega_key),
	foreign key (proveedor_id) references warehouse.dimProveedor(proveedor_key),
);

create table warehouse.factConsumos(
	consumo_key int primary key identity,
	consumo_id int not null,
	fecha_id int not null,
	articulo_id int not null,
	bodega_id int not null,
	lote_id int not null,
	detalle_consumo_id int not null,
	fecha_hora_transaccion datetime not null,
	tipo_movimiento varchar(15) default('Consumo'),
	cantidad decimal(28,13) not null,
	precio_unitario decimal(28,13) not null,
	costo decimal(28,13) not null,
	existencia_minima decimal(28,13) not null,
	existencia_maxima decimal(28,13) not null,
	cantidad_disponible_bruta decimal(28,13) not null,
	cantidad_disponible_neta decimal(28,13) not null,
	valor_inventario_neto decimal(28,13) not null,
	punto_medio_inv decimal(28,13) not null,
	
	-- llaves foraneas definidas
	foreign key (fecha_id) references warehouse.dimFecha(fecha_key),
	foreign key (articulo_id) references warehouse.dimArticulo(articulo_key),
	foreign key (bodega_id) references warehouse.dimBodega(bodega_key),
	foreign key (lote_id) references warehouse.dimLote(lote_key),
);

create table warehouse.factTraspaso(
	traspaso_key int primary key identity,
	fecha_id int not null,
	articulo_id int not null,
	lote_id int not null,
	bodega_id int not null,
	traspaso_id int not null,
    fecha_hora_transaccion datetime not null,
	tipo varchar(30) not null,
	naturaleza varchar(30) not null,
	fecha_registro date not null,
	cantidad decimal(28,13) not null,
	existencia_minima decimal(28,13) not null,
	existencia_maxima decimal(28,13) not null,
	cantidad_disponible_bruta decimal(28,13) not null,
	cantidad_disponible_neta decimal(28,13) not null,
	costo_unitario decimal(28,13) not null,
	costo_total decimal(28,13) not null,

	-- llaves foraneas definidas
	foreign key (fecha_id) references warehouse.dimFecha(fecha_key),
	foreign key (articulo_id) references warehouse.dimArticulo(articulo_key),
	foreign key (lote_id) references warehouse.dimLote(lote_key),
	foreign key (bodega_id) references warehouse.dimBodega(bodega_key),
);

CREATE TABLE warehouse.factVenta (
    venta_key INT NOT NULL,
    fecha_id INT NOT NULL,
    articulo_id INT NOT NULL,
    bodega_id INT NOT NULL,
    cliente_id INT NOT NULL,
    lote_id INT NOT NULL,
    venta_id INT NOT NULL,
    detalle_venta_id INT NOT NULL,
    fecha_hora_transaccion DATETIME NOT NULL,
    tipo_movimiento VARCHAR(15) NOT NULL,
    cantidad DECIMAL(28, 13) NOT NULL,
    precio_local DECIMAL(28, 13) NOT NULL,
    costo DECIMAL(28, 13) NOT NULL,
    existencia_minima DECIMAL(28, 13) NOT NULL,
    existencia_maxima DECIMAL(28, 13) NOT NULL,
    costo_articulos_vendido DECIMAL(28, 13) NOT NULL,
    cantidad_disponible_neta DECIMAL(28, 13) NOT NULL,
    costo_por_venta DECIMAL(28, 13) NOT NULL,
    precio_total DECIMAL(28, 13) NOT NULL,
    margen_venta_dinero DECIMAL(28, 13) NOT NULL,
    margen_porcentual DECIMAL(28, 13) NOT NULL,

    	-- llaves foraneas definidas
    foreign key (cliente_id) references warehouse.dimClientes(cliente_key),
	foreign key (fecha_id) references warehouse.dimFecha(fecha_key),
	foreign key (articulo_id) references warehouse.dimArticulo(articulo_key),
	foreign key (lote_id) references warehouse.dimLote(lote_key),
	foreign key (bodega_id) references warehouse.dimBodega(bodega_key),
);