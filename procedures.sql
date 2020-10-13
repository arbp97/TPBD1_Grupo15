DELIMITER $$

-- DEBUG / ignore

DROP PROCEDURE IF EXISTS log_msg $$
CREATE PROCEDURE log_msg(cMsg VARCHAR(255))
BEGIN
    insert into logs select 0, cMsg;
END $$

-- CONCESIONARIA ----------------------------------------------------------------------

DROP PROCEDURE IF EXISTS alta_concesionaria $$ 
CREATE PROCEDURE alta_concesionaria(cNombre VARCHAR(100), cDireccion VARCHAR(100))
BEGIN

	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	IF cNombre IS NULL OR cNombre='' OR cDireccion IS NULL OR cDireccion='' THEN
	
		SET nResultado = -1;
		SET cMensaje = "Error: verifique los valores de sus parametros";
	
	ELSE
		
		INSERT INTO concesionaria(nombre,direccion)
		VALUES(cNombre,cDireccion);
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS mod_concesionaria $$ 
CREATE PROCEDURE mod_concesionaria(nId INT, cNombre VARCHAR(100), cDireccion VARCHAR(100))
BEGIN
	
	DECLARE nCount INT DEFAULT 0;
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewDireccion VARCHAR(100);
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM concesionaria WHERE concesionaria.id = nId;
    IF (nCount = 0) THEN
 
		SET nResultado = -1;
        SET cMensaje = "Concesionaria inexistente";
    ELSE

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
	
		UPDATE concesionaria
		  SET 
		    nombre = cNewNombre,
		    direccion = cNewDireccion
		  WHERE id = nId;
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS baja_concesionaria $$
CREATE PROCEDURE baja_concesionaria (nId INT)
BEGIN

	DECLARE nCount INT DEFAULT 0;
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM concesionaria WHERE concesionaria.id = nId;
    IF (nCount = 0) THEN
		SET nResultado = -1;
        SET cMensaje = "Concesionaria inexistente";
    ELSE

		DELETE FROM concesionaria WHERE id = nId;
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

-- MODELO ------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS alta_modelo $$ 
CREATE PROCEDURE alta_modelo(cNombre VARCHAR(100), nCantidadEstaciones INT)
BEGIN
	
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;
	DECLARE nModeloId INT;
	DECLARE nLineaMontajeId INT;
	DECLARE nInsertados INT;
	
	
	IF cNombre IS NULL OR cNombre='' THEN	
	
		SET nResultado = -1;
		SET cMensaje = "Inserte un nombre para el modelo";
	END IF;
	IF nCantidadEstaciones < 1 OR nCantidadEstaciones IS NULL THEN
	
		SET nResultado = -1;
		SET cMensaje = "Se necesita 1 estacion como minimo";
	END IF;
	
	IF nResultado = 0 THEN
		
		INSERT INTO modelo(nombre)
		VALUES(cNombre);
		
		SELECT MAX(id) INTO nModeloId FROM modelo; -- ultima id cargada MAX(id)
		
		CALL alta_linea_montaje(nModeloId);
		
		SELECT MAX(id) INTO nLineaMontajeId FROM linea_montaje;
		
		
		SET nInsertados = 0;
		
			WHILE nInsertados < nCantidadEstaciones DO
			
				CALL alta_estacion(nLineaMontajeId, 'descripcion');
			
				SET nInsertados = nInsertados + 1;
				
			END WHILE;
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS mod_modelo $$ 
CREATE PROCEDURE mod_modelo(nId INT, cNombre VARCHAR(100))
BEGIN
	
	DECLARE nCount INT DEFAULT 0;
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM modelo WHERE modelo.id = nId;
    IF (nCount = 0) THEN
		SET nResultado = -1;
        SET cMensaje = "Modelo inexistente";
       
	ELSE
	
		IF cNombre IS NULL OR cNombre='' THEN	
			SELECT modelo.nombre INTO cNewNombre FROM modelo WHERE id = nId;
		ELSE 
			SET cNewNombre = cNombre;
		END IF;
	
		UPDATE modelo
		  SET 
		    nombre = cNewNombre
		  WHERE id = nId;
	END IF;

 	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS baja_modelo $$
