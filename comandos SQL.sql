


/*-------------------------------------------------------------------------------------------------*/
/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\ INICIAN TODAS LAS VISTAS    ////////////////////////////////////////*/
/*-------------------------------------------------------------------------------------------------*/

/* |||||||||||||||||||||||||||||| CONSULTA PARA GUARDAR EN UNA VISTA TODOS LOS MUEBLES QUE SE HAN COMPRADO |||||||||||||||||||||||||||||||||||||||||||||||  */

CREATE OR REPLACE VIEW RegistroMuebles AS -- Vista que muestra todos los muebles que se han comprado hasta la actualidad.
SELECT muebles.idMuebles, muebles.NombreMueble AS 'Nombre del Mueble', movimientos_financieros.cantidad AS 'Precio de Compra',
	movimientos_financieros.fechaMov AS 'Fecha de Compra', muebles.Descripcion  
FROM compras
INNER JOIN muebles ON compras.idMUebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros ON compras.id = movimientos_financieros.id;

-- ***** FALTA AGREGAR LAS FOTOS DE LOS MUEBLES.**********
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
 
 SELECT * FROM RegistroMuebles;
 
 

/* |||||||||||||||||||||||||||||| VISTA TODOS LOS MUEBLES EN EL ALMACEN |||||||||||||||||||||||||||||||||||||||||||||||  */
CREATE OR REPLACE VIEW inventarioView AS -- Muestra todo lo que hay en el almacen.
SELECT muebles.idMuebles, muebles.NombreMueble AS 'Nombre del Mueble', muebles.Descripcion AS 'Descripcion Mueble', almacen.costoFinal AS 'Costo Final', 
	 movimientos_financieros.fechaMov AS 'Fecha de Compra' 
FROM compras
INNER JOIN almacen ON compras.id = almacen.idAlmacen
INNER JOIN muebles ON compras.idMuebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros ON compras.id = movimientos_financieros.id;

-- ***** FALTA AGREGAR LAS FOTOS DE LOS MUEBLES.**********
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

SELECT * FROM inventarioView;

SELECT * FROM almacen;



/* |||||||||||||||||||||||||||||| VISTA TODOS LOS MOVIMIENTOS REALIZADOS ||||||||||||||||||||||||||||||||||||||||||||||| */
-- drop view movimientosregistrados;
CREATE OR REPLACE VIEW movimientosRegistrados AS
SELECT movimientos_financieros.id, tipo_movimiento.Tipo, movimientos_financieros.fechaMov AS 'Fecha Movimiento',
movimientos_financieros.cantidad AS 'Cantidad', movimientos_financieros.capital AS 'Capital' 
 FROM movimientos_financieros
INNER JOIN tipo_movimiento ON codigoTipo = codigo
ORDER BY id;

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
SELECT * FROM movimientosregistrados;



/* |||||||||||||||||||||||||||||| VISTA TADAS LAS COMPRAS REALIZADAS ||||||||||||||||||||||||||||||||||||||||||||||| */

-- drop view comprasRelizadas;
CREATE OR REPLACE VIEW comprasRealizadas AS
SELECT movimientos_financieros.id, muebles.NombreMueble AS Mueble, muebles.Descripcion AS 'Descripcion',
DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T')  AS 'Fecha de Compra', 
movimientos_financieros.cantidad AS 'Costo', compras.descripcion AS 'Descripcion Compra'
FROM compras
INNER JOIN movimientos_financieros ON movimientos_financieros.id = compras.id 
INNER JOIN muebles ON idMuebles2=idMuebles
ORDER BY id;

-- es la misma vista pero con formato de fecha personalizado
CREATE OR REPLACE VIEW comprasRealizadas AS
SELECT movimientos_financieros.id, muebles.NombreMueble AS Mueble, muebles.Descripcion AS 'Descripcion',
DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T')  AS 'Fecha de Compra', 
movimientos_financieros.cantidad AS 'Costo', compras.descripcion AS 'Descripcion Compra'
FROM compras
INNER JOIN movimientos_financieros ON movimientos_financieros.id = compras.id 
INNER JOIN muebles ON idMuebles2=idMuebles
ORDER BY id;

SELECT DATE_FORMAT(fechaMov, '%d/%m/%Y') FROM movimientos_financieros; 
SELECT DATE_FORMAT(fechaMov, '%d-%m-%Y %T') FROM movimientos_financieros; 

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */



/* ///////////////////// VISTA DE TODOS LOS DEPÓSITOS REALIZADOS HASTA LA ACTUALIDAD //////////////////// */

