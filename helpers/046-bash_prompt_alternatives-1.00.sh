#!/bin/bash

# Función para instalar y configurar Powerline
install_powerline() {
  echo "Instalando Powerline..."
  pip install powerline-shell --user

  # Agregar configuración a.bashrc
  echo "Configurando Powerline en.bashrc..."
  cat <<EOF >> ~/.bashrc
function _update_ps1() {
  PS1=\$(powerline-shell \$?)
  if [[ \$TERM!= linux &&! \$PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; \$PROMPT_COMMAND"
  fi
}
_update_ps1
EOF

  # Forzar la recarga de.bashrc
  source ~/.bashrc
  echo "Powerline instalado y configurado."
}

# Función para instalar y configurar Starship
install_starship() {
  echo "Instalando Starship..."
  curl -sS https://starship.rs/install.sh | sh

  # Agregar configuración a.bashrc
  echo "Configurando Starship en.bashrc..."
  cat <<EOF >> ~/.bashrc
eval "\$(starship init bash)"
EOF

  # Forzar la recarga de.bashrc
  source ~/.bashrc
  echo "Starship instalado y configurado."
}

# Función para mostrar menú de selección
show_menu() {
  echo "Seleccione un prompt:"
  echo "1. Powerline"
  echo "2. Starship"
  read -p "Opción: " option

  case $option in
    1)
      install_powerline
      ;;
    2)
      install_starship
      ;;
    *)
      echo "Opción inválida. Saliendo..."
      exit 1
      ;;
  esac
}

# Verificar si el usuario quiere instalar un prompt
if [ "$1" == "install" ]; then
  show_menu
else
  echo "Uso: $0 install"
  exit 1
fi