CREATE PROCEDURE baja_modelo (nId INT)
BEGIN

	DECLARE nCount INT DEFAULT 0;
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM modelo WHERE modelo.id = nId;
    IF (nCount = 0) THEN
		SET nResultado = -1;
        SET cMensaje = "Modelo inexistente";
       
	ELSE
	
	DELETE FROM modelo WHERE id = nId;

	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

-- PROVEEDOR ------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS alta_proveedor $$ 
CREATE PROCEDURE alta_proveedor(cNombre VARCHAR(100), cRubro VARCHAR(100))
BEGIN

	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	IF cNombre IS NULL OR cNombre='' THEN	
	
		SET nResultado = -1;
		SET cMensaje = "Inserte un nombre para el proveedor";
	END IF;
	IF cRubro IS NULL OR cRubro='' THEN	
	
		SET nResultado = -1;
		SET cMensaje = "Inserte un rubro para el proveedor";
	END IF;

	IF (nResultado = 0) THEN
		INSERT INTO proveedor(nombre,rubro)
		VALUES(cNombre,cRubro);
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS mod_proveedor $$ 
CREATE PROCEDURE mod_proveedor(nId INT, cNombre VARCHAR(100), cRubro VARCHAR(100))
BEGIN
	
	DECLARE nCount INT DEFAULT 0;
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewRubro VARCHAR(100);
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM proveedor WHERE proveedor.id = nId;
	IF (nCount = 0) THEN

		SET nResultado = -1;
		SET cMensaje = "Proveedor no existe con esa ID";
	
	ELSE

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

	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS baja_proveedor $$
CREATE PROCEDURE baja_proveedor (nId INT)
BEGIN

	DECLARE nCount INT DEFAULT 0;
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM proveedor WHERE proveedor.id = nId;
	IF (nCount = 0) THEN

		SET nResultado = -1;
		SET cMensaje = "Proveedor no existe con esa ID";
	
	ELSE

		DELETE FROM proveedor WHERE id = nId;

	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

-- INSUMO ---------------------------------------------------------------------------------
						
DROP PROCEDURE IF EXISTS alta_insumo $$ 
CREATE PROCEDURE alta_insumo(cNombre VARCHAR(100), cDescripcion VARCHAR(100))
BEGIN

	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	IF cNombre IS NULL OR cNombre='' THEN	
	
		SET nResultado = -1;
		SET cMensaje = "Inserte un nombre para el insumo";
	END IF;

	IF (nResultado = 0) THEN
		INSERT INTO insumo(nombre,descripcion)
		VALUES(cNombre,cDescripcion);
	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END $$

DROP PROCEDURE IF EXISTS mod_insumo $$
CREATE PROCEDURE mod_insumo(nId INT, cNombre VARCHAR(100), cDescripcion VARCHAR(100))
BEGIN
	
	DECLARE cNewNombre VARCHAR(100);
	DECLARE cNewDescripcion VARCHAR(100);
	DECLARE nCount INT DEFAULT 0;
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM insumo WHERE insumo.id = nId;
	IF (nCount = 0) THEN

		SET nResultado = -1;
		SET cMensaje = "Insumo no existe con esa ID";
	
	ELSE

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

	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END	$$

DROP PROCEDURE IF EXISTS baja_insumo $$
CREATE PROCEDURE baja_insumo (nId INT)
BEGIN

	DECLARE nCount INT DEFAULT 0;
	DECLARE cMensaje VARCHAR(100) DEFAULT "";
	DECLARE nResultado INT DEFAULT 0;

	SELECT COUNT(id) INTO nCount FROM insumo WHERE insumo.id = nId;
	IF (nCount = 0) THEN

		SET nResultado = -1;
		SET cMensaje = "Insumo no existe con esa ID";

	ELSE

		DELETE FROM insumo WHERE id = nId;

	END IF;

	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END	$$

-- VEHICULO ------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS alta_vehiculo$$
CREATE PROCEDURE alta_vehiculo(nModeloId int, nPedidoId int, bFinalizado BIT)
BEGIN

	INSERT INTO vehiculo(modelo_id, pedido_venta_id, finalizado)
	VALUES(nModeloId,nPedidoId,bFinalizado);

END$$

