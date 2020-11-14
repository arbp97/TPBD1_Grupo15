call alta_concesionaria("Autos Adrogué - PEUGEOT", "Av. Hipólito Yrigoyen 8800");
call alta_concesionaria("Cristóbal y Hnos. - SEAT", "España 1492");

call alta_modelo("Peugeot 307", 5);
call alta_modelo("Peugeot 408", 6);

call alta_modelo("SEAT Ibiza", 4);

call alta_proveedor("Pintureria Frias", "Pintura");
call alta_proveedor("Pintura Automotor Quality", "Pintura");

call alta_proveedor("Autopartes Grupo PSA", "Autopartes");
call alta_proveedor("Grupo Volkswagen", "Autopartes");

call alta_proveedor("Total", "Liquidos");

/***********************************************************************************/

-- CARGAR INSUMOS DE CADA PROVEEDOR... segun los modelos y eso

call alta_insumo("Pintura", "Pintura para automoviles");
call alta_insumo("Motor", "Vroom Vroom");
call alta_insumo("Puerta", "Puerta de coche");
call alta_insumo("Carroceria", "Una carroceria basica");
call alta_insumo("Aceite", "Aceite de motor");
call alta_insumo("Refrigerante", "Refrigerante para motor");

call alta_proveedor_x_insumo(1, 1, 1000);
call alta_proveedor_x_insumo(1, 2, 1500);

call alta_proveedor_x_insumo(2, 3, 16000);

call alta_proveedor_x_insumo(3, 3, 3000);
call alta_proveedor_x_insumo(3, 4, 2500);

call alta_proveedor_x_insumo(4, 3, 12000);
call alta_proveedor_x_insumo(4, 4, 14000);

call alta_proveedor_x_insumo(5, 5, 500);
call alta_proveedor_x_insumo(6, 5, 300);

-- call alta_insumo_x_estacion(:nInsumoId, :nEstacionId, :nLineaMontajeId, :nCantidad)

call alta_insumo_x_estacion(1, 3, 1, 2);
call alta_insumo_x_estacion(2, 1, 1, 1);
call alta_insumo_x_estacion(3, 2, 1, 2);
call alta_insumo_x_estacion(4, 0, 1, 1);
call alta_insumo_x_estacion(5, 4, 1, 3);
call alta_insumo_x_estacion(6, 4, 1, 2);

call alta_insumo_x_estacion(1, 3, 2, 1);
call alta_insumo_x_estacion(2, 1, 2, 1);
call alta_insumo_x_estacion(3, 2, 2, 4);
call alta_insumo_x_estacion(4, 0, 2, 1);
call alta_insumo_x_estacion(5, 4, 2, 2);
call alta_insumo_x_estacion(6, 5, 2, 2);

call alta_insumo_x_estacion(1, 3, 3, 1);
call alta_insumo_x_estacion(2, 1, 3, 1);
call alta_insumo_x_estacion(3, 2, 3, 2);
call alta_insumo_x_estacion(4, 0, 3, 1);
call alta_insumo_x_estacion(5, 3, 3, 1);
call alta_insumo_x_estacion(6, 3, 3, 1);


/***********************************************************************************/

call alta_pedido_venta(1);
call alta_detalle_venta(1, 1, 8); -- 16 Peugeot 307 y 408 a Autos Adrogué
call alta_detalle_venta(1, 2, 8);

call alta_pedido_venta(2);
call alta_detalle_venta(2, 3, 20); -- 20 SEAT Ibiza a Cristóbal y Hnos.


call asignar_linea_pedido(1);

call asignar_linea_pedido(2);

/*******************************************************************************************/
-- Ir utilizando estos procedimientos con distintos valores hasta generar el ejemplo deseado

-- call iniciar_ensamblado(1); -- inicia en primera estacion
 
-- call avanzar_estacion(1); -- avanza estacion hasta finalizar su linea de montaje

-- call reporte_vehiculos(1); -- estado de los vehiculos de un pedido

-- call reporte_insumos(1); -- insumos a pedir para finalizar un pedido

-- call reporte_promedio(1); -- promedio de finalizacion de vehiculo en una linea
