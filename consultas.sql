-- DATOS
    -- Autores: Sergio Romera Rupérez (928657)
    --          Javier Valero Fontana (927155)
    --          Javier Tolosa Pérez (928662)

    -- Fichero CONSULTAS


-- CONSULTA 1

WITH 

-- 1. Agrupamos todas las películas que pertenecen a una misma saga. 
        -- Consideramos la película 'Destino' como la cabecera o "nombre" de la,
        -- saga uniéndola consigo misma y con todas sus películas de 'Origen'
        
SagasCompletas AS (
    SELECT tituloDestino as peli_saga, anyoDestino as anyo_saga, tituloDestino as peli_miembro, anyoDestino as anyo_miembro 
    FROM BASADA_EN
    WHERE tipoRelacion IN ('followed by', 'follows', 'spin off', 'spin off from', 'remade as', 'remake of')

    UNION

    SELECT tituloDestino, anyoDestino, tituloOrigen, anyoOrigen 
    FROM BASADA_EN
    WHERE tipoRelacion IN ('followed by', 'follows', 'spin off', 'spin off from', 'remade as', 'remake of')
),


-- 2. Filtramos para quedarnos exclusivamente con las sagas que sean, al
--  menos, trilogías, calculando el total de películas que las componen.
    
    Conteo AS (
    SELECT peli_saga, anyo_saga, COUNT(DISTINCT peli_miembro) as total FROM SagasCompletas
    GROUP BY peli_saga, anyo_saga HAVING COUNT(DISTINCT peli_miembro) >= 3
)

-- 3. Obtenemos los nombres de los directores que cumplan la condición de división.

SELECT DISTINCT e.nombre
FROM SagasCompletas sc
JOIN Conteo c ON sc.peli_saga = c.peli_saga AND sc.anyo_saga = c.anyo_saga
JOIN EQUIPO_TECNICO e ON e.titulo = sc.peli_miembro AND e.anyoEstreno = sc.anyo_miembro
WHERE LOWER(e.rol) = 'director' 
GROUP BY e.nombre, sc.peli_saga, sc.anyo_saga, c.total
-- Exigimos que el número de películas distintas que ha dirigido la 
-- persona en esa saga sea igual al total de películas de la saga.
HAVING COUNT(DISTINCT sc.peli_miembro) = c.total
ORDER BY 1;



------------------------------------------------------------------------------------------------------------------------

-- CONSULTA 2

SELECT tituloSerie, anyoEstrenoSerie
FROM (
    -- Primero agrupamos por temporada para contar episodios
    SELECT tituloSerie, anyoEstrenoSerie, temporada, COUNT(*) as episodios
    FROM CAPITULO
    GROUP BY tituloSerie, anyoEstrenoSerie, temporada
)
GROUP BY tituloSerie, anyoEstrenoSerie
-- 1. Que tenga 2 o más temporadas
HAVING COUNT(*) >= 2 
-- 2. Que el número de temporadas coincida con el número de recuentos de episodios distintos
        -- (Ejemplo: Si hay 3 temporadas y los episodios son 10, 12, 10 -> COUNT es 3, pero DISTINCT es 2: No cumple)
   AND COUNT(*) = COUNT(DISTINCT episodios)
ORDER BY anyoEstrenoSerie ASC;