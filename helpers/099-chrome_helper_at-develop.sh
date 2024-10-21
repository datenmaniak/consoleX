#!/bin/bash


doyouwish_chrome() {

pkg="google-chrome-stable"

     
   if ! command -v $pkg &> /dev/null 
   then 
    
        if [ "$install_googlechrome" == 'true' ] 
        then
            echo "- Install Google Chrome "
            
            confirm_installation $pkg
            if [ $? -eq 1 ] ; then
                # Accepted
                install_package $pkg
            else 
               sed -i 's/install_googlechrome\=\"true\"/install_googlechrome\=\"false\"/g' $ENVIRONMENT
            fi
        fi
    
    fi

    if [ "$install_googlechrome" == 'false' ] && [ ! command -v $pkg &> /dev/null ]
    then 
       echo -e "- To install Google Chrome, run: install_chrome"
    fi
}

install_chrome() {
    detect_os
    echo $OS_DERIVATES
    if [ "$OS_DERIVATES" == 'deb' ] ; then
            install_chrome_for_deb
        
    elif [ "$OS_DERIVATES" == 'rpm' ] ; then
         echo "es RPM"
            
            # source /usr/share/powerline/bash/powerline.sh
            # prompt_enable="true"
    else 
         echo " - Check package installer for this platform: $1"
        #  prompt_enable="false"
    fi
}

install_chrome_for_deb() {

    FILE="/etc/apt/sources.list.d/google-chrome.list"


    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo touch $FILE
    sudo echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"  > $FILE 
    sudo apt update
    sudo apt install google-chrome-stable
}


#TODO: 
install_chrome_for_rpm() {
    echo 'PENDIENTE'
}
