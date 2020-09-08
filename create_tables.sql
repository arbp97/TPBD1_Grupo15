create schema if not exists automotriz;
use automotriz;

CREATE TABLE `pedido_insumo` (
  `id` INT primary key,
  `autoparte_id` INT,
  `proveedor_id` INT,
  `cantidad` FLOAT,

constraint fk_insumo foreign key (autoparte_id) references insumo(id),
constraint fk_modelo foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `insumo` (
  `id` INT primary key,
  `nombre` VARCHAR,
  `descripcion` VARCHAR
);

CREATE TABLE `insumo_x_estacion` (
  `estacion_id` INT,
  `autoparte_id` INT,
  `cantidad` FLOAT,

constraint fk_estacion foreign key (estacion_id) references estacion(id),
constraint fk_insumo foreign key (autoparte_id) references insumo(id)
);

CREATE TABLE `vehiculo` (
  `num_chasis` INT,
  `modelo_id` INT,
  `finalizado` BIT,

constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `proveedor_x_insumo` (
  `insumo_id` INT,
  `proveedor_id` INT,
  `precio` FLOAT

constraint fk_insumo foreign key (insumo_id) references insumo(id),
constraint fk_proveedor foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `pedido_venta` (
  `id` INT primary key,
  `concesionaria_id` INT,
  `modelo_id` INT,
  `cantidad` INT,
  `fecha_entrega` DATE

constraint fk_concesionaria foreign key (concesionaria_id) references concesionaria(id),
constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `linea_montaje` (
  `id` INT primary key,
  `modelo_id` INT,
  `vehiculos_mes` FLOAT,

constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `estacion` (
  `id` INT primary key,
  `linea_montaje_id` INT,
  `descripcion` VARCHAR,

constraint fk_linea_montaje foreign key (linea_montaje_id) linea_montaje(id)
);

CREATE TABLE `vehiculo_x_estacion` (
  `vehiculo_num_chasis` INT,
  `estacion_id` INT,
  `fecha_ingreso` DATETIME,
  `fecha_egreso` DATETIME,

constraint fk_estacion foreign key (estacion_id) estacion (id)
);

CREATE TABLE `concesionaria` (
  `id` INT primary key,
  `nombre` VARCHAR,
  `direccion` VARCHAR
);

CREATE TABLE `proveedor` (
  `id` INT primary key,
  `nombre` VARCHAR,
  `rubro` VARCHAR
);

CREATE TABLE `modelo` (
  `id` INT primary key,
  `nombre` VARCHAR
);

CREATE TABLE terminal
