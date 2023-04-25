resource "openstack_compute_instance_v2" "apps" {
  name                = "${var.name}-apps"
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
    openstack_compute_instance_v2.primary-db,
    openstack_compute_instance_v2.standby-db
  ]
  
  # user_data = data.cloudinit_config.gateway.rendered
}