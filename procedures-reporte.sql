DELIMITER $$
set @testNumero = 1$$

/*
	Dado un numero de pedido, se requiere listar los vehiculos indicando el chasis,
    si se encuentra finalizado, y si no esta terminado, indicar en que estacion se encuentra.
*/
DROP PROCEDURE IF EXISTS reporte_vehiculos$$
CREATE PROCEDURE reporte_vehiculos(iPedido int)
proc: BEGIN
	DECLARE C int default 0;
    
	If iPedido is NULL then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tenes que poner un numero de pedido, pelotudo';
    end if;
    
    select v.num_chasis as "Chasis",
		IF(v.finalizado = 1, "Terminado",
			IF( vxe.vnchasis IS NULL, "Esperando para ensamblaje", CONCAT("En estacion ",vxe.lastSeen)
			)
		) as "Estado"
	from (select * from vehiculo where pedido_venta_id = iPedido) v
    left join (
		select vehiculo_num_chasis vnchasis, max(estacion_id) as lastSeen
        from vehiculo_x_estacion
        group by vehiculo_num_chasis
    ) vxe on v.num_chasis = vxe.vnchasis;
   
END $$
call reporte_vehiculos(1)$$ -- Prueba rapida

/*
	Dado un numero de pedido, se requiere listar los insumos que sera necesario
    solicitar, indicando codigo de insumo y cantidad requerida para ese pedido.
*/
DROP PROCEDURE IF EXISTS reporte_insumos$$
CREATE PROCEDURE reporte_insumos(iPedido int)
proc: BEGIN
	DECLARE C int default 0;
    
	
   
END $$
call reporte_insumos(1)$$ -- Prueba rapida

/*
	Dada una linea de montaje, indicar el tiempo promedio de construccion de los vehiculos
    (tener en cuenta solo los vehiculos terminados)
    Che Alan, podes poner el nombre del procedimiento en español y que sea legible? Gracias <3
*/
DROP PROCEDURE IF EXISTS reporte_buildtime$$
CREATE PROCEDURE reporte_buildtime(iLinea int)
proc: BEGIN
	DECLARE C int default 0;
    
	
   
END $$
call reporte_buildtime(1)$$ -- Prueba rapida

DELIMITER ;

;