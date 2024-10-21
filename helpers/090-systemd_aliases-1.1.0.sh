# Función de ayuda
helpsystemd() {
    echo "Comandos disponibles:"
    echo "  sstart [servicio]  - Inicia el/los servicio(s) especificado(s)."
    echo "  sstop [servicio]   - Detiene el/los servicio(s) especificado(s)."
    echo "  srest [servicio]   - Reinicia el/los servicio(s) especificado(s)."
    echo "  sstat [servicio]   - Muestra el estado del/los servicio(s) especificado(s)."
    echo "  senab [servicio]   - Habilita el/los servicio(s) especificado(s)."
    echo "  sdisb [servicio]   - Deshabilita el/los servicio(s) especificado(s)."
    echo "  srelo [servicio]   - Recarga el/los servicio(s) especificado(s)."
    echo "  sluni               - Lista todas las unidades."
    echo "  sdrlo               - Recarga el daemon de systemd."
}

# Iniciar servicios
sstart() { 
    echo "Iniciando servicio(s): $@"
    sudo systemctl start "$@"; 
}

# Detener servicios
sstop() { 
    echo "Deteniendo servicio(s): $@"
    sudo systemctl stop "$@"; 
}

# Reiniciar servicios
srest() { 
    echo "Reiniciando servicio(s): $@"
    sudo systemctl restart "$@"; 
}

# Ver estado de servicios
sstat() { 
    echo "Verificando estado de servicio(s): $@"
    sudo systemctl status "$@"; 
}

# Habilitar servicios
senab() { 
    echo "Habilitando servicio(s): $@"
    sudo systemctl enable "$@"; 
}

# Deshabilitar servicios
sdisb() { 
    echo "Deshabilitando servicio(s): $@"
    sudo systemctl disable "$@"; 
}

# Recargar servicios
srelo() { 
    echo "Recargando servicio(s): $@"
    sudo systemctl reload "$@"; 
}

# Listar unidades
sluni() { 
    echo "Listando unidades..."
    sudo systemctl list-units "$@"; 
}

# Recargar el daemon de systemd
sdrlo() { 
    echo "Recargando el daemon de systemd..."
    sudo systemctl daemon-reload "$@"; 
}

# Llamar a la función de ayuda si no se pasan argumentos
#if [ "$#" -eq 0 ]; then
#    helpsystemd
#fi

check_ok "Systemd aliases -  (helpsystemd)"
