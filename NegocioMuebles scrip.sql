-- drop database bdNegocioMuebles;

CREATE DATABASE IF NOT EXISTS bdNegocioMuebles;
USE bdNegocioMuebles;

-- // ******************* CREA LAS TABLAS PADRES ******************************//

-- Se crea la primer tabla padre MUEBLES

-- CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Muebles DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Muebles 
(
	idMuebles 			int not null unique auto_increment,
	NombreMueble 		varchar(30) not null,
    Descripcion 		varchar(60),
    foto1 				longblob DEFAULT NULL,
    foto2				longblob DEFAULT NULL,
    PRIMARY KEY (idMuebles)
)ENGINE = InnoDB;


-- Se crea la segunda Tabla padre TIPO DE MOVIMIENTOS
CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Tipo_Movimiento
(
	codigo 		int 			not null unique auto_increment,
    Tipo		varchar(30) 	not null,
    PRIMARY KEY (codigo)
)ENGINE = InnoDb;

-- // ******************* FIN DE LAS TABLAS PADRES ******************************//




-- ------SE CREAN LAS TABLAS HIJAS ----

CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Movimientos_Financieros
(
	id				int 			not null unique auto_increment,
    codigoTipo		int 			not null,
    fechaMov		datetime		not null,
    cantidad		decimal(8,2) 	not null,
    capital			decimal(8,2)    not null, 
    PRIMARY KEY (id),
    CONSTRAINT fk_MovimientosTipo FOREIGN KEY (codigoTipo) REFERENCES Tipo_Movimiento (codigo) on delete no action
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Compras 
(
    id 						INT NOT NULL UNIQUE AUTO_INCREMENT,
    idMuebles2 				INT NOT NULL,
    descripcion 			VARCHAR(60),
    
    CONSTRAINT fk_MovimientosCompras FOREIGN KEY (id)
        REFERENCES Movimientos_Financieros (id)
        ON DELETE NO ACTION,
        
    CONSTRAINT fk_MueblesCompras FOREIGN KEY (idMuebles2)
        REFERENCES muebles (idMuebles)
        ON DELETE NO ACTION,
        PRIMARY KEY (id)
        
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Ventas
(
    id 						INT NOT NULL UNIQUE AUTO_INCREMENT,
    idMuebles2 				INT NOT NULL,
    descripcion 			VARCHAR(100),
    
    CONSTRAINT fk_MovimientosVentas FOREIGN KEY (id)
        REFERENCES Movimientos_Financieros (id)
        ON DELETE NO ACTION,
        
    CONSTRAINT fk_MueblesVentas FOREIGN KEY (idMuebles2)
        REFERENCES muebles (idMuebles)
        ON DELETE NO ACTION,
        PRIMARY KEY (id)
        
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Otros_Gastos
(
	id 				INT NOT NULL UNIQUE AUTO_INCREMENT, 
    idMuebles2 		INT NOT NULL,
    descripcion		VARCHAR(150),
    
    CONSTRAINT fk_MovimientosOtrosGastos FOREIGN KEY (id) REFERENCES Movimientos_Financieros (id)
    ON DELETE NO ACTION,
    CONSTRAINT fk_MueblesOtrosGastos FOREIGN KEY (idMuebles2) REFERENCES Muebles (idMuebles)
    ON DELETE NO ACTION,
    PRIMARY KEY (id)

)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS bdNegocioMuebles.Almacen -- Solo debe haber registros de los muebles que aun no se han vendido
(
	idAlmacen 		INT NOT NULL UNIQUE AUTO_INCREMENT,
    costoFinal		DECIMAL (8,2) DEFAULT 0 COMMENT 'Se debe calcular sumando el valor de compras y gastos extras',
    precioSugerido  DECIMAL (8,2) DEFAULT 0 COMMENT 'Se asigna a criterio de los usuarios',
    
    CONSTRAINT fk_ComprasAlmacen FOREIGN KEY (idAlmacen) REFERENCES Compras (id)
    ON DELETE NO ACTION,
    PRIMARY KEY (idAlmacen)

)ENGINE=INNODB;






/*||||||||||||||||||||||||||||||||||| DATOS PARA CARGAR LA BASE DE DATOS |||||||||||||||||||||||||||||||||||||*/


 
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/ 

 -- SE INSERTAN LOS TIPOS DE MOVIMIENTOS EN ***tipo_movimientos***
 INSERT INTO tipo_movimiento(codigo, tipo) VALUES (0,'Deposito');
 INSERT INTO tipo_movimiento(codigo, tipo) VALUES (0,'Retiro');
 INSERT INTO tipo_movimiento(codigo, tipo) VALUES (0,'Compra');
 INSERT INTO tipo_movimiento(codigo, tipo) VALUES (0,'Venta');
 INSERT INTO tipo_movimiento(codigo, tipo) VALUES (0,'Otro Gasto');
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/ 
 
 
 
 /* |||||||||| SE INSERTAN LOS MUEBLES QUE SE HAN COMPRADO. EN *** muebles*** ||||||||||||||*/
 
 INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
 VALUES(0, 'Sala Negra','Nada que comentar', NULL, NULL);
 INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
 VALUES(0, 'Sala Cafe','Nada que comentar', NULL, NULL);
 INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
 VALUES(0, 'Sala Chocolate','Sala color chocolate', NULL, NULL);
 INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
 VALUES(0, 'Sala Seccional Beige','Nada que comentar', NULL, NULL);
 INSERT INTO muebles(idMuebles, NombreMueble, Descripcion, foto1, foto2)
 VALUES(0, 'Comedor Negro','Nada que comentar', NULL, NULL);
 
/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
 

/* |||||||||||||| SE INSERTAN DATOS EN *** MOVIMIENTOS_FINANCIEROS *** ||||||||||||||*/
 
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,1,'2021/03/30',2550,2550); -- DEPOSITO DEL CAPITAL
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,3,'2021/04/03',2000,2550); -- SALA NEGRA
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,3,'2021/04/03',1500,2550); -- SALA CAFE
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,3,'2021/04/03',2000,2550); -- SALA CHOCOLATE
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,3,'2021/04/03',1500,2550); -- SALA BEIGE
INSERT INTO movimientos_financieros(id, codigoTipo, fechaMov, cantidad, capital)
VALUES(0,3,'2021/04/03',1300,2550); -- COMEDOR ALTO

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/
 
 
 /* |||||||||||||| SE INSERTAN DATOS EN *** COMPRAS *** ||||||||||||||*/

INSERT INTO compras(id, idMuebles2, descripcion)
VALUES(3,1,'Sin comentario'); -- SALA NEGRA
INSERT INTO compras(id, idMuebles2, descripcion)
VALUES(2,2,'Sin comentario'); -- SALA CAFE
INSERT INTO compras(id, idMuebles2, descripcion)
VALUES(4,3,'Sin comentario'); -- SALA CHOCOLATE
INSERT INTO compras(id, idMuebles2, descripcion)
VALUES(6,4,'Sin comentario'); -- SALA BEIGE
INSERT INTO compras(id, idMuebles2, descripcion)
VALUES(5,5,'Sin comentario'); -- COMEDOR ALTO

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/


/* ||||||||||||||||||| SE INSERTAN DATOS EN *** ALMACEN *** ||||||||||||||||||||||*/

INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
VALUES(3,2000,5000); -- SALA NEGRA
INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
VALUES(2,1500,4000); -- SALA CAFE
INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
VALUES(4,2000,4500); -- SALA CHOCOLATE
INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
VALUES(6,1500,4500); -- SALA BEIGE
INSERT INTO almacen(idAlmacen, costoFinal, precioSugerido)
VALUES(5,1300,3800); -- COMEDOR ALTO

/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||*/







