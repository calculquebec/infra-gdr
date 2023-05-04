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

  part {
    filename     = "check_reboot.sh"
    content_type = "text/x-shellscript"
    content      = <<-PART_CONTENT
      #!/usr/bin/env bash
      test -f /var/run/reboot-required && sudo reboot now
    PART_CONTENT
  }
}

resource "openstack_compute_instance_v2" "apps" {
  name                = "${var.ENVIRONMENT_NAME}-apps"
  flavor_name         = "p8-15gb"
  image_name          = "db73980e-1f9c-441e-8268-c1881f99c8ef" # ubuntu 22.04
  key_pair            = var.key_pair
  security_groups     = [openstack_networking_secgroup_v2.apps.name]
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
    module.phac[0].databases,
    module.phac[1].databases
  ]

  # user_data = data.cloudinit_config.apps.rendered

}

# resource "null_resource" "provision_apps" {
#   triggers = { on_apply = timestamp() }
#   connection {
#     type         = "ssh"
#     proxy_host   = var.proxy_host
#     proxy_port   = var.proxy_port
#     user         = "ubuntu"
#     host         = openstack_compute_instance_v2.apps.access_ip_v4
#     private_key  = file(var.SSH_PRIVATE_KEY_FILE)
#     timeout      = "1m"
#   }
#   provisioner "remote-exec" {
#     on_failure = continue
#     inline = [
#       "echo hello from `hostname`"
#     ]
#   }
# }


# @TODO: single primary and many standbys for many apps instead of per-app pha clusters
module "phac" {
  source    = "./modules/phac"
  providers = { openstack = openstack }
  count     = 2

  client_ip_v4          = openstack_compute_instance_v2.apps.access_ip_v4
  db_name_prefix        = "${var.ENVIRONMENT_NAME}-phac-${count.index}"
  key_pair              = var.key_pair
}

variable "ansible_inventory_file" {
  type = string
  default = "ansible/inventory.ini"
}

# resource "null_resource" "generate_ansible_hosts" {
#   provisioner "local-exec" {
#     command = <<-GENERATE_ANSIBLE_HOSTS
#       echo '${openstack_compute_instance_v2.apps.name} ansible_host=${openstack_compute_instance_v2.apps.access_ip_v4} ansible_port' >> ${var.ansible_inventory_file}
#       cat << ANSIBLE_HOSTS > ansible/inventory.ini

#       ANSIBLE_HOSTS
#     GENERATE_ANSIBLE_HOSTS
#   }
# }