CREATE OR REPLACE VIEW depositosView AS
SELECT movimientos_financieros.id AS 'id movimiento', tipo_movimiento.Tipo AS 'Tipo',DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T') AS 'Fecha',
movimientos_financieros.cantidad AS 'Cantidad'
FROM tipo_movimiento
INNER JOIN movimientos_financieros ON movimientos_financieros.codigoTipo=tipo_movimiento.codigo
WHERE codigoTipo=1
ORDER BY fechaMov DESC;

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

SELECT * FROM depositosview;

/* //////////////////////// VISTA DE TODOS LOS RETIROS REALIZADOS HASTA LA ACTUALIDAD /////////////////////////////////*/


CREATE OR REPLACE VIEW retirosView AS
SELECT movimientos_financieros.id AS 'id movimiento', tipo_movimiento.Tipo AS 'Tipo',DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T') AS 'Fecha',
movimientos_financieros.cantidad AS 'Cantidad'
FROM tipo_movimiento
INNER JOIN movimientos_financieros ON movimientos_financieros.codigoTipo=tipo_movimiento.codigo
WHERE codigoTipo=2
ORDER BY fechaMov DESC;

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */


/* /////////////////////////////// VISTA DE TODAS LAS VENTAS REGISTRADAS  /////////////////////////////////////////*/


CREATE OR REPLACE VIEW ventasView AS
SELECT movimientos_financieros.id, muebles.NombreMueble AS "Mueble", DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T') AS 'Fecha', 
movimientos_financieros.cantidad, ventas.descripcion AS Descripcion
FROM ventas
INNER JOIN movimientos_financieros ON movimientos_financieros.id = ventas.id
INNER JOIN muebles ON muebles.idMuebles = ventas.idMuebles2
ORDER BY fechaMov DESC;

SELECT * FROM ventasView;

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */



/* /////////////////////////////// VISTA DE TODOS LOS OTROS GASTOS REGISTRADAS  /////////////////////////////////////////*/

CREATE OR REPLACE VIEW otrosGastosView AS
SELECT  movimientos_financieros.id, muebles.idMuebles, muebles.NombreMueble, DATE_FORMAT(movimientos_financieros.fechaMov, '%d-%m-%Y %T') AS 'Fecha',
			movimientos_financieros.cantidad, otros_gastos.descripcion
FROM otros_gastos
INNER JOIN muebles ON muebles.idMuebles = otros_gastos.idMuebles2
INNER JOIN movimientos_financieros ON movimientos_financieros.id = otros_gastos.id
ORDER BY movimientos_financieros.fechaMov DESC;


select * from otrosGastosView;
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */





/*------------------------------------------------------------------------------------------------------------------------*/
/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ INICIAN TODO LOS PROCEDIMIENTOS ////////////////////////////////////////////////*/
/*-----------------------------------------------------------------------------------------------------------------------*/


/*|||||||||||||||************************ PROCEDIMIENTO COMPRA **************************||||||||*/

DROP PROCEDURE IF EXISTS compra; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE compra(IN NombreMueble VARCHAR(30),IN Descripcion VARCHAR(60),
						fecha DATETIME, costo DECIMAL(8,2), IN descompra VARCHAR(60) )
BEGIN
	DECLARE saldo DECIMAL (8,2) DEFAULT 0.0;
    DECLARE aux, aux2 INT;
    DECLARE sql_error TINYINT DEFAULT FALSE;
   
   -- codigo para obtener el saldo que resta de capital. ------- 
   
	SELECT MAX(id) INTO aux FROM movimientos_financieros;
	SELECT capital INTO saldo FROM movimientos_financieros
    WHERE id=aux;	
  -- -------------------------------------------------------- --  
    
    IF (saldo>= costo) 
		THEN 
			START TRANSACTION;
            
				SET saldo= saldo - costo; -- Calcula el saldo final.
        
				INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
				VALUES(0,3,fecha,costo,saldo); 						-- SE REGISTRA COMPRA EN MOVIMIENTOS FINANCIEROS.
        
				INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
				VALUES(0, NombreMueble, Descripcion, '0', '0'); 	-- Se registra el mueble que se acaba de comprar.
        
				SELECT MAX(idMuebles) INTO aux  FROM muebles;					-- se obtine el codigo del mueble que se acaba de insertar
                SELECT MAX(id) INTO aux2 FROM movimientos_financieros;  -- se obitne el codigo del movimiento financiero que se inserto.
                SELECT aux AS 'Valor de Aux', aux2 AS 'Valor de Aux2';
		
				INSERT INTO compras(id, idMuebles2, descripcion)
				VALUES(aux2,aux,descompra); 							-- se registra la compra en su tabla especial.
            
				INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
				VALUES(aux2,costo,0);
			IF (sql_error = FALSE) THEN
				COMMIT; -- Si no hay error ejecuta todas las transacciones
			ELSE
				ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                -- select 'ERROR AL INSERTAR PUTO' AS 'ERROR'; 
                SIGNAL SQLSTATE 'HY000'
                SET MESSAGE_TEXT = 'ERROR AL INSERTAR';
			END IF; 
            
                
    ELSE -- Se genera un error o un mensaje.
		SIGNAL SQLSTATE 'HY001' SET MESSAGE_TEXT = 'ERROR NO TIENES SUFICIENTES FONDOS.';

        -- select 'no tienes suficientes fondos puto'as 'ERROR' ; 
    END IF;     
		
    
