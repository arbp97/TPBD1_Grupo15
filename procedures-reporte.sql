DELIMITER $$

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
    
   
   select vehiculo.num_chasis,"Finalizado" as estado
	from vehiculo 
	where vehiculo.finalizado = 1 and pedido_venta_id = iPedido
	union
	select vehiculo.num_chasis,"A Fabricar" as estado
	from vehiculo
	WHERE vehiculo.num_chasis NOT IN 
								(SELECT vehiculo_num_chasis 
									FROM vehiculo_x_estacion)
	and finalizado = 0 and vehiculo.pedido_venta_id = iPedido
	union
	select vehiculo.num_chasis, estacion.id as estado
	from vehiculo
	inner join vehiculo_x_estacion on vehiculo.num_chasis = vehiculo_x_estacion.vehiculo_num_chasis 
	inner join estacion on vehiculo_x_estacion.estacion_id = estacion.id
	where vehiculo.finalizado = 0 and vehiculo_x_estacion.fecha_egreso is null
	and vehiculo.pedido_venta_id = iPedido
    group by num_chasis;
END $$

DELIMITER ;
 
call reporte_vehiculos(1); 