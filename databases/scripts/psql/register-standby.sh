#!/bin/bash
# setup backup node for replication
cat << REPMGR_CONFIG > /etc/repmgr.conf
node_id=2
node_name='node2'
conninfo='host=psql-db-2.local user=repmgr dbname=repmgr'
data_directory='/var/lib/postgresql/14/main'
REPMGR_CONFIG
chown postgres:postgres /etc/repmgr.conf

# clone primary database
systemctl stop postgresql
sudo -u postgres repmgr -c -h psql-db-1.local -U repmgr -d repmgr -f /etc/repmgr.conf --force standby clone
systemctl start postgresql

# register standby server
sudo -u postgres repmgr -f /etc/repmgr.conf standby register
sudo -u postgres repmgr -f /etc/repmgr.conf cluster show
