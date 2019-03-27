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
chown user:root /opt


## Remove secure_path (otherwise $PATH will be resetted with each sudo call)
echo "`cat /etc/sudoers | grep -v "secure_path"`" > /etc/sudoers


cat <<\EOF >> /home/user/.bashrc
##
## Added from kickstart-flavor-kit build.sh (user-section):
##
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export GIT_EDITOR=vim
export PATH="$PATH:/home/user/.composer/vendor/bin"

export PS1="\u@\[$(tput sgr0)\]\[\033[38;5;42m\]$DEV_CONTAINER_NAME\[$(tput sgr0)\]\[\033[38;5;8m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;21m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;8m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

## Change Dir to /opt
cd /opt

envtoset=`kick kick_to_env`
## Evaluate and replace $PATH in envtoset
eval envtoset_parsed="\"$envtoset\""
export $envtoset_parsed
EOF

cat <<\EOF >> /root/.bashrc
##
## Added from kickstart-flavor-kit build.sh (root-section):
##
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export GIT_EDITOR=vim
export PATH="$PATH:/root/.composer/vendor/bin"

export PS1="\u@\[$(tput sgr0)\]\[\033[38;5;42m\]$DEV_CONTAINER_NAME\[$(tput sgr0)\]\[\033[38;5;8m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;21m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;8m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

## Change Dir to /opt
cd /opt

envtoset=`kick kick_to_env`
## Evaluate and replace $PATH in envtoset
eval envtoset_parsed="\"$envtoset\""
export $envtoset_parsed
EOF

echo "[build.sh] Finished without errors"



