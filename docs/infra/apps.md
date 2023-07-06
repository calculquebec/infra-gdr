# Applications

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Mattermost

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

https://github.com/mattermost/docs/blob/master/source/install/installing-mattermost-omnibus.rst

> Minimum system requirements:
> 
>   - Hardware: 1 vCPU/core with 2GB RAM (support for up to 1,000 users)
>   - Database: PostgreSQL v11+
>   - Network ports required:
>     - Application ports 80/443, TLS, TCP Inbound
>     - Administrator Console port 8065, TLS, TCP Inbound
>     - SMTP port 10025, TCP/UDP Outbound

## Nextcloud

Nextcloud is a powerful and flexible self-hosted cloud storage and collaboration platform that can be used to provide gated services for research groups. These allow controlled access to data and resources within a research group, ensuring the security and privacy of sensitive information.

### Features and Benefits

- **Secure and Private Storage**: Nextcloud offers end-to-end encryption, ensuring that data remains secure and private.
- **User Management**: Nextcloud provides robust user management capabilities, allowing to control access to data and resources based on user roles and permissions.
- **Collaboration Tools**: Explore a wide range of collaboration features, such as file sharing, document editing, and shared calendars, enabling seamless collaboration within a research group.
- **Integration with Research Workflows**: Integrate with various research tools and services, facilitating data sharing, analysis, and collaboration within a research workflow.
- **Gated Services**: The access control feature allows gated access for specific research projects or resources. Only authorized users will have access to these, ensuring data privacy and security.

### Updates

By default, Nextcloud is configured to use the [updatedirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#updatedirectory) setting for storing update files. However, if the [updatedirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#updatedirectory) is not explicitly set, Nextcloud falls back to using the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory) for updates. 

#### Handling Full Data Partition

In such situation, when the data partition where the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory) is located becomes full, it can lead to issues when performing updates.

The update process requires free space to download and extract update packages, and a full data partition can prevent the update from completing successfully.

To avoid such issues, it is recommended to set the [updatedirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#updatedirectory) explicitly to a separate location that has sufficient free space, independent of the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory).

```php
'updatedirectory' => '/var/lib/nextcloud-updates',
```

```{important}
Make sure the specified [updatedirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#updatedirectory) exists and is writable by the web server (i.e. `www-data`) user so that Nextcloud can store the update packages in that location.
```

By specifying a dedicated directory for update files, we ensure that updates can be performed even if the data partition is full.

### Logging

All log information are written to a separate log file.

By default, this file is named `nextcloud.log` and will be created in the directory which has been configured by the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory) parameter in `config/config.php`.

#### Preventing accessibility issues to files

In certain scenarios, it is advisable to configure the `logfile` key to an absolute location on a separate partition from the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory). 

A quite standard location is `/var/log/nextcloud.log`.

Since the `www-data` user does not have write access within the `/var/log` directory, we need to create the file as follows

```shell
sudo touch /var/log/nextcloud.log
sudo chown www-data. /var/log/nextcloud.log
```

Then we can configure the `logfile` key within `config/config.php`

```php
'logfile' => '/var/log/nextcloud.log',
```

This configuration can help prevent accessibility issues with the **files** app, which logs accesses to the `logfile` whenever directories or files are read within the [datadirectory](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#datadirectory).
