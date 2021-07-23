



/* |||||||||||||||||||||||||||||| CONSULTA PARA GUARDAR EN UNA VISTA TODOS LOS MUEBLES QUE SE HAN COMPRADO |||||||||||||||||||||||||||||||||||||||||||||||  */

CREATE OR REPLACE VIEW RegistroMuebles as -- Vista que muestra todos los muebles que se han comprado hasta la actualidad.
SELECT muebles.idMuebles, muebles.NombreMueble AS 'Nombre del Mueble', movimientos_financieros.cantidad AS 'Precio de Compra',
	movimientos_financieros.fechaMov AS 'Fecha de Compra', muebles.Descripcion  
FROM compras
INNER JOIN muebles ON compras.idMUebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros on compras.id = movimientos_financieros.id;

-- ***** FALTA AGREGAR LAS FOTOS DE LOS MUEBLES.**********
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */
 
 SELECT * FROM RegistroMuebles;
 
 

/* |||||||||||||||||||||||||||||| VISTA TODOS LOS MUEBLES EN EL ALMACEN |||||||||||||||||||||||||||||||||||||||||||||||  */
CREATE OR REPLACE VIEW inventarioView as -- Muestra todo lo que hay en el almacen.
SELECT muebles.idMuebles, muebles.NombreMueble AS 'Nombre del Mueble', almacen.costoFinal AS 'Costo Final', 
	almacen.precioSugerido AS 'Precio Sugerido', movimientos_financieros.fechaMov AS 'Fecha de Compra', muebles.Descripcion  
FROM compras
INNER JOIN almacen ON compras.id = almacen.idAlmacen
INNER JOIN muebles ON compras.idMuebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros on compras.id = movimientos_financieros.id;

-- ***** FALTA AGREGAR LAS FOTOS DE LOS MUEBLES.**********
/* |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */

select * from inventarioView;

SELECT * FROM almacen;



/* |||||||||||||||||||||||||||||| VISTA TODOS LOS MOVIMIENTOS REALIZADOS ||||||||||||||||||||||||||||||||||||||||||||||| */
-- drop view movimientosregistrados;
CREATE OR REPLACE VIEW movimientosRegistrados as
SELECT movimientos_financieros.id, tipo_movimiento.Tipo, movimientos_financieros.fechaMov as 'Fecha Movimiento',
movimientos_financieros.cantidad as 'Cantidad', movimientos_financieros.capital as 'Capital' 
 FROM movimientos_financieros
INNER JOIN tipo_movimiento ON codigoTipo = codigo
ORDER BY id;

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */


select * from movimientosregistrados;

/*-------------------------------------------------------------------------------------------------*/
/*\\\\\\\\\\\\\\\\\\\\\\\\\\\\ INICIAN TODO LOS PROCEDIMIENTOS ///////////////////////////////////*/
/*-------------------------------------------------------------------------------------------------*/


/*|||||||||||||||************************ PROCEDIMIENTO COMPRA **************************||||||||*/

DROP PROCEDURE IF EXISTS compra; -- SE DEBE LLAMAR  DESDE EL PROGRAMA PRINCIPAL O APLICACION.
DELIMITER //
CREATE PROCEDURE compra(IN NombreMueble VARCHAR(30),IN Descripcion VARCHAR(60),
						fecha DATETIME, costo DECIMAL(8,2), IN descompra VARCHAR(60) )
BEGIN
	DECLARE saldo decimal (8,2) default 0.0;
    DECLARE aux, aux2 int;
    DECLARE sql_error tinyint DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
   
   -- codigo para obtener el saldo que resta de capital. ------- 
   
	SELECT max(id) into aux FROM movimientos_financieros;
	SELECT capital into saldo FROM movimientos_financieros
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
        
				SELECT max(idMuebles) into aux  FROM muebles;					-- se obtine el codigo del mueble que se acaba de insertar
                SELECT max(id) into aux2 FROM movimientos_financieros;  -- se obitne el codigo del movimiento financiero que se inserto.
                SELECT aux as 'Valor de Aux', aux2 as 'Valor de Aux2';
		
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
		SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'ERROR NO TIENES SUFICIENTES FONDOS.';
		-- select 'no tienes suficientes fondos puto'as 'ERROR' ; 
    END IF;     
		
    
