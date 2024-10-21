#!/bin/bash

# Función para copiar el archivo
copiar_archivo() {
    # Ruta del archivo de origen
    local ORIGEN="~/consoleX/config/starship.toml"

    # Ruta del archivo de destino
    local DESTINO="~/.config/starship.toml"

    # Expandir los tildes en las rutas
    ORIGEN="${ORIGEN/#\~/$HOME}"
    DESTINO="${DESTINO/#\~/$HOME}"

    echo $ORIGEN
    echo $DESTINO


    # Comprueba si el archivo de origen existe
    if [ ! -f "$ORIGEN" ]; then
        echo "El archivo de origen $ORIGEN no existe."
        return 1
    fi

    # Comprueba si el directorio de destino existe, y lo crea si no existe
    local DESTINO_DIR="$(dirname "$DESTINO")"
    if [ ! -d "$DESTINO_DIR" ]; then
        mkdir -p "$DESTINO_DIR"
    fi

    # Copia el archivo
    cp -v "$ORIGEN" "$DESTINO"

    # Mensaje de confirmación
    echo "El archivo $ORIGEN se ha copiado a $DESTINO con éxito."
    return 0
}

# Ejemplo de cómo llamar a la función
if copiar_archivo; then
    echo "La copia se realizó con éxito."
else
    echo "Ocurrió un error durante la copia."
fi

