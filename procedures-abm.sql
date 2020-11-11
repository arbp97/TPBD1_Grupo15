use automotriz;

DELIMITER $$

/*
DROP PROCEDURE IF EXISTS TESTalta_concesionaria $$ 
CREATE PROCEDURE TESTalta_concesionaria(id int, cNombre VARCHAR(100), cDireccion VARCHAR(100))
proc: BEGIN
	CALL proxy_errorOnDuplicate("concesionaria", "id", id, null);
	IF @result = true THEN LEAVE proc; END IF;
    
	IF cNombre IS NULL OR cNombre='' OR cDireccion IS NULL OR cDireccion='' THEN
		CALL throwMsg(-1, "Verifique los valores de sus parametros");
        LEAVE proc;
	END IF;
	
	INSERT INTO concesionaria(id,nombre,direccion)
	VALUES(id,cNombre,cDireccion);

	CALL throwMsg(0, "");
END $$
*/
-- CONCESIONARIA ----------------------------------------------------------------------

-- Error: que falte un dato
DROP PROCEDURE IF EXISTS alta_concesionaria $$ 
CREATE PROCEDURE alta_concesionaria(cNombre VARCHAR(100), cDireccion VARCHAR(100))
proc: BEGIN
	IF cNombre IS NULL OR cNombre='' OR cDireccion IS NULL OR cDireccion='' THEN
		CALL throwMsg(-1, "Verifique los valores de sus parametros");
        LEAVE proc;
	END IF;
	
	INSERT INTO concesionaria(nombre,direccion)
	VALUES(cNombre,cDireccion);

	CALL throwMsg(0, "");
END $$

