DELIMITER $$

/*
	Dado un numero de pedido, se requiere listar los vehiculos indicando el chasis,
    si se encuentra finalizado, y si no esta terminado, indicar en que estacion se encuentra.
*/
DROP PROCEDURE IF EXISTS reporte_vehiculos$$
CREATE PROCEDURE reporte_vehiculos(iPedido int)
proc: BEGIN
	DECLARE C int default 0;
    
	If iPedido is NULL then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tenes que poner un numero de pedido';
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

/*
	Dado un numero de pedido, se requiere listar los insumos que sera necesario
    solicitar, indicando codigo de insumo y cantidad requerida para ese pedido.
    -- Solo contar los vehiculos que no se comenzaron a hacer
*/
DROP PROCEDURE IF EXISTS reporte_insumos$$
CREATE PROCEDURE reporte_insumos(iPedido int)
proc: BEGIN
	DECLARE C int default 0;
    
    drop table if exists _temp;
    create temporary table _temp (chasis int,linea_montaje_id int)
    select v.num_chasis chasis,lm.id as linea_montaje_id
	from (select * from vehiculo where pedido_venta_id = iPedido) v
    left join (
		select vehiculo_num_chasis vnchasis
        from vehiculo_x_estacion
        group by vehiculo_num_chasis
    ) vxe on v.num_chasis = vxe.vnchasis
    left join linea_montaje lm on lm.modelo_id = v.modelo_id
    where v.finalizado = 0 and vxe.vnchasis is null;
    -- delete from _temp where valid = FALSE;
    
    drop table if exists _temp2;
    create temporary table _temp2 (
		insumo_id int primary key,
        insumo_nombre varchar(100) default "lol",
        cantidad int not null
    );
    insert into _temp2 (insumo_id, insumo_nombre, cantidad)
    select ixe.insumo_id,i.nombre,ixe.cantidad from _temp miniv
    left join insumo_x_estacion ixe on ixe.linea_montaje_id = miniv.linea_montaje_id
    left join insumo i on ixe.insumo_id = i.id
    on duplicate key update _temp2.cantidad = _temp2.cantidad + ixe.cantidad
    ;
    
    -- select * from _temp;
    select * from _temp2;
    
    drop table _temp;
    drop table _temp2;
END $$


/*
	Dada una linea de montaje, indicar el tiempo promedio de construccion de los vehiculos
    (tener en cuenta solo los vehiculos terminados)
*/
DROP PROCEDURE IF EXISTS reporte_promedio$$
CREATE PROCEDURE reporte_promedio(iLinea int)
proc: BEGIN
	DECLARE lineaStationCount int default (select count(id) from estacion where linea_montaje_id = iLinea);
    
	select iLinea as "Linea", concat(TIME_FORMAT(SEC_TO_TIME(AVG(TIMEDIFF(maxt, mint))), "%H:%i:%s"), " horas") as "Promedio" from (
		select * from (
			select vehiculo_num_chasis as chasis, min(fecha_ingreso) as mint, max(fecha_egreso) as maxt, count(fecha_egreso) as passes
			from vehiculo_x_estacion vxe
			where vxe.linea_montaje_id = iLinea
			group by vehiculo_num_chasis
		) short where passes = lineaStationCount
	) short2
    
    ;
   
END $$

DELIMITER ;