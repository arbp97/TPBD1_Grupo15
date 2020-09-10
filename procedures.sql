DELIMITER \\

CREATE PROCEDURE alta_concesionaria(nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN

INSERT INTO concesionaria(nombre,direccion)
VALUES(nombre,direccion);

END\\

CREATE PROCEDURE mod_concesionaria(id INT, nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_direccion VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		-- SET new_nombre = SELECT concesionaria.nombre FROM concesionaria WHERE id = id;
		SELECT concesionaria.nombre INTO new_nombre FROM concesionaria WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF direccion IS NULL OR direccion='' THEN	
		-- SET new_direccion = SELECT concesionaria.direccion FROM concesionaria WHERE id = id;
		SELECT concesionaria.direccion INTO new_direccion FROM concesionaria WHERE id = id;
	ELSE 
		SET new_direccion = direccion;
	END IF;

UPDATE concesionaria
  SET 
    nombre = new_nombre,
    direccion = new_direccion
  WHERE id = id;

END\\

CREATE PROCEDURE baja_concesionaria (id INT, nombre VARCHAR (100), direccion VARCHAR(100))
BEGIN

DELETE FROM concesionaria WHERE id = id;

END\\


DELIMITER ;

CALL alta_concesionaria("pete", "peron");
set SQL_SAFE_UPDATES=0;
CALL mod_concesionaria (1, "tuvieja", "encuatriciclo");

CALL baja_concesionaria(1,"asdas","asdgfg");

select * from concesionaria;
