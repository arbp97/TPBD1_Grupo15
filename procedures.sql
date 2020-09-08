CREATE PROCEDURE alta_concesionaria(nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN

INSERT INTO 'concesionaria'(nombre,descripcion)
VALUES(nombre,descripcion)

END;


CREATE PROCEDURE mod_concesionaria(id INT, nombre VARCHAR(100), direccion VARCHAR(100))
BEGIN

UPDATE 'concesionaria'
  SET 
    nombre = nombre,
    direccion = direccion
  WHERE id = id;

END;
