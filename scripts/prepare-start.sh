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

# Writing files

if [ "$FILE_USER_GITCONFIG" != "" ]
then
    echo "$FILE_USER_GITCONFIG" > /home/user/.gitconfig
fi;


mkdir -p /home/user/.ssh
if [ "$FILE_USER_SSH_ID_RSA" != "" ]
then
    if [ -f /home/user/.ssh/id_rsa ]
    then
        echo "Cannot send /home/user/.ssh/id_rsa: File already existing."
        exit 3
    fi;
    echo "$FILE_USER_SSH_ID_RSA" > /home/user/.ssh/id_rsa
fi;

if [ "$FILE_USER_SSH_ID_ED25519" != "" ]
then
    if [ -f /home/user/.ssh/id_ed25519 ]
    then
        echo "Cannot send /home/user/.ssh/id_ed25519: File already existing."
        exit 3
    fi;
    echo "$FILE_USER_SSH_ID_ED25519" > /home/user/.ssh/id_ed25519
fi;
chmod -R 700 /home/user/.ssh

echo -e $COLOR_LIGHT_CYAN"[prepare-start.sh][DEVELOPMENT MODE] Changing userid of 'user' to $DEV_UID"

usermod -u $DEV_UID user
chown -R user /home/user
export HOME=/home/user

## @todo if DEV_MODE=0 and privileged=0 - disable root access.
echo "user   ALL = (ALL) NOPASSWD:   ALL" >> /etc/sudoers

echo "[prepare-start.sh] File executed successful."