END//
DELIMITER ;


/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/

CALL compra(NULL,NULL,NULL,800000,NULL);
CALL compra('prueba workBench2','Nada', '2021-08-12 19:30:01', 199945.55, 'Prueba de valores');






/*|||||||||||||||************************ PROCEDIMIENTO UPDATE COMPRA **************************||||||||*/


DROP PROCEDURE IF EXISTS updateCompra; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE updateCompra(IN iden INT, IN nombreMueble VARCHAR(30), IN DesMueble VARCHAR(60),
						fecha DATETIME, costo DECIMAL(8,2), IN desCompra VARCHAR(60) )
BEGIN
	DECLARE saldo DECIMAL (8,2) DEFAULT 0.0;
    DECLARE aux, aux2 INT;
    DECLARE sql_error TINYINT DEFAULT FALSE;
--    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
   
   -- codigo para obtener el saldo que resta de capital. ------- 
   
	SELECT MAX(id) INTO aux FROM movimientos_financieros;
	SELECT capital INTO saldo FROM movimientos_financieros
    WHERE id=aux;	
  -- -------------------------------------------------------- --  
    
    IF (saldo>= costo) 
		THEN 
			START TRANSACTION;
            
				SET saldo = saldo - costo; -- Calcula el saldo final.
				
                -- ########### Se actualiza la tabla MOVIMIENTOS_FINANCIEROS #########
                
                UPDATE bdnegociomuebles.movimientos_financieros SET fechaMov = fecha WHERE (id=iden); 
                UPDATE bdnegociomuebles.movimientos_financieros SET cantidad = costo WHERE (id=iden); 
                UPDATE bdnegociomuebles.movimientos_financieros SET capital = saldo  WHERE (id=iden); 
                
                -- ########### Se actualiza la tabla MUEBLES ###################
                
                SELECT idMuebles2 INTO aux2 FROM compras WHERE (id=iden); -- Se obtiene el id del mueble que se va a modificar.
                UPDATE bdnegociomuebles.muebles SET NombreMueble = nombreMueble WHERE (idMuebles = aux2);
                UPDATE bdnegociomuebles.muebles SET Descripcion = DesMueble WHERE (idMuebles = aux2);
                
                -- ########### Se actualiza la tabla COMPRAS ###################
				
				UPDATE bdnegociomuebles.compras SET descripcion = desCompra WHERE (id=iden);
            						
			IF (sql_error = FALSE) THEN
				COMMIT; -- Si no hay error ejecuta todas las transacciones
			ELSE
				ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                -- select 'ERROR AL INSERTAR PUTO' AS 'ERROR'; 
                SIGNAL SQLSTATE 'HY000'
                SET MESSAGE_TEXT = 'ERROR AL INSERTAR';
			END IF; 
            
                
    ELSE -- Se genera un error o un mensaje.
	--  signal sqlstate '45000' set message_text = 'My Error Message';
		SIGNAL SQLSTATE 'HY001' SET MESSAGE_TEXT = 'ERROR NO TIENES SUFICIENTES FONDOS.';

        SELECT 'no tienes suficientes fondos puto'AS 'ERROR' ; 
    END IF;     
		
    
END//
DELIMITER ;




CALL updateCompra(2, 'Sala Cafee', 'modificada', '2021-09-04 19:30:01', '200000.00', 'Sin comentario');

/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/


