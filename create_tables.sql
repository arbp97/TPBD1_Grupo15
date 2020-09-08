create schema if not exists automotriz;
use automotriz;

CREATE TABLE `pedido_insumo` (
  `id` INT,
  `autoparte_id` INT,
  `proveedor_id` INT,
  `cantidad` FLOAT
);

CREATE TABLE `insumo` (
  `id` INT,
  `nombre` VARCHAR,
  `descripcion` VARCHAR
);

CREATE TABLE `insumo_x_estacion` (
  `estacion_id` INT,
  `autoparte_id` INT,
  `cantidad` FLOAT
);

CREATE TABLE `vehiculo` (
  `num_chasis` INT,
  `modelo_id` INT,
  `finalizado` BIT
);

CREATE TABLE `proveedor_x_insumo` (
  `insumo_id` INT,
  `proveedor_id` INT,
  `precio` FLOAT
);

CREATE TABLE `pedido_venta` (
  `id` INT,
  `concesionaria_id` INT,
  `modelo_id` INT,
  `cantidad` INT,
  `fecha_entrega` DATE
);

CREATE TABLE `linea_montaje` (
  `id` INT,
  `modelo_id` INT,
  `vehiculos_mes` FLOAT
);

CREATE TABLE `estacion` (
  `id` INT,
  `linea_montaje_id` INT,
  `descripcion` VARCHAR
);

CREATE TABLE `vehiculo_x_estacion` (
  `vehiculo_num_chasis` INT,
  `estacion_id` INT,
  `fecha_ingreso` DATETIME,
  `fecha_egreso` DATETIME
);

CREATE TABLE `concesionaria` (
  `id` INT,
  `nombre` VARCHAR,
  `direccion` VARCHAR
);

CREATE TABLE `proveedor` (
  `id` INT,
  `nombre` VARCHAR,
  `rubro` VARCHAR
);

CREATE TABLE `modelo` (
  `id` INT,
  `nombre` VARCHAR
);

