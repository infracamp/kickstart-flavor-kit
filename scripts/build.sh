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
export PATH="/opt/bin:/home/user/.composer/vendor/bin:/opt/node_modules/.bin:$PATH"

. /kickstart/flavorkit/scripts/select-console.sh default

## Change Dir to /opt
cd /opt

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

. /kickstart/flavorkit/scripts/select-console.sh default_root
## Change Dir to /opt
cd /opt

EOF


echo "[build.sh] Finished without errors"



