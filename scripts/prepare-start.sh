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

echo -e $COLOR_LIGHT_CYAN"[prepare-start.sh] Changing userid of 'user' to $DEV_UID"




usermod -u $DEV_UID user
chown -R user /home/user
export HOME=/home/user

if [[ "$DEV_MODE" = "1" ]]
then
    echo "Enabling apt / composer caching..."
    mkdir -p /mnt/.kick_cache/root/apt
    mkdir -p /mnt/.kick_cache/user/.cache
    mkdir -p /mnt/.kick_cache/user/.composer
    chown -R user /mnt/.kick_cache/user

    rm -R /var/cache/apt
    ln -s /mnt/.kick_cache/root/apt /var/cache/apt
    ln -s /mnt/.kick_cache/user/.cache /home/user/.cache

    ln -s /mnt/.kick_cache/user/.composer /home/user/.composer

    rm /etc/apt/apt.conf.d/docker-clean
fi;

## @todo if DEV_MODE=0 and privileged=0 - disable root access.
echo "user   ALL = (ALL) NOPASSWD:   ALL" >> /etc/sudoers

echo "[prepare-start.sh] File executed successful."

