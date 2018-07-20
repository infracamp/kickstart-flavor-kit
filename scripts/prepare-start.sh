#!/bin/bash

set -e
set -o pipefail
trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}


echo "[prepare-start.sh] Running /kickstart/container/prepare-start.sh"
echo -e $COLOR_NC

echo -e $COLOR_LIGHT_CYAN"[prepare-start.sh][DEVELOPMENT MODE] Changing userid of 'user' to $DEV_UID"

usermod -u $DEV_UID user
chown -R user /home/user
export HOME=/home/user

## @todo if DEV_MODE=0 and privileged=0 - disable root access.
echo "user   ALL = (ALL) NOPASSWD:   ALL" >> /etc/sudoers

echo "[prepare-start.sh] File executed successful."

