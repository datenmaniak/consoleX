#!/bin/bash

# functions_wrapper.sh



# for warning before complete loading
source $HELPERS/010-messages-1.0.0_helper.sh

#source ./helpers.sh  # Cargar el archivo de helpers

for helper in $HELPERS/*_helper.sh; do
    # uncomment to debug
    #echo -e "file: $helper"
    check_ok $helper
   
    source "$helper"
	
done
