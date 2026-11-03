-- DATOS
    -- Autores: Sergio Romera Rupérez (928657)
    --          Javier Valero Fontana (927155)
    --          Javier Tolosa Pérez (928662)

    -- Fichero CREACIÓN DE TABLAS
    
    
-- 1. CREACIÓN DE LA TABLA PRODUCCION (Superclase limpia)
CREATE TABLE PRODUCCION (
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    CONSTRAINT PRODUCCION_PK PRIMARY KEY (titulo, anyoEstreno)
);

-- 2. TABLA PARA ATRIBUTO MULTIVALUADO: GENERO_PRODUCCION (1FN)
CREATE TABLE GENERO_PRODUCCION (
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    CONSTRAINT GENERO_PROD_PK PRIMARY KEY (titulo, anyoEstreno, genero),
    CONSTRAINT GENERO_PROD_FK FOREIGN KEY (titulo, anyoEstreno) 
        REFERENCES PRODUCCION (titulo, anyoEstreno) ON DELETE CASCADE
);

-- 3. CREACIÓN DE LA TABLA PELICULA (Subclase limpia)
CREATE TABLE PELICULA (
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    CONSTRAINT PELICULA_PK PRIMARY KEY (titulo, anyoEstreno),
    CONSTRAINT PELICULA_PROD_FK FOREIGN KEY (titulo, anyoEstreno) 
        REFERENCES PRODUCCION (titulo, anyoEstreno) ON DELETE CASCADE
);

-- 4. TABLA PARA RELACIÓN REFLEXIVA: BASADA_EN (Resolución de Sagas)
CREATE TABLE BASADA_EN (
    tituloOrigen VARCHAR(150) NOT NULL,
    anyoOrigen NUMBER(4) NOT NULL,
    tituloDestino VARCHAR(150) NOT NULL,
    anyoDestino NUMBER(4) NOT NULL,
    tipoRelacion VARCHAR(50),
    CONSTRAINT BASADA_EN_PK PRIMARY KEY (tituloOrigen, anyoOrigen, tituloDestino, anyoDestino, tipoRelacion),
    CONSTRAINT FK_BASADA_ORIGEN FOREIGN KEY (tituloOrigen, anyoOrigen) 
        REFERENCES PELICULA (titulo, anyoEstreno),
    CONSTRAINT FK_BASADA_DESTINO FOREIGN KEY (tituloDestino, anyoDestino) 
        REFERENCES PELICULA (titulo, anyoEstreno)
);

-- 5. CREACIÓN DE LA TABLA SERIE (Subclase)
CREATE TABLE SERIE (
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    periodoEmision VARCHAR(20),
    CONSTRAINT SERIE_PK PRIMARY KEY (titulo, anyoEstreno),
    CONSTRAINT SERIE_PROD_FK FOREIGN KEY (titulo, anyoEstreno) 
        REFERENCES PRODUCCION (titulo, anyoEstreno) ON DELETE CASCADE
);

-- 6. CREACIÓN DE LA TABLA CAPITULO (Entidad Débil)
CREATE TABLE CAPITULO (
    tituloSerie VARCHAR(150) NOT NULL,
    anyoEstrenoSerie NUMBER(4) NOT NULL,
    tituloCapitulo VARCHAR(150) NOT NULL,
    temporada NUMBER(3),
    numCapitulo NUMBER(4),
    CONSTRAINT CAPITULO_PK PRIMARY KEY (tituloSerie, anyoEstrenoSerie, tituloCapitulo),
    CONSTRAINT CAPITULO_SERIE_FK FOREIGN KEY (tituloSerie, anyoEstrenoSerie) 
        REFERENCES SERIE (titulo, anyoEstreno) ON DELETE CASCADE
);

-- 7. CREACIÓN DE LA TABLA PERSONAL
CREATE TABLE PERSONAL (
    nombre VARCHAR(150) NOT NULL,
    lugarNacimiento VARCHAR(150),
    genero VARCHAR(50),  
    
    CONSTRAINT CHK_GENERO  CHECK (GENERO IN ('m', 'f')),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (nombre)
);

-- 8. CREACIÓN DE LA TABLA ACTUA (Relación N:M)
CREATE TABLE ACTUA (
    nombre VARCHAR(150) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    personaje VARCHAR(150) NOT NULL,
    CONSTRAINT ACTUA_PK PRIMARY KEY (nombre, titulo, anyoEstreno, personaje),
    CONSTRAINT ACTUA_PERSONAL_FK FOREIGN KEY (nombre) REFERENCES PERSONAL (nombre),
    CONSTRAINT ACTUA_PROD_FK FOREIGN KEY (titulo, anyoEstreno) 
        REFERENCES PRODUCCION (titulo, anyoEstreno)
);

-- 9. CREACIÓN DE LA TABLA EQUIPO_TECNICO (Relación N:M)
CREATE TABLE EQUIPO_TECNICO (
    nombre VARCHAR(150) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    anyoEstreno NUMBER(4) NOT NULL,
    rol VARCHAR(150) NOT NULL,
    CONSTRAINT EQUIPOTECNICO_PK PRIMARY KEY (nombre, titulo, anyoEstreno, rol),
    CONSTRAINT EQUIPOTECNICO_PERS_FK FOREIGN KEY (nombre) REFERENCES PERSONAL (nombre),
    CONSTRAINT EQUIPOTECNICO_PROD_FK FOREIGN KEY (titulo, anyoEstreno) 
        REFERENCES PRODUCCION (titulo, anyoEstreno)
);