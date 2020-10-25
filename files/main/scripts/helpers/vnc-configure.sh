#!/bin/bash

USERNAME={{ workspace.user.name }}
VNC_PASSWORD={{ engines.main.vars.vnc_password }}
VNC_CONFIG_DIR={{ engines.main.orchestrator.container.mounts.engine }}/config/vnc
VNC_SERVICE_CONFIGFILE={{ engines.main.orchestrator.container.mounts.engine }}/config/vnc/vncserver@:1.service
NAUTILUS_DESKTOP_ENTRY={{ engines.main.orchestrator.container.mounts.engine }}/config/gnome/nautilus.desktop

# -- VNC Configuration Script --------------------------------------------------
# Configures user vnc settings for clear linux, and create a systemd service 
# that autostarts. This script is mean to be run as root. The script only creates 
# configurations if no configuration is present; this allows for snappshoting.
#
#     USERNAME       username for new linux user.
#     VNC_PASSWORD   password that should be used for vnc 
#     VNC_CONFIG_DIR location of vnc configuration directory that should be copied to user .vnc directory
#     VNC_SERVICE_CONFIGFILE location of systemd config file        
# ------------------------------------------------------------------------------

# -- copy vnc configuration (if non-existent) ----------------------------------
if [ ! -d "/home/$USERNAME/.vnc" ] ; then
    cp -r $VNC_CONFIG_DIR "/home/$USERNAME/.vnc"
fi
echo -e "$VNC_PASSWORD" | vncpasswd -f > "/home/$USERNAME/.vnc/passwd" # always overwrite password
chown -R $USERNAME "/home/$USERNAME/.vnc"
chmod 0600 "/home/$USERNAME/.vnc/passwd"

# -- gnome vnc does not properly set the default file browser. Create spec file for nautilus, then set defaults using:
# for spec, see: https://specifications.freedesktop.org/desktop-entry-spec/latest/
if [ ! -f "/home/$USERNAME/.config/mimeapps.list" ] ; then
    cp $NAUTILUS_DESKTOP_ENTRY /usr/share/applications
    chmod 644 /usr/share/applications/nautilus.desktop
    runuser -l $USERNAME -c "mkdir -p /home/$USERNAME/.config" # required or xdg-mime command will fail to write file ~/.config/mimeapps.list
    runuser -l $USERNAME -c 'xdg-mime default nautilus.desktop inode/directory'
fi

# -- create vnc service for systemd service, and enable service ---------------
SERVICE_NAME=$(basename $VNC_SERVICE_CONFIGFILE)
mkdir -p /etc/systemd/system
cp "$VNC_SERVICE_CONFIGFILE" "/etc/systemd/system/$SERVICE_NAME"
chmod 644 "/etc/systemd/system/$SERVICE_NAME"
systemctl enable $SERVICE_NAME