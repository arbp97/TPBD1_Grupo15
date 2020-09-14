DELIMITER $$

-- CONCESIONARIA

DROP PROCEDURE IF EXISTS alta_concesionaria$$ 
CREATE PROCEDURE alta_concesionaria(nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN

INSERT INTO concesionaria(nombre,direccion)
VALUES(nombre,direccion);

END$$

DROP PROCEDURE IF EXISTS mod_concesionaria$$ 
CREATE PROCEDURE mod_concesionaria(id INT, nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_direccion VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT concesionaria.nombre INTO new_nombre FROM concesionaria WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF direccion IS NULL OR direccion='' THEN	
		SELECT concesionaria.direccion INTO new_direccion FROM concesionaria WHERE id = id;
	ELSE 
		SET new_direccion = direccion;
	END IF;

UPDATE concesionaria
  SET 
    nombre = new_nombre,
    direccion = new_direccion
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_concesionaria$$
CREATE PROCEDURE baja_concesionaria (id INT)
BEGIN

DELETE FROM concesionaria WHERE id = id;

END$$

-- MODELO

DROP PROCEDURE IF EXISTS alta_modelo$$ 
CREATE PROCEDURE alta_modelo(nombre VARCHAR(100))
BEGIN

INSERT INTO modelo(nombre)
VALUES(nombre);

END$$

DROP PROCEDURE IF EXISTS mod_modelo$$ 
CREATE PROCEDURE mod_modelo(id INT, nombre VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT modelo.nombre INTO new_nombre FROM modelo WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;

UPDATE modelo
  SET 
    nombre = new_nombre
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_modelo$$
CREATE PROCEDURE baja_modelo (id INT)
BEGIN

DELETE FROM modelo WHERE id = id;

END$$

-- PROVEEDOR

DROP PROCEDURE IF EXISTS alta_proveedor$$ 
CREATE PROCEDURE alta_proveedor(nombre VARCHAR(100), rubro VARCHAR(100))
BEGIN

INSERT INTO proveedor(nombre,rubro)
VALUES(nombre,rubro);

END$$

DROP PROCEDURE IF EXISTS mod_proveedor$$ 
CREATE PROCEDURE mod_proveedor(id INT, nombre VARCHAR(100), rubro VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_rubro VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT proveedor.nombre INTO new_nombre FROM proveedor WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF rubro IS NULL OR rubro='' THEN	
		SELECT proveedor.rubro INTO new_rubro FROM proveedor WHERE id = id;
	ELSE 
		SET new_rubro = rubro;
	END IF;

UPDATE proveedor
  SET 
    nombre = new_nombre,
    rubro = new_rubro
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_proveedor$$
CREATE PROCEDURE baja_proveedor (id INT)
BEGIN

DELETE FROM proveedor WHERE id = id;

END$$

-- INSUMO
						
DROP PROCEDURE IF EXISTS alta_insumo$$ 
CREATE PROCEDURE alta_insumo(nombre VARCHAR(100), descripcion VARCHAR(100))
BEGIN

INSERT INTO insumo(nombre,descripcion)
VALUES(nombre,descripcion);

END$$

DROP PROCEDURE IF EXISTS mod_insumo$$ 
CREATE PROCEDURE mod_insumo(id INT, nombre VARCHAR(100), descripcion VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_descripcion VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT insumo.nombre INTO new_nombre FROM insumo WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF descripcion IS NULL OR descripcion='' THEN	
		SELECT insumo.descripcion INTO new_descripcion FROM insumo WHERE id = id;
	ELSE 
		SET new_descripcion = descripcion;
	END IF;

UPDATE insumo
  SET 
    nombre = new_nombre,
    descripcion = new_descripcion
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_insumo$$
CREATE PROCEDURE baja_insumo (id INT)
BEGIN

DELETE FROM insumo WHERE id = id;

END$$



-- El Claudio

-- ######## Vehi Culo ########

DROP PROCEDURE IF EXISTS alta_vehiculo$$
CREATE PROCEDURE alta_vehiculo(modid int, pedid int, finbit BIT)
BEGIN
	INSERT INTO vehiculo(modelo_id, pedido_venta_id, finalizado)
	VALUES(modid,pedid,finbit);
END$$
DROP PROCEDURE IF EXISTS baja_vehiculo$$
CREATE PROCEDURE baja_vehiculo(id int)
BEGIN
	DELETE FROM vehiculo WHERE num_chasis = id;
END$$
DROP PROCEDURE IF EXISTS mod_vehiculo$$
CREATE PROCEDURE mod_vehiculo(id int, modid int, pedid int, finbit BIT)
BEGIN
	DECLARE new_modid,new_pedid int;
    DECLARE new_finbit BIT;
    
    IF ISNULL(modid) THEN SELECT modelo_id INTO new_modid FROM vehiculo WHERE num_chasis = id;
    ELSE SET new_modid = modid; END IF;
    IF ISNULL(pedid) THEN SELECT pedido_venta_id INTO new_pedid FROM vehiculo WHERE num_chasis = id;
    ELSE SET new_pedid = pedid; END IF;
    IF ISNULL(finbit) THEN SELECT finalizado INTO new_finbit FROM vehiculo WHERE num_chasis = id;
    ELSE SET new_finbit = finbit; END IF;
    
	UPDATE vehiculo SET
		modelo_id = new_modid,
		pedido_venta_id = new_pedid,
		finalizado = new_finbit
	WHERE num_chasis = id;
END$$



-- ######## Pedido Insumon ########

DROP PROCEDURE IF EXISTS alta_pedido_insumo$$
CREATE PROCEDURE alta_pedido_insumo(insid int, proid int, cant float)
BEGIN
	INSERT INTO pedido_insumo(insumo_id,proveedor_id,cantidad)
	VALUES(insid,proid,cant);
END$$
DROP PROCEDURE IF EXISTS baja_pedido_insumo$$
CREATE PROCEDURE baja_pedido_insumo(id int)
BEGIN
	DELETE FROM pedido_insumo WHERE id = id;
END$$
DROP PROCEDURE IF EXISTS mod_pedido_insumo$$
CREATE PROCEDURE mod_pedido_insumo(id int, insid int, proid int, cant float)
BEGIN
	DECLARE new_insid,new_proid,new_cant int;
    
    IF ISNULL(insid) THEN SELECT insumo_id INTO new_insid FROM pedido_insumo WHERE id = id;
    ELSE SET new_insid = insid; END IF;
    IF ISNULL(proid) THEN SELECT proveedor_id INTO new_proid FROM pedido_insumo WHERE id = id;
    ELSE SET new_proid = proid; END IF;
    IF ISNULL(cant) THEN SELECT cantidad INTO new_cant FROM pedido_insumo WHERE id = id;
    ELSE SET new_cant = cant; END IF;
    
	UPDATE pedido_insumo SET
		insumo_id = new_insid,
		proveedor_id = new_proid,
		cantidad = new_cant
	WHERE id = id;
END$$



-- ######## Vehi Culo Vs. Estacion - Round 1 ########

DROP PROCEDURE IF EXISTS alta_vehiculo_x_estacion$$
CREATE PROCEDURE alta_vehiculo_x_estacion(estid int, indate datetime, outdate datetime)
BEGIN
	INSERT INTO vehiculo_x_estacion(estacion_id, fecha_ingreso, fecha_egreso)
	VALUES(estid,indate,outdate);
END$$
DROP PROCEDURE IF EXISTS baja_vehiculo_x_estacion$$
CREATE PROCEDURE baja_vehiculo_x_estacion(id int)
BEGIN
	DELETE FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = id;
END$$
DROP PROCEDURE IF EXISTS mod_vehiculo_x_estacion$$
CREATE PROCEDURE mod_vehiculo_x_estacion(id int, estid int, indate datetime, outdate datetime)
BEGIN
	DECLARE new_estid int;
    DECLARE new_indate,new_outdate datetime;
    
    IF ISNULL(estid) THEN SELECT estacion_id INTO new_estid FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = id;
    ELSE SET new_estid = estid; END IF;
    IF ISNULL(indate) THEN SELECT fecha_ingreso INTO new_indate FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = id;
    ELSE SET new_indate = indate; END IF;
    -- No hay chequeo para outdate - este puede ser nulo
    
	UPDATE vehiculo_x_estacion SET
		estacion_id = new_estid,
		fecha_ingreso = new_indate,
		fecha_egreso = new_outdate
	WHERE vehiculo_num_chasis = id;
END$$


-- ESTACIÓNOVICH

DROP PROCEDURE IF EXISTS alta_estacion$$
CREATE PROCEDURE alta_estacion (linea_montaje int, descripcion varchar(100))
BEGIN
	INSERT INTO estacion(linea_montaje, descripcion)
	VALUES(linea_montaje, descripcion);
END$$

DROP PROCEDURE IF EXISTS baja_estacion$$
CREATE PROCEDURE baja_estacion(id int)
BEGIN
	DELETE FROM estacion WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_estacion$$
CREATE PROCEDURE mod_estacion(id int, linea_montaje int, descripcion varchar(100))
BEGIN
	DECLARE new_linea_montaje int;
    DECLARE new_descripcion varchar(100);
    
    IF ISNULL(linea_montaje) THEN SELECT linea_montaje INTO new_linea_montaje FROM estacion WHERE id = id;
    ELSE SET new_modid = modid; END IF;
    IF ISNULL(descripcion) THEN SELECT descripcion INTO new_descripcion FROM estacion WHERE id = id;
    ELSE SET new_pedid = pedid; END IF;

    
	UPDATE vehiculo SET
		linea_montaje = new_linea_montaje,
		descripcion = new_descripcion,
	WHERE num_chasis = id;
END$$


DELIMITER ;

