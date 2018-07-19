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
ln -s /kickstart/src/bin/kick /usr/bin/kick
composer install -d /kickstart/src


useradd -s /bin/bash --create-home user
# Add user to admin group
gpasswd -a user adm

# Set Color Prompt
PROMPT='export PROMPT_COMMAND='\''if [ `whoami` != "root" ] ;  then echo -ne "\e[0m\e[95m${DEV_TTYID}\e[0m`whoami`@\e[1;33m${DEV_CONTAINER_NAME}:\e[0m${PWD}$ "; else echo -ne "\e[101m\e[95m${DEV_TTYID}`whoami`@\e[1;33m${DEV_CONTAINER_NAME}:\e[0m${PWD}$ "; fi;'\'' '
echo $PROMPT >> /root/.bashrc
echo 'export PS1=""' >> /root/.bashrc

echo $PROMPT >> /home/user/.bashrc
echo 'export PS1=""' >> /home/user/.bashrc
echo "cd /opt" >> /home/user/.bashrc

chown user:root /opt




if [[ ! -e /root/flavor/flavor-build.sh ]]
then
    echo "Error: Missing flavor-build.sh in /root/flavor/"
    exit 1
fi;

## This file is used by start.sh - but check if it exists on build time here
if [[ ! -e /root/flavor/flavor-build.sh ]]
then
    echo "Error: Missing flavor-start.sh in /root/flavor/"
    exit 1
fi;

echo "Running: /kickstart/container/flavor-build.sh"
. /root/flavor/flavor-build.sh



