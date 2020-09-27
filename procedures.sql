DELIMITER $$

-- DEBUG / ignore

DROP PROCEDURE IF EXISTS log_msg$$
CREATE PROCEDURE log_msg(msg VARCHAR(255))
BEGIN
    insert into logs select 0, msg;
END$$

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

	IF nombre IS NULL OR nombre='' THEN	-- PASAR A TRIGGER
		SELECT concesionaria.nombre INTO new_nombre FROM concesionaria WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF direccion IS NULL OR direccion='' THEN	-- SAME
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
CREATE PROCEDURE alta_modelo(nombre VARCHAR(100), cantidad_estaciones INT)
BEGIN
	

DECLARE modelo_id INT;
DECLARE linea_montaje_id INT;
DECLARE nInsertados INT;


INSERT INTO modelo(nombre)
VALUES(nombre);

SELECT MAX(id) INTO modelo_id FROM modelo; -- ultima id cargada MAX(id)

CALL alta_linea_montaje(modelo_id);

SELECT MAX(id) INTO linea_montaje_id FROM linea_montaje;


SET nInsertados = 0;

	WHILE nInsertados < cantidad_estaciones DO
	
		CALL alta_estacion(linea_montaje_id, 'add description');
	
		SET nInsertados = nInsertados + 1;
		
	END WHILE;

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

-- VEHICULO

DROP PROCEDURE IF EXISTS alta_vehiculo$$
CREATE PROCEDURE alta_vehiculo(modid int, pedid int, finbit BIT)
BEGIN
	INSERT INTO vehiculo(modelo_id, pedido_venta_id, finalizado)
	VALUES(modid,pedid,finbit);
END$$
DROP PROCEDURE IF EXISTS baja_vehiculo$$
CREATE PROCEDURE baja_vehiculo(id int)
BEGIN
	DECLARE C INT DEFAULT 0;
	DECLARE RES INT DEFAULT 0;
    DECLARE MSG VARCHAR(69) DEFAULT "";
    SELECT COUNT(num_chasis) INTO C FROM vehiculo WHERE vehiculo.num_chasis = id;
    IF (C = 0) THEN
		SET RES = -69;
        SET MSG = "Pero eso no existe, pelotudo";
		-- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pero eso no existe, pelotudo';
	ELSE
		DELETE FROM vehiculo WHERE num_chasis = id;
    END IF;
    SELECT RES AS nResultado, MSG as cMensaje;
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

-- PEDIDO_INSUMO

DROP PROCEDURE IF EXISTS alta_pedido_insumo$$
CREATE PROCEDURE alta_pedido_insumo(insid int, proid int, cant float)
BEGIN
	INSERT INTO pedido_insumo(insumo_id,proveedor_id,cantidad)
	VALUES(insid,proid,cant);
END$$
DROP PROCEDURE IF EXISTS baja_pedido_insumo$$
CREATE PROCEDURE baja_pedido_insumo(id int)
BEGIN
	DECLARE C INT DEFAULT 0;
	DECLARE RES INT DEFAULT 0;
    DECLARE MSG VARCHAR(69) DEFAULT "";
    SELECT COUNT(id) INTO C FROM pedido_insumo WHERE id = id;
    IF (C = 0) THEN
		SET RES = -420;
        SET MSG = "No se encontraron pedido_insumos con esa ID";
	ELSE
		DELETE FROM pedido_insumo WHERE id = id;
    END IF;
    SELECT RES AS nResultado, MSG as cMensaje;
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

-- VEHICULO_X_ESTACION

DROP PROCEDURE IF EXISTS alta_vehiculo_x_estacion$$
CREATE PROCEDURE alta_vehiculo_x_estacion(chaid int, estid int, indate datetime, outdate datetime)
BEGIN
	INSERT INTO vehiculo_x_estacion(vehiculo_num_chasis, estacion_id, fecha_ingreso, fecha_egreso)
	VALUES(chaid,estid,indate,outdate);