-- errores: que la concesionaria no exista, que falte un dato, usar caracteres inválidos (números, signos)
    
    
DROP PROCEDURE IF EXISTS mod_concesionaria $$ 
CREATE PROCEDURE mod_concesionaria(nId INT, cNombre VARCHAR(100), cDireccion VARCHAR(100))
proc: BEGIN
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewDireccion VARCHAR(100);
    
	CALL proxy_errorOnMissing("concesionaria", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	IF cNombre IS NULL OR cNombre='' THEN	
		SELECT concesionaria.nombre INTO cNewNombre FROM concesionaria WHERE id = nId;
	ELSE 
		SET cNewNombre = cNombre;
	END IF;
	IF cDireccion IS NULL OR cDireccion='' THEN
		SELECT concesionaria.direccion INTO cNewDireccion FROM concesionaria WHERE id = nId;
	ELSE 
		SET cNewDireccion = cDireccion;
	END IF;
	
	UPDATE concesionaria SET 
		nombre = cNewNombre,
		direccion = cNewDireccion
	WHERE id = nId;

	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_concesionaria $$
CREATE PROCEDURE baja_concesionaria (nId INT)
proc: BEGIN

	CALL proxy_errorOnMissing("concesionaria", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	DELETE FROM concesionaria WHERE id = nId;

	CALL throwMsg(0, "");
END $$

-- MODELO ------------------------------------------------------------------------------------

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_modelo $$ 
CREATE PROCEDURE alta_modelo(cNombre VARCHAR(100), nCantidadEstaciones INT)
proc: BEGIN
	DECLARE nModeloId INT;
	DECLARE nLineaMontajeId INT;
	DECLARE nInsertados INT;
	
	IF cNombre IS NULL OR cNombre='' THEN
        CALL throwMsg(-1, "Inserte un nombre para el modelo");
        LEAVE proc;
	END IF;
	IF nCantidadEstaciones < 1 OR nCantidadEstaciones IS NULL THEN
        CALL throwMsg(-1, "Se necesita 1 estacion como minimo");
        LEAVE proc;
	END IF;
		
	INSERT INTO modelo(nombre) VALUES(cNombre);
	
	SELECT MAX(id) INTO nModeloId FROM modelo; -- ultima id cargada MAX(id)
	
	CALL alta_linea_montaje(nModeloId);
	
	SELECT MAX(id) INTO nLineaMontajeId FROM linea_montaje;
	
	SET nInsertados = 0;
	
	WHILE nInsertados < nCantidadEstaciones DO
		CALL alta_estacion(nInsertados, nLineaMontajeId, 'descripcion');
		SET nInsertados = nInsertados + 1;
	END WHILE;

	CALL throwMsg(0, "");
END $$

-- errores: que el modelo no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_modelo $$ 
CREATE PROCEDURE mod_modelo(nId INT, cNombre VARCHAR(100))
proc: BEGIN
	DECLARE cNewNombre VARCHAR(100);

	CALL proxy_errorOnMissing("modelo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF cNombre IS NULL OR cNombre='' THEN	
		SELECT modelo.nombre INTO cNewNombre FROM modelo WHERE id = nId;
	ELSE 
		SET cNewNombre = cNombre;
	END IF;
	
	UPDATE modelo
		SET nombre = cNewNombre
	WHERE id = nId;
	
	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_modelo $$
CREATE PROCEDURE baja_modelo (nId INT)
proc: BEGIN
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	CALL proxy_errorOnMissing("modelo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	DELETE FROM modelo WHERE id = nId;

	CALL throwMsg(0, "");
END $$

-- PROVEEDOR ------------------------------------------------------------------------

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_proveedor $$ 
CREATE PROCEDURE alta_proveedor(cNombre VARCHAR(100), cRubro VARCHAR(100))
proc: BEGIN
    IF strNullOrEmpty(cNombre) THEN
		CALL throwMsg(-1, "Inserte un nombre para el proveedor"); LEAVE proc;
    END IF;
    IF strNullOrEmpty(cRubro) THEN
		CALL throwMsg(-1, "Inserte un nombre para el proveedor"); LEAVE proc;
    END IF;

	INSERT INTO proveedor(nombre,rubro)
		VALUES(cNombre,cRubro);

	CALL throwMsg(0, "");
END $$

-- errores: que el proveedor no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_proveedor $$ 
CREATE PROCEDURE mod_proveedor(nId INT, cNombre VARCHAR(100), cRubro VARCHAR(100))
proc: BEGIN
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewRubro VARCHAR(100);

	CALL proxy_errorOnMissing("proveedor", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF cNombre IS NULL OR cNombre='' THEN	
		SELECT proveedor.nombre INTO cNewNombre FROM proveedor WHERE id = nId;
	ELSE 
		SET cNewNombre = cNombre;
	END IF;
    
	IF cRubro IS NULL OR cRubro='' THEN	
		SELECT proveedor.rubro INTO cNewRubro FROM proveedor WHERE id = nId;
	ELSE 
		SET cNewRubro = cRubro;
	END IF;
	
	UPDATE proveedor
	SET 
		nombre = cNewNombre,
		rubro = cNewRubro
	WHERE id = nId;

	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_proveedor $$
CREATE PROCEDURE baja_proveedor (nId INT)
proc: BEGIN
	CALL proxy_errorOnMissing("proveedor", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	DELETE FROM proveedor WHERE id = nId;

	CALL throwMsg(0, "");
END $$

-- INSUMO ---------------------------------------------------------------------------------

-- error: que falte un dato
						
DROP PROCEDURE IF EXISTS alta_insumo $$ 
CREATE PROCEDURE alta_insumo(cNombre VARCHAR(100), cDescripcion VARCHAR(100))
proc: BEGIN

	IF strNullOrEmpty(cNombre) THEN	
		CALL throwMsg(-1, "Inserte un nombre para el insumo");
        LEAVE proc;
	END IF;
    
	INSERT INTO insumo(nombre,descripcion)
	VALUES(cNombre,cDescripcion);

	CALL throwMsg(0, "");
END $$

-- errores: que el insumo no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_insumo $$
CREATE PROCEDURE mod_insumo(nId INT, cNombre VARCHAR(100), cDescripcion VARCHAR(100))
proc: BEGIN
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewDescripcion VARCHAR(100);
    
	CALL proxy_errorOnMissing("insumo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF cNombre IS NULL OR cNombre='' THEN	
		SELECT insumo.nombre INTO cNewNombre FROM insumo WHERE id = nId;
	ELSE 
		SET cNewNombre = cNombre;
	END IF;
	IF cDescripcion IS NULL OR cDescripcion='' THEN	
		SELECT insumo.descripcion INTO cNewDescripcion FROM insumo WHERE id = nId;
	ELSE 
		SET cNewDescripcion = cDescripcion;
	END IF;

	UPDATE insumo
	SET 
		nombre = cNewNombre,
		descripcion = cNewDescripcion
	WHERE id = nId;

	CALL throwMsg(0, "");
END	$$

DROP PROCEDURE IF EXISTS baja_insumo $$
CREATE PROCEDURE baja_insumo (nId INT)
proc: BEGIN
	CALL proxy_errorOnMissing("insumo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	DELETE FROM insumo WHERE id = nId;

	CALL throwMsg(0, "");
END	$$

-- VEHICULO ------------------------------------------------------------------------------------

-- Error: que falte un dato

DROP PROCEDURE IF EXISTS alta_vehiculo$$
CREATE PROCEDURE alta_vehiculo(nModeloId int, nPedidoId int, bFinalizado BIT)
proc: BEGIN
	
    if nModeloId IS NULL OR nPedidoId IS NULL OR bFinalizado IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
    
	INSERT INTO vehiculo(modelo_id, pedido_venta_id, finalizado)
	VALUES(nModeloId,nPedidoId,bFinalizado);
    
	CALL throwMsg(0, "");
END$$

DROP PROCEDURE IF EXISTS baja_vehiculo$$
CREATE PROCEDURE baja_vehiculo(nId int)
proc: BEGIN
	CALL proxy_errorOnMissing("vehiculo", "num_chasis", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    -- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pero eso no existe, pelotudo';

	DELETE FROM vehiculo WHERE num_chasis = id;

	CALL throwMsg(0, "");
END$$

-- errores: que el vehículo no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_vehiculo$$
CREATE PROCEDURE mod_vehiculo(nId int, nModeloId int, nPedidoId int, bFinalizado BIT)
proc: BEGIN
	DECLARE nNewModeloId,nNewPedidoId int;
	DECLARE bNewFinalizado BIT;

	CALL proxy_errorOnMissing("vehiculo", "num_chasis", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF ISNULL(nModeloId) THEN
		SELECT modelo_id INTO nNewModeloId FROM vehiculo WHERE num_chasis = nId;
	ELSE 
		SET nNewModeloId = nModeloId; 
	END IF;
	
	IF ISNULL(nPedidoId) THEN
		SELECT pedido_venta_id INTO nNewPedidoId FROM vehiculo WHERE num_chasis = nId;
	ELSE 
		SET nNewPedidoId = nPedidoId; 
	END IF;
	
	IF ISNULL(bFinalizado) THEN
		SELECT finalizado INTO bNewFinalizado FROM vehiculo WHERE num_chasis = nId;
	ELSE 
		SET bNewFinalizado = bFinalizado; 
	END IF;
    
	UPDATE vehiculo SET
		modelo_id = nNewModeloId,
		pedido_venta_id = nNewPedidoId,
		finalizado = bNewFinalizado
	WHERE num_chasis = nId;
	
    CALL throwMsg(0, "");
END$$

-- PEDIDO_INSUMO

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_pedido_insumo$$
CREATE PROCEDURE alta_pedido_insumo(nInsumoId int, nProveedorId int, fCantidad float)
proc: BEGIN
    IF nInsumoId IS NULL OR nProveedorId IS NULL OR fCantidad IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
    
	INSERT INTO pedido_insumo(insumo_id,proveedor_id,cantidad)
	VALUES(nInsumoId,nProveedorId,fCantidad);
	
    CALL throwMsg(0, "");
END$$

DROP PROCEDURE IF EXISTS baja_pedido_insumo$$
CREATE PROCEDURE baja_pedido_insumo(nId int)
proc: BEGIN
	CALL proxy_errorOnMissing("pedido_insumo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	DELETE FROM pedido_insumo WHERE id = nId;
	
	CALL throwMsg(0, "");
END$$

-- errores: que el pedido no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_pedido_insumo$$
CREATE PROCEDURE mod_pedido_insumo(nId int, nInsumoId int, nProveedorId int, fCantidad float)
proc: BEGIN
    DECLARE nNewInsumoId,nNewProveedorId,fNewCantidad int;
    
	CALL proxy_errorOnMissing("pedido_insumo", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
	
	IF ISNULL(nInsumoId) THEN 
		SELECT insumo_id INTO nNewInsumoId FROM pedido_insumo WHERE id = nId;
	ELSE 
		SET nNewInsumoId = nInsumoId;
	END IF;
	
	IF ISNULL(nProveedorId) THEN
		SELECT proveedor_id INTO nNewProveedorId FROM pedido_insumo WHERE id = nId;
	ELSE 
		SET nNewProveedorId = nProveedorId; 
	END IF;
	
	IF ISNULL(fCantidad) THEN 
		SELECT cantidad INTO fNewCantidad FROM pedido_insumo WHERE id = nId;
	ELSE 
		SET fNewCantidad = fCantidad; 
	END IF;
    
	UPDATE pedido_insumo SET
		insumo_id = nNewInsumoId,
		proveedor_id = nNewProveedorId,
		cantidad = fNewCantidad
	WHERE id = nId;
    
	CALL throwMsg(0, "");
END$$

-- VEHICULO_X_ESTACION

-- error: que falte un dato, que la fecha de egreso sea anterior a la de ingreso

DROP PROCEDURE IF EXISTS alta_vehiculo_x_estacion$$
CREATE PROCEDURE alta_vehiculo_x_estacion(nChasisId int, nEstacionId int, nLineaMontajeId int, dInDate datetime, dOutDate datetime)
proc: BEGIN
	-- TODO: Talvez tirar error si se ingresan IDs que no existen en las respectivas tablas? Esto repetido para las otras
    -- TODO: dInDate < dOutDate
	IF nChasisId IS NULL OR nEstacionId IS NULL OR dInDate IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
   
	INSERT INTO vehiculo_x_estacion(vehiculo_num_chasis, estacion_id, linea_montaje_id, fecha_ingreso, fecha_egreso)
	VALUES(nChasisId,nEstacionId,nLineaMontajeId,dInDate,dOutDate);

	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_vehiculo_x_estacion$$
CREATE PROCEDURE baja_vehiculo_x_estacion(nChasisId int, nEstacionId int, nLineaMontajeId int)
proc: BEGIN
	
	DECLARE C INT DEFAULT 0;
	
    SELECT COUNT(id) INTO C FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = nChasisId AND estacion_id = nEstacionId AND linea_montaje_id = nLineaMontajeId;
    IF (C = 0) THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
	END IF;
	
    DELETE FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = nChasisId AND estacion_id = nEstacionId AND linea_montaje_id = nLineaMontajeId;

    CALL throwMsg(0, "");
END $$

-- errores: que el vehículo o la estación no existan, que falte un dato, usar caracteres inválidos (números, signos)
-- TODO: eso, y tener en cuenta nLineaMontajeId como en los procedimientos de arriba
DROP PROCEDURE IF EXISTS mod_vehiculo_x_estacion $$
 CREATE PROCEDURE mod_vehiculo_x_estacion(nChasisId int, nLineaMontajeId int, nEstacionId int, dFechaIngreso datetime, dFechaEgreso datetime)
proc: BEGIN
    
	DECLARE C INT DEFAULT 0;
	DECLARE dNewFechaIngreso datetime;

	SELECT COUNT(vehiculo_num_chasis) INTO C FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = nChasisId AND linea_montaje_id = nLineaMontajeId
	AND estacion_id = nEstacionId;

	IF C = 0 THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
    END IF;
	

	IF ISNULL(dFechaIngreso) THEN 
		SELECT fecha_ingreso INTO dNewFechaIngreso FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = nChasisId AND linea_montaje_id = nLineaMontajeId
		AND estacion_id = nEstacionId;
	ELSE 
		SET dNewFechaIngreso = dFechaIngreso; 
	END IF;

    -- No debe haber chequeo para outdate - este puede ser nulo
    
	UPDATE vehiculo_x_estacion SET
		fecha_ingreso = dNewFechaIngreso,
		fecha_egreso = dFechaEgreso
	WHERE vehiculo_num_chasis = nChasisId AND linea_montaje_id = nLineaMontajeId
	AND estacion_id = nEstacionId;

	CALL throwMsg(0, "");
END $$


-- ESTACIÓN

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_estacion$$
CREATE PROCEDURE alta_estacion (nId int, nLineaMontajeId int, cDescripcion varchar(100))
proc: BEGIN
	
	-- CALL proxy_errorOnMissing("linea_montaje", "id", nLineaMontaje, CONCAT("La linea de montaje ", nLineaMontajeId, " no existe!"));
	-- IF @result = false THEN LEAVE proc; END IF;

    IF nLineaMontajeId IS NULL OR cDescripcion IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
	
	INSERT INTO estacion(id, linea_montaje_id, descripcion)
	VALUES(nId, nLineaMontajeId, cDescripcion);
	
	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_estacion$$
CREATE PROCEDURE baja_estacion(nId int, nLineaMontajeId int)
proc: BEGIN

    CALL existsRowInTable2("estacion", "id", nId, "linea_montaje_id", nLineaMontajeId);
    IF @result = false THEN
		CALL throwMsg(-1, "No se encuentran resultados para el par de IDs");
        LEAVE proc;
    END IF;
	
    DELETE FROM estacion WHERE estacion.id=nId AND estacion.linea_montaje_id = nLineaMontajeId;

    CALL throwMsg(0,"");
END $$

DROP PROCEDURE IF EXISTS mod_estacion$$
CREATE PROCEDURE mod_estacion(nId int, nLineaMontajeId int, cDescripcion varchar(100))
proc: BEGIN
	
   DECLARE new_descripcion varchar(100);
   DECLARE C INT DEFAULT 0;

    SELECT COUNT(id) INTO C FROM estacion e WHERE e.id=nId AND e.linea_montaje_id = nLineaMontajeId;

    IF (C = 0) THEN

		CALL throwMsg(-1, "No se encuentra esa estacion");
		LEAVE proc;
	
    END IF;
    
    IF ISNULL(cDescripcion) THEN SELECT descripcion INTO new_descripcion FROM estacion WHERE id = nId AND linea_montaje_id = nLineaMontajeId;
    ELSE SET new_descripcion = cDescripcion; END IF;
   
    
	UPDATE estacion SET
		descripcion = new_descripcion
	WHERE id = nId AND linea_montaje_id = nLineaMontajeId;

	CALL throwMsg(0,"");
END $$


-- DETALLE_VENTA

-- error: que falte un dato 

DROP PROCEDURE IF EXISTS alta_detalle_venta$$
CREATE PROCEDURE alta_detalle_venta (nPedidoVentaId int, modelo_id int, cantidad int)
proc: BEGIN
    IF nPedidoVentaId IS NULL OR modelo_id IS NULL OR cantidad IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;

	INSERT INTO detalle_venta(pedido_venta_id, modelo_id, cantidad)
	VALUES(nPedidoVentaId, modelo_id, cantidad);

	CALL calcular_fecha_entrega(nPedidoVentaId);
    
	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_detalle_venta$$
CREATE PROCEDURE baja_detalle_venta(nId int)
proc: BEGIN
	CALL proxy_errorOnMissing("detalle_venta", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	DELETE FROM detalle_venta WHERE id = nId;
    
	CALL throwMsg(0, "");
END$$

-- errores: que el pedido venta o el modelo no existan, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_detalle_venta$$
CREATE PROCEDURE mod_detalle_venta(nId int, nPedidoVentaId int, nModeloId int, nCantidad int)
proc: BEGIN
	DECLARE nNewPedidoVentaId int;
	DECLARE nNewModeloId int;
	DECLARE nNewCantidad int;
    
	CALL proxy_errorOnMissing("detalle_venta", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF ISNULL(nPedidoVentaId) THEN 
		 SELECT pedido_venta_id INTO nNewPedidoVentaId FROM detalle_venta WHERE id = nId;
	ELSE 
		 SET nNewPedidoVentaId = nPedidoVentaId; 
	END IF;

	IF ISNULL(nModeloId) THEN 
		 SELECT modelo_id INTO nNewModeloId FROM detalle_venta WHERE id = nId;
	ELSE 
		 SET nNewModeloId = nModeloId; 
	END IF;

	IF ISNULL(nCantidad) THEN 
		 SELECT cantidad INTO nNewCantidad FROM detalle_venta WHERE id = nId;
	ELSE 
		 SET nNewCantidad = nCantidad; 
	END IF;
    
	UPDATE detalle_venta SET
		pedido_venta_id = nNewPedidoVentaId,
		modelo_id = nNewModeloId,
		cantidad = nNewCantidad
	WHERE id = nId;
	
    CALL throwMsg(0, "");
END$$

-- PEDIDO_VENTA

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_pedido_venta$$
CREATE PROCEDURE alta_pedido_venta (nConcesionariaId int)
proc: BEGIN
	IF ISNULL(nConcesionariaId) THEN
		CALL throwMsg(-1, "ConcesionariaId es null!");
        LEAVE proc;
    END IF;
	
	INSERT INTO pedido_venta(concesionaria_id)
	VALUES(nConcesionariaId);
	
    CALL throwMsg(0, "");
END$$

DROP PROCEDURE IF EXISTS baja_pedido_venta$$
CREATE PROCEDURE baja_pedido_venta(nId int)
proc: BEGIN
	CALL proxy_errorOnMissing("pedido_venta", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	DELETE FROM pedido_venta WHERE id = nId;
	
    CALL throwMsg(0, "");
END$$

-- errores: que la concesionaria no exista, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_pedido_venta$$
CREATE PROCEDURE mod_pedido_venta(nId int, nConcesionariaId int, dFechaEntrega date)
proc: BEGIN
	DECLARE nNewConcesionariaId int;
	DECLARE dNewFechaEntrega date;
    
	CALL proxy_errorOnMissing("pedido_venta", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF ISNULL(nConcesionariaId) THEN
		SELECT concesionaria_id INTO nNewConcesionariaId FROM pedido_venta WHERE id = nId;
	ELSE 
		SET nNewConcesionariaId = nConcesionariaId;
	END IF;
	IF ISNULL(dFechaEntrega) THEN
		SELECT fecha_entrega INTO dNewFechaEntrega FROM pedido_venta WHERE id = nId;
	ELSE 
		SET dNewFechaEntrega = dFechaEntrega;
	END IF;
    
	UPDATE pedido_venta SET
		concesionaria_id = nNewConcesionariaId,
		fecha_entrega = dNewFechaEntrega
	WHERE id = nId;
	
    CALL throwMsg(0, "");
END$$

-- LINEA_MONTAJE

-- error: que falte un dato

DROP PROCEDURE IF EXISTS alta_linea_montaje$$
CREATE PROCEDURE alta_linea_montaje (nModeloId int)
proc: BEGIN
	-- TODO: Probar si existe modelo, si no tirar error
	INSERT INTO linea_montaje(modelo_id, vehiculos_mes)
	VALUES(nModeloId, 0);
    
    CALL throwMsg(0, "");
END$$

-- error: que haya todavía un vehículo o modelo

DROP PROCEDURE IF EXISTS baja_linea_montaje$$
CREATE PROCEDURE baja_linea_montaje(nId int)
proc: BEGIN
	CALL proxy_errorOnMissing("linea_montaje", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;

	DELETE FROM linea_montaje WHERE id = nId;
    
    CALL throwMsg(0, "");
END$$

-- errores: que el vehículo o el modelo no existan, que falte un dato, usar caracteres inválidos (números, signos)

DROP PROCEDURE IF EXISTS mod_linea_montaje$$
CREATE PROCEDURE mod_linea_montaje(nId int, nVehiculosMes int, nModeloId int)
proc: BEGIN
	DECLARE nNewVehiculosMes int;
	DECLARE nNewModeloId int;
    
	CALL proxy_errorOnMissing("linea_montaje", "id", nId, null);
	IF @result = false THEN LEAVE proc; END IF;
    
	IF ISNULL(nVehiculosMes) THEN 
		SELECT vehiculos_mes INTO nNewVehiculosMes FROM linea_montaje WHERE id = nId;
	ELSE 
		SET nNewVehiculosMes = nVehiculosMes; 
	END IF;

	IF ISNULL(nModeloId) THEN 
		SELECT modelo_id INTO nNewModeloId FROM linea_montaje WHERE id = nId;
	ELSE 
		SET nNewModeloId = nModeloId; 
	END IF;
   
	UPDATE linea_montaje SET
		vehiculos_mes = nNewVehiculosMes,
		modelo_id = nNewModeloId
	WHERE id = nId;
	
    CALL throwMsg(0, "");
END$$


-- PROVEEDOR_X_INSUMO

-- error: ?

DROP PROCEDURE IF EXISTS alta_proveedor_x_insumo$$
CREATE PROCEDURE alta_proveedor_x_insumo(nInsumoId int, nProveedorId int, precio float)
proc: BEGIN
	-- TODO: Talvez tirar error si se ingresan IDs que no existen en las respectivas tablas? Esto repetido para las otras
    -- TODO: dInDate < dOutDate
	IF nInsumoId IS NULL OR nProveedorId IS NULL OR precio IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
   
	INSERT INTO proveedor_x_insumo(insumo_id, proveedor_id, precio)
	VALUES(nInsumoId,nProveedorId,precio);

	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_proveedor_x_insumo$$
CREATE PROCEDURE baja_proveedor_x_insumo(nInsumoId int, nProveedorId int)
proc: BEGIN
	
	DECLARE C INT DEFAULT 0;
	
    SELECT COUNT(id) INTO C FROM proveedor_x_insumo WHERE insumo_id = nInsumoId AND proveedor_id = nProveedorId;
    IF (C = 0) THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
	END IF;
	
    DELETE FROM proveedor_x_insumo WHERE insumo_id = nInsumoId AND proveedor_id = nProveedorId;

    CALL throwMsg(0, "");
END $$

-- errores: ?
DROP PROCEDURE IF EXISTS mod_proveedor_x_insumo $$
 CREATE PROCEDURE mod_proveedor_x_insumo(nInsumoId int, nProveedorId int, precio float)
proc: BEGIN
	-- TODO: No me dieron ganas de permitir la modificacion de PKs ahora / no tiene que ser asi tampoco salame
    
	DECLARE C INT DEFAULT 0;
	DECLARE fNewPrecio float;

	SELECT COUNT(insumo_id) FROM proveedor_x_insumo WHERE insumo_id = nInsumoId AND proveedor_id = nProveedorId;

	IF C = 0 THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
    END IF;
	
	IF ISNULL(precio) THEN 
		SELECT precio INTO fNewPrecio FROM proveedor_x_insumo WHERE insumo_id = nInsumoId AND proveedor_id = nProveedorId;
	ELSE 
		SET fNewPrecio = precio; 
	END IF;
    
	UPDATE proveedor_x_insumo SET
		precio = fNewPrecio
	WHERE insumo_id = nInsumoId AND proveedor_id = nProveedorId;

	CALL throwMsg(0, "");
END $$

-- INSUMO_x_ESTACION
-- error: ?

DROP PROCEDURE IF EXISTS alta_insumo_x_estacion$$
CREATE PROCEDURE alta_insumo_x_estacion(nInsumoId int, nEstacionId int, nLineaMontajeId int, nCantidad float)
proc: BEGIN
	IF nInsumoId IS NULL OR nEstacionId IS NULL OR nLineaMontajeId IS NULL OR nCantidad IS NULL THEN
		CALL throwMsg(-1, "Faltan datos!");
        LEAVE proc;
    END IF;
   
	INSERT INTO vehiculo_x_estacion(insumo_id, estacion_id, linea_montaje_id, cantidad)
	VALUES(nChasisId,nEstacionId,nLineaMontajeId,nCantidad);

	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS baja_insumo_x_estacion$$
CREATE PROCEDURE baja_insumo_x_estacion(nInsumoId int, nEstacionId int, nLineaMontajeId int, nCantidad float)
proc: BEGIN
	
	DECLARE C INT DEFAULT 0;
	
    SELECT COUNT(id) INTO C FROM insumo_x_estacion WHERE insumo_id = nInsumoId AND estacion_id = nEstacionId AND linea_montaje_id = nLineaMontajeId;
    IF (C = 0) THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
	END IF;
	
    DELETE FROM insumo_x_estacion WHERE insumo_id = nInsumoId AND estacion_id = nEstacionId AND linea_montaje_id = nLineaMontajeId;

    CALL throwMsg(0, "");
END $$

-- errores: que el vehículo o la estación no existan, que falte un dato, usar caracteres inválidos (números, signos)
DROP PROCEDURE IF EXISTS mod_insumo_x_estacion $$
 CREATE PROCEDURE mod_insumo_x_estacion(nInsumoId int, nEstacionId int, nLineaMontajeId int, nCantidad float)
proc: BEGIN
    
	DECLARE C INT DEFAULT 0;
	DECLARE nNewCantidad int;

	SELECT COUNT(insumo_id) FROM insumo_x_estacion WHERE insumo_id = nInsumoId AND linea_montaje_id = nLineaMontajeId
	AND estacion_id = nEstacionId;

	IF C = 0 THEN
		CALL throwMsg(-1, "No se encuentra el registro");
		LEAVE proc;
    END IF;
	

	IF ISNULL(nCantidad) THEN 
		SELECT cantidad INTO nNewCantidad FROM insumo_x_estacion WHERE insumo_id = nInsumoId AND linea_montaje_id = nLineaMontajeId
		AND estacion_id = nEstacionId;
	ELSE 
		SET nNewCantidad = cantidad; 
	END IF;

    -- No debe haber chequeo para outdate - este puede ser nulo
    
	UPDATE insumo_x_estacion SET
		cantidad = nNewCantidad
	WHERE insumo_id = nInsumoId AND linea_montaje_id = nLineaMontajeId
	AND estacion_id = nEstacionId;

	CALL throwMsg(0, "");
END $$

DELIMITER ;