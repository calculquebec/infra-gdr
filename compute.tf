resource "openstack_compute_instance_v2" "apps" {
  name                = "${var.cluster_name}-apps"
  flavor_name         = "p8-15gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu 22.04
  key_pair            = var.key_pair
  security_groups     = [openstack_networking_secgroup_v2.cluster.name]
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
    module.phac.databases
  ]
}

data "openstack_compute_instance_v2" "gateway" {
  id = var.gateway_instance_id
}

data "openstack_networking_floatingip_v2" "gateway" {
  fixed_ip = data.openstack_compute_instance_v2.gateway.access_ip_v4
}

##

resource "openstack_blockstorage_volume_v3" "volumes" {
  for_each    = var.apps
  name        = "${var.cluster_name}-${each.key}-data"
  size        = each.value.volume_size
  volume_type = "volumes-ec"
  region      = "RegionOne"
}

resource "openstack_compute_volume_attach_v2" "attachments" {
  for_each    = var.apps
  instance_id = openstack_compute_instance_v2.apps.id
  volume_id   = openstack_blockstorage_volume_v3.volumes[each.key].id
}

## 

module "phac" {
  source    = "./modules/phac"
  providers = { openstack = openstack }

  cluster_secgroup = openstack_networking_secgroup_v2.cluster
  cluster_name     = var.cluster_name
  key_pair         = var.key_pair
}
