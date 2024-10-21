#!/bin/bash

#
# Activa el prompt basado en 'powerline'
#

# Verificar si la variable de entorno ENVIRONMENT está definida
if [ -z "$ENVIRONMENT" ]; then
    echo "Error: La variable de entorno ENVIRONMENT no está definida."
    exit 1
fi

# Verificar si el archivo de entorno existe
if [ ! -f "$ENVIRONMENT" ]; then
    echo "Error: El archivo especificado por ENVIRONMENT no existe: $ENVIRONMENT"
    exit 1
fi

# Función para actualizar el estado del prompt en el archivo de entorno
update_prompt_status() {
    local prompt_enable="false"
    
    if grep -q "^prompt_enable=" "$ENVIRONMENT"; then
        sed -i "s/prompt_enable=.*/prompt_enable='false'/" "$ENVIRONMENT"
    else
        echo "# Requiere instalar Bash prompt por Powerline" >> "$ENVIRONMENT"
        echo "prompt_enable=$prompt_enable" >> "$ENVIRONMENT"
    fi
}

# Función para establecer el prompt de Powerline
set_prompt() {
    if [[ "$PACKAGE_EXT" == 'deb' ]]; then
        if [[ -f "/usr/share/powerline/bindings/bash/powerline.sh" ]]; then
            source /usr/share/powerline/bindings/bash/powerline.sh
            local prompt_enable="true"
            update_prompt_status
        else
            echo "Archivo no encontrado: /usr/share/powerline/bindings/bash/powerline.sh"
            local prompt_enable="false"
            update_prompt_status
        fi
    elif [[ "$PACKAGE_EXT" == 'rpm' ]]; then
        if [[ -f "/usr/share/powerline/bash/powerline.sh" ]]; then
            source /usr/share/powerline/bash/powerline.sh
            local prompt_enable="true"
            update_prompt_status
        else
            echo "Archivo no encontrado: /usr/share/powerline/bash/powerline.sh"
            local prompt_enable="false"
            update_prompt_status
        fi
    else 
        echo " - Instalador desconocido para este sistema: $PACKAGE_EXT"
        local prompt_enable="false"
        update_prompt_status
    fi
    
    # Activar el prompt si todo está correcto y los paquetes están instalados.
    if [[ "$prompt_enable" == "true" ]]; then 
        enable_powerline_prompt 
    fi
}

# Función para instalar Powerline según la distribución
install_according_distro() {
    echo -e " - Instalando powerline para sistemas derivados de \"$PACKAGE_EXT\""

    if [[ "$PACKAGE_EXT" == "rpm" ]]; then
        install_package powerline powerline-fonts  
        if [[ $? -ne 0 ]]; then
            echo "Error al instalar powerline para RPM."
            exit 1
        fi
    elif [[ "$PACKAGE_EXT" == "deb" ]]; then
        install_package powerline fonts-powerline powerline-gitstatus
        if [[ $? -ne 0 ]]; then
            echo "Error al instalar powerline para DEB."
            exit 1
        fi
    fi

    # Después de la instalación, intentar establecer el prompt nuevamente.
    set_prompt 
}

# Función para habilitar el prompt de Powerline si está instalado.
enable_powerline_prompt() {
    if ! command -v powerline-daemon &> /dev/null; then 
        echo "Powerline-daemon es requerido pero no está instalado."
        
        confirm_installation $pkg
        
        if [[ $? -eq 1 ]]; then
            # Aceptado por el usuario, proceder a la instalación.
            install_according_distro 
        fi
        
    else 
        powerline-daemon -q 
        POWERLINE_BASH_CONTINUATION=1 
        POWERLINE_BASH_SELECT=1 
    fi    
}

# Función principal para iniciar la configuración del prompt.
prompt_main_startup() {
    pkg="powerline"

    pkg_query $pkg

    if [[ $? -eq 0 ]] && [[ "$pkg_found" == 0 ]]; then        
        # Dar opciones al usuario para instalar los paquetes o no.
        confirm_installation $pkg
        
        if [[ $? -eq 1 ]]; then 
            # Aceptado por el usuario, proceder a la instalación.
            install_according_distro 
        fi        
    fi
    
    # Intentar establecer el prompt después de verificar o instalar los paquetes.
    set_prompt 
}

# Función para personalizar el prompt del shell.
customize_shell_prompt() {
    #echo -e " - Personalizando el prompt del shell"
    prompt_enable=""
    prompt_main_startup
    
}

# Llamar a la función principal para personalizar el shell al inicio del script.
customize_shell_prompt
:
