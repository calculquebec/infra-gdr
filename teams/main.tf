terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = { 
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

module "db" { 
  source = "../databases"
  providers = { openstack = openstack }

  secgroup_name = openstack_networking_secgroup_v2.postgresql.name
}

resource "openstack_compute_instance_v2" "apps" {
  name                = "apps-${var.name}"
  flavor_name         = "p8-15gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu:22.04
  key_pair            = "opsocket"
  security_groups     = ["default", "apps-${var.name}"]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu:22.04
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "32"
    delete_on_termination = true
  }

  depends_on = [
    module.db.primary-db,
    module.db.standby-db
  ]
  
  # user_data = data.cloudinit_config.gateway.rendered
}