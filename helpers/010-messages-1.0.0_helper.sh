#!/bin/bash

# funciones/mensajes.sh

# Función para desplegar mensajes con fecha y hora
function show_message() {
    local mensaje="$1"  # Captura el argumento pasado a la función
    local fecha_hora=$(date '+%Y-%m-%d %H:%M:%S')  # Obtiene la fecha y hora actual
    echo "[$fecha_hora] $mensaje  "  # Muestra la fecha y hora junto al mensaje
}

function catch_error() {
    local error_code="$1"
    local error_message="$2"
    show_message "Error: $error_message"
    return "$error_code"  # Salir con el código de error

}

# Función para mostrar mensajes de depuración con un ícono de alarma
function debug_message() {
     local timestamp=$(date +"%Y-%m-%d %H:%M:%S")  # Captura la fecha y hora actual
     local message="$1"  # Primer argumento como el mensaje
     shift  # Desplaza los argumentos a la izquierda, eliminando el primero

     # Comprueba si hay variables adicionales
     if [ "$#" -gt 0 ]; then
         echo -e "🔔  [DEBUG] [${timestamp}] 🔔 ${message} | Variables: $@"  # Muestra el mens    aje y las variables pasadas
     else
         echo -e "🔔  [DEBUG] [${timestamp}] 🔔 ${message} | Sin variables adicionales."  # Me    nsaje sin variables
     fi
}


function show_message_with_prefix() {
    show_message "$1"
}

# función simplificada de echo con -e
function e() {
    echo -e " $@"
}

function check_ok() {
    echo -e "✅ $@"
}

function checked()  {
    echo -e "✔️ $@ "
}


