#!/bin/bash

# Environment control

# get current date
datetime=$(date +"%Y-%m-%d %H:%M:%S")


# Function to verify the existence of the environment file
function verify_environment_file {
    if [[ -f "$ENVIRONMENT" ]]; then
        #check_ok "Environment file found."
        return 0
    else
        return 1  # Return 1 if the environment file is not found
    fi
}

# Function to create a new environment file based on default variables if it doesn't exist
function create_new_env_file {
    
    NEW_ENV_FILE="$APPDIR/console.env"

    
    if [[ ! -f "$NEW_ENV_FILE" ]]; then  # Only create if it doesn't exist
        cat <<EOF > "$NEW_ENV_FILE"
#
# ==================================================================
#  $    $ENVIRONMENT        $datetime  
# ==================================================================
#
# Default Directory 
APPDIR="\$HOME/consoleX"      
# if was created by using git clone <.../consoleX.git>

# allowed packages for this app
allowed_packages="(deb|rpm)"

# Functions Library directory
helpers="\$APPDIR/helpers"

# Indicates whether Google Chrome is installed (true/false)
install_googlechrome="false"   
# (if needed at you workstation)  not for servers

# The operating system your are working on
OS=""

# The version of the operating system
VER=""

# The package manager used by default on the system
PACKAGE_MGR=""

# The package format detected on the system (rpm or deb)
PACKAGE_EXT=""

# Enable a prompt with Powerline
prompt_enable="true"

# Prompt
STARSHIP_INSTALLED="false"

#Prompt
POWERLINE_INSTALLED="false"

EOF

        show_message_with_prefix "New environment file created at $NEW_ENV_FILE"
    else 
        show_message_with_prefix "Environment file already exists at $NEW_ENV_FILE"
    fi  
}

