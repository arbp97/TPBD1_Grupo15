use automotriz;

DELIMITER $$

DROP PROCEDURE IF EXISTS asignar_linea_pedido$$ -- PUNTO 8
CREATE PROCEDURE asignar_linea_pedido(pedido_venta_id INT)
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
END $$

DROP PROCEDURE IF EXISTS calcular_fecha_entrega$$ -- teniendo en cuenta que un vehiculo tarda 1 dia en finalizarse...
CREATE PROCEDURE calcular_fecha_entrega(pedido_venta_id INT)
BEGIN

	DECLARE finished INT DEFAULT 0;
	DECLARE nCantidad INT;
	DECLARE dFechaEntrega date DEFAULT NOW();

	DECLARE cursor_detalle_venta
        CURSOR FOR
            SELECT cantidad FROM detalle_venta WHERE detalle_venta.pedido_venta_id = pedido_venta_id;
 	
    DECLARE CONTINUE HANDLER
        FOR NOT FOUND SET finished = 1;
  
    OPEN cursor_detalle_venta;
   
    getDetalle: LOOP

        FETCH cursor_detalle_venta INTO nCantidad;
      	
        IF finished = 1 THEN
            LEAVE getDetalle;
		END IF;

		SET dFechaEntrega = DATE_ADD(dFechaEntrega, INTERVAL nCantidad DAY);

    END LOOP getDetalle;
	
   	CALL mod_pedido_venta(pedido_venta_id, null, dFechaEntrega);
   
    CLOSE cursor_detalle_venta;
END $$

DROP PROCEDURE IF EXISTS iniciar_ensamblado $$ -- PUNTO 9
CREATE PROCEDURE iniciar_ensamblado(nChasisId INT)
proc: BEGIN
	
	DECLARE linea_montaje_ref int;
	DECLARE nChasisEstacionId int DEFAULT 0;
	
	SELECT modelo_id INTO linea_montaje_ref FROM vehiculo WHERE num_chasis = nChasisId;
    
	SELECT vehiculo_num_chasis INTO nChasisEstacionId FROM vehiculo_x_estacion vxe WHERE vxe.linea_montaje_id = linea_montaje_ref
	AND vxe.estacion_id = 0 
	AND vxe.fecha_egreso is null;
	-- se busca si hay un vehiculo metido en la estacion sin haber salido
	IF nChasisEstacionId > 0 THEN
		
		CALL throwMsg(-1, CONCAT("Todavia hay un vehiculo (id chasis: ",nChasisEstacionId,") en la estacion"));
		LEAVE proc;
	END IF;
	
	CALL alta_vehiculo_x_estacion(nChasisId, 0, linea_montaje_ref, NOW() , null);
	
	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS avanzar_estacion $$
CREATE PROCEDURE avanzar_estacion(nChasisId INT) -- PUNTO 10 -- needs testing
proc: BEGIN
    
	DECLARE linea_montaje_ref int;
	DECLARE nCantEstacionesLinea int DEFAULT 0; -- TEMP cambiar por max() ?
	DECLARE nCurrentEstacionId int DEFAULT -1;
	DECLARE nChasisEstacionId int DEFAULT 0; -- chasis dentro de la estacion siguiente
	DECLARE bFinalizado bit DEFAULT 0;
	
	-- conseguir linea de montaje del modelo del vehiculo
	SELECT modelo_id,finalizado INTO linea_montaje_ref,bFinalizado FROM vehiculo WHERE vehiculo.num_chasis = nChasisId;

	-- TEMP get cant estaciones 
	SELECT COUNT(id) INTO nCantEstacionesLinea FROM estacion WHERE linea_montaje_id = linea_montaje_ref;

	-- conseguir la estacion en la cual estaria el vehiculo actualmente
	SELECT estacion_id INTO nCurrentEstacionId FROM vehiculo_x_estacion WHERE vehiculo_x_estacion.vehiculo_num_chasis = nChasisId
	AND vehiculo_x_estacion.linea_montaje_id = linea_montaje_ref
	AND fecha_egreso is null;

	IF bFinalizado = 1 THEN
		CALL throwMsg(-1, "El vehiculo ya está terminado.");
		LEAVE proc;
	END IF;

	IF nCurrentEstacionId = -1 THEN
		CALL throwMsg(-1, "El vehiculo todavia no está en producción.");
		LEAVE proc;
	END IF;

	IF (nCurrentEstacionId+1) < nCantEstacionesLinea THEN
		
		SELECT vehiculo_num_chasis INTO nChasisEstacionId FROM vehiculo_x_estacion vxe WHERE vxe.linea_montaje_id = linea_montaje_ref 
		AND vxe.estacion_id = (nCurrentEstacionId+1) 
		AND vxe.fecha_egreso is null;

		-- se busca si hay un vehiculo metido en la estacion sin haber salido
		IF nChasisEstacionId > 0 THEN
			CALL throwMsg(-1, CONCAT("Todavia hay un vehiculo (id chasis: ",nChasisEstacionId,") en la estacion"));
		LEAVE proc;
		END IF;

		CALL alta_vehiculo_x_estacion(nChasisId, (nCurrentEstacionId+1), linea_montaje_ref, NOW() , null);
		-- CALL throwMsg(0, "");
	ELSE
		CALL mod_vehiculo(nChasisId, null, null, 1); -- vehiculo finalizado
        -- CALL throwMsg(0, "Vehiculo completado.");
	END IF;
    
	-- vehiculo sale de la estacion
	CALL mod_vehiculo_x_estacion(nChasisId, linea_montaje_ref, nCurrentEstacionId, null, NOW());
    CALL throwMsg(0, "");
END $$


DELIMITER ;