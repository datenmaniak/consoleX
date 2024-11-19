#!/bin/bash

# Fonts Installer

# Cargar configuración
if [[ -f $HOME/consoleX/config.sh ]]; then
    source $HOME/consoleX/config.sh  # Cargar el entorno básico
else
    echo -e "Advertencia: config.sh no encontrado. \nLas variables no estarán disponibles."
    exit 1
fi

# Verificar si la variable de entorno ENVIRONMENT está definida
if [ -z "$ENVIRONMENT" ]; then
    echo "La variable de entorno ENVIRONMENT no está definida."
    exit 1
fi

# Leer el gestor de paquetes del archivo ENVIRONMENT
PACKAGE_MGR=$(grep '^PACKAGE_MGR=' "$ENVIRONMENT" | cut -d'=' -f2)

if [[ ! "$PACKAGE_MGR" =~ ^(apt|yum|dnf|pacman|zypper)$ ]]; then
    echo "Gestor de paquetes no reconocido: $PACKAGE_MGR"
    exit 1
fi

echo "Usando gestor de paquetes: $PACKAGE_MGR"

# Función para instalar paquetes usando pacman
install_package_pacman() {
    local package_name="$1"
    echo "Instalando $package_name..."
    if ! sudo pacman -S "$package_name" --noconfirm; then
        echo "Error al instalar $package_name. Verifique si el paquete está disponible."
        return 1
    fi
}

# Función para instalar paquetes usando otros gestores
install_package() {
    local package_name="$1"
    echo "Instalando $package_name..."
    if ! $PACKAGE_MGR install "$package_name" -y; then
        echo "Error al instalar $package_name. Verifique si el paquete está disponible."
        return 1
    fi
}

# Función para instalar fuentes según nombre común
install_font() {
    case $1 in
        "Arial") package="ttf-mscorefonts-installer";;
        "Open Sans") package="fonts-open-sans";;
        "Georgia") package="fonts-georgia";;
        "Fira Code") package="fonts-firacode";;
        "JetBrains Mono") package="fonts-jetbrains-mono";;
        *) echo "$1 no está disponible en repositorios estándar."; return;;
    esac
    
    if [[ "$PACKAGE_MGR" == "pacman" ]]; then
        install_package_pacman "$package"
    else
        install_package "$package"
    fi
}

# Menú interactivo para seleccionar fuentes a instalar
while true; do
    echo ""
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

    case $option in
        0) break ;;
        1) install_font "Arial" ;;
        2) install_font "Verdana" ;;
        3) install_font "Tahoma" ;;
        4) install_font "Trebuchet MS" ;;
        5) install_font "Open Sans" ;;
        6) install_font "Georgia" ;;
        7) echo "Cambria no está disponible en repositorios estándar." ;;
        8) install_font "Courier New" ;;
        9) echo "Monaco no está disponible en repositorios estándar." ;;
        10) echo "Lucida Console no está disponible en repositorios estándar." ;;
        11) install_font "Fira Code" ;;
        12) install_font "JetBrains Mono" ;;
        *) echo "Opción incorrecta." ;;
    esac
done

echo "Script finalizado."
