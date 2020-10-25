FROM clearlinux:latest
RUN swupd bundle-add sysadmin-basic net-tools vim-minimal sudo
RUN swupd bundle-add openssh-server
RUN swupd bundle-add desktop-autostart vnc-server xfce4-desktop
RUN swupd bundle-add cluster-tools
RUN swupd bundle-add c-basic

# generate ssh keys
RUN ssh-keygen -A