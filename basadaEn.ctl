OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'BasadaEn.csv'
APPEND
INTO TABLE BASADA_EN
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  tituloOrigen  "TRIM(REPLACE(REPLACE(:tituloOrigen,  CHR(10), ''), CHR(13), ''))",
  anyoOrigen,
  tituloDestino "TRIM(REPLACE(REPLACE(:tituloDestino, CHR(10), ''), CHR(13), ''))",
  anyoDestino,
  tipoRelacion  "TRIM(REPLACE(REPLACE(:tipoRelacion,  CHR(10), ''), CHR(13), ''))"
)