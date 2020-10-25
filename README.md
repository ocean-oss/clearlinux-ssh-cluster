# An SSH cluster running on Clear Linux

This app starts an Clear linux cluster (or single node) where passwordless communication is enabled accross all hosts.

### Cluster access

You can access the head node in any of the following ways:
- Terminal Access: ssh (including x forwarding)
- Virtual desktop (tigervnc)
- File Transfer: sftp 

### Ocean environment variables

1. `OCEAN_HOSTS` contains a comma separated list of the hostnames for all the nodes in the pool.
2. `OCEAN_WORKERS` contains a comma separated list of the hostnames for all worker nodes in the pool.
3. `OCEAN_HEAD` contains the hostnames of the head node.

For example, to execute the command `hostname` on all nodes you can run
```console
pdsh -w $OCEAN_HOSTS hostname
```