data "cloudinit_config" "gateway" {
  gzip = false
  base64_encode = false

  part {
    filename = "init.yml"
    content_type = "text/cloud-config"
    content = <<-CLOUD_CONFIG
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - apt autoremove -y
    CLOUD_CONFIG
  }
}
