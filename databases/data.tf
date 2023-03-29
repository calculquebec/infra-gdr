data "cloudinit_config" "primary-db" {
  gzip          = false
  base64_encode = false

  part {
    filename = "setup.sh"
    content_type = "text/x-shellscript"
    content = file("databases/scripts/psql/setup.sh")
  }


  part {
    filename = "register-primary.sh"
    content_type = "text/x-shellscript"
    content = file("databases/scripts/psql/register-primary.sh")
  }
}

data "cloudinit_config" "standby-db" {
  gzip          = false
  base64_encode = false

  part {
    filename = "setup.sh"
    content_type = "text/x-shellscript"
    content = file("databases/scripts/psql/setup.sh")
  }

  part {
    filename = "register-standby.sh"
    content_type = "text/x-shellscript"
    content = file("databases/scripts/psql/register-standby.sh")
  }
}
