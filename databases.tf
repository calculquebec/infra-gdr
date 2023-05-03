data "cloudinit_config" "primary_db" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "setup.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/external/databases/setup.sh")
  }

  part {
    filename     = "register-primary.sh"
    content_type = "text/x-shellscript"
    content      = <<-REGISTER_PRIMARY
      #!/usr/bin/env bash
      cat << REPMGR_CONFIG > /etc/repmgr.conf
      node_id=1
      node_name='node1'
      conninfo='host=`hostname`.local user=repmgr dbname=repmgr'
      data_directory='/var/lib/postgresql/14/main'
      REPMGR_CONFIG
      chown postgres. /etc/repmgr.conf
      sudo -u postgres repmgr primary register
    REGISTER_PRIMARY
  }
}

resource "openstack_compute_instance_v2" "primary_db" {
  name                = "${var.ENVIRONMENT_NAME}-psql-1"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "opsocket"
  security_groups     = ["default", openstack_networking_secgroup_v2.databases.name]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  depends_on = [
    openstack_networking_secgroup_v2.databases
  ]

  user_data = data.cloudinit_config.primary_db.rendered
}

data "cloudinit_config" "standby_db" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "setup.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.module}/external/databases/setup.sh")
  }

  part {
    filename     = "register-standby.sh"
    content_type = "text/x-shellscript"
    content      = <<-REGISTER_PRIMARY
      #!/bin/bash
      # setup backup node for replication
      cat << REPMGR_CONFIG > /etc/repmgr.conf
      node_id=2
      node_name='node2'
      conninfo='host=`hostname`.local user=repmgr dbname=repmgr'
      data_directory='/var/lib/postgresql/14/main'
      REPMGR_CONFIG

      chown postgres. /etc/repmgr.conf

      # clone primary database
      systemctl stop postgresql
      sudo -u postgres repmgr -h psql-1.local -U repmgr -d repmgr --force standby clone
      systemctl start postgresql

      # register standby server
      sudo -u postgres repmgr standby register
    REGISTER_PRIMARY
  }
}

resource "openstack_compute_instance_v2" "standby_db" {
  name                = "${var.ENVIRONMENT_NAME}-psql-2"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "opsocket"
  security_groups     = ["default", openstack_networking_secgroup_v2.databases.name]
  force_delete        = true
  stop_before_destroy = true

  depends_on = [
    openstack_compute_instance_v2.primary_db,
    openstack_networking_secgroup_v2.databases
  ]

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  user_data = data.cloudinit_config.standby_db.rendered

}
