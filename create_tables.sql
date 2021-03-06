drop database if exists automotriz;
create database if not exists automotriz;
use automotriz;

-- DEBUG / ignore

CREATE TABLE `logs` (
	`id` INT primary key AUTO_INCREMENT,
	`msg` VARCHAR(255)
);

-- Tablas base

CREATE TABLE `concesionaria` (
	`id` INT primary key AUTO_INCREMENT,
	`nombre` varchar(100) not null,
	`direccion` varchar(100) not null
);

CREATE TABLE `modelo` (
	`id` INT primary key AUTO_INCREMENT,
	`nombre` varchar(100) not null
);

CREATE TABLE `proveedor` (
	`id` INT primary key AUTO_INCREMENT,
	`nombre` varchar(100) not null,
	`rubro` varchar(100) not null
);

CREATE TABLE `insumo` (
	`id` INT primary key AUTO_INCREMENT,
	`nombre` varchar(100) not null,
	`descripcion` varchar(100) not null
);


-- Y el resto

CREATE TABLE `pedido_venta` (
	`id` INT primary key AUTO_INCREMENT,
	`concesionaria_id` int not null,
	`fecha_entrega` date,
	`finalizado` bit not null DEFAULT 0,
	foreign key (concesionaria_id) references concesionaria(id)
);

CREATE TABLE `detalle_venta` (
	`id` INT primary key AUTO_INCREMENT,
	`pedido_venta_id` int not null,
	`modelo_id` int not null,
	`cantidad` int not null,
	foreign key (pedido_venta_id) references pedido_venta(id),
	foreign key (modelo_id) references modelo(id) -- Si?
);

CREATE TABLE `linea_montaje` (
	`id` INT primary key AUTO_INCREMENT,
	`modelo_id` int not null,
	`vehiculos_mes` float not null,
	foreign key (modelo_id) references modelo(id)
);


CREATE TABLE `estacion` (
	`id` INT not null,
	`linea_montaje_id` int not null,
	`descripcion` varchar(100) not null,
	primary key (id, linea_montaje_id),
	foreign key (linea_montaje_id) references linea_montaje(id)
);

CREATE TABLE `vehiculo` (
	`num_chasis` INT primary key AUTO_INCREMENT,
	`modelo_id` int not null,
	`pedido_venta_id` int not null,
	`finalizado` bit not null,
	foreign key (modelo_id) references modelo(id),
	foreign key (pedido_venta_id) references pedido_venta(id)
);
CREATE UNIQUE INDEX index_auto ON vehiculo ( num_chasis,pedido_venta_id );


-- tabla X tabla

CREATE TABLE `pedido_insumo` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`insumo_id` int not null,
	`proveedor_id` int not null,
	`cantidad` float not null,
	foreign key (insumo_id) references insumo(id),
	foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `proveedor_x_insumo` (
	`insumo_id` int not null,
	`proveedor_id` int not null,
	primary key (insumo_id, proveedor_id),
	`precio` float not null,
	foreign key (insumo_id) references insumo(id),
	foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `insumo_x_estacion` (
	`estacion_id` int not null,
	`linea_montaje_id` int not null,
	`insumo_id` int not null,
	primary key (estacion_id, linea_montaje_id, insumo_id),
	`cantidad` float not null,
	foreign key (estacion_id) references estacion(id),
	foreign key (linea_montaje_id) references linea_montaje(id),
	foreign key (insumo_id) references insumo(id)
);

CREATE TABLE `vehiculo_x_estacion` (
	`vehiculo_num_chasis` int not null,
	`estacion_id` int not null,
	`linea_montaje_id` int not null,
	primary key (vehiculo_num_chasis, estacion_id, linea_montaje_id),
	`fecha_ingreso` datetime not null,
  `fecha_egreso` datetime,
	foreign key (vehiculo_num_chasis) references vehiculo(num_chasis),
	foreign key (linea_montaje_id) references linea_montaje(id),
	foreign key (estacion_id) references estacion(id)
);