# Function to load environment variables from the environment file
function load_environment_variables {
    if [[ -f "$ENVIRONMENT" ]]; then
        source "$ENVIRONMENT"
    fi

    # Set default values if variables are missing
    APPDIR=${APPDIR:-"$HOME/consoleX"}
    install_googlechrome=${install_googlechrome:-\"false\"}
    allowed_packages=${allowed_packages:-\"(deb|rpm)\"}
    helpers=${helpers:-"$APPDIR/helpers"}
    OS=${OS:-"unknown"}
    VER=${VER:-"unknown"}
    PACKAGE_MGR=${PACKAGE_MGR:-"unknown"}
    PACKAGE_EXT=${PACKAGE_EXT:-"unknown"}
    prompt_enable=${prompt_enable:-\"false\"}
}

# Function to capture initial environment values
function capture_environment_snapshot() {
    
    # uncomment for debugging	
    # check_ok "Environment Snapshot"

    # Capture initial values
    initial_install_googlechrome=$install_googlechrome
    initial_APPDIR=$APPDIR
    initial_helpers=$helpers
    initial_allowed_packages=$allowed_packages
    initial_ENVIRONMENT=$ENVIRONMENT
    initial_OS=$OS
    initial_VER=$VER
    initial_PACKAGE_MGR=$PACKAGE_MGR
    initial_PACKAGE_EXT=$PACKAGE_EXT
    initial_prompt_enable=$prompt_enable
}

# Function to update or add a variable in the environment file

<< 'ORIGINAL-DISABLED'
function update_environment_variable {
    local var_name="$1"
    local var_value="$2"

    if grep -q "^$var_name=" "$ENVIRONMENT"; then
        sed -i "s/^$var_name=.*/$var_name=$var_value/" "$ENVIRONMENT"
    else
        echo "$var_name=$var_value" >> "$ENVIRONMENT"
    fi
}
ORIGINAL-DISABLED

function update_environment_variable {
    local var_name="$1"
    local var_value="$2"
    
    # Check if ENVIRONMENT variable is set and file exists
    if [[ -z "$ENVIRONMENT" || ! -f "$ENVIRONMENT" ]]; then
        echo "Error: ENVIRONMENT variable is not set or file does not exist."
        return 1
    fi

    # Escape special characters in var_value for sed
    local escaped_value=$(printf '%s\n' "$var_value" | sed 's/[\/&]/\\&/g')
    debug_message $escaped_value

    # Enclose the value in double quotes
    local quoted_value="\"$escaped_value\""

    debug_message $quoted_value

    if grep -q "^$var_name=" "$ENVIRONMENT"; then
        # Update existing variable with quoted value
        sed -i "s/^$var_name=.*/$var_name=$quoted_value/" "$ENVIRONMENT"
    else
        # Append new variable with quoted value
        echo "$var_name=$quoted_value" >> "$ENVIRONMENT"
    fi
}


function update_environment_file {
    show_message "Updating environment file with new values..."

    # Create a backup before updating (versioning)
    if [[ -f "$ENVIRONMENT" ]]; then
        cp "$ENVIRONMENT" "${ENVIRONMENT}.bak.$(date +%Y%m%d%H%M%S)"
    fi

    #source $HELPERS/012-os-packages_management-v1.1.0_helper.sh

    # Update the environment variables in the environment file, ensuring all are set correctly.
    update_environment_variable "APPDIR" "$APPDIR"
    update_environment_variable "install_googlechrome" "$install_googlechrome"
    update_environment_variable "allowed_packages" "$allowed_packages"
    update_environment_variable "helpers" "$helpers"
    update_environment_variable "OS" "$OS"
    update_environment_variable "VER" "$VER"
    update_environment_variable "PACKAGE_MGR" "$PACKAGE_MGR"
    update_environment_variable "PACKAGE_EXT" "$PACKAGE_EXT"
    update_environment_variable "prompt_enable" "$prompt_enable"

    check_ok "Environment updated at $ENVIRONMENT"
}

# Function to check for changes in variables and update if necessary
function check_env_changes {

    # Variable para rastrear si hay cambios
    local changes_detected=false

    # Comparar las variables actuales con los valores iniciales
    if [[ "$install_googlechrome" != "$initial_install_googlechrome" ]]; then
        echo "🔄 Detected change in 'install_googlechrome': $initial_install_googlechrome -> $install_googlechrome"
        changes_detected=true
    fi

    if [[ "$APPDIR" != "$initial_APPDIR" ]]; then
        echo "🔄 Detected change in 'APPDIR': $initial_APPDIR -> $APPDIR"
        changes_detected=true
    fi

    if [[ "$helpers" != "$initial_helpers" ]]; then
        echo "🔄 Detected change in 'helpers': $initial_helpers -> $helpers"
        changes_detected=true
    fi

    if [[ "$allowed_packages" != "$initial_allowed_packages" ]]; then
        echo "🔄 Detected change in 'allowed_packages': $initial_allowed_packages -> $allowed_packages"
        changes_detected=true
    fi

    if [[ "$OS" != "$initial_OS" ]]; then
        echo "🔄 Detected change in 'OS': $initial_OS -> $OS"
        changes_detected=true
    fi

    if [[ "$VER" != "$initial_VER" ]]; then
        echo "🔄 Detected change in 'VER': $initial_VER -> $VER"
        changes_detected=true
    fi

    if [[ "$PACKAGE_MGR" != "$initial_PACKAGE_MGR" ]]; then
        echo "🔄 Detected change in 'PACKAGE_MGR': $initial_PACKAGE_MGR -> $PACKAGE_MGR"
        changes_detected=true
    fi

    if [[ "$PACKAGE_EXT" != "$initial_PACKAGE_EXT" ]]; then
        echo "🔄 Detected change in 'PACKAGE_EXT': $initial_PACKAGE_EXT -> $PACKAGE_EXT"
        changes_detected=true
    fi

    if [[ "$prompt_enable" != "$initial_prompt_enable" ]]; then
        echo "🔄 Detected change in 'prompt_enable': $initial_prompt_enable -> $prompt_enable"
        changes_detected=true
    fi

    checked "Environment Checked."
    #checkedhow_message "✔️ Environment Checked" # TOREMOVE
    
    # Si se detectaron cambios, actualizar el archivo de entorno
    if [ "$changes_detected" = true ]; then
        update_environment_file  # Actualiza el archivo con los nuevos valores.
        capture_environment_snapshot  # Captura nuevamente los valores actuales.
        echo "✅ Environment file updated with new values."
     
    #else
    #    echo "✔️ No changes detected in the environment."
    fi
}

# Verify the existence of the environment file and create it if it does not exist.
if ! verify_environment_file; then
   create_new_env_file  # Create a new environment file if it does not exist.
fi

# Load existing environment variables or set defaults.
load_environment_variables

# Initialize by capturing current environment values and checking for changes.
capture_environment_snapshot  # Captura los valores iniciales.
check_env_changes   # Llama a esta función para verificar cambios.