END//
DELIMITER ;


/* ||||||||||||||||||||||||||||------------------------------------------------|||||||||||||||||||||||||||||||*/

call compra(null,null,null,800000,null);
call compra('Comedor Cafe','Nada','0', '0', '2021/04/12', 1345, 'Prueba de valores');








/*|||||||||||||||||||||||||||************ PROCEDIMIENTO VENTA ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS venta;
DELIMITER //
CREATE PROCEDURE venta(IN nombreMueble_ VARCHAR(30), IN precio DECIMAL(8,2), IN fechaV DATETIME, IN ventadesc VARCHAR(100))
BEGIN
	
    DECLARE saldo decimal (8,2) default 0.0;
    DECLARE aux, aux2 int;
    DECLARE sql_error tinyint DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
    
    SELECT idMuebles INTO aux FROM muebles -- --------------------> Con el nombre del mueble se busca si existe en la tabla y se obtine su id
    WHERE NombreMueble = nombreMueble_;
	
    this_proc: BEGIN
		IF (aux>0) THEN -- ---> Entra si el nombre del mueble existe.
			SELECT id INTO aux2 FROM compras 
			WHERE idMuebles2=aux; -- ----------------> Se busca el id con el que se compro el mueble.
            
			SELECT idAlmacen INTO aux FROM	almacen
            WHERE idAlmacen=aux2;
            
			IF(aux2 > 0) THEN -- Entra porque el mueble no se ha vendido se puede iniciar la venta.
				
                START TRANSACTION; -- Transaccion para verficar que no haya ningun error en las operaciones que se van a realizar.
						
						SELECT capital INTO saldo FROM movimientos_financieros
						ORDER BY id DESC LIMIT 1; -- --------------------------> Se obtiene el ultimo capital que se inserto en la tabla.
						SET saldo = saldo + precio;
												
						INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
						VALUES(0,4,fechaV,precio,saldo); -- -------------------> Se registra el movimiento financiero (venta). 
						
						SELECT max(id) into aux2 FROM movimientos_financieros; -- --> Para saber cual id le toco al movimiento recien ingresado.
						
						INSERT INTO ventas(id, idMuebles2, descripcion)
						VALUE(aux2, aux, ventadesc); -- -----------------------> Se regisra la venta en su tabla.
						
						SELECT id INTO aux2 FROM compras
						WHERE idMuebles2=aux;  -- -----------------------------> Se obtiene la idcompra del mueble para poder borrar en el almacen.
						
						DELETE FROM almacen WHERE idAlmacen=aux2; -- ------------------> Se borra el mueble vendido del almacen.
						
						IF (sql_error = FALSE) THEN
							COMMIT; -- Si no hay error ejecuta todas las transacciones
						ELSE
							ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                            SIGNAL SQLSTATE 'HY000'
							SET MESSAGE_TEXT = 'ERROR AL INSERTAR.';
							select 'ERROR AL INSERTAR PUTO' AS 'ERROR', saldo, aux, aux2;
						END IF;
                
                
            ELSE -- No se encuentra el mueble buscado en el almacen.
				SIGNAL SQLSTATE 'HY000'
				SET MESSAGE_TEXT = 'ERROR NO EXISTE EN EL ALMACEN';
				SELECT 'error no esta en el alamcen. ' as 'ERROR EN ALMACEN';
                LEAVE this_proc;
				
	
            END IF;
               
		ELSE
			SIGNAL SQLSTATE 'HY000'
			SET MESSAGE_TEXT = 'ERROR NO EXISTE ESE MUEBLE.';
			select 'error no existe ese mueble ' as 'ERROR MUEBLE';
			LEAVE this_proc;
		END IF;
			
            
       
			
			
		END; -- -------------> FIN DE THIS_PROC.

END//

DELIMITER ;

/*|||||||**********************************************************************************||||||*/

   SELECT idMuebles FROM muebles -- --------------------> Con el nombre del mueble se busca si existe en la tabla y se obtine su id
    WHERE NombreMueble = 'negra';

CALL venta('sala negra', 2000, '2021/04/14', 'Se pago al contado');
CALL venta(' negra', 2000, '2021/04/14', 'Se pago al contado');
SELECT * FROM ALMACEN;








