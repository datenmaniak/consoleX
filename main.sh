#!/bin/bash
#
#	main.sh
#
#  Agregar algunas prestaciones a la consola de comandos
#
#    14.4.2024, 23h31
#
#  Se refactoriza el código de:
#       https://github.com/WojGeek/set-bash-env.git


# TODO: To enable check_NodeJS

# root directory
ROOTDIR=$HOME

if [[ -f $ROOTDIR/consoleX/config.sh ]]; then
    source $ROOTDIR/consoleX/config.sh			# load basic environment
else
    echo -e "Advertencia: config.sh no encontrado. \nLas variables no estarán disponibles."
fi


if [[ -f $ROOTDIR/consoleX/functions_wrapper.sh ]]; then
    source $ROOTDIR/consoleX/functions_wrapper.sh		# load the functions wrapper
else
    echo -e "Advertencia: functions_wrapper.sh no encontrado. \nLas funciones no estarán disponibles."
fi



function main() {

    #if  [  "$prompt_enable" == 'true' ] ; then
    #    customize_shell_prompt
    #fi

    echo 'Happy day!'

}

# let's start the game!
main "$@"
