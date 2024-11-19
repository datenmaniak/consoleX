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

# Leer el archivo especificado en $ENVIRONMENT
if [ ! -f "$ENVIRONMENT" ]; then
    echo "El archivo especificado en ENVIRONMENT no existe."
    exit 1
fi

# Leer el gestor de paquetes del archivo ENVIRONMENT
while IFS= read -r line; do
    if [[ $line == PACKAGE_MGR* ]]; then
        PACKAGE_MGR=$(echo "$line" | cut -d'=' -f2)
        break
    fi
done < "$ENVIRONMENT"

echo "Package manager found: $PACKAGE_MGR"

# Validar el gestor de paquetes
if [[ ! "$PACKAGE_MGR" =~ ^(apt|yum|dnf|pacman|zypper)$ ]]; then
    echo "Gestor de paquetes no reconocido: $PACKAGE_MGR"
    exit 1
fi

echo "Usando gestor de paquetes: $PACKAGE_MGR"

# Función para instalar fuentes usando el gestor de paquetes definido
install_font() {
    local font_name="$1"
    case $font_name in
        "Arial" | "Verdana" | "Tahoma" | "Trebuchet MS" | "Courier New")
            echo "Instalando $font_name..."
            $PACKAGE_MGR install ttf-mscorefonts-installer -y || {
                echo "Error al instalar $font_name. Verifique si el paquete está disponible."
                return 1
            }
            ;;
        "Open Sans")
            echo "Instalando Open Sans..."
            $PACKAGE_MGR install fonts-open-sans -y || {
                echo "Error al instalar Open Sans. Verifique si el paquete está disponible."
                return 1
            }
            ;;
        "Georgia")
            echo "Instalando Georgia..."
            $PACKAGE_MGR install fonts-georgia -y || {
                echo "Error al instalar Georgia. Verifique si el paquete está disponible."
                return 1
            }
            ;;
        "Fira Code")
            echo "Instalando Fira Code..."
            $PACKAGE_MGR install fonts-firacode -y || {
                echo "Error al instalar Fira Code. Verifique si el paquete está disponible."
                return 1
            }
            ;;
        "JetBrains Mono")
            echo "Instalando JetBrains Mono..."
            $PACKAGE_MGR install fonts-jetbrains-mono -y || {
                echo "Error al instalar JetBrains Mono. Verifique si el paquete está disponible."
                return 1
            }
            ;;
        *)
            echo "$font_name no está disponible en repositorios estándar."
            ;;
    esac
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
        0)
            break ;;
        1)
            install_font "Arial" ;;
        2)
            install_font "Verdana" ;;
        3)
            install_font "Tahoma" ;;
        4)
            install_font "Trebuchet MS" ;;
        5)
            install_font "Open Sans" ;;
        6)
            install_font "Georgia" ;;
        7)
            echo "Cambria no está disponible en repositorios estándar." ;;
        8)
            install_font "Courier New" ;;
        9)
            echo "Monaco no está disponible en repositorios estándar." ;;
        10)
            echo "Lucida Console no está disponible en repositorios estándar." ;;
        11)
            install_font "Fira Code" ;;
        12)
            install_font "JetBrains Mono" ;;
        *)
            echo "Opción incorrecta." ;;
    esac
done

echo "Script finalizado."
