#!/bin/bash

export SSHD_CONFIG={{ engines.main.orchestrator.container.mounts.engine }}/config/ssh/sshd_config
export SSHD_SERVICE_OVERRIDE={{ engines.main.orchestrator.container.mounts.engine }}/config/ssh/override.conf

# -- USER CREATE SCRIPT -------------------------------------------------------
# Configures sshd for the user, and enables the service to autostart. The 
# script responds to the following environmental variables:
#
#     SSHD_SERVICE_OVERRIDE     Overridden settings for sshd service
#     SSHD_CONFIG               Desired SSHD configuration file
# ------------------------------------------------------------------------------

# set sshd_config file
if [ ! -f /etc/ssh/sshd_config ] ; then
    cp $SSHD_CONFIG /etc/ssh/sshd_config
fi

# select port for sshd -- override systemd service settings (https://docs.01.org/clearlinux/latest/guides/network/openssh-server.html)
mkdir -p /etc/systemd/system/sshd.socket.d/
cp $SSHD_SERVICE_OVERRIDE /etc/systemd/system/sshd.socket.d/override.conf

systemctl enable sshd.service