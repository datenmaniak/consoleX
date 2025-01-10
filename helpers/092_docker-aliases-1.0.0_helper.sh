#!/bin/bash

# Función para levantar contenedores
dcup() {
    docker compose up "$@"
}

# Función para detener contenedores
dcd() {
    docker compose down
}

# Función para detener contenedores y eliminar volúmenes
dcdv() {
    docker compose down -v
}

# Función para listar imágenes de Docker
dimg() {
    docker images
}

# Función para listar todos los contenedores
dpsa() {
    docker ps -a
}

# Función para listar volúmenes de Docker
dvls() {
    docker volume ls
}

# Función para listar redes de Docker
dnls() {
    docker network ls
}

# Función de ayuda que muestra información sobre las funciones disponibles
help-mydocker() {
    echo "Funciones disponibles:"
    echo ""
    echo "  dcup     Levanta los contenedores definidos en el archivo docker-compose."
    echo "           Uso: dcup [opciones]"
    echo ""
    echo "  dcd      Detiene los contenedores definidos en el archivo docker-compose."
    echo ""
    echo "  dcdv     Detiene los contenedores y elimina los volúmenes asociados."
    echo ""
    echo "  dimg     Lista todas las imágenes de Docker en el sistema."
    echo ""
    echo "  dpsa     Lista todos los contenedores, incluyendo los que están detenidos."
    echo ""
    echo "  dvls     Lista todos los volúmenes de Docker."
    echo ""
    echo "  dnls     Lista todas las redes de Docker."
    echo ""
    echo "  my-docker-help     Muestra esta ayuda."
}

about_this "Shortcuts to Docker shortcuts, run: help-mydocker"

# Fin del script

