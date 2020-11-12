DELIMITER $$

/*
	Dado un numero de pedido, se requiere listar los vehiculos indicando el chasis,
    si se encuentra finalizado, y si no esta terminado, indicar en que estacion se encuentra.
    
    Se toma una id de pedido_venta (-> iPedido)
    Se guarda en una variable el vehiculo
    Listar todos los vehiculos cuyo pedido_venta_id sea igual a iPedido
    Se mostrara una tabla de formato chasis|finalizado|estacion, donde:
    * Si un vehiculo tiene el bit finalizado a 1, se marca, y [estacion] queda null
    * Si no, se busca la estacion que posea la linea de montaje correspondiente al modelo del vehiculo que estamos viendo
    va, en realidad solo tengo que mostrar esos y ya ta xd
    no tengo que hacer nada raro
*/
DROP PROCEDURE IF EXISTS reporte_vehiculos$$
CREATE PROCEDURE reporte_vehiculos(iPedido int) -- NO FUNCIONA, ARREGLAR!!
proc: BEGIN
	DECLARE C int default 0;
    
	If iPedido is NULL then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tenes que poner un numero de pedido, pelotudo';
    end if;
    
    CREATE TEMPORARY TABLE obama (
		id int primary key auto_increment,
        pedido int not null,
		chasis int not null,
        finalizado bit not null,
        estacion int
    );
    
    -- M
    INSERT INTO obama(pedido, chasis, finalizado, estacion)
		SELECT vehiculo.pedido_venta_id, vehiculo.num_chasis, vehiculo.finalizado, estacion.id
        FROM vehiculo
        JOIN vehiculo_x_estacion ON vehiculo.num_chasis = vehiculo_x_estacion.vehiculo_num_chasis
        JOIN estacion ON vehiculo_x_estacion.estacion_id = estacion.id;

	-- CALL throwMsg(0, "");
END$$

DELIMITER ;

		SELECT vehiculo.num_chasis, vehiculo.pedido_venta_id, vehiculo.finalizado, estacion.id
        FROM vehiculo
        LEFT JOIN vehiculo_x_estacion vxe ON vehiculo.num_chasis = vxe.vehiculo_num_chasis
        LEFT JOIN estacion ON vxe.estacion_id = estacion.id;

CALL reporte_vehiculos(69);