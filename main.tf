terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = { 
      source  = "terraform-provider-openstack/openstack"
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

  # user_data = data.cloudinit_config.gateway.rendered
}

module "teams" {
  source = "./teams"
  providers = { openstack = openstack }
  
  for_each = {
    1 = { name = "epistemopratique" }
    2 = { name = "otherteam" }
  }

  number = each.key
  name = each.value.name
  gateway = openstack_compute_instance_v2.gateway
}


# data "cloudinit_config" "gateway" {
#   gzip          = false
#   base64_encode = false

#   part {
#     content_type = "text/cloud-config"
#     content = jsonencode({
#       write_files = [
#         {
#           content = file("cloud_init/apps/containers/gitlab.yml")
#           path = "/opt/gitlab.yml"
#         }
#       ]
#     })
#   }

#   part {
#     filename     = "gateway.sh"
#     content_type = "text/x-shellscript"
#     content = file("gateway.sh")
#   }

#   # define our instance cloud-init config script
#   part {
#     filename     = "instance.yaml"
#     content_type = "text/cloud-config"
#     content = file("cloud_init/apps/init-instance.yml")
#   }
# }

# module "teams" { source = "./teams" }