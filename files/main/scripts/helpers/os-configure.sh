#!/bin/bash

# -- Configuration for Clear Linux ---------------------------------------------
# ------------------------------------------------------------------------------

# disable autoupdate to preserve container reproducability
systemctl mask swupd-update.service #equivalent to swupd autoupdate --disable