/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO DEPOSITO ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS deposito;
DELIMITER // 
CREATE PROCEDURE deposito(IN cantidad DECIMAL(8,2), IN fecha DATETIME )
BEGIN
	 DECLARE saldo decimal (8,2) default 0.0;
     DECLARE aux, aux2 int default 0;
     
     IF(CANTIDAD>0) THEN
		 SELECT max(id) into aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
		 SELECT capital into saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
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


/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/

CALL deposito(0000 , '2021/04/20 23:35:05');
SELECT * FROM movimientos_financieros;






/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO RETIRO ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS retiro;
DELIMITER // 
CREATE PROCEDURE retiro(IN cantRet DECIMAL(8,2), IN fecha DATETIME )
BEGIN
	 DECLARE saldo decimal (8,2) default 0.0;
     DECLARE aux, aux2 int default 0;
     
     SELECT max(id) into aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital into saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
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

/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/

CALL retiro(0.00, '2021/04/22');






/*||||||||||||||||||||||||||||||************* PROCEDIMIENTO OTRO GASTO  ******************|||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS otroGasto;
DELIMITER // 
CREATE PROCEDURE otroGasto(IN nombreMue VARCHAR(30), IN cantGasto DECIMAL(8,2), IN fechaOtro DATETIME, IN descOtro VARCHAR(150) )
BEGIN
	 DECLARE saldo decimal (8,2) default 0.0;
     DECLARE aux, aux2, aux3 int default 0;
     DECLARE sql_error tinyint DEFAULT FALSE;
	 DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET sql_error = TRUE;
     
     
     SELECT max(id) into aux FROM movimientos_financieros; --  ----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital into saldo FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
     WHERE id=aux;
     
     IF(saldo >= cantGasto ) THEN -- ------>Entra si existen los fondos suficientes para realizar la operacion.
		
        set aux = 0;
        SELECT idMuebles INTO aux FROM muebles
        WHERE NombreMueble = nombreMue; --    ---------> Se obtiene el id del mueble que se esta buscando.
        
        SELECT id INTO aux2 FROM compras -- -----------> Con el id del mueble se busca el id de la compra.
        WHERE idMuebles2 = aux;
        
        SELECT idAlmacen INTO aux3 FROM almacen -- -----------> Con el id de la compra se revisa si todavia esta ese mueble en el almacen.
        WHERE idAlmacen= aux2;
        
      
        
        IF(aux3 > 0) THEN -- --------------> Entra si todavia esta el mueble en el almacen.
			 
             
            START TRANSACTION;
				
				SELECT capital INTO saldo FROM movimientos_financieros
				ORDER BY id DESC LIMIT 1; -- --------------------------> Se obtiene el ultimo capital que se inserto en la tabla.
				
                SET saldo = saldo - cantGasto;
		       
                INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
				VALUES(0, 5, fechaOtro, cantGasto, saldo); -- -------------------> Se registra el movimiento financiero (otro gasto). 
				
                SELECT costoFinal INTO saldo FROM almacen
                WHERE idAlmacen = aux3;
               
               
			    SET saldo = saldo + cantGasto; -- ----------> Se suma la cantidad del gasto a lo que ya tiene gasto final.
                UPDATE almacen set costoFinal = saldo
                WHERE idAlmacen = aux3;
             
                    
                SELECT max(id) into aux2 FROM movimientos_financieros;
                
                INSERT INTO otros_gastos(id, idMuebles2, descripcion)
                VALUES(aux2, aux, descOtro);
                
                /*----- ******* PROBAR PARTE POR PARTE DE LA INSERCION COMENTADO PARATE DEL CODIGO----*/
                
				IF (sql_error = FALSE) THEN
					-- select 'TODO BIEN' AS 'BIEN', aux, aux2, aux3, saldo;
					COMMIT; -- Si no hay error ejecuta todas las transacciones
				ELSE
					ROLLBACK; -- Si encutra algun error en 1 de las transacciones deja las tablas en su estado original.
                    
                    ALTER TABLE movimientos_financieros AUTO_INCREMENT = 1; -- Para borrar el auto incremento en caso de algun fallo.
                    ALTER TABLE otros_gastos AUTO_INCREMENT = 1; -- ---------> Para borrar el auto incremento en caso de algun fallo.
		
					SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT='ERROR AL INSERTAR';
		            select 'ERROR AL INSERTAR PUTO' AS 'ERROR', aux, aux2, aux3, saldo, cantGasto;
                    
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


