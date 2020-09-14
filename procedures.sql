DELIMITER $$

-- CONCESIONARIA

DROP PROCEDURE IF EXISTS alta_concesionaria$$ 
CREATE PROCEDURE alta_concesionaria(nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN

INSERT INTO concesionaria(nombre,direccion)
VALUES(nombre,direccion);

END$$

DROP PROCEDURE IF EXISTS mod_concesionaria$$ 
CREATE PROCEDURE mod_concesionaria(id INT, nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_direccion VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT concesionaria.nombre INTO new_nombre FROM concesionaria WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF direccion IS NULL OR direccion='' THEN	
		SELECT concesionaria.direccion INTO new_direccion FROM concesionaria WHERE id = id;
	ELSE 
		SET new_direccion = direccion;
	END IF;

UPDATE concesionaria
  SET 
    nombre = new_nombre,
    direccion = new_direccion
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_concesionaria$$
CREATE PROCEDURE baja_concesionaria (id INT)
BEGIN

DELETE FROM concesionaria WHERE id = id;

END$$

-- MODELO

DROP PROCEDURE IF EXISTS alta_modelo$$ 
CREATE PROCEDURE alta_modelo(nombre VARCHAR(100))
BEGIN

INSERT INTO modelo(nombre)
VALUES(nombre);

END$$

DROP PROCEDURE IF EXISTS mod_modelo$$ 
CREATE PROCEDURE mod_modelo(id INT, nombre VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT modelo.nombre INTO new_nombre FROM modelo WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;

UPDATE modelo
  SET 
    nombre = new_nombre
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_modelo$$
CREATE PROCEDURE baja_modelo (id INT)
BEGIN

DELETE FROM modelo WHERE id = id;

END$$

-- PROVEEDOR

DROP PROCEDURE IF EXISTS alta_proveedor$$ 
CREATE PROCEDURE alta_proveedor(nombre VARCHAR(100), rubro VARCHAR(100))
BEGIN

INSERT INTO proveedor(nombre,rubro)
VALUES(nombre,rubro);

END$$

DROP PROCEDURE IF EXISTS mod_proveedor$$ 
CREATE PROCEDURE mod_proveedor(id INT, nombre VARCHAR(100), rubro VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_rubro VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT proveedor.nombre INTO new_nombre FROM proveedor WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF rubro IS NULL OR rubro='' THEN	
		SELECT proveedor.rubro INTO new_rubro FROM proveedor WHERE id = id;
	ELSE 
		SET new_rubro = rubro;
	END IF;

UPDATE proveedor
  SET 
    nombre = new_nombre,
    rubro = new_rubro
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_proveedor$$
CREATE PROCEDURE baja_proveedor (id INT)
BEGIN

DELETE FROM proveedor WHERE id = id;

END$$

-- INSUMO
						
DROP PROCEDURE IF EXISTS alta_insumo$$ 
CREATE PROCEDURE alta_insumo(nombre VARCHAR(100), descripcion VARCHAR(100))
BEGIN

INSERT INTO insumo(nombre,descripcion)
VALUES(nombre,descripcion);

END$$

DROP PROCEDURE IF EXISTS mod_insumo$$ 
CREATE PROCEDURE mod_insumo(id INT, nombre VARCHAR(100), descripcion VARCHAR(100))
BEGIN
	
	DECLARE new_nombre VARCHAR(100);
	DECLARE new_descripcion VARCHAR(100);

	IF nombre IS NULL OR nombre='' THEN	
		SELECT insumo.nombre INTO new_nombre FROM insumo WHERE id = id;
	ELSE 
		SET new_nombre = nombre;
	END IF;
	IF descripcion IS NULL OR descripcion='' THEN	
		SELECT insumo.descripcion INTO new_descripcion FROM insumo WHERE id = id;
	ELSE 
		SET new_descripcion = descripcion;
	END IF;

UPDATE insumo
  SET 
    nombre = new_nombre,
    descripcion = new_descripcion
  WHERE id = id;

END$$

DROP PROCEDURE IF EXISTS baja_insumo$$
CREATE PROCEDURE baja_insumo (id INT)
BEGIN

DELETE FROM insumo WHERE id = id;

END$$


DELIMITER ;
