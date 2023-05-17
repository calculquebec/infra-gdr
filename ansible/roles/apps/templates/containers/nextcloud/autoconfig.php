<?php
$AUTOCONFIG = array(
  "adminlogin"             => "{{ nextcloud.adminuser }}",
  "adminpass"              => "{{ nextcloud.adminpass }}",
  "dbtype"                 => "pgsql",
  "dbname"                 => "{{ nextcloud.dbname }}",
  "dbuser"                 => "{{ nextcloud.dbuser }}",
  "dbpass"                 => "{{ nextcloud.dbpass }}",
  "dbhost"                 => "{{ nextcloud.dbhost }}",
  "dbport"                 => "5432",
  "dbtableprefix"          => "",
  "directory"              => "{{ nextcloud.mount_point }}"
);