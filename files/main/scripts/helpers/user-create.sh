#!/bin/bash

export USER_ID={{ workspace.user.uid }}
export GROUP_ID={{ workspace.user.gid }}
export USER_NAME={{ workspace.user.name }}
export GRANT_SUDO=TRUE

# -- USER CREATE SCRIPT -------------------------------------------------------
# Adds a non root user and enables sudo permissions for entrypoint usermod 
# script. The script responds to the following environmental variables:
#
#     USER_ID         ID for new linux user
#     GROUP_ID        Group ID for new linux user
#     USER_NAME       username for new linux user
#     USER_PASSWORD   password for new linux user
#     GRANT_SUDO      if "TRUE" then new linux user will have sudo privilages
#                     usermod script "/opt/build-scripts/usermod.sh"
# ------------------------------------------------------------------------------

# -- exit if user already exists -----------------------------------------------
if id "$USER_NAME" >/dev/null 2>&1; then
    exit;    
fi

# -- Add User-------------------------------------------------------------------
if [ -z "$USER_ID" ] || [ -z "$GROUP_ID" ] ; then
    useradd -m -l -s /bin/bash $USER_NAME
else
    groupadd -o --gid $GROUP_ID $USER_NAME
    useradd -m -l -o -s /bin/bash --uid $USER_ID --gid $GROUP_ID $USER_NAME
    # -- chown home directory --------------------------------------------------
    chown $USER_ID:$GROUP_ID /home/$USER_NAME # ocean currenly creates home directory via bind mount, therefore it is owned by root
fi

# -- Set User Password ---------------------------------------------------------
if [ -n "$USER_PASSWORD" ] ; then
    echo -e "$USER_PASSWORD\n$USER_PASSWORD" | passwd $USER_NAME
fi 

# -- Grant sudo ----------------------------------------------------------------
if [ "$GRANT_SUDO" = "TRUE" ] ; then
    if [ -n "$USER_PASSWORD" ] ; then
        (usermod -aG wheel $USER_NAME)
    else
        (usermod -aG wheelnopw $USER_NAME)
    fi
    # fix output error for rootless containers: See https://github.com/sudo-project/sudo/issues/42
    echo "Set disable_coredump false" >> /etc/sudo.conf # should be removed once sudo > v1.8.31
fi