END$$
DROP PROCEDURE IF EXISTS baja_vehiculo_x_estacion$$
CREATE PROCEDURE baja_vehiculo_x_estacion(chasisid int, stationid int)
BEGIN
	DECLARE C INT DEFAULT 0;
	DECLARE RES INT DEFAULT 0;
    DECLARE MSG VARCHAR(69) DEFAULT "";
    SELECT COUNT(id) INTO C FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = chasisid AND estacion_id = stationid;
    IF (C = 0) THEN
		SET RES = -666;
        SET MSG = "No se encuentran resultados para el par de IDs";
	ELSE
		-- DELETE FROM pedido_insumo WHERE id = id;
        DELETE FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = chasisid AND estacion_id = stationid;
    END IF;
    SELECT RES AS nResultado, MSG as cMensaje;
END$$
DROP PROCEDURE IF EXISTS mod_vehiculo_x_estacion$$
CREATE PROCEDURE mod_vehiculo_x_estacion(oldcarid int, oldestid int, nextcarid int, nextestid int, indate datetime, outdate datetime)
BEGIN
	-- oldX: Se modificara la entrada que tenga este par de PKs
    -- newX: Si se modifica el valor de alguna PK, a cual
	DECLARE new_estid,new_carid int;
    DECLARE new_indate,new_outdate datetime;
    
    IF ISNULL(nextcarid) THEN SET new_carid = oldcarid; ELSE SET new_carid = nextcarid; END IF;
    IF ISNULL(nextestid) THEN SET new_estid = oldestid; ELSE SET new_estid = nextestid; END IF;
    IF ISNULL(indate) THEN SELECT fecha_ingreso INTO new_indate FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = id;
    ELSE SET new_indate = indate; END IF;
    -- No hay chequeo para outdate - este puede ser nulo
    
	UPDATE vehiculo_x_estacion SET
		vehiculo_num_chasis = new_carid,
		estacion_id = new_estid,
		fecha_ingreso = new_indate,
		fecha_egreso = new_outdate
	WHERE vehiculo_num_chasis = oldcarid AND estacion_id = oldestid;
END$$


-- ESTACIÓN

DROP PROCEDURE IF EXISTS alta_estacion$$
CREATE PROCEDURE alta_estacion (linea_montaje_id int, descripcion varchar(100))
BEGIN
	INSERT INTO estacion(linea_montaje_id, descripcion)
	VALUES(linea_montaje_id, descripcion);
END$$

DROP PROCEDURE IF EXISTS baja_estacion$$
CREATE PROCEDURE baja_estacion(id int)
BEGIN
	DELETE FROM estacion WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_estacion$$
CREATE PROCEDURE mod_estacion(id int, linea_montaje_id int, descripcion varchar(100))
BEGIN
	DECLARE new_linea_montaje_id int;
    DECLARE new_descripcion varchar(100);
    
    IF ISNULL(linea_montaje_id) THEN SELECT linea_montaje_id INTO new_linea_montaje_id FROM estacion WHERE id = id;
    ELSE SET new_linea_montaje_id = linea_montaje_id; END IF;
    IF ISNULL(descripcion) THEN SELECT descripcion INTO new_descripcion FROM estacion WHERE id = id;
    ELSE SET new_descripcion = descripcion; END IF;

    
	UPDATE estacion SET
		linea_montaje_id = new_linea_montaje_id,
		descripcion = new_descripcion
	WHERE id = id;
END$$


-- DETALLE_VENTA

DROP PROCEDURE IF EXISTS alta_detalle_venta$$
CREATE PROCEDURE alta_detalle_venta (pedido_venta_id int, modelo_id int, cantidad int)
BEGIN
	INSERT INTO detalle_venta(pedido_venta_id, modelo_id, cantidad)
	VALUES(pedido_venta_id, modelo_id, cantidad);
END$$

DROP PROCEDURE IF EXISTS baja_detalle_venta$$
CREATE PROCEDURE baja_detalle_venta(id int)
BEGIN
	DELETE FROM detalle_venta WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_detalle_venta$$
