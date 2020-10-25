#! /bin/bash

# ==============================================================================
# Starting script for cluster worker node
# ==============================================================================

MAIN_ENGINE_DIR={{ engines.main.orchestrator.container.mounts.engine }}

$MAIN_ENGINE_DIR/scripts/helpers/os-configure.sh
$MAIN_ENGINE_DIR/scripts/helpers/user-create.sh
$MAIN_ENGINE_DIR/scripts/helpers/sshd-configure.sh

exec /sbin/init