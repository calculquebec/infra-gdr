# Backups

Backing up data is a crucial aspect of data management, and it ensures that we can recover important files in case of data loss, hardware failure, or other disasters.

> For that purpose, we use [Restic](https://restic.net) which is a fast and secure backup program that allows you to easily backup and restore files from various sources, including local directories, remote servers, and cloud storage platforms. 

In this section, we will explore how to create data backups, manage multiple backup repositories, and automate backup tasks using [systemd](https://systemd.io). 

We will also cover some best practices for backup storage and security, including encryption and password management. Whether you are a beginner or an experienced user, this documentation will guide you through the process of setting up and maintaining a reliable backup strategy.

## Scheduling

Scheduling backup jobs with [systemd](https://systemd.io) is a convenient and reliable way to automate your backup process. 

> Systemd is a modern system and service manager that is available on most Linux distributions, and it provides a powerful and flexible interface for managing background services and scheduled tasks.

Let's say a volume is mounted on `/media/myconf`, then we could use [restic-systemd](https://gitlab.com/opsocket/restic-systemd) as follows: 

```shell
while read -r line; do export "${line}"; done < /etc/restic/myconf.conf
restic init
```

This will initialize a repository for our volume in our container.

```shell
systemctl enable --now restic@myconf.timer
```

This will perform a secure backup job hourly and keep snapshots for last **7 days**.

```{note}
Overall, using systemd to schedule restic backups is a robust and efficient way to ensure that your data is always backed up and protected.
```

## Databases

```{important}
Secure backups of application databases are taken daily in a secure and reliable manner with a retention policy of **7 days**. 

This protects against potential data loss and enable disaster recovery.
```

In summary, this procedure consists of using `repmgr standby pause`, performing a backup from the paused **standby** server and resuming replication.

```shell
systemctl stop repmgrd
sudo -u postgres /usr/bin/pg_dumpall --clean \
    | gzip --rsyncable \
    | restic backup --host $1 --stdin \
        --stdin-filename postgres-$1.sql.gz
systemctl start repmgrd
``` 

This will stop the **standby** server from replaying the backlog of WAL records from the primary server, allowing us to perform *risks-free* backups and/or other maintenance tasks.

```{tip}
An extra **standby** server would allow a server to be promoted in case of a primary server failure during the backup job. 
```
