create schema if not exists automotriz;
use automotriz;

CREATE TABLE `pedido_insumo` (
  `id` INT AUTO_INCREMENT,
  `autoparte_id` INT,
  `proveedor_id` INT,
  `cantidad` FLOAT,
primary key(id, autoparte_id, proveedor_id),

constraint fk_insumo foreign key (autoparte_id) references insumo(id),
constraint fk_modelo foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `insumo` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` VARCHAR,
  `descripcion` VARCHAR
);

CREATE TABLE `insumo_x_estacion` (
  `estacion_id` INT,
  `autoparte_id` INT,
  `cantidad` FLOAT,
primary key(estacion_id, autoparte_id),

constraint fk_estacion foreign key (estacion_id) references estacion(id),
constraint fk_insumo foreign key (autoparte_id) references insumo(id)
);

CREATE TABLE `vehiculo` (
  `num_chasis` INT AUTO_INCREMENT,
  `modelo_id` INT,
  `finalizado` BIT,
primary key(num_chasis, modelo_id),

constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `proveedor_x_insumo` (
  `insumo_id` INT,
  `proveedor_id` INT,
  `precio` FLOAT
primary key (insumo_id, proveedor_id),

constraint fk_insumo foreign key (insumo_id) references insumo(id),
constraint fk_proveedor foreign key (proveedor_id) references proveedor(id)
);

CREATE TABLE `pedido_venta` (
  `id` INT primary key AUTO_INCREMENT,
  `concesionaria_id` INT,
  `modelo_id` INT,
  `cantidad` INT,
  `fecha_entrega` DATE
primary key (id, concesionaria_id, modelo_id),

constraint fk_concesionaria foreign key (concesionaria_id) references concesionaria(id),
constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `linea_montaje` (
  `id` INT primary key AUTO_INCREMENT,
  `modelo_id` INT,
  `vehiculos_mes` FLOAT,
primary key (id, modelo_id),

constraint fk_modelo foreign key (modelo_id) references modelo(id)
);

CREATE TABLE `estacion` (
  `id` INT primary key AUTO_INCREMENT,
  `linea_montaje_id` INT,
  `descripcion` VARCHAR,
primary key (id, linea_montaje_id),

constraint fk_linea_montaje foreign key (linea_montaje_id) linea_montaje(id)
);

CREATE TABLE `vehiculo_x_estacion` (
  `vehiculo_num_chasis` INT,
  `estacion_id` INT,
  `fecha_ingreso` DATETIME,
  `fecha_egreso` DATETIME,
primary key (vehiculo_num_chasis, estacion_id),

constraint fk_estacion foreign key (estacion_id) estacion (id),
constraint fk_vehiculo foreign key (vehiculo_num_chasis) vehiculo (num_chasis)
);

CREATE TABLE `concesionaria` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` VARCHAR,
  `direccion` VARCHAR
);

CREATE TABLE `proveedor` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` VARCHAR,
  `rubro` VARCHAR
);

CREATE TABLE `modelo` (
  `id` INT primary key AUTO_INCREMENT,
  `nombre` VARCHAR
);

CREATE TABLE terminal
