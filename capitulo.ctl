OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'Capitulo.csv'
APPEND
INTO TABLE CAPITULO
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  tituloSerie,
  anyoEstrenoSerie,
  tituloCapitulo,
  temporada,
  numCapitulo
)