/*|||||||||||||||||||||||||||************ PROCEDIMIENTO VENTA ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS venta;
DELIMITER //
CREATE PROCEDURE venta(IN idMuebles_ INT, IN precio DECIMAL(8,2), IN fechaV DATETIME, IN ventadesc VARCHAR(100))
BEGIN
	
    DECLARE saldo DECIMAL (8,2) DEFAULT 0.0;
    DECLARE aux, aux2, aux3 INT;
    DECLARE sql_error TINYINT DEFAULT FALSE;
  
    
    THIS_PROC: BEGIN  -- Instruccion necesaria para poder el procedimiento con un LEAVE THIS_PROC;
	
			SELECT id INTO aux2 FROM compras 
			WHERE idMuebles2=idMuebles_; -- ----------------> Se busca el id de compras con el que se compro el mueble.
             
			SELECT idAlmacen INTO aux3 FROM	almacen
            WHERE idAlmacen=aux2;
             
			IF(aux3 > 0) THEN -- Entra porque el mueble no se ha vendido se puede iniciar la venta.
				
                START TRANSACTION; -- Transaccion para verficar que no haya ningun error en las operaciones que se van a realizar.
						
					SELECT capital INTO saldo FROM movimientos_financieros
					ORDER BY id DESC LIMIT 1; -- --------------------------> Se obtiene el ultimo capital que se inserto en la tabla.
					SET saldo = saldo + precio;
											
					INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
					VALUES(0,4,fechaV,precio,saldo); -- -------------------> Se registra el movimiento financiero (venta). 
					
					SELECT MAX(id) INTO aux FROM movimientos_financieros; -- --> Para saber cual id le toco al movimiento recien ingresado.
																		
					INSERT INTO ventas(id, idMuebles2, descripcion)
					VALUE(aux, idMuebles_, ventadesc); -- -----------------------> Se regisra la venta en su tabla.
				
                    
					DELETE FROM almacen WHERE idAlmacen=aux3; -- ------------------> Se borra el mueble vendido del almacen.
				
				IF (sql_error = FALSE) THEN
					COMMIT; -- Si no hay error ejecuta todas las transacciones
				ELSE
					ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
					SIGNAL SQLSTATE 'HY000'
					SET MESSAGE_TEXT = 'ERROR AL INSERTAR.';
					SELECT 'ERROR AL INSERTAR PUTO' AS 'ERROR', saldo, aux, aux2;
				END IF;
                
                
            ELSE -- No se encuentra el mueble buscado en el almacen.
				SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'ERROR NO EXISTE EN EL ALMACEN';
				SELECT 'error no esta en el alamcen. ' AS 'ERROR EN ALMACEN';
                LEAVE THIS_PROC;
				
	
            END IF;
        			
		END; -- -------------> FIN DE THIS_PROC.

END//

DELIMITER ;


CALL venta(9, 5000, '2021/04/15', 'Se pago al contado');

/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/


/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO UPDATE  VENTA ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS updateVenta; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE updateVenta(IN iden INT, fechaNew DATETIME, cantNew DECIMAL(8,2), descNew VARCHAR(100))
BEGIN
-- iden ------> Es el id del movimiento financiero en el que se va hacer la modificacion.
-- fechaNew --> Es la fecha que se va actualizar.
-- cantNew ---> Es la cantidad que se va actualizar.
-- descNew ---> Es la descripcion que el usuario manda.
	    
	DECLARE saldoTotal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital con el que se cuenta actualmente, en el id mas grande.
    DECLARE saldoLocal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital relacionado con el id que se va a modificar.
	DECLARE diferencia DECIMAL (8,2) DEFAULT 0.0; -- Guarda lo que se tiene que agregar o restar de capital actual.
	DECLARE capActual  DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE capLocal   DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE cantAux    DECIMAL (8,2) DEFAULT 0.0; -- Guarda la cantidad que esta en la base de datos. 
    DECLARE aux 	   INT DEFAULT 0;
    DECLARE sql_error  TINYINT DEFAULT FALSE;
      
   -- codigo para obtener el capital actual y el capital relacioando a la id de modificacion . ------- 

    SELECT capital INTO capActual FROM movimientos_financieros
    WHERE id=(SELECT MAX(id) FROM movimientos_financieros);	-- Se obtiene el capital restante hasta el momento.
    
    SELECT capital INTO capLocal FROM movimientos_financieros
    WHERE id=iden;
    
  -- -------------------------------------------------------- --  
    SELECT cantidad INTO cantAux FROM movimientos_financieros
    WHERE id=iden;
    
    
    IF (cantNew >= cantAux) 
		THEN 
        --  Si la cantidad que ingresa es mayor o igual a la cantidad que arroja la subconsulta se realiza una suma al capital
	  
        SET diferencia = cantNew   - cantAux;
        SET saldoTotal = capActual + diferencia;
        SET saldoLocal = capLocal  + diferencia;
   
   ELSE
		
        SET diferencia = cantAux   - cantNew;
        SET saldoTotal = capActual - diferencia;
        SET saldoLocal = capLocal  - diferencia;
        
    END IF;       
        
	START TRANSACTION;
          
		-- ########### Se actualiza la tabla MOVIMIENTOS_FINANCIEROS #########
		
        SELECT MAX(id) INTO aux FROM movimientos_financieros; -- Se obtiene el id de la ultima transaccion.
		
        UPDATE bdnegociomuebles.movimientos_financieros SET fechaMov = fechaNew, cantidad = cantNew, capital=saldoLocal WHERE (id=iden); 
        UPDATE bdnegociomuebles.movimientos_financieros SET capital = saldoTotal  WHERE (id=aux);
        
        -- ###########-- Se actualiza la tabla VENTAS ----------###########
       
       UPDATE ventas SET descripcion = descNew WHERE id=iden;
                            						
			IF (sql_error = FALSE) THEN
				COMMIT; -- Si no hay error ejecuta todas las transacciones
			ELSE
				ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                -- select 'ERROR AL INSERTAR PUTO' AS 'ERROR'; 
                SIGNAL SQLSTATE 'HY000'
                SET MESSAGE_TEXT = 'ERROR AL INSERTAR';
			END IF; 
   
END//
DELIMITER ;

CALL updateVenta(11111, '2021/09/28 19:35:05', 1500.00, 'Se actualizo desde Workbench');
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/


/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO DEPOSITO ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS deposito;
DELIMITER // 
CREATE PROCEDURE deposito(IN cantidad DECIMAL(8,2), IN fecha DATETIME )
BEGIN
	 DECLARE saldo DECIMAL (8,2) DEFAULT 0.0;
     DECLARE aux, aux2 INT DEFAULT 0;
     
     IF(CANTIDAD>0) THEN
		 SELECT MAX(id) INTO aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
		 SELECT capital INTO saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
		 WHERE id=aux;
			
		 SET saldo = saldo + cantidad;
			  
		 INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
		 VALUES(0,1,fecha,cantidad ,saldo); -- ------------------------> Se registra el movimiento financiero (deposito). 
     ELSE
			SIGNAL SQLSTATE 'HY000'
			SET MESSAGE_TEXT = 'ERROR LA CANTIDAD DEBE DE SER MAYOR QUE 0.';
            
            -- select 'error no existe ese mueble ' as 'ERROR MUEBLE';
     END IF;
     
    
END //
DELIMITER ;


CALL deposito(0000 , '2021/04/20 23:35:05');
SELECT * FROM movimientos_financieros;

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/




/*|||||||||||||||************************ PROCEDIMIENTO UPDATE DEPOSITO **************************||||||||*/


