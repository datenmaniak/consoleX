#!/bin/bash

#
# Package Installer Script
#

# Suppress pip warnings about mismatched installation paths
export _PIP_LOCATIONS_NO_WARN_ON_MISMATCH=1

# Function to install a package using the specified package manager
install_package() {
    if [ -z "$1" ]; then
        echo " - install_package: No arguments given."
        return 1
    fi

    pkg="$@"
    if sudo $PACKAGE_MGR install -y $pkg; then
        echo " - Successfully installed $pkg"
    else
        echo " - Failed to install $pkg"
        return 1
    fi
}

# Function to update environment variable in the environment file
update_environment_variable() {
    local var_name=$1
    local var_value=$2

    # Check if the variable already exists in the environment file
    if grep -q "^$var_name=" "$ENVIRONMENT"; then
        # Update the existing variable
        sed -i "s/^$var_name=.*/$var_name=\"$var_value\"/" "$ENVIRONMENT"
    else
        # Add the variable to the end of the file
        echo "$var_name=\"$var_value\"" >> "$ENVIRONMENT"
    fi
}

# Function to get environment variable from the environment file
get_environment_variable() {
    local var_name=$1
    local value=$(grep "^$var_name=" "$ENVIRONMENT" | cut -d '=' -f 2- | tr -d '"')
    echo "$value"
}

# Function to install Powerline based on the package manager type
install_powerline() {
    case "$PACKAGE_EXT" in
        deb)
            sudo apt update && install_package powerline fonts-powerline || {
                echo "Failed to install Powerline on Debian/Ubuntu."
                return 1
            }
            ;;
        rpm)
            # Ensure python3-pip is installed first.
            if ! command -v pip3 &> /dev/null; then 
                echo "Installing python3-pip..."
                sudo yum install -y python3-pip || sudo dnf install -y python3-pip 
            fi
            
            # Install Powerline using pip.
            pip3 install --user powerline-status || {
                echo "Failed to install Powerline on RPM-based system."
                return 1 
            }
            ;;
        *)
            echo "Unsupported package type: $PACKAGE_EXT"
            return 1 
            ;;
    esac
    
    # Agregar configuración de Powerline a.bashrc sin usar eval
    case "$PACKAGE_EXT" in
        deb)

           if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
		   powerline_path="/usr/share/powerline/bindings/bash/powerline.sh"
           else 
		   powerline_path=""
	   fi
            #powerline_path="/usr/lib/python3/dist-packages/powerline/bindings/bash/powerline.sh"
            ;;
        rpm)
            powerline_path="/usr/local/lib/python3.x/site-packages/powerline/bindings/bash/powerline.sh"
            ;;
    esac
    
    echo "source $powerline_path" >> ~/.bashrc
    
    # Update environment variable
    update_environment_variable "POWERLINE_INSTALLED" "true"
    
    echo "Powerline installed and configured successfully."
}

# Function to install Starship based on the package manager type
install_starship() {
    # Install Starship
    curl -sS https://starship.rs/install.sh | sh || {
        echo "Failed to install Starship."
        return 1
    }

    # Add Starship configuration to.bashrc
    echo "# Starship Prompt" >> ~/.bashrc
    echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
    
    # Update environment variable
    update_environment_variable "STARSHIP_INSTALLED" "true"

    # copy starship config
    if copy_starship_config;  then
        checked "Starship installed and configured successfully."
    else
       echo "Ocurrió un error durante la copia."
    fi

}

copy_starship_config() {
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




# Trap SIGINT (Ctrl+C) and SIGTERM signals to prevent exiting the script.
trap 'echo "Signal received. Continuing execution...";' SIGINT SIGTERM

# Load environment variables from the specified file, or create/update it if it doesn't exist.
if [ -f "$ENVIRONMENT" ]; then
    source "$ENVIRONMENT"

    # Update PACKAGE_EXT and PACKAGE_MGR if they are not set or need changing.
    sed -i.bak \
        -e '/^PACKAGE_EXT=/!b' \
        -e 's/^PACKAGE_EXT=.*/PACKAGE_EXT="rpm"/' \
        -e '/^PACKAGE_MGR=/!b' \
        -e 's/^PACKAGE_MGR=.*/PACKAGE_MGR="yum"/' "$ENVIRONMENT"
else
    echo "Environment file not found: $ENVIRONMENT. Creating a new one..."

    # Determine the system type and set default values accordingly.
    if grep -qE 'Debian|Ubuntu' /etc/os-release; then
        SYSTEM_TYPE="deb"
        PACKAGE_MGR="apt"
    else
        SYSTEM_TYPE="rpm"
        PACKAGE_MGR="yum"
    fi
    
    # Create a new environment file with default values and comments (customize as needed)
    {
      echo "# Default environment variables for package management"
      echo "# PACKAGE_EXT specifies the package type (deb or rpm)"
      echo "PACKAGE_EXT=\"$SYSTEM_TYPE\""
      echo "# PACKAGE_MGR specifies the package manager (apt, yum, dnf)"
      echo "PACKAGE_MGR=\"$PACKAGE_MGR\""
    } > "$ENVIRONMENT"

    # Source the newly created environment file.
    source "$ENVIRONMENT"
    
    # Inform the user that defaults have been set.
    echo "Default environment variables set in $ENVIRONMENT."
fi

# Ensure PACKAGE_EXT and PACKAGE_MGR are set from the environment file.
if [ -z "$PACKAGE_EXT" ] || [ -z "$PACKAGE_MGR" ]; then 
    echo "Error: PACKAGE_EXT or PACKAGE_MGR is not set. Please check your environment file."
else 
    # Comprobar si ya se han instalado los prompts
    if [ "$(get_environment_variable "POWERLINE_INSTALLED")" = "true" ]; then
        checked "Powerline ya está instalado."
    elif [ "$(get_environment_variable "STARSHIP_INSTALLED")" = "true" ]; then
        checked "Starship ya está instalado."
    else
        echo "Ninguno de los prompts está instalado."

        # Present the user with a choice between Powerline and Starship
        echo -e "\nSelect your preferred prompt theme:"
        PS3="Enter your choice: "
        items=("Install Powerline" "Install Starship" "Exit")

        while true; do
            select item in "${items[@]}"; do
                case $REPLY in                                                                       
                    1)
                        echo -e "\nInstalling Powerline..."
                        install_powerline
                        break 2                                                                    
                        ;;                                                                            
                    2)
                        echo -e "\nInstalling Starship..."
                        install_starship
                        break 2                                                                    
                        ;;                                                                            
                    3)
                        echo "Exiting installation process."
                        exit 0                                                                       
                        ;;                                                                            
                    *) 
                        echo "Ooops - unknown choice $REPLY"                                          
                        break;;                                                                          
                esac                                                                                 
            done                                                                                     
        done                                                                                         
    fi
fi
#!/bin/bash


