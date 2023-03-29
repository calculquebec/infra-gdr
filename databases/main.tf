terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = { 
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

resource "openstack_compute_instance_v2" "primary-db" {
  name                = "psql-db"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "opsocket"
  security_groups     = ["default", "${var.secgroup}"]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  user_data = data.cloudinit_config.primary-db.rendered

}

resource "openstack_compute_instance_v2" "standby-db" {
  name                = "psql-db"
  flavor_name         = "p1-2gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef"
  key_pair            = "opsocket"
  security_groups     = ["default", "${var.secgroup}"]
  force_delete        = true
  stop_before_destroy = true

  depends_on = [
    openstack_compute_instance_v2.primary-db
  ]
  
  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef"
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }
  
  user_data = data.cloudinit_config.standby-db.rendered

}
