DELIMITER $$
set @testPedido = 1$$

/*
	Dado un numero de pedido, se requiere listar los vehiculos indicando el chasis,
    si se encuentra finalizado, y si no esta terminado, indicar en que estacion se encuentra.
    
    
*/
DROP PROCEDURE IF EXISTS reporte_vehiculos$$
CREATE PROCEDURE reporte_vehiculos(iPedido int) -- NO FUNCIONA, ARREGLAR!!
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
call reporte_vehiculos(1)$$ -- Prueba rapida (avanzar algunos chasis para mostrar!)

DELIMITER ;

;