#!/bin/bash

# -- Ocean Environment Script ----------------------------------------------------
# sets two global environment variables for all users
#   OCEAN_HOSTS : comma separated list of all host in pool
#   OCEAN_WORKERS: comma separated list of all workers in pool
#   OCEAN_MAIN: hostname of main node
# ------------------------------------------------------------------------------

OCEAN_WORKERS={% for worker in engines.main.deployment.nodes.workers %}{{ worker.hostname }}{% unless forloop.last %},{% endunless %}{% endfor %}
OCEAN_HOSTS={{engines.main.deployment.nodes.main.hostname}}{% for worker in engines.main.deployment.nodes.workers %},{{ worker.hostname }}{% endfor %}
OCEAN_HEAD={{engines.main.deployment.nodes.main.hostname}}

mkdir -p /etc/profile.d
echo "OCEAN_HOSTS=$OCEAN_HOSTS" > /etc/profile.d/ocean_hosts.sh
echo "OCEAN_WORKERS=$OCEAN_WORKERS" > /etc/profile.d/ocean_workers.sh
echo "OCEAN_HEAD=$OCEAN_HEAD" > /etc/profile.d/ocean_head.sh