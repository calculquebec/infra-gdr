resource "openstack_compute_instance_v2" "databases" {
  name                = "${var.db_name_prefix}-db-${count.index}"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = var.key_pair
  security_groups     = [openstack_networking_secgroup_v2.databases.name]
  force_delete        = true
  stop_before_destroy = true
  count = 3

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  depends_on = [
    openstack_compute_instance_v2.databases[0], # repmgr primary database
    openstack_networking_secgroup_v2.databases
  ]

  # user_data = count.index == 1 ? data.cloudinit_config.primary-db.rendered : data.cloudinit_config.standby-db.rendered
}

output "databases" { 
  value = openstack_compute_instance_v2.databases 
}
