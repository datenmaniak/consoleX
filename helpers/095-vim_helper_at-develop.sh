#!/bin/bash

#
#  Todo lo que relaciona  instalar el editor Vi,
#   Habilitar funciones y componentes 
#           21.04.2024,  23h29


enable_vimrc() {

    if [ -f ~/.vimrc ]; then
        echo -e " - .vimrc: OK"
    else
        if [ -f $APPDIR/rc/vimrc ]; then
            
            ln -s $APPDIR/rc/vimrc ~/.vimrc
            echo -e " - Linked .vimrc: done"
        else
            echo -e " - .vimrc: not found!"
        fi
    fi

}

# install neovim as editor
package_name="neovim"
command_exists $package_name
if [ $? -eq 0 ] || [  "$installed" ]
   then
    #install_command "neovim"
    echo " - Pendiente chequeo de paquetes, status:  $installed"

fi

#enable_vimrc






