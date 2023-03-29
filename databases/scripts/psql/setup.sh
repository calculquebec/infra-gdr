#!/bin/bash
export NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y && apt autoremove -y
apt install avahi-daemon postgresql repmgr -y

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

# check if pg_hba is already configured or append replication lines
CIDR_LOCAL_NETWORK=`ip -4 addr show | grep inet | awk '$2 !~ /127.0.0/ {print $2}'`
cat <<  PG_HBA >> ${PG_HBAFILE}
# replication
local   replication   repmgr                              trust
host    replication   repmgr      127.0.0.1/32            trust
host    replication   repmgr      ${CIDR_LOCAL_NETWORK}   trust

local   repmgr        repmgr                              trust
host    repmgr        repmgr      127.0.0.1/32            trust
host    repmgr        repmgr      ${CIDR_LOCAL_NETWORK}   trust
PG_HBA

systemctl restart postgresql
