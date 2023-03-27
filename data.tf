data "cloudinit_config" "gateway" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.yml"
    content_type = "text/cloud-config"
    content      = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - apt autoremove -y
    EOF
  }
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
