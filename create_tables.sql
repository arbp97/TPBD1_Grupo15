create database if not exists automotriz;
use automotriz;

CREATE TABLE `modelo` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` varchar(20) not null
);


CREATE TABLE `proveedor` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` varchar(20) not null,
  `rubro` varchar(20) not null
);


CREATE TABLE `concesionaria` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` varchar(20) not null,
  `direccion` varchar(20) not null
);


CREATE TABLE `insumo` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` varchar(20) not null,
  `descripcion` varchar(20) not null
);


CREATE TABLE `pedido_insumo` (
  `id` INT primary key AUTO_INCREMENT,
  `insumo_id` INT,
  `proveedor_id` INT,
  `cantidad` FLOAT,

foreign key (insumo_id) references insumo(id),
foreign key (proveedor_id) references proveedor(id)
);





CREATE TABLE `vehiculo` (
  `num_chasis` INT AUTO_INCREMENT,
  `modelo_id` INT,
  `finalizado` BIT,
primary key(num_chasis, modelo_id),

constraint fk_modelo foreign key (modelo_id) references modelo(id)
);


CREATE TABLE `linea_montaje` (
  `id` INT AUTO_INCREMENT,
  `modelo_id` INT,
  `vehiculos_mes` FLOAT,
primary key (id, modelo_id),

foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `estacion` (
  `id` INT primary key AUTO_INCREMENT,
  `linea_montaje_id` INT,
  `descripcion` varchar(20) not null,

foreign key (linea_montaje_id) references linea_montaje(id)
);


CREATE TABLE `pedido_venta` (
  `id` INT primary key AUTO_INCREMENT,
  `concesionaria_id` INT,
  `modelo_id` INT,
  `cantidad` INT,
  `fecha_entrega` DATE,

foreign key (concesionaria_id) references concesionaria(id),
foreign key (modelo_id) references modelo(id)
);


CREATE TABLE `proveedor_x_insumo` (
  `insumo_id` INT,
  `proveedor_id` INT,
  `precio` FLOAT,
primary key (insumo_id, proveedor_id),

foreign key (insumo_id) references insumo(id),
foreign key (proveedor_id) references proveedor(id)
);


CREATE TABLE `vehiculo_x_estacion` (
  `vehiculo_num_chasis` INT,
  `estacion_id` INT,
  `fecha_ingreso` DATETIME,
  `fecha_egreso` DATETIME,
primary key (vehiculo_num_chasis, estacion_id),

foreign key (estacion_id) references estacion (id),
foreign key (vehiculo_num_chasis) references vehiculo (num_chasis)
);


CREATE TABLE `insumo_x_estacion` (
  `estacion_id` INT,
  `insumo_id` INT,
  `cantidad` FLOAT,
primary key(estacion_id, insumo_id),

foreign key (estacion_id) references estacion(id),
foreign key (insumo_id) references insumo(id)
);