/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/


/*|||||||||||||||||||||||||||||************* PROCEDIMIENTO DEPOSITO ******************||||||||||||||||||||||||||||||||*/

DROP PROCEDURE IF EXISTS capitalActual;
DELIMITER // 
CREATE PROCEDURE capitalActual()
BEGIN
	 DECLARE saldo decimal (8,2) DEFAULT 0.00;
     DECLARE aux int DEFAULT 0;
     
     SELECT max(id) into aux FROM movimientos_financieros; -- -----> Se obtiene el ultimo dato de captial de la tabla.
	 SELECT capital FROM movimientos_financieros -- ----> Se guarda el dato obtendio anteriormente.
     WHERE id=aux;
    
END //
DELIMITER ;

CALL capitalActual();
SELECT @cap;
/*||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/










CALL otroGasto('no existe ',100, null, null);
CALL otroGasto('Sala Cafe', 50, '2021/04/28', 'Se reparo la tela');
SELECT * FROM inventarioView;
select * from muebles;




insert into otros_gastos(id, idMuebles2, decripcion)
values(14,2,'probando esta madre');

SELECT * FROM MUEBLES;
SELECT * FROM movimientos_financieros;
SELECT * FROM COMPRAS;
SELECT * FROM VENTAS;
SELECT * FROM tipo_movimiento;
SELECT * FROM almacen;
SELECT * FROM otros_gastos;
SELECT sum(costoFinal) AS equity FROM ALMACEN
UNION
SELECT sum(precioSugerido) AS inventario FROM ALMACEN;


SELECT muebles.idMuebles, compras.id, muebles.NombreMueble AS 'Nombre del Mueble', movimientos_financieros.cantidad AS 'Precio de Compra',
	movimientos_financieros.fechaMov AS 'Fecha de Compra', muebles.Descripcion  
FROM compras
INNER JOIN muebles ON compras.idMUebles2 = muebles.idMuebles
INNER JOIN movimientos_financieros on compras.id = movimientos_financieros.id;



SELECT capital FROM movimientos_financieros
ORDER BY id DESC LIMIT 1;



SELECT * from movimientos_financieros;
SELECT LAST_INSERT_ID() AS ULTIMO from movimientos_financieros; -- REGRESA DEL ULTIMO REGISTRO INESERTADO SIN IMPORTAR DE QUE LO HAYAN BORRADO
SELECT MAX(ID) FROM movimientos_financieros; -- REGRESA EL NUMERO DEL ULTIMO REGISTRO DE LA TABLA.
SELECT MAX(idMuebles) FROM muebles; -- REGRESA EL NUMERO DEL ULTIMO REGISTRO DE LA TABLA.


SELECT MAX(ID) FROM movimientos_financieros;

SELECT * FROM movimientos_financieros
ORDER BY id DESC LIMIT 1;

SET @autoid := @@auto_increment_increment;
select @autoid;
UPDATE movimientos_financieros set id = @autoid := (@autoid+ 1);

SELECT * from selmovimientosregistrados;
ALTER TABLE movimientos_financieros AUTO_INCREMENT = 0; 

UPDATE `bdnegociomuebles`.`MUEBLES` SET `NombreMueble` = 'Comedor Alto' WHERE (`idMuebles` = '5');
ALTER TABLE movimientos_financieros MODIFY capital decimal(8,2) NOT NULL;
ALTER TABLE movimientos_financieros MODIFY cantidad decimal(8,2) NOT NULL;
ALTER TABLE movimientos_financieros MODIFY fechaMov DATETIME NOT NULL;
ALTER TABLE almacen MODIFY costoFinal 	   decimal(8,2) NOT NULL;
ALTER TABLE almacen MODIFY precioSugerido  decimal(8,2) NOT NULL;
ALTER TABLE otros_gastos CHANGE decripcion descripcion VARCHAR(150);
	

SELECT DATE_FORMAT(fechaMov, '%d/%m/%Y') FROM movimientos_financieros; 