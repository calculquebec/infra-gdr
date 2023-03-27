resource "openstack_compute_instance_v2" "primary-db" {
  name                = "psql-db"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "gateway"
  security_groups     = ["default"]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  # user_data = (
  #   count.index == 1 
  #   ? data.cloudinit_config.psql-primary.rendered 
  #   : data.cloudinit_config.psql-standby.rendered
  # )

  # user_data = data.cloudinit_config.primary-db.rendered

}

resource "openstack_compute_instance_v2" "backup-db" {
  name                = "psql-db"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "gateway"
  security_groups     = ["default"]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  # user_data = (
  #   count.index == 1 
  #   ? data.cloudinit_config.psql-primary.rendered 
  #   : data.cloudinit_config.psql-standby.rendered
  # )
  
  # user_data = data.cloudinit_config.backup-db.rendered

  depends_on = [
    openstack_compute_instance_v2.primary-db
  ]
}