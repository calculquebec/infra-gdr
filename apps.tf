data "cloudinit_config" "apps" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "setup.sh"
    content_type = "text/x-shellscript"
    content      = <<-PART_CONTENT
      #!/usr/bin/env bash
      apt update && apt upgrade -y && apt autoremove -y

    PART_CONTENT
  }

  # part {
  #   filename     = "check_reboot.sh"
  #   content_type = "text/x-shellscript"
  #   content      = <<-PART_CONTENT
  #     #!/usr/bin/env bash
  #     test -f /var/run/reboot-required && sudo reboot now
  #   PART_CONTENT
  # }
}

resource "openstack_compute_instance_v2" "apps" {
  name                = "${var.ENVIRONMENT_NAME}-apps"
  flavor_name         = "p8-15gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu 22.04
  key_pair            = "opsocket"
  security_groups     = ["default", openstack_networking_secgroup_v2.apps.name]
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
    openstack_compute_instance_v2.primary_db,
    openstack_compute_instance_v2.standby_db,
  ]

  user_data = data.cloudinit_config.apps.rendered
}
