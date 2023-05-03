#!/bin/bash
export NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y && apt autoremove -y
apt install postgresql repmgr -y

PG_CONFIGFILE=`sudo -u postgres psql -tc "SHOW config_file;"`
PG_CONFIGDIR=`dirname ${PG_CONFIGFILE}`
PG_HBAFILE="${PG_CONFIGDIR}/pg_hba.conf"
PG_REPLICA_CONFIG="${PG_CONFIGDIR}/conf.d/pg_replica.conf"

LOCAL_NETWORK_IPV4=`ip -4 addr show | grep inet | awk '$2 !~ /127.0.0/ {print $2}' | cut -d'/' -f1`

sudo -u postgres cat << PG_REPLICA_CONFIG > ${PG_REPLICA_CONFIG}
listen_addresses = '${LOCAL_NETWORK_IPV4}'
archive_mode = on
archive_command = '/bin/true'
wal_log_hints = on
PG_REPLICA_CONFIG

# create user and database
sudo -u postgres createuser -s repmgr
sudo -u postgres createdb repmgr -O repmgr

# declare managed `pg_hba.conf` lines
MANAGED_LINES_ARRAY=(
  # Allow ssl connections to replication and repmgr databases for the repmgr user 
  # connecting from a device on the same local network using password
  "hostssl replication,repmgr repmgr ${LOCAL_NETWORK_IPV4}/24 scram-sha-256"

  # these should be set and depends on variables 
  # "hostssl nextcloud nextcloud_user ${APPS_INSTANCE_IPV4}/32 scram-sha-256"
  # "hostssl mattermost mattermost_user ${APPS_INSTANCE_IPV4}/32 scram-sha-256"
)

# compute MANAGED_LINES variable
unset MANAGED_LINES
for LINE in "${MANAGED_LINES_ARRAY[@]}"; do MANAGED_LINES+="$LINE\n"; done

# check if required lines exist in PG_HBAFILE
if ! grep -Fxq "${MANAGED_LINES}" "$PG_HBAFILE"; then
  # if required lines do not exist, add them
  echo -e "\n${MANAGED_LINES}" >> "$PG_HBAFILE"
  echo "-- required lines written to $PG_HBAFILE"
else
  echo "-- required lines already exist in $PG_HBAFILE"
fi

systemctl restart postgresql
