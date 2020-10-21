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

DROP PROCEDURE IF EXISTS iniciar_ensamblado $$ -- PUNTO 9
CREATE PROCEDURE iniciar_ensamblado(nChasisId INT)
proc: BEGIN
	
	DECLARE linea_montaje_ref int;
	DECLARE nChasisEstacionId int DEFAULT 0;
	
	SELECT modelo_id INTO linea_montaje_ref FROM vehiculo WHERE num_chasis = nChasisId;
    
	SELECT vehiculo_num_chasis INTO nChasisEstacionId FROM vehiculo_x_estacion vxe WHERE vxe.linea_montaje_id = linea_montaje_ref AND vxe.estacion_id = 1 AND 
	vxe.fecha_egreso is null;
	-- se busca si hay un vehiculo metido en la estacion sin haber salido
	IF nChasisEstacionId > 0 THEN
		
		CALL throwMsg(-1, CONCAT("Todavia hay un vehiculo (id chasis: ",nChasisEstacionId,") en la estacion"));
		LEAVE proc;
	END IF;
	
	CALL alta_vehiculo_x_estacion(nChasisId, 0, linea_montaje_ref, NOW() , null);
	
	CALL throwMsg(0, "");
END $$

DROP PROCEDURE IF EXISTS avanzar_estacion
CREATE PROCEDURE avanzar_estacion(nChasisId INT)
proc: BEGIN
    -- todo
END $$


DELIMITER ;