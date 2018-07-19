#!/bin/bash

set -e
set -o pipefail
trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}


echo "[entry.sh] Running /kickstart/container/prepare-start.sh"
echo -e $COLOR_NC

echo "[entry.sh] + kick kick_to_env"
envtoset=`kick kick_to_env`
echo $envtoset
export $envtoset;

if [ "$KICK_PRESET" != "" ]
then
    echo "[entry.sh] Loading preset $KICK_PRESET";
    presetFile="/root/flavor/presets/$KICK_PRESET.sh"
    if [ ! -e $presetFile ]
    then
        echo "Error: Preset $KICK_PRESET (selected in .kick.yml - preset): File not found: $presetFile";
        exit 1;
    fi
    . $presetFile
fi


. /root/flavor/flavor-prepare-start.sh


echo -e $COLOR_LIGHT_CYAN"[entry.sh][DEVELOPMENT MODE] Changing userid of 'user' to $DEV_UID"

usermod -u $DEV_UID user
chown -R user /home/user
export HOME=/home/user

## @todo if DEV_MODE=0 and privileged=0 - disable root access.
echo "user   ALL = (ALL) NOPASSWD:   ALL" >> /etc/sudoers

