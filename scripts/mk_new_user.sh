#!/usr/bin/env bash

# Defaults to creating a new homedir + setting bash as default shell.

# Does _NOT_ assign to sudo group. Do that manually.

# Must be run by a user with permissions to create users.
# Likely easiest by just sudo'ing the invocation.

function showhelp {
    echo "Usage: ./mk_new_user.sh <username>"
}

if [[ -z "$1" ]]; then
    echo "You must provide a username to create. Aborting."
    showhelp
    exit 1
fi

getent passwd $1 > /dev/null

if [[ "$?" -eq 0 ]]; then
    echo "User '$1' already exists. Aborting."
    exit 1
fi

# Create user
useradd -s /bin/bash -m $1
# Define default pw of 'changempls' so sshd allows connections. Passwordless accounts may not have ssh.
sudo bash -c "echo -e 'changemepls\nchangemepls' | passwd $1"

sudo -u $1 bash -c \
    "mkdir /home/$1/.ssh && \
    chmod 700 /home/$1/.ssh"