DROP PROCEDURE IF EXISTS baja_vehiculo$$
CREATE PROCEDURE baja_vehiculo(id int)
BEGIN

	DECLARE C INT DEFAULT 0;
	DECLARE RES INT DEFAULT 0;
        DECLARE MSG VARCHAR(69) DEFAULT "";

        SELECT COUNT(num_chasis) INTO C FROM vehiculo WHERE vehiculo.num_chasis = id;

        IF (C = 0) THEN

		SET RES = 0;
                SET MSG = "Pero eso no existe, pelotudo";
		-- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pero eso no existe, pelotudo';

	ELSE

		DELETE FROM vehiculo WHERE num_chasis = id;
		SET RES = 1;
		SET MSG = "Vehiculo eliminado";

        END IF;

        SELECT RES AS nResultado, MSG as cMensaje;

END$$

DROP PROCEDURE IF EXISTS mod_vehiculo$$
CREATE PROCEDURE mod_vehiculo(nId int, nModeloId int, nPedidoId int, bFinalizado BIT)
BEGIN

        DECLARE nNewModeloId,nNewPedidoId int;
        DECLARE bNewFinalizado BIT;
    
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

END$$

-- PEDIDO_INSUMO

DROP PROCEDURE IF EXISTS alta_pedido_insumo$$
CREATE PROCEDURE alta_pedido_insumo(nInsumoId int, nProveedorId int, fCantidad float)
BEGIN

	INSERT INTO pedido_insumo(insumo_id,proveedor_id,cantidad)
	VALUES(nInsumoId,nProveedorId,fCantidad);

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
CREATE PROCEDURE mod_pedido_insumo(nId int, nInsumoId int, nProveedorId int, fCantidad float)
BEGIN

        DECLARE nNewInsumoId,nNewProveedorId,fNewCantidad int;
    
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

END$$

-- VEHICULO_X_ESTACION

DROP PROCEDURE IF EXISTS alta_vehiculo_x_estacion$$
CREATE PROCEDURE alta_vehiculo_x_estacion(nChasisId int, nEstacionId int, dInDate datetime, dOutDate datetime)
BEGIN

	INSERT INTO vehiculo_x_estacion(vehiculo_num_chasis, estacion_id, fecha_ingreso, fecha_egreso)
	VALUES(nChasisId,nEstacionId,dInDate,dOutDate);

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
CREATE PROCEDURE mod_vehiculo_x_estacion(nOldCarId int, nOldEstacionId int, nNextCarId int, nNextEstacionId int, nInDate datetime, dOutDate datetime)
BEGIN
	-- oldX: Se modificara la entrada que tenga este par de PKs
	-- newX: Si se modifica el valor de alguna PK, a cual
	DECLARE nNewEstacionId,nNewCarId int;
	DECLARE dNewInDate,dNewOutDate datetime;
    
	IF ISNULL(nNextCarId) THEN

                  SET nNewCarId = nOldCarId; ELSE SET nNewCarId = nNextCarId; 
	END IF;

	IF ISNULL(nNextEstacionId) THEN 

                 SET nNewEstacionId = nOldEstacionId; ELSE SET nNewEstacionId = nNextEstacionId; 

	END IF;

	IF ISNULL(dInDate) THEN 

                 SELECT fecha_ingreso INTO dNewInDate FROM vehiculo_x_estacion WHERE vehiculo_num_chasis = id;

	ELSE 

                 SET dNewInDate = dInDate; 

	END IF;

    -- No hay chequeo para outdate - este puede ser nulo
    
	UPDATE vehiculo_x_estacion SET
                 vehiculo_num_chasis = nNewCarId,
		 estacion_id = nNewEstacionId,
		 fecha_ingreso = dNewIndate,
		 fecha_egreso = dNewOutDate
	WHERE vehiculo_num_chasis = nOldCarId AND estacion_id = nOldEstacionId;

END$$


-- ESTACIÓN

DROP PROCEDURE IF EXISTS alta_estacion$$
CREATE PROCEDURE alta_estacion (nLineaMontajeId int, cDescripcion varchar(100))
BEGIN

	INSERT INTO estacion(linea_montaje_id, descripcion)
	VALUES(nLineaMontajeId, cDescripcion);

END$$

