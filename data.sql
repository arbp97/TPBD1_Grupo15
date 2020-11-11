call alta_concesionaria("Autos Adrogué - PEUGEOT", "Av. Hipólito Yrigoyen 8800");
call alta_concesionaria("Cristóbal y Hnos. - SEAT", "España 1492");
call alta_concesionaria("Chrysler", "Av. Espora 13456");

call alta_modelo("Peugeot 307", 5);
call alta_modelo("Peugeot 408", 6);

call alta_modelo("SEAT Ibiza", 4);
call alta_modelo("SEAT León", 5);

call alta_modelo("Chrysler PT Cruiser", 7);
call alta_modelo("Chrysler X", 5);

call alta_proveedor("Pintureria Frias", "Pintura");
call alta_proveedor("Pintura Automotor Quality", "Pintura");

call alta_proveedor("Autopartes Grupo PSA", "Autopartes");
call alta_proveedor("Grupo Volkswagen", "Autopartes");

call alta_proveedor("Total", "Liquidos");

/***********************************************************************************/

-- CARGAR INSUMOS DE CADA PROVEEDOR... segun los modelos y eso

/***********************************************************************************/

call alta_pedido_venta(1);
call alta_detalle_venta(1, 1, 8); -- 16 Peugeot 307 y 408 a Autos Adrogué
call alta_detalle_venta(1, 2, 8);

call alta_pedido_venta(2);
call alta_detalle_venta(2, 3, 20); -- 20 SEAT Ibiza a Cristóbal y Hnos.


call asignar_linea_pedido(1);

call asignar_linea_pedido(2);

/*************************************************************************************/
-- EJEMPLO

-- call iniciar_ensamblado(1); -- inicia en primera estacion

-- call avanzar_estacion(1); -- avanza estacion hasta finalizar su linea de montaje
