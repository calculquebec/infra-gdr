terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" { cloud = var.cloud }

# create a floating ip for the nginx instance
resource "openstack_networking_floatingip_v2" "gateway" {
  pool = "public"
}

resource "openstack_compute_instance_v2" "gateway" {
  name                = "gateway"
  flavor_name         = "p4-7.5gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu:22.04
  key_pair            = "opsocket"
  security_groups     = ["default", "gateway"]
  force_delete        = true
  stop_before_destroy = true

  block_device {
    uuid                  = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu:22.04
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = "16"
    delete_on_termination = true
  }

  user_data = data.cloudinit_config.gateway.rendered

  depends_on = [

  ]
}

module "teams" {
  source    = "./teams"
  providers = { openstack = openstack }
  for_each  = { for idx, name in var.teams : idx => name }

  gateway = openstack_compute_instance_v2.gateway

  name   = each.value
  number = each.key
}
