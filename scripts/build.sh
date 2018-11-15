#!/bin/bash


## set -e: Stop on error
set -e
set -o pipefail
trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}

####################################################################
## Execute after .dockerfile-build.sh
####################################################################

echo "Linking kick..."
ln -s /kickstart/flavorkit/lib/kicker/bin/kick /usr/bin/kick
composer install -d /kickstart/flavorkit/lib/kicker


useradd -s /bin/bash --create-home user
# Add user to admin group
gpasswd -a user adm

# Set Color Prompt
#PROMPT='export PROMPT_COMMAND='\''if [ `whoami` != "root" ] ;  then echo -ne "\e[0m\e[95m${DEV_TTYID}\e[0m`whoami`@\e[1;33m${DEV_CONTAINER_NAME}:\e[0m${PWD}$ "; else echo -ne "\e[101m\e[95m${DEV_TTYID}`whoami`@\e[1;33m${DEV_CONTAINER_NAME}:\e[0m${PWD}$ "; fi;'\'' '
##echo $PROMPT >> /root/.bashrc
echo 'export PS1="\u@\[$(tput sgr0)\]\[\033[38;5;42m\]$DEV_CONTAINER_NAME\[$(tput sgr0)\]\[\033[38;5;8m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;21m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;8m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"' >> /root/.bashrc
echo '' >> /root/.bashrc

#echo $PROMPT >> /home/user/.bashrc
#echo 'export PS1=""' >> /home/user/.bashrc
echo 'export PS1="\u@\[$(tput sgr0)\]\[\033[38;5;42m\]$DEV_CONTAINER_NAME\[$(tput sgr0)\]\[\033[38;5;8m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;21m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;8m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"' >> /home/user/.bashrc

echo "cd /opt" >> /home/user/.bashrc

chown user:root /opt


echo "[build.sh] Finished without errors"



