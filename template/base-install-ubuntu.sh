#!/bin/bash

set -e
set -o pipefail
trap 'on_error $LINENO' ERR;
PROGNAME=$(basename $0)

function on_error () {
    echo "Error: ${PROGNAME} on line $1" 1>&2
    exit 1
}


export DEBIAN_FRONTEND=noninteractive
apt-get update


# Bug in Ubuntu18.04. You have to install tzdata standalone first!
apt-get install -y --no-install-recommends tzdata
apt-get install -y php7.2-cli curl zip composer vim nano git curl sudo whois bash-completion pwgen netcat

# (whois: offers mkpasswd command)