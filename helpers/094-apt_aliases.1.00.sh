#!/bin/bash

# 9.9.2024, Willians Patiño

# Alias minimalistas para apt

alias aptupd='sudo apt update'            # Actualizar la lista de paquetes
alias aptupg='sudo apt upgrade'           # Actualizar paquetes instalados
alias aptfup='sudo apt full-upgrade'      # Actualización completa del sistema
alias aptint='sudo apt install "$@" '           # Instalar un paquete
alias aptrem='sudo apt remove "$@" '           # Eliminar un paquete
alias aptare='sudo apt autoremove'       # Limpiar paquetes no utilizados
alias aptsea='apt search "$@" '              # Buscar un paquete
alias aptinf='apt show'                 # Mostrar información de un paquete
alias aptlst='apt list --installed'      # Listar paquetes instalados
alias aptcle='sudo apt clean'            # Limpiar caché de paquetes

