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

# Function to query if a package is installed
pkg_query() {
    local pkg=$1

    if [ -z "$pkg" ]; then
        echo " - pkg_query: No arguments given for search/query."
        return 1
    fi

    case "$PACKAGE_EXT" in
        deb)
            status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>/dev/null)"
            ;;
        rpm)
            status="$(rpm -q "$pkg" 2>/dev/null)"
            ;;
        *)
            echo " - Allowed package types only are deb and rpm."
            return 1
            ;;
    esac

    if [[ "$status" =~ "not-installed" ]]; then
        echo "pkg_query: $pkg not installed ❎"
        return 0
    else
        check_ok "pkg_query: $pkg "
        return 1
    fi
}

# Function to confirm installation of a package
confirm_installation() {
    local pkg=$1

    echo -e "\n"
    PS3="Select your choice: "
    items=("Install the package: $pkg")

    while true; do
        select item in "${items[@]}" "Continue without installing"; do
            case $REPLY in                                                                       
                1)
                    echo -e "\nFollow the next instructions to $item or CTRL-C to abort."
                    return 0                                                                    
                    ;;                                                                            
                $((${#items[@]}+1)))
                    echo "Exiting installation process."
                    break 2                                                                       
                    ;;                                                                            
                *) 
                    echo "Ooops - unknown choice $REPLY"                                          
                    break;;                                                                          
            esac                                                                                 
        done                                                                                     
    done                                                                                         
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
            #pip3 install --user powerline-status > /dev/null 2>&1 || {
            pip3 install --user powerline-status  || {
                show_message "Failed to install Powerline on RPM-based system."
                return 1 
            }
            ;;
        *)
            echo "Unsupported package type: $PACKAGE_EXT"
            return 1 
            ;;
    esac
    
    check_ok "Powerline installed successfully."
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
    # Call the installation function for Powerline based on the package manager type.
    echo "TODO: install_powerline "
fi 
