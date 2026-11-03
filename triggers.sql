-- DATOS
    -- Autores: Sergio Romera Rupérez (928657)
    --          Javier Valero Fontana (927155)
    --          Javier Tolosa Pérez (928662)

    -- Fichero TRIGGERS
    
    
-- TRIGGER 1 - INTEGRIDAD DE JERARQUIAS

-- 1. DISPARADOR PARA PROTEGER LA RELACION SERIE

CREATE OR REPLACE TRIGGER TRG_EXCLUSIVIDAD_SERIE
BEFORE INSERT OR UPDATE ON SERIE
FOR EACH ROW
DECLARE
    -- Variable Local 
   numApariciones NUMBER;
BEGIN
    -- Comprobamos si está en Película
    SELECT COUNT(*) INTO numApariciones
    FROM PELICULA
    WHERE titulo = :new.titulo  AND anyoEstreno = :new.anyoEstreno;

    -- Si está → ERROR
    IF numApariciones  > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error de Integridad: Esta producción ya está registrada como Película.');
    END IF;
END;
/

-- 2. DISPARADOR PARA PROTEGER LA RELACION PELÍCULA

CREATE OR REPLACE TRIGGER TRG_EXCLUSIVIDAD_PELICULA
BEFORE INSERT OR UPDATE ON PELICULA
FOR EACH ROW
DECLARE
    numApariciones NUMBER;
BEGIN
    -- Comprobamos si está en Serie
    SELECT COUNT(*) INTO numApariciones
    FROM SERIE
    WHERE titulo = :new.titulo AND anyoEstreno = :new.anyoEstreno;

    IF numApariciones> 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error de Integridad: Esta producción ya está registrada como Serie.');
    END IF;
END;
/


-------------------------------------------------------------------------------------------------------------------------------

-- TRIGGER 2 - Restricción de Reciprocidad en Derivaciones

-- TRIGGER PARA EVITAR PARADOJAS CRONOLÓGICAS Y CICLOS DIRECCIONALES
CREATE OR REPLACE TRIGGER TRG_BASADA_EN_SIN_RECIPROCIDAD
AFTER INSERT OR UPDATE ON BASADA_EN
DECLARE
    numCoincidencias NUMBER;
BEGIN
    -- Ejecutamos un Self-Join para buscar ciclos lógicos recíprocos.
    SELECT COUNT(*) INTO numCoincidencias 
    FROM BASADA_EN b1, BASADA_EN b2
    WHERE b1.tituloOrigen = b2.tituloDestino 
      AND b1.anyoOrigen   = b2.anyoDestino
      AND b1.tituloDestino = b2.tituloOrigen 
      AND b1.anyoDestino   = b2.anyoOrigen
      -- CONDICIÓN DE PARADOJA: Ambas relaciones apuntan en la misma dirección temporal
      AND (
          -- Caso A: Ambas apuntan hacia el FUTURO
          (b1.tipoRelacion IN ('edited into', 'featured in', 'followed by', 'referenced in', 'remade as', 'spin off', 'spoofed in') AND 
           b2.tipoRelacion IN ('edited into', 'featured in', 'followed by', 'referenced in', 'remade as', 'spin off', 'spoofed in'))
          OR
          -- Caso B: Ambas apuntan hacia el PASADO
          (b1.tipoRelacion IN ('edited from', 'features', 'follows', 'references', 'remake of', 'spin off from', 'spoofs') AND 
           b2.tipoRelacion IN ('edited from', 'features', 'follows', 'references', 'remake of', 'spin off from', 'spoofs'))
      );

    -- Si se cumple la paradoja, abortamos
    IF numCoincidencias > 0 THEN     
        RAISE_APPLICATION_ERROR(-20020, 'Error de Integridad: Paradoja cronológica detectada. Incompatibilidad de vectores temporales entre las producciones.');
    END IF;
END;
/


-------------------------------------------------------------------------------------------------------------------------------

-- TRIGGER 3 - Mantenimiento de Nuestro Sistema

CREATE OR REPLACE TRIGGER TRG_MANTENIMIENTO_DIRECTORES
AFTER INSERT OR UPDATE OR DELETE ON EQUIPO_TECNICO
BEGIN
    
    -- 1. Vaciado de la Tabla Particionada
    DELETE FROM DIRECTOR_FISICO;

    -- 2. Actualización de la Tabla
    INSERT INTO DIRECTOR_FISICO (nombre, titulo, anyoEstreno)
    SELECT nombre, titulo, anyoEstreno
    FROM EQUIPO_TECNICO
    WHERE LOWER(rol) = 'director';
END;
/