CREATE PROCEDURE mod_detalle_venta(id int, pedido_venta_id int, modelo_id int, cantidad int)
BEGIN
	DECLARE new_pedido_venta_id int;
    DECLARE new_modelo_id int;
    DECLARE new_cantidad int;
    
    IF ISNULL(pedido_venta_id) THEN SELECT pedido_venta_id INTO new_pedido_venta_id FROM detalle_venta WHERE id = id;
    ELSE SET new_pedido_venta_id = pedido_venta_id; END IF;
    IF ISNULL(modelo_id) THEN SELECT modelo_id INTO new_modelo_id FROM detalle_venta WHERE id = id;
    ELSE SET new_modelo_id = modelo_id; END IF;
	IF ISNULL(cantidad) THEN SELECT cantidad INTO new_cantidad FROM detalle_venta WHERE id = id;
    ELSE SET new_cantidad = cantidad; END IF;


    
	UPDATE detalle_venta SET
		pedido_venta_id = new_pedido_venta_id,
                modelo_id = new_modelo_id,
		cantidad = new_cantidad
	WHERE id = id;
END$$

-- PEDIDO_VENTA

DROP PROCEDURE IF EXISTS alta_pedido_venta$$
CREATE PROCEDURE alta_pedido_venta (concesionaria_id INT)
BEGIN
	INSERT INTO pedido_venta(concesionaria_id)
	VALUES(concesionaria_id);
END$$

DROP PROCEDURE IF EXISTS baja_pedido_venta$$
CREATE PROCEDURE baja_pedido_venta(id int)
BEGIN
	DELETE FROM pedido_venta WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_pedido_venta$$
CREATE PROCEDURE mod_pedido_venta(id int, concesionaria_id int)
BEGIN
	DECLARE new_concesionaria_id int;
    
    IF ISNULL(concesionaria_id) THEN SELECT concesionaria_id INTO new_concesionaria_id FROM pedido_venta WHERE id = id;
    ELSE SET new_concesionaria_id = concesionaria_id; END IF;
    
	UPDATE pedido_venta SET
		concesionaria_id = new_concesionaria_id
	WHERE id = id;
END$$

-- LINEA_MONTAJE

DROP PROCEDURE IF EXISTS alta_linea_montaje$$
CREATE PROCEDURE alta_linea_montaje (modelo_id int)
BEGIN
	INSERT INTO linea_montaje(modelo_id, vehiculos_mes)
	VALUES(modelo_id, 0);
END$$

DROP PROCEDURE IF EXISTS baja_linea_montaje$$
CREATE PROCEDURE baja_linea_montaje(id int)
BEGIN
	DELETE FROM linea_montaje WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_linea_montaje$$
CREATE PROCEDURE mod_linea_montaje(id int, vehiculos_mes int,modelo_id int)
BEGIN
	DECLARE new_vehiculos_mes int;
    DECLARE new_modelo_id int;
    
    IF ISNULL(vehiculos_mes) THEN SELECT vehiculos_mes INTO new_vehiculos_mes FROM linea_montaje WHERE id = id;
    ELSE SET new_vehiculos_mes = vehiculos_mes; END IF;
    IF ISNULL(modelo_id) THEN SELECT modelo_id INTO new_modelo_id FROM linea_montaje WHERE id = id;
    ELSE SET new_modelo_id = modelo_id; END IF;

    
	UPDATE linea_montaje SET
		vehiculos_mes = new_vehiculos_mes,
        modelo_id = new_modelo_id
	WHERE id = id;
END$$


-- BUSINESS

DROP PROCEDURE IF EXISTS comenzar_ensamblado$$
CREATE PROCEDURE comenzar_ensamblado(pedido_venta_id INT)
BEGIN

	DECLARE finished INT DEFAULT 0;
	DECLARE nCantidad INT; 
	DECLARE nModelo_id INT;
	DECLARE nInsertados INT;

	DECLARE cursor_detalle_venta
        CURSOR FOR
            SELECT modelo_id, cantidad FROM detalle_venta WHERE detalle_venta.pedido_venta_id = pedido_venta_id;
 	
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
       
    -- CALL log_msg('help'); 
  
    OPEN cursor_detalle_venta;
   
    getDetalle: LOOP

        FETCH cursor_detalle_venta INTO nModelo_id, nCantidad;
      	
        IF finished = 1 THEN
            LEAVE getDetalle;
		END IF;

		SET nInsertados = 0;

		WHILE nInsertados < nCantidad DO
		
		CALL alta_vehiculo(nModelo_id, pedido_venta_id, 0);
	
		SET nInsertados = nInsertados + 1;
	
		END WHILE;

    END LOOP getDetalle;

    CLOSE cursor_detalle_venta;
END$$


DELIMITER ;