DROP PROCEDURE IF EXISTS updateDeposito; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE updateDeposito(IN iden INT, fechaNew DATETIME, cantNew DECIMAL(8,2))
BEGIN
-- iden ------> Es el id del movimiento financiero en el que se va hacer la modificacion.
-- fechaNew --> Es la fecha que se va actualizar.
-- cantNew ---> Es la cantidad que se va actualizar.
	
	DECLARE saldoTotal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital con el que se cuenta actualmente, en el id mas grande.
    DECLARE saldoLocal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital relacionado con el id que se va a modificar.
	DECLARE diferencia DECIMAL (8,2) DEFAULT 0.0; -- Guarda lo que se tiene que agregar o restar de capital actual.
	DECLARE capActual  DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE capLocal   DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE cantAux    DECIMAL (8,2) DEFAULT 0.0; -- Guarda la cantidad que esta en la base de datos. 
    DECLARE aux 	   INT DEFAULT 0;
    DECLARE sql_error  TINYINT DEFAULT FALSE;
    
   
   -- codigo para obtener el capital actual y el capital relacioando a la id de modificacion . ------- 

    SELECT capital INTO capActual FROM movimientos_financieros
    WHERE id=(SELECT MAX(id) FROM movimientos_financieros);	-- Se obtiene el capital restante hasta el momento.
    
    SELECT capital INTO capLocal FROM movimientos_financieros
    WHERE id=iden;
    
  -- -------------------------------------------------------- --  
    SELECT cantidad INTO cantAux FROM movimientos_financieros
    WHERE id=iden;
    
    
    IF (cantNew >= cantAux) 
		THEN 
        --  Si la cantidad que ingresa es mayor o igual a la cantidad que arroja la subconsulta se realiza una suma al capital
	  
        SET diferencia = cantNew   - cantAux;
        SET saldoTotal = capActual + diferencia;
        SET saldoLocal = capLocal  + diferencia;
   
   ELSE
		
        SET diferencia = cantAux   - cantNew;
        SET saldoTotal = capActual - diferencia;
        SET saldoLocal = capLocal  - diferencia;
        
    END IF;       
        
	START TRANSACTION;
          
		-- ########### Se actualiza la tabla MOVIMIENTOS_FINANCIEROS #########
		
        SELECT MAX(id) INTO aux FROM movimientos_financieros; -- Se obtiene el id de la ultima transaccion.
		
        UPDATE bdnegociomuebles.movimientos_financieros SET fechaMov = fechaNew, cantidad = cantNew, capital=saldoLocal WHERE (id=iden); 
        UPDATE bdnegociomuebles.movimientos_financieros SET capital = saldoTotal  WHERE (id=aux); 
                            						
			IF (sql_error = FALSE) THEN
				COMMIT; -- Si no hay error ejecuta todas las transacciones
			ELSE
				ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                -- select 'ERROR AL INSERTAR PUTO' AS 'ERROR'; 
                SIGNAL SQLSTATE 'HY000'
                SET MESSAGE_TEXT = 'ERROR AL INSERTAR';
			END IF; 
   
