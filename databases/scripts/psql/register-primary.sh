#!/bin/bash
# setup primary node for replication
cat << REPMGR_CONFIG > /etc/repmgr.conf
node_id=1
node_name='node1'
conninfo='host=psql-db-1.local user=repmgr dbname=repmgr'
data_directory='/var/lib/postgresql/14/main'
REPMGR_CONFIG

chown postgres:postgres /etc/repmgr.conf

# once configured we can register the primary node
sudo -u postgres repmgr -f /etc/repmgr.conf primary register
sudo -u postgres repmgr -f /etc/repmgr.conf cluster show