#!/bin/bash

# 	file_management_helper.sh


function verify_file() {
    if [[ ! -f "$1" ]]; then
        catch_error 1 "El archivo $1 no existe."
    fi
}



function read_file() {
    verify_file "$1" || return 1
    cat "$1" || catch_error 2 "No se pudo leer el archivo $1."
}