END//
DELIMITER ;

CALL updateDeposito(35, '2021/09/28 19:35:05', 1500.00);

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/




/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO RETIRO ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS retiro;
DELIMITER // 
CREATE PROCEDURE retiro(IN cantRet DECIMAL(8,2), IN fecha DATETIME )
BEGIN
	 DECLARE saldo DECIMAL (8,2) DEFAULT 0.0;
     DECLARE aux, aux2 INT DEFAULT 0;
     
     SELECT MAX(id) INTO aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital INTO saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
     WHERE id=aux;
     
     IF(cantRet>0) THEN
		 IF(saldo >= cantRet ) THEN
			SET saldo = saldo - cantRet;
			  
			  
			INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
			VALUES(0,2,fecha,cantRet ,saldo); -- ------------------------> Se registra el movimiento financiero (retiro).
		 ELSE
			SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='NO TIENES FONDOS SUFICIENTES';
			SELECT 'NO TIENES SUFICIENTES FONDOS PUTO' AS 'ERROR SALDO';
		 END IF;      
     ELSE
		SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='LA CANTIDAD A RETIRAR DEBE DE SER MAYOR A 0';
	END IF;
		
    
END //
DELIMITER ;


CALL retiro(0.00, '2021/04/22');

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/



/*|||||||||||||||************************ PROCEDIMIENTO UPDATE RETIRO **************************||||||||*/


DROP PROCEDURE IF EXISTS updateRetiro; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE updateRetiro(IN iden INT, fechaNew DATETIME, cantNew DECIMAL(8,2))
BEGIN
-- iden ------> Es el id del movimiento financiero en el que se va hacer la modificacion.
-- fechaNew --> Es la fecha que se va actualizar.
-- cantNew ---> Es la cantidad que se va actualizar.
	    
	DECLARE saldoTotal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital con el que se cuenta actualmente, en el id mas grande.
    DECLARE saldoLocal DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital relacionado con el id que se va a modificar.
	DECLARE diferencia DECIMAL (8,2) DEFAULT 0.0; -- Guarda lo que se tiene que agregar o restar de capital actual.
	DECLARE capActual  DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE capLocal   DECIMAL (8,2) DEFAULT 0.0; -- Guarda el capital actual 
	DECLARE cantAux    DECIMAL (8,2) DEFAULT 0.0; -- Guarda la cantidad que esta en la base de datos. 
    DECLARE aux 	   INT DEFAULT 0;
    DECLARE sql_error  TINYINT DEFAULT FALSE;
      
   -- codigo para obtener el capital actual y el capital relacioando a la id de modificacion . ------- 

    SELECT capital INTO capActual FROM movimientos_financieros
    WHERE id=(SELECT MAX(id) FROM movimientos_financieros);	-- Se obtiene el capital restante hasta el momento.
    
    SELECT capital INTO capLocal FROM movimientos_financieros
	WHERE id=iden;
   
   THIS_PROC: BEGIN
   
		IF(cantNew < 1 || cantNew > capActual || cantNew > capLocal)
			THEN
				-- Entra por que lo que se quiere retirar es una cantidad que existe en la cuenta.
                SIGNAL SQLSTATE 'HY000'
					SET MESSAGE_TEXT = 'ERROR EN LA CANTIDAD A MODIFICAR';
				 LEAVE THIS_PROC; -- Sale del procedimiento debido a que no hay condiciones para continuar con la ejecucion.
		END IF;
		   
	  
		
		
	  -- -------------------------------------------------------- --  
		SELECT cantidad INTO cantAux FROM movimientos_financieros
		WHERE id=iden;
		
		
		IF (cantNew >= cantAux) 
			THEN 
			--  Si la cantidad que ingresa es mayor o igual a la cantidad que arroja la subconsulta se realiza una suma al capital
			SET diferencia = cantNew   - cantAux;
			SET saldoTotal = capActual - diferencia;
			SET saldoLocal = capLocal  - diferencia;
		 
	   ELSE
			SET diferencia = cantAux   - cantNew;
			SET saldoTotal = capActual + diferencia;
			SET saldoLocal = capLocal  + diferencia;
				 
		END IF;       
			
		START TRANSACTION;
			  
			-- ########### Se actualiza la tabla MOVIMIENTOS_FINANCIEROS #########
			
			SELECT MAX(id) INTO aux FROM movimientos_financieros; -- Se obtiene el id de la ultima transaccion.
			
			UPDATE bdnegociomuebles.movimientos_financieros SET fechaMov = fechaNew, cantidad = cantNew, capital=saldoLocal WHERE (id=iden); 
			UPDATE bdnegociomuebles.movimientos_financieros SET capital = saldoTotal  WHERE (id=aux); 
														
				IF (sql_error = FALSE) THEN
					COMMIT; -- Si no hay error ejecuta todas las transacciones
				ELSE
					ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
					-- select 'ERROR AL INSERTAR PUTO' AS 'ERROR'; 
					SIGNAL SQLSTATE 'HY000'
					SET MESSAGE_TEXT = 'ERROR AL INSERTAR';
				END IF; 
   END; -- Fin del procedimiento.
