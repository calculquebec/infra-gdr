#!/bin/bash
export NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y && apt autoremove -y
apt install postgresql repmgr -y

PG_CONFIGFILE=`sudo -u postgres psql -tc "SHOW config_file;"`
PG_CONFIGDIR=`dirname ${PG_CONFIGFILE}`
PG_HBAFILE="${PG_CONFIGDIR}/pg_hba.conf"
PG_REPLICA_CONFIG="${PG_CONFIGDIR}/postgresql.replica.conf"

sudo -u postgres touch ${PG_REPLICA_CONFIG}
cat << PG_REPLICA_CONFIG > ${PG_REPLICA_CONFIG}
listen_addresses = '*'
archive_mode = on
archive_command = '/bin/true'
wal_log_hints = on
PG_REPLICA_CONFIG

# check if replica config is already included or append it to postgresql config file
PG_INCLUDE_REPLICA="include '${PG_REPLICA_CONFIG}'"
sudo -u root echo "${PG_INCLUDE_REPLICA}" >> ${PG_CONFIGFILE}

# create user and database
sudo -u postgres createuser -s repmgr
sudo -u postgres createdb repmgr -O repmgr

# retrieve local network cidr
CIDR_LOCAL_NETWORK_24=$(printf "%-24s" `ip -4 addr show | grep inet | awk '$2 !~ /127.0.0/ {print $2}'`)

# declare managed `pg_hba.conf` lines
MANAGED_LINES_ARRAY=(
  "# managed for high availability"
  "local   replication   repmgr                              trust"
  "host    replication   repmgr      127.0.0.1/32            trust"
  "host    replication   repmgr      ${CIDR_LOCAL_NETWORK_24}trust"
  "local   repmgr        repmgr                              trust"
  "host    repmgr        repmgr      127.0.0.1/32            trust"
  "host    repmgr        repmgr      ${CIDR_LOCAL_NETWORK_24}trust"
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
