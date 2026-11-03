#!/bin/bash

# --- Configuración de conexión ---
echo "===================================================="
echo "   Carga de Datos - Proyecto BD (sqlldr)"
echo "===================================================="
read -p "Usuario: " DB_USER
read -sp "Contraseña: " DB_PASS
echo ""
DB_CONN="barret.danae04.unizar.es"

TABLAS=(
    "produccion"
    "personal"
    "pelicula"
    "serie"
    "generoProduccion"
    "actua"
    "equipoTecnico"
    "capitulo"
    "basadaEn"
)

for ctl_name in "${TABLAS[@]}"; do
    echo -n ">> Procesando ${ctl_name}.ctl ... "

    # Ejecución de sqlldr
    # Usamos silent=header,feedback para una salida más limpia
    sqlldr ${DB_USER}/${DB_PASS}@${DB_CONN} \
           control=${ctl_name}.ctl \
           log=${ctl_name}.log \
           bad=${ctl_name}.bad \
           silent=header,feedback

    # Comprobación de éxito
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "ERROR (Verifica ${ctl_name}.log)"
    fi
done

echo -e "\n===================================================="
echo "   Carga finalizada. Revisa los archivos .log"
echo "===================================================="