END//
DELIMITER ;



CALL updateRetiro(10, '2021/09/28 19:35:05', 1500.00);

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/



/*||||||||||||||||||||||||||||||************* PROCEDIMIENTO OTRO GASTO  ******************|||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS otroGasto;
DELIMITER // 
CREATE PROCEDURE otroGasto(IN idmue INT, IN cantGasto DECIMAL(8,2), IN fechaOtro DATETIME, IN descOtro VARCHAR(150) )
BEGIN

-- idmue ------> Se recibe el id del mueble al que se le va agregar algun gasto.
-- cantGasto --> Cantidad de dinero del gasto o reparacion.
-- fechaOtro --> Cuando se agrego el gasto.
-- descOtro ---> Que tipo de reparacion se hizo. 

	 DECLARE saldo DECIMAL (8,2) DEFAULT 0.0; -- Saldo con el que se cuenta en el momento de la operacion.
     DECLARE total DECIMAL (8.2) DEFAULT 0.0; -- Para guardar la suma del costo final mas el gasto.
     DECLARE aux, aux2, aux3 INT DEFAULT 0;
     DECLARE alm INT DEFAULT 0; -- Guarda el id del almacen que es igual al de compras.
     DECLARE sql_error TINYINT DEFAULT FALSE;
	 
     -- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
     
     
     SELECT MAX(id) INTO aux FROM movimientos_financieros; --  ----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital INTO saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
     WHERE id=aux;
     
     IF(saldo >= cantGasto ) THEN -- ------>Entra si existen los fondos suficientes para realizar la operacion.
		
		SELECT id INTO alm FROM compras
		WHERE idMuebles2 = idmue;
        
        SELECT idAlmacen INTO aux3 FROM almacen -- -----------> Con el id de la compra se revisa si todavia esta ese mueble en el almacen.
        WHERE idAlmacen= alm;
               
        IF(aux3 > 0) THEN -- --------------> Entra si todavia esta el mueble en el almacen.
			 
             
            START TRANSACTION;
				
			    SET saldo = saldo - cantGasto;
		       
                INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
				VALUES(0, 5, fechaOtro, cantGasto, saldo); -- -----> Se registra el movimiento financiero (otro gasto). 
				
                              
                SELECT costoFinal INTO total FROM almacen
                WHERE idAlmacen = alm; -- alm tiene el id de compra relacionado al mueble al que se le esta haciendo la reparacion.
               
               
			    SET total = total + cantGasto; -- ------> Se suma la cantidad del gasto a lo que ya tiene gasto final.
                UPDATE almacen SET costoFinal = total
                WHERE idAlmacen = alm;
             
                    
                SELECT MAX(id) INTO aux2 FROM movimientos_financieros;
                
                INSERT INTO otros_gastos(id, idMuebles2, descripcion)
                VALUES(aux2, idmue, descOtro);
                
                /*----- ******* PROBAR PARTE POR PARTE DE LA INSERCION COMENTADO PARATE DEL CODIGO----*/
                
				IF (sql_error = FALSE) THEN
					-- select 'TODO BIEN' AS 'BIEN', aux, aux2, aux3, saldo;
					COMMIT; -- Si no hay error ejecuta todas las transacciones
				ELSE
					ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                    
           --         ALTER TABLE movimientos_financieros AUTO_INCREMENT = 1; -- Para borrar el auto incremento en caso de algun fallo.
           --         ALTER TABLE otros_gastos AUTO_INCREMENT = 1; -- ---------> Para borrar el auto incremento en caso de algun fallo.
		
					SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='ERROR AL INSERTAR';
		            SELECT 'ERROR AL INSERTAR PUTO' AS 'ERROR', aux, aux2, aux3, saldo, cantGasto;
                    
				END IF;
            
            
        ELSE
			SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='NO EXISTE ESE MUEBLE';
			SELECT 'NO EXISTE ESE MUEBLE PUTO' AS 'ERROR EXISTENCIA',saldo, aux, aux2, cantGasto;
        END IF;
        
		
     ELSE
		SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='NO TIENES FONDOS SUFICIENTES';
		SELECT 'NO TIENES SUFICIENTES FONDOS PUTO' AS 'ERROR SALDO';
     END IF;      
     
    
