-- ======================================================
-- SCRIPT PARA DESPOBLAR LA BASE DE DATOS
-- Orden: De tablas dependientes a tablas maestras
-- ======================================================

-- 1. Tablas de Tercer Nivel (Dependencias de Relaciones y Entidades Débiles)
DELETE FROM BASADA_EN;
DELETE FROM CAPITULO;
DELETE FROM ACTUA;
DELETE FROM EQUIPO_TECNICO;

-- 2. Tablas de Segundo Nivel (Subclases y Atributos Multivaluados)
DELETE FROM GENERO_PRODUCCION;
DELETE FROM PELICULA;
DELETE FROM SERIE;

-- 3. Tablas de Primer Nivel (Superclases y Maestros)
DELETE FROM PRODUCCION;
DELETE FROM PERSONAL;

-- 4. Confirmar cambios
COMMIT;
