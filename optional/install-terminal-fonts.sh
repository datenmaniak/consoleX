#!/bin/bash

#  Fonts installer
#


if [[ -f $HOME/consoleX/config.sh ]]; then
    source $HOME/consoleX/config.sh                  # load basic environment
else
    echo -e "Advertencia: config.sh no encontrado. \nLas variables no estarán disponibles."
fi




# Verificar si la variable de entorno ENVIRONMENT está definida
if [ -z "$ENVIRONMENT" ]; then
    echo "La variable de entorno ENVIRONMENT no está definida."
    exit 1
fi

# Leer el archivo especificado en $ENVIRONMENT
if [ -f "$ENVIRONMENT" ]; then
    # Leer la línea que contiene PACKAGE_MGR
    while IFS= read -r line; do
        if [[ $line == PACKAGE_MGR* ]]; then
            PACKAGE_MGR=$(echo "$line" | cut -d'=' -f2)
            break
        fi
    done < "$ENVIRONMENT"
else
    echo "El archivo especificado en ENVIRONMENT no existe."
    exit 1
fi

# Función para instalar fuentes usando el gestor de paquetes definido
install_font() {
    case $1 in
        1) echo "Instalando Arial..."
           $PACKAGE_MGR install ttf-mscorefonts-installer -y
           ;;
        2) echo "Instalando Verdana..."
           $PACKAGE_MGR install ttf-mscorefonts-installer -y
           ;;
        3) echo "Instalando Tahoma..."
           $PACKAGE_MGR install ttf-mscorefonts-installer -y
           ;;
        4) echo "Instalando Trebuchet MS..."
           $PACKAGE_MGR install ttf-mscorefonts-installer -y
           ;;
        5) echo "Instalando Open Sans..."
           $PACKAGE_MGR install fonts-open-sans -y
           ;;
        6) echo "Instalando Georgia..."
           $PACKAGE_MGR install fonts-georgia -y
           ;;
        7) echo "Cambria no está disponible en repositorios estándar."
           ;;
        8) echo "Instalando Courier New..."
           $PACKAGE_MGR install ttf-mscorefonts-installer -y
           ;;
        9) echo "Monaco no está disponible en repositorios estándar."
           ;;
        10) echo "Lucida Console no está disponible en repositorios estándar."
            ;;
        11) echo "Instalando Fira Code..."
            $PACKAGE_MGR install fonts-firacode -y
            ;;
        12) echo "Instalando JetBrains Mono..."
            $PACKAGE_MGR install fonts-jetbrains-mono -y
            ;;
        *) echo "Opción incorrecta."
           ;;
    esac
}

while true; do
    echo "Seleccione una fuente para instalar:"
    echo "1) Arial"
    echo "2) Verdana"
    echo "3) Tahoma"
    echo "4) Trebuchet MS"
    echo "5) Open Sans"
    echo "6) Georgia"
    echo "7) Cambria (no disponible)"
    echo "8) Courier New"
    echo "9) Monaco (no disponible)"
    echo "10) Lucida Console (no disponible)"
    echo "11) Fira Code"
    echo "12) JetBrains Mono"
    echo "0) Salir"

    read -p "Opción: " option

    if [ "$option" -eq 0 ]; then
        break
    fi

    install_font $option
done

echo "Script finalizado."