END //
DELIMITER ;


CALL otroGasto(5,200.00,'2021/09/28 19:35:05','Se agrego gasto desde workbench');

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/





/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO CAPITAL ACTUAL ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS capitalActual;
DELIMITER // 
CREATE PROCEDURE capitalActual()
BEGIN
	 DECLARE saldo DECIMAL (8,2) DEFAULT 0.00;
     DECLARE aux INT DEFAULT 0;
     
     SELECT MAX(id) INTO aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
     WHERE id=aux;
    
END //
DELIMITER ;

CALL capitalActual();
SELECT @cap;
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/



SELECT * FROM MUEBLES;
SELECT * FROM movimientos_financieros;
SELECT * FROM COMPRAS;
SELECT * FROM VENTAS;
SELECT * FROM tipo_movimiento;
SELECT * FROM almacen;
SELECT * FROM otros_gastos;
SELECT SUM(costoFinal) AS equity FROM ALMACEN
UNION
SELECT SUM(precioSugerido) AS inventario FROM ALMACEN;


SELECT muebles.idMuebles, compras.id, muebles.NombreMueble AS 'Nombre del Mueble', movimientos_financieros.cantidad AS 'Precio de Compra',
	movimientos_financieros.fechaMov AS 'Fecha de Compra', muebles.Descripcion  
FROM compras
INNER JOIN muebles ON compras.idMUebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros ON compras.id = movimientos_financieros.id;



SELECT capital FROM movimientos_financieros
ORDER BY id DESC LIMIT 1;



SELECT * FROM movimientos_financieros;
SELECT LAST_INSERT_ID() AS ULTIMO FROM movimientos_financieros; -- REGRESA DEL ULTIMO REGISTRO INESERTADO SIN IMPORTAR DE QUE LO HAYAN BORRADO
SELECT MAX(ID) FROM movimientos_financieros; -- REGRESA EL NUMERO DEL ULTIMO REGISTRO DE LA TABLA.
SELECT MAX(idMuebles) FROM muebles; -- REGRESA EL NUMERO DEL ULTIMO REGISTRO DE LA TABLA.


SELECT MAX(ID) FROM movimientos_financieros;

SELECT * FROM movimientos_financieros
ORDER BY id DESC LIMIT 1;

SET @autoid := @@auto_increment_increment;
SELECT @autoid;
UPDATE movimientos_financieros SET id = @autoid := (@autoid+ 1);

SELECT * FROM selmovimientosregistrados;
ALTER TABLE movimientos_financieros AUTO_INCREMENT = 0; 

UPDATE `bdnegociomuebles`.`MUEBLES` SET `NombreMueble` = 'Comedor Alto' WHERE (`idMuebles` = '5');
ALTER TABLE movimientos_financieros MODIFY capital DECIMAL(8,2) NOT NULL;
ALTER TABLE movimientos_financieros MODIFY cantidad DECIMAL(8,2) NOT NULL;
ALTER TABLE movimientos_financieros MODIFY fechaMov DATETIME NOT NULL;
ALTER TABLE almacen MODIFY costoFinal 	   DECIMAL(8,2) NOT NULL;
ALTER TABLE almacen MODIFY precioSugerido  DECIMAL(8,2) NOT NULL;
ALTER TABLE otros_gastos CHANGE decripcion descripcion VARCHAR(150);
	

SELECT DATE_FORMAT(fechaMov, '%d/%m/%Y') FROM movimientos_financieros; 