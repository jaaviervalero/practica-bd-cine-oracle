# Base de datos de cine y series (Bases de Datos)

Práctica 2 de **Bases de Datos** (Ingeniería Informática, Universidad de Zaragoza, curso 2025-26), sobre Oracle.

- `crear_bd2.sql`: esquema relacional de producciones, películas, series, capítulos, personal, reparto, equipo técnico, géneros y relaciones entre películas (secuelas, remakes, spin-offs).
- `poblar.sh` y los ficheros `*.ctl`: carga masiva con SQL*Loader. El script pide usuario y contraseña al ejecutarse.
- `consultas.sql`: consultas complejas con subconsultas `WITH`, agregaciones y uniones.
- `diseñoFisico.sql`: diseño físico, con comparación de costes mediante `EXPLAIN PLAN` antes y después de optimizar (índices y vistas).
- `triggers.sql` y `test.sql`: disparadores para mantener restricciones de integridad, y sus pruebas.

Los datos (CSV) no se incluyen porque vienen del material de la asignatura.

**Autores:** Sergio Romera, Javier Valero y Javier Tolosa.
