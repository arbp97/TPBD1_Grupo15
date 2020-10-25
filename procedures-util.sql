use automotriz;

DELIMITER $$

-- DEBUG / ignore

DROP PROCEDURE IF EXISTS log_msg $$
CREATE PROCEDURE log_msg(cMsg VARCHAR(255))
BEGIN
    insert into logs select 0, cMsg;
END $$

DROP PROCEDURE IF EXISTS throwMsg$$
CREATE PROCEDURE throwMsg(nResultado INT, cMensaje VARCHAR(100))
BEGIN
	SELECT nResultado AS Resultado, cMensaje AS Mensaje;
END$$

DROP FUNCTION IF EXISTS strNullOrEmpty$$
CREATE FUNCTION strNullOrEmpty(string VARCHAR(69))
RETURNS bool DETERMINISTIC
BEGIN
	DECLARE ok BOOL DEFAULT false;
    IF string IS NULL OR string='' THEN SET ok = TRUE; END IF;
	RETURN ok;
END$$

DROP PROCEDURE IF EXISTS existsRowInTable$$
CREATE PROCEDURE existsRowInTable(sTable VARCHAR(69), sIdCol VARCHAR(69), iIdVal int)
BEGIN
	-- ES UN EXPERIMENTO
	-- Mini macro, es mucho mas limpio que varias lineas al pedo
    -- Si la tabla sTable tiene una fila donde cuya columna sIdCol es iIdVal, devuelve true
    -- Si no, devuelve false
    SET @count = 0;
    SET @exe = CONCAT("SELECT COUNT(", sIdCol, ") INTO @count FROM ", sTable, " WHERE ", sIdCol, "=?;");
    
    PREPARE query FROM @exe;
    SET @x = iIdVal;
    EXECUTE query USING @x;
    DEALLOCATE PREPARE query;

	SET @result = false;
	IF (@count > 0) THEN
		-- CALL throwMsg(-1, "No se encuentran resultados para ese ID");
        SET @result = true;
	END IF;
END$$

DROP PROCEDURE IF EXISTS existsRowInTable2$$
CREATE PROCEDURE existsRowInTable2(sTable VARCHAR(69), sIdCol1 VARCHAR(69), iIdVal1 int, sIdCol2 VARCHAR(69), iIdVal2 int)
BEGIN
	-- (SIN PROBAR XDD)
	-- Lo mismo que antes pero para pares
    SET @count = 0;
    SET @exe = CONCAT("SELECT COUNT(", sIdCol1, ") INTO @count FROM ", sTable, " WHERE ", sIdCol1, "=? AND ", sIdCol2, "=?;");
    
    PREPARE query FROM @exe;
    SET @x = iIdVal1,@y = iIdVal2;
    EXECUTE query USING @x,@y;
    DEALLOCATE PREPARE query;

	SET @result = false;
	IF (@count > 0) THEN
        SET @result = true;
	END IF;
END$$

DROP PROCEDURE IF EXISTS proxy_errorOnDuplicate$$
CREATE PROCEDURE proxy_errorOnDuplicate(IN sTable VARCHAR(69), IN sIdCol VARCHAR(69), IN iIdVal int, IN sErr VARCHAR(100))
BEGIN
	IF sErr IS NULL THEN SET sErr = CONCAT("Ya existe una entrada en ",sTable," con ",sIdCol," ",iIdVal,"!"); END IF;
	CALL existsRowInTable(sTable, sIdCol, iIdVal);
    IF @result = true THEN CALL throwMsg(-1, sErr); END IF;
END$$

DROP PROCEDURE IF EXISTS proxy_errorOnMissing$$
CREATE PROCEDURE proxy_errorOnMissing(IN sTable VARCHAR(69), IN sIdCol VARCHAR(69), IN iIdVal int, IN sErr VARCHAR(100))
BEGIN
	IF sErr IS NULL THEN SET sErr = CONCAT("No existen entradas en ",sTable," con ",sIdCol," ",iIdVal,"!"); END IF;
	CALL existsRowInTable(sTable, sIdCol, iIdVal);
    IF @result = false THEN CALL throwMsg(-1, sErr); END IF;
END$$

DELIMITER ;