DROP PROCEDURE IF EXISTS baja_estacion$$
CREATE PROCEDURE baja_estacion(id int)
BEGIN

	DECLARE C INT DEFAULT 0;
	DECLARE RES INT DEFAULT 0;
	DECLARE MSG VARCHAR(100) DEFAULT "";

	SELECT COUNT(id) INTO C FROM estacion WHERE id=id;

	IF (C = 0) THEN

		 SET RES = -404;
		 SET MSG = "No se encuentran resultados para ese ID";

	ELSE
	
		 DELETE FROM estacion WHERE id=id;

	END IF;

		 SELECT RES AS nResultado, MSG as cMensaje;

END$$

DROP PROCEDURE IF EXISTS mod_estacion$$
CREATE PROCEDURE mod_estacion(nId int, nLineaMontajeId int, cDescripcion varchar(100))
BEGIN

	DECLARE nNewLineaMontajeId int;
	DECLARE new_descripcion varchar(100);
    
	IF ISNULL(nLineaMontajeId) THEN

		 SELECT linea_montaje_id INTO nNewLineaMontajeId FROM estacion WHERE id = nId;

	ELSE 

		 SET nNewLineaMontajeId = nLineaMontajeId; 

	END IF;

	IF ISNULL(cDescripcion) THEN

 		 SELECT descripcion INTO cNewDescripcion FROM estacion WHERE id = nId;

	ELSE 

		 SET cNewDescripcion = cDescripcion; 

	END IF;

    
	UPDATE estacion SET
		 linea_montaje_id = new_linea_montaje_id,
		 descripcion = cNewDescripcion
	WHERE id = nId;

END$$


-- DETALLE_VENTA

DROP PROCEDURE IF EXISTS alta_detalle_venta$$
CREATE PROCEDURE alta_detalle_venta (nPedidoVentaId int, modelo_id int, cantidad int)
BEGIN

	INSERT INTO detalle_venta(pedido_venta_id, modelo_id, cantidad)
	VALUES(nPedidoVentaId, modelo_id, cantidad);

END$$

DROP PROCEDURE IF EXISTS baja_detalle_venta$$
CREATE PROCEDURE baja_detalle_venta(id int)
BEGIN

	DELETE FROM detalle_venta WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS mod_detalle_venta$$
CREATE PROCEDURE mod_detalle_venta(nId int, nPedidoVentaId int, nModeloId int, nCantidad int)
BEGIN

	DECLARE nNewPedidoVentaId int;
	DECLARE nNewModeloId int;
	DECLARE nNewCantidad int;
    
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

END$$

-- PEDIDO_VENTA

DROP PROCEDURE IF EXISTS alta_pedido_venta$$
CREATE PROCEDURE alta_pedido_venta (nConcesionariaId int)
BEGIN

	INSERT INTO pedido_venta(concesionaria_id)
	VALUES(nConcesionariaId);

END$$

DROP PROCEDURE IF EXISTS baja_pedido_venta$$
CREATE PROCEDURE baja_pedido_venta(id int)
BEGIN

	DELETE FROM pedido_venta WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS mod_pedido_venta$$
CREATE PROCEDURE mod_pedido_venta(nId int, nConcesionariaId int)
BEGIN

	DECLARE nNewConcesionariaId int;
    
	IF ISNULL(nConcesionariaId) THEN 

                SELECT concesionaria_id INTO nNewConcesionariaId FROM pedido_venta WHERE id = nId;

	ELSE 

                SET nNewConcesionariaId = nConcesionariaId; 

	END IF;
    
	UPDATE pedido_venta SET
		concesionaria_id = nNewConcesionariaId
	WHERE id = nId;

END$$

-- LINEA_MONTAJE

DROP PROCEDURE IF EXISTS alta_linea_montaje$$
CREATE PROCEDURE alta_linea_montaje (nModeloId int)
BEGIN
	INSERT INTO linea_montaje(modelo_id, vehiculos_mes)
	VALUES(nModeloId, 0);
END$$

DROP PROCEDURE IF EXISTS baja_linea_montaje$$
CREATE PROCEDURE baja_linea_montaje(id int)
BEGIN
	DELETE FROM linea_montaje WHERE id = id;
END$$

DROP PROCEDURE IF EXISTS mod_linea_montaje$$
CREATE PROCEDURE mod_linea_montaje(nId int, nVehiculosMes int, nModeloId int)
BEGIN
	DECLARE nNewVehiculosMes int;
	DECLARE nNewModeloId int;
    
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

