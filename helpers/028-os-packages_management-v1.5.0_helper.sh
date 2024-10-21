#!/bin/bash

# Identify operating system as well as the package manager
# Version: 1.06.20.2024, 14h06

# Change Logs
# 19.09.2024 - Rocky Linux added to OS list

# Function to verify the existence of the environment file
function verify_environment_file {
    if [[ -f "$ENVIRONMENT" ]]; then
        #ok "Environment file found."
        return 0
    else
        show_message_with_prefix "Environment file not found!"

        return 1
    fi
}

# Function to update or add a variable in the environment file
function update_environment_variable {
    local var_name="$1"
    local var_value="$2"

    if grep -q "^$var_name=" "$ENVIRONMENT"; then
        sed -i "s/^$var_name=.*/$var_name=$var_value/" "$ENVIRONMENT"
    else
        echo "$var_name=$var_value" >> "$ENVIRONMENT"
    fi
}


function identify_os_and_version() {
# Detect the operating system
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS=$(lsb_release -s -i)
    VER=$(lsb_release -s -r)
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    OS=Debian
    VER=$(cat /etc/debian_version)
else
    OS=$(uname -s)
    VER=$(uname -r)
fi

# Determine the package manager and extension based on the OS detected
case "$OS" in
    debian|ubuntu|linuxmint|parrots)
        PACKAGE_MGR="apt"
        PACKAGE_EXT="deb"
        ;;
    fedora|rhel|centos|rocky)
        if command -v dnf &> /dev/null; then
            PACKAGE_MGR="dnf"
            PACKAGE_EXT="rpm"
        else
            PACKAGE_MGR="yum"
            PACKAGE_EXT="rpm"
        fi
        ;;
    opensuse-leap|opensuse-tumbleweed)
        PACKAGE_MGR="zypper"
        PACKAGE_EXT="rpm"
        ;;
    *)
        PACKAGE_MGR="unknown"
        PACKAGE_EXT="unknown"
        ;;
esac


}


# Verify the environment file
if ! verify_environment_file; then
   return 1  # Exit if the environment file is not found
fi

identify_os_and_version

# Update the environment variables in the environment file

update_environment_variable "OS" "$OS"
update_environment_variable "VER" "$VER"
update_environment_variable "PACKAGE_MGR" "$PACKAGE_MGR"
update_environment_variable "PACKAGE_EXT" "$PACKAGE_EXT"


# Output the identified OS and package manager information
checked " OS/Package manager identified: $OS-$VER/$PACKAGE_EXT"
